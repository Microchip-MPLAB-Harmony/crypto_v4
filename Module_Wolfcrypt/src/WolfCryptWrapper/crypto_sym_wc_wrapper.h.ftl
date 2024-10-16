/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_wc_wrapper.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef CRYPTO_SYM_WC_WRAPPER_H
#define CRYPTO_SYM_WC_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) 
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))> 
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
</#if>
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>
  
crypto_Sym_Status_E Crypto_Sym_Wc_AesCTR_Init(void *ptr_aesCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
</#if><#-- CRYPTO_WC_AES_CTR --> 
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) 
    ||  (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>
	
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Encrypt(void *ptr_aesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Decrypt(void *ptr_aesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
</#if>
<#if (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true))>
  
crypto_Sym_Status_E Crypto_Sym_Wc_AesXts_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize);
crypto_Sym_Status_E Crypto_Sym_Wc_AesXts_Encrypt(void *ptr_aesXtsCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_tweak);
crypto_Sym_Status_E Crypto_Sym_Wc_AesXts_Decrypt(void *ptr_aesXtsCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_tweak);
</#if><#-- CRYPTO_WC_AES_XTS --> 
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) 
    ||  (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) 
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true)) 
    ||  (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true))>
	
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_EncryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_DecryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
</#if>
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true)) || (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>

//Camellia
crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_Init(void *ptr_camCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_Encrypt(void *ptr_camCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_Decrypt(void *ptr_camCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_EncryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_DecryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->
<#if    (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true)) 
    ||  (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))>
	
//Triple DES or 3-DES
crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_Init(void *ptr_tdesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_Encrypt(void *ptr_tdesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_Decrypt(void *ptr_tdesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_EncryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_DecryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint8_t *ptr_initVect);
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->
<#if (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true))>

//AES-KEYWRAP
crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyWrap_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyWrap(void *ptr_aesCtx, uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyUnWrap(void *ptr_aesCtx, uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyWrapDirect(uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen,
                                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyUnWrapDirect(uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen,
                                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
</#if><#-- CRYPTO_WC_AES_KW  -->
<#if (CRYPTO_WC_CHACHA20?? &&(CRYPTO_WC_CHACHA20 == true))>

//ChaCha
crypto_Sym_Status_E Crypto_Sym_Wc_ChaCha_Init(void *ptr_chaChaCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Wc_ChaChaUpdate(void *ptr_chaChaCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Wc_ChaChaDirect(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
</#if><#-- CRYPTO_WC_CHACHA20  -->

#endif //CRYPTO_SYM_WC_WRAPPER_H