/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_aead_hsm_lite_04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for HSM_LITE/CAM hardware AES.

  Description:
    This header file contains the wrapper interface to access the AEAD
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

#ifndef CRYPTO_AEAD_HSM_LITE_04777_WRAPPER_H
#define CRYPTO_AEAD_HSM_LITE_04777_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_aead_cipher.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @def MINIMUM_AEAD_CONTEXT_DATA_SIZE
 * @brief Minimum size in bytes for the HSM_LITE/CAM library AEAD context data block.
 * @details This size is required for AEAD operations.
 */

#define MINIMUM_AEAD_CONTEXT_DATA_SIZE  (256U)

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @def AES_GCM_AUTHTAG_SIZE
 * @brief Size of the AES-GCM authentication tag.
 * @details This defines the length of the authentication tag used in AES-GCM operations.
 */

#define AES_GCM_AUTHTAG_SIZE            (16U)
#define AES_CCM_AUTHTAG_SIZE            (16U)

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @struct CRYPTO_AEAD_HW_CONTEXT
 * @brief Hardware AEAD context structure for AES operations.
 * @var CRYPTO_AEAD_HW_CONTEXT::contextData
 * Buffer to store the HSM_LITE/CAM library's internal context data.
 * Must be 4-byte aligned.
 */
typedef struct
{
  // This is used to store the HSM_LITE/CAM library context data.
  uint8_t contextData[MINIMUM_AEAD_CONTEXT_DATA_SIZE] __attribute__((aligned(4)));

} CRYPTO_AEAD_HW_CONTEXT;

// *****************************************************************************
// *****************************************************************************
// Section: AEAD Algorithms Common Interface
// *****************************************************************************
// *****************************************************************************

<#if (CRYPTO_HW_AES_GCM?? && (CRYPTO_HW_AES_GCM == true))>

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @brief Initializes the AES-GCM AEAD operation.
 * @param [in,out] aeadInitCtx Pointer to the AEAD context (@ref CRYPTO_AEAD_HW_CONTEXT).
 * This context will be initialized.
 * @param [in] cipherOper_en The cipher operation to perform (encryption or decryption).
 * @param [in] key Pointer to the encryption key.
 * @param [in] keyLen Length of the key in bytes.
 * @param [in] initVect Pointer to the initialization vector.
 * @param [in] initVectLen Length of the initialization vector in bytes.
 * @return @ref crypto_Aead_Status_E indicating operation result.
 * @retval CRYPTO_AEAD_SUCCESS Success.
 * @retval CRYPTO_AEAD_ERROR_FAIL General failure.
 */

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Init(void *aeadInitCtx,
    crypto_CipherOper_E cipherOper_en, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect, uint32_t initVectLen);

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @brief Adds additional authenticated data (AAD) to the AES-GCM operation.
 * @param [in,out] aeadCipherCtx Pointer to the AEAD context.
 * @param [in] aad Pointer to the additional authenticated data.
 * @param [in] aadLen Length of the additional authenticated data in bytes.
 * @return @ref crypto_Aead_Status_E indicating operation result.
 * @retval CRYPTO_AEAD_SUCCESS Success.
 * @retval CRYPTO_AEAD_ERROR_FAIL General failure.
 */

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_AddAadData(void *aeadCipherCtx,
      uint8_t *aad, uint32_t aadLen);

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @brief Processes the input data for AES-GCM encryption or decryption.
 * @param [in,out] aeadCipherCtx Pointer to the AEAD context.
 * @param [in] inputData Pointer to the input data to be processed.
 * @param [in] dataLen Length of the input data in bytes.
 * @param [out] outData Pointer to the buffer where the processed output will be stored.
 * @return @ref crypto_Aead_Status_E indicating operation result.
 * @retval CRYPTO_AEAD_SUCCESS Success.
 * @retval CRYPTO_AEAD_ERROR_FAIL General failure.
 */

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Cipher(void *aeadCipherCtx,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData);

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @brief Finalizes the AES-GCM operation and retrieves the authentication tag.
 * @param [in,out] aeadCipherCtx Pointer to the AEAD context.
 * @param [out] authTag Pointer to the buffer where the authentication tag will be stored.
 * @param [in] authTagLen Length of the authentication tag in bytes.
 * @return @ref crypto_Aead_Status_E indicating operation result.
 * @retval CRYPTO_AEAD_SUCCESS Success.
 * @retval CRYPTO_AEAD_ERROR_FAIL General failure.
 */

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Final(void *aeadCipherCtx,
      uint8_t *authTag, uint32_t authTagLen);

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @brief Encrypts and authenticates data in a single operation using AES-GCM.
 * @param [in] inputData Pointer to the input data to be encrypted.
 * @param [in] dataLen Length of the input data in bytes.
 * @param [out] outData Pointer to the buffer where the encrypted output will be stored.
 * @param [in] key Pointer to the encryption key.
 * @param [in] keyLen Length of the key in bytes.
 * @param [in] initVect Pointer to the initialization vector.
 * @param [in] initVectLen Length of the initialization vector in bytes.
 * @param [in] aad Pointer to the additional authenticated data.
 * @param [in] aadLen Length of the additional authenticated data in bytes.
 * @param [out] authTag Pointer to the buffer where the authentication tag will be stored.
 * @param [in] authTagLen Length of the authentication tag in bytes.
 * @return @ref crypto_Aead_Status_E indicating operation result.
 * @retval CRYPTO_AEAD_SUCCESS Success.
 * @retval CRYPTO_AEAD_ERROR_FAIL General failure.
 */

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_EncryptAuthDirect(uint8_t *inputData,
    uint32_t dataLen, uint8_t *outData, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect, uint32_t initVectLen, uint8_t *aad, uint32_t aadLen,
    uint8_t *authTag, uint32_t authTagLen);

