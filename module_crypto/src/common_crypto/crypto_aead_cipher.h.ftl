/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_aead_cipher.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef CRYPTO_AEAD_CIPHER_H
#define CRYPTO_AEAD_CIPHER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto_common.h"

typedef enum
{
    CRYPTO_AEAD_ERROR_CIPNOTSUPPTD = -127,
    CRYPTO_AEAD_ERROR_CTX = -126,
    CRYPTO_AEAD_ERROR_KEY = -125,
    CRYPTO_AEAD_ERROR_HDLR = -124,
    CRYPTO_AEAD_ERROR_INPUTDATA = -123,
    CRYPTO_AEAD_ERROR_OUTPUTDATA = -122,        
    CRYPTO_AEAD_ERROR_NONCE = -121,
    CRYPTO_AEAD_ERROR_AUTHTAG = -120,
    CRYPTO_AEAD_ERROR_AAD = -119,        
    CRYPTO_AEAD_ERROR_CIPOPER = -118,
    CRYPTO_AEAD_ERROR_SID = -117,  ////session ID Error
    CRYPTO_AEAD_ERROR_ARG = -116,
    CRYPTO_AEAD_ERROR_CIPFAIL = -115,
    CRYPTO_AEAD_ERROR_AUTHFAIL = -114,        
    CRYPTO_AEAD_CIPHER_SUCCESS = 0,        
}crypto_Aead_Status_E;

// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************
<#if lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM == true))>
typedef struct
{
    uint32_t cryptoSessionID;
    crypto_HandlerType_E aeadHandlerType_en;
    uint8_t *ptr_key;
    uint32_t aeadKeySize;
    uint8_t arr_aeadDataCtx[512]__attribute__((aligned (4)));
}st_Crypto_Aead_AesCcm_ctx;
</#if><#-- CRYPTO_WC_AES_CCM --> 
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM == true))) || (CRYPTO_HW_AES_GCM?? &&(CRYPTO_HW_AES_GCM == true))>

typedef struct
{
    uint32_t cryptoSessionID;
    crypto_HandlerType_E aeadHandlerType_en;
    crypto_CipherOper_E aeadCipherOper_en;
    uint8_t *ptr_key;
    uint32_t aeadKeySize;
    uint8_t *ptr_initVect;
    uint32_t initVectLen;    
    uint8_t arr_aeadDataCtx[512]__attribute__((aligned (4)));
}st_Crypto_Aead_AesGcm_ctx;
</#if><#-- CRYPTO_WC_AES_GCM || CRYPTO_HW_AES_GCM -->
<#if lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX == true))>
 
typedef struct
{
    uint32_t cryptoSessionID;
    crypto_HandlerType_E aeadHandlerType_en;
    crypto_CipherOper_E aeadCipherOper_en;
    uint8_t *ptr_key;
    uint32_t aeadKeySize;
    uint8_t *ptr_aeadNonce;
    uint32_t aeadNonceLen;
    uint8_t arr_aeadDataCtx[1920]__attribute__((aligned (4)));
}st_Crypto_Aead_AesEax_ctx;
</#if><#-- CRYPTO_WC_AES_EAX -->
// *****************************************************************************
<#if lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM == true))>

crypto_Aead_Status_E Crypto_Aead_AesCcm_Init(st_Crypto_Aead_AesCcm_ctx *ptr_aesCcmCtx_st, crypto_HandlerType_E handlerType_en, 
                                              uint8_t *ptr_key, uint32_t keyLen, uint32_t sessionID);

crypto_Aead_Status_E Crypto_Aead_AesCcm_Cipher(st_Crypto_Aead_AesCcm_ctx *ptr_aesCcmCtx_st, crypto_CipherOper_E cipherOper_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_nonce, uint32_t nonceLen, uint8_t *ptr_authTag,
                                                    uint32_t authTagLen, uint8_t *ptr_aad, uint32_t aadLen);
</#if><#-- CRYPTO_WC_AES_CCM --> 
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX == true)))> 

crypto_Aead_Status_E Crypto_Aead_AesEax_Init(st_Crypto_Aead_AesEax_ctx *ptr_aesEaxCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOper_en, 
                                                uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_nonce, uint32_t nonceLen, uint8_t *ptr_aad, uint32_t aadLen, uint32_t sessionID);

crypto_Aead_Status_E Crypto_Aead_AesEax_Cipher(st_Crypto_Aead_AesEax_ctx *ptr_aesEaxCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_aad, uint32_t aadLen);

crypto_Aead_Status_E Crypto_Aead_AesEax_Final(st_Crypto_Aead_AesEax_ctx *ptr_aesEaxCtx_st, uint8_t *ptr_authTag, uint32_t authTagLen);

crypto_Aead_Status_E Crypto_Aead_AesEax_AddAadData(st_Crypto_Aead_AesEax_ctx *ptr_aesEaxCtx_st, uint8_t *ptr_aad, uint32_t aadLen);

crypto_Aead_Status_E Crypto_Aead_AesEax_EncryptAuthDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_nonce, 
                                                            uint32_t nonceLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint32_t authTagLen, uint32_t sessionID);

crypto_Aead_Status_E Crypto_Aead_AesEax_DecryptAuthDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_nonce, 
                                                            uint32_t nonceLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint32_t authTagLen, uint32_t sessionID);
</#if><#-- CRYPTO_WC_AES_EAX -->
<#if ( (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM == true))) || (CRYPTO_HW_AES_GCM?? &&(CRYPTO_HW_AES_GCM == true)))>

<#if (driver_defines?contains("HAVE_CRYPTO_HW_AES_6149_DRIVER")) || (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM == true)))>
crypto_Aead_Status_E Crypto_Aead_AesGcm_Init(st_Crypto_Aead_AesGcm_ctx *ptr_aesGcmCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOper_en, 
                                                              uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t initVectLen, uint32_t sessionID);

crypto_Aead_Status_E Crypto_Aead_AesGcm_AddAadData(st_Crypto_Aead_AesGcm_ctx *ptr_aesGcmCtx_st, uint8_t *ptr_aad, uint32_t aadLen);

crypto_Aead_Status_E Crypto_Aead_AesGcm_Cipher(st_Crypto_Aead_AesGcm_ctx *ptr_aesGcmCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);

crypto_Aead_Status_E Crypto_Aead_AesGcm_Final(st_Crypto_Aead_AesGcm_ctx *ptr_aesGcmCtx_st, uint8_t *ptr_authTag, uint8_t authTagLen);
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER || lib_wolfcrypt.CRYPTO_WC_AES_GCM  -->
<#if (driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")) || (driver_defines?contains("HAVE_CRYPTO_HW_AES_6149_DRIVER")) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM == true)))>

crypto_Aead_Status_E Crypto_Aead_AesGcm_EncryptAuthDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, 
                                                            uint32_t initVectLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen, uint32_t sessionID);

crypto_Aead_Status_E Crypto_Aead_AesGcm_DecryptAuthDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, 
                                                            uint32_t initVectLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen, uint32_t sessionID);
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER || HAVE_CRYPTO_HW_HSM_03785_DRIVER ||CRYPTO_WC_AES_GCM  -->
</#if><#-- CRYPTO_WC_AES_GCM || CRYPTO_HW_AES_GCM -->

#endif //CRYPTO_AEAD_CIPHER_H
