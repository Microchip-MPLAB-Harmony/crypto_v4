/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hash_hsm04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for hardware SHA.

  Description:
    This header file contains the wrapper interface to access the SHA
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

#ifndef CRYPTO_HASH_HSM04777_WRAPPER_H
#define CRYPTO_HASH_HSM04777_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_hash.h"

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
 * @ingroup crypto_hash_hsm04777_wrapper
 * @def MINIMUM_HASH_CONTEXT_DATA_SIZE
 * @brief Minimum size in bytes for the CAM library HASH context data block.
 * @details This size is required for multi-step hash operations (init, update, final).
 */

#define MINIMUM_HASH_CONTEXT_DATA_SIZE        (580UL)

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @def MINIMUM_HASH_DIGEST_CONTEXT_DATA_SIZE
 * @brief Minimum size in bytes for the CAM library HASH single-step digest context.
 * @details This smaller context is for single-call digest operations.
 */

#define MINIMUM_HASH_DIGEST_CONTEXT_DATA_SIZE (216UL)

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @struct CRYPTO_HASH_HW_CONTEXT
 * @brief Hardware HASH context structure for multi-step operations.
 * @var CRYPTO_HASH_HW_CONTEXT::algorithm
 * The hash algorithm being used (see @ref crypto_Hash_Algo_E).
 * @var CRYPTO_HASH_HW_CONTEXT::contextData
 * Buffer to store the CAM library's internal context data.
 * Must be 4-byte aligned.
 */

typedef struct
{
  crypto_Hash_Algo_E algorithm;

  // This is used to store the CAM library context data.
  uint8_t contextData[MINIMUM_HASH_CONTEXT_DATA_SIZE] __attribute__((aligned(4)));

} CRYPTO_HASH_HW_CONTEXT;

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @struct CRYPTO_HASH_HW_DIGEST_CONTEXT
 * @brief Hardware HASH context structure for single-step digest operations.
 * @var CRYPTO_HASH_HW_DIGEST_CONTEXT::algorithm
 * The hash algorithm being used (see @ref crypto_Hash_Algo_E).
 * @var CRYPTO_HASH_HW_DIGEST_CONTEXT::contextData
 * Buffer to store the CAM library's internal context data for digest operations.
 * Must be 4-byte aligned.
 */

typedef struct
{
  crypto_Hash_Algo_E algorithm;

  // This is used to store the CAM library context data.
  uint8_t contextData[MINIMUM_HASH_DIGEST_CONTEXT_DATA_SIZE] __attribute__((aligned(4)));

} CRYPTO_HASH_HW_DIGEST_CONTEXT;

// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @brief Computes a SHA digest in a single operation using hardware.
 * @param [in] data Pointer to the input data to be hashed.
 * @param [in] dataLen Length of the input data in bytes.
 * @param [out] digest Pointer to the buffer where the computed digest will be stored.
 * @param [in] shaAlgorithm_en The SHA algorithm to use (see @ref crypto_Hash_Algo_E).
 * @return @ref crypto_Hash_Status_E indicating operation result.
 * @retval CRYPTO_HASH_SUCCESS Success.
 * @retval CRYPTO_HASH_ERROR_ALGO Invalid algorithm.
 * @retval CRYPTO_HASH_ERROR_FAIL General failure.
 */

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *data, uint32_t dataLen,
    uint8_t *digest, crypto_Hash_Algo_E shaAlgorithm_en);

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @brief Initializes a multi-step SHA hash operation using hardware.
 * @param [in,out] shaInitCtx Pointer to the hardware HASH context (@ref CRYPTO_HASH_HW_CONTEXT).
 * This context will be initialized.
 * @param [in] shaAlgorithm_en The SHA algorithm to use (see @ref crypto_Hash_Algo_E).
 * @return @ref crypto_Hash_Status_E indicating operation result.
 * @retval CRYPTO_HASH_SUCCESS Success.
 * @retval CRYPTO_HASH_ERROR_ALGO Invalid algorithm.
 * @retval CRYPTO_HASH_ERROR_FAIL General failure.
 */

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *shaInitCtx,
    crypto_Hash_Algo_E shaAlgorithm_en);

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @brief Updates a multi-step SHA hash operation with more data using hardware.
 * @param [in,out] shaUpdateCtx Pointer to the hardware HASH context (@ref CRYPTO_HASH_HW_CONTEXT).
 * @param [in] data Pointer to the additional input data.
 * @param [in] dataLen Length of the additional input data in bytes.
 * @return @ref crypto_Hash_Status_E indicating operation result.
 * @retval CRYPTO_HASH_SUCCESS Success.
 * @retval CRYPTO_HASH_ERROR_FAIL General failure (e.g., context not active).
 */

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *shaUpdateCtx,
    uint8_t *data, uint32_t dataLen);

/**
 * @ingroup crypto_hash_hsm04777_wrapper
 * @brief Finalizes a multi-step SHA hash operation and retrieves the digest using hardware.
 * @param [in,out] shaFinalCtx Pointer to the hardware HASH context (@ref CRYPTO_HASH_HW_CONTEXT).
 * @param [out] digest Pointer to the buffer where the computed digest will be stored.
 * @return @ref crypto_Hash_Status_E indicating operation result.
 * @retval CRYPTO_HASH_SUCCESS Success.
 * @retval CRYPTO_HASH_ERROR_FAIL General failure (e.g., context not active or digest length error).
 */
 
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *shaFinalCtx,
    uint8_t *digest);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* CRYPTO_HASH_HSM04777_WRAPPER_H */
