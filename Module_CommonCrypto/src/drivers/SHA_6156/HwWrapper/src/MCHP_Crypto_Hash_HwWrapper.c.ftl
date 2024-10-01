/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Hash_HwWrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware SHA.

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

#include <stdint.h>
#include <string.h>
#include "device.h"
#include "crypto/common_crypto/MCHP_Crypto_Hash_HwWrapper.h"
<#if driver_defines?contains("HAVE_CRYPTO_HW_SHA_6156_DRIVER")>
#include "crypto/drivers/drv_crypto_sha_hw_6156.h"
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: Macro definitions
// *****************************************************************************
// *****************************************************************************

#define HASH_SHORT_PAD_SIZE_BYTES     (56U)
#define HASH_LONG_PAD_SIZE_BYTES      (112U)

// *****************************************************************************
// *****************************************************************************
// Section: File scope data
// *****************************************************************************
// *****************************************************************************
       
static uint8_t hashPaddingMsg[CRYPTO_SHA_BLOCK_SIZE_WORDS_32 << 2] = {
    0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

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
#ifdef CRYPTO_HASH_SHA1_EN
        case CRYPTO_HASH_SHA1:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA1;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
#endif
         
#ifdef CRYPTO_HASH_SHA2_224_EN
        case CRYPTO_HASH_SHA2_224:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA224;
            ret_status = CRYPTO_HASH_SUCCESS;
            break; 
#endif
            
#ifdef CRYPTO_HASH_SHA2_256_EN
        case CRYPTO_HASH_SHA2_256:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA256;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
#endif
       
#ifdef CRYPTO_HASH_SHA2_384_EN 
        case CRYPTO_HASH_SHA2_384:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA384;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
#endif
           
#ifdef CRYPTO_HASH_SHA2_512_EN  
        case CRYPTO_HASH_SHA2_512:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA512;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;
#endif

#ifdef CRYPTO_HASH_SHA2_512_224_EN 
        case CRYPTO_HASH_SHA2_512_224:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA512_224;
            ret_status = CRYPTO_HASH_SUCCESS;
            break;        
#endif
        
#ifdef CRYPTO_HASH_SHA2_512_256_EN
        case CRYPTO_HASH_SHA2_512_256:
            *shaAlgo = CRYPTO_SHA_ALGO_SHA512_256;
            ret_status = CRYPTO_HASH_SUCCESS;
            break; 
#endif

        default:
            ret_status = CRYPTO_HASH_ERROR_ALGO;
            break;
    }
    
   return ret_status;
}

static uint32_t lCrypto_Hash_Hw_Sha_GetBlockSizeBytes(crypto_Hash_Algo_E shaAlgorithm)
{
    CRYPTO_SHA_BLOCK_SIZE blockSize = CRYPTO_SHA_BLOCK_SIZE_WORDS_32;
    uint32_t blockLen = ((uint32_t)blockSize) << 2UL; // 128 bytes
    crypto_Hash_Status_E retVal = CRYPTO_HASH_ERROR_FAIL;
    
    CRYPTO_SHA_ALGO shaAlgo = CRYPTO_SHA_ALGO_SHA256;
    retVal = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm, &shaAlgo);
    
    if(retVal == CRYPTO_HASH_SUCCESS)
    {
        if ((shaAlgo == CRYPTO_SHA_ALGO_SHA1) || 
            (shaAlgo == CRYPTO_SHA_ALGO_SHA224) ||
            (shaAlgo == CRYPTO_SHA_ALGO_SHA256))
        {
            blockSize =  CRYPTO_SHA_BLOCK_SIZE_WORDS_16;
            blockLen = ((uint32_t)blockSize) << 2UL; // 64 bytes   
        }
    }
    else
    {
        //do nothing
    }
    
    return blockLen;
}
 
static uint8_t lCrypto_Hash_Hw_Sha_GetPaddingSizeBytes(crypto_Hash_Algo_E shaAlgorithm)
{
    uint8_t paddingLen = HASH_LONG_PAD_SIZE_BYTES;
    crypto_Hash_Status_E retVal = CRYPTO_HASH_ERROR_FAIL;
    
    CRYPTO_SHA_ALGO shaAlgo = CRYPTO_SHA_ALGO_SHA256;
    
    retVal = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm, &shaAlgo);
    if(retVal == CRYPTO_HASH_SUCCESS)
    {
        if ((shaAlgo == CRYPTO_SHA_ALGO_SHA1) || 
            (shaAlgo == CRYPTO_SHA_ALGO_SHA224) ||
            (shaAlgo == CRYPTO_SHA_ALGO_SHA256))
        {
            paddingLen = HASH_SHORT_PAD_SIZE_BYTES;    
        }
    }
    else
    {
        //do nothing
    }
    
    return paddingLen;
}

