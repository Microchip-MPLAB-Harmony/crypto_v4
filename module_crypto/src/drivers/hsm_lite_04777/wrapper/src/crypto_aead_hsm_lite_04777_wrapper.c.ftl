/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_aead_hsm_lite_04777_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for HSM_LITE/CAM hardware AES.

  Description:
    This source file contains the wrapper interface to access the AEAD
    algorithms in the HSM_LITE/CAM AES hardware driver for Microchip microcontrollers.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) ${.now?string("yyyy")}, Microchip Technology Inc., and its subsidiaries. All rights reserved.

The software and documentation is provided by microchip and its contributors
"as is" and any express, implied or statutory warranties, including, but not
limited to, the implied warranties of merchantability, fitness for a particular
purpose and non-infringement of third party intellectual property rights are
disclaimed to the fullest extent permitted by law. In no event shall microchip
or its contributors be liable for any direct, indirect, incidental, special,
exemplary, or consequential damages (including, but not limited to, procurement
of substitute goods or services; loss of use, data, or profits; or business
interruption) however caused and on any theory of liability, whether in contract,
strict liability, or tort (including negligence or otherwise) arising in any way
out of the use of the software and documentation, even if advised of the
possibility of such damage.

Except as expressly permitted hereunder and subject to the applicable license terms
for any third-party software incorporated in the software and any applicable open
source software license terms, no license or other rights, whether express or
implied, are granted under any patent or other intellectual property rights of
Microchip or any third party.
*/
//DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include <string.h>
#include "crypto/drivers/wrapper/crypto_aead_hsm_lite_04777_wrapper.h"
#include "crypto/drivers/wrapper/crypto_hsm_lite_04777_wrapper.h"
#include "crypto/drivers/library/cam_aes.h"

<#if (CRYPTO_HW_AES_CCM?? && (CRYPTO_HW_AES_CCM == true))>
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************
#define AAD_PRESENT_FLAG    (1U << 6)   // Indicates that AAD is present in the data set.
#define AES_CCM_HEADER_SIZE (22UL)      // The size of the AES CCM data header.
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

/**
 * @brief Initialize the CAM library's AES interrupt handler.
 */
static void lCrypto_Aead_Hw_Aes_InterruptSetup(void)
{
    (void)Crypto_Int_Hw_Register_Engine_Handler(CRYPTO_HSM_ENGINE_AES, DRV_CRYPTO_AES_IsrHelper);
    Crypto_Int_Hw_SelectEngine(CRYPTO_HSM_ENGINE_AES);
    (void)Crypto_Int_Hw_Enable(CRYPTO_HSM_INT);
}

/**
 * @brief Gets the AES operation type based on the cipher operation.
 *
 * @param cipherOpType The type of cipher operation (encrypt or decrypt).
 * @param operation Pointer to the variable where the operation type will be stored.
 *
 * @return @ref crypto_Aead_Status_E Status of the operation.
 *         @retval CRYPTO_AEAD_CIPHER_SUCCESS on success.
 *         @retval CRYPTO_AEAD_ERROR_CIPOPER if the operation type is invalid.
 */
static crypto_Aead_Status_E lCrypto_Aead_Hw_Aes_GetOperation
    (crypto_CipherOper_E cipherOpType, AESCON_OPERATION* operation)
{
    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPOPER;

    switch (cipherOpType)
    {
        case CRYPTO_CIOP_ENCRYPT:
            *operation = OP_ENCRYPT;
            status = CRYPTO_AEAD_CIPHER_SUCCESS;
            break;
        case CRYPTO_CIOP_DECRYPT:
            *operation = OP_DECRYPT;
            status = CRYPTO_AEAD_CIPHER_SUCCESS;
            break;
        default:
            status = CRYPTO_AEAD_ERROR_CIPOPER;
            break;
    }

    return status;
}

/**
 * @brief Calculates the number of padding bytes required for AES.
 *
 * @param dataLen The length of the data to be padded.
 *
 * @return @ref uint32_t The number of padding bytes needed to align the data to the AES block size.
 */
static uint32_t lCrypto_Aead_Hw_Aes_GetPadBytes(uint32_t dataLen)
{
    uint32_t mask = (AES_BLOCK_SIZE - 1UL);
    uint32_t pad = ((dataLen + mask) & ~mask) - dataLen;

    return pad;
}

