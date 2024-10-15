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

#include "crypto/common_crypto/crypto_kas_hsm03785_wrapper.h"
#include "crypto/common_crypto/crypto_hsm03785_common_wrapper.h"
#include "crypto/drivers/hsm_kas.h"

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