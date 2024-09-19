/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_ecdsa_hw_05346.c

  Summary:
    ECDSA Hardware functions.

  Description:
    This source file contains the implementation for the 
    ECDSA driver functionality.
**************************************************************************/

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

#include "../drv_crypto_ecdsa_hw_05346.h"

CRYPTO_ECDSA_RESULT GetSize(CAM_CMD_CURVE hwEccCurve, CAM_ECC_SIZE *size);
CAM_ERROR CAM_Execute(CAM_ECC_STRUCT* ecc_data);
CAM_ERROR CAM_Set_Locations(CAM_ECC_STRUCT* ecc_data);
CAM_ERROR CAM_Clear_Memory(void);
void getTRNGNumber(uint8_t* data, uint32_t size);

CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_InitEccParamsSign(CAM_ECC_STRUCT *eccData, uint8_t *hash, uint32_t hashLen, uint8_t * privKey, uint32_t privKeyLen, CAM_CMD_CURVE hwEccCurve)
{
    CAM_ECC_SIZE size;
    CRYPTO_ECDSA_RESULT result = GetSize(hwEccCurve, &size);
    uint8_t random_TRNG[MAX_TRNG_SIZE] = {0};

    if (result != CRYPTO_ECDSA_RESULT_SUCCESS)
    {
        return result;
    }

    eccData->curve = hwEccCurve;
    eccData->operation = eECDSA_S_GEN;
    eccData->op1.data = privKey;
    eccData->op1.size = privKeyLen;

    getTRNGNumber(random_TRNG, sizeof (random_TRNG));
    eccData->op2.data = random_TRNG;
    eccData->op2.size = (uint32_t) size - 2U;
    eccData->op3.data = hash;
    eccData->op3.size = hashLen;
    eccData->op_size = (uint32_t) size - 1U;

    CAM_HAL_Setup_Engine();
    CAM_HAL_Setup_Interrupts();

    return result;
}

//TODO: placeholder random number

void getTRNGNumber(uint8_t* data, uint32_t size)
{
    for (uint32_t i = 0; i < size; i++)
    {
        data[i] = i;
    }
}

CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_Sign(CAM_ECC_STRUCT *eccData, uint8_t * pfulSignature, uint32_t signatureLen)
{
    CRYPTO_ECDSA_RESULT result = CRYPTO_ECDSA_RESULT_SUCCESS;
    CAM_ERROR errorCode;

    errorCode = CAM_Execute(eccData);
    if (errorCode != CAM_NO_ERROR)
    {
        return CRYPTO_ECDSA_RESULT_ERROR_FAIL;
    }

    errorCode = CAM_HAL_Read_Location(ECDSA_R, pfulSignature, signatureLen / 2u);
    if (errorCode != CAM_NO_ERROR)
    {
        return CRYPTO_ECDSA_RESULT_ERROR_FAIL;
    }

    errorCode = CAM_HAL_Read_Location(ECDSA_S, pfulSignature + signatureLen / 2u, signatureLen / 2u);
    if (errorCode != CAM_NO_ERROR)
    {
        return CRYPTO_ECDSA_RESULT_ERROR_FAIL;
    }

    return result;
}

CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_InitEccParamsVerify(CAM_ECC_STRUCT *eccData, uint8_t *inputHash, uint32_t hashLen, uint8_t *inputSig, uint32_t sigLen, uint8_t *pubKey, uint32_t pubKeyLen, CAM_CMD_CURVE hwEccCurve)
{
    CAM_ECC_SIZE size;
    CRYPTO_ECDSA_RESULT result = GetSize(hwEccCurve, &size);

    if (result != CRYPTO_ECDSA_RESULT_SUCCESS)
    {
        return result;
    }

    eccData->curve = hwEccCurve;
    eccData->operation = eECDSA_S_VER;
    eccData->op1.data = inputSig;
    eccData->op1.size = sigLen / 2U;
    eccData->op2.data = inputSig + (sizeof (uint8_t) * sigLen / 2U);
    eccData->op2.size = sigLen / 2U;
    eccData->op3.data = inputHash;
    eccData->op3.size = hashLen;

    eccData->p1.x = pubKey;
    eccData->p1.y = pubKey + (sizeof (uint8_t) * pubKeyLen / 2U);
    eccData->p1.size = pubKeyLen;
    eccData->op_size = ((uint8_t) size - 1U);

    CAM_HAL_Setup_Engine();
    CAM_HAL_Setup_Interrupts();

    return result;
}

