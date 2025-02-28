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

#ifndef DRV_CRYPTO_ECDH_HW_CPKCL_H
#define DRV_CRYPTO_ECDH_HW_CPKCL_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/drivers/cpkcl_lib/cryptolib_typedef_pb.h"

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