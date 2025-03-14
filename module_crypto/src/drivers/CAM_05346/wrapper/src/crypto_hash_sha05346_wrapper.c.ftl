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
#include "crypto/drivers/library/cam_hash.h"
#include <xc.h>

// *****************************************************************************
// *****************************************************************************
// Section: Global Functions
// *****************************************************************************
// *****************************************************************************

void __attribute__((interrupt)) _CRYPTO1Interrupt(void);

void __attribute__((interrupt)) _CRYPTO1Interrupt(void) 
{
    DRV_CRYPTO_Hash_IsrHelper();
    _CRYPT1IF = 0;
}

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

static void lDRV_CRYPTO_Hash_InterruptSetup(void)
{
    _CRYPT1IF = 0;
    _CRYPT1IE = 1;
}

static crypto_Hash_Status_E lCrypto_Hash_Hw_Sha_GetAlgorithm(crypto_Hash_Algo_E shaAlgorithm, 
        HASHCON_MODE* mode)
{
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    
    switch(shaAlgorithm)
    {  
        case CRYPTO_HASH_SHA1:
            *mode = MODE_SHA1;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_224:
            *mode = MODE_SHA224;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_256:
            *mode = MODE_SHA256;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_384:
            *mode = MODE_SHA384;
            status = CRYPTO_HASH_SUCCESS;
            break;
        case CRYPTO_HASH_SHA2_512:
            *mode = MODE_SHA512;
            status = CRYPTO_HASH_SUCCESS;
            break;
        default:
            status = CRYPTO_HASH_ERROR_ALGO;
            break;
    }
    
    return status;
}

// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface Implementation
// *****************************************************************************
// *****************************************************************************
    
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *shaInitCtx, 
        crypto_Hash_Algo_E shaAlgorithm)
{
    HASHCON_MODE mode;
    CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*) shaInitCtx;
    
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    HASH_ERROR hashStatus = HASH_INITIALIZE_ERROR;
            
    status = lCrypto_Hash_Hw_Sha_GetAlgorithm(shaAlgorithm, &mode);
    
    if (status == CRYPTO_HASH_SUCCESS)
    {
        shaCtx->algorithm = shaAlgorithm;
        hashStatus = DRV_CRYPTO_Hash_Initialize(mode);
    }
    
    if (hashStatus == HASH_NO_ERROR)
    {
        lDRV_CRYPTO_Hash_InterruptSetup();
    }
    else 
    {        
        status = CRYPTO_HASH_ERROR_FAIL;
    }
    
    return status;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *shaUpdateCtx,
    uint8_t *data, uint32_t dataLen)
{
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    HASH_ERROR hashStatus = DRV_CRYPTO_Hash_Update(data, dataLen);
    
    if (hashStatus == HASH_NO_ERROR)
    {
        status = CRYPTO_HASH_SUCCESS;
    }
    
    return status;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *shaFinalCtx, 
    uint8_t *digest)
{
    crypto_Hash_Status_E status = CRYPTO_HASH_ERROR_FAIL;
    HASH_ERROR hashStatus = HASH_READ_ERROR;
    
    const CRYPTO_HASH_HW_CONTEXT *shaCtx = (CRYPTO_HASH_HW_CONTEXT*) shaFinalCtx;
    uint32_t digestLen;
    
    switch(shaCtx->algorithm)
    {
        case CRYPTO_HASH_SHA1:
            digestLen = 20;
            break;
        case CRYPTO_HASH_SHA2_224:
            digestLen = 28;
            break;
        case CRYPTO_HASH_SHA2_256:
            digestLen = 32;
            break;
        case CRYPTO_HASH_SHA2_384:
            digestLen = 48;
            break;
        case CRYPTO_HASH_SHA2_512:
            digestLen = 64;
            break;
        default:
            digestLen = 0;
            break;
    }
    
    hashStatus = DRV_CRYPTO_Hash_Final(digest, digestLen);
    
    if (hashStatus == HASH_NO_ERROR)
    {
        status = CRYPTO_HASH_SUCCESS;
    }
    
    return status;
}

crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *data, uint32_t dataLen, 
    uint8_t *digest, crypto_Hash_Algo_E shaAlgorithm_en)
{
    CRYPTO_HASH_HW_CONTEXT shaCtx;

    crypto_Hash_Status_E status = Crypto_Hash_Hw_Sha_Init(&shaCtx, shaAlgorithm_en);
    
    if (status == CRYPTO_HASH_SUCCESS)
    {
        status = Crypto_Hash_Hw_Sha_Update(&shaCtx, data, dataLen);
    }
    
    if (status == CRYPTO_HASH_SUCCESS)
    {
        status = Crypto_Hash_Hw_Sha_Final(&shaCtx, digest);
    }
    
    return status;
}
