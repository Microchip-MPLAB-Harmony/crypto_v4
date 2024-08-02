/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Hash_HwWrapper.h

  Summary:
    Crypto Framework Library wrapper file for hardware SHA.

  Description:
    This header file contains the wrapper interface to access the SHA 
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

#ifndef MCHP_CRYPTO_HASH_HWWRAPPER_H
#define MCHP_CRYPTO_HASH_HWWRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

//#include "crypto/common_crypto/MCHP_Crypto_Common.h"
//#include "crypto/common_crypto/MCHP_Crypto_Hash_Config.h"
#include "crypto/common_crypto/MCHP_Crypto_Hash.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    extern "C" {
#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface 
// *****************************************************************************
// *****************************************************************************
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest);
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Init(void *ptr_md5Ctx);
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Update(void *ptr_md5Ctx, uint8_t *ptr_inputData, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Final(void *ptr_md5Ctx, uint8_t *ptr_digest);
        
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en);
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *ptr_shaCtx, crypto_Hash_Algo_E shaAlgorithm_en);
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *ptr_shaCtx, uint8_t *ptr_inputData, uint32_t dataLen, crypto_Hash_Algo_E shaAlgorithm_en);
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *ptr_shaCtx, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

#endif /* MCHP_CRYPTO_HASH_HWWRAPPER_H */