/**
 * @brief Compares two byte arrays for equality.
 *
 * @param cmp1 Pointer to the first byte array.
 * @param cmp2 Pointer to the second byte array.
 * @param cmpLen The length of the byte arrays to compare.
 *
 * @return @ref uint32_t 0 if the arrays are equal, 1 if they are different.
 */
static uint32_t lCrypto_Aead_Hw_CompareAsBytes(uint8_t *cmp1, uint8_t *cmp2, uint32_t cmpLen)
{
    register uint8_t* c1 = cmp1;
    register uint8_t* c2 = cmp2;
    register int32_t len = (int32_t)cmpLen;
    uint32_t result = 0UL;

    while (len > 0L)
    {
        if (*c1 != *c2)
        {
            result = 1UL;
            break;
        }
        else
        {
            len--;
            c1++;
            c2++;
        }
    }

    return result;
}

<#if (CRYPTO_HW_AES_CCM?? && (CRYPTO_HW_AES_CCM == true))>

/**
 * @brief Builds the header for the AES CCM (Counter with CBC-MAC) encryption scheme.
 *
 * This function constructs the header for the AES CCM mode of operation as defined in
 * RFC 1310, paragraph 2.2. The header includes flags, nonce, data length, and
 * additional authentication data (AAD) length if present.
 *
 * @param[out] header Pointer to the buffer where the constructed header will be stored.
 * @param[out] headerLen Pointer to a variable that will hold the length of the constructed header.
 * @param[in] nonce Pointer to the nonce (number used once) to be included in the header.
 * @param[in] nonceLen Length of the nonce in bytes.
 * @param[in] aadLen Length of the additional authentication data in bytes.
 * @param[in] dataLen Length of the data to be encrypted, in bytes (up to 7 bytes).
 * @param[in] authTagLen Length of the authentication tag in bytes.
 *
 * @note The function assumes that the header buffer is large enough to hold the constructed header.
 *       The header format includes flags, nonce, data length, and AAD length as specified in the RFC.
 *       The function sets the appropriate flags based on the provided parameters.
 */
static void lCrypto_Aead_Hw_BuildCcmHeader(uint8_t *header, uint32_t *headerLen,
    uint8_t *nonce, uint32_t nonceLen,
    uint32_t aadLen, uint64_t dataLen, uint32_t authTagLen)
{
    // The format of this header is defined in RFC 1310, paragraph 2.2.
    uint8_t *localHeader = header;
    uint8_t *localNonce = nonce;
    uint8_t flags = 0U;
    uint8_t tagSize = ((uint8_t)authTagLen - 2U) / 2U;
    uint8_t lengthSize = (0x0FU - (uint8_t)nonceLen);

    // Encode the auth tag length and nonce length.
    flags |= (tagSize & 0x07U) << 3U;
    flags |= (lengthSize - 1U) & 0x7U;

    // If there is AAD data, set the flag at bit 6.
    if (aadLen > 0UL)
    {
        flags |= AAD_PRESENT_FLAG;
    }

    // Add the flags as the first byte.
    *localHeader = flags; localHeader++;

    // Add the nonce starting at the second byte.
    for (uint8_t i = 0U; i < nonceLen; i++)
    {
        *localHeader = *localNonce;
        localHeader++;
        localNonce++;
    }

    // Add the data length.  dataLen is 64 bits since this size can be up to 7 bytes.
    for (int8_t i = ((lengthSize - 1U) * 8U); i >= 0; i -= 8)
    {
        uint64_t m = (0xFFULL << (uint64_t)i);
        uint64_t b = (dataLen & m);

        *localHeader = (b >> (uint64_t)i); localHeader++;
    }

    // Encode additional authentication data length if present.
    localHeader = &header[16];
    if (aadLen > 0U)
    {
        if (aadLen < 0xFF00UL)
        {
            *localHeader = (aadLen & 0x0000FF00UL) >> 8; localHeader++;
            *localHeader = (aadLen & 0x000000FFUL); localHeader++;
        }
        else
        {
            *localHeader = 0xFF; localHeader++;
            *localHeader = 0xFE; localHeader++;
            *localHeader = (aadLen & 0xFF000000UL) >> 24; localHeader++;
            *localHeader = (aadLen & 0x00FF0000UL) >> 16; localHeader++;
            *localHeader = (aadLen & 0x0000FF00UL) >> 8; localHeader++;
            *localHeader = (aadLen & 0x000000FFUL); localHeader++;
        }
    }

/* MISRA C:2012 Rule 18.4 deviation:
 * Reason: The expression (localHeader - header) involves pointer subtraction.
 * This violates Rule 18.4, which restricts pointer arithmetic to pointers that
 * refer to elements of the same array object. In this context, 'header' is a pointer
 * to a statically allocated buffer, and 'localHeader' is incremented only within the
 * bounds of that buffer. The subtraction is used to determine the number of bytes
 * written to the buffer. This usage is safe, well-defined, and does not result in
 * out-of-bounds access.
 * Deviation approved: Yes ?  No ?  (Mark as appropriate per your project process)
 */
 /* cppcheck-suppress misra-c2012-18.4 */
    *headerLen = (localHeader - header);
}

