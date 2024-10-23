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

 
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/common_crypto/crypto_digsign.h"
#include "crypto/common_crypto/crypto_common.h"
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

<#if ( ((CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) && (driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER"))) 
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
    else if((ecdsaSessionId <= 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
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
<#if driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER")> 
            	ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Sign(ptr_inputHash, hashLen, ptr_outSig, sigLen, ptr_privKey, privKeyLen, eccCurveType_En);            	
</#if><#-- HAVE_CRYPTO_HW_CPKCC_44163_DRIVER -->  
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
                                                    uint8_t *ptr_pubKey, uint32_t pubKeyLen, int8_t *ptr_hashVerifyStat, crypto_EccCurveType_E eccCurveType_En, uint32_t ecdsaSessionId)
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
    else if((ecdsaSessionId <= 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_SID;
    }
    else
    {
        switch(ecdsaHandlerType_en)
        {
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>          
            case CRYPTO_HANDLER_SW_WOLFCRYPT:
                ret_ecdsaStat_en = Crypto_DigiSign_Wc_Ecdsa_VerifyHash(ptr_inputHash, hashLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, ptr_hashVerifyStat, eccCurveType_En);
            	break; 
</#if><#-- CRYPTO_WC_ECDSA -->            
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true))>            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_CPKCC_44163_DRIVER")>
            	ret_ecdsaStat_en = Crypto_DigiSign_Ecdsa_Hw_Verify(ptr_inputHash, hashLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, 
                                        ptr_hashVerifyStat, eccCurveType_En);
</#if><#-- HAVE_CRYPTO_HW_CPKCC_44163_DRIVER --> 
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
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HASHTYPE;
    }
    else if((ecdsaSessionId <= 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
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
<#if (CRYPTO_WC_ECDSA?? &&(CRYPTO_WC_ECDSA == true))>            
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
                                                            crypto_Hash_Algo_E hashType_en, int8_t *ptr_hashVerifyStat, crypto_EccCurveType_E eccCurveType_En, 
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
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_HASHTYPE;
    }
    //Check the Key compression Type, 0x04 for uncompressed, 0x02 for Even compressed and 0x03 for Odd compressed
    else if( !( (ptr_pubKey[0] == 0x04u) || ((ptr_pubKey[0] == 0x02u) || (ptr_pubKey[0] == 0x03u)) ) )
    {
        ret_ecdsaStat_en = CRYPTO_DIGISIGN_ERROR_PUBKEYCOMPRESS;
    }
    else if((ecdsaSessionId <= 0u) || (ecdsaSessionId > (uint32_t)CRYPTO_DIGISIGN_SESSION_MAX) )
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
                                                                            ptr_hashVerifyStat, eccCurveType_En);
            break; 
</#if><#-- CRYPTO_WC_ECDSA -->    
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true))>            
            case CRYPTO_HANDLER_HW_INTERNAL:
<#if driver_defines?contains("HAVE_CRYPTO_HW_HSM_03785_DRIVER")>
            	ret_ecdsaStat_en = Crypto_DigiSign_Hw_Ecdsa_VerifyData(ptr_inputData, dataLen, ptr_inputSig, sigLen, ptr_pubKey, pubKeyLen, 
                                                                            hashType_en, ptr_hashVerifyStat, eccCurveType_En);
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