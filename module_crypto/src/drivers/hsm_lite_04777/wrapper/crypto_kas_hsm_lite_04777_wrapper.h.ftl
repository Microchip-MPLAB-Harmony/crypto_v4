/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_hsm_lite_04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for the Shared Secret generation in the
    hardware cryptographic library.

  Description:
    This source file contains the wrapper interface to access the hardware
    cryptographic library in Microchip microcontrollers for Shared Secret generation.
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

#ifndef CRYPTO_KAS_HSM_04777_WRAPPER_H
#define	CRYPTO_KAS_HSM_04777_WRAPPER_H

#ifdef	__cplusplus
extern "C" {
#endif

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_kas.h"

// *****************************************************************************
// *****************************************************************************
// Section: MAC Algorithms Common Interface
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_kas_hsm_lite_04777_wrapper
 * @brief Generates a shared secret using the Elliptic Curve Diffie-Hellman (ECDH) algorithm.
 *
 * This function computes the shared secret based on the provided private and public keys
 * using the specified elliptic curve type. The generated shared secret is stored in the
 * provided buffer.
 *
 * @param [in] privKey Pointer to the private key buffer.
 * @param [in] privKeyLen Length of the private key in bytes.
 * @param [in] pubKey Pointer to the public key buffer.
 * @param [in] pubKeyLen Length of the public key in bytes.
 * @param [out] secret Pointer to the buffer where the shared secret will be stored.
 * @param [in] secretLen Length of the shared secret buffer in bytes.
 * @param [in] eccCurveType_en The type of elliptic curve to be used for the operation.
 *
 * @return @ref crypto_Kas_Status_E indicating the status of the shared secret generation operation.
 * @retval CRYPTO_KAS_SUCCESS Operation completed successfully.
 * @retval CRYPTO_KAS_ERROR Invalid parameters or operation failed.
 */

crypto_Kas_Status_E Crypto_Kas_Ecdh_Hw_SharedSecret(uint8_t *privKey, 
    uint32_t privKeyLen, uint8_t *pubKey, uint32_t pubKeyLen, 
    uint8_t *secret, uint32_t secretLen, crypto_EccCurveType_E eccCurveType_en);

#ifdef	__cplusplus
}
#endif

#endif	/* CRYPTO_KAS_HSM_04777_WRAPPER_H */

