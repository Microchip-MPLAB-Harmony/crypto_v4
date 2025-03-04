/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_digisign_hsm03785_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for the digital signature in the 
    hardware cryptographic library.

  Description:
    This source file contains the wrapper interface to access the hardware 
    cryptographic library in Microchip microcontrollers for digital signature.
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

#include "crypto/drivers/wrapper/crypto_digisign_hsm03785_wrapper.h"
#include "crypto/drivers/wrapper/crypto_hsm03785_common_wrapper.h"
#include "crypto/drivers/driver/hsm_sign.h"
#include "crypto/drivers/wrapper/crypto_hash_hsm03785_wrapper.h"
#include "crypto/drivers/driver/hsm_hash.h"
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
//crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_Sign(uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_privKey, 
//                                                       uint32_t privKeyLen, crypto_EccCurveType_E eccCurveType_en)
//{
//    crypto_DigiSign_Status_E digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
//    hsm_Ecc_CurveType_E curveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
//    hsm_Cmd_Status_E hsmStatus_en = HSM_CMD_ERROR_FAILED;
//    uint8_t *randomNumber = NULL;
//    //random number //?????this need to remove later
////    uint8_t randomNumber[32]= 
////    {
////        0x94,0xa1,0xbb,0xb1,0x4b,0x90,0x6a,0x61,0xa2,0x80,0xf2,0x45,0xf9,0xe9,0x3c,0x7f,
////        0x3b,0x4a,0x62,0x47,0x82,0x4f,0x5d,0x33,0xb9,0x67,0x07,0x87,0x64,0x2a,0x68,0xde
////    };
//    
//    curveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
//    if(curveType_en != HSM_ECC_MAXIMUM_CURVES_LIMIT)
//    {
//        hsmStatus_en = Hsm_DigiSign_Ecdsa_Sign(ptr_inputHash, hashLen, ptr_Sig, ptr_privKey, privKeyLen, randomNumber, curveType_en); //?????????????? random number ???
//        if(hsmStatus_en == HSM_CMD_SUCCESS)
//        {
//            digiSignStatus_en = CRYPTO_DIGISIGN_SUCCESS;
//        }
//        else
//        {
//            digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
//        }
//    }
//    else
//    {
//        digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_CURVE;
//    }
//    
//    return digiSignStatus_en;
//}
//
//crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_Verify(uint8_t *ptr_inputHash, uint32_t hashLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_pubKey, 
//                                                       uint32_t pubKeyLen, int8_t *ptr_verifyStatus, crypto_EccCurveType_E eccCurveType_en)
//{
//    crypto_DigiSign_Status_E digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
//    hsm_Ecc_CurveType_E curveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
//    hsm_Cmd_Status_E hsmStatus_en = HSM_CMD_ERROR_FAILED;
//    
//    curveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
//    if(curveType_en != HSM_ECC_MAXIMUM_CURVES_LIMIT)
//    {
//        hsmStatus_en =  Hsm_DigiSign_Ecdsa_Verify(ptr_inputHash, hashLen, ptr_Sig,
//                                                &ptr_pubKey[1], (pubKeyLen - 1U), ptr_verifyStatus, curveType_en);
//        if(hsmStatus_en == HSM_CMD_SUCCESS)
//        {
//            digiSignStatus_en = CRYPTO_DIGISIGN_SUCCESS;
//        }
//        else
//        {
//            digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
//        }
//    }
//    else
//    {
//        digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_CURVE;
//    }
//    
//    return digiSignStatus_en;
//}


crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_SignData(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_privKey, 
                                                                uint32_t privKeyLen, crypto_Hash_Algo_E hashType_en, crypto_EccCurveType_E eccCurveType_en)
{
    crypto_DigiSign_Status_E digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    hsm_Ecc_CurveType_E curveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
    hsm_Cmd_Status_E hsmStatus_en = HSM_CMD_ERROR_FAILED;
    uint8_t *randomNumber = NULL;

    hsm_Hash_Types_E hashAlgo_en = HSM_CMD_HASH_INVALID;
    uint32_t hashBlockSize = 0;
    
    hashAlgo_en = Crypto_Hash_Hw_GetShaAlgoType(hashType_en, &hashBlockSize);
    
    if(hashAlgo_en != HSM_CMD_HASH_INVALID)
    {
        curveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
        if(curveType_en != HSM_ECC_MAXIMUM_CURVES_LIMIT)
        {
            hsmStatus_en = Hsm_DigiSign_Ecdsa_SignData(ptr_inputData, dataLen, ptr_Sig, ptr_privKey, privKeyLen, hashAlgo_en, randomNumber, curveType_en); //?????????????? random number ???
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
    }
    else
    {
        digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_HASHTYPE;
    }
    
    return digiSignStatus_en;
}

crypto_DigiSign_Status_E Crypto_DigiSign_Hw_Ecdsa_VerifyData(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_Sig, uint32_t sigLen, uint8_t *ptr_pubKey, 
                                                    uint32_t pubKeyLen, crypto_Hash_Algo_E hashType_en, int8_t *ptr_verifyStatus, crypto_EccCurveType_E eccCurveType_en)
{
    crypto_DigiSign_Status_E digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_FAIL;
    hsm_Ecc_CurveType_E curveType_en = HSM_ECC_MAXIMUM_CURVES_LIMIT;
    hsm_Cmd_Status_E hsmStatus_en = HSM_CMD_ERROR_FAILED;
    
    hsm_Hash_Types_E hashAlgo_en = HSM_CMD_HASH_INVALID;
    uint32_t hashBlockSize = 0;
    
    hashAlgo_en = Crypto_Hash_Hw_GetShaAlgoType(hashType_en, &hashBlockSize);
    
    if(hashAlgo_en != HSM_CMD_HASH_INVALID)
    {
        curveType_en = Crypto_Hw_ECC_GetEccCurveType(eccCurveType_en);
        if(curveType_en != HSM_ECC_MAXIMUM_CURVES_LIMIT)
        {
            hsmStatus_en =  Hsm_DigiSign_Ecdsa_VerifyData(ptr_inputData, dataLen, ptr_Sig,
                                                    &ptr_pubKey[1], (pubKeyLen - 1U), hashAlgo_en, ptr_verifyStatus, curveType_en);
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
    }
    else
    {
        digiSignStatus_en = CRYPTO_DIGISIGN_ERROR_HASHTYPE;
    }
    
    return digiSignStatus_en;
}