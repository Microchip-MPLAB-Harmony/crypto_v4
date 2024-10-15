/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_wc_common_wrapper.h

  Summary:
    This header file provides Common Prototypes and definitions for the Wolfcrypt Library.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef CRYPTO_WC_COMMON_WRAPPER_H
#define CRYPTO_WC_COMMON_WRAPPER_H

#include "crypto/common_crypto/MCHP_Crypto_Common.h"

#define CRYPTO_WC_ECC_TOTAL_CURVES (5)

<#if (CRYPTO_WC_ECDSA?? &&(CRYPTO_WC_ECDSA == true)) || (CRYPTO_WC_ECDH?? &&(CRYPTO_WC_ECDH == true))>
int Crypto_Common_Wc_Ecc_GetWcCurveId(crypto_EccCurveType_E curveType_en);
</#if> <#-- CRYPTO_WC_ECDSA || CRYPTO_WC_ECDH -->

#endif /* CRYPTO_WC_COMMON_WRAPPER_H */