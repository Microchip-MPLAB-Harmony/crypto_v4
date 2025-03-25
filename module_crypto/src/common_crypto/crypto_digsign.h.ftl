/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_digsign.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
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

#ifndef CRYPTO_DIGSIGN_H
#define CRYPTO_DIGSIGN_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto_common.h"
<#if (driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
#include "crypto/common_crypto/crypto_hash.h"
</#if><#-- HAVE_CRYPTO_HW_HSM_03785_DRIVER || CRYPTO_WC_ECDSA || CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 || CRYPTO_WC_DIGISIGN_RSA_PSS || CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->  

typedef enum
{
    CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD = -127,
    CRYPTO_DIGISIGN_ERROR_PRIVKEY = -126,
    CRYPTO_DIGISIGN_ERROR_PRIVKEYLEN = -125,
    CRYPTO_DIGISIGN_ERROR_PUBKEY = -124,
    CRYPTO_DIGISIGN_ERROR_PUBKEYCOMPRESS = -123,
    CRYPTO_DIGISIGN_ERROR_PUBKEYLEN = -122,        
    CRYPTO_DIGISIGN_ERROR_HDLR = -121,
    CRYPTO_DIGISIGN_ERROR_INPUTHASH = -120,
    CRYPTO_DIGISIGN_ERROR_SIGNATURE = -119,
    CRYPTO_DIGISIGN_ERROR_SID = -118,  ////session ID Error
    CRYPTO_DIGISIGN_ERROR_ARG = -117,
    CRYPTO_DIGISIGN_ERROR_CURVE = -116, 
    CRYPTO_DIGISIGN_ERROR_RNG = -115, 
    CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE = -114,        
    CRYPTO_DIGISIGN_ERROR_FAIL = -113,
    CRYPTO_DIGISIGN_ERROR_RSAPADDING = -112,
    CRYPTO_DIGISIGN_ERROR_INPUTDATA = -111,
    CRYPTO_DIGISIGN_SUCCESS = 0,        
}crypto_DigiSign_Status_E;
<#if ( (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) || (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true))) )>
<#if (driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER")) || (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Sign(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                    uint32_t sigLen, uint8_t *ptr_privKey, uint32_t privKeyLen, 
                                                    crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId);

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Verify(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputHash, uint32_t hashLen, 
                                                        uint8_t *ptr_inputSig, uint32_t sigLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen,
                                                        int8_t *ptr_sigVerifyStat, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId);
</#if><#-- HAVE_CRYPTO_HW_CPKCC_44163_DRIVER || CRYPTO_HW_ECDSA -->
<#if (driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")) || (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_SignData(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                        uint8_t *ptr_outSig, uint32_t sigLen, uint8_t *ptr_privKey, uint32_t privKeyLen, 
                                                        crypto_Hash_Algo_E hashType_en, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId);

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_VerifyData(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_inputSig, uint32_t sigLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen, 
                                                            crypto_Hash_Algo_E hashType_en, int8_t *ptr_sigVerifyStat, crypto_EccCurveType_E eccCurveType_En, 
                                                            uint32_t ecdsaSessionId);
</#if><#-- HAVE_CRYPTO_HW_HSM_03785_DRIVER || CRYPTO_WC_ECDSA -->                                                             
</#if><#-- CRYPTO_HW_ECDSA || CRYPTO_WC_ECDSA -->

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))>
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_Sign(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_Verify(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_inSign, 
                                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_SignData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_outSign, 
                                                                uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_VerifyData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_inSign, 
                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 --> 

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))>
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_Sign(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_Verify(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_inSign, 
                                                        uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_SignData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_outSign, 
                                                                uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_VerifyData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_inSign, 
                                                               uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS --> 

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_Sign(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_Verify(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_inSign, 
                                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_SignData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_outSign, 
                                                                uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_VerifyData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_inSign, 
                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId);
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING --> 
#endif /* CRYPTO_DIGSIGN_H */
