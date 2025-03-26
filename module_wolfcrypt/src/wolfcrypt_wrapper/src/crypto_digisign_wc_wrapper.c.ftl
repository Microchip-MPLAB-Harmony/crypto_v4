/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_digisign_wc_wrapper.c

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
#include "crypto/common_crypto/crypto_digsign.h"
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/wolfcrypt/crypto_digisign_wc_wrapper.h"
#include "crypto/wolfcrypt/crypto_common_wc_wrapper.h"
#include "wolfssl/wolfcrypt/error-crypt.h"
<#if (CRYPTO_WC_ECDSA?? &&(CRYPTO_WC_ECDSA == true))>
#include "wolfssl/wolfcrypt/random.h"
#include "wolfssl/wolfcrypt/ecc.h"
#include "crypto/common_crypto/crypto_hash.h"
</#if><#-- CRYPTO_WC_ECDSA -->

<#if (CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(CRYPTO_WC_DIGISIGN_RSA_PSS == true)) 
		|| (CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true))
		|| (CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true))>
#include "wolfssl/wolfcrypt/rsa.h"
#include "crypto/wolfcrypt/crypto_hash_wc_wrapper.h"
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS || CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 || CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->

<#if (CRYPTO_WC_ECDSA?? &&(CRYPTO_WC_ECDSA == true))>

crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Ecdsa_SignHash(uint8_t *ptr_wcInputHash, uint32_t wcHashLen, uint8_t *ptr_wcSig, uint32_t wcSigLen, uint8_t *ptr_wcPrivKey, 
                                                       uint32_t wcPrivKeyLen, crypto_EccCurveType_E wcEccCurveType_en)
{
    crypto_DigiSign_Status_E ret_wcEcdsaStat_en;
    ecc_key wcEccPrivKey_st;
    WC_RNG wcRng_st;
    int wcEccCurveId = (int)ECC_CURVE_INVALID;
    int wcEcdsaStat = BAD_FUNC_ARG;
    mp_int r, s;
   
    wcEccCurveId = Crypto_Common_Wc_Ecc_GetWcCurveId(wcEccCurveType_en);
    
    if(wcEccCurveId == (int)ECC_CURVE_INVALID)
    {
        ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    else
    {
        // Setup the RNG
        wcEcdsaStat = wc_InitRng(&wcRng_st);

        if(wcEcdsaStat == 0)
        {
            /* Setup the ECC key */
            wcEcdsaStat = wc_ecc_init(&wcEccPrivKey_st);
            
            if(wcEcdsaStat == 0)
            {
                // Import private key, public part Pass as NULL
                wcEcdsaStat = wc_ecc_import_private_key_ex(ptr_wcPrivKey, wcPrivKeyLen,/* private key "d" */
                                                            NULL, 0,                    /* public (optional) */
                                                            &wcEccPrivKey_st,
                                                            wcEccCurveId                /* ECC Curve Id */
                                                            );
                if(wcEcdsaStat == 0)
                {
                    wcEcdsaStat = mp_init(&r);
                    
                    if(wcEcdsaStat == 0)
                    {        
                        wcEcdsaStat = mp_init(&s);           

                        if(wcEcdsaStat == 0)
                        {
                            wcEcdsaStat = wc_ecc_sign_hash_ex(ptr_wcInputHash, wcHashLen, &wcRng_st, &wcEccPrivKey_st, &r, &s);

                            //Import signature R and S
                            if(wcEcdsaStat == 0)
                            {
                                wcEcdsaStat = mp_to_unsigned_bin_len(&r, (byte*)ptr_wcSig, (int)wcPrivKeyLen);
                            }
                            if(wcEcdsaStat == 0)
                            {
                                wcEcdsaStat = mp_to_unsigned_bin_len(&s, (byte*)(ptr_wcSig + (uint32_t)wcPrivKeyLen), (int)wcPrivKeyLen);
                            }
                        }
                    }
                }
            }
            if(wcEcdsaStat == 0)
            {
                ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
            }
            else if(wcEcdsaStat == ECC_CURVE_OID_E)
            {
                ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
            }
            else if( (wcEcdsaStat == BAD_FUNC_ARG) || (wcEcdsaStat == ECC_BAD_ARG_E) )
            {
                ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
            }
            else
            {
                ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
            }
        }
        else
        {
            ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_RNG;
        }
    }
    
    return ret_wcEcdsaStat_en;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1" 
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Ecdsa_VerifyHash(uint8_t *ptr_wcInputHash, uint32_t wcHashLen, uint8_t *ptr_wcInputSig, uint32_t wcSigLen, uint8_t *ptr_wcPubKey, uint32_t wcPubKeyLen, 
                                                         int8_t *ptr_wcHashVerifyStat, crypto_EccCurveType_E wcEccCurveType_en)
{
    crypto_DigiSign_Status_E ret_wcEcdsaStat_en;
    ecc_key wcEccPubKey_st;
    int wcEccCurveId = (int)ECC_CURVE_INVALID;
    int wcEcdsaStat = BAD_FUNC_ARG;
    int ptr_verifyStat = 0;
    mp_int r, s;
    int curveLen = 0;
    
    wcEccCurveId = Crypto_Common_Wc_Ecc_GetWcCurveId(wcEccCurveType_en);
    
    if(wcEccCurveId == (int)ECC_CURVE_INVALID)
    {
        ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    else
    {
        /* Setup the ECC key */
        wcEcdsaStat = wc_ecc_init(&wcEccPubKey_st);
        if(wcEcdsaStat == 0)
        {
            wcEcdsaStat = mp_init(&r);
            if(wcEcdsaStat == 0)
            {        
                wcEcdsaStat = mp_init(&s);
            }
            if(wcEcdsaStat == 0)
            {   
                wcEcdsaStat = wc_ecc_import_x963_ex(ptr_wcPubKey, wcPubKeyLen, &wcEccPubKey_st, wcEccCurveId);

                if(wcEcdsaStat == 0)
                {
                    //Get Curve Length using Curve ID
                    curveLen = wc_ecc_get_curve_size_from_id(wcEccCurveId);

                    // Import signature r and s
                    wcEcdsaStat = mp_read_unsigned_bin(&r, ptr_wcInputSig, (word32)curveLen);
                    if (wcEcdsaStat == 0) 
                    {
                        wcEcdsaStat = mp_read_unsigned_bin(&s, (const byte*)(ptr_wcInputSig+(uint32_t)curveLen), (word32)curveLen);

                        //If Verify status value is 1 then verification is successfully
                        if (wcEcdsaStat == 0) 
                        {
                            wcEcdsaStat = wc_ecc_verify_hash_ex(&r, &s, (const byte*)ptr_wcInputHash, (word32)wcHashLen, &ptr_verifyStat, &wcEccPubKey_st);
                            *ptr_wcHashVerifyStat = (int8_t)ptr_verifyStat;
                        }
                    }
                }
            }
        }
        else
        {
           //do nothing 
        }
        if(wcEcdsaStat == 0)
        {
            ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
        }
        else if(wcEcdsaStat == ECC_CURVE_OID_E)
        {
            ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
        }
        else if( (wcEcdsaStat == BAD_FUNC_ARG) || (wcEcdsaStat == ECC_BAD_ARG_E) )
        {
            ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
        }
        else
        {
            ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
        }
    }
    
    return ret_wcEcdsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Ecdsa_SignData(uint8_t *ptr_wcInputData, uint32_t wcDataLen, uint8_t *ptr_wcSig, uint32_t wcSigLen, 
                                                            uint8_t *ptr_wcPrivKey, uint32_t wcPrivKeyLen, crypto_Hash_Algo_E hashType_en,                                                            
                                                            crypto_EccCurveType_E wcEccCurveType_en)
{
    crypto_DigiSign_Status_E ret_wcEcdsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before signing
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, hashType_en, ptr_wcInputData,wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Sign the Hash
        ret_wcEcdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_SignHash(arr_hash, wcHashLen, ptr_wcSig, wcSigLen, ptr_wcPrivKey, 
                                                       wcPrivKeyLen, wcEccCurveType_en);
    }
    
    return ret_wcEcdsaStat_en;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1" 
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Ecdsa_VerifyData(uint8_t *ptr_wcInputData, uint32_t wcDataLen, uint8_t *ptr_wcSig, uint32_t wcSigLen, 
                                                            uint8_t *ptr_wcPubKey, uint32_t wcPubKeyLen, crypto_Hash_Algo_E hashType_en,
                                                            int8_t *ptr_wcHashVerifyStat, crypto_EccCurveType_E wcEccCurveType_en)
{
    crypto_DigiSign_Status_E ret_wcEcdsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before verify
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, hashType_en, ptr_wcInputData,wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcEcdsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Verify the Hash
        ret_wcEcdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_VerifyHash(arr_hash, wcHashLen, ptr_wcSig, wcSigLen, ptr_wcPubKey, 
                                                                wcPubKeyLen, ptr_wcHashVerifyStat, wcEccCurveType_en);
    }
    
    return ret_wcEcdsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 
</#if><#-- CRYPTO_WC_ECDSA -->	

<#if (CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true))>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1" 
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pkcs1v15_SignHash(uint8_t *ptr_wcInHash, uint32_t wcHashLen, uint8_t *ptr_wcOutSign, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen)
{
	crypto_DigiSign_Status_E ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
	int wcStatus = BAD_FUNC_ARG;
	RsaKey wcRsaPrivKey;
	WC_RNG wcRng;
	word32 wcOutLen = 0;
	word32 inOutIdx = 0;
	
	wcStatus = wc_InitRsaKey(&wcRsaPrivKey, NULL);
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPrivateKeyDecode((const byte*)ptr_wcPrivKeyDer, &inOutIdx, &wcRsaPrivKey, (word32)wcPrivKeyBufLen);
		wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPrivKey);
	}
	
	if(wcStatus == 0)
	{
		wcStatus = wc_InitRng(&wcRng);
	}
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaSSL_Sign((const byte*)ptr_wcInHash, (word32)wcHashLen, (byte*)ptr_wcOutSign, wcOutLen, &wcRsaPrivKey, &wcRng);
	}

    if(wcStatus == (int)wcOutLen)
    {
        wcStatus = wc_FreeRsaKey(&wcRsaPrivKey);
    }
	
	if(wcStatus == 0)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_RSAPADDING;
    }
    else
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
	
	return ret_wcRsaStat_en;
}

