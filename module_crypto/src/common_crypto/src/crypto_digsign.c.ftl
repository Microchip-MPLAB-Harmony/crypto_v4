/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_digsign.c

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
<#if crypto_digisign_cam05346_wrapper_h_ftl_flag?? &&(crypto_digisign_cam05346_wrapper_h_ftl_flag == true)>
#include "crypto/drivers/wrapper/crypto_digisign_cam05346_wrapper.h"
#include "crypto/drivers/wrapper/crypto_cam05346_wrapper.h"
</#if>
<#if crypto_digisign_hsm_lite_04777_wrapper_h_ftl_flag?? && (crypto_digisign_hsm_lite_04777_wrapper_h_ftl_flag == true)>
#include "crypto/drivers/wrapper/crypto_digisign_hsm_lite_04777_wrapper.h"
</#if>
<#if crypto_digisign_cpkcc44163_wrapper_h_ftl_flag?? &&(crypto_digisign_cpkcc44163_wrapper_h_ftl_flag == true)>
#include "crypto/drivers/wrapper/crypto_digisign_cpkcc44163_wrapper.h"
</#if>
<#if crypto_digisign_hsm03785_wrapper_h_ftl_flag?? &&(crypto_digisign_hsm03785_wrapper_h_ftl_flag == true)>
#include "crypto/drivers/wrapper/crypto_digisign_hsm03785_wrapper.h"
</#if>
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.crypto_digisign_wc_wrapper_h_ftl_flag?? &&(lib_wolfcrypt.crypto_digisign_wc_wrapper_h_ftl_flag == true)))> 
#include "crypto/wolfcrypt/crypto_digisign_wc_wrapper.h"
</#if> 

// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// ***************************************************************************** 

<#lt>#define CRYPTO_DIGISIGN_SESSION_MAX (1) 

// *****************************************************************************
// *****************************************************************************
// Section: Function Definitions
// *****************************************************************************
// *****************************************************************************

<#if ( ((CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) && (driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_CAM_05346_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_HSM_LITE_04777_DRIVER"))) 
					|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true))))>
crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Sign(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                    uint32_t sigLen, uint8_t *ptr_privKey, uint32_t privKeyLen, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inputHash == NULL) || (hashLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if( (ptr_outSig == NULL) || (sigLen == 0u) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (eccCurveType_En <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_En >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
    else if( (ptr_privKey == NULL) || (privKeyLen == 0u))
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if((ecdsaSessionId == 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_ecdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_SignHash(ptr_inputHash, hashLen, ptr_outSig, sigLen, ptr_privKey, privKeyLen, eccCurveType_En);
                break; 
</#if><#-- CRYPTO_WC_ECDSA -->
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true))>            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_CAM_05346_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_HSM_LITE_04777_DRIVER")> 
            	ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Sign(ptr_inputHash, hashLen, ptr_outSig, sigLen, ptr_privKey, privKeyLen, eccCurveType_En);            	
</#if><#-- HAVE_CRYPTO_HW_CPKCC_44163_DRIVER, HAVE_CRYPTO_HW_CAM_05346_DRIVER , HAVE_CRYPTO_HW_HSM_LITE_04777_DRIVER -->  
                break;             
</#if><#-- CRYPTO_HW_ECDSA -->
            default:
                ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        }
    }
    return ret_ecdsaStat_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Verify(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_inputSig, uint32_t sigLen, 
                                                    uint8_t *ptr_pubKey, uint32_t pubKeyLen, int8_t *ptr_sigVerifyStat, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inputHash == NULL) || (hashLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if( (ptr_inputSig == NULL) || (sigLen == 0u) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (eccCurveType_En <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_En >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    else if( (ptr_pubKey == NULL) || (pubKeyLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    //Check the Key compression Type, 0x04 for uncompressed, 0x02 for Even compressed and 0x03 for Odd compressed
    else if( !( (ptr_pubKey[0] == 0x04u) || ((ptr_pubKey[0] == 0x02u) || (ptr_pubKey[0] == 0x03u)) ) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEYCOMPRESS;
    }
    else if((ecdsaSessionId == 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>          
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_ecdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_VerifyHash(ptr_inputHash, hashLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, ptr_sigVerifyStat, eccCurveType_En);
                break; 
</#if><#-- CRYPTO_WC_ECDSA -->            
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true))>            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_CAM_05346_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_HSM_LITE_04777_DRIVER")>
            	ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Verify(ptr_inputHash, hashLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, 
                                        ptr_sigVerifyStat, eccCurveType_En);
</#if><#-- HAVE_CRYPTO_HW_CPKCC_44163_DRIVER, HAVE_CRYPTO_HW_CAM_05346_DRIVER , HAVE_CRYPTO_HW_HSM_LITE_04777_DRIVER --> 
            	break;
</#if><#-- CRYPTO_HW_ECDSA -->            
            default:
                ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        }
    }
    return ret_ecdsaStat_en;
}
</#if><#-- (CRYPTO_HW_ECDSA && !HAVE_CRYPTO_HW_HSM_03785_DRIVER) || CRYPTO_WC_ECDSA -->
<#if ( ((CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) && (driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER"))) 
                    || (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true))) )>

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_SignData(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                        uint8_t *ptr_outSig, uint32_t sigLen, uint8_t *ptr_privKey, uint32_t privKeyLen, 
                                                        crypto_Hash_Algo_E hashType_en, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if( (ptr_outSig == NULL) || (sigLen == 0u) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (eccCurveType_En <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_En >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
    else if( (ptr_privKey == NULL) || (privKeyLen == 0u))
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (hashType_en <= CRYPTO_HASH_INVALID) || (hashType_en >= CRYPTO_HASH_MAX))
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if((ecdsaSessionId == 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>             
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_ecdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_SignData(ptr_inputData, dataLen, ptr_outSig, sigLen, ptr_privKey, privKeyLen, 
                                                                                                                    hashType_en, eccCurveType_En);
            break; 
</#if><#-- CRYPTO_WC_ECDSA -->
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true))>            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")>    
                ret_ecdsaStat_en = Crypto_DigiSign_Hw_Ecdsa_SignData(ptr_inputData, dataLen, ptr_outSig, sigLen, ptr_privKey, privKeyLen, hashType_en, eccCurveType_En);
</#if><#-- HAVE_CRYPTO_HW_HSM_03785_DRIVER -->                  
            break;
</#if><#-- CRYPTO_HW_ECDSA -->           
            default:
                ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
            break;
        }
    }
    return ret_ecdsaStat_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_VerifyData(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputData, uint32_t dataLen, 
                                                            uint8_t *ptr_inputSig, uint32_t sigLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen, 
                                                            crypto_Hash_Algo_E hashType_en, int8_t *ptr_sigVerifyStat, crypto_EccCurveType_E eccCurveType_En, 
                                                            uint32_t ecdsaSessionId)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inputData == NULL) || (dataLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if( (ptr_inputSig == NULL) || (sigLen == 0u) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (eccCurveType_En <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_En >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    else if( (ptr_pubKey == NULL) || (pubKeyLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (hashType_en <= CRYPTO_HASH_INVALID) || (hashType_en >= CRYPTO_HASH_MAX))
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    //Check the Key compression Type, 0x04 for uncompressed, 0x02 for Even compressed and 0x03 for Odd compressed
    else if( !( (ptr_pubKey[0] == 0x04u) || ((ptr_pubKey[0] == 0x02u) || (ptr_pubKey[0] == 0x03u)) ) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEYCOMPRESS;
    }
    else if((ecdsaSessionId == 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>             
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_ecdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_VerifyData(ptr_inputData, dataLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, hashType_en,
                                                                            ptr_sigVerifyStat, eccCurveType_En);
            break; 
</#if><#-- CRYPTO_WC_ECDSA -->    
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true))>            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")>
                ret_ecdsaStat_en = Crypto_DigiSign_Hw_Ecdsa_VerifyData(ptr_inputData, dataLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, 
                                                                            hashType_en, ptr_sigVerifyStat, eccCurveType_En);
</#if><#-- HAVE_CRYPTO_HW_HSM_03785_DRIVER -->               
            break;
</#if><#-- CRYPTO_HW_ECDSA -->            
            default:
                ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
            break;
        }
    }
    return ret_ecdsaStat_en;
}
</#if><#-- (CRYPTO_HW_ECDSA && HAVE_CRYPTO_HW_HSM_03785_DRIVER) || CRYPTO_WC_ECDSA -->

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))>
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_Sign(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inHash == NULL) || (hashLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if(ptr_outSig == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pkcs1v15_SignHash(ptr_inHash, hashLen, ptr_outSig, ptr_privKeyDer, privKeyBufLen);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_Verify(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_inSign, 
                                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inHash == NULL) || (hashLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if(ptr_inSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pkcs1v15_VerifyHash(ptr_inHash, hashLen, ptr_inSign, ptr_pubKeyDer, pubKeyBufLen);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_SignData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_outSign, 
                                                                uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inData == NULL) || (dataLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTDATA;
    }
    else if(ptr_outSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pkcs1v15_SignData(ptr_inData, dataLen, ptr_outSign, ptr_privKeyDer, privKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
} 
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 5.1" "H3_MISRAC_2012_R_5_1_DR_1"        
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pkcs1v15_VerifyData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_inSign, 
                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inData == NULL) || (dataLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTDATA;
    }
    else if(ptr_inSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pkcs1v15_VerifyData(ptr_inData, dataLen, ptr_inSign, ptr_pubKeyDer, pubKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}
#pragma coverity compliance end_block "MISRA C-2012 Rule 5.1"
#pragma GCC diagnostic pop 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PKCS1_V15 -->      

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))>
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_Sign(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inHash == NULL) || (hashLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if(ptr_outSig == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pss_SignHash(ptr_inHash, hashLen, ptr_outSig, ptr_privKeyDer, privKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}


crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_Verify(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_inSign, 
                                                        uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inHash == NULL) || (hashLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if(ptr_inSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pss_VerifyHash(ptr_inHash, hashLen, ptr_inSign, ptr_pubKeyDer, pubKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        }
    }
    return ret_rsaStat_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_SignData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_outSign, 
                                                                uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inData == NULL) || (dataLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTDATA;
    }
    else if(ptr_outSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pss_SignData(ptr_inData, dataLen, ptr_outSign, ptr_privKeyDer, privKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}        
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_Pss_VerifyData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_inSign, 
                                                               uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inData == NULL) || (dataLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTDATA;
    }
    else if(ptr_inSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_PSS == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_Pss_VerifyData(ptr_inData, dataLen, ptr_inSign, ptr_pubKeyDer, pubKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}

</#if><#-- CRYPTO_WC_DIGISIGN_RSA_PSS --> 


<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_Sign(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_outSig, 
                                                                        uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inHash == NULL) || (hashLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if(ptr_outSig == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_NoPadding_SignHash(ptr_inHash, hashLen, ptr_outSig, ptr_privKeyDer, privKeyBufLen);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}


crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_Verify(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inHash, uint32_t hashLen, uint8_t *ptr_inSign, 
                                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inHash == NULL) || (hashLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if(ptr_inSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_NoPadding_VerifyHash(ptr_inHash, hashLen, ptr_inSign, ptr_pubKeyDer, pubKeyBufLen);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_SignData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_outSign, 
                                                                uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inData == NULL) || (dataLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTDATA;
    }
    else if(ptr_outSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_privKeyDer == NULL) || (privKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_NoPadding_SignData(ptr_inData, dataLen, ptr_outSign, ptr_privKeyDer, privKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}        
crypto_DigiSign_Status_E Crypto_DigiSign_Rsa_NoPadding_VerifyData(crypto_HandlerType_E rsaHandlerType_en, uint8_t *ptr_inData, uint32_t dataLen, uint8_t *ptr_inSign, 
                                                                uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, crypto_Hash_Algo_E maskHashType_en, uint32_t rsaSessionId)
{
    crypto_DigiSign_Status_E ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_inData == NULL) || (dataLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTDATA;
    }
    else if(ptr_inSign == NULL)
    {
         ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (ptr_pubKeyDer == NULL) || (pubKeyBufLen == 0u) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    else if( (maskHashType_en <= CRYPTO_HASH_INVALID) || (maskHashType_en >= CRYPTO_HASH_MAX) )
    {    
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_MASKHASHTYPE;
    }
    else if( (rsaSessionId <= 0u) || (rsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(rsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_DIGISIGN_RSA_NO_PADDING == true)))>
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_rsaStat_en = Crypto_DigiSign_Wc_Rsa_NoPadding_VerifyData(ptr_inData, dataLen, ptr_inSign, ptr_pubKeyDer, pubKeyBufLen, maskHashType_en);
                break; 
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING -->        
       
            default:
                ret_rsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        } 
    }
    return ret_rsaStat_en;
}
</#if><#-- CRYPTO_WC_DIGISIGN_RSA_NO_PADDING --> 

<#if (CRYPTO_HW_ECDSA?? && (CRYPTO_HW_ECDSA == true) && (driver_defines?contains("HAVE_CRYPTO_HW_CAM_05346_DRIVER") || driver_defines?contains("HAVE_CRYPTO_HW_HSM_LITE_04777_DRIVER")))>
// *****************************************************************************
// *****************************************************************************
// Section: Non-Blocking Crypto APIS
// *****************************************************************************
// *****************************************************************************

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Sign_Start(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_privKey, 
                                                            uint32_t privKeyLen, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
    
    if(Crypto_DigiSign_Ecdsa_Sign_GetStatus() == CRYPTO_DIGISIGN_OPERATION_IN_PROGRESS)
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_PKE_BUSY;
    }
    else if( (ptr_inputHash == NULL) || (hashLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if( (eccCurveType_En <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_En >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    }
    else if( (ptr_privKey == NULL) || (privKeyLen == 0u))
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PRIVKEY;
    }
    else if((ecdsaSessionId == 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {
            case CRYPTO_HANDLER_HW_INTERNAL:
            	ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Sign_Start(ptr_inputHash, hashLen, ptr_privKey, privKeyLen, eccCurveType_En);     	
                break;             
            default:
                ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                break;
        }
    }
    
    return ret_ecdsaStat_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Verify_Start(crypto_HandlerType_E ecdsaHandlerType_en, uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_inputSig, 
                                                           uint32_t sigLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_ALGONOTSUPPTD;
        
    if(Crypto_DigiSign_Ecdsa_Verify_GetStatus() == CRYPTO_DIGISIGN_OPERATION_IN_PROGRESS)
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_PKE_BUSY;
    }
    else if( (ptr_inputHash == NULL) || (hashLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_INPUTHASH;
    }
    else if( (ptr_inputSig == NULL) || (sigLen == 0u) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if( (eccCurveType_En <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_En >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    else if( (ptr_pubKey == NULL) || (pubKeyLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEY;
    }
    //Check the Key compression Type, 0x04 for uncompressed, 0x02 for Even compressed and 0x03 for Odd compressed
    else if( !( (ptr_pubKey[0] == 0x04u) || ((ptr_pubKey[0] == 0x02u) || (ptr_pubKey[0] == 0x03u)) ) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEYCOMPRESS;
    }
    else if((ecdsaSessionId == 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {         
            case CRYPTO_HANDLER_HW_INTERNAL:
            	    ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Verify_Start(ptr_inputHash, hashLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, 
                                        eccCurveType_En);
            	    break;
                default:
                    ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HDLR;
                    break;         
        }
    }
        
    return ret_ecdsaStat_en;
}

crypto_DigiSign_Status_E  Crypto_DigiSign_Ecdsa_Sign_GetStatus(void)
{
    return Crypto_DigiSign_Ecdsa_Hw_Sign_GetStatus();
}

crypto_DigiSign_Status_E  Crypto_DigiSign_Ecdsa_Verify_GetStatus(void)
{
    return Crypto_DigiSign_Ecdsa_Hw_Verify_GetStatus();
}

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Sign_GetResult(uint8_t *ptr_outputSig, uint32_t sigLen)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    
    if( (ptr_outputSig == NULL) || (sigLen == 0u) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SIGNATURE;
    }
    else if(Crypto_DigiSign_Ecdsa_Hw_GetState() == CRYPTO_PROCESS_STARTED)
    {
        ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Sign_GetStatus();
        if(ret_ecdsaStat_en == CRYPTO_DIGISIGN_OPERATION_COMPLETED)
        {
            ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Sign_GetResult(ptr_outputSig, sigLen);
            Crypto_DigiSign_Ecdsa_Hw_SetState(CRYPTO_PROCESS_COMPLETE);
        }
        else
        {
            ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_OPERATION_INCOMPLETE;
        }
    }else {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_NO_OPERATION_REQUESTED;
    }
    
    return ret_ecdsaStat_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Ecdsa_Verify_GetResult(void)
{
    crypto_DigiSign_Status_E ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    
    if(Crypto_DigiSign_Ecdsa_Hw_GetState() == CRYPTO_PROCESS_STARTED)
    {
        ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Verify_GetStatus();
        if(ret_ecdsaStat_en == CRYPTO_DIGISIGN_OPERATION_COMPLETED)
        {
            ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Verify_GetResult();
            Crypto_DigiSign_Ecdsa_Hw_SetState(CRYPTO_PROCESS_COMPLETE);
        }
        else
        {
            ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_OPERATION_INCOMPLETE;
        }
    }
    else
    {
         ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_NO_OPERATION_REQUESTED;
    }
    
    return ret_ecdsaStat_en;
}

void Crypto_DigiSign_Ecdsa_SignComplete_CallbackRegister(void (*handler)(void))
{
    CRYPTO_Int_Hw_SignComplete_CallbackRegister(handler);
}

void Crypto_DigiSign_Ecdsa_VerifyComplete_CallbackRegister(void (*handler)(void))
{
    CRYPTO_Int_Hw_VerifyComplete_CallbackRegister(handler);
}
</#if><#-- CRYPTO_HW_ECDSA &&  HAVE_CRYPTO_HW_CAM_05346_DRIVER--> 