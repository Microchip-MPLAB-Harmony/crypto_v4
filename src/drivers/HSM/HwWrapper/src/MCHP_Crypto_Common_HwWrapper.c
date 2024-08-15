/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Common_HwWrapper.c

  Summary:
    Crypto Framework Library wrapper file for the common Function across HW Wrappers.

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

#include "crypto/common_crypto/MCHP_Crypto_Common_HwWrapper.h"
#include "crypto/drivers/hsm_common.h"
// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

hsm_Aes_KeySize_E Crypto_Hw_Aes_GetKeySize(uint32_t keyLen)
{
    hsm_Aes_KeySize_E ret_keySize_en = HSM_SYM_AES_KEY_128;
    
    if(keyLen == 16U)
    {
       ret_keySize_en = HSM_SYM_AES_KEY_128;
    }
    else if(keyLen == 24U)
    {
        ret_keySize_en = HSM_SYM_AES_KEY_192;
    }
    else if(keyLen == 32U)
    {
        ret_keySize_en = HSM_SYM_AES_KEY_256;
    }
    else
    {
        ret_keySize_en = HSM_SYM_AES_KEY_128;
    }
    return ret_keySize_en;
}

hsm_Ecc_CurveType_E Crypto_Hw_ECC_GetEccCurveType(crypto_EccCurveType_E eccCurveType_en)
{
    hsm_Ecc_CurveType_E hsmCurveType_en = HSM_ECC_MAX_CURVE;
    
    switch(eccCurveType_en)
    {
        case CRYPTO_ECC_CURVE_P192:        
            hsmCurveType_en = HSM_ECC_CURVETYPE_P192;
        break;
     
        case CRYPTO_ECC_CURVE_P256:       
            hsmCurveType_en = HSM_ECC_CURVETYPE_P256;
        break;
        
        case CRYPTO_ECC_CURVE_P384:
            hsmCurveType_en = HSM_ECC_CURVETYPE_P384;
        break;
        
        case CRYPTO_ECC_CURVE_P521:
            hsmCurveType_en = HSM_ECC_CURVETYPE_P521;
        break;
        
        default:
            hsmCurveType_en = HSM_ECC_MAX_CURVE;
        break;       
    };
    return hsmCurveType_en;
}