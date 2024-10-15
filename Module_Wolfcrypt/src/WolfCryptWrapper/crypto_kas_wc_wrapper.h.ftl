/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_wc_wrapper.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef CRYPTO_KAS_WC_WRAPPER_H
#define CRYPTO_KAS_WC_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/MCHP_Crypto_Common.h"
#include "crypto/common_crypto/MCHP_Crypto_Kas_Config.h"
// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
<#if (CRYPTO_WC_ECDH?? &&(CRYPTO_WC_ECDH == true))>
crypto_Kas_Status_E Crypto_Kas_Wc_Ecdh_SharedSecret(uint8_t *ptr_wcPrivKey, uint32_t wcPrivKeyLen, uint8_t *ptr_wcPubKey, uint32_t wcPubKeyLen, uint8_t *ptr_wcSharedSecret,
                                                    uint32_t wcSharedSecretLen, crypto_EccCurveType_E wcEccCurveType_en);
</#if> <#-- CRYPTO_WC_ECDH -->

#endif /* CRYPTO_KAS_WC_WRAPPER_H */