static CRYPTO_SHA_DIGEST_SIZE lCrypto_Hash_Hw_Sha_GetDigestLen
    (crypto_Hash_Algo_E shaAlgorithm)
{
    CRYPTO_SHA_DIGEST_SIZE digestSize = CRYPTO_SHA_DIGEST_SIZE_INVALID;
    crypto_Hash_Status_E retVal = CRYPTO_HASH_ERROR_FAIL;
    CRYPTO_SHA_ALGO shaAlgo = CRYPTO_SHA_ALGO_SHA256;
    retVal = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm, &shaAlgo);
    
    if(retVal == CRYPTO_HASH_SUCCESS)
    {
        switch(shaAlgo)
        {
            case CRYPTO_SHA_ALGO_SHA1:
                digestSize = CRYPTO_SHA_DISGEST_SIZE_SHA1;
                break;

            case CRYPTO_SHA_ALGO_SHA224:
            case CRYPTO_SHA_ALGO_SHA512_224:
                digestSize = CRYPTO_SHA_DIGEST_SIZE_SHA224;
                break;        

            case CRYPTO_SHA_ALGO_SHA256:
            case CRYPTO_SHA_ALGO_SHA512_256:
                digestSize = CRYPTO_SHA_DIGEST_SIZE_SHA256;
                break;

            case CRYPTO_SHA_ALGO_SHA384:
                digestSize = CRYPTO_SHA_DIGEST_SIZE_SHA384;
                break;

            case CRYPTO_SHA_ALGO_SHA512:
                digestSize = CRYPTO_SHA_DIGEST_SIZE_SHA512;
                break;

            default:
                digestSize = CRYPTO_SHA_DIGEST_SIZE_INVALID;
                break;
        }
    }
    
   return digestSize;
}
 
// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
    
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *shaInitCtx, 
    crypto_Hash_Algo_E shaAlgorithm_en)
{
<#if !driver_defines?contains("HAVE_CRYPTO_HW_SHA_6156_DRIVER")>
    return CRYPTO_HASH_ERROR_NOTSUPPTED;
<#else>
    CRYPTO_SHA_ALGO shaAlgo;
    crypto_Hash_Status_E result;
    uint8_t *retAdr = NULL;
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*)shaInitCtx;
            
    /* Set algorithm for driver */
    result = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm_en, &shaAlgo);
    if (result != CRYPTO_HASH_SUCCESS)
    {
        return result;
    }
    
    /* Initialize context */
    shaCtx->algo = shaAlgorithm_en;
    shaCtx->totalLen = 0;
    retAdr = memset(shaCtx->buffer, 0, sizeof(shaCtx->buffer));

    if(retAdr == NULL)
    {
        return CRYPTO_HASH_ERROR_FAIL;
    }
    
    /* Configure the driver */
    DRV_CRYPTO_SHA_Init(shaAlgo);
    
    return CRYPTO_HASH_SUCCESS;
</#if>
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *shaUpdateCtx,
    uint8_t *data, uint32_t dataLen)
{
<#if !driver_defines?contains("HAVE_CRYPTO_HW_SHA_6156_DRIVER")>
    return CRYPTO_HASH_ERROR_NOTSUPPTED;
<#else>
    uint32_t *localBuffer = NULL;
    uint32_t fill;
    uint32_t left;
    uint32_t blockSizeBytes;
    uint32_t tempWords;
    CRYPTO_SHA_BLOCK_SIZE blockSizeWords;
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*)shaUpdateCtx;
    
    blockSizeBytes = lCrypto_Hash_Hw_Sha_GetBlockSizeBytes(shaCtx->algo);
    tempWords = (blockSizeBytes >> 2UL);
    blockSizeWords = (CRYPTO_SHA_BLOCK_SIZE)tempWords;
    
    left = ((uint32_t)(shaCtx->totalLen)) & ((uint32_t)(blockSizeBytes - 1UL));
    fill = blockSizeBytes - left;
    shaCtx->totalLen += dataLen;

    if ((left & dataLen) >= fill)
    {
        (void) memcpy((shaCtx->buffer + left), data, fill);
        
        /* MISRA C-2012 deviation block start */
        /* MISRA C-2012 Rule 11.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
</#if>
        /* Load message */
        localBuffer = (uint32_t *)shaCtx->buffer;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
        /* MISRA C-2012 deviation block end */

        for (uint32_t x = 0; x < dataLen; x += blockSizeBytes)
        {
            DRV_CRYPTO_SHA_Update(localBuffer, blockSizeWords);
            localBuffer += (uint32_t)blockSizeWords;
        }
        
        data += fill;
        dataLen -= fill;
        left = 0;
    }

    if (dataLen >= blockSizeBytes)
    {
        /* MISRA C-2012 deviation block start */
        /* MISRA C-2012 Rule 11.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
</#if>
        DRV_CRYPTO_SHA_Update((uint32_t *)data, blockSizeWords);
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
        /* MISRA C-2012 deviation block end */
        data += blockSizeBytes;
        dataLen -= blockSizeBytes; 
    }

    if (dataLen > 0U)
    {
        (void) memcpy((shaCtx->buffer + left), data, dataLen);
    }

    return CRYPTO_HASH_SUCCESS;
