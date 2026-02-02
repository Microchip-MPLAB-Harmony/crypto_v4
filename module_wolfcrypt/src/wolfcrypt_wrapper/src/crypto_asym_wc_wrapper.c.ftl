/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_asym_wc_cipher.c

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
* Copyright (C) ${.now?string("yyyy")} Microchip Technology Inc. and its subsidiaries.
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

#include "crypto/common_crypto/crypto_asym_cipher.h"
#include "crypto/wolfcrypt/crypto_asym_wc_wrapper.h"

<#if (CRYPTO_WC_ASYM_RSA_OAEP?? &&(CRYPTO_WC_ASYM_RSA_OAEP == true)) 
        || (CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true))
        || (CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(CRYPTO_WC_ASYM_RSA_NO_PADDING == true))>
#include "wolfssl/wolfcrypt/rsa.h"
</#if> <#-- CRYPTO_WC_ASYM_RSA_OAEP || CRYPTO_WC_ASYM_RSA_PKCS1_V15 || CRYPTO_WC_ASYM_RSA_NO_PADDING -->

<#if (CRYPTO_WC_ASYM_RSA_OAEP?? &&(CRYPTO_WC_ASYM_RSA_OAEP == true))>
#include "crypto/wolfcrypt/crypto_hash_wc_wrapper.h"
</#if> <#-- CRYPTO_WC_ASYM_RSA_OAEP -->
// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// ***************************************************************************** 


// *****************************************************************************
// *****************************************************************************
// Section: Function Definitions
// *****************************************************************************
// *****************************************************************************

<#if (CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true))>
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Pkcs1v15_Encrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    int wcStatus = BAD_FUNC_ARG;
    RsaKey wcRsaPubKey;
    WC_RNG wcRng;
    word32 wcOutLen = 0;
    word32 inOutIdx = 0;
    
    wcStatus = wc_InitRsaKey(&wcRsaPubKey, NULL);
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPublicKeyDecode((const byte*) ptr_wcPubKeyDer, &inOutIdx, &wcRsaPubKey, (word32)wcPubKeyBufLen);
        wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPubKey); 
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_InitRng(&wcRng);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPublicEncrypt_ex(ptr_wcInData, wcDataLen, ptr_wcOutData, wcOutLen, &wcRsaPubKey, &wcRng, WC_RSA_PKCSV15_PAD, WC_HASH_TYPE_NONE, WC_MGF1NONE, NULL, 0);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_FreeRsaKey(&wcRsaPubKey);
    }
    
    if(wcStatus == 0 || wcStatus == (int)wcOutLen)
    {
        ret_rsaStat_en = CRYPTO_ASYM_CIPHER_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_KEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_PADDING;
    }
    else
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPFAIL;
    }
    
    return ret_rsaStat_en;
}

crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Pkcs1v15_Decrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    int wcStatus = BAD_FUNC_ARG;
    RsaKey wcRsaPrivKey;
    word32 wcOutLen = 0;
    word32 inOutIdx = 0;
    
    wcStatus = wc_InitRsaKey(&wcRsaPrivKey, NULL);
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPrivateKeyDecode((const byte*) ptr_wcPrivKeyDer, &inOutIdx, &wcRsaPrivKey, (word32)wcPrivKeyBufLen);
        wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPrivKey);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPrivateDecrypt_ex(ptr_wcInData, wcDataLen, ptr_wcOutData, wcOutLen, &wcRsaPrivKey, WC_RSA_PKCSV15_PAD, WC_HASH_TYPE_NONE, WC_MGF1NONE, NULL, 0);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_FreeRsaKey(&wcRsaPrivKey);
    }
    
    if(wcStatus == 0 || wcStatus > 0)
    {
        ret_rsaStat_en = CRYPTO_ASYM_CIPHER_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_KEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_PADDING;
    }
    else
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPFAIL;
    }
    
    return ret_rsaStat_en;
}
</#if> <#-- CRYPTO_WC_ASYM_RSA_PKCS1_V15 -->

<#if (CRYPTO_WC_ASYM_RSA_OAEP?? &&(CRYPTO_WC_ASYM_RSA_OAEP == true))>
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Oaep_Encrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen, 
                                                                                                crypto_Hash_Algo_E wcMaskHashType_en, uint8_t *ptr_wcLabel, uint32_t wcLabelLen)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    int wcStatus = BAD_FUNC_ARG;
    RsaKey wcRsaPubKey;
    WC_RNG wcRng;
    int wcHashType = (int)WC_HASH_TYPE_NONE;
    int wcMgfType = WC_MGF1NONE;
    word32 wcOutLen = 0;
    word32 inOutIdx = 0;
    
    wcStatus = wc_InitRsaKey(&wcRsaPubKey, NULL);
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPublicKeyDecode((const byte*) ptr_wcPubKeyDer, &inOutIdx, &wcRsaPubKey, (word32)wcPubKeyBufLen);
        wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPubKey); 
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_InitRng(&wcRng);
    }
    
    if(wcStatus == 0)
    {
        wcHashType = Crypto_Hash_Wc_GetWcHashType(wcMaskHashType_en);
        wcMgfType = wc_hash2mgf((enum wc_HashType)wcHashType);
        wcStatus = wc_RsaPublicEncrypt_ex(ptr_wcInData, wcDataLen, ptr_wcOutData, wcOutLen, &wcRsaPubKey, &wcRng, WC_RSA_OAEP_PAD, (enum wc_HashType)wcHashType, 
                                                                                                                                wcMgfType, ptr_wcLabel, wcLabelLen);     
    }
    
    if(wcStatus == 0 || wcStatus == (int)wcOutLen)
    {
    crypto_Asym_Status_E freeRsaKeyStatus = (crypto_Asym_Status_E)wc_FreeRsaKey(&wcRsaPubKey);
    if (freeRsaKeyStatus == CRYPTO_ASYM_CIPHER_SUCCESS) {
        ret_rsaStat_en = CRYPTO_ASYM_CIPHER_SUCCESS;
    }
    
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_KEY;
    }
    else if(wcStatus == RSA_BUFFER_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_BUFFER;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_PADDING;
    }
    else
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPFAIL;
    }
    
    return ret_rsaStat_en;
}

crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Oaep_Decrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint32_t wcOutDatLen, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen, 
                                                                                                crypto_Hash_Algo_E wcMaskHashType_en, uint8_t *ptr_wcLabel, uint32_t wcLabelLen)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    int wcStatus = BAD_FUNC_ARG;
    RsaKey wcRsaPrivKey;
    int wcHashType = (int)WC_HASH_TYPE_NONE;
    int wcMgfType = WC_MGF1NONE;
    word32 inOutIdx = 0;
    
    wcStatus = wc_InitRsaKey(&wcRsaPrivKey, NULL);
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPrivateKeyDecode((const byte*) ptr_wcPrivKeyDer, &inOutIdx, &wcRsaPrivKey, (word32)wcPrivKeyBufLen);
    }
    
    if(wcStatus == 0)
    {
        wcHashType = Crypto_Hash_Wc_GetWcHashType(wcMaskHashType_en);
        wcMgfType = wc_hash2mgf((enum wc_HashType)wcHashType);
        wcStatus = wc_RsaPrivateDecrypt_ex(ptr_wcInData, wcDataLen, ptr_wcOutData, wcOutDatLen, &wcRsaPrivKey, WC_RSA_OAEP_PAD, (enum wc_HashType)wcHashType, 
                                                                                                                        wcMgfType, ptr_wcLabel, wcLabelLen);     
    }
    
    if(wcStatus == 0 || wcStatus > 0)
    {
    crypto_Asym_Status_E freeRsaKeyStatus = (crypto_Asym_Status_E)wc_FreeRsaKey(&wcRsaPrivKey);
    if (freeRsaKeyStatus == CRYPTO_ASYM_CIPHER_SUCCESS) {
        ret_rsaStat_en = CRYPTO_ASYM_CIPHER_SUCCESS;
    }
    
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_KEY;
    }
    else if(wcStatus == RSA_BUFFER_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_BUFFER;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_PADDING;
    }
    else
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPFAIL;
    }
    
    return ret_rsaStat_en;
}

</#if> <#-- CRYPTO_WC_ASYM_RSA_OAEP -->

<#if (CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(CRYPTO_WC_ASYM_RSA_NO_PADDING == true))>

crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_NoPadding_Encrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    int wcStatus = BAD_FUNC_ARG;
    RsaKey wcRsaPubKey;
    WC_RNG wcRng;
    word32 wcOutLen = 0;
    word32 inOutIdx = 0;
    
    wcStatus = wc_InitRsaKey(&wcRsaPubKey, NULL);
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPublicKeyDecode((const byte*) ptr_wcPubKeyDer, &inOutIdx, &wcRsaPubKey, (word32)wcPubKeyBufLen);
        wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPubKey); 
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_InitRng(&wcRng);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPublicEncrypt_ex(ptr_wcInData, wcDataLen, ptr_wcOutData, wcOutLen, &wcRsaPubKey, &wcRng, WC_RSA_NO_PAD, WC_HASH_TYPE_NONE, WC_MGF1NONE, NULL, 0);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_FreeRsaKey(&wcRsaPubKey);
    }
    
    if(wcStatus == 0 || wcStatus == (int)wcOutLen)
    {
        ret_rsaStat_en = CRYPTO_ASYM_CIPHER_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_KEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_PADDING;
    }
    else
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPFAIL;
    }
    
    return ret_rsaStat_en;
}

crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_NoPadding_Decrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen)
{
    crypto_Asym_Status_E ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPNOTSUPPTD;
    int wcStatus = BAD_FUNC_ARG;
    RsaKey wcRsaPrivKey;
    word32 wcOutLen = 0;
    word32 inOutIdx = 0;
    
    wcStatus = wc_InitRsaKey(&wcRsaPrivKey, NULL);
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPrivateKeyDecode((const byte*) ptr_wcPrivKeyDer, &inOutIdx, &wcRsaPrivKey, (word32)wcPrivKeyBufLen);
        wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPrivKey);
    }
    
    if(wcStatus == 0)
    {
        wcStatus = wc_RsaPrivateDecrypt_ex(ptr_wcInData, wcDataLen, ptr_wcOutData, wcOutLen, &wcRsaPrivKey, WC_RSA_NO_PAD, WC_HASH_TYPE_NONE, WC_MGF1NONE, NULL, 0);
    }
    
    if(wcStatus == (int)wcDataLen)
    {
        wcStatus = wc_FreeRsaKey(&wcRsaPrivKey);
    }
    
    if(wcStatus == 0)
    {
        ret_rsaStat_en = CRYPTO_ASYM_CIPHER_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_KEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_PADDING;
    }
    else
    {
        ret_rsaStat_en = CRYPTO_ASYM_ERROR_CIPFAIL;
    }
    
    return ret_rsaStat_en;
}


</#if> <#-- CRYPTO_WC_ASYM_RSA_NO_PADDING -->