/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_aead_wc_wrapper.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef CRYPTO_AEAD_WC_WRAPPER_H
#define CRYPTO_AEAD_WC_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
<#if (CRYPTO_WC_AES_CCM?? &&(CRYPTO_WC_AES_CCM == true))>
crypto_Aead_Status_E Crypto_Aead_Wc_AesCcm_Init(void *ptr_aesCcmCtx, uint8_t *ptr_key, uint32_t keySize);
crypto_Aead_Status_E Crypto_Aead_Wc_AesCcm_Cipher(crypto_CipherOper_E cipherOper_en, void *ptr_aesCcmCtx, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_nonce, uint32_t nonceLen, uint8_t *ptr_authTag,
                                                    uint32_t authTagLen, uint8_t *ptr_aad, uint32_t aadLen);
</#if>  <#-- CRYPTO_WC_AES_CCM --> 

<#if (CRYPTO_WC_AES_EAX?? &&(CRYPTO_WC_AES_EAX == true))>
crypto_Aead_Status_E Crypto_Aead_Wc_AesEax_Init(void *ptr_aesEaxCtx, uint8_t *ptr_key, uint32_t keySize, 
                                                uint8_t *ptr_nonce, uint32_t nonceLen, uint8_t *ptr_aad, uint32_t aadLen);
crypto_Aead_Status_E Crypto_Aead_Wc_AesEax_Cipher(crypto_CipherOper_E cipherOper_en, void *ptr_aesEaxCtx, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_aad, uint32_t aadLen);
crypto_Aead_Status_E Crypto_Aead_Wc_AesEax_Final(crypto_CipherOper_E cipherOper_en, void *ptr_aesEaxCtx, uint8_t *ptr_authTag, uint32_t authTagLen);

crypto_Aead_Status_E Crypto_Aead_Wc_AesEax_AddAadData(void *ptr_aesEaxCtx, uint8_t *ptr_aad, uint32_t aadLen);

crypto_Aead_Status_E Crypto_Aead_Wc_AesEax_EncDecAuthDirect(crypto_CipherOper_E cipherOper_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_nonce, 
                                                            uint32_t nonceLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint32_t authTagLen);
</#if>  <#-- CRYPTO_WC_AES_EAX -->

<#if (CRYPTO_WC_AES_GCM?? &&(CRYPTO_WC_AES_GCM == true))>   
crypto_Aead_Status_E Crypto_Aead_Wc_AesGcm_Init(void *ptr_aesGcmCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect, uint32_t initVectLen);
crypto_Aead_Status_E Crypto_Aead_Wc_AesGcm_AddAadData(crypto_CipherOper_E cipherOper_en, void *ptr_aesGcmCtx, uint8_t *ptr_aad, uint32_t aadLen);
crypto_Aead_Status_E Crypto_Aead_Wc_AesGcm_Cipher(crypto_CipherOper_E cipherOper_en, void *ptr_aesGcmCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Aead_Status_E Crypto_Aead_Wc_AesGcm_Final(crypto_CipherOper_E cipherOper_en, void *ptr_aesGcmCtx, uint8_t *ptr_authTag, uint8_t authTagLen);
crypto_Aead_Status_E Crypto_Aead_Wc_AesGcm_EncDecAuthDirect(crypto_CipherOper_E cipherOper_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keySize, 
                                                uint8_t *ptr_initVect, uint32_t initVectLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen);
</#if> <#--CRYPTO_WC_AES_GCM-->

#endif //CRYPTO_AEAD_WC_WRAPPER_H