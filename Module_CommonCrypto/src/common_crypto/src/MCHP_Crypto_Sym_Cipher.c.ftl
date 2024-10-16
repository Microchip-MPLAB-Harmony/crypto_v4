/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Sym_Cipher.c

  Summary:
    This file contains the source code for the MPLAB Harmony application.

  Description:
    This file contains the source code for the MPLAB Harmony application.  It
    implements the logic of the application's state machine and it may call
    API routines of other MPLAB Harmony modules in the system, such as drivers,
    system services, and middleware.  However, it does not call any of the
    system interfaces (such as the "Initialize" and "Tasks" functions) of any of
    the modules in the system or make any assumptions about when those functions
    are called.  That is the responsibility of the configuration-specific system
    files.
*******************************************************************************/

 
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/MCHP_Crypto_Common.h"
#include "crypto/common_crypto/MCHP_Crypto_Sym_Cipher.h"
<#if    (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true))
    ||  (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) 
    ||  (lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true))
    ||  (lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true))
    ||  (lib_wolfcrypt.CRYPTO_WC_CHACHA20?? &&(lib_wolfcrypt.CRYPTO_WC_CHACHA20 == true))>
#include "crypto/wolfcrypt/crypto_sym_wc_wrapper.h"
</#if>
<#if    (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    ||  (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    ||  (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
    ||  (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
    ||  (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true)) 
    ||  (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
    ||  (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true)) 
    ||  (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true)) 
    ||  (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))
    ||  (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))
    ||  (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
    ||  (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>
<#if (HAVE_CRYPTO_HW_AES_6149_DRIVER?? &&(HAVE_CRYPTO_HW_AES_6149_DRIVER == true))> 
#include "crypto/common_crypto/crypto_sym_aes6149_wrapper.h"
<#elseif (HAVE_CRYPTO_HW_HSM_03785_DRIVER?? &&(HAVE_CRYPTO_HW_HSM_03785_DRIVER == true))>
#include "crypto/common_crypto/crypto_sym_hsm03785_wrapper.h"
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER, HAVE_CRYPTO_HW_HSM_03785_DRIVER -->
<#if (HAVE_CRYPTO_HW_TDES_6150_DRIVER?? &&(HAVE_CRYPTO_HW_TDES_6150_DRIVER == true))>
<#--  #include "crypto/common_crypto/crypto_sym_des6150_wrapper.h" -->
</#if><#-- HAVE_CRYPTO_HW_TDES_6150_DRIVER -->
</#if>
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true))     || (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
    || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))     || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
    || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))   || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))   
    || (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>
	
crypto_Sym_Status_E Crypto_Sym_Aes_Init(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_aesCtx_st == NULL)
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (cipherOpType_en <= CRYPTO_CIOP_INVALID) || (cipherOpType_en >= CRYPTO_CIOP_MAX) )
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_CIPOPER; 
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_OPMODE;
    }         
    else if(
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>             
            (opMode_en != CRYPTO_SYM_OPMODE_XTS) && 
</#if><#-- CRYPTO_WC_AES_XTS || CRYPTO_HW_AES_XTS -->           
            ( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256) )  ) //key length check other than XTS mode 
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;
    }
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))> 
    else if( (opMode_en == CRYPTO_SYM_OPMODE_XTS) && 
                (   (ptr_key == NULL) 
                    ||  ( (keyLen != (uint32_t) (((uint32_t)CRYPTO_AESKEYSIZE_128)*2UL)) 
                            && (keyLen != (uint32_t)(((uint32_t)CRYPTO_AESKEYSIZE_256)*2UL)) )
                )
            )//key length check for XTS mode 
    {
        ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;;
    }
</#if><#-- CRYPTO_WC_AES_XTS || CRYPTO_HW_AES_XTS -->       
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( ptr_initVect == NULL
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true))>           
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_HW_AES_ECB -->             
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>            
            && (opMode_en != CRYPTO_SYM_OPMODE_XTS)
