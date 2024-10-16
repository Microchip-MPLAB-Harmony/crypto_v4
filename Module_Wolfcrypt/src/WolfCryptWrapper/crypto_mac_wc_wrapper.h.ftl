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