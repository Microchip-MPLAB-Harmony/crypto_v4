/*******************************************************************************
 HSM Lite Hash Crypto Driver definitions

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypt_hsmlite_aes.h

  Summary:
    HSM Lite Crypto Driver definitions

  Description:
 This file includes the common hsmlite definitions that deal with hardware AES
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

#ifndef DRV_CRYPT_HSMLITE_AES_H
#define DRV_CRYPT_HSMLITE_AES_H

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
   uint8_t data[244];
}DRV_CRYPT_HSMLITE_AES_CTX;

typedef struct {
   uint8_t data[368];
}DRV_CRYPT_HSMLITE_AES_AEAD_CTX;

typedef struct {
   uint8_t data[220];
}DRV_CRYPT_HSMLITE_AES_CMAC_CTX;


// *****************************************************************************
// *****************************************************************************
// Section: Device Layer System Interface Routines
// *****************************************************************************
// *****************************************************************************

int32_t DRV_CRYPT_HSMLITE_AES_ECB_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize);
int32_t DRV_CRYPT_HSMLITE_AES_ECB_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize);

int32_t DRV_CRYPT_HSMLITE_AES_CBC_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);
int32_t DRV_CRYPT_HSMLITE_AES_CBC_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);

int32_t DRV_CRYPT_HSMLITE_AES_CTR_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);
int32_t DRV_CRYPT_HSMLITE_AES_CTR_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);

int32_t DRV_CRYPT_HSMLITE_AES_CFB_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);
int32_t DRV_CRYPT_HSMLITE_AES_CFB_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);

int32_t DRV_CRYPT_HSMLITE_AES_OFB_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);
int32_t DRV_CRYPT_HSMLITE_AES_OFB_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);

int32_t DRV_CRYPT_HSMLITE_AES_GCM_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);
int32_t DRV_CRYPT_HSMLITE_AES_GCM_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * iv, uint32_t ivSize);
    
int32_t DRV_CRYPT_HSMLITE_AES_XTS_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * key2, uint32_t key2Size, uint8_t * iv, uint32_t ivSize);
int32_t DRV_CRYPT_HSMLITE_AES_XTS_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * key2, uint32_t key2Size, uint8_t * iv, uint32_t ivSize);

int32_t DRV_CRYPT_HSMLITE_AES_CCM_CreateEncrypt(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * nonce, uint32_t nonceSize, uint32_t tagSz, uint32_t aadSz, uint32_t dataSz);
int32_t DRV_CRYPT_HSMLITE_AES_CCM_CreateDecrypt(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx, uint8_t * key, uint32_t keySize, uint8_t * nonce, uint32_t nonceSize, uint32_t tagSz, uint32_t aadSz, uint32_t dataSz);

int32_t DRV_CRYPT_HSMLITE_AES_CMAC_Create(DRV_CRYPT_HSMLITE_AES_CMAC_CTX * ctx, uint8_t * key, uint32_t keySize);

int32_t DRV_CRYPT_HSMLITE_AES_AEAD_AddAAD(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx, uint8_t * aad, uint32_t aadSize);

int32_t DRV_CRYPT_HSMLITE_AES_BLK_Crypt(DRV_CRYPT_HSMLITE_AES_CTX * ctx, uint8_t * dataIn, uint8_t * dataOut, uint32_t dataSize, uint8_t initial, uint8_t final);
int32_t DRV_CRYPT_HSMLITE_AES_AEAD_Crypt(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx, uint8_t * dataIn, uint8_t * dataOut, uint32_t dataSize, uint8_t initial, uint8_t final, uint8_t * tag, uint32_t tagSz);
int32_t DRV_CRYPT_HSMLITE_AES_CMAC_AddData(DRV_CRYPT_HSMLITE_AES_CMAC_CTX * ctx, uint8_t * dataIn, uint32_t dataSize);

int32_t DRV_CRYPT_HSMLITE_AES_AEAD_ProduceCmac(DRV_CRYPT_HSMLITE_AES_CMAC_CTX * ctx, uint8_t * cmac, uint32_t cmacSz);

int32_t  DRV_CRYPT_HSMLITE_AES_BLK_Status(DRV_CRYPT_HSMLITE_AES_CTX * ctx);
int32_t  DRV_CRYPT_HSMLITE_AES_AEAD_Status(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx);
int32_t  DRV_CRYPT_HSMLITE_AES_CMAC_Status(DRV_CRYPT_HSMLITE_AES_CMAC_CTX * ctx);

uint8_t * DRV_CRYPT_HSMLITE_AES_BLK_GetExtraMem(DRV_CRYPT_HSMLITE_AES_CTX * ctx);
uint8_t * DRV_CRYPT_HSMLITE_AES_AEAD_GetExtraMem(DRV_CRYPT_HSMLITE_AES_AEAD_CTX * ctx);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

}

#endif
// DOM-IGNORE-END  


#endif //DRV_CRYPT_HSMLITE_AES_H