/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hash_hsm03785_wrapper.c

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
#include "crypto/drivers/wrapper/crypto_hash_hsm03785_wrapper.h"
#include "crypto/drivers/driver/hsm_hash.h"
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
<#if (CRYPTO_HW_MD5?? &&(CRYPTO_HW_MD5 == true))>
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
    
    hsmApiStatus_en = HSM_Hash_FinalCmd((uint8_t*)ptr_md5Ctx, NULL, 0, 0, ptr_digest, HSM_CMD_HASH_MD5);

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
</#if>
<#if    (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true)) 
    ||  (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true)) 
    ||  (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true))
    ||  (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))
    ||  (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))>
	
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    hsm_Cmd_Status_E hsmApiStatus_en = HSM_CMD_ERROR_FAILED;
    hsm_Hash_Types_E shaAlgoType_en = HSM_CMD_HASH_INVALID;
    uint32_t hashBlockSize = 0;
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en, &hashBlockSize);
        
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
    uint32_t hashBlockSize = 0;
    uint8_t *ptr_byteShaCtx = (uint8_t*)ptr_shaCtx;
    uint8_t *ptr_restBytesLen = &ptr_byteShaCtx[CRYPTO_HW_RESTBYTES_LEN_INEX];
    uint32_t *ptr_wordTotalLen = (uint32_t*)ptr_shaCtx;
    uint32_t *ptr_totalDataLen = &ptr_wordTotalLen[CRYPTO_HW_TOTAL_LEN_INDEX];
    
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en, &hashBlockSize);
        
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {   
        *ptr_restBytesLen = 0x00U;
        *ptr_totalDataLen = 0x00000000UL;
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
    uint32_t hashBlockSize = 0;
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en, &hashBlockSize);
    uint32_t dataLenInBlock = 0; 
    
    uint8_t *ptr_byteShaCtx = (uint8_t*)ptr_shaCtx;
    uint8_t *ptr_restBytesLen = &ptr_byteShaCtx[CRYPTO_HW_RESTBYTES_LEN_INEX];
    uint8_t *ptr_restDataByte = &ptr_byteShaCtx[CRYPTO_HW_RESTBYTES_INDEX];
    uint32_t *ptr_wordTotalLen = (uint32_t*)ptr_shaCtx;
    uint32_t *ptr_totalDataLen = &ptr_wordTotalLen[CRYPTO_HW_TOTAL_LEN_INDEX];
    
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {
        if(*ptr_restBytesLen > 0U)
        {
            if((*ptr_restBytesLen + dataLen) >= hashBlockSize)
            {
                uint8_t reqBytes = (uint8_t)(hashBlockSize - (uint32_t)*ptr_restBytesLen);
                for(uint8_t i = 0U; i < reqBytes; i++)
                {
                    ptr_restDataByte[*ptr_restBytesLen + i] =  ptr_inputData[i]; 
                }
                hsmApiStatus_en = HSM_Hash_UpdateCmd((uint8_t*)ptr_shaCtx, ptr_restDataByte, hashBlockSize, shaAlgoType_en);
                *ptr_restBytesLen = 0U;
                for(uint8_t i = 0U; i < hashBlockSize; i++) //clear the already saved data
                {
                     ptr_restDataByte[i] = 0x00;
                }
                *ptr_totalDataLen = *ptr_totalDataLen + hashBlockSize;
                
                uint32_t totalBlocks = (dataLen - reqBytes)/hashBlockSize;
                if(totalBlocks > 0UL)
                {
                    hsmApiStatus_en = HSM_Hash_UpdateCmd((uint8_t*)ptr_shaCtx, &ptr_inputData[reqBytes], (hashBlockSize*totalBlocks), shaAlgoType_en);
                    *ptr_totalDataLen = *ptr_totalDataLen + (hashBlockSize*totalBlocks);
                    *ptr_restBytesLen = (uint8_t)((dataLen - (uint32_t)reqBytes)% hashBlockSize);
                }
                else
                {
                    *ptr_restBytesLen = (uint8_t)((dataLen - (uint32_t)reqBytes));
                }
                for(uint8_t k = 0U; k < *ptr_restBytesLen; k++)
                {
                    ptr_restDataByte[k] = ptr_inputData[reqBytes + k];
                }
            }
            else
            {
                for(uint8_t k = 0U; k < dataLen; k++)
                {
                    ptr_restDataByte[*ptr_restBytesLen + k] = ptr_inputData[k];
                }
                *ptr_restBytesLen = (uint8_t)(*ptr_restBytesLen + dataLen);
                hsmApiStatus_en = HSM_CMD_SUCCESS;
            }
        }
        else
        {
            if(dataLen >= hashBlockSize)
            {
                *ptr_restBytesLen = (uint8_t)(dataLen % hashBlockSize);
                if(*ptr_restBytesLen == 0U)        
                {
                    dataLenInBlock = dataLen;
                }
                else
                {
                    for(uint8_t k = 0U; k < *ptr_restBytesLen; k++)
                    {
                        ptr_restDataByte[k] = ptr_inputData[dataLen - *ptr_restBytesLen + k];
                    }
                    dataLenInBlock = (dataLen - *ptr_restBytesLen);
                }
                hsmApiStatus_en = HSM_Hash_UpdateCmd((uint8_t*)ptr_shaCtx, ptr_inputData, dataLenInBlock, shaAlgoType_en);
                *ptr_totalDataLen = *ptr_totalDataLen + dataLenInBlock;
            }
            else
            {
                *ptr_restBytesLen = (uint8_t)dataLen;
                for(uint8_t k = 0U; k < *ptr_restBytesLen; k++)
                {
                    ptr_restDataByte[k] = ptr_inputData[k];
                }
                hsmApiStatus_en = HSM_CMD_SUCCESS;
            }
        }
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
    uint32_t hashBlockSize = 0;
    uint8_t *ptr_byteShaCtx = (uint8_t*)ptr_shaCtx;
    uint8_t *ptr_restBytesLen = &ptr_byteShaCtx[CRYPTO_HW_RESTBYTES_LEN_INEX];
    uint8_t *ptr_restDataByte = &ptr_byteShaCtx[CRYPTO_HW_RESTBYTES_INDEX];
    uint32_t *ptr_wordTotalLen = (uint32_t*)ptr_shaCtx;
    uint32_t *ptr_totalDataLen = &ptr_wordTotalLen[CRYPTO_HW_TOTAL_LEN_INDEX];
    
    shaAlgoType_en = Crypto_Hash_Hw_GetShaAlgoType(shaAlgorithm_en, &hashBlockSize);
    
    if(shaAlgoType_en != HSM_CMD_HASH_INVALID)
    {        
        hsmApiStatus_en = HSM_Hash_FinalCmd((uint8_t*)ptr_shaCtx, ptr_restDataByte, *ptr_restBytesLen, *ptr_totalDataLen, ptr_digest, shaAlgoType_en);
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

hsm_Hash_Types_E Crypto_Hash_Hw_GetShaAlgoType(crypto_Hash_Algo_E hashAlgo_en, uint32_t *blockSize)
{
    hsm_Hash_Types_E algoType_en = HSM_CMD_HASH_INVALID;
    
    switch(hashAlgo_en)
    {
<#if (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true))>
        case CRYPTO_HASH_SHA1:
            algoType_en = HSM_CMD_HASH_SHA1;
            *blockSize = 64U;
            break;
</#if><#-- CRYPTO_HW_SHA1 -->
<#if (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true))>
        case CRYPTO_HASH_SHA2_224:
            algoType_en = HSM_CMD_HASH_SHA224;
            *blockSize = 64U;
            break;
</#if><#-- CRYPTO_HW_SHA2_224 -->
<#if (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true))>
        case CRYPTO_HASH_SHA2_256:
            algoType_en = HSM_CMD_HASH_SHA256;
            *blockSize = 64U;
            break;
</#if><#-- CRYPTO_HW_SHA2_256 -->
<#if (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))>
        case CRYPTO_HASH_SHA2_384:
            algoType_en = HSM_CMD_HASH_SHA384;
            *blockSize = 128U;
            break;
</#if><#-- CRYPTO_HW_SHA2_384 -->
<#if (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))>
        case CRYPTO_HASH_SHA2_512:
            algoType_en = HSM_CMD_HASH_SHA512;
            *blockSize = 128U;
            break;
</#if><#-- CRYPTO_HW_SHA2_512 -->
        default:
            algoType_en = HSM_CMD_HASH_INVALID;
            *blockSize = 0x00U;
            break;                  
    }
    return algoType_en;
}
</#if>
