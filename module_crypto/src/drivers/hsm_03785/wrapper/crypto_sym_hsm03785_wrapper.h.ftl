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
