/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hash_hsm03785_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for hardware SHA.

  Description:
    This header file contains the wrapper interface to access the SHA 
    hardware driver for Microchip microcontrollers.
**************************************************************************/

/*******************************************************************************
* Copyright (C) 2025 Microchip Technology Inc. and its subsidiaries.
*
* Subject to your compliance with these terms, you may use Microchip software
* and any derivatives exclusively with Microchip products. It is your
* responsibility to comply with third party license terms applicable to your
* use of third party software (including open source software) that may
* accompany Microchip software.
*
* THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
* EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
* WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
* PARTICULAR PURPOSE.
*
* IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
* INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
* WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
* BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
* FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
* ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
* THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
*******************************************************************************/

#ifndef CRYPTO_HASH_HSM03785_WRAPPER_H
#define CRYPTO_HASH_HSM03785_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include "crypto/common_crypto/crypto_hash.h"
#include "crypto/drivers/driver/hsm_hash.h"

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
#define CRYPTO_HW_TOTAL_LEN_INDEX (120/4)
#define CRYPTO_HW_RESTBYTES_LEN_INEX (127)
#define CRYPTO_HW_RESTBYTES_INDEX (128)
        

// *****************************************************************************
// *****************************************************************************
// Section: Hash Algorithms Common Interface 
// *****************************************************************************
// *****************************************************************************
<#if (CRYPTO_HW_MD5?? &&(CRYPTO_HW_MD5 == true))>
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest);
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Init(void *ptr_md5Ctx);
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Update(void *ptr_md5Ctx, uint8_t *ptr_inputData, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Hw_Md5_Final(void *ptr_md5Ctx, uint8_t *ptr_digest);
</#if>
<#if    (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true)) 
    ||  (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true)) 
    ||  (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true))
    ||  (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))
    ||  (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))>
	
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Digest(uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en);
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Init(void *ptr_shaCtx, crypto_Hash_Algo_E shaAlgorithm_en);
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Update(void *ptr_shaCtx, uint8_t *ptr_inputData, uint32_t dataLen, crypto_Hash_Algo_E shaAlgorithm_en);
crypto_Hash_Status_E Crypto_Hash_Hw_Sha_Final(void *ptr_shaCtx, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en);

hsm_Hash_Types_E Crypto_Hash_Hw_GetShaAlgoType(crypto_Hash_Algo_E hashAlgo_en, uint32_t *blockSize);
</#if>
// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility
    }
#endif
// DOM-IGNORE-END

#endif /* CRYPTO_HASH_HSM03785_WRAPPER_H */
