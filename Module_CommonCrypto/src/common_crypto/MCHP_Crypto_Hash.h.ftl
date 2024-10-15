/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    MCHP_Crypto_Hash.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
*******************************************************************************/

#ifndef MCHP_CRYPTO_HASH_H
#define MCHP_CRYPTO_HASH_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/MCHP_Crypto_Common.h"
#include "crypto/common_crypto/MCHP_Crypto_Hash_Config.h"
// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************

#define CRYPTO_HASH_SHA512CTX_SIZE (288)

typedef enum {
	CRYPTO_HASH_INVALID = 0,
            
<#if (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true)) || (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true)) || (CRYPTO_ICM11105_SHA1?? &&(CRYPTO_ICM11105_SHA1 == true))>            
	CRYPTO_HASH_SHA1 = 1,
</#if> <#-- CRYPTO_WC_SHA1 || CRYPTO_HW_SHA1 || CRYPTO_ICM11105_SHA1 --> 
            
<#if (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true)) || (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true)) || (CRYPTO_ICM11105_SHA2_224?? &&(CRYPTO_ICM11105_SHA2_224 == true))>            
	CRYPTO_HASH_SHA2_224 = 2,
</#if> <#-- CRYPTO_WC_SHA2_224 || CRYPTO_HW_SHA2_224 || CRYPTO_ICM11105_SHA2_224 -->
            
<#if (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true)) || (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true)) || (CRYPTO_ICM11105_SHA2_256?? &&(CRYPTO_ICM11105_SHA2_256 == true))>           
	CRYPTO_HASH_SHA2_256 = 3,
</#if> <#-- CRYPTO_WC_SHA2_256 || CRYPTO_HW_SHA2_256 || CRYPTO_ICM11105_SHA2_256 --> 
            
<#if (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true)) || (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))>           
	CRYPTO_HASH_SHA2_384 = 4,
</#if> <#-- CRYPTO_WC_SHA2_384 || CRYPTO_HW_SHA2_384 --> 
            
<#if (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true)) || (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))>              
	CRYPTO_HASH_SHA2_512 = 5,
</#if> <#-- CRYPTO_WC_SHA2_512 || CRYPTO_HW_SHA2_512 --> 

<#if (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true)) || (CRYPTO_HW_SHA2_512_224?? &&(CRYPTO_HW_SHA2_512_224 == true))>          
	CRYPTO_HASH_SHA2_512_224 = 6,
</#if> <#-- CRYPTO_WC_SHA2_512_224 || CRYPTO_HW_SHA2_512_224 --> 

<#if (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true)) || (CRYPTO_HW_SHA2_512_256?? &&(CRYPTO_HW_SHA2_512_256 == true))>            
	CRYPTO_HASH_SHA2_512_256 = 7,
</#if> <#-- CRYPTO_WC_SHA2_512_256 || CRYPTO_HW_SHA2_512_256 -->             

<#if (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))>         
	CRYPTO_HASH_SHA3_224 = 8,
</#if> <#-- CRYPTO_WC_SHA3_224 --> 

<#if (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))>           
	CRYPTO_HASH_SHA3_256 = 9,
</#if> <#-- CRYPTO_WC_SHA3_256 --> 

<#if (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))>           
	CRYPTO_HASH_SHA3_384 = 10,
</#if> <#-- CRYPTO_WC_SHA3_384 --> 

<#if (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>                    
	CRYPTO_HASH_SHA3_512 = 11,
</#if> <#-- CRYPTO_WC_SHA3_512 -->            
 
<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true))>             
	CRYPTO_HASH_SHA3_SHAKE128 = 12,
</#if> <#-- CRYPTO_WC_SHAKE_128 --> 
            
<#if (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>           
	CRYPTO_HASH_SHA3_SHAKE256 = 13,
</#if> <#-- CRYPTO_WC_SHAKE_256 -->             

<#if (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))> 
	CRYPTO_HASH_BLAKE2B = 14,
</#if> <#-- CRYPTO_WC_BLAKE2B -->
            
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true)) >           
	CRYPTO_HASH_BLAKE2S = 15,
</#if> <#-- CRYPTO_WC_BLAKE2S -->           
            
