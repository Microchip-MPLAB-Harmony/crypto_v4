/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_mac_wc_wrapper.c

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
 
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_mac_cipher.h"
#include "crypto/wolfcrypt/crypto_mac_wc_wrapper.h"
#include "wolfssl/wolfcrypt/error-crypt.h"
<#if (CRYPTO_WC_AES_CMAC?? &&(CRYPTO_WC_AES_CMAC == true))>
#include "wolfssl/wolfcrypt/cmac.h"
</#if><#-- CRYPTO_WC_AES_CMAC -->
<#if 	(CRYPTO_WC_AES_CMAC?? &&(CRYPTO_WC_AES_CMAC == true))
	|| 	(CRYPTO_WC_AES_GMAC?? &&(CRYPTO_WC_AES_GMAC == true))>
#include "wolfssl/wolfcrypt/aes.h"
</#if>
// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// *****************************************************************************
<#if (CRYPTO_WC_AES_CMAC?? &&(CRYPTO_WC_AES_CMAC == true))>
crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Init(void *ptr_aesCmacCtx, uint8_t *ptr_key, uint32_t keySize)
{
    crypto_Mac_Status_E ret_aesStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    
    if(ptr_aesCmacCtx != NULL)
    {
        wcAesStatus =  wc_InitCmac( (Cmac*) ptr_aesCmacCtx, (const byte*)ptr_key, (word32)keySize, (int)WC_CMAC_AES, NULL);
        
        if(wcAesStatus == 0)
        {
            ret_aesStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_aesStat_en = CRYPTO_MAC_ERROR_CTX;
    }
    return ret_aesStat_en;
}

crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Cipher(void *ptr_aesCmacCtx, uint8_t *ptr_inputData, uint32_t dataLen)
{
    crypto_Mac_Status_E ret_aesStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
  
    if( (ptr_aesCmacCtx != NULL ) && (ptr_inputData != NULL) )
    {
        wcAesStatus = wc_CmacUpdate((Cmac*)ptr_aesCmacCtx, (const byte*)ptr_inputData, (word32)dataLen);
        
        if(wcAesStatus == 0)
        {
            ret_aesStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    } //end of if of argument checking
    else
    {
        ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
    }
    return ret_aesStat_en;
}

crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Final(void *ptr_aesCmacCtx, uint8_t *ptr_outMac, uint32_t macLen)
{
    crypto_Mac_Status_E ret_aesStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    word32 wcMacLen = macLen;
    if( (ptr_aesCmacCtx != NULL ) && (ptr_outMac != NULL) )
    {
        wcAesStatus = wc_CmacFinal( (Cmac*)ptr_aesCmacCtx, (byte*)ptr_outMac, &wcMacLen);
        if(wcAesStatus == 0)
        {
            ret_aesStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    } //end of if of argument checking
    else
    {
        ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
    }
    return ret_aesStat_en;
}

crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Direct(uint8_t *ptr_inputData, uint32_t inuptLen, uint8_t *ptr_outMac, uint32_t macLen, uint8_t *ptr_key, uint32_t keyLen)
{
    crypto_Mac_Status_E ret_aesStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    word32 wcMacLen = macLen;
    if( (ptr_inputData != NULL ) && (ptr_outMac != NULL) )
    {
        wcAesStatus = wc_AesCmacGenerate( (byte*)ptr_outMac, &wcMacLen, (const byte*)ptr_inputData, inuptLen, (const byte*)ptr_key, keyLen);
        
        if(wcAesStatus == 0)
        {
            ret_aesStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    } //end of if of argument checking
    else
    {
        ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
    }
    return ret_aesStat_en;  
}   
</#if><#-- CRYPTO_WC_AES_CMAC -->
<#if (CRYPTO_WC_AES_GMAC?? &&(CRYPTO_WC_AES_GMAC == true))>

crypto_Mac_Status_E Crypto_Mac_Wc_AesGmac_Init(void *ptr_aesGmacCtx, uint8_t *ptr_key, uint32_t keySize)
{
    crypto_Mac_Status_E ret_aesGmacStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    
    if(ptr_aesGmacCtx != NULL)
    {
        wcAesStatus = wc_AesInit((Aes*)ptr_aesGmacCtx, NULL, 0);
        
        if(wcAesStatus == 0)
        {
            wcAesStatus = wc_GmacSetKey((Gmac*)ptr_aesGmacCtx, (const byte*)ptr_key, (word32)keySize);
        }
        
        if(wcAesStatus == 0)
        {
            ret_aesGmacStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesGmacStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesGmacStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    }
    else
    {
        ret_aesGmacStat_en = CRYPTO_MAC_ERROR_CTX;
    }
    return ret_aesGmacStat_en;
}

crypto_Mac_Status_E Crypto_Mac_Wc_AesGmac_Cipher(void *ptr_aesGmacCtx, uint8_t *ptr_initVect, uint32_t initVectLen, uint8_t *ptr_aad, uint32_t aadLen, 
                                                                                                                uint8_t *ptr_outMac, uint32_t macLen)
{
    crypto_Mac_Status_E ret_aesGmacStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
  
    if(ptr_aesGmacCtx != NULL)
    {
        wcAesStatus = wc_GmacUpdate((Gmac*)ptr_aesGmacCtx, (const byte*)ptr_initVect, (word32) initVectLen,
                                (const byte*)ptr_aad, (word32)aadLen, (byte*)ptr_outMac, (word32)macLen);  
        if(wcAesStatus == 0)
        {
            ret_aesGmacStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesGmacStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesGmacStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    } //end of if of argument checking
    else
    {
        ret_aesGmacStat_en = CRYPTO_MAC_ERROR_ARG;
    }
    return ret_aesGmacStat_en;
}

crypto_Mac_Status_E Crypto_Mac_Wc_AesGmac_Direct(uint8_t *ptr_initVect, uint32_t initVectLen, uint8_t *ptr_outMac, uint32_t macLen, uint8_t *ptr_key, 
                                                                                                  uint32_t keyLen, uint8_t *ptr_aad, uint32_t aadLen)
{
    crypto_Mac_Status_E ret_aesStat_en = CRYPTO_MAC_ERROR_CIPNOTSUPPTD;
    int wcAesStatus = BAD_FUNC_ARG;
    Gmac ptr_aesGmacCtx[1];
    if(ptr_outMac != NULL)
    {
        wcAesStatus = wc_AesInit(&ptr_aesGmacCtx[0].aes, NULL, 0);
        if(wcAesStatus == 0)
        {
            wcAesStatus = wc_GmacSetKey((Gmac*)ptr_aesGmacCtx, (const byte*)ptr_key, (word32)keyLen);
            if(wcAesStatus == 0)
            {
                wcAesStatus = wc_GmacUpdate((Gmac*)ptr_aesGmacCtx, (const byte*)ptr_initVect, (word32) initVectLen,
                                (const byte*)ptr_aad, (word32)aadLen, (byte*)ptr_outMac, (word32)macLen);  
            }
        }
        
        if(wcAesStatus == 0)
        {
            ret_aesStat_en = CRYPTO_MAC_CIPHER_SUCCESS;
        }
        else if(wcAesStatus == BAD_FUNC_ARG)
        {
            ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
        }
        else
        {
            ret_aesStat_en  = CRYPTO_MAC_ERROR_CIPFAIL;
        }
    } //end of if of argument checking
    else
    {
        ret_aesStat_en = CRYPTO_MAC_ERROR_ARG;
    }
    return ret_aesStat_en;  
}
</#if><#-- CRYPTO_WC_AES_GMAC -->
// *****************************************************************************