</#if><#-- CRYPTO_HW_AES_CCM -->
// *****************************************************************************
// *****************************************************************************
// Section: AEAD Algorithms Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

<#if (CRYPTO_HW_AES_GCM?? && (CRYPTO_HW_AES_GCM == true))>
crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Init(void *aeadInitCtx,
    crypto_CipherOper_E cipherOper_en, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect, uint32_t initVectLen)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to the AEAD context defined by the
    *         CAM Hardware Driver pre-compiled library is required since
    *         the library does not have access to the upper context structures
    *         defined by the Crypto APIs.
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_AEAD_HW_CONTEXT *aeadCtx = (CRYPTO_AEAD_HW_CONTEXT*) aeadInitCtx;
    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_INITIALIZE_ERROR;

    AESCON_MODE mode = MODE_GCM;
    AESCON_OPERATION operation;

    status = lCrypto_Aead_Hw_Aes_GetOperation(cipherOper_en, &operation);

    if (status == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        // Context data must be cleared as the context may be on a stack versus static memory.
        (void)memset(aeadCtx->contextData, 0, sizeof(aeadCtx->contextData));

        aesStatus = DRV_CRYPTO_AES_Initialize(aeadCtx, mode, operation, key, keyLen, initVect, initVectLen);
    }

    if(aesStatus == AES_NO_ERROR)
    {
        lCrypto_Aead_Hw_Aes_InterruptSetup();
    }
    else
    {
        status = CRYPTO_AEAD_ERROR_CIPFAIL;
    }

    return status;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_AddAadData(void *aeadCipherCtx,
    uint8_t *aad, uint32_t aadLen)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to the AEAD context defined by the
    *         CAM Hardware Driver pre-compiled library is required since
    *         the library does not have access to the upper context structures
    *         defined by the Crypto APIs.
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_AEAD_HW_CONTEXT *aeadCtx = (CRYPTO_AEAD_HW_CONTEXT*) aeadCipherCtx;
    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPFAIL;
    AES_ERROR aesStatus;
    AES_ERROR aesActive;

    aesStatus = DRV_CRYPTO_AES_IsActive(aeadCtx->contextData, &aesActive);
    if ((aesStatus == AES_NO_ERROR) && (aesActive == AES_OPERATION_IS_ACTIVE))
    {
        if (aadLen > 0UL)
        {
            aesStatus = DRV_CRYPTO_AES_AddHeader(aeadCtx->contextData, aad, aadLen);
            if(aesStatus == AES_NO_ERROR)
            {
                /* AES-GCM hardware includes the authentication data in its output.  This data needs to be
                 * discarded from the output stream.  The data is padded to a block size. */
                uint32_t pad = lCrypto_Aead_Hw_Aes_GetPadBytes(aadLen);

                aesStatus = DRV_CRYPTO_AES_DiscardData(aeadCtx->contextData, (aadLen + pad));
            }

            if(aesStatus == AES_NO_ERROR)
            {
                status = CRYPTO_AEAD_CIPHER_SUCCESS;
            }
        }
        else
        {
            // Empty AAD data is allowed.
            status = CRYPTO_AEAD_CIPHER_SUCCESS;
        }
}

    return status;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Cipher(void *aeadCipherCtx,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to the AEAD context defined by the
    *         CAM Hardware Driver pre-compiled library is required since
    *         the library does not have access to the upper context structures
    *         defined by the Crypto APIs.
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_AEAD_HW_CONTEXT *aeadCtx = (CRYPTO_AEAD_HW_CONTEXT*) aeadCipherCtx;
    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPFAIL;
    AES_ERROR aesStatus;
    AES_ERROR aesActive;

    aesStatus = DRV_CRYPTO_AES_IsActive(aeadCtx->contextData, &aesActive);
    if ((aesStatus == AES_NO_ERROR) && (aesActive == AES_OPERATION_IS_ACTIVE))
    {
        /* AES GCM cipher/decipher accepts the actual number of bytes, and the library will
         * automatically pad to a block size and configure the descriptor to ignore the pad bytes.*/
        aesStatus = DRV_CRYPTO_AES_AddInputData(aeadCtx->contextData, inputData, dataLen);
        if(aesStatus == AES_NO_ERROR)
        {
            aesStatus = DRV_CRYPTO_AES_AddOutputData(aeadCtx->contextData, outData, dataLen);
        }

        if((aesStatus == AES_NO_ERROR) && (dataLen > 0UL))
        {
            /* AES-GCM hardware operates on block size boundaries.  When data size is not aligned to
             * a block size boundary, the excess must be discarded from the output stream.
             * When data is not specified, this is skipped. */
            uint32_t pad = lCrypto_Aead_Hw_Aes_GetPadBytes(dataLen);

            aesStatus = DRV_CRYPTO_AES_DiscardData(aeadCtx->contextData, pad);
        }

        if(aesStatus == AES_NO_ERROR)
        {
            status = CRYPTO_AEAD_CIPHER_SUCCESS;
        }
    }

    return status;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Final(void *aeadFinalCtx,
    uint8_t *authTag, uint32_t authTagLen)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to the AEAD context defined by the
    *         CAM Hardware Driver pre-compiled library is required since
    *         the library does not have access to the upper context structures
    *         defined by the Crypto APIs.
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_AEAD_HW_CONTEXT *aeadCtx = (CRYPTO_AEAD_HW_CONTEXT*) aeadFinalCtx;
    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPFAIL;
    AES_ERROR aesStatus;
    AES_ERROR aesActive;

    aesStatus = DRV_CRYPTO_AES_IsActive(aeadCtx->contextData, &aesActive);
    if ((aesStatus == AES_NO_ERROR) && (aesActive == AES_OPERATION_IS_ACTIVE))
    {
        aesStatus = DRV_CRYPTO_AES_AddOutputData(aeadCtx->contextData, authTag, authTagLen);
        if(aesStatus == AES_NO_ERROR)
        {
            aesStatus = DRV_CRYPTO_AES_AddLenALenC(aeadCtx->contextData);
        }

        if(aesStatus == AES_NO_ERROR)
        {
            aesStatus = DRV_CRYPTO_AES_Execute(aeadCtx->contextData);
        }

        if(aesStatus == AES_NO_ERROR)
        {
            status = CRYPTO_AEAD_CIPHER_SUCCESS;
        }
    }

    return status;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_EncryptAuthDirect(uint8_t *inputData,
    uint32_t dataLen, uint8_t *outData, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect, uint32_t initVectLen, uint8_t *aad, uint32_t aadLen,
    uint8_t *authTag, uint32_t authTagLen)
{
    CRYPTO_AEAD_HW_CONTEXT aeadCtx;
    crypto_Aead_Status_E result;

    result = Crypto_Aead_Hw_AesGcm_Init(&aeadCtx, CRYPTO_CIOP_ENCRYPT, key, keyLen, initVect, initVectLen);
    if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        result = Crypto_Aead_Hw_AesGcm_AddAadData(&aeadCtx, aad, aadLen);
    }

    if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        result = Crypto_Aead_Hw_AesGcm_Cipher(&aeadCtx, inputData, dataLen, outData);
    }

    if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        result = Crypto_Aead_Hw_AesGcm_Final(&aeadCtx, authTag, authTagLen);
    }

    return result;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_DecryptAuthDirect(uint8_t *inputData,
    uint32_t dataLen, uint8_t *outData, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect, uint32_t initVectLen, uint8_t *aad, uint32_t aadLen,
    uint8_t *authTag, uint32_t authTagLen)
{
    CRYPTO_AEAD_HW_CONTEXT aeadCtx;
    crypto_Aead_Status_E result;

    result = Crypto_Aead_Hw_AesGcm_Init(&aeadCtx, CRYPTO_CIOP_DECRYPT, key, keyLen, initVect, initVectLen);
    if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        result = Crypto_Aead_Hw_AesGcm_AddAadData(&aeadCtx, aad, aadLen);
    }

    if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        result = Crypto_Aead_Hw_AesGcm_Cipher(&aeadCtx, inputData, dataLen, outData);
    }

    if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        uint8_t generatedAuthTag[AES_GCM_AUTHTAG_SIZE];

        result = Crypto_Aead_Hw_AesGcm_Final(&aeadCtx, generatedAuthTag, authTagLen);

        if (result == CRYPTO_AEAD_CIPHER_SUCCESS)
        {
            // The tag must be verified against what was calculated.
            if (0UL != lCrypto_Aead_Hw_CompareAsBytes(generatedAuthTag, authTag, authTagLen))
            {
                result = CRYPTO_AEAD_ERROR_AUTHFAIL;
            }
        }
    }

    return result;
}
</#if><#-- CRYPTO_HW_AES_GCM -->

