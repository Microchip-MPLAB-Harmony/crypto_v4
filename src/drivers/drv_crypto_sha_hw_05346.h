/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_sha_hw_05346.h

  Summary:
    Crypto Framework Library interface file for hardware SHA.

  Description:
    This header file contains the interface that make up the SHA hardware 
    driver for the following families of Microchip microcontrollers:
    dsPIC33AK with Crypto Accelerator Module.
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

#ifndef DRV_CRYPTO_SHA_HW_05346_H
#define	DRV_CRYPTO_SHA_HW_05346_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: CAM Data Types
// *****************************************************************************
// *****************************************************************************

#define HASH_BLOCK_SIZE          4

// *****************************************************************************
// *****************************************************************************
// Section: SHA Common Data Types
// *****************************************************************************
// *****************************************************************************

typedef enum 
{
  CRYPTO_SHA_ALGO_SHA1 = 1,
  CRYPTO_SHA_ALGO_SHA224 = 2,
  CRYPTO_SHA_ALGO_SHA256 = 3,
  CRYPTO_SHA_ALGO_SHA384 = 4,
  CRYPTO_SHA_ALGO_SHA512 = 5
} CRYPTO_SHA_ALGO;

// *****************************************************************************
// *****************************************************************************
// Section: SHA Common Interface 
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_SHA_Init(CRYPTO_SHA_ALGO shaAlgo);

void DRV_CRYPTO_SHA_Update(uint32_t *data, uint32_t size, uint8_t numOfPaddingBytes);

void DRV_CRYPTO_SHA_GetOutputData(uint32_t *digest);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif	// DRV_CRYPTO_SHA_HW_05346_H

