/*******************************************************************************
 HSM Lite Crypto Driver definitions

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypt_hsmlite.h

  Summary:
    HSM Lite Crypto Driver definitions

  Description:
 This file includes the common hsmlite definitions that are shared between
 multiple cryptographic algorithms
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

#ifndef DRV_CRYPT_HSMLITE_H
#define DRV_CRYPT_HSMLITE_H

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

    enum { // Supported Hash types
        DRV_CRYPT_HSMLITE_SHA_1,
        DRV_CRYPT_HSMLITE_SHA_2_224,
        DRV_CRYPT_HSMLITE_SHA_2_256,
        DRV_CRYPT_HSMLITE_SHA_2_384,
        DRV_CRYPT_HSMLITE_SHA_2_512,
    };

    enum // Status
    {
        DRV_CRYPTO_HSMLITE_INVALID_KEYSIZE = -1005,
        DRV_CRYPTO_HSMLITE_INVALID_IV_SIZE = -1004,
        DRV_CRYPTO_HSMLITE_INVALID_HASH_TYPE  = -1002,
        DRV_CRYPTO_HSMLITE_DIGEST_TOO_SMALL  = -1001,
        DRV_CRYPTO_HSMLITE_NOT_HASH_BLOCK_SIZE = -1000,
        DRV_CRYPTO_HSMLITE_RESET_NEEDED = -82,
        DRV_CRYPTO_HSMLITE_FEED_AFTER_DATA = -73,
        DRV_CRYPTO_HSMLITE_CONTEXT_SAVING_NOT_SUPPORTED = -72,
        DRV_CRYPTO_HSMLITE_HW_KEY_NOT_SUPPORTED = -71,
        DRV_CRYPTO_HSMLITE_WRONG_SIZE_GRANULARITY = -70,
        DRV_CRYPTO_HSMLITE_FEED_COUNT_EXCEEDED = -69,
        DRV_CRYPTO_HSMLITE_INVALID_NONCE_SIZE = -68,
        DRV_CRYPTO_HSMLITE_INVALID_TAG_SIZE = -67,
        DRV_CRYPTO_HSMLITE_INVALID_KEY_SZ = -66,
        DRV_CRYPTO_HSMLITE_TOO_SMALL = -65,
        DRV_CRYPTO_HSMLITE_TOO_BIG = -64,
        DRV_CRYPTO_HSMLITE_ALLOCATION_TOO_SMALL = -35,
        DRV_CRYPTO_HSMLITE_INVALID_KEYREF = -34,
        DRV_CRYPTO_HSMLITE_UNITIALIZED_OBJ = -33,
        DRV_CRYPTO_HSMLITE_DMA_FAILED = -32,
        DRV_CRYPTO_HSMLITE_INVALID_TAG = -16,
        DRV_CRYPTO_HSMLITE_INCOMPATIBLE_HW = -3,
        DRV_CRYPTO_HSMLITE_RETRY = -2,
        DRV_CRYPTO_HSMLITE_HW_PROCESSING  = -1,
        DRV_CRYPTO_HSMLITE_STATUS_OK,
        DRV_CRYPTO_HSMLITE_INVALID_PARAM,
        DRV_CRYPTO_HSMLITE_UNKNOWN_ERROR,        
        DRV_CRYPTO_HSMLITE_PK_BUSY = 3,
        DRV_CRYPTO_HSMLITE_NOT_QUADRATIC_RESIDUE,
        DRV_CRYPTO_HSMLITE_COMPOSITE_VALUE,
        DRV_CRYPTO_HSMLITE_NOT_INVERTIBLE,
        DRV_CRYPTO_HSMLITE_INVALID_SIGNATURE,
        DRV_CRYPTO_HSMLITE_NOT_IMPLEMENTED,
        DRV_CRYPTO_HSMLITE_INVALID_MICROCODE,
        DRV_CRYPTO_HSMLITE_OUT_OF_RANGE,
        DRV_CRYPTO_HSMLITE_INVALID_MODULUS,
        DRV_CRYPTO_HSMLITE_POINT_NOT_ON_CURVE,
        DRV_CRYPTO_HSMLITE_OPERAND_TOO_LARGE,
        DRV_CRYPTO_HSMLITE_PLATFORM_ERROR,
        DRV_CRYPTO_HSMLITE_EXPIRED,
        DRV_CRYPTO_HSMLITE_IK_MODE,
        DRV_CRYPTO_HSMLITE_INVALID_CURVE_PARAM,
        DRV_CRYPTO_HSMLITE_IK_NOT_READY,
        DRV_CRYPTO_HSMLITE_PK_RETRY,
        DRV_CRYPTO_HSMLITE_BAD_ORDER
    };

    
// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************


    
// *****************************************************************************
// *****************************************************************************
// Section: Device Layer System Interface Routines
// *****************************************************************************
// *****************************************************************************
    
    
    
    void DRV_CRYPT_HSMLITE_Enable(void);
    void DRV_CRYPT_HSMLITE_Disable(void);
    uint8_t DRV_CRYPT_HSMLITE_Status(void); // Returns 0 on disable and non 0 on enable
    
        
        
// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

}

#endif
// DOM-IGNORE-END  


#endif //DRV_CRYPT_HSMLITE_H