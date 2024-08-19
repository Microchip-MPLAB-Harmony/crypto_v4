/**************************************************************************
  Crypto Framework Library Header

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_ecdh_hw_cpkcl.h
  
  Summary:
    Crypto Framework Library header for the CPKCC ECDH functions.

  Description:
    This header contains the function definitions for the CPKCC ECDH functions.
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

#ifndef DRV_CRYPTO_ECDH_HW_CPKCL_H
#define DRV_CRYPTO_ECDH_HW_CPKCL_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "CryptoLib_CPKCL/CryptoLib_typedef_pb.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

typedef enum
{
    CRYPTO_ECDH_RESULT_SUCCESS, 
    CRYPTO_ECDH_RESULT_INIT_FAIL,
    CRYPTO_ECDH_ERROR_PUBKEYCOMPRESS,
    CRYPTO_ECDH_RESULT_ERROR_CURVE,        
    CRYPTO_ECDH_RESULT_ERROR_FAIL
} CRYPTO_ECDH_RESULT;

// *****************************************************************************
// *****************************************************************************
// Section: CPKCC ECDH Common Interface 
// *****************************************************************************
// *****************************************************************************

CRYPTO_ECDH_RESULT DRV_CRYPTO_ECDH_InitEccParams(CPKCL_ECC_DATA *pEccData, 
    pfu1 privKey, u4 privKeyLen, pfu1 pubKey, CRYPTO_CPKCL_CURVE eccCurveType);
    
CRYPTO_ECDH_RESULT DRV_CRYPTO_ECDH_GetSharedKey(CPKCL_ECC_DATA *pEccData, 
    pfu1 sharedKey);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* DRV_CRYPTO_ECDH_HW_CPKCL_H */