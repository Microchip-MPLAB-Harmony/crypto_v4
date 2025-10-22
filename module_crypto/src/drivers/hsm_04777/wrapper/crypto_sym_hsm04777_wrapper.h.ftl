/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_hsm04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for CAM hardware AES.

  Description:
    This header file contains the wrapper interface to access the symmetric
    AES algorithms in the AES hardware driver for Microchip microcontrollers.
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

#ifndef CRYPTO_SYM_HSM04777_WRAPPER_H
#define CRYPTO_SYM_HSM04777_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/common_crypto/crypto_sym_cipher.h"

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
 * @brief The minimum size to store a CAM library AES context data block.
 */
 
#define MINIMUM_AES_CONTEXT_DATA_SIZE  (252UL)

/**
 * @brief Structure to hold the AES hardware context data.
 * 
 * This structure is used to store the context data required for AES operations
 * in the hardware. It contains an array that holds the necessary information
 * for the AES algorithm to function correctly.
 */

typedef struct
{
  /** 
   * @brief Context data for the CAM library.
   * 
   * This array holds the context data for the AES operations. It is aligned
   * to a 4-byte boundary to meet the hardware requirements.
   */
  uint8_t contextData[MINIMUM_AES_CONTEXT_DATA_SIZE] __attribute__((aligned(4)));

} CRYPTO_AES_HW_CONTEXT;

// *****************************************************************************
// *****************************************************************************
// Section: Symmetric Algorithms Common Interface
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_sym_hsm04777_wrapper
 * @brief Initializes the AES context for encryption or decryption.
 * @param [in] aesInitCtx Pointer to the AES context to be initialized.
 * @param [in] cipherOpType_en The cipher operation type (encrypt or decrypt).
 * @param [in] opMode_en The operation mode (e.g., ECB, CTR).
 * @param [in] key Pointer to the encryption key.
 * @param [in] keyLen Length of the encryption key.
 * @param [in] initVect Pointer to the initialization vector.
 * @return @ref crypto_Sym_Status_E indicating the status of the operation.
 * @retval CRYPTO_SYM_SUCCESS Operation completed successfully.
 * @retval CRYPTO_SYM_ERROR An error occurred during the operation.
 * @details This function initializes the AES context with the provided parameters and sets up
 * the necessary hardware configurations for AES operations.
 */

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Init(void *aesInitCtx, crypto_CipherOper_E cipherOpType_en,
    crypto_Sym_OpModes_E opMode_en, uint8_t *key, uint32_t keyLen,
    uint8_t *initVect);

/**
 * @ingroup crypto_sym_hsm04777_wrapper
 * @brief Performs AES encryption or decryption on the input data.
 * @param [in] aesCipherCtx Pointer to the AES context for the operation.
 * @param [in] inputData Pointer to the input data to be processed.
 * @param [in] dataLen Length of the input data.
 * @param [out] outData Pointer to the buffer where the output data will be stored.
 * @return @ref crypto_Sym_Status_E indicating the status of the operation.
 * @retval CRYPTO_SYM_SUCCESS Operation completed successfully.
 * @retval CRYPTO_SYM_ERROR An error occurred during the operation.
 * @details This function processes the input data using the AES algorithm and stores the result
 * in the output buffer. It handles both encryption and decryption based on the initialized context.
 */

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Cipher(void *aesCipherCtx, uint8_t *inputData,
    uint32_t dataLen, uint8_t *outData);

/**
 * @ingroup crypto_sym_hsm04777_wrapper
 * @brief Performs AES XTS encryption or decryption on the input data.
 * @param [in] aesCipherCtx Pointer to the AES context for the operation.
 * @param [in] inputData Pointer to the input data to be processed.
 * @param [in] dataLen Length of the input data.
 * @param [out] outData Pointer to the buffer where the output data will be stored.
 * @param [in] tweak Pointer to the tweak value used in XTS mode.
 * @return @ref crypto_Sym_Status_E indicating the status of the operation.
 * @retval CRYPTO_SYM_SUCCESS Operation completed successfully.
 * @retval CRYPTO_SYM_ERROR An error occurred during the operation.
 * @details This function processes the input data using the AES algorithm in XTS mode
 * and stores the result in the output buffer. It handles both encryption and decryption
 * based on the initialized context.
 */
 
crypto_Sym_Status_E Crypto_Sym_Hw_AesXts_Cipher(void *aesCipherCtx,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData, uint8_t* tweak);

/**
 * @ingroup crypto_sym_hsm04777_wrapper
 * @brief Encrypts the input data directly using AES.
 * @param [in] opMode_en The operation mode (e.g., ECB, CTR).
 * @param [in] inputData Pointer to the input data to be encrypted.
 * @param [in] dataLen Length of the input data.
 * @param [out] outData Pointer to the buffer where the encrypted data will be stored.
 * @param [in] key Pointer to the encryption key.
 * @param [in] keyLen Length of the encryption key.
 * @param [in] initVect Pointer to the initialization vector.
 * @return @ref crypto_Sym_Status_E indicating the status of the operation.
 * @retval CRYPTO_SYM_SUCCESS Operation completed successfully.
 * @retval CRYPTO_SYM_ERROR An error occurred during the operation.
 * @details This function initializes the AES context for encryption and processes the input data
 * to produce the encrypted output.
 */

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_EncryptDirect(crypto_Sym_OpModes_E opMode_en,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData,
    uint8_t *key, uint32_t keyLen, uint8_t *initVect);

/**
 * @ingroup crypto_sym_hsm04777_wrapper
 * @brief Decrypts the input data directly using AES.
 * @param [in] opMode_en The operation mode (e.g., ECB, CTR).
 * @param [in] inputData Pointer to the input data to be decrypted.
 * @param [in] dataLen Length of the input data.
 * @param [out] outData Pointer to the buffer where the decrypted data will be stored.
 * @param [in] key Pointer to the decryption key.
 * @param [in] keyLen Length of the decryption key.
 * @param [in] initVect Pointer to the initialization vector.
 * @return @ref crypto_Sym_Status_E indicating the status of the operation.
 * @retval CRYPTO_SYM_SUCCESS Operation completed successfully.
 * @retval CRYPTO_SYM_ERROR An error occurred during the operation.
 * @details This function initializes the AES context for decryption and processes the input data
 * to produce the decrypted output.
 */

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_DecryptDirect(crypto_Sym_OpModes_E opMode_en,
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData,
    uint8_t *key, uint32_t keyLen, uint8_t *initVect);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* CRYPTO_SYM_HSM04777_WRAPPER_H */