/**
 * @ingroup crypto_aead_hsm_lite_04777_wrapper
 * @brief Decrypts and authenticates data in a single operation using AES-GCM.
 * @param [in] inputData Pointer to the input data to be decrypted.
 * @param [in] dataLen Length of the input data in bytes.
 * @param [out] outData Pointer to the buffer where the decrypted output will be stored.
 * @param [in] key Pointer to the decryption key.
 * @param [in] keyLen Length of the key in bytes.
 * @param [in] initVect Pointer to the initialization vector.
 * @param [in] initVectLen Length of the initialization vector in bytes.
 * @param [in] aad Pointer to the additional authenticated data.
 * @param [in] aadLen Length of the additional authenticated data in bytes.
 * @param [in] authTag Pointer to the authentication tag.
 * @param [in] authTagLen Length of the authentication tag in bytes.
 * @return @ref crypto_Aead_Status_E indicating operation result.
 * @retval CRYPTO_AEAD_SUCCESS Success.
 * @retval CRYPTO_AEAD_ERROR_FAIL General failure.
 */
 
crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_DecryptAuthDirect(uint8_t *inputData,
    uint32_t dataLen, uint8_t *outData, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect, uint32_t initVectLen, uint8_t *aad, uint32_t aadLen,
    uint8_t *authTag, uint32_t authTagLen);

</#if><#-- CRYPTO_HW_AES_GCM -->
<#if (CRYPTO_HW_AES_CCM?? && (CRYPTO_HW_AES_CCM == true))>
crypto_Aead_Status_E Crypto_Aead_Hw_AesCcm_Init(void *aeadInitCtx,
    uint8_t *key, uint32_t keyLen);

crypto_Aead_Status_E Crypto_Aead_Hw_AesCcm_Cipher(void *aeadCipherCtx,
    crypto_CipherOper_E cipherOper_en,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData,
    uint8_t *nonce, uint32_t nonceLen, uint8_t *aad, uint32_t aadLen,
    uint8_t *authTag, uint32_t authTagLen);

</#if><#-- CRYPTO_HW_AES_CCM -->
// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* CRYPTO_AEAD_HSM_LITE_04777_WRAPPER_H */