</#if><#-- CRYPTO_WC_AES_XTS || CRYPTO_HW_AES_XTS -->            
            )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        ptr_aesCtx_st->cryptoSessionID =  sessionID;
        ptr_aesCtx_st->symHandlerType_en = handlerType_en;
        ptr_aesCtx_st->ptr_initVect = ptr_initVect;
        ptr_aesCtx_st->ptr_key = ptr_key;
        ptr_aesCtx_st->symAlgoMode_en = opMode_en;
        ptr_aesCtx_st->symKeySize = keyLen;
        ptr_aesCtx_st->symCipherOper_en = cipherOpType_en;
        
        switch(ptr_aesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true)) 
  || (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
  || (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) >
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true))>               
                if(ptr_aesCtx_st->symAlgoMode_en == CRYPTO_SYM_OPMODE_XTS)
                {
                    ret_aesStatus_en = Crypto_Sym_Wc_AesXts_Init((void*)ptr_aesCtx_st->arr_symDataCtx, ptr_aesCtx_st->symCipherOper_en, 
                                                                      ptr_aesCtx_st->ptr_key, ptr_aesCtx_st->symKeySize);
                }
                else
</#if><#-- CRYPTO_WC_AES_XTS -->                 
<#if (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true))>                      
                if(ptr_aesCtx_st->symAlgoMode_en == CRYPTO_SYM_OPMODE_CTR)
                {                   
                    ret_aesStatus_en = Crypto_Sym_Wc_AesCTR_Init((void*)ptr_aesCtx_st->arr_symDataCtx,ptr_aesCtx_st->ptr_key, ptr_aesCtx_st->symKeySize, ptr_aesCtx_st->ptr_initVect);
                }
                else
</#if><#-- CRYPTO_WC_AES_CTR -->    
                {
                
                    ret_aesStatus_en = Crypto_Sym_Wc_Aes_Init((void*)ptr_aesCtx_st->arr_symDataCtx,ptr_aesCtx_st->symCipherOper_en, 
                                                  ptr_aesCtx_st->ptr_key, ptr_aesCtx_st->symKeySize, ptr_aesCtx_st->ptr_initVect);
                }
                break;                
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_WC_AES_CBC || CRYPTO_WC_AES_CTR || CRYPTO_WC_AES_OFB || CRYPTO_WC_AES_CFB1 || CRYPTO_WC_AES_CFB8 || CRYPTO_WC_AES_CFB128 ||  CRYPTO_WC_AES_XTS --> 
<#if (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
  || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true)) || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
  || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true)) || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))
  || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>              
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_AES_6149_DRIVER?? &&(HAVE_CRYPTO_HW_AES_6149_DRIVER == true))>           
                ret_aesStatus_en =  Crypto_Sym_Hw_Aes_Init(ptr_aesCtx_st->symCipherOper_en,  ptr_aesCtx_st->symAlgoMode_en, 
                                                            ptr_aesCtx_st->ptr_key, ptr_aesCtx_st->symKeySize, ptr_aesCtx_st->ptr_initVect);
<#elseif (HAVE_CRYPTO_HW_HSM_03785_DRIVER?? &&(HAVE_CRYPTO_HW_HSM_03785_DRIVER == true))>
                ret_aesStatus_en = Crypto_Sym_Hw_Aes_Init((void*)ptr_aesCtx_st->arr_symDataCtx, ptr_aesCtx_st->symCipherOper_en, ptr_aesCtx_st->symAlgoMode_en, 
                                                                    ptr_aesCtx_st->ptr_key, ptr_aesCtx_st->symKeySize, ptr_aesCtx_st->ptr_initVect);
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER, HAVE_CRYPTO_HW_HSM_03785_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_AES_ECB|| CRYPTO_HW_AES_CBC || CRYPTO_HW_AES_CTR || CRYPTO_HW_AES_OFB || CRYPTO_HW_AES_CFB8 || CRYPTO_HW_AES_CFB16 || CRYPTO_HW_AES_CFB32|| CRYPTO_HW_AES_CFB64
         || CRYPTO_HW_AES_CFB128 || CRYPTO_HW_AES_XTS -->               
            default:
                ret_aesStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_aesStatus_en;
}
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
    || (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true))     || (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
    || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))     || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
    || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))   || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))   
    || (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))>
	
