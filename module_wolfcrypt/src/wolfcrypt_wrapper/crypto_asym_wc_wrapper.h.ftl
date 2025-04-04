/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_asym_wc_wrapper.h

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

#ifndef CRYPTO_ASYM_WC_WRAPPER_H
#define CRYPTO_ASYM_WC_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "wolfssl/wolfcrypt/error-crypt.h"

// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// ***************************************************************************** 
<#if (CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true))>
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Pkcs1v15_Encrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen);
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Pkcs1v15_Decrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen);
</#if> <#-- CRYPTO_WC_ASYM_RSA_PKCS1_V15 -->

<#if (CRYPTO_WC_ASYM_RSA_OAEP?? &&(CRYPTO_WC_ASYM_RSA_OAEP == true))>
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Oaep_Encrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen, 
                                                                                                crypto_Hash_Algo_E wcMaskHashType_en, uint8_t *ptr_wcLabel, uint32_t wcLabelLen);
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_Oaep_Decrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint32_t wcOutDatLen, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen, 
                                                                                                crypto_Hash_Algo_E wcMaskHashType_en, uint8_t *ptr_wcLabel, uint32_t wcLabelLen);
</#if> <#-- CRYPTO_WC_ASYM_RSA_OAEP -->

<#if (CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(CRYPTO_WC_ASYM_RSA_NO_PADDING == true))>
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_NoPadding_Encrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPubKeyDer, uint32_t wcPubKeyBufLen);
crypto_Asym_Status_E Crypto_Asym_Wc_Rsa_NoPadding_Decrypt(uint8_t *ptr_wcInData, uint32_t wcDataLen, uint8_t *ptr_wcOutData, uint8_t *ptr_wcPrivKeyDer, uint32_t wcPrivKeyBufLen);
</#if><#-- CRYPTO_WC_ASYM_RSA_NO_PADDING  -->

#endif //CRYPTO_ASYM_WC_WRAPPER_H