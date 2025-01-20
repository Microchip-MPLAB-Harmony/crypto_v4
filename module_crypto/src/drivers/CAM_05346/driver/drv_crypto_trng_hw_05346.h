/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_trng_hw_05346.h

  Summary:
    Crypto Framework Library interface file for hardware TRNG.

  Description:
    This header file contains the interface that make up the TRNG hardware 
    driver for the following families of Microchip microcontrollers:
    dsPIC33CK512MPS512.
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

#ifndef DRV_CRYPTO_TRNG_HW_05346_H
#define	DRV_CRYPTO_TRNG_HW_05346_H

#define KEY_SIZE 128

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#ifdef	__cplusplus
extern "C" {
#endif

#include <stdint.h>   
#include <stdbool.h>
    
// *****************************************************************************
// *****************************************************************************
// Section: TRNG Common Interface 
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_TRNG_Generate(uint8_t *rngData, uint32_t rngLen);
    
#ifdef	__cplusplus
}
#endif

#endif	/* DRV_CRYPTO_TRNG_HW_05346_H */