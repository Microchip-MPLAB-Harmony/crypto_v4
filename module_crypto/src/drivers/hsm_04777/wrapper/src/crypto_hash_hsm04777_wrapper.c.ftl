/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hash_hsm04777_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware SHA.

  Description:
    This source file contains the wrapper interface to access the SHA
    hardware driver for Microchip microcontrollers.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) 2025, Microchip Technology Inc., and its subsidiaries. All rights reserved.

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
#include "../crypto_hash_hsm04777_wrapper.h"
#include "../../library/cam_hash.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

/**
 * @brief Get the SHA algorithm mode based on the specified algorithm.
 *
 * This function maps the provided SHA algorithm enumeration to the corresponding
 * hardware mode used by the SHA driver.
 *
 * @param shaAlgorithm The SHA algorithm enumeration.
 * @param mode Pointer to the variable where the corresponding mode will be stored.
 * @return @ref crypto_Hash_Status_E Status of the operation, indicating success or failure.
 * @retval CRYPTO_HASH_SUCCESS The operation was successful.
 * @retval CRYPTO_HASH_ERROR_FAIL The operation failed.
 * @retval CRYPTO_HASH_ERROR_ALGO The specified algorithm is not supported.
 */

static crypto_Hash_Status_E lCrypto_Hash_Hw_Sha_GetAlgorithm(crypto_Hash_Algo_E shaAlgorithm,
        HASHCON_MODE* mode)
{
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;

    switch(shaAlgorithm)
    {
        case CRYPTO_HASH_SHA1:
            *mode = MODE_SHA1;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_224:
            *mode = MODE_SHA224;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_256:
            *mode = MODE_SHA256;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_384:
            *mode = MODE_SHA384;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_512:
            *mode = MODE_SHA512;
            status = CRYPTO_HASH_SUCCESS;
            break;
        default:
            status = CRYPTO_HASH_ERROR_ALGO;
            break;
    }

    return status;
}

/**
 * @brief Get the digest length for the specified SHA algorithm.
 *
 * This function retrieves the expected output length of the hash digest
 * for the given SHA algorithm.
 *
 * @param shaAlgorithm The SHA algorithm enumeration.
 * @param digestLength Pointer to the variable where the digest length will be stored.
 * @return @ref crypto_Hash_Status_E Status of the operation, indicating success or failure.
 * @retval CRYPTO_HASH_SUCCESS The operation was successful.
 * @retval CRYPTO_HASH_ERROR_FAIL The operation failed.
 */

static crypto_Hash_Status_E lCrypto_Hash_Hw_Sha_GetDigestLength(crypto_Hash_Algo_E shaAlgorithm, uint32_t *digestLength)
{
    crypto_Hash_Status_E status = CRYPTO_HASH_SUCCESS;

    switch(shaAlgorithm)
    {
        case CRYPTO_HASH_SHA1:
            *digestLength = 20;
            break;
        case CRYPTO_HASH_SHA2_224:
            *digestLength = 28;
            break;
        case CRYPTO_HASH_SHA2_256:
            *digestLength = 32;
            break;
        case CRYPTO_HASH_SHA2_384:
            *digestLength = 48;
            break;
        case CRYPTO_HASH_SHA2_512:
            *digestLength = 64;
            break;
        default:
            *digestLength = 0;
            status = CRYPTO_HASH_ERROR_FAIL;
            break;
    }

    return status;
}

// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *shaInitCtx,
        crypto_Hash_Algo_E shaAlgorithm)
{
    
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to CRYPTO_HASH_HW_CONTEXT* is necessary to access
    * context-specific members. The input pointer is guaranteed by design to point
    * to a valid CRYPTO_HASH_HW_CONTEXT instance. This is safe and controlled.
    * Deviation approved: Yes ☐  No ☐
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*) shaInitCtx;
    HASHCON_MODE mode;
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    HASH_ERROR hashStatus = HASH_INITIALIZE_ERROR;

    status = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm, &mode);

    if (status == CRYPTO_HASH_SUCCESS)
    {
        shaCtx->algorithm = shaAlgorithm;
        (void)memset(shaCtx->contextData, 0, sizeof(shaCtx->contextData));
        hashStatus = DRV_CRYPTO_HASH_Initialize(shaCtx->contextData, mode);
    }

    if (hashStatus != HASH_NO_ERROR)
    {
        status = CRYPTO_HASH_ERROR_FAIL;
    }

    return status;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *shaUpdateCtx,
    uint8_t *data, uint32_t dataLen)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to CRYPTO_HASH_HW_CONTEXT* is necessary to access
    * context-specific members. The input pointer is guaranteed by design to point
    * to a valid CRYPTO_HASH_HW_CONTEXT instance. This is safe and controlled.
    * Deviation approved: Yes ☐  No ☐
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*) shaUpdateCtx;
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    HASH_ERROR hashStatus;
    HASH_ERROR hashActive;

    hashStatus = DRV_CRYPTO_HASH_IsActive(shaCtx->contextData, &hashActive);
    if ((hashStatus == HASH_NO_ERROR) && (hashActive == HASH_OPERATION_IS_ACTIVE))
    {
        hashStatus = DRV_CRYPTO_HASH_Update(shaCtx->contextData, data, dataLen);

        if (hashStatus == HASH_NO_ERROR)
        {
            status = CRYPTO_HASH_SUCCESS;
        }
    }

    return status;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *shaFinalCtx,
    uint8_t *digest)
{
    /* MISRA C:2012 Rule 11.5 deviation:
    * Reason: Conversion from void* to CRYPTO_HASH_HW_CONTEXT* is necessary to access
    * context-specific members. The input pointer is guaranteed by design to point
    * to a valid CRYPTO_HASH_HW_CONTEXT instance. This is safe and controlled.
    * Deviation approved: Yes ☐  No ☐
    */
    /* cppcheck-suppress misra-c2012-11.5 */
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*) shaFinalCtx;
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    HASH_ERROR hashStatus;
    HASH_ERROR hashActive;

    hashStatus = DRV_CRYPTO_HASH_IsActive(shaCtx->contextData, &hashActive);
    if ((hashStatus == HASH_NO_ERROR) && (hashActive == HASH_OPERATION_IS_ACTIVE))
    {
        uint32_t digestLen;

        switch(shaCtx->algorithm)
        {
            case CRYPTO_HASH_SHA1:
                digestLen = 20;
                break;
            case CRYPTO_HASH_SHA2_224:
                digestLen = 28;
                break;
            case CRYPTO_HASH_SHA2_256:
                digestLen = 32;
                break;
            case CRYPTO_HASH_SHA2_384:
                digestLen = 48;
                break;
            case CRYPTO_HASH_SHA2_512:
                digestLen = 64;
                break;
            default:
                digestLen = 0;
                hashStatus = HASH_READ_ERROR;
                break;
        }

        if (hashStatus == HASH_NO_ERROR)
        {
            hashStatus = DRV_CRYPTO_HASH_Final(shaCtx->contextData, digest, digestLen);
            if (hashStatus == HASH_NO_ERROR)
            {
                status = CRYPTO_HASH_SUCCESS;
            }
        }
    }

    return status;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *data, uint32_t dataLen,
    uint8_t *digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
    HASHCON_MODE mode;
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    CRYPTO_HASH_HW_DIGEST_CONTEXT shaDigestCtx;

    status = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm_en, &mode);

    if (status == CRYPTO_HASH_SUCCESS)
    {
        HASH_ERROR hashStatus = HASH_INITIALIZE_ERROR;
        uint32_t digestLength = 0;

        shaDigestCtx.algorithm = shaAlgorithm_en;
        (void)memset(shaDigestCtx.contextData, 0, sizeof(shaDigestCtx.contextData));

        if (CRYPTO_HASH_SUCCESS == lCrypto_Hash_Hw_Sha_GetDigestLength(shaDigestCtx.algorithm, &digestLength))
        {
            hashStatus = DRV_CRYPTO_HASH_Digest(shaDigestCtx.contextData, mode, data, dataLen, digest, digestLength);
        }

        if (hashStatus != HASH_NO_ERROR)
        {
            status = CRYPTO_HASH_ERROR_FAIL;
        }
    }

    return status;
}
