/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_cpkcc44163_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for the key agreement in the 
    hardware cryptographic library.

  Description:
    This source file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for key agreement.
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/drivers/HwWrapper/crypto_kas_cpkcc44163_wrapper.h"
#include "crypto/drivers/Driver/drv_crypto_ecc_hw_cpkcl.h"
#include "crypto/drivers/Driver/drv_crypto_ecdh_hw_cpkcl.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

static crypto_Kas_Status_E lCrypto_Kas_Ecdh_Hw_GetCurve(
    crypto_EccCurveType_E eccCurveType, CRYPTO_CPKCL_CURVE *hwEccCurve)
{
    crypto_Kas_Status_E kasStatus = CRYPTO_KAS_SUCCESS;
    
    switch (eccCurveType)
    {     
        case CRYPTO_ECC_CURVE_P192:
            *hwEccCurve = CRYPTO_CPKCL_CURVE_P192;
            break;
        
        case CRYPTO_ECC_CURVE_P224:
            *hwEccCurve = CRYPTO_CPKCL_CURVE_P224;
            break;
        
        case CRYPTO_ECC_CURVE_P256:
            *hwEccCurve = CRYPTO_CPKCL_CURVE_P256;
            break;
        
        case CRYPTO_ECC_CURVE_P384:
            *hwEccCurve = CRYPTO_CPKCL_CURVE_P384;
            break;
        
        case CRYPTO_ECC_CURVE_P521:
            *hwEccCurve = CRYPTO_CPKCL_CURVE_P521;
            break;
        
        default:
            kasStatus = CRYPTO_KAS_ERROR_CURVE;
            break;
    }
    
    return kasStatus;
}    

static crypto_Kas_Status_E lCrypto_Kas_Ecdh_Hw_MapResult(
    CRYPTO_ECDH_RESULT result)
{
    crypto_Kas_Status_E kasStatus;
    
    switch (result) 
    {
        case CRYPTO_ECDH_RESULT_SUCCESS:
            kasStatus = CRYPTO_KAS_SUCCESS;
            break;
            
        case CRYPTO_ECDH_RESULT_ERROR_CURVE:
            kasStatus = CRYPTO_KAS_ERROR_CURVE;
            break;
        
        case CRYPTO_ECDH_RESULT_INIT_FAIL:
        case CRYPTO_ECDH_RESULT_ERROR_FAIL:
            kasStatus = CRYPTO_KAS_ERROR_FAIL;
            break;
            
        default:
            kasStatus = CRYPTO_KAS_ERROR_FAIL;
            break;
    }
    
    return kasStatus;
}

// *****************************************************************************
// *****************************************************************************
// Section: Kas Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

crypto_Kas_Status_E Crypto_Kas_Ecdh_Hw_SharedSecret(uint8_t *privKey, 
    uint32_t privKeyLen, uint8_t *pubKey, uint32_t pubKeyLen, 
    uint8_t *secret, uint32_t secretLen, crypto_EccCurveType_E eccCurveType_en)
{
    crypto_Kas_Status_E result;
    CRYPTO_ECDH_RESULT hwResult;
    CPKCL_ECC_DATA eccData;
    CRYPTO_CPKCL_CURVE hwEccCurve;

    /* Get curve */
    result = lCrypto_Kas_Ecdh_Hw_GetCurve(eccCurveType_en, &hwEccCurve);
    if (result != CRYPTO_KAS_SUCCESS)
    {
        return result;
    }
     
    hwResult = DRV_CRYPTO_ECDH_InitEccParams(&eccData, privKey, (u4) privKeyLen,
                                             pubKey, hwEccCurve);
    if (hwResult != CRYPTO_ECDH_RESULT_SUCCESS) 
    {
        return lCrypto_Kas_Ecdh_Hw_MapResult(hwResult);
        
    }
    
    /* Get shared key */
    hwResult = DRV_CRYPTO_ECDH_GetSharedKey(&eccData, (pfu1)secret);

    return lCrypto_Kas_Ecdh_Hw_MapResult(hwResult);     
}
