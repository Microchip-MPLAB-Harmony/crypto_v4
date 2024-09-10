/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Hash_HwWrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware MD5 and SHA.

  Description:
    This source file contains the wrapper interface to access the SHA 
    hardware driver for Microchip microcontrollers.
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
#include "crypto/common_crypto/MCHP_Crypto_Hash_HwWrapper.h"
#include "crypto/drivers/hsm_hash.h"
#include "crypto/common_crypto/MCHP_Crypto_Common_HwWrapper.h"
// *****************************************************************************
// *****************************************************************************
// Section: Macro definitions
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: File scope data
// *****************************************************************************
// *****************************************************************************
       
// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    
    hsmApiStatus_en = HSM_Hash_DigestDirect(HSM_CMD_HASH_MD5, ptr_inputData, dataLen, ptr_digest);
    
    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_md5Stat_en;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Init(void *ptr_md5Ctx)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    
    hsmApiStatus_en =  HSM_Hash_InitCmd( (uint8_t*)ptr_md5Ctx, HSM_CMD_HASH_MD5);
    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_md5Stat_en; 
}

crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Update(void *ptr_md5Ctx, uint8_t *ptr_inputData, uint32_t dataLen)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    
    hsmApiStatus_en = HSM_Hash_UpdateCmd((uint8_t*)ptr_md5Ctx, ptr_inputData, dataLen, HSM_CMD_HASH_MD5);

    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_md5Stat_en; 
}

crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Final(void *ptr_md5Ctx, uint8_t *ptr_digest)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    
    hsmApiStatus_en = HSM_Hash_FinalCmd((uint8_t*)ptr_md5Ctx, NULL, 0, ptr_digest, HSM_CMD_HASH_MD5);

    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_md5Stat_en; 
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Hash_Types_E shaAlgoType_en = HSM_CMD_HASH_INVALID;
    
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en);
        
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {
        hsmApiStatus_en = HSM_Hash_DigestDirect(shaAlgoType_en, ptr_inputData, dataLen, ptr_digest);
    }
    
    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_shaStat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_shaStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *ptr_shaCtx, crypto_Hash_Algo_E shaAlgorithm_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Hash_Types_E shaAlgoType_en = HSM_CMD_HASH_INVALID;
    
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en);
        
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {        
        hsmApiStatus_en =  HSM_Hash_InitCmd( (uint8_t*)ptr_shaCtx, shaAlgoType_en);
    }
    
    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_shaStat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_shaStat_en; 
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *ptr_shaCtx, uint8_t *ptr_inputData, uint32_t dataLen, crypto_Hash_Algo_E shaAlgorithm_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Hash_Types_E shaAlgoType_en = HSM_CMD_HASH_INVALID;
    
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en);
        
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {
        hsmApiStatus_en = HSM_Hash_UpdateCmd((uint8_t*)ptr_shaCtx, ptr_inputData, dataLen, shaAlgoType_en);
    }
    
    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_shaStat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_shaStat_en; 
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *ptr_shaCtx, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Hash_Types_E shaAlgoType_en = HSM_CMD_HASH_INVALID;
    
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en);
    
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {
        hsmApiStatus_en = HSM_Hash_FinalCmd((uint8_t*)ptr_shaCtx, NULL, 0, ptr_digest, shaAlgoType_en);
    }

    if(hsmApiStatus_en == HSM_CMD_SUCCESS)
    {
        ret_shaStat_en = CRYPTO_HASH_SUCCESS;
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    return ret_shaStat_en; 
}

hsm_Hash_Types_E Crypto_Hash_Hw_GetShaAlgoType(crypto_Hash_Algo_E hashAlgo_en)
{
    hsm_Hash_Types_E algoType_en = HSM_CMD_HASH_INVALID;
    
    switch(hashAlgo_en)
    {
        case CRYPTO_HASH_SHA1:
            algoType_en = HSM_CMD_HASH_SHA1;
        break;
        
        case CRYPTO_HASH_SHA2_224:
            algoType_en = HSM_CMD_HASH_SHA224;
        break;
        
        case CRYPTO_HASH_SHA2_256:
            algoType_en = HSM_CMD_HASH_SHA256;
        break;
        
        case CRYPTO_HASH_SHA2_384:
            algoType_en = HSM_CMD_HASH_SHA384;
        break;
        
        case CRYPTO_HASH_SHA2_512:
            algoType_en = HSM_CMD_HASH_SHA512;
        break;
        
        default:
            algoType_en = HSM_CMD_HASH_INVALID;
        break;                  
    }
    return algoType_en;
}

