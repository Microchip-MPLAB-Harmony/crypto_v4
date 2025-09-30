/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_mac_hsm04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for CAM hardware AES MAC.

  Description:
    This header file contains the wrapper interface to access the
    AES MAC algorithms in the AES hardware driver for Microchip microcontrollers.
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

#ifndef CRYPTO_MAC_HSM04777_WRAPPER_H
#define	CRYPTO_MAC_HSM04777_WRAPPER_H

#include "crypto/common_crypto/crypto_mac_cipher.h"

#ifdef	__cplusplus
extern "C" {
#endif

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

/**
 * @brief The minimum size to store a CAM library AES-CMAC context data block.
 *
 * This constant defines the minimum size required for the context data block
 * used in the AES-CMAC implementation within the CAM library.
 */
 
#define MINIMUM_CMAC_CONTEXT_DATA_SIZE  (240UL)

/** 
 * @brief Context data structure for AES-CMAC operations.
 * 
 * This structure is used to store the context data required for 
 * performing AES-CMAC operations using the CAM library. It contains 
 * an array to hold the context data, which is aligned to a 4-byte 
 * boundary for optimal access.
 */

typedef struct
{
  /** 
   * @brief Array to store the CAM library context data.
   * 
   * This array has a minimum size defined by 
   * MINIMUM_CMAC_CONTEXT_DATA_SIZE and is aligned to 4 bytes.
   */
  uint8_t contextData[MINIMUM_CMAC_CONTEXT_DATA_SIZE] __attribute__((aligned(4)));

} CRYPTO_CMAC_HW_CONTEXT;

// *****************************************************************************
// *****************************************************************************
// Section: MAC Algorithms Common Interface
// *****************************************************************************
// *****************************************************************************

/** 
 * @ingroup crypto_mac_hsm04777_wrapper
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
 * @ingroup crypto_mac_hsm04777_wrapper
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
 * @ingroup crypto_mac_hsm04777_wrapper
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
 * @ingroup crypto_mac_hsm04777_wrapper
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

#ifdef	__cplusplus
}
#endif

#endif	/* CRYPTO_MAC_HSM04777_WRAPPER_H */