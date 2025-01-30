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
    ECDSA driver functionality for the following families 
    of Microchip microcontrollers:
    dsPIC33AK with Crypto Accelerator Module.
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "../drv_crypto_ecdsa_hw_05346.h"
#include <xc.h>

// *****************************************************************************
// *****************************************************************************
// Section: Global Functions
// *****************************************************************************
// *****************************************************************************

void __attribute__((interrupt)) _CRYPTO3Interrupt(void)
{
    DRV_CRYPTO_ECDSA_IsrHelper();
    _CRYPT3IF = 0;
}

// *****************************************************************************
// *****************************************************************************
// Section: File Scope Function implementations
// *****************************************************************************
// *****************************************************************************

static void lDRV_CRYPTO_ECDSA_InterruptSetup(void)
{
    _CRYPT3IF = 0;
    _CRYPT3IE = 1;
}

static ECDSA_ERROR lDRV_CRYPTO_ECDSA_SetVariableLocations(ECDSA_CONFIG* ecc_data)
{
    ECDSA_ERROR error_code = ECDSA_NO_ERROR;

    switch (ecc_data->operation)
    {
    case ECDSA_SIGNATURE_GENERATION:
        error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_D, ecc_data->op1.data, ecc_data->op1.size);
        
        if (error_code == ECDSA_NO_ERROR)
        {
            error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_K, ecc_data->op2.data, ecc_data->op2.size);
        }
        
        if (error_code == ECDSA_NO_ERROR)
        {
            error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_H, ecc_data->op3.data, ecc_data->op3.size);
        }
        break;
    case ECDSA_SIGNATURE_VERIFICATION:
        error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_R, ecc_data->op1.data, ecc_data->op1.size);
        
        if (error_code == ECDSA_NO_ERROR)
        {
            error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_S, ecc_data->op2.data, ecc_data->op2.size);
        }
        
        if (error_code == ECDSA_NO_ERROR)
        {
            error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_H, ecc_data->op3.data, ecc_data->op3.size);
        }
        
        if (error_code == ECDSA_NO_ERROR)
        {
            error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_QX, ecc_data->p1.x, ecc_data->p1.size);
        }
        
        if (error_code == ECDSA_NO_ERROR)
        {
            error_code = DRV_CRYPTO_ECDSA_WriteLocation(ECDSA_QX + 1, ecc_data->p1.y, ecc_data->p1.size);
        }
        break;
    default:
        error_code = ECDSA_INVALID_OPERATION;
        break;
    }
    return error_code;
}

static ECDSA_ERROR lDRV_CRYPTO_ECDSA_ClearMemory(void)
{
    ECDSA_CONFIG eccData = {
        .operation = ECDSA_CLEAR_MEMORY,
        .field = 0,
        .op_size = 0,
        .curve = 0,
        .edwards = 0,
        .flag_a = 0,
        .flag_b = 0
    };

    DRV_CRYPTO_ECDSA_SetCommand(&eccData);

    DRV_CRYPTO_ECDSA_StartEngine();

    return DRV_CRYPTO_ECDSA_CheckErrors();
}

//TODO: placeholder until TRNG implementation is available
static void lDRV_CRYPTO_ECDSA_GetRandomNumber(uint8_t* data, uint32_t size)
{
    for (uint32_t i = 0; i < size; i++)
    {
        data[i] = i;
    }
}

static CRYPTO_ECDSA_RESULT lDRV_CRYPTO_ECDSA_GetCurveSize(ECDSA_CMD_CURVE hwEccCurve, ECDSA_ECC_SIZE *size)
{
    CRYPTO_ECDSA_RESULT result = CRYPTO_ECDSA_RESULT_SUCCESS;
    switch (hwEccCurve)
    {
    case P256:
        *size = P256_sz;
        break;
    case P384:
        *size = P384_sz;
        break;
    case P521:
        *size = P521_sz;
        break;
    case P192:
        *size = P192_sz;
        break;
    default:
        result = CRYPTO_ECDSA_RESULT_ERROR_CURVE;
        break;
    }
    return result;
}

static ECDSA_ERROR lDRV_CRYPTO_ECDSA_ExecuteCommand(ECDSA_CONFIG* ecc_data)
{
    ECDSA_ERROR error_code;

    error_code = lDRV_CRYPTO_ECDSA_ClearMemory();
    if (error_code == ECDSA_NO_ERROR)
    {
        error_code = lDRV_CRYPTO_ECDSA_SetVariableLocations(ecc_data);
    }
    
    if (error_code == ECDSA_NO_ERROR)
    {
        DRV_CRYPTO_ECDSA_SetCommand(ecc_data);

        DRV_CRYPTO_ECDSA_StartEngine();
    }

    if (0x99U != ecc_data->result_location)
    {
        error_code = DRV_CRYPTO_ECDSA_ReadLocation(ecc_data->result_location, ecc_data->r1.data, ecc_data->r1.size);
        ecc_data->result_location = 0x99;
    }
    
    if (error_code == ECDSA_NO_ERROR)
    {
        error_code = DRV_CRYPTO_ECDSA_CheckErrors();
    }
    
    return error_code;
}

