/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_asym_cipher.c

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
* Copyright (C) 2026 Microchip Technology Inc. and its subsidiaries.
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

#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_asym_cipher.h"

<#if lib_wolfcrypt?? &&(lib_wolfcrypt.crypto_asym_wc_wrapper_h_ftl_flag?? &&(lib_wolfcrypt.crypto_asym_wc_wrapper_h_ftl_flag == true))>
#include "crypto/wolfcrypt/crypto_asym_wc_wrapper.h"
</#if>
 
// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// ***************************************************************************** 

<#lt>#define CRYPTO_ASYM_SESSION_MAX (1)

// *****************************************************************************
// *****************************************************************************
// Section: Function Definitions
// *****************************************************************************
// *****************************************************************************
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true)))>
crypto_Asym_Status_E Crypto_Asym_Rsa_Pkcs1v15_Encrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, 
                                                                                                      crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    if ((ptr_inputData == NULL) || (dataLen == (uint32_t)0))
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_OUTPUTDATA;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == (uint32_t)0) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_ASYM_SESSION_MAX) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_SID; 
    }
    else
    {       
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                    ret_rsaStat_en = Crypto_Asym_Wc_Rsa_Pkcs1v15_Encrypt(ptr_inputData, dataLen, ptr_outData, ptr_pubKeyDer, pubKeyBufLen);     
                break;
</#if><#-- CRYPTO_WC_ASYM_RSA_PKCS1_V15 --> 
 
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
                
            default:
                ret_rsaStat_en = CRYPTO_ASYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_rsaStat_en;
}

crypto_Asym_Status_E Crypto_Asym_Rsa_Pkcs1v15_Decrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outputData, 
                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, 
                                                        crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    if ((ptr_inputData == NULL) || (dataLen == (uint32_t)0))
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_INPUTDATA;
    }
    else if(ptr_outputData == NULL)
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_OUTPUTDATA;
    }
    else if(ptr_privKeyDer == NULL) 
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_ASYM_SESSION_MAX) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_SID; 
    }
    else
    {       
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true)))>         
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                    ret_rsaStat_en = Crypto_Asym_Wc_Rsa_Pkcs1v15_Decrypt(ptr_inputData, dataLen, ptr_outputData, ptr_privKeyDer, privKeyBufLen);   
                break;
</#if><#-- CRYPTO_WC_ASYM_RSA_PKCS1_V15 -->                
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
                
            default:
                ret_rsaStat_en = CRYPTO_ASYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_rsaStat_en;
}
</#if><#-- CRYPTO_WC_ASYM_RSA_PKCS1_V15 --> 

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP == true)))>
crypto_Asym_Status_E Crypto_Asym_Rsa_Oaep_Encrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, 
                                                                                    crypto_Hash_Algo_E hashType_en, crypto_HandlerType_E rsaHandlerType_en, 
                                                                                    uint8_t *ptr_label, uint32_t labelLen, uint32_t sessionID)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    if ((ptr_inputData == NULL) || (dataLen == (uint32_t)0))
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_OUTPUTDATA;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == (uint32_t)0) ) 
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_ASYM_SESSION_MAX) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_SID; 
    }
    else
    {       
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP == true)))>        
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                    ret_rsaStat_en = Crypto_Asym_Wc_Rsa_Oaep_Encrypt(ptr_inputData, dataLen, ptr_outData, ptr_pubKeyDer, pubKeyBufLen, hashType_en, ptr_label, labelLen);     
                break;
</#if><#-- CRYPTO_WC_ASYM_RSA_OAEP -->                
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
                
            default:
                ret_rsaStat_en = CRYPTO_ASYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_rsaStat_en;
}

crypto_Asym_Status_E Crypto_Asym_Rsa_Oaep_Decrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint32_t outDataLen, uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, 
                                                            crypto_Hash_Algo_E hashType_en, crypto_HandlerType_E rsaHandlerType_en, 
                                                            uint8_t *ptr_label, uint32_t labelLen, uint32_t sessionID)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    if ((ptr_inputData == NULL) || (dataLen == (uint32_t)0))
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_OUTPUTDATA;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == (uint32_t)0) ) 
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_ASYM_SESSION_MAX) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_SID; 
    }
    else
    {       
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP == true)))>        
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                    ret_rsaStat_en = Crypto_Asym_Wc_Rsa_Oaep_Decrypt(ptr_inputData, dataLen, ptr_outData, outDataLen, ptr_privKeyDer, privKeyBufLen, hashType_en, ptr_label, labelLen);   
                break;
</#if><#-- CRYPTO_WC_ASYM_RSA_OAEP -->  
               
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
                
            default:
                ret_rsaStat_en = CRYPTO_ASYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_rsaStat_en;
}

</#if><#-- CRYPTO_WC_ASYM_RSA_OAEP -->

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING == true)))> 
crypto_Asym_Status_E Crypto_Asym_Rsa_NoPadding_Encrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, 
                                                                                                    crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    if ((ptr_inputData == NULL) || (dataLen == (uint32_t)0))

    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_OUTPUTDATA;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == (uint32_t)0) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_ASYM_SESSION_MAX) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_SID; 
    }
    else
    {       
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING == true)))>            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                    ret_rsaStat_en = Crypto_Asym_Wc_Rsa_NoPadding_Encrypt(ptr_inputData, dataLen, ptr_outData, ptr_pubKeyDer, pubKeyBufLen);     
                break;
</#if><#-- CRYPTO_WC_ASYM_RSA_NO_PADDING -->
               
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
                
            default:
                ret_rsaStat_en = CRYPTO_ASYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_rsaStat_en;
}

crypto_Asym_Status_E Crypto_Asym_Rsa_NoPadding_Decrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, 
                                                            crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    if( (ptr_inputData == NULL) || (dataLen == (uint32_t)0) )
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_INPUTDATA;
    }
    else if(ptr_outData == NULL)
    {
        ret_rsaStat_en =  CRYPTO_ASYM_ERROR_OUTPUTDATA;
    }
    else if(ptr_privKeyDer == NULL) 
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_KEY;
    }
    else if( (sessionID <= 0u) || (sessionID > (uint32_t)CRYPTO_ASYM_SESSION_MAX) )
    {
       ret_rsaStat_en =  CRYPTO_ASYM_ERROR_SID; 
    }
    else
    {       
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING == true)))>            
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                    ret_rsaStat_en = Crypto_Asym_Wc_Rsa_NoPadding_Decrypt(ptr_inputData, dataLen, ptr_outData, ptr_privKeyDer, privKeyBufLen);   
                break;
</#if><#-- CRYPTO_WC_ASYM_RSA_NO_PADDING -->               
            case CRYPTO_HANDLER_HW_INTERNAL:
                
                break;
                
            default:
                ret_rsaStat_en = CRYPTO_ASYM_ERROR_HDLR;
                break;
        }
        
    }
    return ret_rsaStat_en;
}

</#if><#-- CRYPTO_WC_ASYM_RSA_NO_PADDING -->