<#if (CRYPTO_WC_MD5?? &&(CRYPTO_WC_MD5 == true)) || (CRYPTO_HW_MD5?? &&(CRYPTO_HW_MD5 == true))>           
	CRYPTO_HASH_MD5 = 16,
</#if>  <#-- CRYPTO_WC_MD5 || CRYPTO_HW_MD5 -->

<#if (CRYPTO_WC_RIPEMD160?? &&(CRYPTO_WC_RIPEMD160 == true))>            
	CRYPTO_HASH_RIPEMD160 = 17,
</#if>  <#-- CRYPTO_WC_RIPEMD160 -->
            
	CRYPTO_HASH_MAX
}crypto_Hash_Algo_E;

typedef enum {
    CRYPTO_HASH_ERROR_NOTSUPPTED = -127,
    CRYPTO_HASH_ERROR_CTX = -126,
    CRYPTO_HASH_ERROR_INPUTDATA = -125,
    CRYPTO_HASH_ERROR_OUTPUTDATA = -124,
    CRYPTO_HASH_ERROR_SID = -123,
    CRYPTO_HASH_ERROR_ALGO = -122,
    CRYPTO_HASH_ERROR_KEY = -121,
    CRYPTO_HASH_ERROR_ARG = -120,
    CRYPTO_HASH_ERROR_HDLR = -119,
	CRYPTO_HASH_ERROR_FAIL = -118,
	CRYPTO_HASH_SUCCESS = 0
}crypto_Hash_Status_E;

//MD5 Algorithm
<#if (CRYPTO_WC_MD5?? &&(CRYPTO_WC_MD5 == true)) || (CRYPTO_HW_MD5?? &&(CRYPTO_HW_MD5 == true))>
typedef struct{
	uint32_t md5SessionId;
	crypto_HandlerType_E md5Handler_en;
	uint8_t arr_md5DataCtx[110];// __attribute__((aligned (8)));
}st_Crypto_Hash_Md5_Ctx;
</#if>  <#-- CRYPTO_WC_MD5 || CRYPTO_HW_MD5 -->

<#if (CRYPTO_WC_RIPEMD160?? &&(CRYPTO_WC_RIPEMD160 == true))>
//RIPEMD-160 Algorithm
typedef struct{
	uint32_t ripemd160SessionId;
	crypto_HandlerType_E ripedmd160Handler_en;
	uint8_t arr_ripemd160DataCtx[110];// __attribute__((aligned (8)));
}st_Crypto_Hash_Ripemd160_Ctx;
</#if>  <#-- CRYPTO_WC_RIPEMD160 -->

<#if    (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))           
    ||  (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true))  
    ||  (CRYPTO_ICM11105_SHA1?? &&(CRYPTO_ICM11105_SHA1 == true))
    ||  (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true))   
    ||  (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true)) 
    ||  (CRYPTO_ICM11105_SHA2_224?? &&(CRYPTO_ICM11105_SHA2_224 == true))
    ||  (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))   
    ||  (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true)) 
    ||  (CRYPTO_ICM11105_SHA2_256?? &&(CRYPTO_ICM11105_SHA2_256 == true))
    ||  (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true))   
    ||  (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))
    ||  (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true))   
    ||  (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))
    ||  (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true)) 
    ||  (CRYPTO_HW_SHA2_512_224?? &&(CRYPTO_HW_SHA2_512_224 == true))
    ||  (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true)) 
    ||  (CRYPTO_HW_SHA2_512_256?? &&(CRYPTO_HW_SHA2_512_256 == true))
    ||  (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))
    ||  (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))
    ||  (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))
    ||  (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>
//SHA-1, SHA-2, SHA-3(Except SHAKE)
typedef struct{
	uint32_t shaSessionId;
	crypto_Hash_Algo_E shaAlgo_en;
	crypto_HandlerType_E shaHandler_en;
	uint8_t arr_shaDataCtx[CRYPTO_HASH_SHA512CTX_SIZE] __attribute__((aligned (4)));
}st_Crypto_Hash_Sha_Ctx;
</#if>

<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true)) || (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>
//SHA-3 only SHAKE
typedef struct{
	uint32_t shakeSessionId;
	uint32_t digestLen;
	crypto_Hash_Algo_E shakeAlgo_en;
	crypto_HandlerType_E shakeHandler_en;
	uint8_t arr_shakeDataCtx[CRYPTO_HASH_SHA512CTX_SIZE];// __attribute__((aligned (8)));
}st_Crypto_Hash_Shake_Ctx;
</#if> <#-- CRYPTO_WC_SHAKE_128 || CRYPTO_WC_SHAKE_256 -->

<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true)) || (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))>
//BLAKE Algorithm
typedef struct{
	uint32_t blakeSessionId;
	uint32_t digestLen;
	crypto_Hash_Algo_E blakeAlgo_en;
	crypto_HandlerType_E blakeHandler_en;
	uint8_t *ptr_key;
	uint32_t keyLen;
	uint8_t arr_blakeDataCtx[400];// __attribute__((aligned (8)));
}st_Crypto_Hash_Blake_Ctx;
</#if> <#-- CRYPTO_WC_BLAKE2S || CRYPTO_WC_BLAKE2B -->
// *****************************************************************************