crypto_Sym_Status_E Crypto_Sym_Aes_Cipher(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_aesCtx_st == NULL)
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_INPUTDATA; 
    }
    else if(ptr_outData == NULL)
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else
    {
        switch(ptr_aesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true)) 
  || (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
  || (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true))>           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                if(ptr_aesCtx_st->symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
                {
                    ret_aesStatus_en = Crypto_Sym_Wc_Aes_Encrypt(ptr_aesCtx_st->arr_symDataCtx, ptr_aesCtx_st->symAlgoMode_en, ptr_inputData, dataLen, ptr_outData);
                }
                else if(ptr_aesCtx_st->symCipherOper_en == CRYPTO_CIOP_DECRYPT)
                {
                    ret_aesStatus_en = Crypto_Sym_Wc_Aes_Decrypt(ptr_aesCtx_st->arr_symDataCtx, ptr_aesCtx_st->symAlgoMode_en, ptr_inputData, dataLen, ptr_outData);
                }
                else
                {
                    ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPOPER;
                }
                break;
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_WC_AES_CBC || CRYPTO_WC_AES_CTR || CRYPTO_WC_AES_OFB || CRYPTO_WC_AES_CFB1 || CRYPTO_WC_AES_CFB8 || CRYPTO_WC_AES_CFB128 -->                  
<#if (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
  || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true)) || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
  || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true)) || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))>              
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_AES_6149_DRIVER?? &&(HAVE_CRYPTO_HW_AES_6149_DRIVER == true))> 
                ret_aesStatus_en =  Crypto_Sym_Hw_Aes_Cipher(ptr_inputData, dataLen, ptr_outData);
<#elseif (HAVE_CRYPTO_HW_HSM_03785_DRIVER?? &&(HAVE_CRYPTO_HW_HSM_03785_DRIVER == true))>
                ret_aesStatus_en = Crypto_Sym_Hw_Aes_Cipher((void*)ptr_aesCtx_st->arr_symDataCtx, ptr_inputData, dataLen, ptr_outData);
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER, HAVE_CRYPTO_HW_HSM_03785_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_AES_ECB|| CRYPTO_HW_AES_CBC || CRYPTO_HW_AES_CTR || CRYPTO_HW_AES_OFB || CRYPTO_HW_AES_CFB8 || CRYPTO_HW_AES_CFB16 || CRYPTO_HW_AES_CFB32|| CRYPTO_HW_AES_CFB64
         || CRYPTO_HW_AES_CFB128-->       
            default:
                ret_aesStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesStatus_en; 
}
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_HW_AES_ECB || CRYPTO_WC_AES_CBC || CRYPTO_HW_AES_CBC || CRYPTO_WC_AES_CTR || CRYPTO_HW_AES_CTR|| CRYPTO_WC_AES_OFB || CRYPTO_HW_AES_OFB 
        || CRYPTO_WC_AES_CFB1 || CRYPTO_WC_AES_CFB8 || CRYPTO_HW_AES_CFB8 || CRYPTO_HW_AES_CFB16 || CRYPTO_HW_AES_CFB32 || CRYPTO_HW_AES_CFB64 || CRYPTO_WC_AES_CFB128 || CRYPTO_HW_AES_CFB128 -->
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>

crypto_Sym_Status_E Crypto_Sym_AesXts_Cipher(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_tweak)
{
    crypto_Sym_Status_E ret_aesXtsStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_aesCtx_st == NULL)
    {
        ret_aesXtsStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_aesXtsStat_en = CRYPTO_SYM_ERROR_INPUTDATA; 
    }
    else if( (ptr_outData == NULL) )
    {
        ret_aesXtsStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if(ptr_tweak == NULL)
    {
        ret_aesXtsStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    else
    {
        switch(ptr_aesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true))>           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                if(ptr_aesCtx_st->symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
                {
                    ret_aesXtsStat_en = Crypto_Sym_Wc_AesXts_Encrypt(ptr_aesCtx_st->arr_symDataCtx, ptr_inputData, dataLen, ptr_outData, ptr_tweak);
                }
                else if(ptr_aesCtx_st->symCipherOper_en == CRYPTO_CIOP_DECRYPT)
                {
                    ret_aesXtsStat_en = Crypto_Sym_Wc_AesXts_Decrypt(ptr_aesCtx_st->arr_symDataCtx, ptr_inputData, dataLen, ptr_outData, ptr_tweak);
                }
                else
                {
                    ret_aesXtsStat_en = CRYPTO_SYM_ERROR_CIPOPER;
                }
                break;
</#if><#-- CRYPTO_WC_AES_XTS -->           
<#if (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>                
            case CRYPTO_HANDLER_HW_INTERNAL:
                break;
</#if><#-- CRYPTO_HW_AES_XTS --> 
            default:
                ret_aesXtsStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesXtsStat_en; 
}
</#if><#-- lib_wolfcrypt.CRYPTO_WC_AES_XTS|| CRYPTO_HW_AES_XTS -->

crypto_Sym_Status_E Crypto_Sym_Aes_EncryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_OPMODE;
    }   
    else if(ptr_key == NULL)
	{
		ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;
	}	
	else if(
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>            
            (opMode_en != CRYPTO_SYM_OPMODE_XTS) && 
</#if><#-- CRYPTO_WC_AES_XTS|| CRYPTO_HW_AES_XTS -->             
            ((keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256) ) ) //key length check other than XTS mode 
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;
    }
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>
    else if( (opMode_en == CRYPTO_SYM_OPMODE_XTS) && 
							(keyLen != (uint32_t) (((uint32_t)CRYPTO_AESKEYSIZE_128)*2UL)) 
                            && (keyLen != (uint32_t)(((uint32_t)CRYPTO_AESKEYSIZE_256)*2UL))  
            )//key length check for XTS mode 
    {
        ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;;
    }
