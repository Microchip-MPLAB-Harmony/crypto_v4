/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas.c

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

#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_kas.h"
<#if (crypto_kas_cpkcc44163_wrapper_h_ftl_flag?? &&(crypto_kas_cpkcc44163_wrapper_h_ftl_flag == true))>
#include "crypto/drivers/wrapper/crypto_kas_cpkcc44163_wrapper.h"
</#if>
<#if (crypto_kas_hsm03785_wrapper_h_ftl_flag?? &&(crypto_kas_hsm03785_wrapper_h_ftl_flag == true))>
#include "crypto/drivers/wrapper/crypto_kas_hsm03785_wrapper.h"
</#if>
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.crypto_kas_wc_wrapper_h_ftl_flag?? &&(lib_wolfcrypt.crypto_kas_wc_wrapper_h_ftl_flag == true)))>
#include "crypto/wolfcrypt/crypto_kas_wc_wrapper.h"
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// *****************************************************************************

<#lt>#define CRYPTO_KAS_SESSION_MAX (1) 

// *****************************************************************************
// *****************************************************************************
// Section: Function Definitions
// *****************************************************************************
// *****************************************************************************

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDH?? &&(lib_wolfcrypt.CRYPTO_WC_ECDH == true))) || (CRYPTO_HW_ECDH?? &&(CRYPTO_HW_ECDH == true))>
crypto_Kas_Status_E Crypto_Kas_Ecdh_SharedSecret(crypto_HandlerType_E ecdhHandlerType_en, uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen,
                                                    uint8_t *ptr_sharedSecret, uint32_t sharedSecretLen, crypto_EccCurveType_E eccCurveType_en, uint32_t ecdhSessionId)
{
    crypto_Kas_Status_E ret_ecdhStat_en = CRYPTO_KAS_ERROR_ALGONOTSUPPTD;
    
    if( (ptr_pubKey == NULL) || (pubKeyLen == 0u) )
    {
        ret_ecdhStat_en = CRYPTO_KAS_ERROR_PUBKEY;
    }
    else if( (ptr_privKey == NULL) || (privKeyLen <= 0u) || (privKeyLen > (uint32_t)CRYPTO_ECC_MAX_KEY_LENGTH) )
    {
         ret_ecdhStat_en = CRYPTO_KAS_ERROR_PRIVKEY;
    }
    else if( (eccCurveType_en <= CRYPTO_ECC_CURVE_INVALID) || (eccCurveType_en >= CRYPTO_ECC_CURVE_MAX) )
    {
         ret_ecdhStat_en = CRYPTO_KAS_ERROR_CURVE;
    }
    else if((ecdhSessionId <= 0u) || (ecdhSessionId > (uint32_t)CRYPTO_KAS_SESSION_MAX) )
    {
        ret_ecdhStat_en = CRYPTO_KAS_ERROR_SID;
    }
    else
    {
        switch(ecdhHandlerType_en)
        {            
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDH?? &&(lib_wolfcrypt.CRYPTO_WC_ECDH == true)))>          
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_ecdhStat_en = Crypto_Kas_Wc_Ecdh_SharedSecret(ptr_privKey, privKeyLen, ptr_pubKey, pubKeyLen, ptr_sharedSecret,
                                                                    sharedSecretLen, eccCurveType_en);
            break; 
</#if><#-- CRYPTO_WC_ECDH -->  
<#if (CRYPTO_HW_ECDH?? &&(CRYPTO_HW_ECDH == true))>      
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER")>
	            ret_ecdhStat_en = Crypto_Kas_Ecdh_Hw_SharedSecret(ptr_privKey, privKeyLen, ptr_pubKey, pubKeyLen, ptr_sharedSecret,
	                                                                    sharedSecretLen, eccCurveType_en);
<#elseif driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")>
                ret_ecdhStat_en =  Crypto_Kas_Hw_Ecdh_SharedSecret(ptr_privKey, privKeyLen, ptr_pubKey, pubKeyLen, ptr_sharedSecret,
                                                                    sharedSecretLen, eccCurveType_en);
</#if><#-- HAVE_CRYPTO_HW_CPKCC_44163_DRIVER, HAVE_CRYPTO_HW_HSM_03785_DRIVER -->
	            break;
</#if><#-- CRYPTO_HW_ECDH -->
            default:
                ret_ecdhStat_en = CRYPTO_KAS_ERROR_HDLR;
                break;
        }
    }
    return ret_ecdhStat_en;
}
</#if><#-- CRYPTO_WC_ECDH || CRYPTO_HW_ECDH -->
