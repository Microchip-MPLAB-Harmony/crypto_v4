/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_asym_cipher.h

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

#ifndef CRYPTO_ASYM_CIPHER_H
#define CRYPTO_ASYM_CIPHER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/crypto_common.h"
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP == true)))>
#include "crypto/common_crypto/crypto_hash.h"
</#if><#-- CRYPTO_WC_ASYM_RSA_OAEP --> 
// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************

typedef enum
{
    CRYPTO_ASYM_ERROR_CIPNOTSUPPTD = -127,   //Error when Cipher Algorithm is not supported by Crypto software component
    CRYPTO_ASYM_ERROR_CTX = -126,            //Error when Context pointer is NULL
    CRYPTO_ASYM_ERROR_KEY = -125,            //Error when Key length is above or below its range Or Key pointer is NULL
    CRYPTO_ASYM_ERROR_HDLR = -124,           //Error when Handler Type is Invalid
    CRYPTO_ASYM_ERROR_PADDING = -123,         //Error when Padding Mode (PKCSv1.5, OAEP) is Invalid
    CRYPTO_ASYM_ERROR_INPUTDATA = -121,      //Error when input data length is 0 or its pointer is NULL 
    CRYPTO_ASYM_ERROR_OUTPUTDATA = -120,     //Error when Output Data pointer is NULL        
    CRYPTO_ASYM_ERROR_SID = -118,            //Error when Session ID is 0 or Its value is more than Max. session configure in configurations
    CRYPTO_ASYM_ERROR_ARG = -117,            //Error when any other argument is Invalid
    CRYPTO_ASYM_ERROR_CIPFAIL = -116,        //Error when Encryption or Decryption operation failed due to any reason
    CRYPTO_ASYM_CIPHER_SUCCESS = 0,        
}crypto_Asym_Status_E;

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15 == true)))>
crypto_Asym_Status_E Crypto_Asym_Rsa_Pkcs1v15_Encrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, 
															                                          crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID);

crypto_Asym_Status_E Crypto_Asym_Rsa_Pkcs1v15_Decrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outputData, uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, 
																		                                      crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID);
</#if><#-- lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_PKCS1_V15  -->

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP == true)))>														
crypto_Asym_Status_E Crypto_Asym_Rsa_Oaep_Encrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, 
                                                                                    crypto_Hash_Algo_E hashType_en, crypto_HandlerType_E rsaHandlerType_en, 
                                                                                    uint8_t *ptr_label, uint32_t labelLen, uint32_t sessionID);
crypto_Asym_Status_E Crypto_Asym_Rsa_Oaep_Decrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData,  uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, 
															crypto_Hash_Algo_E hashType_en, crypto_HandlerType_E rsaHandlerType_en, 
															uint8_t *ptr_label, uint32_t labelLen, uint32_t sessionID);
</#if><#-- lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_OAEP  -->

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING?? &&(lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING == true)))>	
crypto_Asym_Status_E Crypto_Asym_Rsa_NoPadding_Encrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_pubKeyDer, uint32_t pubKeyBufLen, 
															                                        crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID);
crypto_Asym_Status_E Crypto_Asym_Rsa_NoPadding_Decrypt(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData, uint8_t *ptr_privKeyDer, uint32_t privKeyBufLen, 
															                                            crypto_HandlerType_E rsaHandlerType_en, uint32_t sessionID);																									
</#if><#-- lib_wolfcrypt.CRYPTO_WC_ASYM_RSA_NO_PADDING  -->

#endif //CRYPTO_ASYM_CIPHER_H