<#if (CRYPTO_WC_MD5?? &&(CRYPTO_WC_MD5 == true)) || (CRYPTO_HW_MD5?? &&(CRYPTO_HW_MD5 == true))>
//MD5 Algorithm
crypto_Hash_Status_E Crypto_Hash_Md5_Digest(crypto_HandlerType_E md5Handler_en, uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest, uint32_t md5SessionId);
crypto_Hash_Status_E Crypto_Hash_Md5_Init(st_Crypto_Hash_Md5_Ctx *ptr_md5Ctx_st, crypto_HandlerType_E md5HandlerType_en, uint32_t md5SessionId);
crypto_Hash_Status_E Crypto_Hash_Md5_Update(st_Crypto_Hash_Md5_Ctx * ptr_md5Ctx_st, uint8_t *ptr_data, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Md5_Final(st_Crypto_Hash_Md5_Ctx * ptr_md5Ctx_st, uint8_t *ptr_digest);
</#if>  <#-- CRYPTO_WC_MD5 || CRYPTO_HW_MD5 -->

<#if (CRYPTO_WC_RIPEMD160?? &&(CRYPTO_WC_RIPEMD160 == true))>
//RIPEMD-160 Algorithm
crypto_Hash_Status_E Crypto_Hash_Ripemd160_Digest(crypto_HandlerType_E ripedmd160Handler_en, uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest, uint32_t ripemdSessionId);
crypto_Hash_Status_E Crypto_Hash_Ripemd160_Init(st_Crypto_Hash_Ripemd160_Ctx *ptr_ripemdCtx_st, crypto_HandlerType_E ripedmd160Handler_en, uint32_t ripemdSessionId);
crypto_Hash_Status_E Crypto_Hash_Ripemd160_Update(st_Crypto_Hash_Ripemd160_Ctx *ptr_ripemdCtx_st, uint8_t *ptr_data, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Ripemd160_Final(st_Crypto_Hash_Ripemd160_Ctx *ptr_ripemdCtx_st, uint8_t *ptr_digest);
</#if>  <#-- CRYPTO_WC_RIPEMD160 -->

<#if    (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))           
    ||  (CRYPTO_HW_SHA1?? &&(CRYPTO_HW_SHA1 == true))  
    ||  (CRYPTO_ICM11105_SHA1?? &&(CRYPTO_ICM11105_SHA1 == true))
    ||  (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true))   
    ||  (CRYPTO_HW_SHA2_224?? &&(CRYPTO_HW_SHA2_224 == true)) 
    ||  (CRYPTO_ICM11105_SHA2_224?? &&(CRYPTO_ICM11105_SHA2_224 == true))
    ||  (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))   
    ||  (CRYPTO_HW_SHA2_256?? &&(CRYPTO_HW_SHA2_256 == true)) 
    ||  (CRYPTO_ICM11105_SHA2_256?? &&(CRYPTO_ICM11105_SHA2_256 == true))
    ||  (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true))   
    ||  (CRYPTO_HW_SHA2_384?? &&(CRYPTO_HW_SHA2_384 == true))
    ||  (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true))   
    ||  (CRYPTO_HW_SHA2_512?? &&(CRYPTO_HW_SHA2_512 == true))
    ||  (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true)) 
    ||  (CRYPTO_HW_SHA2_512_224?? &&(CRYPTO_HW_SHA2_512_224 == true))
    ||  (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true)) 
    ||  (CRYPTO_HW_SHA2_512_256?? &&(CRYPTO_HW_SHA2_512_256 == true))
    ||  (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))
    ||  (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))
    ||  (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))
    ||  (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>
//SHA-1, SHA-2, SHA-3(Except SHAKE)
crypto_Hash_Status_E Crypto_Hash_Sha_Digest(crypto_HandlerType_E shaHandler_en, uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest, crypto_Hash_Algo_E shaAlgorithm_en, uint32_t shaSessionId);
crypto_Hash_Status_E Crypto_Hash_Sha_Init(st_Crypto_Hash_Sha_Ctx *ptr_shaCtx_st, crypto_Hash_Algo_E shaAlgorithm_en, crypto_HandlerType_E shaHandler_en, uint32_t shaSessionId);
crypto_Hash_Status_E Crypto_Hash_Sha_Update(st_Crypto_Hash_Sha_Ctx *ptr_shaCtx_st, uint8_t *ptr_data, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Sha_Final(st_Crypto_Hash_Sha_Ctx *ptr_shaCtx_st, uint8_t *ptr_digest);
</#if> 


<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true)) || (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>
//SHA-3 only SHAKE
crypto_Hash_Status_E Crypto_Hash_Shake_Digest(crypto_HandlerType_E shakeHandlerType_en, crypto_Hash_Algo_E shakeAlgorithm_en, uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest, uint32_t digestLen, uint32_t shakeSessionId);
crypto_Hash_Status_E Crypto_Hash_Shake_Init(st_Crypto_Hash_Shake_Ctx* ptr_shakeCtx_st, crypto_Hash_Algo_E shakeAlgorithm_en, crypto_HandlerType_E shakeHandlerType_en, uint32_t digestLen, uint32_t shakeSessionId);
crypto_Hash_Status_E Crypto_Hash_Shake_Update(st_Crypto_Hash_Shake_Ctx* ptr_shakeCtx_st, uint8_t *ptr_data, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Shake_Final(st_Crypto_Hash_Shake_Ctx* ptr_shakeCtx_st, uint8_t *ptr_digest);
</#if> <#-- CRYPTO_WC_SHAKE_128 || CRYPTO_WC_SHAKE_256 -->


<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true)) || (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))>
//BLAKE Algorithm
crypto_Hash_Status_E Crypto_Hash_Blake_Digest(crypto_HandlerType_E blakeHandlerType_en, crypto_Hash_Algo_E blakeAlgorithm_en, uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_blakeKey, uint32_t keySize, uint8_t *ptr_digest, uint32_t digestLen, uint32_t blakeSessionId);
crypto_Hash_Status_E Crypto_Hash_Blake_Init(st_Crypto_Hash_Blake_Ctx *ptr_blakeCtx_st,crypto_Hash_Algo_E blakeAlgorithm_en, uint8_t *ptr_blakeKey, uint32_t keySize, uint32_t digestSize, crypto_HandlerType_E blakeHandlerType_en, uint32_t blakeSessionId);
crypto_Hash_Status_E Crypto_Hash_Blake_Update(st_Crypto_Hash_Blake_Ctx * ptr_blakeCtx_st, uint8_t *ptr_data, uint32_t dataLen);
crypto_Hash_Status_E Crypto_Hash_Blake_Final(st_Crypto_Hash_Blake_Ctx * ptr_blakeCtx_st, uint8_t *ptr_digest);
</#if> <#-- CRYPTO_WC_BLAKE2S || CRYPTO_WC_BLAKE2B -->

uint32_t Crypto_Hash_GetHashAndHashSize(crypto_HandlerType_E shaHandler_en, crypto_Hash_Algo_E hashType_en, uint8_t *ptr_wcInputData, 
                                                                                                        uint32_t wcDataLen, uint8_t *ptr_outHash);
#endif //MCHP_CRYPTO_HASH_H