</#if><#-- CRYPTO_WC_AES_XTS|| CRYPTO_HW_AES_XTS -->  
    else if( (sessionID <= 0u ) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) >           
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB) 
</#if><#-- CRYPTO_WC_AES_ECB|| CRYPTO_HW_AES_ECB -->             
            )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true))
        || (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
        || (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true))>           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_aesStatus_en = Crypto_Sym_Wc_Aes_EncryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, keyLen, ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_WC_AES_CBC || CRYPTO_WC_AES_CTR || CRYPTO_WC_AES_OFB || CRYPTO_WC_AES_CFB1 || CRYPTO_WC_AES_CFB8 || CRYPTO_WC_AES_CFB128 ||  CRYPTO_WC_AES_XTS -->                 
<#if (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
  || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true)) || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
  || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true)) || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))
  || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>                
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_AES_6149_DRIVER?? &&(HAVE_CRYPTO_HW_AES_6149_DRIVER == true))>
                ret_aesStatus_en = Crypto_Sym_Hw_Aes_EncryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, keyLen, ptr_initVect);
<#elseif (HAVE_CRYPTO_HW_HSM_03785_DRIVER?? &&(HAVE_CRYPTO_HW_HSM_03785_DRIVER == true))>
                ret_aesStatus_en = Crypto_Sym_Hw_Aes_CipherDirect(CRYPTO_CIOP_ENCRYPT, opMode_en, ptr_inputData, dataLen, 
                                                                                ptr_outData, ptr_key, keyLen, ptr_initVect);
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER, HAVE_CRYPTO_HW_HSM_03785_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_AES_ECB|| CRYPTO_HW_AES_CBC || CRYPTO_HW_AES_CTR || CRYPTO_HW_AES_OFB || CRYPTO_HW_AES_CFB8 || CRYPTO_HW_AES_CFB16 || CRYPTO_HW_AES_CFB32|| CRYPTO_HW_AES_CFB64
         || CRYPTO_HW_AES_CFB128 || CRYPTO_HW_AES_XTS -->  
            default:
                ret_aesStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesStatus_en;    
}

crypto_Sym_Status_E Crypto_Sym_Aes_DecryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if(
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>             
            (opMode_en != CRYPTO_SYM_OPMODE_XTS) && 
</#if><#-- CRYPTO_WC_AES_XTS|| CRYPTO_HW_AES_XTS -->              
            ( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256) )  ) //key length check other than XTS mode 
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;
    }
<#if (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true)) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>
    else if( (opMode_en == CRYPTO_SYM_OPMODE_XTS) && 
                (   (ptr_key == NULL) 
                    ||  ( (keyLen != (uint32_t) (((uint32_t)CRYPTO_AESKEYSIZE_128)*2UL)) 
                            && (keyLen != (uint32_t)(((uint32_t)CRYPTO_AESKEYSIZE_256)*2UL)) )
                )
            )//key length check for XTS mode 
    {
        ret_aesStatus_en =  CRYPTO_SYM_ERROR_KEY;;
    }
</#if><#-- CRYPTO_WC_AES_XTS|| CRYPTO_HW_AES_XTS --> 
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_aesStatus_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL)
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) >            
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_AES_ECB|| CRYPTO_HW_AES_ECB -->            
            )
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true))
        || (lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true)) 
        || (lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true)) || (lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true))>             
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_aesStatus_en = Crypto_Sym_Wc_Aes_DecryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, keyLen, ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_WC_AES_CBC || CRYPTO_WC_AES_CTR || CRYPTO_WC_AES_OFB || CRYPTO_WC_AES_CFB1 || CRYPTO_WC_AES_CFB8 || CRYPTO_WC_AES_CFB128 ||  CRYPTO_WC_AES_XTS -->               
<#if (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
  || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) || (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true)) || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
  || (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true)) || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true)) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))
  || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))>                  
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_AES_6149_DRIVER?? &&(HAVE_CRYPTO_HW_AES_6149_DRIVER == true))>
                ret_aesStatus_en = Crypto_Sym_Hw_Aes_DecryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, keyLen, ptr_initVect);
