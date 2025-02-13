/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_trng_hw_05346.c

  Summary:
    Crypto Framework Library interface file for hardware TRNG.

  Description:
    This source file contains the interface that make up the TRNG hardware 
    driver for the following families of Microchip microcontrollers:
    dsPIC33CK512MPS512.
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/drivers/driver/drv_crypto_trng_hw_05346.h"
#include "crypto/drivers/library/cam_trng.h"
#include <xc.h>

// *****************************************************************************
// *****************************************************************************
// Section: Global Functions
// *****************************************************************************
// *****************************************************************************

void __attribute__((interrupt)) _CRYPTO2Interrupt(void);

void __attribute__((interrupt)) _CRYPTO2Interrupt(void) 
{
    DRV_CRYPTO_TRNG_IsrHelper();
    _CRYPT2IF = 0;
}

// *****************************************************************************
// *****************************************************************************
// Section: File Scope Functions
// *****************************************************************************
// *****************************************************************************

static void lDRV_CRYPTO_TRNG_InterruptSetup(void) 
{
    _CRYPT2IF = 0;
    _CRYPT2IE = 1;
}

static TRNG_ERROR lDRV_CRYPTO_TRNG_SetKey(TRNG_CTX* trngData)
{
    uint8_t keyData[KEY_SIZE] = {0};
    TRNG_ERROR errorCode = DRV_CRYPTO_TRNG_ReadData(keyData, KEY_SIZE);

    if (TRNG_NO_ERROR != errorCode)
    {
        errorCode = TRNG_KEY_SETUP;
    }
    else 
    {
        trngData->key.data = keyData;
        trngData->key.size = KEY_SIZE;
        DRV_CRYPTO_TRNG_SetupKey(trngData->key.data, trngData->key.size);
    }

    DRV_CRYPTO_TRNG_Reset();
    
    return errorCode;
}

static TRNG_ERROR lDRV_CRYPTO_TRNG_Setup(TRNG_CTX* trngData)
{
    DRV_CRYPTO_TRNG_SetupEngine(trngData->fifoWriteStartup, 
            trngData->htestAfterCond, trngData->conditioningBypass, 
            trngData->nb128Block);
    DRV_CRYPTO_TRNG_SetInitialWait(trngData->initialWait);
    DRV_CRYPTO_TRNG_SetFifoThreshold( trngData->fifoThreshold);
    lDRV_CRYPTO_TRNG_InterruptSetup();
    return lDRV_CRYPTO_TRNG_SetKey(trngData);
}

// *****************************************************************************
// *****************************************************************************
// Section: TRNG Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_TRNG_Generate(uint8_t *rngData, uint32_t rngLen) 
{
    TRNG_CTX trngData = {
        .clkDiv = 0,                     
        .conditioningBypass = false,       
        .fifoThreshold = 3,         
        .fifoWriteStartup = false,          
        .htestAfterCond = false,           
        .initialWait = 256,                     
        .nb128Block = 4        
    };
    
    (void) lDRV_CRYPTO_TRNG_Setup(&trngData);

    (void) DRV_CRYPTO_TRNG_ReadData(rngData, rngLen);

    DRV_CRYPTO_TRNG_Reset();
}