</#if>
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *shaFinalCtx, 
    uint8_t *digest)
{
<#if !driver_defines?contains("HAVE_CRYPTO_HW_SHA_6156_DRIVER")>
    return CRYPTO_HASH_ERROR_NOTSUPPTED;
<#else>
    uint32_t blockSizeBytes;
    uint32_t last;
    uint8_t lenMsg[16] = {0};
    uint8_t paddingSizeBytes;
    uint8_t paddingLen;
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 11.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
</#if>
    uint32_t *ptr_digest = (uint32_t*)digest;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */
    CRYPTO_SHA_DIGEST_SIZE digestLen;
    crypto_Hash_Status_E retVal = CRYPTO_HASH_ERROR_FAIL;
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*)shaFinalCtx;
   
    blockSizeBytes = lCrypto_Hash_Hw_Sha_GetBlockSizeBytes(shaCtx->algo);
    paddingSizeBytes = lCrypto_Hash_Hw_Sha_GetPaddingSizeBytes(shaCtx->algo);
   
    /* Get the number of bits */    
    uint64_t totalBits = shaCtx->totalLen << 3;
    
    last = ((uint32_t)(shaCtx->totalLen)) & ((uint32_t)(blockSizeBytes - 1UL));
    if (last < paddingSizeBytes)
    { 
        paddingLen = (uint8_t) (paddingSizeBytes - (uint8_t)last);
    }
    else 
    {
        paddingLen = (uint8_t)blockSizeBytes + (uint8_t)(paddingSizeBytes - last);
    }

    retVal = Crypto_Hash_Hw_Sha_Update(shaCtx, (uint8_t*)&hashPaddingMsg[0], paddingLen);
    
    /* Create the message bit length block */
    if (paddingSizeBytes == HASH_SHORT_PAD_SIZE_BYTES)
    {
        lenMsg[0] = (uint8_t)(totalBits >> 56U);
        lenMsg[1] = (uint8_t)(totalBits >> 48U);
        lenMsg[2] = (uint8_t)(totalBits >> 40U);
        lenMsg[3] = (uint8_t)(totalBits >> 32U);
        lenMsg[4] = (uint8_t)(totalBits >> 24U);
        lenMsg[5] = (uint8_t)(totalBits >> 16U);
        lenMsg[6] = (uint8_t)(totalBits >>  8U);
        lenMsg[7] = (uint8_t)(totalBits);   
    
        retVal = Crypto_Hash_Hw_Sha_Update(shaCtx, lenMsg, 8);    
    }
    else 
    {
        lenMsg[8] = (uint8_t)(totalBits >> 56U);
        lenMsg[9] = (uint8_t)(totalBits >> 48U);
        lenMsg[10] = (uint8_t)(totalBits >> 40U);
        lenMsg[11] = (uint8_t)(totalBits >> 32U);
        lenMsg[12] = (uint8_t)(totalBits >> 24U);
        lenMsg[13] = (uint8_t)(totalBits >> 16U);
        lenMsg[14] = (uint8_t)(totalBits >>  8U);
        lenMsg[15] = (uint8_t)(totalBits);
        
        retVal = Crypto_Hash_Hw_Sha_Update(shaCtx, lenMsg, 16);   
    }

    digestLen = lCrypto_Hash_Hw_Sha_GetDigestLen(shaCtx->algo);
    DRV_CRYPTO_SHA_GetOutputData(ptr_digest, digestLen);

    return retVal;
</#if>
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *data, uint32_t dataLen, 
    uint8_t *digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
<#if !driver_defines?contains("HAVE_CRYPTO_HW_SHA_6156_DRIVER")>
    return CRYPTO_HASH_ERROR_NOTSUPPTED;
<#else>
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
</#if>
}
