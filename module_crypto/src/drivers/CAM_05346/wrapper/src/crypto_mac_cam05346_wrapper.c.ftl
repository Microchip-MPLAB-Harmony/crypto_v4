/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_mac_cam05346_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for CAM hardware AES MAC.

  Description:
    This source file contains the wrapper interface to access the 
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include <xc.h>
#include "crypto/drivers/wrapper/crypto_mac_cam05346_wrapper.h"
#include "crypto/drivers/library/cam_aes.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

static void lDRV_CRYPTO_AES_InterruptSetup(void)
{
    _CRYPT1IF = 0;
    _CRYPT1IE = 1;
}
    
static uint32_t lCrypto_Cmac_Hw_Aes_GetNumOfInvalidBytes(uint32_t dataLen)
{
    uint32_t numOfInvalidBytes = 0;
    uint32_t bytesOverAesBlock = dataLen % (uint32_t) AES_BLOCK_SIZE;

    if (bytesOverAesBlock != (uint32_t) 0)
    {
        numOfInvalidBytes = (uint32_t) AES_BLOCK_SIZE - bytesOverAesBlock;
    }
    
    return numOfInvalidBytes;
}

// *****************************************************************************
// *****************************************************************************
// Section: Symmetric Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Init(uint8_t *key, uint32_t keyLen)
{ 
    crypto_Mac_Status_E status = CRYPTO_MAC_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_INITIALIZE_ERROR;
    
    AESCON_MODE mode = MODE_CMAC;
    AESCON_OPERATION operation = OP_ENC;
    
    aesStatus = DRV_CRYPTO_AES_Initialize(mode, operation, key, keyLen, NULL);
    
    if(aesStatus == AES_NO_ERROR)
    {                      
        lDRV_CRYPTO_AES_InterruptSetup();
        status = CRYPTO_MAC_CIPHER_SUCCESS;
    } 
    else 
    {        
        status = CRYPTO_MAC_ERROR_CIPFAIL;
    }
    
    return status;
}
    
crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Cipher(uint8_t *inputData, uint32_t dataLen)
{
    crypto_Mac_Status_E status = CRYPTO_MAC_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_GENERAL_ERROR;
    
    uint32_t numOfInvalidBytes = lCrypto_Cmac_Hw_Aes_GetNumOfInvalidBytes(dataLen);
    uint32_t fullBlockLen = dataLen + numOfInvalidBytes;
    
    aesStatus = DRV_CRYPTO_AES_WriteInputData(inputData, fullBlockLen, numOfInvalidBytes);
 
    if(aesStatus == AES_NO_ERROR)
    {
        status = CRYPTO_MAC_CIPHER_SUCCESS;
    }

    return status;
}

crypto_Mac_Status_E Crypto_Sym_Hw_Cmac_Final(uint8_t *outputMac, uint32_t macLen){
    crypto_Mac_Status_E status = CRYPTO_MAC_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_GENERAL_ERROR;

    aesStatus = DRV_CRYPTO_AES_ReadOutputData(outputMac, macLen);

    if(aesStatus == AES_NO_ERROR)
    {
        status = CRYPTO_MAC_CIPHER_SUCCESS;
    }
    return status;
}

