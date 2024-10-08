/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_ecdsa_hw_05346.h

  Summary:
    ECDSA Hardware function declarations.

  Description:
    This header file contains the ECDSA API for crypto functionality 
    for the following families of Microchip microcontrollers:
    dsPIC33AK with Crypto Accelerator Module.
**************************************************************************/

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

#ifndef DRV_CRYPTO_ECDSA_HW_05346_H
#define	DRV_CRYPTO_ECDSA_HW_05346_H

#ifdef	__cplusplus
extern "C" {
#endif
    // DOM-IGNORE-END
    
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
    
#include "cam_ecdsa.h"
        
// *****************************************************************************
// *****************************************************************************
// Section: ECDSA Common Interface 
// *****************************************************************************
// *****************************************************************************
    
CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_InitEccParamsSign(ECDSA_CONFIG *eccData, uint8_t *hash, uint32_t hashLen, uint8_t * privKey, uint32_t privKeyLen, ECDSA_CMD_CURVE hwEccCurve);
CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_Sign(ECDSA_CONFIG *eccData, uint8_t * pfulSignature, uint32_t signatureLen);
CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_InitEccParamsVerify(ECDSA_CONFIG *eccData, uint8_t *inputHash, uint32_t hashLen, uint8_t *inputSig, uint32_t sigLen, uint8_t *pubKey, uint32_t pubKeyLen, ECDSA_CMD_CURVE hwEccCurve);
CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_Verify(ECDSA_CONFIG *eccData);

#ifdef	__cplusplus
}
#endif

#endif	/* DRV_CRYPTO_ECDSA_HW_05346_H */
