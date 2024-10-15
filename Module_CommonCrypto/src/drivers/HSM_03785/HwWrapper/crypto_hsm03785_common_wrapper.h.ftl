/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hsm03785_common_wrapper.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef CRYPTO_HSM03785_COMMON_WRAPPER_H
#define CRYPTO_HSM03785_COMMON_WRAPPER_H

#include "crypto/drivers/Driver/hsm_common.h"
#include "crypto/common_crypto/MCHP_Crypto_Common.h"

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
hsm_Aes_KeySize_E Crypto_Hw_Aes_GetKeySize(uint32_t keyLen);
hsm_Ecc_CurveType_E Crypto_Hw_ECC_GetEccCurveType(crypto_EccCurveType_E eccCurveType_en);

#endif /* CRYPTO_HSM03785_COMMON_WRAPPER_H */