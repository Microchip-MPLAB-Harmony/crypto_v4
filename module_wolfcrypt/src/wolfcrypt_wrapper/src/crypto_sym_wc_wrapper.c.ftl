/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_wc_wrapper.c

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

#include "crypto/common_crypto/crypto_sym_cipher.h"
#include "crypto/wolfcrypt/crypto_sym_wc_wrapper.h"
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) 
    ||  (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) 
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true)) 
    ||  (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true)) 
    ||  (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true))>
#include "wolfssl/wolfcrypt/aes.h"
</#if>
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true)) || (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>
#include "wolfssl/wolfcrypt/camellia.h"
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->
<#if    (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true)) 
    ||  (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))>
#include "wolfssl/wolfcrypt/des3.h"
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->
<#if (CRYPTO_WC_CHACHA20?? &&(CRYPTO_WC_CHACHA20 == true))>
#include "wolfssl/wolfcrypt/chacha.h"
</#if><#-- CRYPTO_WC_CHACHA20  -->
#include "wolfssl/wolfcrypt/error-crypt.h"

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// ***************************************************************************** 
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true))
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)	
<#elseif (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) ||  (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true))>
static crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
</#if>
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true))
	||	(CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))
	||  (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) 
	||  (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true)) 
	||  (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true))>	
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    int dir = -1;
    if(ptr_aesCtx != NULL)
    {
        if(symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
        {
            dir = AES_ENCRYPTION;
        }
        else if(symCipherOper_en == CRYPTO_CIOP_DECRYPT)
        {
            dir = AES_DECRYPTION;
        }
        else
        {
            ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPOPER;
        }
        if(ret_aesStatus_en != CRYPTO_SYM_ERROR_CIPOPER)
        {
            wcAesStatus = wc_AesSetKey( (Aes*)ptr_aesCtx, (const byte*)ptr_key, (word32)keySize, ptr_initVect, dir);

            if(wcAesStatus == 0)
            {
                ret_aesStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
            }
            else if (wcAesStatus == WC_KEY_SIZE_E)
            {
                ret_aesStatus_en = CRYPTO_SYM_ERROR_KEY;
            }
            else if(wcAesStatus == BAD_FUNC_ARG)
            {
                ret_aesStatus_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_aesStatus_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    }
    else
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    return ret_aesStatus_en;
}
</#if>
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>
   
crypto_Sym_Status_E Crypto_Sym_Wc_AesCTR_Init(void *ptr_aesCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
	crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    ret_aesStatus_en = Crypto_Sym_Wc_Aes_Init(ptr_aesCtx, CRYPTO_CIOP_ENCRYPT, ptr_key, keySize, ptr_initVect);
	
    return ret_aesStatus_en;
}
</#if><#-- CRYPTO_WC_AES_CTR --> 
<#if    (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true)) 
    ||  (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true)) 
    ||  (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true)) 
    ||  (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true)) 
    ||  (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true)) 
    ||  (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true)) 
    ||  (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>
	
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Encrypt(void *ptr_aesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
  
    if(ptr_aesCtx != NULL)
    {
        switch(symAlgoMode_en)
        {
<#if (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true))>       
            case CRYPTO_SYM_OPMODE_ECB:
                wcAesStatus = wc_AesEcbEncrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_ECB -->
<#if (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true))>
            case CRYPTO_SYM_OPMODE_CBC:
                wcAesStatus = wc_AesCbcEncrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CBC -->
<#if (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true))>
            case CRYPTO_SYM_OPMODE_OFB:
                wcAesStatus = wc_AesOfbEncrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_OFB -->
<#if (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true))> 
            case CRYPTO_SYM_OPMODE_CFB1:         
                wcAesStatus = wc_AesCfb1Encrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CFB1 -->
<#if (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true))>                
            case CRYPTO_SYM_OPMODE_CFB8:
                wcAesStatus = wc_AesCfb8Encrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CFB8 -->
<#if (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>               
            case CRYPTO_SYM_OPMODE_CFB128:
                wcAesStatus = wc_AesCfbEncrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;  
</#if><#-- CRYPTO_WC_AES_CFB128 -->                
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>            
            case CRYPTO_SYM_OPMODE_CTR:
                wcAesStatus = wc_AesCtrEncrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CTR --> 
            default:
                ret_aesStatus_en = CRYPTO_SYM_ERROR_OPMODE;
                break;
        } //end of switch
            
        if(wcAesStatus == 0)
        {
            ret_aesStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_aesStatus_en != CRYPTO_SYM_ERROR_OPMODE)
        {
            if(wcAesStatus == BAD_FUNC_ARG)
            {
                ret_aesStatus_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_aesStatus_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
        else
        {
            //do nothing
        }
    } //end of if of argument checking
    else
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    return ret_aesStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_Aes_Decrypt(void *ptr_aesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_aesStatus_En = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
  
    if(ptr_inputData != NULL)
    {
        switch(symAlgoMode_en)
        {
<#if (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true))>      
            case CRYPTO_SYM_OPMODE_ECB:
                wcAesStatus = wc_AesEcbDecrypt( (Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_ECB -->
<#if (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true))>
            case CRYPTO_SYM_OPMODE_CBC:
                wcAesStatus = wc_AesCbcDecrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CBC -->
<#if (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true))>
            case CRYPTO_SYM_OPMODE_OFB:
                wcAesStatus = wc_AesOfbDecrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_OFB -->
<#if (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true))>               
            case CRYPTO_SYM_OPMODE_CFB1:         
                wcAesStatus = wc_AesCfb1Decrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CFB1 -->
<#if (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true))>                  
            case CRYPTO_SYM_OPMODE_CFB8:
                wcAesStatus = wc_AesCfb8Decrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CFB8 -->                
<#if (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>                  
            case CRYPTO_SYM_OPMODE_CFB128:
                wcAesStatus = wc_AesCfbDecrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break; 
</#if><#-- CRYPTO_WC_AES_CFB128 --> 
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>            
            case CRYPTO_SYM_OPMODE_CTR:
                wcAesStatus = wc_AesCtrEncrypt((Aes*)ptr_aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_AES_CTR -->  
            default:
                ret_aesStatus_En = CRYPTO_SYM_ERROR_OPMODE;
                break;
        } //end of switch
            
        if(wcAesStatus == 0)
        {
            ret_aesStatus_En = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_aesStatus_En != CRYPTO_SYM_ERROR_OPMODE)
        {
            if(wcAesStatus == BAD_FUNC_ARG)
            {
                ret_aesStatus_En = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_aesStatus_En  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
        else
        {
            //do nothing
        }
    } //end of if of argument checking
    
    return ret_aesStatus_En;
}
</#if>
<#if (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true))>

crypto_Sym_Status_E Crypto_Sym_Wc_AesXts_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    int dir = 0;
    if(ptr_aesCtx != NULL)
    {
        if(symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
        {
            dir = AES_ENCRYPTION;
        }
        else if(symCipherOper_en == CRYPTO_CIOP_DECRYPT)
        {
            dir = AES_DECRYPTION;
        }
        else
        {
            ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPOPER;
        }
        
        if(ret_aesStatus_en != CRYPTO_SYM_ERROR_CIPOPER)
        {
            wcAesStatus = wc_AesXtsSetKey( (XtsAes*)ptr_aesCtx, (const byte*)ptr_key, (word32)keySize, dir, NULL, 0); 

            if(wcAesStatus == 0)
            {
                ret_aesStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
            }
            else if (wcAesStatus == WC_KEY_SIZE_E)
            {
                ret_aesStatus_en = CRYPTO_SYM_ERROR_KEY;
            }
            else if(wcAesStatus == BAD_FUNC_ARG)
            {
                ret_aesStatus_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_aesStatus_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    }
    else
    {
        ret_aesStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    return ret_aesStatus_en;
}

//Every encryption or decryption call requires different tweak
crypto_Sym_Status_E Crypto_Sym_Wc_AesXts_Encrypt(void *ptr_aesXtsCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_tweak)
{
    crypto_Sym_Status_E ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
  
    int wcAesXtsStatus = BAD_FUNC_ARG;
    if( (ptr_aesXtsCtx!= NULL) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_tweak != NULL) )
    {
        wcAesXtsStatus = wc_AesXtsEncrypt( (XtsAes*)ptr_aesXtsCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen, (const byte*)ptr_tweak, AES_BLOCK_SIZE);
        if(wcAesXtsStatus == 0)
        {
            ret_aesXtsStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcAesXtsStatus == BAD_FUNC_ARG)
        {
           ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_ARG; 
        }
        else
        {
            ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_ARG;
    }
   
    return ret_aesXtsStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_AesXts_Decrypt(void *ptr_aesXtsCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_tweak)
{
    crypto_Sym_Status_E ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    int wcAesXtsStatus = BAD_FUNC_ARG;
    if( (ptr_aesXtsCtx!= NULL) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_tweak != NULL) )
    {
        wcAesXtsStatus = wc_AesXtsDecrypt( (XtsAes*)ptr_aesXtsCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen, (const byte*)ptr_tweak, AES_BLOCK_SIZE);
        
        if(wcAesXtsStatus == 0)
        {
            ret_aesXtsStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcAesXtsStatus == BAD_FUNC_ARG)
        {
           ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_ARG; 
        }
        else
        {
            ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_aesXtsStatus_en = CRYPTO_SYM_ERROR_ARG;
    }
    
    return ret_aesXtsStatus_en;
}
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
                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;    
   
    int wcAesStatus = BAD_FUNC_ARG;
<#if (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true))>    
    if(symAlgoMode_en == CRYPTO_SYM_OPMODE_XTS)
    {           
        XtsAes aesXtsCtx[1];
        wcAesStatus = wc_AesXtsSetKey(aesXtsCtx, (const byte*)ptr_key, (word32)keySize, AES_ENCRYPTION, NULL, 0);
        if(wcAesStatus == 0)
        {
            wcAesStatus = wc_AesXtsEncrypt(aesXtsCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen, (const byte*)ptr_initVect, AES_BLOCK_SIZE);
        }
        ret_aesStat_en = CRYPTO_SYM_ERROR_OPMODE;            
    }
    else
</#if><#-- CRYPTO_WC_AES_XTS -->         
    {
        Aes aesCtx[1];
        wcAesStatus = wc_AesSetKey(aesCtx, (const byte*)ptr_key, (word32)keySize, (const byte*)ptr_initVect, AES_ENCRYPTION);
        if(wcAesStatus == 0)
        {
            switch(symAlgoMode_en)
            {
<#if (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true))>        
                case CRYPTO_SYM_OPMODE_ECB:
                    wcAesStatus = wc_AesEcbEncrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_ECB -->
<#if (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true))>
                case CRYPTO_SYM_OPMODE_CBC:
                    wcAesStatus = wc_AesCbcEncrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_CBC -->
<#if (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true))>
                case CRYPTO_SYM_OPMODE_OFB:
                    wcAesStatus = wc_AesOfbEncrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_OFB -->
<#if (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true))>                     
                case CRYPTO_SYM_OPMODE_CFB1:           
                    wcAesStatus = wc_AesCfb1Encrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_CFB1 -->                    
<#if (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true))>                    
                case CRYPTO_SYM_OPMODE_CFB8:  
                    wcAesStatus = wc_AesCfb8Encrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_CFB8 -->
<#if (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>                    
                case CRYPTO_SYM_OPMODE_CFB128:
                    wcAesStatus = wc_AesCfbEncrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_CFB128 -->                   
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>            
                case CRYPTO_SYM_OPMODE_CTR:
                    wcAesStatus = wc_AesCtrEncrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_AES_CTR --> 
                default:
                    ret_aesStat_en = CRYPTO_SYM_ERROR_OPMODE;
                    break;
            } //end of switch
        }
    }
    if(wcAesStatus == 0)
    {
        ret_aesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
    }
    else if(ret_aesStat_en == CRYPTO_SYM_ERROR_OPMODE)
    {
        //do nothing
    }
    else
    {
        if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_aesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    return ret_aesStat_en;
}
        
crypto_Sym_Status_E Crypto_Sym_Wc_Aes_DecryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;    
  
    int wcAesStatus = BAD_FUNC_ARG;
    if( (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_key != NULL) && (keySize > 0u) )
    {
<#if (CRYPTO_WC_AES_XTS?? &&(CRYPTO_WC_AES_XTS == true))>        
        if(symAlgoMode_en == CRYPTO_SYM_OPMODE_XTS)
        {           
            XtsAes aesXtsCtx[1];
            wcAesStatus = wc_AesXtsSetKey(aesXtsCtx, (const byte*)ptr_key, (word32)keySize, AES_DECRYPTION, NULL, 0);
            if(wcAesStatus == 0)
            {
                wcAesStatus = wc_AesXtsDecrypt(aesXtsCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen, (const byte*)ptr_initVect, AES_BLOCK_SIZE);
            }
        }
        else
</#if><#-- CRYPTO_WC_AES_XTS -->            
        {
            Aes aesCtx[1];
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>  			
			if(symAlgoMode_en == CRYPTO_SYM_OPMODE_CTR)
			{
            	wcAesStatus = wc_AesSetKey(aesCtx, (const byte*)ptr_key, (word32)keySize, (const byte*)ptr_initVect, AES_ENCRYPTION);
			}
			else
</#if><#-- CRYPTO_WC_AES_CTR -->			
			{
				wcAesStatus = wc_AesSetKey(aesCtx, (const byte*)ptr_key, (word32)keySize, (const byte*)ptr_initVect, AES_DECRYPTION);
			}
			
            if(wcAesStatus == 0)
            {
                switch(symAlgoMode_en)
                {
<#if (CRYPTO_WC_AES_ECB?? &&(CRYPTO_WC_AES_ECB == true))>     
                    case CRYPTO_SYM_OPMODE_ECB:
                        wcAesStatus = wc_AesEcbDecrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_ECB -->
<#if (CRYPTO_WC_AES_CBC?? &&(CRYPTO_WC_AES_CBC == true))>
                    case CRYPTO_SYM_OPMODE_CBC:
                        wcAesStatus = wc_AesCbcDecrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_CBC -->
<#if (CRYPTO_WC_AES_OFB?? &&(CRYPTO_WC_AES_OFB == true))>
                    case CRYPTO_SYM_OPMODE_OFB:
                        wcAesStatus = wc_AesOfbDecrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_OFB -->
<#if (CRYPTO_WC_AES_CFB1?? &&(CRYPTO_WC_AES_CFB1 == true))>                         
                    case CRYPTO_SYM_OPMODE_CFB1:           
                        wcAesStatus = wc_AesCfb1Decrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_CFB1 -->
<#if (CRYPTO_WC_AES_CFB8?? &&(CRYPTO_WC_AES_CFB8 == true))>                       
                    case CRYPTO_SYM_OPMODE_CFB8:  
                        wcAesStatus = wc_AesCfb8Decrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_CFB8 -->
<#if (CRYPTO_WC_AES_CFB128?? &&(CRYPTO_WC_AES_CFB128 == true))>                          
                    case CRYPTO_SYM_OPMODE_CFB128:
                        wcAesStatus = wc_AesCfbDecrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_CFB128 -->                       
<#if (CRYPTO_WC_AES_CTR?? &&(CRYPTO_WC_AES_CTR == true))>            
                    case CRYPTO_SYM_OPMODE_CTR:
                        wcAesStatus = wc_AesCtrEncrypt(aesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                        break;
</#if><#-- CRYPTO_WC_AES_CTR --> 
                    default:
                        ret_aesStat_en = CRYPTO_SYM_ERROR_OPMODE;
                        break;
                } //end of switch
            }
        }
        if(wcAesStatus == 0)
        {
            ret_aesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_aesStat_en != CRYPTO_SYM_ERROR_OPMODE)
        {
            if(wcAesStatus == BAD_FUNC_ARG)
            {
                ret_aesStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_aesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
        else
        {
         //do nothing   
        }
    } //end of if of argument checking
    else
    {
        ret_aesStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    return ret_aesStat_en;
}
</#if>
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true)) || (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>

//Camellia
crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_Init(void *ptr_camCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcCamStatus = BAD_FUNC_ARG;
    if(ptr_camCtx != NULL)
    {
        wcCamStatus = wc_CamelliaSetKey( (Camellia*)ptr_camCtx, (const byte*)ptr_key, (word32)keySize, ptr_initVect);
        if(wcCamStatus == 0)
        {
            ret_camStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if (wcCamStatus == BAD_FUNC_ARG)
        {
            ret_camStatus_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_camStatus_en  = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_camStatus_en = CRYPTO_SYM_ERROR_CTX;
    }
    return ret_camStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_Encrypt(void *ptr_camCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcCamStatus = BAD_FUNC_ARG;
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>      
    uint32_t dataBlocks = 0;
    uint32_t dataIndex = 0;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->     
    if( (ptr_camCtx != NULL) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) )
    {
        switch(symAlgoMode_en)
        {
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>           
            case CRYPTO_SYM_OPMODE_ECB:
                dataBlocks = (dataLen / (uint32_t)CAMELLIA_BLOCK_SIZE);
                dataIndex = 0;
                while(dataBlocks > 0u) 
                {
                    wcCamStatus = wc_CamelliaEncryptDirect( (Camellia*)ptr_camCtx, (byte*)&ptr_outData[dataIndex], (const byte*)&ptr_inputData[dataIndex]);
                    dataIndex = dataIndex + (uint32_t)CAMELLIA_BLOCK_SIZE;
                    dataBlocks = dataBlocks - 1u;
                }
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB --> 
<#if (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>                
            case CRYPTO_SYM_OPMODE_CBC:
                wcCamStatus = wc_CamelliaCbcEncrypt( (Camellia*)ptr_camCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_CBC -->                
            default:
                ret_camStatus_en = CRYPTO_SYM_ERROR_OPMODE;
                break;
        } //end of switch
            
        if(wcCamStatus == 0)
        {
            ret_camStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_camStatus_en == CRYPTO_SYM_ERROR_OPMODE)
        {
            //do nothing
        }
        else
        {
            if(wcCamStatus == BAD_FUNC_ARG)
            {
                ret_camStatus_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_camStatus_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    
    return ret_camStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_Decrypt(void *ptr_camCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_camStatus_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcCamStatus = BAD_FUNC_ARG;
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>     
    uint32_t dataBlocks = 0;
    uint32_t dataIndex = 0;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->    
    if( (ptr_camCtx != NULL) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) )
    {
        switch(symAlgoMode_en)
        {    
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>  
            case CRYPTO_SYM_OPMODE_ECB:
                dataBlocks = (dataLen / (uint32_t)CAMELLIA_BLOCK_SIZE);
                dataIndex = 0;
                while(dataBlocks > 0u) 
                {
                    wcCamStatus = wc_CamelliaDecryptDirect( (Camellia*)ptr_camCtx, (byte*)&ptr_outData[dataIndex], (const byte*)&ptr_inputData[dataIndex]);
                    dataIndex = dataIndex + (uint32_t)CAMELLIA_BLOCK_SIZE;
                    dataBlocks = dataBlocks - 1u;
                }
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB --> 
<#if (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>                
            case CRYPTO_SYM_OPMODE_CBC:
                wcCamStatus = wc_CamelliaCbcDecrypt( (Camellia*)ptr_camCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_CAMELLIA_CBC -->                
            default:
                ret_camStatus_en = CRYPTO_SYM_ERROR_OPMODE;
                break;
        } //end of switch
            
        if(wcCamStatus == 0)
        {
            ret_camStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_camStatus_en == CRYPTO_SYM_ERROR_OPMODE)
        {
          //Do nothing   
        }
        else
        {
            if(wcCamStatus == BAD_FUNC_ARG)
            {
                ret_camStatus_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_camStatus_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    
    return ret_camStatus_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_EncryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_camStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcCamStatus = BAD_FUNC_ARG;  
    if( (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_key != NULL) && (keySize > 0u) )
    {
        Camellia camCtx[1];
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>         
        uint32_t dataBlocks = 0;
        uint32_t dataIndex = 0;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->        
        wcCamStatus = wc_CamelliaSetKey(camCtx,(const byte*)ptr_key, (word32)keySize, (const byte*)ptr_initVect);
        if(wcCamStatus == 0)
        {
            switch(symAlgoMode_en)
            {
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>              
                case CRYPTO_SYM_OPMODE_ECB:
                    dataBlocks = (dataLen / (uint32_t)CAMELLIA_BLOCK_SIZE);
                    while(dataBlocks > 0u) 
                    {
                        wcCamStatus = wc_CamelliaEncryptDirect(camCtx, (byte*)&ptr_outData[dataIndex], (const byte*)&ptr_inputData[dataIndex]);

                        if(wcCamStatus != 0)
                        {
                            break;
                        }
                        dataIndex = dataIndex + (uint32_t)CAMELLIA_BLOCK_SIZE;
                        dataBlocks = dataBlocks - 1u;
                    }
                    break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->                     
<#if (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>    
                case CRYPTO_SYM_OPMODE_CBC:
                    wcCamStatus = wc_CamelliaCbcEncrypt(camCtx,(byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break; 
</#if><#-- CRYPTO_WC_CAMELLIA_CBC -->                
                default:
                    ret_camStat_en = CRYPTO_SYM_ERROR_OPMODE;
                    break;
            } //end of switch
        }    
        if(wcCamStatus == 0)
        {
            ret_camStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_camStat_en == CRYPTO_SYM_ERROR_OPMODE)
        {
         //do nothing   
        }
        else
        {
            if(wcCamStatus == BAD_FUNC_ARG)
            {
                ret_camStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_camStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    else
    {
        ret_camStat_en = CRYPTO_SYM_ERROR_ARG;
    }     
    return ret_camStat_en;    
}

crypto_Sym_Status_E Crypto_Sym_Wc_Camellia_DecryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_camStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcCamStatus = BAD_FUNC_ARG;
    
    if( (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_key != NULL) && (keySize > 0u) )
    {
        Camellia camCtx[1];
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>         
        uint32_t dataBlocks;
        uint32_t dataIndex = 0;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB -->       
        wcCamStatus = wc_CamelliaSetKey(camCtx,(const byte*)ptr_key, (word32)keySize, (const byte*)ptr_initVect);
        if(wcCamStatus == 0)
        {
            switch(symAlgoMode_en)
            {
<#if (CRYPTO_WC_CAMELLIA_ECB?? &&(CRYPTO_WC_CAMELLIA_ECB == true))>                 
                case CRYPTO_SYM_OPMODE_ECB:
                    dataBlocks = (dataLen / (uint32_t)CAMELLIA_BLOCK_SIZE);
                    while(dataBlocks > 0u) 
                    {
                        wcCamStatus = wc_CamelliaDecryptDirect(camCtx, (byte*)&ptr_outData[dataIndex], (const byte*)&ptr_inputData[dataIndex]);

                        if(wcCamStatus != 0)
                        {
                            break;
                        }
                        dataIndex = dataIndex + (uint32_t)CAMELLIA_BLOCK_SIZE;
                        dataBlocks = dataBlocks - 1u;
                    }
                    break;
</#if><#-- CRYPTO_WC_CAMELLIA_ECB --> 
<#if (CRYPTO_WC_CAMELLIA_CBC?? &&(CRYPTO_WC_CAMELLIA_CBC == true))>                    
                case CRYPTO_SYM_OPMODE_CBC:
                    wcCamStatus = wc_CamelliaCbcDecrypt(camCtx,(byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break; 
</#if><#-- CRYPTO_WC_CAMELLIA_CBC -->                    
                default:
                    ret_camStat_en = CRYPTO_SYM_ERROR_OPMODE;
                    break;
            } //end of switch
        }
        else
        {
            //do nothing
        }
        if(wcCamStatus == 0)
        {
            ret_camStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_camStat_en == CRYPTO_SYM_ERROR_OPMODE)
        {
          //do nothing   
        }
        else
        {
            if(wcCamStatus == BAD_FUNC_ARG)
            {
                ret_camStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_camStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    else
    {
        ret_camStat_en = CRYPTO_SYM_ERROR_ARG;
    }
     
    return ret_camStat_en;    
}
</#if><#-- CRYPTO_WC_CAMELLIA_ECB || CRYPTO_WC_CAMELLIA_CBC -->
<#if    (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true)) 
    ||  (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))>
	
//Triple DES or 3-DES
crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_Init(void *ptr_tdesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcTdesStat = BAD_FUNC_ARG;
    int dir = -1;
    if(ptr_tdesCtx != NULL)
    {
        if(symCipherOper_en == CRYPTO_CIOP_ENCRYPT)
        {
            dir = DES_ENCRYPTION;
        }
        else if(symCipherOper_en == CRYPTO_CIOP_DECRYPT)
        {
            dir = DES_DECRYPTION;
        }
        else
        {
            ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPOPER;
        }
        if(ret_tdesStat_en != CRYPTO_SYM_ERROR_CIPOPER)
        {
            wcTdesStat = wc_Des3_SetKey((Des3*)ptr_tdesCtx, (const byte*)ptr_key, (const byte*)ptr_initVect, dir);
        
            if(wcTdesStat == 0)
            {
                ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
            }
            else if (wcTdesStat == BAD_FUNC_ARG)
            {
                ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_tdesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    }
    else
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    return ret_tdesStat_en;
    
}

crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_Encrypt(void *ptr_tdesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcTdesStat = BAD_FUNC_ARG;
    if( (ptr_tdesCtx != NULL) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) )
    {
        switch(symAlgoMode_en)
        { 
<#if (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true))>            
            case CRYPTO_SYM_OPMODE_ECB:
                wcTdesStat = wc_Des3_EcbEncrypt( (Des3*)ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_TDES_ECB -->
<#if (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))>                
            case CRYPTO_SYM_OPMODE_CBC:
                wcTdesStat = wc_Des3_CbcEncrypt( (Des3*)ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_TDES_CBC -->                
            default:
                ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
                break;
        } //end of switch
            
        if(wcTdesStat == 0)
        {
            ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_tdesStat_en != CRYPTO_SYM_ERROR_OPMODE)
        {
            if(wcTdesStat == BAD_FUNC_ARG)
            {
                ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_tdesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
        else
        {
            //do nothing
        }
    } //end of if of argument checking
    
    return ret_tdesStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_Decrypt(void *ptr_tdesCtx, crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcTdesStat = BAD_FUNC_ARG;
    if( (ptr_tdesCtx != NULL) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) )
    {
        switch(symAlgoMode_en)
        {
<#if (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true))>            
            case CRYPTO_SYM_OPMODE_ECB:
                wcTdesStat = wc_Des3_EcbDecrypt( (Des3*)ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_TDES_ECB -->                
<#if (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))> 
            case CRYPTO_SYM_OPMODE_CBC:
                wcTdesStat = wc_Des3_CbcDecrypt( (Des3*)ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_TDES_CBC -->                
            default:
                ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
                break;
        } //end of switch
            
        if(wcTdesStat == 0)
        {
            ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_tdesStat_en == CRYPTO_SYM_ERROR_OPMODE)
        {
            //do nothing
        }
        else
        {
            if(wcTdesStat == BAD_FUNC_ARG)
            {
                ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_tdesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    else
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    
    return ret_tdesStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_EncryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcTdesStat = BAD_FUNC_ARG;
    
    if( (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_key != NULL) )
    {
        Des3 ptr_tdesCtx[1];
        wcTdesStat = wc_Des3_SetKey(ptr_tdesCtx, (const byte*)ptr_key, (const byte*)ptr_initVect, DES_ENCRYPTION);
        if(wcTdesStat == 0)
        {
            switch(symAlgoMode_en)
            {
<#if (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true))>                
                case CRYPTO_SYM_OPMODE_ECB:
                    wcTdesStat = wc_Des3_EcbEncrypt(ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_TDES_ECB -->
<#if (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))>                     
                case CRYPTO_SYM_OPMODE_CBC:
                    wcTdesStat = wc_Des3_CbcEncrypt(ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break; 
</#if><#-- CRYPTO_WC_TDES_CBC -->                    
                default:
                    ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
                    break;
            } //end of switch
        }
        else
        {
            ret_tdesStat_en = CRYPTO_SYM_ERROR_KEY;
        }
        if(wcTdesStat == 0)
        {
            ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_tdesStat_en == CRYPTO_SYM_ERROR_OPMODE)
        {
            //do nothing
        }
        else
        {
            if(wcTdesStat == BAD_FUNC_ARG)
            {
                ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_tdesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    else
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    
    return ret_tdesStat_en;    
}

crypto_Sym_Status_E Crypto_Sym_Wc_Tdes_DecryptDirect(crypto_Sym_OpModes_E symAlgoMode_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,
                                                                    uint8_t *ptr_key, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcTdesStat = BAD_FUNC_ARG;
    
    if( (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_key != NULL) )
    {
        Des3 ptr_tdesCtx[1];
        wcTdesStat = wc_Des3_SetKey(ptr_tdesCtx, (const byte*)ptr_key, (const byte*)ptr_initVect, DES_DECRYPTION);
        if(wcTdesStat == 0)
        {
            switch(symAlgoMode_en)
            {
<#if (CRYPTO_WC_TDES_ECB?? &&(CRYPTO_WC_TDES_ECB == true))>                 
                case CRYPTO_SYM_OPMODE_ECB:
                    wcTdesStat = wc_Des3_EcbDecrypt(ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break;
</#if><#-- CRYPTO_WC_TDES_ECB -->                    
<#if (CRYPTO_WC_TDES_CBC?? &&(CRYPTO_WC_TDES_CBC == true))>                     
                case CRYPTO_SYM_OPMODE_CBC:
                    wcTdesStat = wc_Des3_CbcDecrypt(ptr_tdesCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32)dataLen);
                    break; 
</#if><#-- CRYPTO_WC_TDES_CBC -->                    
                default:
                    ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
                    break;
            } //end of switch
        }    
        if(wcTdesStat == 0)
        {
            ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(ret_tdesStat_en == CRYPTO_SYM_ERROR_OPMODE)
        {
            //do nothing   
        }
        else
        {
            if(wcTdesStat == BAD_FUNC_ARG)
            {
                ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
            }
            else
            {
                ret_tdesStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
            }
        }
    } //end of if of argument checking
    else
    {
        ret_tdesStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    
    return ret_tdesStat_en;    
}
</#if><#-- CRYPTO_WC_TDES_ECB || CRYPTO_WC_TDES_CBC -->
<#if (CRYPTO_WC_AES_KW?? &&(CRYPTO_WC_AES_KW == true))>

//AES-KW
crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyWrap_Init(void *ptr_aesCtx, crypto_CipherOper_E symCipherOper_en, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    ret_aesKwStat_en = Crypto_Sym_Wc_Aes_Init( (Aes*)ptr_aesCtx, symCipherOper_en, ptr_key, keySize, ptr_initVect);
    return ret_aesKwStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyWrap(void *ptr_aesCtx, uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcAesKwStat = -1;
    if(ptr_aesCtx == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (ptr_outData == NULL) || (inputLen == 0u) || (outputLen == 0u) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    else
    {
        wcAesKwStat = wc_AesKeyWrap_ex( (Aes*)ptr_aesCtx, (const byte*)ptr_inputData, (word32)inputLen, (byte*)ptr_outData, (word32)outputLen, (const byte*)ptr_initVect);
   
        if(wcAesKwStat == (int)((int)inputLen + (int)KEYWRAP_BLOCK_SIZE) )
        {
            ret_aesKwStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcAesKwStat == BAD_FUNC_ARG)
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    
    return ret_aesKwStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyUnWrap(void *ptr_aesCtx, uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen, uint8_t *ptr_initVect)
{  
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    int wcAesKwStat = -1;
    if(ptr_aesCtx == NULL)
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_CTX;
    }
    else if( (ptr_inputData == NULL) || (ptr_outData == NULL) || (inputLen == 0u) || (outputLen == 0u) || (outputLen < inputLen) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    else
    {
        wcAesKwStat = wc_AesKeyUnWrap_ex( (Aes*)ptr_aesCtx, (const byte*)ptr_inputData, (word32)inputLen, (byte*)ptr_outData, (word32)outputLen, (const byte*)ptr_initVect);
   
        if(wcAesKwStat == (int)((int)inputLen - (int)KEYWRAP_BLOCK_SIZE) )
        {
            ret_aesKwStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcAesKwStat == BAD_FUNC_ARG)
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    return ret_aesKwStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyWrapDirect(uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen,
                                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;    
    int wcAesKwStat = -1;
    if( (ptr_inputData == NULL) || (inputLen < (uint32_t)((8Lu)*(2Lu))) || (ptr_outData == NULL) || (outputLen == 0u))
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    else if( (ptr_key == NULL) && (keySize > 0u) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_KEY;
    }
    else
    {
        wcAesKwStat = wc_AesKeyWrap( (const byte*)ptr_key, (word32)keySize, (const byte*)ptr_inputData, (word32)inputLen, (byte*)ptr_outData, (word32)outputLen, (const byte*)ptr_initVect);
    
        if(wcAesKwStat == (int)((int)inputLen + (int)KEYWRAP_BLOCK_SIZE) )
        {
            ret_aesKwStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcAesKwStat == BAD_FUNC_ARG)
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }     
    }
    return ret_aesKwStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_AesKeyUnWrapDirect(uint8_t *ptr_inputData, uint32_t inputLen, uint8_t *ptr_outData, uint32_t outputLen,
                                                                        uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
    
    int wcAesKwStat = -1;
    if( (ptr_inputData == NULL) || (inputLen < (uint32_t)((8Lu)*(2Lu))) || (ptr_outData == NULL) || (outputLen == 0u))
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    else if( (ptr_key == NULL) && (keySize > 0u) )
    {
        ret_aesKwStat_en = CRYPTO_SYM_ERROR_KEY;
    }
    else
    {
        wcAesKwStat = wc_AesKeyUnWrap( (const byte*)ptr_key, (word32)keySize, (const byte*)ptr_inputData, (word32)inputLen, (byte*)ptr_outData, (word32)outputLen, (const byte*)ptr_initVect);
    
        if(wcAesKwStat == (int)((int)inputLen - (int)KEYWRAP_BLOCK_SIZE) )
        {
            ret_aesKwStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcAesKwStat == BAD_FUNC_ARG)
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_aesKwStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    return ret_aesKwStat_en;
}
</#if><#-- CRYPTO_WC_AES_KW  -->
<#if (CRYPTO_WC_CHACHA20?? &&(CRYPTO_WC_CHACHA20 == true))>

//ChaCha20
crypto_Sym_Status_E Crypto_Sym_Wc_ChaCha_Init(void *ptr_chaChaCtx, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_chaChaStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;   
    int wcChaChaStatus = BAD_FUNC_ARG;
    if(ptr_chaChaCtx != NULL)
    {
        wcChaChaStatus = wc_Chacha_SetKey( (ChaCha*)ptr_chaChaCtx, (const byte*)ptr_key, (word32)keySize);
        if(wcChaChaStatus == 0)
        {
            word32 counter = 0;
            
            counter = (word32)( ((word32)ptr_initVect[12]<<24u) | ((word32)ptr_initVect[13]<<16u) | ((word32)ptr_initVect[14] << 8u) | ((word32)ptr_initVect[15]));
            
            wcChaChaStatus = wc_Chacha_SetIV( (ChaCha*)ptr_chaChaCtx, (const byte*) ptr_initVect, counter);
        }
        if(wcChaChaStatus == 0)
        {
            ret_chaChaStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if (wcChaChaStatus == WC_KEY_SIZE_E)
        {
            ret_chaChaStat_en = CRYPTO_SYM_ERROR_KEY;
        }
        else if(wcChaChaStatus == BAD_FUNC_ARG)
        {
            ret_chaChaStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_chaChaStat_en  = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_chaChaStat_en = CRYPTO_SYM_ERROR_CTX;
    }       
    return ret_chaChaStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_ChaChaUpdate(void *ptr_chaChaCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    crypto_Sym_Status_E ret_chaChaStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD; 
    int wcChaChaStatus = BAD_FUNC_ARG;
    if( (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) )
    {
        //This function processes the text from the buffer input, encrypts or decrypts it, and stores the result in the buffer output
        wcChaChaStatus = wc_Chacha_Process(ptr_chaChaCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32) dataLen);
        if(wcChaChaStatus == 0)
        {
            ret_chaChaStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcChaChaStatus == BAD_FUNC_ARG)
        {
            ret_chaChaStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_chaChaStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_chaChaStat_en = CRYPTO_SYM_ERROR_ARG;
    }
    return ret_chaChaStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Wc_ChaChaDirect(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_chaChaStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;    
    int wcChaChaStatus = BAD_FUNC_ARG;
    if( ( (keySize >= 16u) && (keySize <= 32u) ) && (ptr_inputData != NULL) && (dataLen > 0u) && (ptr_outData != NULL) && (ptr_key != NULL) && (ptr_initVect != NULL))
    {
        ChaCha chaChaCtx[1];
        wcChaChaStatus = wc_Chacha_SetKey(chaChaCtx, (const byte*)ptr_key, (word32)keySize);
        if(wcChaChaStatus == 0)
        {
            word32 counter = 0;
            counter = (word32) (((word32)ptr_initVect[12]<<24u) | ((word32)ptr_initVect[13]<<16u) | ((word32)ptr_initVect[14] << 8u) | ((word32)ptr_initVect[15]));
            wcChaChaStatus = wc_Chacha_SetIV(chaChaCtx, (const byte*) ptr_initVect, counter);
            if(wcChaChaStatus == 0)
            {
                //This function processes the text from the buffer input, encrypts or decrypts it, and stores the result in the buffer output
               wcChaChaStatus = wc_Chacha_Process(chaChaCtx, (byte*)ptr_outData, (const byte*)ptr_inputData, (word32) dataLen);
            }
            else
            {
                ret_chaChaStat_en = CRYPTO_SYM_ERROR_ARG;
            }
        }
        if(wcChaChaStatus == 0)
        {
            ret_chaChaStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(wcChaChaStatus == BAD_FUNC_ARG)
        {
            ret_chaChaStat_en = CRYPTO_SYM_ERROR_ARG;
        }
        else
        {
            ret_chaChaStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_chaChaStat_en = CRYPTO_SYM_ERROR_ARG;
    }   
    return ret_chaChaStat_en;
}
</#if><#-- CRYPTO_WC_CHACHA20  -->