#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1" 
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pkcs1v15_VerifyHash(uint8_t *ptr_wcInHash, uint32_t wcHashLen, uint8_t *ptr_wcInSign, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen)
{
	crypto_DigiSign_Status_E ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
	int wcStatus = BAD_FUNC_ARG;
	RsaKey wcRsaPubKey;
	word32 wcOutLen = 1;
	word32 inOutIdx = 0;
	
	wcStatus = wc_InitRsaKey(&wcRsaPubKey, NULL);
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPublicKeyDecode((const byte*)ptr_wcPubKeyDer, &inOutIdx, &wcRsaPubKey, (word32)wcPubKeyBufLen);
		wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPubKey);
	}
	
	uint8_t arr_wcPlainText[wcHashLen];
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaSSL_Verify((const byte*)ptr_wcInSign, wcOutLen, (byte*)arr_wcPlainText, (word32)wcHashLen, &wcRsaPubKey);
	}
	
	if(wcStatus == (int)wcHashLen)
    {
        bool signatureValid = true;
		for(uint8_t i = 0; i < wcHashLen; i++)
		{
			if(ptr_wcInHash[i] != arr_wcPlainText[i])
			{
				ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
                signatureValid = false;
				break;
			}
		}
        
        if (signatureValid) {
            ret_wcRsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
        }
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_RSAPADDING;
    }
    else
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
	
	return ret_wcRsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pkcs1v15_SignData(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutSign, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen,
																		crypto_Hash_Algo_E maskHashType_en)
{
    crypto_DigiSign_Status_E ret_wcRsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before signing
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, maskHashType_en, ptr_wcInData, wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Sign the Hash
		ret_wcRsaStat_en = Crypto_DigiSign_Wc_Rsa_Pkcs1v15_SignHash(arr_hash, wcHashLen, ptr_wcOutSign, ptr_wcPrivKeyDer, wcPrivKeyBufLen);
    }
    
    return ret_wcRsaStat_en;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pkcs1v15_VerifyData(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcInSign, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen,
																		crypto_Hash_Algo_E maskHashType_en)
{
    crypto_DigiSign_Status_E ret_wcRsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before verify
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, maskHashType_en, ptr_wcInData, wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Verify the Hash
        ret_wcRsaStat_en = Crypto_DigiSign_Wc_Rsa_Pkcs1v15_VerifyHash(arr_hash, wcHashLen, ptr_wcInSign, ptr_wcPubKeyDer, wcPubKeyBufLen);
    }
    
    return ret_wcRsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop  
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 -->	


