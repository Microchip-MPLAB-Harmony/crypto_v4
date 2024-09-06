/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Aead_HwWrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware AES.

  Description:
    This source file contains the wrapper interface to access the AEAD
    algorithms in the AES hardware driver for Microchip microcontrollers.
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/MCHP_Crypto_Aead_Cipher.h"
#include "crypto/common_crypto/MCHP_Crypto_Aead_HwWrapper.h"
#include "crypto/common_crypto/MCHP_Crypto_Common_HwWrapper.h"
#include "crypto/drivers/hsm_aead.h"
// *****************************************************************************
// *****************************************************************************
// Section: File Scope Variables
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Init(void *ptr_aesGcmCtx, crypto_CipherOper_E cipherOper_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t ivLen)
{
    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;
    hsm_Aes_KeySize_E keySize_en = HSM_SYM_AES_KEY_128;
    hsm_Aes_CmdTypes_E ciperOper_en = HSM_SYM_AES_GCM_ENCRYPT;
    
    keySize_en = Crypto_Hw_Aes_GetKeySize(keyLen);
    
    if(cipherOper_en == CRYPTO_CIOP_ENCRYPT)
    {
        ciperOper_en = HSM_SYM_AES_GCM_ENCRYPT;
    }
    else
    {
        ciperOper_en = HSM_SYM_AES_GCM_DECRYPT;
    }
    
    hsmCmdStatus_en = Hsm_Aead_AesGcm_Init(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ciperOper_en, ptr_key, keySize_en, ptr_initVect, ivLen);
    
    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
    }
    else
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
    }
    return ret_aesGcmStatus_en;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_AddAad(void *ptr_aesGcmCtx, uint8_t *ptr_aad, uint32_t aadLen)
{
    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;

    hsmCmdStatus_en = Hsm_Aead_AesGcm_AddAad(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ptr_aad, aadLen);
    
    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
    }
    else
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
    }
    return ret_aesGcmStatus_en;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Cipher(void *ptr_aesGcmCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;

    hsmCmdStatus_en = Hsm_Aead_AesGcm_UpdateCipher(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ptr_inputData, dataLen, ptr_outData);
    
    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
    }
    else
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
    }
    return ret_aesGcmStatus_en;
}

crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Final(void *ptr_aesGcmCtx, uint8_t *ptr_authTag, uint8_t authTagLen)
{
    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;
    
    hsmCmdStatus_en = Hsm_Aead_AesGcm_Final(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ptr_authTag, authTagLen);
    
    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
    }
    else
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
    }
    return ret_aesGcmStatus_en;
}


crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_EncryptAuthDirect(uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_outData, 
                                                          uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t initVectLen, 
                                                          uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen)
{
    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Aes_KeySize_E keySize_en = HSM_SYM_AES_KEY_128;
    
    keySize_en = Crypto_Hw_Aes_GetKeySize(keyLen);
    
    hsmCmdStatus_en = Hsm_Aead_AesGcm_DirectEncrypt(ptr_dataIn, (uint16_t)dataLen, ptr_outData,
                                        ptr_key, keySize_en, ptr_initVect,initVectLen, ptr_aad, aadLen, ptr_authTag, authTagLen);
    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
    }
    else
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
    }
    return ret_aesGcmStatus_en;
}


crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_DecryptAuthDirect(uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_outData, 
                                                          uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t initVectLen, 
                                                          uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen)
{
    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Aes_KeySize_E keySize_en = HSM_SYM_AES_KEY_128;
    
    keySize_en = Crypto_Hw_Aes_GetKeySize(keyLen);
    
    hsmCmdStatus_en = Hsm_Aead_AesGcm_DirectDecrypt(ptr_dataIn, (uint16_t)dataLen, ptr_outData,
                                        ptr_key, keySize_en, ptr_initVect,initVectLen, ptr_aad, aadLen, ptr_authTag, authTagLen);
    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
    }
    else if(hsmCmdStatus_en == HSM_CMD_ERROR_AEADAUTH_FAILED)
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_AUTHFAIL;
    }
    else
    {
        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
    }
    return ret_aesGcmStatus_en;
}