/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hash_sha05346_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware SHA.

  Description:
    This source file contains the wrapper interface to access the SHA 
    hardware driver for Microchip microcontrollers.
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
#include <string.h>
#include "crypto/drivers/wrapper/crypto_hash_sha05346_wrapper.h"
#include "crypto/drivers/driver/drv_crypto_sha_hw_05346.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

static crypto_Hash_Status_E lCrypto_Hash_Hw_Sha_GetAlgorithm
    (crypto_Hash_Algo_E shaAlgorithm, CRYPTO_SHA_ALGO *shaAlgo)
{
    crypto_Hash_Status_E ret_status = CRYPTO_HASH_ERROR_FAIL;
    switch(shaAlgorithm)
    {  
<#if (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true))>
        case CRYPTO_HASH_SHA1:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA1;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
</#if><#-- CRYPTO_HW_SHA1 -->         
<#if (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true))>
        case CRYPTO_HASH_SHA2_224:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA224;
            ret_status = CRYPTO_HASH_SUCCESS;
            break; 
</#if><#-- CRYPTO_HW_SHA2_224 -->            
<#if (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true))>
        case CRYPTO_HASH_SHA2_256:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA256;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
</#if><#-- CRYPTO_HW_SHA2_256 -->     
<#if (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))>
        case CRYPTO_HASH_SHA2_384:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA384;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
</#if><#-- CRYPTO_HW_SHA2_384 -->           
<#if (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))>  
        case CRYPTO_HASH_SHA2_512:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA512;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
</#if><#-- CRYPTO_HW_SHA2_512 -->
<#if (CRYPTO_HW_SHA2_512_224?? &&(CRYPTO_HW_SHA2_512_224 == true))>  
        case CRYPTO_HASH_SHA2_512_224:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA512_224;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;        
</#if><#-- CRYPTO_HW_SHA2_512_224 -->        
<#if (CRYPTO_HW_SHA2_512_256?? &&(CRYPTO_HW_SHA2_512_256 == true))> 
        case CRYPTO_HASH_SHA2_512_256:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA512_256;
            ret_status = CRYPTO_HASH_SUCCESS;
            break; 
</#if><#-- CRYPTO_HW_SHA2_512_256 -->
        default:
            ret_status = CRYPTO_HASH_ERROR_ALGO;
            break;
    }    
   return ret_status;
}
 
// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
    
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *shaInitCtx, 
    crypto_Hash_Algo_E shaAlgorithm_en)
{
    CRYPTO_SHA_ALGO shaAlgo;
    crypto_Hash_Status_E result;
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*)shaInitCtx;
            
    /* Set algorithm for driver */
    result = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm_en, &shaAlgo);
    if (result != CRYPTO_HASH_SUCCESS)
    {
        return result;
    }
    
    /* Initialize context */
    shaCtx->algo = shaAlgorithm_en;
    
    /* Configure the driver */
    DRV_CRYPTO_SHA_Init(shaAlgo);
    
    return CRYPTO_HASH_SUCCESS;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *shaUpdateCtx,
    uint8_t *data, uint32_t dataLen)
{
    uint8_t *inputData = data;
    uint32_t inputDataLen = dataLen;
    uint32_t numOfInvalidBytes = 0;
    
    #ifdef ENABLE_SW_PADDING

    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*) shaUpdateCtx;    
    
    switch(shaCtx->algo)
    {
        case CRYPTO_HASH_SHA2_256:
            inputDataLen = 64;
            break;
        case CRYPTO_HASH_SHA2_384:
            inputDataLen = 128;
            break;
        default:
            return CRYPTO_HASH_ERROR_ALGO;
    }
    
    uint8_t inputDataPadded[inputDataLen];
        
    memcpy(inputDataPadded, inputData, dataLen);
    
    for(int index = dataLen; index < inputDataLen - 1; index++)
    {
        inputDataPadded[index] = (uint8_t) 0x00;
    }

    inputDataPadded[dataLen] = 0x80;
    
    inputDataPadded[inputDataLen - 5] = dataLen >> 29;
    inputDataPadded[inputDataLen - 4] = dataLen >> 21;
    inputDataPadded[inputDataLen - 3] = dataLen >> 13;
    inputDataPadded[inputDataLen - 2] = dataLen >> 5;
    inputDataPadded[inputDataLen - 1] = dataLen << 3;

    inputData = &inputDataPadded[0];
    
    #else

    if(inputDataLen == 0)
    {
        inputDataLen = 4;
        numOfInvalidBytes = 4;
    }
    else
    {
        uint32_t bytesOverHashBlock = inputDataLen % (uint32_t) HASH_BLOCK_SIZE;

        if (bytesOverHashBlock != (uint32_t) 0)
        {
            numOfInvalidBytes = (uint32_t) HASH_BLOCK_SIZE - bytesOverHashBlock;
        }
    }
    
    #endif

    /* Write the data to be ciphered to the input data registers */
    DRV_CRYPTO_SHA_Update(inputData, inputDataLen, numOfInvalidBytes);
    
    return CRYPTO_HASH_SUCCESS;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *shaFinalCtx, 
    uint8_t *digest)
{
    DRV_CRYPTO_SHA_GetOutputData((CRYPTO_HASH_HW_CONTEXT*) shaFinalCtx, digest);

    return CRYPTO_HASH_SUCCESS;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *data, uint32_t dataLen, 
    uint8_t *digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
    CRYPTO_HASH_HW_CONTEXT shaCtx;
    crypto_Hash_Status_E result = CRYPTO_HASH_SUCCESS;

    result = Crypto_Hash_Hw_Sha_Init(&shaCtx, shaAlgorithm_en);
    if (result != CRYPTO_HASH_SUCCESS)
    {
        return result;
    }
    
    result = Crypto_Hash_Hw_Sha_Update(&shaCtx, data, dataLen);
    if (result != CRYPTO_HASH_SUCCESS)
    {
        return result;
    }    
    return Crypto_Hash_Hw_Sha_Final(&shaCtx, digest);
}
