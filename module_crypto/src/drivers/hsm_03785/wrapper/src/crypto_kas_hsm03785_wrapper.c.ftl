/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_hsm03785_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for the key agreement in the 
    hardware cryptographic library.

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

#include "crypto/drivers/wrapper/crypto_kas_hsm03785_wrapper.h"
#include "crypto/drivers/wrapper/crypto_hsm03785_common_wrapper.h"
#include "crypto/drivers/driver/hsm_kas.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Kas Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
crypto_Kas_Status_E Crypto_Kas_Hw_Ecdh_SharedSecret(uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen, uint8_t *ptr_sharedSecret,
                                                    uint32_t sharedSecretLen, crypto_EccCurveType_E eccCurveType_en)
{
    crypto_Kas_Status_E ret_ecdhStatus_en = CRYPTO_KAS_ERROR_FAIL;
    hsm_Ecc_CurveType_E hsmCurveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
    hsm_Cmd_Status_E hsmEcdhStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_Kas_Dh_Cmd arr_ecdhCmdCtx_st[1] = {0};
    
    hsmCurveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
    if(hsmCurveType_en != HSM_ECC_MAXIMUM_CURVES_LIMIT)
    {
        hsmEcdhStatus_en = Hsm_Kas_Dh_Ecdh_SharedSecret(arr_ecdhCmdCtx_st, ptr_privKey, privKeyLen, &ptr_pubKey[1], (pubKeyLen-1U),
                                            ptr_sharedSecret, (uint16_t)sharedSecretLen, hsmCurveType_en);
        
        if(hsmEcdhStatus_en == HSM_CMD_SUCCESS)
        {
            ret_ecdhStatus_en = CRYPTO_KAS_SUCCESS;
        }
        else
        {
            ret_ecdhStatus_en = CRYPTO_KAS_ERROR_FAIL;
        }
    }
    else
    {
        ret_ecdhStatus_en = CRYPTO_KAS_ERROR_CURVE;
    }
    return ret_ecdhStatus_en;
}