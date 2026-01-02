/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_mac_hsm_lite_04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for HSM_LITE/CAM hardware AES MAC.

  Description:
    This header file contains the wrapper interface to access the AES-MAC
    algorithms in the HSM_LITE/CAM AES hardware driver for Microchip microcontrollers.
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

#ifndef CRYPTO_MAC_HSM_LITE_04777_WRAPPER_H
#define	CRYPTO_MAC_HSM_LITE_04777_WRAPPER_H

#include <stdint.h>

#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_mac_cipher.h"

<#if (CRYPTO_HW_HMAC?? &&(CRYPTO_HW_HMAC == true))>
#include "crypto/drivers/wrapper/crypto_hash_hsm_lite_04777_wrapper.h"
</#if> <#-- CRYPTO_HW_AES_HMAC -->
<#if (CRYPTO_HW_AES_GMAC?? && CRYPTO_HW_AES_GMAC == true)>
#include "crypto/drivers/wrapper/crypto_aead_hsm_lite_04777_wrapper.h"
</#if> <#-- CRYPTO_HW_AES_GMAC -->
#ifdef	__cplusplus
extern "C" {
#endif

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Minimum size (in bytes) required to store an AES-CMAC HSM_LITE/CAM library context block.
 */
#define MINIMUM_CMAC_CONTEXT_DATA_SIZE  (240UL)

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief AES-CMAC hardware context.
 * @details
 * Structure containing state necessary for AES-CMAC operations using HSM_LITE/CAM library.
 * The contextData array is aligned for optimal hardware access.
 */
typedef struct
{
  /**
   * @brief Array to store HSM_LITE/CAM library internal context data.
   */
  uint8_t contextData[MINIMUM_CMAC_CONTEXT_DATA_SIZE] __attribute__((aligned(4)));
} CRYPTO_CMAC_HW_CONTEXT;

<#if (CRYPTO_HW_HMAC?? &&(CRYPTO_HW_HMAC == true))>
/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief The maximum block size allowed for HMAC operations.
 * @details
 * This constant represents the maximum key or block size (in bytes)
 * for supported SHA-based HMAC operations.
 */
#define HMAC_MAX_BLOCK_SIZE (128U)

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief HMAC hardware context.
 * @details
 * Structure storing the HMAC process state, block size, and SHA context
 * used for HMAC operations.
 */
typedef struct
{
    // Stores the ipad_key / opad_key as used during the HMAC operation.
    uint8_t hmacKeyData[HMAC_MAX_BLOCK_SIZE];

    // Stores the HMAC block size to use for the HMAC operation.
    uint32_t hmacBlockSize;

    // Stores the HASH context to use when performing HMAC HASH operations.
    CRYPTO_HASH_HW_CONTEXT shaContext;

} CRYPTO_HMAC_HW_CONTEXT;

</#if>
<#if (CRYPTO_HW_AES_GMAC?? && CRYPTO_HW_AES_GMAC == true)>
/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief GMAC hardware context.
 * @details
 * Structure holding key material and AEAD context data for GMAC (based on AES-GCM) operations.
 */
typedef struct
{
    // Key data, provided during init and used during cipher.
    uint8_t keyData[CRYPTO_AESKEYSIZE_256];
    // Length of the key data.
    uint32_t keyLength;

    // GMAC uses GCM with all the data provided as Additional Authentication Data (AAD).
    CRYPTO_AEAD_HW_CONTEXT aeadContext;

} CRYPTO_GMAC_HW_CONTEXT;

</#if> <#-- CRYPTO_HW_AES_GMAC -->
// *****************************************************************************
// *****************************************************************************
// Section: MAC Algorithms Common Interface
// *****************************************************************************
// *****************************************************************************

/** 
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Initializes the AES-CMAC context.
 * @param [in] contextData Pointer to the context data structure.
 * @param [in] key Pointer to the AES key.
 * @param [in] keyLen Length of the AES key in bytes.
 * @return @ref crypto_Mac_Status_E indicating the status of the operation.
 * @retval CRYPTO_MAC_SUCCESS Operation completed successfully.
 * @retval CRYPTO_MAC_ERROR An error occurred during the operation.
 * @details This function initializes the context for AES-CMAC operations.
 */
 
crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Init(void *contextData, uint8_t *key, uint32_t keyLen);

/** 
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Processes input data for AES-CMAC.
 * @param [in] contextData Pointer to the context data structure.
 * @param [in] inputData Pointer to the input data to be processed.
 * @param [in] dataLen Length of the input data in bytes.
 * @return @ref crypto_Mac_Status_E indicating the status of the operation.
 * @retval CRYPTO_MAC_SUCCESS Operation completed successfully.
 * @retval CRYPTO_MAC_ERROR An error occurred during the operation.
 * @details This function processes the input data and updates the AES-CMAC context.
 */

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Cipher(void *contextData, uint8_t *inputData, uint32_t dataLen);

/** 
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Finalizes the AES-CMAC operation and produces the MAC.
 * @param [in] contextData Pointer to the context data structure.
 * @param [out] outputMac Pointer to the buffer where the MAC will be stored.
 * @param [in] macLen Length of the MAC in bytes.
 * @return @ref crypto_Mac_Status_E indicating the status of the operation.
 * @retval CRYPTO_MAC_SUCCESS Operation completed successfully.
 * @retval CRYPTO_MAC_ERROR An error occurred during the operation.
 * @details This function finalizes the AES-CMAC operation and writes the resulting MAC 
 * to the output buffer.
 */

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Final(void *contextData, uint8_t *outputMac, uint32_t macLen);

/** 
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Computes the AES-CMAC directly from input data.
 * @param [in] ptr_inputData Pointer to the input data.
 * @param [in] dataLen Length of the input data in bytes.
 * @param [out] ptr_outMac Pointer to the buffer where the MAC will be stored.
 * @param [in] macLen Length of the MAC in bytes.
 * @param [in] ptr_key Pointer to the AES key.
 * @param [in] keyLen Length of the AES key in bytes.
 * @return @ref crypto_Mac_Status_E indicating the status of the operation.
 * @retval CRYPTO_MAC_SUCCESS Operation completed successfully.
 * @retval CRYPTO_MAC_ERROR An error occurred during the operation.
 * @details This function computes the AES-CMAC directly from the input data without 
 * the need for a context.
 */

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Direct(uint8_t *ptr_inputData, uint32_t dataLen,
                                              uint8_t *ptr_outMac, uint32_t macLen,
                                              uint8_t *ptr_key, uint32_t keyLen);

<#if (CRYPTO_HW_HMAC?? &&(CRYPTO_HW_HMAC == true))>

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Initializes HMAC context for hardware HMAC operation.
 * @param [in] contextData   Pointer to an HMAC context structure.
 * @param [in] key           Pointer to the HMAC key.
 * @param [in] keyLength     Length (in bytes) of the HMAC key.
 * @param [in] shaAlgorithm  SHA hash algorithm to use.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_Hmac_Init(void *contextData, uint8_t *key, uint32_t keyLength, crypto_Hash_Algo_E shaAlgorithm);

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Processes input data for HMAC operation.
 * @param [in] contextData   Pointer to an HMAC context structure.
 * @param [in] inputData     Pointer to input data.
 * @param [in] dataLength    Length (in bytes) of input data.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_Hmac_Cipher(void *contextData, uint8_t *inputData, uint32_t dataLength);

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Finalizes the HMAC operation and generates the MAC.
 * @param [in] contextData   Pointer to an HMAC context structure.
 * @param [out] outputMac    Pointer to buffer for the generated MAC.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_Hmac_Final(void *contextData, uint8_t *outputMac);

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Computes HMAC in direct (one-step) mode.
 * @param [in] ptr_inputData   Pointer to input data.
 * @param [in] dataLength      Length of input data in bytes.
 * @param [out] ptr_outMac     Pointer to output buffer for the MAC.
 * @param [in] ptr_key         Pointer to HMAC key.
 * @param [in] keyLength       Length of key in bytes.
 * @param [in] shaAlgorithm    SHA algorithm to use.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_Hmac_Direct(uint8_t *ptr_inputData, uint32_t dataLength,
                                              uint8_t *ptr_outMac,
                                              uint8_t *ptr_key, uint32_t keyLength, crypto_Hash_Algo_E shaAlgorithm);

</#if>

<#if (CRYPTO_HW_AES_GMAC?? && CRYPTO_HW_AES_GMAC == true)>

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Initializes the GMAC hardware context.
 * @param [in] ptr_aesGmacCtx  Pointer to a GMAC context structure.
 * @param [in] ptr_key         Pointer to AES key data.
 * @param [in] keySize         Length of the AES key in bytes.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_AesGmac_Init(void *ptr_aesGmacCtx, uint8_t *ptr_key, uint32_t keySize);

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Processes input vector and AAD for GMAC calculation.
 * @param [in] ptr_aesGmacCtx  Pointer to a GMAC context structure.
 * @param [in] ptr_initVect    Pointer to initialization vector.
 * @param [in] initVectLen     Length of initialization vector in bytes.
 * @param [in] ptr_aad         Pointer to Additional Authenticated Data (AAD).
 * @param [in] aadLen          Length of AAD data in bytes.
 * @param [out] ptr_outMac     Pointer to buffer for output MAC.
 * @param [in] macLen          Length of the MAC in bytes.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_AesGmac_Cipher(void *ptr_aesGmacCtx, uint8_t *ptr_initVect,
                                                 uint32_t initVectLen, uint8_t *ptr_aad, uint32_t aadLen,
                                                 uint8_t *ptr_outMac, uint32_t macLen);

/**
 * @ingroup crypto_mac_hsm_lite_04777_wrapper
 * @brief Computes GMAC in direct (one-step) mode.
 * @param [in] ptr_initVect  Pointer to initialization vector.
 * @param [in] initVectLen   Length of initialization vector in bytes.
 * @param [out] ptr_outMac   Pointer to output buffer for the MAC.
 * @param [in] macLen        Length of the MAC in bytes.
 * @param [in] ptr_key       Pointer to AES key data.
 * @param [in] keyLen        Length of the AES key in bytes.
 * @param [in] ptr_aad       Pointer to Additional Authenticated Data (AAD).
 * @param [in] aadLen        Length of AAD data in bytes.
 * @return @ref crypto_Mac_Status_E indicating status.
 */
crypto_Mac_Status_E Crypto_Mac_Hw_AesGmac_Direct(uint8_t *ptr_initVect, uint32_t initVectLen,
                                                 uint8_t *ptr_outMac, uint32_t macLen, uint8_t *ptr_key,
                                                 uint32_t keyLen, uint8_t *ptr_aad, uint32_t aadLen);

</#if> <#-- CRYPTO_HW_AES_GMAC -->
#ifdef	__cplusplus
}
#endif

#endif	/* CRYPTO_MAC_HSM_LITE_04777_WRAPPER_H */