<#elseif (HAVE_CRYPTO_HW_HSM_03785_DRIVER?? &&(HAVE_CRYPTO_HW_HSM_03785_DRIVER == true))>
                ret_aesStatus_en = Crypto_Sym_Hw_Aes_CipherDirect(CRYPTO_CIOP_DECRYPT, opMode_en, ptr_inputData, dataLen, 
                                                                                ptr_outData, ptr_key, keyLen, ptr_initVect);
</#if><#-- HAVE_CRYPTO_HW_AES_6149_DRIVER, HAVE_CRYPTO_HW_HSM_03785_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_AES_ECB|| CRYPTO_HW_AES_CBC || CRYPTO_HW_AES_CTR || CRYPTO_HW_AES_OFB || CRYPTO_HW_AES_CFB8 || CRYPTO_HW_AES_CFB16 || CRYPTO_HW_AES_CFB32|| CRYPTO_HW_AES_CFB64
         || CRYPTO_HW_AES_CFB128 || CRYPTO_HW_AES_XTS -->  
                
            default:
                ret_aesStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesStatus_en;    
}
</#if><#-- CRYPTO_WC_AES_ECB || CRYPTO_HW_AES_ECB || CRYPTO_WC_AES_CBC || CRYPTO_HW_AES_CBC || CRYPTO_WC_AES_CTR || CRYPTO_HW_AES_CTR
         || CRYPTO_WC_AES_OFB || CRYPTO_HW_AES_OFB || CRYPTO_WC_AES_CFB1 || CRYPTO_WC_AES_CFB8 || CRYPTO_HW_AES_CFB8 || CRYPTO_HW_AES_CFB16
         || CRYPTO_HW_AES_CFB32 || CRYPTO_HW_AES_CFB64 || CRYPTO_WC_AES_CFB128 || CRYPTO_HW_AES_CFB128 || CRYPTO_WC_AES_XTS -->
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true))>

crypto_Sym_Status_E Crypto_Sym_Camellia_Init(st_Crypto_Sym_BlockCtx *ptr_camCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_camCtx_st == NULL)
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_key == NULL) || ( (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256) ) ) 
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (cipherOpType_en <= CRYPTO_CIOP_INVALID) || (cipherOpType_en >= CRYPTO_CIOP_MAX) )
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_CIPOPER; 
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if((sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) >           
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->            
            )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        ptr_camCtx_st->cryptoSessionID =  sessionID;
        ptr_camCtx_st->symHandlerType_en = handlerType_en;
        ptr_camCtx_st->ptr_initVect = ptr_initVect;
        ptr_camCtx_st->ptr_key = ptr_key;
        ptr_camCtx_st->symAlgoMode_en = opMode_en;
        ptr_camCtx_st->symKeySize = keyLen;
        ptr_camCtx_st->symCipherOper_en = cipherOpType_en;
        
        switch(ptr_camCtx_st->symHandlerType_en)
        {
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true)) >            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_camStatus_en =  Crypto_Sym_Wc_Camellia_Init(ptr_camCtx_st->arr_symDataCtx, ptr_camCtx_st->ptr_key, ptr_camCtx_st->symKeySize, ptr_camCtx_st->ptr_initVect);
                break;
</#if><#-- lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB || lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC -->                 
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_camStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_camStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Camellia_Cipher(st_Crypto_Sym_BlockCtx *ptr_camCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_camCtx_st == NULL)
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else
    {
        switch(ptr_camCtx_st->symHandlerType_en)
        {
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true)) >           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                if(ptr_camCtx_st->symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
                {
                    ret_camStatus_en = Crypto_Sym_Wc_Camellia_Encrypt(ptr_camCtx_st->arr_symDataCtx, ptr_camCtx_st->symAlgoMode_en, ptr_inputData, dataLen, ptr_outData);
                }
                else if(ptr_camCtx_st->symCipherOper_en == CRYPTO_CIOP_DECRYPT)
                {
                    ret_camStatus_en = Crypto_Sym_Wc_Camellia_Decrypt(ptr_camCtx_st->arr_symDataCtx, ptr_camCtx_st->symAlgoMode_en, ptr_inputData, dataLen, ptr_outData);
                }
                else
                {
                    ret_camStatus_en = CRYPTO_SYM_ERROR_CIPOPER;;
                }
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->                
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_camStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_camStatus_en; 
}

