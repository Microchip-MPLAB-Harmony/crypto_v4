/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_hsm03785_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware AES.

  Description:
    This source file contains the wrapper interface to access the symmetric 
    AES algorithms in the AES hardware driver for Microchip microcontrollers.
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

#include "crypto/common_crypto/crypto_sym_cipher.h"
#include "crypto/drivers/wrapper/crypto_sym_hsm03785_wrapper.h"
#include "crypto/drivers/driver/hsm_sym.h"
#include "crypto/drivers/wrapper/crypto_hsm03785_common_wrapper.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************
<#if    (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    ||  (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    ||  (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true))>
static hsm_Sym_Aes_ModeTypes_E Crypto_Sym_Hw_Aes_GetOpMode(crypto_Sym_OpModes_E opMode_en)
{
    hsm_Sym_Aes_ModeTypes_E ret_modeType_en = HSM_SYM_AES_OPMODE_INVALID;
    
    switch(opMode_en)
    {
<#if (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true))>	
        case CRYPTO_SYM_OPMODE_ECB:
            ret_modeType_en = HSM_SYM_AES_OPMODE_ECB;
        break;
</#if>  
<#if (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true))>       
        case CRYPTO_SYM_OPMODE_CBC:
            ret_modeType_en = HSM_SYM_AES_OPMODE_CBC;
        break;
</#if> 
<#if (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) >        
        case CRYPTO_SYM_OPMODE_CTR:
            ret_modeType_en = HSM_SYM_AES_OPMODE_CTR;
        break;
</#if>          
        default:
            ret_modeType_en = HSM_SYM_AES_OPMODE_INVALID;
        break;      
    };

    return ret_modeType_en;
}
</#if>
<#if 	(CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
    ||  (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>
	
//static hsm_Sym_Tdes_ModeTypes_E Crypto_Sym_Hw_Tdes_GetOpMode(crypto_Sym_OpModes_E opMode_en)
//{
//    hsm_Sym_Tdes_ModeTypes_E ret_modeType_en = HSM_SYM_DES_OPMODE_ECB;
//    
//    switch(opMode_en)
//    {
//        case CRYPTO_SYM_OPMODE_ECB:
//            ret_modeType_en = HSM_SYM_DES_OPMODE_ECB;
//        break;
//        
//        case CRYPTO_SYM_OPMODE_CBC:
//            ret_modeType_en = HSM_SYM_DES_OPMODE_CBC;
//        break;
//         
//        default:
//            ret_modeType_en = HSM_SYM_DES_OPMODE_ECB;
//        break;      
//    };
//
//    return ret_modeType_en;
//}
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Symmetric Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
<#if    (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    ||  (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    ||  (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true))>
crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Init(void *ptr_aesCtx, crypto_CipherOper_E cipherOpType_en, crypto_Sym_OpModes_E opMode_en, 
                                                                            uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD; 
    hsm_Aes_KeySize_E keySize_en = HSM_SYM_AES_KEY_128;
    hsm_Sym_Aes_ModeTypes_E modeType_en = HSM_SYM_AES_OPMODE_INVALID;
    
    modeType_en = Crypto_Sym_Hw_Aes_GetOpMode(opMode_en);
    
    if(modeType_en != HSM_SYM_AES_OPMODE_INVALID)
    {
        keySize_en = Crypto_Hw_Aes_GetKeySize(keySize);
        
        if(cipherOpType_en == CRYPTO_CIOP_ENCRYPT)
        {
            Hsm_Sym_Aes_Init( (st_Hsm_Sym_Aes_Cmd *)ptr_aesCtx, modeType_en, HSM_SYM_AES_ENCRYPT, ptr_key, keySize_en, ptr_initVect, 0U);
            ret_aesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else if(cipherOpType_en ==  CRYPTO_CIOP_DECRYPT)
        {
            Hsm_Sym_Aes_Init( (st_Hsm_Sym_Aes_Cmd *)ptr_aesCtx, modeType_en, HSM_SYM_AES_DECRYPT, ptr_key, keySize_en, ptr_initVect, 0U);
            ret_aesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
        }
        else
        {
            ret_aesStat_en = CRYPTO_SYM_ERROR_CIPOPER;
        }
    }
    else
    {
        ret_aesStat_en = CRYPTO_SYM_ERROR_OPMODE;
    }
    
    return ret_aesStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Cipher(void *ptr_aesCtx, uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut)
{
    crypto_Sym_Status_E ret_aesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD; 
    hsm_Cmd_Status_E hsmAesStat_en = HSM_CMD_ERROR_FAILED;
    hsmAesStat_en =  Hsm_Sym_Aes_Cipher( (st_Hsm_Sym_Aes_Cmd *)ptr_aesCtx, ptr_dataIn, dataLen, ptr_dataOut);
    
    if(hsmAesStat_en == HSM_CMD_SUCCESS)
    {
        ret_aesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
    }
    else
    {
        ret_aesStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
    }
    return ret_aesStat_en;
}

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_CipherDirect(crypto_CipherOper_E cipherOpType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect)
{
    crypto_Sym_Status_E ret_aesStatus_en = CRYPTO_SYM_ERROR_CIPFAIL;
    st_Hsm_Sym_Aes_Cmd aesCtx_st[1];
    
    ret_aesStatus_en = Crypto_Sym_Hw_Aes_Init((void *)aesCtx_st, cipherOpType_en, opMode_en, ptr_key, keyLen, ptr_initVect);
    if(ret_aesStatus_en == CRYPTO_SYM_CIPHER_SUCCESS)
    {
        ret_aesStatus_en = Crypto_Sym_Hw_Aes_Cipher((void *)aesCtx_st, ptr_inputData, dataLen, ptr_outData);
    }
    else
    {
        //do nothing
    }
    return ret_aesStatus_en; 
}
</#if>
<#if 	(CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
    ||  (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>
//crypto_Sym_Status_E Crypto_Sym_Hw_Tdes_Init(void *ptr_tdesCtx, crypto_CipherOper_E cipherOpType_en, 
//                                            crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint8_t *ptr_initVect)
//{
//    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD; 
//    hsm_Sym_Tdes_ModeTypes_E modeType_en = HSM_SYM_DES_OPMODE_ECB;
//   
//    if( (opMode_en == CRYPTO_SYM_OPMODE_ECB) || (opMode_en == CRYPTO_SYM_OPMODE_CBC) )
//    {
//        modeType_en = Crypto_Sym_Hw_Tdes_GetOpMode(opMode_en);
//     
//        if(cipherOpType_en == CRYPTO_CIOP_ENCRYPT)
//        {
//            Hsm_Sym_Tdes_Init( (st_Hsm_Sym_Tdes_Cmd*)ptr_tdesCtx, modeType_en, HSM_CMD_DES_ENCRYPT, ptr_key, ptr_initVect, 0);
//            ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
//        }
//        else if(cipherOpType_en == CRYPTO_CIOP_DECRYPT)
//        {
//            Hsm_Sym_Tdes_Init( (st_Hsm_Sym_Tdes_Cmd*)ptr_tdesCtx, modeType_en, HSM_CMD_DES_ENCRYPT, ptr_key, ptr_initVect, 0);
//            ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
//        }
//        else
//        {
//            ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPOPER;
//        }
//    }
//    else
//    {
//        ret_tdesStat_en = CRYPTO_SYM_ERROR_OPMODE;
//    }
//    
//    return ret_tdesStat_en;
//}
//
//crypto_Sym_Status_E Crypto_Sym_Hw_Tdes_Cipher(void *ptr_tdesCtx, uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut)
//{
//    crypto_Sym_Status_E ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPNOTSUPPTD; 
//    hsm_Cmd_Status_E hsmTdesStat_en = HSM_CMD_ERROR_FAILED;
//    
//    hsmTdesStat_en = Hsm_Sym_Tdes_Cipher( (st_Hsm_Sym_Tdes_Cmd*)ptr_tdesCtx, ptr_dataIn, dataLen, ptr_dataOut);
//    
//    if(hsmTdesStat_en == HSM_CMD_SUCCESS)
//    {
//        ret_tdesStat_en = CRYPTO_SYM_CIPHER_SUCCESS;
//    }
//    else
//    {
//        ret_tdesStat_en = CRYPTO_SYM_ERROR_CIPFAIL;
//    }
//    return ret_tdesStat_en;
//}
//
//crypto_Sym_Status_E Crypto_Sym_Hw_Tdes_CipherDirect(crypto_CipherOper_E cipherOpType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
//                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect)
//{
//    crypto_Sym_Status_E ret_tdesStatus_en = CRYPTO_SYM_ERROR_CIPFAIL;
//    hsm_Cmd_Status_E hsmTdesStat_en = HSM_CMD_ERROR_FAILED;
//    hsm_Sym_Tdes_ModeTypes_E opModeType_en = HSM_SYM_DES_OPMODE_ECB;
//    st_Hsm_Sym_Tdes_Cmd tdesCtx_st[1];
//    
//    if( (opMode_en == CRYPTO_SYM_OPMODE_ECB) || (opMode_en == CRYPTO_SYM_OPMODE_CBC) )
//    {
//        opModeType_en = Crypto_Sym_Hw_Tdes_GetOpMode(opMode_en);
//     
//        if(cipherOpType_en == CRYPTO_CIOP_ENCRYPT)
//        {
//            Hsm_Sym_Tdes_Init(tdesCtx_st, opModeType_en, HSM_CMD_DES_ENCRYPT, ptr_key, ptr_initVect, 0);
//            hsmTdesStat_en = Hsm_Sym_Tdes_Cipher(tdesCtx_st, ptr_inputData, dataLen, ptr_outData);
//        }
//        else if(cipherOpType_en == CRYPTO_CIOP_DECRYPT)
//        {
//            Hsm_Sym_Tdes_Init(tdesCtx_st, opModeType_en, HSM_CMD_DES_DECRYPT, ptr_key, ptr_initVect, 0);
//            hsmTdesStat_en = Hsm_Sym_Tdes_Cipher(tdesCtx_st, ptr_inputData, dataLen, ptr_outData);
//        }
//        else
//        {
//            ret_tdesStatus_en = CRYPTO_SYM_ERROR_CIPOPER;
//        }
//        if(ret_tdesStatus_en != CRYPTO_SYM_ERROR_CIPOPER) 
//        {
//            if(hsmTdesStat_en == HSM_CMD_SUCCESS)
//            {
//                ret_tdesStatus_en = CRYPTO_SYM_CIPHER_SUCCESS;
//            }
//            else
//            {
//                ret_tdesStatus_en = CRYPTO_SYM_ERROR_CIPFAIL;
//            }
//        }
//    }
//    else
//    {
//        ret_tdesStatus_en = CRYPTO_SYM_ERROR_OPMODE;
//    }
//    
//    return ret_tdesStatus_en;
//}
</#if>