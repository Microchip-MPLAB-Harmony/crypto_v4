/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hsm03785_common_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for the common Function across HW Wrappers.

  Description:
    This source file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for key agreement.
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/drivers/wrapper/crypto_hsm03785_common_wrapper.h"
#include "crypto/drivers/driver/hsm_common.h"
// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************
<#if   (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
    || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
    || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true))
	|| (CRYPTO_HW_AES_GCM?? &&(CRYPTO_HW_AES_GCM == true))>
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
</#if>
<#if (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) || (CRYPTO_HW_ECDH?? &&(CRYPTO_HW_ECDH == true))>

hsm_Ecc_CurveType_E Crypto_Hw_ECC_GetEccCurveType(crypto_EccCurveType_E eccCurveType_en)
{
    hsm_Ecc_CurveType_E hsmCurveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
    
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
            hsmCurveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
        break;       
    };
    return hsmCurveType_en;
}
</#if>