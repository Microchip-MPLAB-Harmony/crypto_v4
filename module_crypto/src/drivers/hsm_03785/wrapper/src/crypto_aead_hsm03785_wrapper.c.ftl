/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_aead_hsm03785_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware AES.

  Description:
    This source file contains the wrapper interface to access the AEAD
    algorithms in the AES hardware driver for Microchip microcontrollers.
**************************************************************************/

/*******************************************************************************
* Copyright (C) 2025 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*******************************************************************************/

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/crypto_aead_cipher.h"
#include "crypto/drivers/wrapper/crypto_aead_hsm03785_wrapper.h"
#include "crypto/drivers/wrapper/crypto_hsm03785_common_wrapper.h"
#include "crypto/drivers/driver/hsm_aead.h"
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

//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Init(void *ptr_aesGcmCtx, crypto_CipherOper_E cipherOper_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t ivLen)
//{
//    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
//    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
//    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;
//    hsm_Aes_KeySize_E keySize_en = HSM_SYM_AES_KEY_128;
//    hsm_Aes_CmdTypes_E ciperOper_en = HSM_SYM_AES_GCM_ENCRYPT;
//    
//    keySize_en = Crypto_Hw_Aes_GetKeySize(keyLen);
//    
//    if(cipherOper_en == CRYPTO_CIOP_ENCRYPT)
//    {
//        ciperOper_en = HSM_SYM_AES_GCM_ENCRYPT;
//    }
//    else
//    {
//        ciperOper_en = HSM_SYM_AES_GCM_DECRYPT;
//    }
//    
//    hsmCmdStatus_en = Hsm_Aead_AesGcm_Init(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ciperOper_en, ptr_key, keySize_en, ptr_initVect, ivLen);
//    
//    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
//    }
//    else
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
//    }
//    return ret_aesGcmStatus_en;
//}
//
//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_AddAad(void *ptr_aesGcmCtx, uint8_t *ptr_aad, uint32_t aadLen)
//{
//    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
//    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
//    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;
//
//    hsmCmdStatus_en = Hsm_Aead_AesGcm_AddAad(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ptr_aad, aadLen);
//    
//    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
//    }
//    else
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
//    }
//    return ret_aesGcmStatus_en;
//}
//
//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Cipher(void *ptr_aesGcmCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
//{
//    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
//    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
//    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;
//
//    hsmCmdStatus_en = Hsm_Aead_AesGcm_UpdateCipher(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ptr_inputData, dataLen, ptr_outData);
//    
//    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
//    }
//    else
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
//    }
//    return ret_aesGcmStatus_en;
//}
//
//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Final(void *ptr_aesGcmCtx, uint8_t *ptr_authTag, uint8_t authTagLen)
//{
//    crypto_Aead_Status_E ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL; 
//    hsm_Cmd_Status_E hsmCmdStatus_en = HSM_CMD_ERROR_FAILED;
//    st_Hsm_Aead_AesGcm_Ctx *ptr_aesGcmHsmCtx = (st_Hsm_Aead_AesGcm_Ctx*)ptr_aesGcmCtx;
//    
//    hsmCmdStatus_en = Hsm_Aead_AesGcm_Final(&ptr_aesGcmHsmCtx->aesGcmHsmCmd_st, ptr_aesGcmHsmCtx->aesGcmHsmCtx, ptr_authTag, authTagLen);
//    
//    if(hsmCmdStatus_en == HSM_CMD_SUCCESS)
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_CIPHER_SUCCESS;
//    }
//    else
//    {
//        ret_aesGcmStatus_en = CRYPTO_AEAD_ERROR_CIPFAIL;
//    }
//    return ret_aesGcmStatus_en;
//}

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