crypto_Sym_Status_E Crypto_Sym_Camellia_EncryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256)  ) 
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) >            
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB) 
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->             
            )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true)) >            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_camStatus_en = Crypto_Sym_Wc_Camellia_EncryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, (keyLen/8u), ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->                
            case CRYPTO_HANDLER_HW_INTERNAL:

                break;
            default:
                ret_camStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_camStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Camellia_DecryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256)  ) 
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_camStatus_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) >            
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->             
            )
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if  (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true)) >            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_camStatus_en = Crypto_Sym_Wc_Camellia_EncryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, (keyLen/8u), ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->                
            case CRYPTO_HANDLER_HW_INTERNAL:

                break;
            default:
                ret_camStatus_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_camStatus_en;
}
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->
<#if  (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
   || (lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true)) || (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>
   
crypto_Sym_Status_E Crypto_Sym_Tdes_Init(st_Crypto_Sym_BlockCtx *ptr_tdesCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_tdesCtx_st == NULL)
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if(ptr_key == NULL) 
    {
       ret_tdesStat_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (cipherOpType_en <= CRYPTO_CIOP_INVALID) || (cipherOpType_en >= CRYPTO_CIOP_MAX) )
    {
       ret_tdesStat_en =  CRYPTO_SYM_ERROR_CIPOPER; 
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_tdesStat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) >           
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_HW_TDES_ECB -->           
            )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        ptr_tdesCtx_st->cryptoSessionID =  sessionID;
        ptr_tdesCtx_st->symHandlerType_en = handlerType_en;
        ptr_tdesCtx_st->ptr_initVect = ptr_initVect;
        ptr_tdesCtx_st->ptr_key = ptr_key;
        ptr_tdesCtx_st->symAlgoMode_en = opMode_en;
        ptr_tdesCtx_st->symCipherOper_en = cipherOpType_en;
        
        switch(ptr_tdesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true)) >          
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_tdesStat_en = Crypto_Sym_Wc_Tdes_Init(ptr_tdesCtx_st->arr_symDataCtx, ptr_tdesCtx_st->symCipherOper_en, 
                                                                       ptr_tdesCtx_st->ptr_key, ptr_tdesCtx_st->ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->
<#if (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) || (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true)) >                 
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_TDES_6150_DRIVER?? &&(HAVE_CRYPTO_HW_TDES_6150_DRIVER == true))>

</#if><#-- HAVE_CRYPTO_HW_TDES_6150_DRIVER -->   
                break;
</#if><#-- CRYPTO_HW_TDES_ECB || CRYPTO_HW_TDES_CBC -->                
            default:
                ret_tdesStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }   
    }
    return ret_tdesStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Tdes_Cipher(st_Crypto_Sym_BlockCtx *ptr_tdesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_tdesCtx_st == NULL)
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else
    {
        switch(ptr_tdesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true)) >            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                if(ptr_tdesCtx_st->symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
                {
                    ret_tdesStat_en = Crypto_Sym_Wc_Tdes_Encrypt(ptr_tdesCtx_st->arr_symDataCtx, ptr_tdesCtx_st->symAlgoMode_en, ptr_inputData, dataLen, ptr_outData);
                }
                else if(ptr_tdesCtx_st->symCipherOper_en == CRYPTO_CIOP_DECRYPT)
                {
                    ret_tdesStat_en = Crypto_Sym_Wc_Tdes_Decrypt(ptr_tdesCtx_st->arr_symDataCtx, ptr_tdesCtx_st->symAlgoMode_en, ptr_inputData, dataLen, ptr_outData);
                }
                else
                {
                    ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPOPER;
                }
                break;
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->
<#if (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) || (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true)) >
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_TDES_6150_DRIVER?? &&(HAVE_CRYPTO_HW_TDES_6150_DRIVER == true))> 

</#if><#-- HAVE_CRYPTO_HW_TDES_6150_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_TDES_ECB || CRYPTO_HW_TDES_CBC -->
            default:
                ret_tdesStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_tdesStat_en; 
}

crypto_Sym_Status_E Crypto_Sym_Tdes_EncryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_tdesStat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) >            
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_HW_TDES_ECB -->             
            )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true)) >           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_tdesStat_en = Crypto_Sym_Wc_Tdes_EncryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->   
<#if (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) || (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true)) >            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_TDES_6150_DRIVER?? &&(HAVE_CRYPTO_HW_TDES_6150_DRIVER == true))> 

