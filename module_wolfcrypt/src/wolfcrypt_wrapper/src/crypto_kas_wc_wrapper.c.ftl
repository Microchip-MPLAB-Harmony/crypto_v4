/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_wc_wrapper.c

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
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_kas.h"
#include "crypto/wolfcrypt/crypto_kas_wc_wrapper.h"
#include "crypto/wolfcrypt/crypto_common_wc_wrapper.h"
#include "wolfssl/wolfcrypt/error-crypt.h"
<#if (CRYPTO_WC_ECDH?? &&(CRYPTO_WC_ECDH == true))>
#include "wolfssl/wolfcrypt/ecc.h"
</#if><#-- CRYPTO_WC_ECDH -->
<#if (CRYPTO_WC_ECDH?? &&(CRYPTO_WC_ECDH == true))>

crypto_Kas_Status_E Crypto_Kas_Wc_Ecdh_SharedSecret(uint8_t *ptr_wcPrivKey, uint32_t wcPrivKeyLen, uint8_t *ptr_wcPubKey, uint32_t wcPubKeyLen, uint8_t *ptr_wcSharedSecret,
                                                    uint32_t wcSharedSecretLen, crypto_EccCurveType_E wcEccCurveType_en)
{
    crypto_Kas_Status_E ret_wcEcdhStat_en = CRYPTO_KAS_ERROR_ALGONOTSUPPTD;
    ecc_key wcEccPrivKey_st;
    ecc_key wcEccPubKey_st;
    int wcEcdhStatus = BAD_FUNC_ARG;
    int wcEccCurveId = (int)ECC_CURVE_INVALID;
    word32 sharedSecretLen = wcSharedSecretLen;
    
    wcEccCurveId = Crypto_Common_Wc_Ecc_GetWcCurveId(wcEccCurveType_en);
    
    if(wcEccCurveId == (int)ECC_CURVE_INVALID)
    {
        ret_wcEcdhStat_en = CRYPTO_KAS_ERROR_CURVE;
    }
    else
    {
        //Process ECC Private Key 
        wcEcdhStatus = wc_ecc_init(&wcEccPrivKey_st);
        if(wcEcdhStatus == 0)
        {
            /* Import private key, public part optional if (pub) passed as NULL */
            wcEcdhStatus = wc_ecc_import_private_key_ex(ptr_wcPrivKey, wcPrivKeyLen, /* private key "d" */
                                                        NULL, 0,            /* public (optional) */
                                                        &wcEccPrivKey_st,
                                                        wcEccCurveId     /* ECC Curve Id */
                                                        );
            if(wcEcdhStatus == 0)
            {
                //Process ECC Public Key 
                wcEcdhStatus = wc_ecc_init(&wcEccPubKey_st);

                if(wcEcdhStatus == 0)
                {
                    /* Import public ECC key in ANSI X9.63 format */
                    wcEcdhStatus = wc_ecc_import_x963_ex(ptr_wcPubKey, wcPubKeyLen, &wcEccPubKey_st, wcEccCurveId);
                    if(wcEcdhStatus == 0)
                    {
                        /* Generate Shared Secret using ECDH*/
                        wcEcdhStatus = wc_ecc_shared_secret(&wcEccPrivKey_st, &wcEccPubKey_st, ptr_wcSharedSecret, &sharedSecretLen);
                    }
                }
            }
        }
        if(wcEcdhStatus == 0)
        {
            ret_wcEcdhStat_en = CRYPTO_KAS_SUCCESS;
        }
        else if(wcEcdhStatus == ECC_CURVE_OID_E)
        {
            ret_wcEcdhStat_en = CRYPTO_KAS_ERROR_CURVE;
        }
        else if( (wcEcdhStatus == BAD_FUNC_ARG) || (wcEcdhStatus == ECC_BAD_ARG_E) )
        {
            ret_wcEcdhStat_en = CRYPTO_KAS_ERROR_ARG;
        }
        else
        {
            ret_wcEcdhStat_en = CRYPTO_KAS_ERROR_FAIL;
        }
    }
    return ret_wcEcdhStat_en;
}
</#if><#-- CRYPTO_WC_ECDH -->
