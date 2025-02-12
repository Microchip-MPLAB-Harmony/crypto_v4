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

//DOM-IGNORE-BEGIN
/*
Copyright (C) 2024, Microchip Technology Inc., and its subsidiaries. All rights reserved.

The software and documentation is provided by microchip and its contributors
"as is" and any express, implied or statutory warranties, including, but not
limited to, the implied warranties of merchantability, fitness for a particular
purpose and non-infringement of third party intellectual property rights are
disclaimed to the fullest extent permitted by law. In no event shall microchip
or its contributors be liable for any direct, indirect, incidental, special,
exemplary, or consequential damages (including, but not limited to, procurement
of substitute goods or services; loss of use, data, or profits; or business
interruption) however caused and on any theory of liability, whether in contract,
strict liability, or tort (including negligence or otherwise) arising in any way
out of the use of the software and documentation, even if advised of the
possibility of such damage.

Except as expressly permitted hereunder and subject to the applicable license terms
for any third-party software incorporated in the software and any applicable open
source software license terms, no license or other rights, whether express or
implied, are granted under any patent or other intellectual property rights of
Microchip or any third party.
*/
//DOM-IGNORE-END

#ifndef CRYPTO_HSM03785_COMMON_WRAPPER_H
#define CRYPTO_HSM03785_COMMON_WRAPPER_H

#include "crypto/drivers/driver/hsm_common.h"
#include "crypto/common_crypto/crypto_common.h"

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
<#if   (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true))
	|| (CRYPTO_HW_AES_GCM?? &&(CRYPTO_HW_AES_GCM == true))>
hsm_Aes_KeySize_E Crypto_Hw_Aes_GetKeySize(uint32_t keyLen);
</#if>
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) || (CRYPTO_HW_ECDH?? &&(CRYPTO_HW_ECDH == true))>
hsm_Ecc_CurveType_E Crypto_Hw_ECC_GetEccCurveType(crypto_EccCurveType_E eccCurveType_en);
</#if>

#endif /* CRYPTO_HSM03785_COMMON_WRAPPER_H */