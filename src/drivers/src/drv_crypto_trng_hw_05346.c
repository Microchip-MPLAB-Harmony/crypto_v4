/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_trng_hw_05346.c

  Summary:
    Crypto Framework Library interface file for hardware TRNG.

  Description:
    This source file contains the interface that make up the TRNG hardware 
    driver for the following families of Microchip microcontrollers:
    dsPIC33CK512MPS512.
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

#include "../drv_crypto_trng_hw_05346.h"
#include "../../../../../libraries/cam_trng.h"

// *****************************************************************************
// *****************************************************************************
// Section: Global Functions
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
// *****************************************************************************
// Section: File Scope Functions
// *****************************************************************************
// *****************************************************************************

static inline TRNG_ERROR lDRV_CRYPTO_TRNG_ReadDriverData(uint32_t* data, uint32_t size){
    TRNG_ERROR error_code = DRV_CRYPTO_TRNG_ReadData(data, size);
    if (TRNG_NO_ERROR != error_code)
        return error_code;
    return DRV_CRYPTO_TRNG_CheckError();
}

static inline TRNG_ERROR lDRV_CRYPTO_TRNG_SetKey(trng_struct* trng_data){
    uint32_t key_data[128/4] = {0};
    TRNG_ERROR error_code = DRV_CRYPTO_TRNG_ReadDrvData(key_data, 128);
    if (TRNG_NO_ERROR != error_code)
        return TRNG_KEY_SETUP_FAIL;
    trng_data->key.data = key_data;
    trng_data->key.size = 128;
    DRV_CRYPTO_TRNG_SetupKey(trng_data->key.data, trng_data->key.size);
    return TRNG_NO_ERROR;
}

static inline TRNG_ERROR lDRV_CRYPTO_TRNG_Setup(trng_struct* trng_data){
    TRNG_ERROR error_code;
    DRV_CRYPTO_TRNG_Reset();
    DRV_CRYPTO_TRNG_SetupEngine(trng_data->fifo_write_startup, trng_data->htest_after_cond, trng_data->conditioning_bypass, trng_data->nb128block);
    DRV_CRYPTO_TRNG_SetInitialWait(trng_data->initial_wait);
    DRV_CRYPTO_TRNG_SetFifoThreshold( trng_data->fifo_threshold);
    error_code = lDRV_CRYPTO_TRNG_SetKey(trng_data);
    if (TRNG_NO_ERROR != error_code)
        return error_code;
    return TRNG_NO_ERROR;
}

// *****************************************************************************
// *****************************************************************************
// Section: TRNG Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_TRNG_Generate(uint8_t *rngData, uint32_t rngLen) {
    TRNG_ERROR errorCode = 0x99;
    trng_struct trngData;
    trngData.clk_div = 0;                           // Set the frequency div at which the outputs of the rings are sampled is given by
    trngData.conditioning_bypass = false;           // Conditioning function bypass bit
    trngData.fifo_threshold = 3;                    // FIFO level below which the module leaves the idle state to refill the FIFO, expressed in number of
                                                    // 128-bit blocks
    trngData.fifo_write_startup = false;            // Enable/Disable write of the samples in the FIFO during start-up 
    trngData.htest_after_cond = false;              // Output Before/After conditioning as input to Health test module
    trngData.initial_wait = 0x100;                  // Set the number of clock cycles to wait before sampling data from the noise          
    trngData.nb128block = 4;                        // Number of 128-bit blocks used in AES-CBCMAC post-processing bits
    trngData.off_tmr = 0xFFF; 
    
    lDRV_CRYPTO_TRNG_Setup(&trngData);
    errorCode = lDRV_CRYPTO_TRNG_ReadDriverData((uint32_t*) rngData, rngLen);
}