</#if><#-- HAVE_CRYPTO_HW_TDES_6150_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_TDES_ECB || CRYPTO_HW_TDES_CBC -->                
            default:
                ret_tdesStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_tdesStat_en; 
}

crypto_Sym_Status_E Crypto_Sym_Tdes_DecryptDirect(crypto_HandlerType_E handlerType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (opMode_en <= CRYPTO_SYM_OPMODE_INVALID) || (opMode_en >= CRYPTO_SYM_OPMODE_MAX) )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_tdesStat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if( (ptr_initVect == NULL) 
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) >           
            && (opMode_en != CRYPTO_SYM_OPMODE_ECB)
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_HW_TDES_ECB -->            
            )
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true)) || (lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true)) >       
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_tdesStat_en = Crypto_Sym_Wc_Tdes_DecryptDirect(opMode_en, ptr_inputData, dataLen, ptr_outData, ptr_key, ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->       
<#if (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) || (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true)) >         
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if (HAVE_CRYPTO_HW_TDES_6150_DRIVER?? &&(HAVE_CRYPTO_HW_TDES_6150_DRIVER == true))> 

</#if><#-- HAVE_CRYPTO_HW_TDES_6150_DRIVER -->
                break;
</#if><#-- CRYPTO_HW_TDES_ECB || CRYPTO_HW_TDES_CBC -->                
            default:
                ret_tdesStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_tdesStat_en; 
}
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_HW_TDES_ECB ||  CRYPTO_WC_TDES_CBC || CRYPTO_HW_TDES_CBC-->
<#if (lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true))>

crypto_Sym_Status_E Crypto_Sym_AesKeyWrap_Init(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, crypto_HandlerType_E handlerType_en, crypto_CipherOper_E cipherOpType_en, 
                                                                                      uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_aesCtx_st == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256)  ) 
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (cipherOpType_en <= CRYPTO_CIOP_INVALID) || (cipherOpType_en >= CRYPTO_CIOP_MAX) )
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_CIPOPER; 
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else
    {
        ptr_aesCtx_st->cryptoSessionID =  sessionID;
        ptr_aesCtx_st->symHandlerType_en = handlerType_en;
        ptr_aesCtx_st->ptr_initVect = ptr_initVect;
        ptr_aesCtx_st->ptr_key = ptr_key;
        ptr_aesCtx_st->symKeySize = keyLen;
        ptr_aesCtx_st->symCipherOper_en = cipherOpType_en;
        
        switch(ptr_aesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true))>            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_aesKwStat_en = Crypto_Sym_Wc_AesKeyWrap_Init(ptr_aesCtx_st->arr_symDataCtx, ptr_aesCtx_st->symCipherOper_en, 
                                                                       ptr_aesCtx_st->ptr_key, ptr_aesCtx_st->symKeySize, ptr_aesCtx_st->ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_AES_KW  -->                
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_aesKwStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_aesKwStat_en;
}

crypto_Sym_Status_E Crypto_Sym_AesKeyWrap_Cipher(st_Crypto_Sym_BlockCtx *ptr_aesCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_aesCtx_st == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else
    {
        switch(ptr_aesCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true))>            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                if(ptr_aesCtx_st->symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
                {
                    ret_aesKwStat_en = Crypto_Sym_Wc_AesKeyWrap(ptr_aesCtx_st->arr_symDataCtx, ptr_inputData, dataLen, ptr_outData, (dataLen+8u), ptr_aesCtx_st->ptr_initVect);
                }
                else if(ptr_aesCtx_st->symCipherOper_en == CRYPTO_CIOP_DECRYPT)
                {
                    ret_aesKwStat_en = Crypto_Sym_Wc_AesKeyUnWrap(ptr_aesCtx_st->arr_symDataCtx, ptr_inputData, dataLen, ptr_outData, (dataLen+8u), ptr_aesCtx_st->ptr_initVect);
                }
                else
                {
                    ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPOPER;
                }
                break;
</#if><#-- CRYPTO_WC_AES_KW  -->               
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_aesKwStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesKwStat_en; 
}

crypto_Sym_Status_E Crypto_Sym_AesKeyWrapDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t inputLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (inputLen < (uint32_t)((8Lu)*(2Lu)) ) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256)  ) 
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true))>           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_aesKwStat_en = Crypto_Sym_Wc_AesKeyWrapDirect(ptr_inputData, inputLen, ptr_outData, (inputLen + 8u), ptr_key, keyLen, ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_AES_KW  -->                
            case CRYPTO_HANDLER_HW_INTERNAL:

                break;
            default:
                ret_aesKwStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesKwStat_en;    
}

