/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Sym_Cipher.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef MCHP_CRYPTO_SYM_CIPHER_H
#define MCHP_CRYPTO_SYM_CIPHER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/MCHP_Crypto_Common.h"
#include "crypto/common_crypto/MCHP_Crypto_Sym_Config.h"

// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************

typedef enum
{
    CRYPTO_SYM_ERROR_CIPNOTSUPPTD = -127,   //Error when Cipher Algorithm is not supported by Crypto software component
    CRYPTO_SYM_ERROR_CTX = -126,            //Error when Context pointer is NULL
    CRYPTO_SYM_ERROR_KEY = -125,            //Error when Key length is above or below its range Or Key pointer is NULL
    CRYPTO_SYM_ERROR_HDLR = -124,           //Error when Handler Type is Invalid
    CRYPTO_SYM_ERROR_OPMODE = -123,         //Error when Operation Mode (ECB, CBC or CFB etc.) is Invalid
    CRYPTO_SYM_ERROR_IV = -122,             //Error when Initialization Vector pointer is NULL or Its length is 0  
    CRYPTO_SYM_ERROR_INPUTDATA = -121,      //Error when input data length is 0 or its pointer is NULL 
    CRYPTO_SYM_ERROR_OUTPUTDATA = -120,     //Error when Output Data pointer is NULL        
    CRYPTO_SYM_ERROR_CIPOPER = -119,        //Error when Cipher Operation (Encryption or Decryption) is Invalid
    CRYPTO_SYM_ERROR_SID = -118,            //Error when Session ID is 0 or Its value is more than Max. session configure in configurations
    CRYPTO_SYM_ERROR_ARG = -117,            //Error when any other argument is Invalid. For example Tweak value pointer is NULL for AES-XTS etc.
    CRYPTO_SYM_ERROR_CIPFAIL = -116,        //Error when Encryption or Decryption operation failed due to any reason
    CRYPTO_SYM_CIPHER_SUCCESS = 0,        
}crypto_Sym_Status_E;

typedef enum
{
    CRYPTO_SYM_OPMODE_INVALID = 0,        
    CRYPTO_SYM_OPMODE_ECB = 1,            
    CRYPTO_SYM_OPMODE_CBC = 2,            
    CRYPTO_SYM_OPMODE_OFB = 3,            
    CRYPTO_SYM_OPMODE_CFB1 = 4,           
    CRYPTO_SYM_OPMODE_CFB8 = 5,          
    CRYPTO_SYM_OPMODE_CFB16 = 6,           
    CRYPTO_SYM_OPMODE_CFB32 = 7,         
    CRYPTO_SYM_OPMODE_CFB64 = 8,          
    CRYPTO_SYM_OPMODE_CFB128 = 9,          
    CRYPTO_SYM_OPMODE_CTR = 10,           
    CRYPTO_SYM_OPMODE_XTS = 11,        
    CRYPTO_SYM_OPMODE_MAX
}crypto_Sym_OpModes_E;


<#if (CRYPTO_WC_CHACHA20?? &&(CRYPTO_WC_CHACHA20 == true))>
typedef struct 
{
    uint32_t cryptoSessionID;
    crypto_HandlerType_E symHandlerType_en;
    uint8_t *ptr_key;
    uint8_t *ptr_initVect;
    uint8_t arr_symDataCtx[70];
}st_Crypto_Sym_StreamCtx;
</#if> <#-- CRYPTO_WC_CHACHA20  -->

<#if (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    || (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    || (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
    || (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
    || (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true))     || (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))     || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
    || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))   || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))   
    || (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true)) 
    || (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true)) >
typedef struct 
{
    uint32_t cryptoSessionID;
    crypto_HandlerType_E symHandlerType_en;
    crypto_CipherOper_E symCipherOper_en;
    crypto_Sym_OpModes_E symAlgoMode_en;
    uint8_t *ptr_key;
    uint32_t symKeySize;
    uint8_t *ptr_initVect;
    uint8_t arr_symDataCtx[500];
}st_Crypto_Sym_BlockCtx;

//AES
crypto_Sym_Status_E Crypto_Sym_Aes_Init(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);

crypto_Sym_Status_E Crypto_Sym_Aes_EncryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);

crypto_Sym_Status_E Crypto_Sym_Aes_DecryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);                                                

<#if (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    || (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    || (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
    || (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
    || (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true))     || (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))     || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
    || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))   || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))   
    || (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))>
crypto_Sym_Status_E Crypto_Sym_Aes_Cipher(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
</#if>

<#if (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true)) >
crypto_Sym_Status_E Crypto_Sym_AesXts_Cipher(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_tweak);
</#if> <#-- CRYPTO_WC_AES_XTS|| CRYPTO_HW_AES_XTS -->

</#if>

<#if  (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true)) || (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true)) >
//Camellia
crypto_Sym_Status_E Crypto_Sym_Camellia_Init(st_Crypto_Sym_BlockCtx *ptr_camCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);
crypto_Sym_Status_E Crypto_Sym_Camellia_Cipher(st_Crypto_Sym_BlockCtx *ptr_camCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Camellia_EncryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);
crypto_Sym_Status_E Crypto_Sym_Camellia_DecryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);
</#if> <#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->

<#if    (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true)) 
    ||  (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
    ||  (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true)) 
    ||  (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>
//DES3 or Triple-DES
crypto_Sym_Status_E Crypto_Sym_Tdes_Init(st_Crypto_Sym_BlockCtx *ptr_tdesCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID);
crypto_Sym_Status_E Crypto_Sym_Tdes_Cipher(st_Crypto_Sym_BlockCtx *ptr_tdesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_Tdes_EncryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID);
crypto_Sym_Status_E Crypto_Sym_Tdes_DecryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID);
</#if> <#-- CRYPTO_WC_TDES_ECB || CRYPTO_HW_TDES_ECB ||  CRYPTO_WC_TDES_CBC || CRYPTO_HW_TDES_CBC-->

<#if (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true))>
//AES-KEYWRAP
crypto_Sym_Status_E Crypto_Sym_AesKeyWrap_Init(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                                                      uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);
crypto_Sym_Status_E Crypto_Sym_AesKeyWrap_Cipher(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
crypto_Sym_Status_E Crypto_Sym_AesKeyWrapDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t inputLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);
crypto_Sym_Status_E Crypto_Sym_AesKeyUnWrapDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t inputLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID);
</#if> <#-- CRYPTO_WC_AES_KW  -->

<#if (CRYPTO_WC_CHACHA20?? &&(CRYPTO_WC_CHACHA20 == true))>
//CHACHA-20
crypto_Sym_Status_E Crypto_Sym_ChaCha20_Init(st_Crypto_Sym_StreamCtx *ptr_chaChaCtx_st, crypto_HandlerType_E handlerType_en, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID);

crypto_Sym_Status_E Crypto_Sym_ChaCha20_Cipher(st_Crypto_Sym_StreamCtx *ptr_chaChaCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);

crypto_Sym_Status_E Crypto_Sym_ChaCha20Direct(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                                uint8_t *ptr_outData, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID);
</#if> <#-- CRYPTO_WC_CHACHA20  -->

#endif //MCHP_CRYPTO_SYM_CIPHER_H
