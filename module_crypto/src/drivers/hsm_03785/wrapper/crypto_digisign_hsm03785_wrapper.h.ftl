/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_digisign_hsm03785_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for the digital signature in the 
    hardware cryptographic library.

  Description:
    This header file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for digital signature.
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

#ifndef CRYPTO_DIGISIGN_HSM03785_WRAPPER_H
#define CRYPTO_DIGISIGN_HSM03785_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_digsign.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: DigSign Common Interface 
// *****************************************************************************
// *****************************************************************************

//crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_Sign(uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_Sig, uint32_t sigLen,  
//                                                       uint8_t *ptr_privKey, uint32_t privKeyLen, crypto_EccCurveType_E eccCurveType_en);
//
//crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_Verify(uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_pubKey, 
//                                                       uint32_t pubKeyLen, int8_t *ptr_verifyStatus, crypto_EccCurveType_E eccCurveType_en);        

crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_SignData(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_privKey, 
                                                                uint32_t privKeyLen, crypto_Hash_Algo_E hashType_en, crypto_EccCurveType_E eccCurveType_en);

crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_VerifyData(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_pubKey, 
                                                    uint32_t pubKeyLen, crypto_Hash_Algo_E hashType_en, int8_t *ptr_verifyStatus, crypto_EccCurveType_E eccCurveType_en);
// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

#endif /* CRYPTO_DIGISIGN_HSM03785_WRAPPER_H */
