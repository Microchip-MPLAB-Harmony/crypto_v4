/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_wc_common_wrapper.c

  Summary:
    This file contains the Common code for the Wolfcrypt Library application.

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

#include "crypto/common_crypto/crypto_wc_common_wrapper.h"

<#if (CRYPTO_WC_ECDSA?? &&(CRYPTO_WC_ECDSA == true)) || (CRYPTO_WC_ECDH?? &&(CRYPTO_WC_ECDH == true))>
#include "wolfssl/wolfcrypt/ecc.h"


static const int arr_EccCurveWcMap[CRYPTO_WC_ECC_TOTAL_CURVES][2] =  {
                                                                        {(int)CRYPTO_ECC_CURVE_INVALID, (int)ECC_CURVE_INVALID},
                                                                        {(int)CRYPTO_ECC_CURVE_SECP224R1, (int)ECC_SECP224R1}, 
                                                                        {(int)CRYPTO_ECC_CURVE_SECP256R1, (int)ECC_SECP256R1},
                                                                        {(int)CRYPTO_ECC_CURVE_SECP384R1, (int)ECC_SECP384R1},
                                                                        {(int)CRYPTO_ECC_CURVE_SECP521R1, (int)ECC_SECP521R1},
                                                                    };


int Crypto_Common_Wc_Ecc_GetWcCurveId(crypto_EccCurveType_E curveType_en)
{
    int wcCurveId = -1;
    
    for(int curve = 0; curve < CRYPTO_WC_ECC_TOTAL_CURVES; curve++)
    {
        if(curveType_en == (crypto_EccCurveType_E)arr_EccCurveWcMap[curve][0])
        {
            wcCurveId = arr_EccCurveWcMap[curve][1];
            break;
        }
    }
    
    return wcCurveId;
}
</#if> <#-- CRYPTO_WC_ECDSA || CRYPTO_WC_ECDH -->