<#if (CRYPTO_HW_AES_CCM?? && (CRYPTO_HW_AES_CCM == true))>
crypto_Aead_Status_E Crypto_Aead_Hw_AesCcm_Init(void *aeadInitCtx,
    uint8_t *key, uint32_t keyLen)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to CRYPTO_AEAD_HW_CONTEXT* is necessary to access
    * context-specific members. The input pointer is guaranteed by design to point
    * to a valid CRYPTO_AEAD_HW_CONTEXT instance. This is safe and controlled.
    * Deviation approved: Yes ?  No ?
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_AEAD_HW_CONTEXT *aeadCtx = (CRYPTO_AEAD_HW_CONTEXT*) aeadInitCtx;
    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_INITIALIZE_ERROR;

    AESCON_MODE mode = MODE_CCM;

    // Context data must be cleared as the context may be on a stack versus static memory.
    (void)memset(aeadCtx->contextData, 0, sizeof(aeadCtx->contextData));

    /* CCM does not use an initialization vector, instead using a nonce provided during the call to cipher.
     * The 'operation' is dummied as OP_ENCRYPT as it will be overwritten by the 'DRV_Crypto_AES_SetOperation'
     * call in the cipher step. */
    aesStatus = DRV_CRYPTO_AES_Initialize(aeadCtx, mode, OP_ENCRYPT, key, keyLen, NULL, 0UL);
    if(aesStatus == AES_NO_ERROR)
    {
        lCrypto_Aead_Hw_Aes_InterruptSetup();
        status = CRYPTO_AEAD_CIPHER_SUCCESS;
    }

    return status;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesCcm_Cipher(void *aeadCipherCtx,
    crypto_CipherOper_E cipherOper_en,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData,
    uint8_t *nonce, uint32_t nonceLen, uint8_t *aad, uint32_t aadLen,
    uint8_t *authTag, uint32_t authTagLen)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to CRYPTO_AEAD_HW_CONTEXT* is necessary to access
    * context-specific members. The input pointer is guaranteed by design to point
    * to a valid CRYPTO_AEAD_HW_CONTEXT instance. This is safe and controlled.
    * Deviation approved: Yes ?  No ?
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_AEAD_HW_CONTEXT *aeadCtx = (CRYPTO_AEAD_HW_CONTEXT*) aeadCipherCtx;

    crypto_Aead_Status_E status = CRYPTO_AEAD_ERROR_CIPFAIL;
    AESCON_OPERATION operation;

    if(lCrypto_Aead_Hw_Aes_GetOperation(cipherOper_en, &operation) == CRYPTO_AEAD_CIPHER_SUCCESS)
    {
        AES_ERROR aesStatus;
        AES_ERROR aesActive;

        aesStatus = DRV_CRYPTO_AES_IsActive(aeadCtx->contextData, &aesActive);
        if ((aesStatus == AES_NO_ERROR) && (aesActive == AES_OPERATION_IS_ACTIVE))
        {
            uint8_t generatedAuthTag[AES_CCM_AUTHTAG_SIZE];

            aesStatus = DRV_CRYPTO_AES_SetOperation(aeadCtx->contextData, operation);
            if(aesStatus == AES_NO_ERROR)
            {
                uint8_t headerData[AES_CCM_HEADER_SIZE];
                uint32_t headerLen;

                // Build the CCM header.
                lCrypto_Aead_Hw_BuildCcmHeader(headerData, &headerLen, nonce, nonceLen, aadLen, dataLen, authTagLen);

                // The CCM header data is inserted without alignment or padding.
                aesStatus = DRV_CRYPTO_AES_AddRawHeader(aeadCtx->contextData, headerData, headerLen, AES_HEADER_DO_NOT_ALIGN);
                if (aesStatus == AES_NO_ERROR)
                {
                    if (aadLen > 0UL)
                    {
                        // AAD is inserted without padding, but with alignment.
                        aesStatus = DRV_CRYPTO_AES_AddRawHeader(aeadCtx->contextData, aad, aadLen, AES_HEADER_ALIGN);
                    }

                    if (aesStatus == AES_NO_ERROR)
                    {
                        /* The header + AAD is "the header" (even though it is in two pieces), and has a size.
                         * This may not align to a block size, so the hardware will pad automatically.
                         * The pad must be marked as 'ignore'. */
                        uint32_t pad = lCrypto_Aead_Hw_Aes_GetPadBytes(headerLen + aadLen);
                        aesStatus = DRV_CRYPTO_AES_IgnoreData(aeadCtx->contextData, pad);
                    }

                    if (aesStatus == AES_NO_ERROR)
                    {
                        /* AES hardware includes (header + authentication) data in its output.  This data needs to be
                         * discarded from the output stream.  The data to discard is padded to a block size. */
                        uint32_t pad = lCrypto_Aead_Hw_Aes_GetPadBytes(headerLen + aadLen);

                        aesStatus = DRV_CRYPTO_AES_DiscardData(aeadCtx->contextData, (headerLen + aadLen + pad));
                    }
                }
            }

            // Add the input plaintext.
            if (aesStatus == AES_NO_ERROR)
            {
                /* AES hardware operates on block size boundaries.  When input data size is not aligned to
                 * a block size, the input must be padded to a block size and the pad 'ignored'.  The
                 * driver call performs this padding. */
                aesStatus = DRV_CRYPTO_AES_AddInputData(aeadCtx->contextData, inputData, dataLen);
            }

            // Add the output ciphertext buffer.
            if (aesStatus == AES_NO_ERROR)
            {
                aesStatus = DRV_CRYPTO_AES_AddOutputData(aeadCtx->contextData, outData, dataLen);
            }

            if ((aesStatus == AES_NO_ERROR) && (dataLen > 0UL))
            {
                /* AES hardware operates on block size boundaries.  When output data size is not aligned to
                 * a block size boundary, the excess must be discarded from the output stream.
                 * When data is not specified, this is skipped. */
                uint32_t pad = lCrypto_Aead_Hw_Aes_GetPadBytes(dataLen);
                aesStatus = DRV_CRYPTO_AES_DiscardData(aeadCtx->contextData, pad);
            }

            if (aesStatus == AES_NO_ERROR)
            {
                // Add the authtag output buffer.
                uint8_t *tagPtr = (operation == OP_ENCRYPT) ? authTag : generatedAuthTag;
                aesStatus = DRV_CRYPTO_AES_AddOutputData(aeadCtx->contextData, tagPtr, authTagLen);

                if(aesStatus == AES_NO_ERROR)
                {
                    /* AES hardware operates on block size boundaries.  When output data size is not aligned to
                     * a block size boundary, the excess must be discarded from the output stream. */
                    uint32_t pad = lCrypto_Aead_Hw_Aes_GetPadBytes(authTagLen);
                    aesStatus = DRV_CRYPTO_AES_DiscardData(aeadCtx->contextData, pad);
                }
            }

            /* On decryption, add the authtag as an input.  The tag is needed as part of the decryption data.
             * It will also be generated as an output for comparison. */
            if ((aesStatus == AES_NO_ERROR) && (operation == OP_DECRYPT))
            {
                /* AES hardware operates on block size boundaries.  When input data size is not aligned to
                 * a block size, the input must be padded to a block size and the pad 'ignored'.  The
                 * driver call performs this padding. */
                aesStatus = DRV_CRYPTO_AES_AddInputData(aeadCtx->contextData, authTag, authTagLen);
            }

            if (aesStatus == AES_NO_ERROR)
            {
                aesStatus = DRV_CRYPTO_AES_Execute(aeadCtx->contextData);
            }

            if (aesStatus == AES_NO_ERROR)
            {
                // On decryption, the tag must be verified against what was calculated.
                if (operation == OP_DECRYPT)
                {
                    if (0UL != lCrypto_Aead_Hw_CompareAsBytes(generatedAuthTag, authTag, authTagLen))
                    {
                        status = CRYPTO_AEAD_CIPHER_SUCCESS;
                    }
                }
                else
                {
                    status = CRYPTO_AEAD_CIPHER_SUCCESS;
                }
            }
        }
    }

    return status;
}
</#if><#-- CRYPTO_HW_AES_CCM -->