<#if (CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(CRYPTO_WC_DIGISIGN_RSA_PSS == true))>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pss_SignHash(uint8_t *ptr_wcInHash, uint32_t wcHashLen, uint8_t *ptr_wcOutSign, 
																uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen, crypto_Hash_Algo_E maskHashType_en)
{
	crypto_DigiSign_Status_E ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
	int wcStatus = BAD_FUNC_ARG;
	RsaKey wcRsaPrivKey;
	WC_RNG wcRng;
	int wcHashType = (int)WC_HASH_TYPE_NONE;
	int wcMgfType = WC_MGF1NONE;
	word32 wcOutLen = 0;
	word32 inOutIdx = 0;
	
	wcStatus = wc_InitRsaKey(&wcRsaPrivKey, NULL);
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPrivateKeyDecode((const byte*)ptr_wcPrivKeyDer, &inOutIdx, &wcRsaPrivKey, (word32)wcPrivKeyBufLen);
		wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPrivKey);
	}
	
	if(wcStatus == 0)
	{
		wcStatus = wc_InitRng(&wcRng);
	}
	
	if(wcStatus == 0)
	{
		wcHashType = Crypto_Hash_Wc_GetWcHashType(maskHashType_en);
		wcMgfType = wc_hash2mgf((enum wc_HashType)wcHashType);
		wcStatus = wc_RsaPSS_Sign((const byte*)ptr_wcInHash, (word32)wcHashLen, (byte*)ptr_wcOutSign, wcOutLen, (enum wc_HashType)wcHashType, wcMgfType, &wcRsaPrivKey, &wcRng);
	}
	
    if(wcStatus == (int)wcOutLen)
    {
        wcStatus = wc_FreeRsaKey(&wcRsaPrivKey);
    }
    
	if(wcStatus == 0)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_RSAPADDING;
    }
    else
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
	
	return ret_wcRsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop  


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pss_VerifyHash(uint8_t *ptr_wcInHash, uint32_t wcHashLen, uint8_t *ptr_wcInSign, 
                                                                uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen, crypto_Hash_Algo_E maskHashType_en)
{
	crypto_DigiSign_Status_E ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
	int wcStatus = BAD_FUNC_ARG;
	RsaKey wcRsaPubKey;
	int wcHashType = (int)WC_HASH_TYPE_NONE;
	int wcMgfType = WC_MGF1NONE;
	word32 wcSigLen = 1;
	word32 inOutIdx = 0;
	
	wcStatus = wc_InitRsaKey(&wcRsaPubKey, NULL);
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPublicKeyDecode((const byte*)ptr_wcPubKeyDer, &inOutIdx, &wcRsaPubKey, (word32)wcPubKeyBufLen);
		wcSigLen = (word32)wc_RsaEncryptSize(&wcRsaPubKey);
	}
	
	uint8_t arr_wcPlainText[wcHashLen*(uint32_t)2];

	if(wcStatus == 0)
	{
		wcHashType = Crypto_Hash_Wc_GetWcHashType(maskHashType_en);
		wcMgfType = wc_hash2mgf((enum wc_HashType)wcHashType);
		wcStatus = wc_RsaPSS_Verify((byte*)ptr_wcInSign, wcSigLen, (byte*)arr_wcPlainText, (word32)(wcHashLen*(uint32_t)2), (enum wc_HashType)wcHashType, wcMgfType, &wcRsaPubKey);
	}
	
	if(wcStatus >= 0)
    {
        wcStatus = wc_RsaPSS_CheckPadding(ptr_wcInHash, wcHashLen, arr_wcPlainText, (wcHashLen*(uint32_t)2), (enum wc_HashType)wcHashType); 
                
		if(wcStatus == 0)
		{
            ret_wcRsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
        }
        else
        {
				ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
		}
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_RSAPADDING;
    }
    else
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
	
	return ret_wcRsaStat_en;
}

#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 

crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pss_SignData(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutSign, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen,
																		crypto_Hash_Algo_E maskHashType_en)
{
    crypto_DigiSign_Status_E ret_wcRsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before signing
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, maskHashType_en, ptr_wcInData, wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Sign the Hash
		ret_wcRsaStat_en = Crypto_DigiSign_Wc_Rsa_Pss_SignHash(arr_hash, wcHashLen, ptr_wcOutSign, ptr_wcPrivKeyDer, wcPrivKeyBufLen, maskHashType_en);
    }
    
    return ret_wcRsaStat_en;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_Pss_VerifyData(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcInSign, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen,
																		crypto_Hash_Algo_E maskHashType_en) 		
{
    crypto_DigiSign_Status_E ret_wcRsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before verify
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, maskHashType_en, ptr_wcInData, wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Verify the Hash
        ret_wcRsaStat_en = Crypto_DigiSign_Wc_Rsa_Pss_VerifyHash(arr_hash, wcHashLen, ptr_wcInSign, ptr_wcPubKeyDer, wcPubKeyBufLen, maskHashType_en);
    }
    
    return ret_wcRsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS -->