// *****************************************************************************
// *****************************************************************************
// Section: ECDSA Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_InitEccParamsSign(ECDSA_CONFIG *eccData, uint8_t *hash, uint32_t hashLen, uint8_t * privKey, uint32_t privKeyLen, ECDSA_CMD_CURVE hwEccCurve)
{
    ECDSA_ECC_SIZE size;
    CRYPTO_ECDSA_RESULT result = lDRV_CRYPTO_ECDSA_GetCurveSize(hwEccCurve, &size);
    uint8_t random_TRNG[P521_sz] = {0};

    if (result == CRYPTO_ECDSA_RESULT_SUCCESS)
    {
        eccData->curve = hwEccCurve;
        eccData->operation = ECDSA_SIGNATURE_GENERATION;
        eccData->op1.data = privKey;
        eccData->op1.size = privKeyLen;

        lDRV_CRYPTO_ECDSA_GetRandomNumber(random_TRNG, sizeof (random_TRNG));
        eccData->op2.data = random_TRNG;
        eccData->op2.size = (uint32_t) size - 2U;
        eccData->op3.data = hash;
        eccData->op3.size = hashLen;
        eccData->op_size = (uint32_t) size - 1U;

        DRV_CRYPTO_ECDSA_SetupEngine();
        lDRV_CRYPTO_ECDSA_InterruptSetup();
    }

    return result;
}


CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_Sign(ECDSA_CONFIG *eccData, uint8_t * pfulSignature, uint32_t signatureLen)
{
    CRYPTO_ECDSA_RESULT result = CRYPTO_ECDSA_RESULT_SUCCESS;
    ECDSA_ERROR error_code;

    error_code = lDRV_CRYPTO_ECDSA_ExecuteCommand(eccData);
    
    if (error_code == ECDSA_NO_ERROR)
    {
        error_code = DRV_CRYPTO_ECDSA_ReadLocation(ECDSA_R, pfulSignature, signatureLen / 2u);
    }
    
    if (error_code == ECDSA_NO_ERROR)
    {
        error_code = DRV_CRYPTO_ECDSA_ReadLocation(ECDSA_S, pfulSignature + (signatureLen / 2u), signatureLen / 2u);
    }
    
    if(error_code != ECDSA_NO_ERROR){
        result = CRYPTO_ECDSA_RESULT_ERROR_FAIL;
    }
    
    return result;
}

CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_InitEccParamsVerify(ECDSA_CONFIG *eccData, uint8_t *inputHash, uint32_t hashLen, uint8_t *inputSig, uint32_t sigLen, uint8_t *pubKey, uint32_t pubKeyLen, ECDSA_CMD_CURVE hwEccCurve)
{
    ECDSA_ECC_SIZE size;
    CRYPTO_ECDSA_RESULT result = lDRV_CRYPTO_ECDSA_GetCurveSize(hwEccCurve, &size);
    
    /* Compressed keys not supported */
    if (pubKey[0] != 0x04U) 
    {
        return CRYPTO_ECDSA_ERROR_PUBKEYCOMPRESS;
    }
    
    if (result == CRYPTO_ECDSA_RESULT_SUCCESS)
    {
        eccData->curve = hwEccCurve;
        eccData->operation = ECDSA_SIGNATURE_VERIFICATION;
        eccData->op1.data = inputSig;
        eccData->op1.size = sigLen / 2U;
        eccData->op2.data = inputSig + (sizeof (uint8_t) * sigLen / 2U);
        eccData->op2.size = sigLen / 2U;
        eccData->op3.data = inputHash;
        eccData->op3.size = hashLen;

        eccData->p1.x = pubKey + 1U;
        eccData->p1.y = pubKey + 1U + (sizeof (uint8_t) * (pubKeyLen - 1U) / 2U);
        eccData->p1.size = (pubKeyLen - 1U) / 2U;
        eccData->op_size = ((uint8_t) size - 1U);

        DRV_CRYPTO_ECDSA_SetupEngine();
        lDRV_CRYPTO_ECDSA_InterruptSetup();
    }

    return result;
}


CRYPTO_ECDSA_RESULT DRV_CRYPTO_ECDSA_Verify(ECDSA_CONFIG *eccData)
{
    CRYPTO_ECDSA_RESULT result = CRYPTO_ECDSA_RESULT_SUCCESS;
    ECDSA_ERROR error_code;

    error_code = lDRV_CRYPTO_ECDSA_ExecuteCommand(eccData);

    if (error_code != ECDSA_NO_ERROR)
    {
        result = CRYPTO_ECDSA_RESULT_ERROR_FAIL;
    }

    return result;
}
