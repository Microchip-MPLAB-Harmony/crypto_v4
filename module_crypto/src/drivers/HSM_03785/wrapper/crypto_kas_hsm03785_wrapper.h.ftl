/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_hsm03785_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for the key agreement in the 
    hardware cryptographic library.

  Description:
    This header file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for key agreement.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) 2024, Microchip Technology Inc., and its subsidiaries. All rights reserved.

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

#ifndef CRYPTO_KAS_HSM03785_WRAPPER_H
#define CRYPTO_KAS_HSM03785_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_kas.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Kas Common Interface 
// *****************************************************************************
// *****************************************************************************

crypto_Kas_Status_E Crypto_Kas_Hw_Ecdh_SharedSecret(uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen, 
                                                    uint8_t *ptr_sharedSecret, uint32_t sharedSecretLen, crypto_EccCurveType_E eccCurveType_en);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

#endif /* CRYPTO_KAS_HSM03785_WRAPPER_H */
