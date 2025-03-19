/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_mac_cam05346_wrapper.h

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

#ifndef CRYPTO_MAC_CAM05346_WRAPPER_H
#define	CRYPTO_MAC_CAM05346_WRAPPER_H

#include "crypto/common_crypto/crypto_mac_cipher.h"

#ifdef	__cplusplus
extern "C" {
#endif
    
// *****************************************************************************
// *****************************************************************************
// Section: MAC Algorithms Common Interface 
// *****************************************************************************
// *****************************************************************************

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Init(uint8_t *key, uint32_t keyLen);
    
crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Cipher(uint8_t *inputData, uint32_t dataLen);

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Final(uint8_t *outputMac, uint32_t macLen);

#ifdef	__cplusplus
}
#endif

#endif	/* CRYPTO_MAC_CAM05346_WRAPPER_H */