CRYPTO_ECDSA_RESULT GetSize(CAM_CMD_CURVE hwEccCurve, CAM_ECC_SIZE *size)
{
    CRYPTO_ECDSA_RESULT result = CRYPTO_ECDSA_RESULT_SUCCESS;
    switch (hwEccCurve)
    {
    case eP256:
        *size = eP256_sz;
        break;
    case eP384:
        *size = eP384_sz;
        break;
    case eP521:
        *size = eP521_sz;
        break;
    case eP192:
        *size = eP192_sz;
        break;
    default:
        result = CRYPTO_ECDSA_RESULT_ERROR_CURVE;
        break;
    }
    return result;
}

CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_Verify(CAM_ECC_STRUCT *eccData)
{
    CRYPTO_ECDSA_RESULT result = CRYPTO_ECDSA_RESULT_SUCCESS;
    CAM_ERROR errorCode;

    errorCode = CAM_Execute(eccData);

    if (errorCode != CAM_NO_ERROR)
    {
        result = CRYPTO_ECDSA_RESULT_ERROR_FAIL;
    }

    return result;
}

CAM_ERROR CAM_Execute(CAM_ECC_STRUCT* ecc_data)
{
    CAM_ERROR error_code;

    error_code = CAM_Clear_Memory();
    if (CAM_NO_ERROR != error_code)
    {
        return error_code;
    }

    error_code = CAM_Set_Locations(ecc_data);
    if (CAM_NO_ERROR != error_code)
    {
        return error_code;
    }

    CAM_HAL_Set_Cmd(ecc_data);

    CAM_HAL_Start();

    if (0x99U != ecc_data->result_location)
    {
        error_code = CAM_HAL_Read_Location(ecc_data->result_location, ecc_data->r1.data, ecc_data->r1.size);
        ecc_data->result_location = 0x99;
        if (CAM_NO_ERROR != error_code)
        {
            return error_code;
        }
    }

    return CAM_HAL_Check_Errors();
}

CAM_ERROR CAM_Set_Locations(CAM_ECC_STRUCT* ecc_data)
{
    CAM_ERROR error_code = CAM_NO_ERROR;

    switch (ecc_data->operation)
    {
    case eECDSA_S_GEN:
        error_code = CAM_HAL_Write_Location(ECDSA_D, ecc_data->op1.data, ecc_data->op1.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        error_code = CAM_HAL_Write_Location(ECDSA_K, ecc_data->op2.data, ecc_data->op2.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        error_code = CAM_HAL_Write_Location(ECDSA_H, ecc_data->op3.data, ecc_data->op3.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        break;
    case eECDSA_S_VER:
        error_code = CAM_HAL_Write_Location(ECDSA_R, ecc_data->op1.data, ecc_data->op1.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        error_code = CAM_HAL_Write_Location(ECDSA_S, ecc_data->op2.data, ecc_data->op2.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        error_code = CAM_HAL_Write_Location(ECDSA_H, ecc_data->op3.data, ecc_data->op3.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        error_code = CAM_HAL_Write_Location(ECDSA_QX, ecc_data->p1.x, ecc_data->p1.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        error_code = CAM_HAL_Write_Location(ECDSA_QX + 1, ecc_data->p1.y, ecc_data->p1.size);
        if (CAM_NO_ERROR != error_code)
        {
            break;
        }
        break;
        /************* Other PKE functions ****************/
    default:
        return CAM_INVALID_OPERATION;
    }
    return error_code;
}

CAM_ERROR CAM_Clear_Memory(void)
{
    CAM_ECC_STRUCT eccData = {
        .operation = eCLR_MEM,
        .field = 0,
        .op_size = 0,
        .curve = 0,
        .edwards = 0,
        .flag_a = 0,
        .flag_b = 0
    };

    CAM_HAL_Set_Cmd(&eccData);

    CAM_HAL_Start();

    return CAM_HAL_Check_Errors();
}