crypto_Sym_Status_E Crypto_Sym_AesKeyUnWrapDirect(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t inputLen, 
                                                    uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (inputLen < (uint32_t)((8Lu)*(2Lu))) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if( (ptr_key == NULL) || (keyLen < (uint32_t)CRYPTO_AESKEYSIZE_128) || (keyLen > (uint32_t)CRYPTO_AESKEYSIZE_256) ) 
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_aesKwStat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true))>            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_aesKwStat_en = Crypto_Sym_Wc_AesKeyUnWrapDirect(ptr_inputData, inputLen, ptr_outData, (inputLen + 8u), ptr_key, keyLen, ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_AES_KW  -->                
            case CRYPTO_HANDLER_HW_INTERNAL:

                break;
            default:
                ret_aesKwStat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_aesKwStat_en;    
}
</#if><#-- CRYPTO_WC_AES_KW  -->
<#if (lib_wolfcrypt.CRYPTO_WC_CHACHA20?? &&(lib_wolfcrypt.CRYPTO_WC_CHACHA20 == true))>

crypto_Sym_Status_E Crypto_Sym_ChaCha20_Init(st_Crypto_Sym_StreamCtx *ptr_chaChaCtx_st, crypto_HandlerType_E handlerType_en, 
                                                                    uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_chaChaCtx_st == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if(ptr_key == NULL)  
    {
       ret_chaCha20Stat_en =  CRYPTO_SYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_chaCha20Stat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if(ptr_initVect == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        ptr_chaChaCtx_st->cryptoSessionID =  sessionID;
        ptr_chaChaCtx_st->symHandlerType_en = handlerType_en;
        ptr_chaChaCtx_st->ptr_initVect = ptr_initVect;
        ptr_chaChaCtx_st->ptr_key = ptr_key;
        
        switch(ptr_chaChaCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_CHACHA20?? &&(lib_wolfcrypt.CRYPTO_WC_CHACHA20 == true))>          
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_chaCha20Stat_en = Crypto_Sym_Wc_ChaCha_Init(ptr_chaChaCtx_st->arr_symDataCtx, ptr_chaChaCtx_st->ptr_key, 32, ptr_chaChaCtx_st->ptr_initVect);
                break;
</#if><#-- CRYPTO_WC_CHACHA20  -->                
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_chaCha20Stat_en;
}

crypto_Sym_Status_E Crypto_Sym_ChaCha20_Cipher(st_Crypto_Sym_StreamCtx *ptr_chaChaCtx_st, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if(ptr_chaChaCtx_st == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else
    {
        switch(ptr_chaChaCtx_st->symHandlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_CHACHA20?? &&(lib_wolfcrypt.CRYPTO_WC_CHACHA20 == true))>         
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_chaCha20Stat_en = Crypto_Sym_Wc_ChaChaUpdate(ptr_chaChaCtx_st, ptr_inputData, dataLen, ptr_outData);
                break;
</#if><#-- CRYPTO_WC_CHACHA20  -->                
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_chaCha20Stat_en;
} 

crypto_Sym_Status_E Crypto_Sym_ChaCha20Direct(crypto_HandlerType_E handlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                                uint8_t *ptr_outData, uint8_t *ptr_key, uint8_t *ptr_initVect, uint32_t sessionID)
{
    crypto_Sym_Status_E ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_OUTPUTDATA;
    }
    else if(ptr_key == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_SYM_SESSION_MAX) )
    {
       ret_chaCha20Stat_en =  CRYPTO_SYM_ERROR_SID; 
    }
    else if(ptr_initVect == NULL)
    {
        ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_IV;
    }
    else
    {
        switch(handlerType_en)
        {
<#if (lib_wolfcrypt.CRYPTO_WC_CHACHA20?? &&(lib_wolfcrypt.CRYPTO_WC_CHACHA20 == true))>           
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_chaCha20Stat_en = Crypto_Sym_Wc_ChaChaDirect(ptr_inputData, dataLen, ptr_outData, ptr_key, 32u, ptr_initVect); //key size is 32 bytes for chacha20
                break;
</#if><#-- CRYPTO_WC_CHACHA20  -->               
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
            default:
                ret_chaCha20Stat_en = CRYPTO_SYM_ERROR_HDLR;
                break;
        }
    }
    return ret_chaCha20Stat_en;
}
</#if><#-- CRYPTO_WC_CHACHA20  -->
