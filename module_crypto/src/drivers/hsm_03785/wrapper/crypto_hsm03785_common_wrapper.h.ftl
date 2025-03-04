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