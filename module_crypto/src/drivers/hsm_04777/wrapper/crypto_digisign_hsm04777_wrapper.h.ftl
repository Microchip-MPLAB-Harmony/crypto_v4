/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_digisign_hsm04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for the digital signature in the 
    hardware cryptographic library.

  Description:
    This header file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for digital signature.
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

#ifndef CRYPTO_DIGISIGN_HSM04777_WRAPPER_H
#define CRYPTO_DIGISIGN_HSM04777_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_digsign.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: DigSign Common Interface 
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_digisign_hsm04777_wrapper
 * @brief Performs an ECDSA sign operation using hardware.
 * @details Generates an ECDSA signature from a hash using the CAM hardware library.
 * @param [in] inputHash Pointer to the hash to be signed.
 * @param [in] hashLen Length of the input hash in bytes.
 * @param [out] outSig Pointer to the buffer for the generated signature.
 * @param [in] sigLen Length of the output signature buffer in bytes.
 * @param [in] privKey Pointer to the private key.
 * @param [in] privKeyLen Length of the private key in bytes.
 * @param [in] eccCurveType_En ECC curve type (see @ref crypto_EccCurveType_E).
 * @return @ref crypto_DigiSign_Status_E indicating operation result.
 * @retval CRYPTO_DIGISIGN_SUCCESS Success.
 * @retval CRYPTO_DIGISIGN_ERROR_CURVE Invalid ECC curve.
 * @retval CRYPTO_DIGISIGN_ERROR_RNG RNG error.
 * @retval CRYPTO_DIGISIGN_ERROR_FAIL General sign failure.
 */

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Hw_Sign(uint8_t *inputHash, 
    uint32_t hashLen, uint8_t *outSig, uint32_t sigLen, uint8_t *privKey, 
    uint32_t privKeyLen, crypto_EccCurveType_E eccCurveType_En);

/**
 * @ingroup crypto_digisign_hsm04777_wrapper
 * @brief Performs an ECDSA signature verification using hardware.
 * @details Verifies an ECDSA signature against a hash and public key using the CAM hardware.
 * @param [in] inputHash Pointer to the hash that was signed.
 * @param [in] hashLen Length of the input hash in bytes.
 * @param [in] inputSig Pointer to the signature to be verified.
 * @param [in] sigLen Length of the input signature in bytes.
 * @param [in] pubKey Pointer to the public key.
 * @param [in] pubKeyLen Length of the public key in bytes.
 * @param [out] hashVerifyStatus Verification result: 1 for valid, 0 for invalid.
 * @param [in] eccCurveType_En ECC curve type (see @ref crypto_EccCurveType_E).
 * @return @ref crypto_DigiSign_Status_E indicating operation result.
 * @retval CRYPTO_DIGISIGN_SUCCESS Operation completed (check `hashVerifyStatus`).
 * @retval CRYPTO_DIGISIGN_ERROR_PUBKEYCOMPRESS Public key decompression error.
 * @retval CRYPTO_DIGISIGN_ERROR_CURVE Invalid ECC curve.
 * @retval CRYPTO_DIGISIGN_ERROR_FAIL General verification failure.
 * @note Return status indicates hardware operation success; `hashVerifyStatus` shows signature validity.
 */
 
crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Hw_Verify(uint8_t *inputHash, 
    uint32_t hashLen, uint8_t *inputSig, uint32_t sigLen, uint8_t *pubKey, 
    uint32_t pubKeyLen, int8_t *hashVerifyStatus, 
    crypto_EccCurveType_E eccCurveType_En);


// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* CRYPTO_DIGISIGN_HSM04777_WRAPPER_H */
