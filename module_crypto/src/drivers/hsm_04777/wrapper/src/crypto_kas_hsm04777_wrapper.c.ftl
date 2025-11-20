/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_kas_hsm04777_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for the Shared Secret generation in the
    hardware cryptographic library.

  Description:
    This source file contains the wrapper interface to access the hardware
    cryptographic library in Microchip microcontrollers for Shared Secret generation.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) 2025, Microchip Technology Inc., and its subsidiaries. All rights reserved.

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
#include "../crypto_kas_hsm04777_wrapper.h"
#include "../../library/cam_ecdh.h"

/**
 * @brief Maps the ECC curve type to the corresponding hardware ECC curve.
 *
 * This function takes an ECC curve type as input and sets the corresponding
 * hardware ECC curve. It returns a status indicating whether the operation
 * was successful or if there was an error with the curve type.
 *
 * @param[in] eccCurveType The ECC curve type to be mapped.
 * @param[out] hwEccCurve Pointer to the variable where the hardware ECC curve
 *                        will be stored.
 * @return @ref CRYPTO_PKE_RESULT Status of the operation.
 * @retval CRYPTO_PKE_RESULT_SUCCESS The operation was successful.
 * @retval CRYPTO_PKE_RESULT_ERROR_CURVE The provided curve type is invalid.
 */

static CRYPTO_PKE_RESULT lCrypto_Kas_Ecdh_Hw_GetCurve(
    crypto_EccCurveType_E eccCurveType, PKE_ECC_CURVE *hwEccCurve)
{
    CRYPTO_PKE_RESULT eccStatus = CRYPTO_PKE_RESULT_SUCCESS;

    switch (eccCurveType)
    {
        case CRYPTO_ECC_CURVE_P192:
            *hwEccCurve = P192;
            break;

        case CRYPTO_ECC_CURVE_P256:
            *hwEccCurve = P256;
            break;

        case CRYPTO_ECC_CURVE_P384:
            *hwEccCurve = P384;
            break;

        case CRYPTO_ECC_CURVE_P521:
            *hwEccCurve = P521;
            break;

        default:
            eccStatus = CRYPTO_PKE_RESULT_ERROR_CURVE;
            break;
    }

    return eccStatus;
}   

/**
 * @brief Maps the hardware PKE result to the KAS status.
 *
 * This function translates the result from the hardware PKE operation
 * into a corresponding KAS status. It helps in understanding the outcome
 * of the shared secret generation process.
 *
 * @param[in] result The result from the hardware PKE operation.
 * @return @ref crypto_Kas_Status_E The mapped KAS status.
 * @retval CRYPTO_KAS_SUCCESS The operation was successful.
 * @retval CRYPTO_KAS_ERROR_PUBKEY The public key is invalid.
 * @retval CRYPTO_KAS_ERROR_CURVE The curve type is invalid.
 * @retval CRYPTO_KAS_ERROR_FAIL The operation failed.
 */

static crypto_Kas_Status_E lCrypto_Kas_Ecdh_Hw_MapResult(CRYPTO_PKE_RESULT result)
{
    crypto_Kas_Status_E kasStatus;

    switch (result)
    {
        case CRYPTO_PKE_RESULT_SUCCESS:
            kasStatus = CRYPTO_KAS_SUCCESS;
            break;

        case CRYPTO_PKE_ERROR_PUBKEYCOMPRESS:
            kasStatus = CRYPTO_KAS_ERROR_PUBKEY;
            break;

        case CRYPTO_PKE_RESULT_ERROR_CURVE:
            kasStatus = CRYPTO_KAS_ERROR_CURVE;
            break;

        case CRYPTO_PKE_RESULT_INIT_FAIL:
        case CRYPTO_PKE_RESULT_ERROR_FAIL:
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
// Section: KAS Common Interface Implementation
// *****************************************************************************
// *****************************************************************************


crypto_Kas_Status_E Crypto_Kas_Ecdh_Hw_SharedSecret(uint8_t *privKey, 
    uint32_t privKeyLen, uint8_t *pubKey, uint32_t pubKeyLen, 
    uint8_t *secret, uint32_t secretLen, crypto_EccCurveType_E eccCurveType_en)
{
    CRYPTO_PKE_RESULT hwResult;
    PKE_CONFIG eccData;
    PKE_ECC_CURVE hwEccCurve;

    if (pubKey[0] == 0x04U)
    {
        /* Get curve */
        hwResult = lCrypto_Kas_Ecdh_Hw_GetCurve(eccCurveType_en, &hwEccCurve);

        if (hwResult == CRYPTO_PKE_RESULT_SUCCESS)
        {
            uint8_t *adjustedPubKey = &pubKey[1];
            uint32_t adjustedPubKeyLen = pubKeyLen - 1U;

            hwResult = DRV_CRYPTO_ECDH_InitEccParams(&eccData, 
                                                    privKey, 
                                                    privKeyLen,
                                                    adjustedPubKey, 
                                                    adjustedPubKeyLen, 
                                                    hwEccCurve);
        }

        if (hwResult == CRYPTO_PKE_RESULT_SUCCESS)
        {
            /* Get shared key */
            hwResult = DRV_CRYPTO_ECDH_GetSharedSecret(&eccData, secret, secretLen);
        }
    }
    else {
        hwResult = CRYPTO_KAS_ERROR_PUBKEY;
    }

    return lCrypto_Kas_Ecdh_Hw_MapResult(hwResult);     
}