<#if (CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true))>
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_NoPadding_SignHash(uint8_t *ptr_wcInHash, uint32_t wcHashLen, uint8_t *ptr_wcOutSign, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen)
{
	crypto_DigiSign_Status_E ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
	int wcStatus = BAD_FUNC_ARG;
	RsaKey wcRsaPrivKey;
	WC_RNG wcRng;
	word32 wcOutLen = 0;
	word32 inOutIdx = 0;
	
	wcStatus = wc_InitRsaKey(&wcRsaPrivKey, NULL);
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPrivateKeyDecode((const byte*)ptr_wcPrivKeyDer, &inOutIdx, &wcRsaPrivKey, (word32)wcPrivKeyBufLen);
		wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPrivKey);
	}
	
	if(wcStatus == 0)
	{
		wcStatus = wc_InitRng(&wcRng);
	}
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPublicEncrypt_ex((const byte*)ptr_wcInHash, (word32)wcHashLen, (byte*)ptr_wcOutSign, wcOutLen, &wcRsaPrivKey, &wcRng,
											WC_RSA_NO_PAD, WC_HASH_TYPE_NONE, WC_MGF1NONE, NULL, 0);
	}
	
	if(wcStatus == 0)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_RSAPADDING;
    }
    else
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
	
	return ret_wcRsaStat_en;
}
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_NoPadding_VerifyHash(uint8_t *ptr_wcInHash, uint32_t wcHashLen, uint8_t *ptr_wcInSign, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen)
{
	crypto_DigiSign_Status_E ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
	int wcStatus = BAD_FUNC_ARG;
	RsaKey wcRsaPubKey;
	word32 wcOutLen = 1;
	word32 inOutIdx = 0;
	
	wcStatus = wc_InitRsaKey(&wcRsaPubKey, NULL);
	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaPublicKeyDecode((const byte*)ptr_wcPubKeyDer, &inOutIdx, &wcRsaPubKey, (word32)wcPubKeyBufLen);
		wcOutLen = (word32)wc_RsaEncryptSize(&wcRsaPubKey);
	}
	
	uint8_t arr_wcPlainText[wcOutLen];

	
	if(wcStatus == 0)
	{
		wcStatus = wc_RsaSSL_Verify_ex((const byte*)ptr_wcInSign, wcOutLen, (byte*)arr_wcPlainText, (word32)wcHashLen, &wcRsaPubKey, WC_RSA_NO_PAD);
	}
	
	if(wcStatus == 0)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_SUCCESS;
		
		for(uint8_t i = 0; i < wcHashLen; i++)
		{
			if(ptr_wcInHash[i] != arr_wcPlainText[i])
			{
				ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
				break;
			}
		}
    }
    else if(wcStatus == BAD_FUNC_ARG)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_ARG;
    }
    else if( (wcStatus == ASN_PARSE_E) || (wcStatus == WC_KEY_SIZE_E) )
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if(wcStatus == RSA_PAD_E)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_RSAPADDING;
    }
    else
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
	
	return ret_wcRsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 

crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_NoPadding_SignData(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutSign, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen,
																		crypto_Hash_Algo_E maskHashType_en)
{
    crypto_DigiSign_Status_E ret_wcRsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before signing
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, maskHashType_en, ptr_wcInData, wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Sign the Hash
		ret_wcRsaStat_en = Crypto_DigiSign_Wc_Rsa_NoPadding_SignHash(arr_hash, wcHashLen, ptr_wcOutSign, ptr_wcPrivKeyDer, wcPrivKeyBufLen);
    }
    
    return ret_wcRsaStat_en;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Wc_Rsa_NoPadding_VerifyData(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcInSign, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen,
																							crypto_Hash_Algo_E maskHashType_en) 
{
    crypto_DigiSign_Status_E ret_wcRsaStat_en;
    uint8_t arr_hash[512];
    uint32_t wcHashLen = 0x00UL;
    
    //calculate the hash before verify
    wcHashLen = Crypto_Hash_GetHashAndHashSize(CRYPTO_HANDLER_SW_WOLFCRYPT, maskHashType_en, ptr_wcInData, wcDataLen, arr_hash);
    
    if(wcHashLen == 0x00UL)
    {
        ret_wcRsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else
    {
        //Verify the Hash
        ret_wcRsaStat_en = Crypto_DigiSign_Wc_Rsa_NoPadding_VerifyHash(arr_hash, wcHashLen, ptr_wcInSign, ptr_wcPubKeyDer, wcPubKeyBufLen);
    }
    
    return ret_wcRsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->		