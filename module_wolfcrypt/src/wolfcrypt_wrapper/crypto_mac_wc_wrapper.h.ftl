/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_mac_wc_wrapper.h

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

#ifndef CRYPTO_MAC_WC_WRAPPER_H
#define CRYPTO_MAC_WC_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
<#if (CRYPTO_WC_AES_CMAC?? &&(CRYPTO_WC_AES_CMAC == true))>
crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Init(void *ptr_aesCmacCtx, uint8_t *ptr_key, uint32_t keySize);
crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Cipher(void *ptr_aesCmacCtx, uint8_t *ptr_inputData, uint32_t dataLen);
crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Final(void *ptr_aesCmacCtx, uint8_t *ptr_outMac, uint32_t macLen);
crypto_Mac_Status_E Crypto_Mac_Wc_AesCmac_Direct(uint8_t *ptr_inputData, uint32_t inuptLen, uint8_t *ptr_outMac, uint32_t macLen, uint8_t *ptr_key, uint32_t keyLen);
</#if><#-- CRYPTO_WC_AES_CMAC -->
<#if (CRYPTO_WC_AES_GMAC?? &&(CRYPTO_WC_AES_GMAC == true))>

crypto_Mac_Status_E Crypto_Mac_Wc_AesGmac_Init(void *ptr_aesGmacCtx, uint8_t *ptr_key, uint32_t keySize);
crypto_Mac_Status_E Crypto_Mac_Wc_AesGmac_Cipher(void *ptr_aesGmacCtx, uint8_t *ptr_initVect, uint32_t initVectLen, uint8_t *ptr_aad, uint32_t aadLen, 
                                                                                                                uint8_t *ptr_outMac, uint32_t macLen);
crypto_Mac_Status_E Crypto_Mac_Wc_AesGmac_Direct(uint8_t *ptr_initVect, uint32_t initVectLen, uint8_t *ptr_outMac, uint32_t macLen, uint8_t *ptr_key, 
                                                                                                  uint32_t keyLen, uint8_t *ptr_aad, uint32_t aadLen);
</#if><#-- CRYPTO_WC_AES_GMAC -->
        
#endif //CRYPTO_MAC_WC_WRAPPER_H