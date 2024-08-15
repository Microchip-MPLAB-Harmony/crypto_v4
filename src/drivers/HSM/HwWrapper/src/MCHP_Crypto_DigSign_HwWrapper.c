/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_DigSign_HwWrapper.c

  Summary:
    Crypto Framework Library wrapper file for the digital signature in the 
    hardware cryptographic library.

  Description:
    This source file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for digital signature.
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

#include "crypto/common_crypto/MCHP_Crypto_DigSign_HwWrapper.h"
#include "crypto/common_crypto/MCHP_Crypto_Common_HwWrapper.h"
#include "crypto/drivers/hsm_sign.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: DigSign Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_Sign(uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_privKey, 
                                                       uint32_t privKeyLen, uint8_t *ptr_randomNumber, crypto_EccCurveType_E eccCurveType_en)
{
    crypto_DigiSign_Status_E digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    hsm_Ecc_CurveType_E curveType_en = HSM_ECC_MAX_CURVE;
    hsm_Cmd_Status_E hsmStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_DigiSign_Cmd ecdsaCmd_st[1];
    
    curveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
    if(curveType_en != HSM_ECC_MAX_CURVE)
    {
        hsmStatus_en = Hsm_DigiSign_Ecdsa_Sign(ecdsaCmd_st, ptr_inputHash, hashLen, ptr_Sig, sigLen,
                                                ptr_privKey, privKeyLen, ptr_randomNumber, curveType_en); //?????????????? random number ???
        if(hsmStatus_en == HSM_CMD_SUCCESS)
        {
            digiSignStatus_en = CRYPTO_DIGISIGN_SUCCESS;
        }
        else
        {
            digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
        }
    }
    else
    {
        digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    
    return digiSignStatus_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_Verify(uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_pubKey, 
                                                       uint32_t pubKeyLen, int8_t *ptr_verifyStatus, crypto_EccCurveType_E eccCurveType_en)
{
    crypto_DigiSign_Status_E digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    hsm_Ecc_CurveType_E curveType_en = HSM_ECC_MAX_CURVE;
    hsm_Cmd_Status_E hsmStatus_en = HSM_CMD_ERROR_FAILED;
    st_Hsm_DigiSign_Cmd ecdsaCmd_st[1];
    
    curveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
    if(curveType_en != HSM_ECC_MAX_CURVE)
    {
        hsmStatus_en =  Hsm_DigiSign_Ecdsa_Verify(ecdsaCmd_st, ptr_inputHash, hashLen, ptr_Sig, sigLen,
                                                ptr_pubKey, pubKeyLen, ptr_verifyStatus, curveType_en);
        if(hsmStatus_en == HSM_CMD_SUCCESS)
        {
            digiSignStatus_en = CRYPTO_DIGISIGN_SUCCESS;
        }
        else
        {
            digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
        }
    }
    else
    {
        digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_CURVE;
    }
    
    return digiSignStatus_en;
}