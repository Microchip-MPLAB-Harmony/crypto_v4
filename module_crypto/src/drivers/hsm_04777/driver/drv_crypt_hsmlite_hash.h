/*******************************************************************************
 HSM Lite Hash Crypto Driver definitions

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypt_hsmlite_hash.h

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

#ifndef DRV_CRYPT_HSMLITE_HASH_H
#define DRV_CRYPT_HSMLITE_HASH_H

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
       uint8_t data[580];
    }DRV_CRYPT_HSMLITE_HASH_CTX;
    
// *****************************************************************************
// *****************************************************************************
// Section: Device Layer System Interface Routines
// *****************************************************************************
// *****************************************************************************
    
int32_t DRV_CRYPTO_HSMLITE_Hash_DigestDirect(DRV_CRYPT_HSMLITE_HASH_CTX *ptr_hashCtx, uint32_t hashType_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
int32_t DRV_CRYPTO_HSMLITE_HSM_Hash_Init(DRV_CRYPT_HSMLITE_HASH_CTX *ptr_hashCtx, uint32_t hashType_en);
int32_t DRV_CRYPTO_HSMLITE_HSM_Hash_Update(DRV_CRYPT_HSMLITE_HASH_CTX *ptr_hashCtx, uint8_t *ptr_inputData, uint32_t dataLen);
int32_t DRV_CRYPTO_HSMLITE_HSM_Hash_Final(DRV_CRYPT_HSMLITE_HASH_CTX *ptr_hashCtx, uint8_t *ptr_leftoverInData, uint32_t dataLen, uint8_t *ptr_OutputData);
        
int32_t DRV_CRYPTO_HSMLITE_HSM_Hash_Status(DRV_CRYPT_HSMLITE_HASH_CTX *ptr_hashCtx);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

}

#endif
// DOM-IGNORE-END  


#endif //DRV_CRYPT_HSMLITE_HASH_H