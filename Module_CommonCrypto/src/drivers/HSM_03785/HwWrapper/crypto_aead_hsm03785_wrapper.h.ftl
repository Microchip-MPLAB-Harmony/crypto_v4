/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_aead_hsm03785_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for hardware AES.

  Description:
    This header file contains the wrapper interface to access the AEAD 
    algorithms in the AES hardware driver for Microchip microcontrollers.
**************************************************************************/

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

#ifndef CRYPTO_AEAD_HSM03785_WRAPPER_H
#define CRYPTO_AEAD_HSM03785_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

//#include <stdint.h>
//#include "crypto/common_crypto/MCHP_Crypto_Common.h"
//#include "crypto/common_crypto/MCHP_Crypto_Aead_Config.h"
//#include "crypto/common_crypto/MCHP_Crypto_Aead_Cipher.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// ***************************** ************************************************


// *****************************************************************************
// *****************************************************************************
// Section: AEAD Algorithms Common Interface 
// *****************************************************************************
// *****************************************************************************

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Init(void *ptr_aesGcmCtx, crypto_CipherOper_E cipherOper_en, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect,uint32_t ivLen);
//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_AddAad(void *ptr_aesGcmCtx, uint8_t *ptr_aad, uint32_t aadLen);
//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Cipher(void *ptr_aesGcmCtx, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
//crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_Final(void *ptr_aesGcmCtx, uint8_t *ptr_authTag, uint8_t authTagLen);


crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_EncryptAuthDirect(uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_outData, 
                                                      uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t initVectLen, 
                                                      uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen);
    
crypto_Aead_Status_E Crypto_Aead_Hw_AesGcm_DecryptAuthDirect(uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_outData, 
                                                      uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect, uint32_t initVectLen, 
                                                      uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_authTag, uint8_t authTagLen);
#endif /* CRYPTO_AEAD_HSM03785_WRAPPER_H */
