/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_cam05346_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for CAM hardware AES.

  Description:
    This source file contains the wrapper interface to access the symmetric 
    AES algorithms in the AES hardware driver for Microchip microcontrollers.
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
#include "crypto/drivers/wrapper/crypto_sym_cam05346_wrapper.h"
#include "crypto/drivers/library/cam_aes.h"

// *****************************************************************************
// *****************************************************************************
// Section: Global Functions
// *****************************************************************************
// *****************************************************************************

void __attribute__((interrupt)) _CRYPTO1Interrupt(void);

void __attribute__((interrupt)) _CRYPTO1Interrupt(void) 
{
    DRV_CRYPTO_AES_IsrHelper();
    _CRYPT1IF = 0;
}

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

static crypto_Sym_Status_E lCrypto_Sym_Hw_Aes_GetCipherMode(crypto_Sym_OpModes_E opMode, 
        AESCON_MODE* mode)
{
    crypto_Sym_Status_E status = CRYPTO_SYM_ERROR_OPMODE;
    
    switch (opMode) 
    {
        case CRYPTO_SYM_OPMODE_ECB:
            *mode = MODE_ECB;
            status = CRYPTO_SYM_CIPHER_SUCCESS;
            break;  
        default:
            status = CRYPTO_SYM_ERROR_OPMODE;
            break;
    }
    
    return status;
}

static crypto_Sym_Status_E lCrypto_Sym_Hw_Aes_GetOperation
    (crypto_CipherOper_E cipherOpType, AESCON_OPERATION* operation)
{
    crypto_Sym_Status_E status = CRYPTO_SYM_ERROR_CIPOPER;
    
    switch (cipherOpType) 
    {
        case CRYPTO_CIOP_ENCRYPT:
            *operation = OP_ENC;
            status = CRYPTO_SYM_CIPHER_SUCCESS;
            break;
        case CRYPTO_CIOP_DECRYPT:
            *operation = OP_DEC;
            status = CRYPTO_SYM_CIPHER_SUCCESS;
            break;        
        default:
            status = CRYPTO_SYM_ERROR_CIPOPER;
            break;
    }
    
    return status;
}

static uint32_t lCrypto_Sym_Hw_Aes_GetNumOfInvalidBytes(uint32_t dataLen)
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

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Init(crypto_CipherOper_E cipherOpType_en, 
    crypto_Sym_OpModes_E opMode_en, uint8_t *key, uint32_t keyLen, 
    uint8_t *initVect)
{ 
    crypto_Sym_Status_E status = CRYPTO_SYM_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_INITIALIZE_ERROR;
    
    AESCON_MODE mode;
    AESCON_OPERATION operation;

    status = lCrypto_Sym_Hw_Aes_GetCipherMode(opMode_en, &mode);
    
    if(status == CRYPTO_SYM_CIPHER_SUCCESS)
    {
        status = lCrypto_Sym_Hw_Aes_GetOperation(cipherOpType_en, &operation);
    }
    
    if(status == CRYPTO_SYM_CIPHER_SUCCESS)
    {
        aesStatus = DRV_CRYPTO_AES_Initialize(mode, operation, key, keyLen, initVect);
    }
    
    if(aesStatus == AES_NO_ERROR)
    {
        lDRV_CRYPTO_AES_InterruptSetup();
    } 
    else 
    {        
        status = CRYPTO_SYM_ERROR_CIPFAIL;
    }
    
    return status;
}
    
crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Cipher(uint8_t *inputData, 
    uint32_t dataLen, uint8_t *outData)
{
    crypto_Sym_Status_E status = CRYPTO_SYM_ERROR_CIPFAIL;
    AES_ERROR aesStatus = AES_GENERAL_ERROR;
    
    uint32_t numOfInvalidBytes = lCrypto_Sym_Hw_Aes_GetNumOfInvalidBytes(dataLen);
    uint32_t fullBlockLen = dataLen + numOfInvalidBytes;
   
    aesStatus = DRV_CRYPTO_AES_WriteInputData(inputData, fullBlockLen, numOfInvalidBytes);
    
    if(aesStatus == AES_NO_ERROR)
    {
        aesStatus = DRV_CRYPTO_AES_ReadOutputData(outData, fullBlockLen);
    }
    
    if(aesStatus == AES_NO_ERROR)
    {
        status = CRYPTO_SYM_CIPHER_SUCCESS;
    }

    return status;
}

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_EncryptDirect(crypto_Sym_OpModes_E opMode_en, 
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData, 
    uint8_t *key, uint32_t keyLen, uint8_t *initVect)
{    
    crypto_Sym_Status_E status = Crypto_Sym_Hw_Aes_Init(CRYPTO_CIOP_ENCRYPT, 
            opMode_en, key, keyLen, initVect);

    if (status == CRYPTO_SYM_CIPHER_SUCCESS)
    {
        status = Crypto_Sym_Hw_Aes_Cipher(inputData, dataLen, outData);
    }
    
    return status;
}

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_DecryptDirect(crypto_Sym_OpModes_E opMode_en, 
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData, 
    uint8_t *key, uint32_t keyLen, uint8_t *initVect)
{
    crypto_Sym_Status_E status = Crypto_Sym_Hw_Aes_Init(CRYPTO_CIOP_DECRYPT, 
            opMode_en, key, keyLen, initVect);
    
    uint32_t numOfInvalidBytes = lCrypto_Sym_Hw_Aes_GetNumOfInvalidBytes(dataLen);
    uint32_t fullBlockLen = dataLen + numOfInvalidBytes;
                
    if (status == CRYPTO_SYM_CIPHER_SUCCESS)
    {
        status = Crypto_Sym_Hw_Aes_Cipher(inputData, fullBlockLen, outData);
    }
    
    return status;
}
