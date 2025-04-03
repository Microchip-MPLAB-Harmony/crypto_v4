/*******************************************************************************
 HSM Lite Crypto Driver definitions

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypt_hsmlite_ecc.h

  Summary:
    HSM Lite Crypto Driver definitions

  Description:
 This file includes the ECC hsmlite definitions 
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

#ifndef DRV_CRYPT_HSMLITE_PK_H
#define DRV_CRYPT_HSMLITE_PK_H

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
#include <stddef.h>
#include "drv_crypt_hsmlite_common.h"
    
// *****************************************************************************
// *****************************************************************************
// Section: Constants
// *****************************************************************************
// *****************************************************************************

    enum {
        DRV_CRYPT_HSMLITE_PK_OP_256_MIN_SIZE = 2176 + 112,  //for p192, p224 and p256
       DRV_CRYPT_HSMLITE_PK_OP_521_MIN_SIZE = 4096 + 112,  //for p384, p521 - Recommended if only using ECC
        DRV_CRYPT_HSMLITE_PK_OP_2048_MIN_SIZE = 8192 + 112, //for RSA 2048
        DRV_CRYPT_HSMLITE_PK_OP_4096_MIN_SIZE = 16384 + 112 //for RSA 4096 - Recommended if using RSA
    };

    enum {
         DRV_CRYPT_HSMLITE_ECC_CURVE_P192,
         DRV_CRYPT_HSMLITE_ECC_CURVE_P224,
         DRV_CRYPT_HSMLITE_ECC_CURVE_P256,
         DRV_CRYPT_HSMLITE_ECC_CURVE_P384,
         DRV_CRYPT_HSMLITE_ECC_CURVE_P521,
         DRV_CRYPT_HSMLITE_ECC_CURVE_ED25519,
         DRV_CRYPT_HSMLITE_ECC_CURVE_ED448,
         DRV_CRYPT_HSMLITE_ECC_CURVE_X25519,
         DRV_CRYPT_HSMLITE_ECC_CURVE_X448,
         DRV_CRYPT_HSMLITE_ECC_CURVE_P256K1,
    }; // DRV_CRYPT_HSMLITE_ECC_CURVE_ID
    
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

    typedef struct {
       uint8_t data[20];
    } DRV_CRYPT_HSMLITE_ECC_CURVE;
    
    typedef struct {
        uint8_t data[8];
    } DRV_CRYPT_HSMLITE_PK_REQ;
    
    
    typedef uint32_t * DRV_CRYPT_HSMLITE_PK_CNX;    

// *****************************************************************************
// *****************************************************************************
// Section: Device Layer System Interface Routines
// *****************************************************************************
// *****************************************************************************
            
    int32_t DRV_CRYPT_HSMLITE_PK_Open(DRV_CRYPT_HSMLITE_PK_CNX * context, uint8_t * usrMem, uint32_t usrMemSize, uint64_t cmSeed);
    int32_t DRV_CRYPT_HSMLITE_PK_Close(DRV_CRYPT_HSMLITE_PK_CNX context);

    void DRV_CRYPT_HSMLITE_PK_GetCurve_P192(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_P224(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_P256(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_P384(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_P521(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_ED25519(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_ED448(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_X25519(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_X448(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.
    void DRV_CRYPT_HSMLITE_PK_GetCurve_P256K1(DRV_CRYPT_HSMLITE_PK_CNX context, DRV_CRYPT_HSMLITE_ECC_CURVE * curve); // each one gets a function, that way those curves not used aren't compiled in.

    int32_t DRV_CRYPT_HSMLITE_PK_ECDSA_SigVerStart(DRV_CRYPT_HSMLITE_ECC_CURVE curve, int8_t * pubX, size_t pubXSz, int8_t * pubY, size_t pubYSz, int8_t * R, size_t RSz, int8_t * S, size_t SSz, int8_t * hash, size_t hashSz, DRV_CRYPT_HSMLITE_PK_REQ * req);
    int32_t DRV_CRYPT_HSMLITE_PK_ECDSA_SigVerEnd(DRV_CRYPT_HSMLITE_PK_REQ * request);
    int32_t DRV_CRYPT_HSMLITE_PK_ECDSA_SigGenStart(DRV_CRYPT_HSMLITE_ECC_CURVE curve, int8_t * privKey, size_t privKeySz, int8_t * K, size_t KSz, int8_t * hash, size_t hashSz, DRV_CRYPT_HSMLITE_PK_REQ * req);
    void DRV_CRYPT_HSMLITE_PK_ECDSA_SigGenEnd(DRV_CRYPT_HSMLITE_PK_REQ * request, int8_t * R, size_t RSz, int8_t * S, size_t SSz);
    int32_t DRV_CRYPT_HSMLITE_PK_Status(DRV_CRYPT_HSMLITE_PK_REQ * request);

    //int32_t DRV_CRYPT_HSM_PK_ECC_PointMultiply(DRV_CRYPT_HSMLITE_ECC_CURVE * curve, int8_t * pubX, int8_t * pubY, size_t pubSz, int8_t *privkey, size_t privKeySz, int8_t * output, size_t outputSz);
    int32_t DRV_CRYPT_HSMLITE_PK_ModularExponentStart(DRV_CRYPT_HSMLITE_PK_CNX context, uint8_t * input, size_t inputSz, uint8_t * exp, size_t expSz, uint8_t * m, size_t mSz, DRV_CRYPT_HSMLITE_PK_REQ * request);
    int32_t DRV_CRYPT_HSMLITE_PK_ModularExponentEnd(DRV_CRYPT_HSMLITE_PK_REQ * request, uint8_t * output, size_t outputSz);
    
    int32_t DRV_CRYPT_HSMLITE_PK_RSASignGenerateStartPrePadded(DRV_CRYPT_HSMLITE_PK_CNX context, uint8_t * prePaddedHash, size_t hashSz, uint8_t * d, size_t dSz, uint8_t * n, size_t nSz, DRV_CRYPT_HSMLITE_PK_REQ * request);
    int32_t DRV_CRYPT_HSMLITE_PK_RSASignGenerateEndPrePadded(DRV_CRYPT_HSMLITE_PK_REQ * request, uint8_t * signature, size_t signatureSz);
    
    int32_t DRV_CRYPT_HSMLITE_PK_RSASignVerifyStartPrePadded(DRV_CRYPT_HSMLITE_PK_CNX context, uint8_t * signature, size_t signatureSz, uint8_t * e, size_t eSz, uint8_t * n, size_t nSz, DRV_CRYPT_HSMLITE_PK_REQ * request);
    int32_t DRV_CRYPT_HSMLITE_PK_RSASignVerifyEndPrePadded(DRV_CRYPT_HSMLITE_PK_REQ * request, uint8_t * prePaddedHash, size_t hashSz);
    
    int32_t DRV_CRYPT_HSMLITE_PK_RSAEncryptStartPrePadded(DRV_CRYPT_HSMLITE_PK_CNX context, uint8_t * prePaddedMessage, size_t msgSz, uint8_t * e, size_t eSz, uint8_t * n, size_t nSz, DRV_CRYPT_HSMLITE_PK_REQ * request);
    int32_t DRV_CRYPT_HSMLITE_PK_RSAEncryptEndPrePadded(DRV_CRYPT_HSMLITE_PK_REQ * request, uint8_t * cipherText, size_t cipherTextSz);

    int32_t DRV_CRYPT_HSMLITE_PK_RSADecryptStartPrePadded(DRV_CRYPT_HSMLITE_PK_CNX context, uint8_t * cipherText, size_t cipherTextSz, uint8_t * d, size_t dSz, uint8_t * n, size_t nSz, DRV_CRYPT_HSMLITE_PK_REQ * request);
    int32_t DRV_CRYPT_HSMLITE_PK_RSADecryptEndPrePadded(DRV_CRYPT_HSMLITE_PK_REQ * request, uint8_t * messageText, size_t messageSz);
    
    
    
// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

}

#endif
// DOM-IGNORE-END  


#endif //DRV_CRYPT_HSMLITE_PK_H