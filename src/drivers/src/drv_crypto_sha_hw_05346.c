/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_sha_hw_05346.c

  Summary:
    Crypto Framework Library interface file for hardware SHA.

  Description:
    This source file contains the interface that make up the SHA hardware 
    driver for the following families of Microchip microcontrollers:
    dsPIC33AK with Crypto Accelerator Module.
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

#include "../drv_crypto_sha_hw_05346.h"
#include "../../../../../libraries/cam_dma.h"

// *****************************************************************************
// *****************************************************************************
// Section: SHA Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_SHA_Init(CRYPTO_SHA_ALGO shaAlgo)
{
    uint32_t hashConfig = 0;
    HASHCON_MODE mode = 0;
    
    DRV_CRYPTO_DMA_Configure();
    DRV_CRYPTO_CAM_InterruptSetup();
    DRV_CRYPTO_CAM_SYM_InterruptEnable();
    (void) DRV_CRYPTO_DMA_Reset();
    
    switch(shaAlgo)
    {
        case CRYPTO_SHA_ALGO_SHA1:
            mode = MODE_SHA1;
            break;
        case CRYPTO_SHA_ALGO_SHA224:
            mode = MODE_SHA224;
            break;
        case CRYPTO_SHA_ALGO_SHA256:
            mode = MODE_SHA256;
            break;
        case CRYPTO_SHA_ALGO_SHA384:
            mode = MODE_SHA384;
            break;
        case CRYPTO_SHA_ALGO_SHA512:
            mode = MODE_SHA512;
            break;
        default:
            mode = MODE_SHA256;
            break;
    }
    
    (void) DRV_CRYPTO_DMA_SHA_SetupEngine(&hashConfig, mode, DIGEST, HW_PADDING, HMAC_OFF);
    (void) DRV_CRYPTO_DMA_SetTagConfig(TAG_ENGINE_HASH, TAG_IS_LAST, ZERO);
     DRV_CRYPTO_DMA_SetFetchAddress((uint32_t) & hashConfig);  
    (void) DRV_CRYPTO_DMA_SetFetchLength(CAM_INIT_FETCH_LENGTH);
    (void) DRV_CRYPTO_DMA_StartFetch();
}

void DRV_CRYPTO_SHA_Update(uint32_t *data, uint32_t size, uint8_t numOfPaddingBytes)
{
    (void) DRV_CRYPTO_DMA_SetTagData(TAG_ENGINE_HASH, TAG_IS_LAST, 
            TAG_HASH_MESSAGE, numOfPaddingBytes);
    DRV_CRYPTO_DMA_SetFetchAddress((uint32_t) data);
    (void) DRV_CRYPTO_DMA_SetFetchLength(size);
    (void) DRV_CRYPTO_DMA_StartFetch();
}

void DRV_CRYPTO_SHA_GetOutputData(uint32_t *digest)
{
    uint16_t timeout = (uint16_t) DMA_TIMEOUT_LIMIT;
    uint8_t* outputData = (uint8_t*) digest;
    
    while (!DRV_CRYPTO_DMA_DataIsReady() && (timeout > (uint16_t) 0))
    {
        timeout--;
    }
    
    while(DRV_CRYPTO_DMA_DataIsReady())
    {
        uint16_t sizeOfAvailableData = DRV_CRYPTO_DMA_GetAvailableDataSize();
        
        DRV_CRYPTO_DMA_SetPushAddress((uint32_t) outputData);
        (void) DRV_CRYPTO_DMA_SetPushLength((uint32_t) sizeOfAvailableData);
        (void) DRV_CRYPTO_DMA_StartPush();
        
        outputData += (uint8_t) sizeOfAvailableData;
    }
}
