/*******************************************************************************
 HSM Lite Hash Crypto Driver definitions

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypt_hsmlite_hmac.h

  Summary:
    HSM Lite Crypto Driver definitions

  Description:
 This file includes the common hsmlite definitions that deal with hardware hashing
*******************************************************************************/

//DOM-IGNORE-BEGIN
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
// DOM-IGNORE-END

#ifndef DRV_CRYPT_HSMLITE_HMAC_H
#define DRV_CRYPT_HSMLITE_HMAC_H

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

extern "C" {

#endif
// DOM-IGNORE-END  

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
    
// *****************************************************************************
// *****************************************************************************
// Section: Constants
// *****************************************************************************
// *****************************************************************************

    
    
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

    typedef struct {
       uint8_t data[220];
    }DRV_CRYPT_HSMLITE_HMAC_CTX;
    
// *****************************************************************************
// *****************************************************************************
// Section: Device Layer System Interface Routines
// *****************************************************************************
// *****************************************************************************
    
int32_t DRV_CRYPTO_HSMLITE_Hmac_MacDirect(DRV_CRYPT_HSMLITE_HMAC_CTX *ptr_hmacCtx, uint32_t hashType_en, uint8_t *ptr_inputKey, uint32_t keyLen, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
int32_t DRV_CRYPTO_HSMLITE_Hmac_Init(DRV_CRYPT_HSMLITE_HMAC_CTX *ptr_hmacCtx, uint32_t hashType_en, uint8_t *ptr_inputKey, uint32_t keyLen);
int32_t DRV_CRYPTO_HSMLITE_Hmac_Update(DRV_CRYPT_HSMLITE_HMAC_CTX *ptr_hmacCtx, uint8_t *ptr_inputData, uint32_t dataLen);
int32_t DRV_CRYPTO_HSMLITE_Hmac_Final(DRV_CRYPT_HSMLITE_HMAC_CTX *ptr_hmacCtx, uint8_t *ptr_leftoverInData, uint32_t dataLen, uint8_t *ptr_OutputData);
        
int32_t DRV_CRYPTO_HSMLITE_Hmac_Status(DRV_CRYPT_HSMLITE_HMAC_CTX *ptr_hmacCtx);


// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

}

#endif
// DOM-IGNORE-END  


#endif //DRV_CRYPT_HSMLITE_HMAC_H