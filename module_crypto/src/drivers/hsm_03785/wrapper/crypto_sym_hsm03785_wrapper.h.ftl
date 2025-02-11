/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_hsm03785_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for hardware AES.

  Description:
    This header file contains the wrapper interface to access the symmetric 
    AES algorithms in the AES hardware driver for Microchip microcontrollers.
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

#ifndef CRUPTO_SYM_HSM03785_WRAPPER_H
#define CRUPTO_SYM_HSM03785_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_sym_cipher.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Symmetric Algorithms Common Interface 
// *****************************************************************************
// *****************************************************************************
<#if    (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    ||  (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    ||  (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true))>
crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Init(void *ptr_aesCtx, crypto_CipherOper_E cipherOpType_en, crypto_Sym_OpModes_E opMode_en, 
                                                                    uint8_t *ptr_key, uint32_t keySize, uint8_t *ptr_initVect);
crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Cipher(void *ptr_aesCtx, uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut);
crypto_Sym_Status_E Crypto_Sym_Hw_Aes_CipherDirect(crypto_CipherOper_E cipherOpType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect);
</#if>
<#if 	(CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
    ||  (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>
//crypto_Sym_Status_E Crypto_Sym_Hw_Tdes_Init(void *ptr_tdesCtx, crypto_CipherOper_E cipherOpType_en, 
//                                                    crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_key, uint8_t *ptr_initVect);
//crypto_Sym_Status_E Crypto_Sym_Hw_Tdes_Cipher(void *ptr_tdesCtx, uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut);
//crypto_Sym_Status_E Crypto_Sym_Hw_Tdes_CipherDirect(crypto_CipherOper_E cipherOpType_en, crypto_Sym_OpModes_E opMode_en, uint8_t *ptr_inputData, 
//                                                        uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_key, uint32_t keyLen, uint8_t *ptr_initVect);
</#if>
// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

#endif /* CRUPTO_SYM_HSM03785_WRAPPER_H */
