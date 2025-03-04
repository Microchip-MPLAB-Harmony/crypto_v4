/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hash_wc_wrapper.c

  Summary:
    This file contains the source code for the MPLAB Harmony application.

  Description:
    This file contains the source code for the MPLAB Harmony application.  It
    implements the logic of the application's state machine and it may call
    API routines of other MPLAB Harmony modules in the system, such as drivers,
    system services, and middleware.  However, it does not call any of the
    system interfaces (such as the "Initialize" and "Tasks" functions) of any of
    the modules in the system or make any assumptions about when those functions
    are called.  That is the responsibility of the configuration-specific system
    files.
*******************************************************************************/

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
 
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_hash.h"
#include "crypto/wolfcrypt/crypto_hash_wc_wrapper.h"
#include "wolfssl/wolfcrypt/error-crypt.h"
<#if (CRYPTO_WC_MD5?? &&(CRYPTO_WC_MD5 == true))>
#include "wolfssl/wolfcrypt/md5.h"
</#if><#-- CRYPTO_WC_MD5 -->
<#if (CRYPTO_WC_RIPEMD160?? &&(CRYPTO_WC_RIPEMD160 == true))>
#include "wolfssl/wolfcrypt/ripemd.h"
</#if><#-- CRYPTO_WC_RIPEMD160 -->
<#if (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))>
#include "wolfssl/wolfcrypt/sha.h"
</#if><#-- CRYPTO_WC_SHA1 -->
<#if (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true)) || (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))>
#include "wolfssl/wolfcrypt/sha256.h"
</#if><#-- CRYPTO_WC_SHA2_224 || CRYPTO_WC_SHA2_256 -->
<#if   (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true)) 
    || (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true)) 
    || (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true)) 
    || (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true))>
#include "wolfssl/wolfcrypt/sha512.h"
</#if><#-- CRYPTO_WC_SHA2_384 || CRYPTO_WC_SHA2_512 || CRYPTO_WC_SHA2_512_224 || CRYPTO_WC_SHA2_512_256 -->
<#if    (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))
    ||  (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))
    ||  (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))
    ||  (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))
    ||  (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true))
    ||  (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))> 
#include "wolfssl/wolfcrypt/sha3.h"
</#if><#-- CRYPTO_WC_SHA3_224 || CRYPTO_WC_SHA3_256 || CRYPTO_WC_SHA3_384 || CRYPTO_WC_SHA3_512 -->
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true)) || (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))>
#include "wolfssl/wolfcrypt/blake2.h"
</#if><#-- CRYPTO_WC_BLAKE2S || CRYPTO_WC_BLAKE2B -->
// *****************************************************************************
// *****************************************************************************
// Section: Global Data Definitions
// *****************************************************************************
// *****************************************************************************


// *****************************************************************************
<#if (CRYPTO_WC_MD5?? &&(CRYPTO_WC_MD5 == true))>
crypto_Hash_Status_E Crypto_Hash_Wc_Md5Digest(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 

    if( (ptr_data != NULL) && (ptr_digest != NULL) && (dataLen > 0u) )
    {
        wc_Md5 ptr_md5Ctx_st[1];
        ret_md5Stat_en = Crypto_Hash_Wc_Md5Init(ptr_md5Ctx_st);
        if(ret_md5Stat_en == CRYPTO_HASH_SUCCESS)
        {
            ret_md5Stat_en = Crypto_Hash_Wc_Md5Update(ptr_md5Ctx_st, ptr_data, dataLen);
            if(ret_md5Stat_en == CRYPTO_HASH_SUCCESS)
            {
                ret_md5Stat_en = Crypto_Hash_Wc_Md5Final(ptr_md5Ctx_st, ptr_digest);
            }
        }
    }
    else
    {
        ret_md5Stat_en = CRYPTO_HASH_ERROR_ARG;
    }
    return ret_md5Stat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_Md5Init(void *ptr_md5Ctx_st)
{  	
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    int wcMd5Status = BAD_FUNC_ARG;
    if(ptr_md5Ctx_st != NULL)
    {
        wcMd5Status = wc_InitMd5((wc_Md5*)ptr_md5Ctx_st);

        if(wcMd5Status == 0)
        {
            ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcMd5Status == BAD_FUNC_ARG)
        {
            ret_md5Stat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
        ret_md5Stat_en = CRYPTO_HASH_ERROR_CTX;
    }
    return ret_md5Stat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_Md5Update(void *ptr_md5Ctx_st, uint8_t *ptr_data, uint32_t dataLen)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcMd5Status = BAD_FUNC_ARG;
    if(ptr_md5Ctx_st != NULL)
    {
        wcMd5Status = wc_Md5Update((wc_Md5*)ptr_md5Ctx_st, (const byte*)ptr_data, (word32)dataLen);
        
        if(wcMd5Status == 0)
        {
            ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcMd5Status == BAD_FUNC_ARG)
        {
            ret_md5Stat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
       ret_md5Stat_en = CRYPTO_HASH_ERROR_CTX;
    }
    return ret_md5Stat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_Md5Final(void *ptr_md5Ctx_st, uint8_t *ptr_digest)
{
    crypto_Hash_Status_E ret_md5Stat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcMd5Status = BAD_FUNC_ARG;
    if(ptr_md5Ctx_st != NULL)
    {
        wcMd5Status = wc_Md5Final((wc_Md5*)ptr_md5Ctx_st, (byte*)ptr_digest);
        
        if(wcMd5Status == 0)
        {
            ret_md5Stat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcMd5Status == BAD_FUNC_ARG)
        {
            ret_md5Stat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_md5Stat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
       ret_md5Stat_en = CRYPTO_HASH_ERROR_CTX;
    }
    return ret_md5Stat_en; 
}
</#if><#-- CRYPTO_WC_MD5 -->
<#if (CRYPTO_WC_RIPEMD160?? &&(CRYPTO_WC_RIPEMD160 == true))>

crypto_Hash_Status_E Crypto_Hash_Wc_Ripemd160Digest(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest)
{
    crypto_Hash_Status_E ret_ripemdStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;  
    RipeMd ptr_ripemdCtx_st[1];
    if( (ptr_data != NULL) && (ptr_digest != NULL) && (dataLen != 0u) )
    {
        //Initialize the Ripemd160 context
        ret_ripemdStat_en = Crypto_Hash_Wc_Ripemd160Init(ptr_ripemdCtx_st);
        
        if(ret_ripemdStat_en == CRYPTO_HASH_SUCCESS)
        {
            ret_ripemdStat_en = Crypto_Hash_Wc_Ripemd160Update(ptr_ripemdCtx_st, ptr_data, dataLen);
        }
        if(ret_ripemdStat_en == CRYPTO_HASH_SUCCESS)
        {
            ret_ripemdStat_en = Crypto_Hash_Wc_Ripemd160Final(ptr_ripemdCtx_st, ptr_digest);
        }
        else
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
       ret_ripemdStat_en = CRYPTO_HASH_ERROR_ARG;
    }
    return ret_ripemdStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_Ripemd160Init(void *ptr_ripemdCtx_st)
{
    crypto_Hash_Status_E ret_ripemdStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED; 
    int wcRipemdStatus = BAD_FUNC_ARG;
    if(ptr_ripemdCtx_st != NULL)
    {
        wcRipemdStatus = wc_InitRipeMd((RipeMd*)ptr_ripemdCtx_st);

        if(wcRipemdStatus == 0)
        {
            ret_ripemdStat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcRipemdStatus == BAD_FUNC_ARG)
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
        ret_ripemdStat_en = CRYPTO_HASH_ERROR_CTX;
    }   
    return ret_ripemdStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_Ripemd160Update(void *ptr_ripemdCtx_st, uint8_t *ptr_data, uint32_t dataLen)
{
    crypto_Hash_Status_E ret_ripemdStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcRipemdStatus = BAD_FUNC_ARG;
    if(ptr_ripemdCtx_st != NULL)
    {
        wcRipemdStatus = wc_RipeMdUpdate((RipeMd*)ptr_ripemdCtx_st, (const byte*)ptr_data, (word32)dataLen);
        
        if(wcRipemdStatus == 0)
        {
            ret_ripemdStat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcRipemdStatus == BAD_FUNC_ARG)
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
       ret_ripemdStat_en = CRYPTO_HASH_ERROR_CTX;
    } 
    return ret_ripemdStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_Ripemd160Final(void *ptr_ripemdCtx_st, uint8_t *ptr_digest)
{   
    crypto_Hash_Status_E ret_ripemdStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcRipemdStatus = BAD_FUNC_ARG;
    if( (ptr_ripemdCtx_st != NULL) && (ptr_digest != NULL) )
    {
        wcRipemdStatus = wc_RipeMdFinal((RipeMd*)ptr_ripemdCtx_st, (byte*)ptr_digest);
        
        if(wcRipemdStatus == 0)
        {
            ret_ripemdStat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcRipemdStatus == BAD_FUNC_ARG)
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_ripemdStat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
       ret_ripemdStat_en = CRYPTO_HASH_ERROR_ARG;
    }
    return ret_ripemdStat_en;
}
</#if><#-- CRYPTO_WC_RIPEMD160 -->
<#if    (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))           
    ||  (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true))   
    ||  (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))   
    ||  (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true))   
    ||  (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true))   
    ||  (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true)) 
    ||  (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true)) 
    ||  (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))
    ||  (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))
    ||  (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))
    ||  (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>
	
crypto_Hash_Status_E Crypto_Hash_Wc_ShaDigest(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    
    //As due to VLA misra Issue maximum Size is allocated
    uint8_t arr_shaDataCtx[CRYPTO_HASH_SHA512CTX_SIZE];
    
    if( (ptr_data != NULL) && (dataLen > 0u) && (ptr_digest != NULL) )
    {
        ret_shaStat_en = Crypto_Hash_Wc_ShaInit(arr_shaDataCtx, hashAlgo_en);
        if(ret_shaStat_en == CRYPTO_HASH_SUCCESS)
        {
            ret_shaStat_en = Crypto_Hash_Wc_ShaUpdate(arr_shaDataCtx, ptr_data, dataLen, hashAlgo_en);
            if(ret_shaStat_en == CRYPTO_HASH_SUCCESS)
            {
                ret_shaStat_en = Crypto_Hash_Wc_ShaFinal(arr_shaDataCtx, ptr_digest, hashAlgo_en);
            }
        }
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_ARG;
    }
    return ret_shaStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_ShaInit(void *ptr_shaCtx_st, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
	int wcShaStatus = BAD_FUNC_ARG;
	
    if(ptr_shaCtx_st != NULL)
    {
        switch(hashAlgo_en)
        {    
<#if (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))>
            case CRYPTO_HASH_SHA1:
                wcShaStatus = wc_InitSha((wc_Sha*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA1 -->	
<#if (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true))>
            case CRYPTO_HASH_SHA2_224:
                wcShaStatus = wc_InitSha224((wc_Sha224*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA2_224 -->		
<#if (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))>
            case CRYPTO_HASH_SHA2_256:
                wcShaStatus = wc_InitSha256((wc_Sha256*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA2_256 -->		               
<#if (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true))>
            case CRYPTO_HASH_SHA2_384:
                wcShaStatus = wc_InitSha384((wc_Sha384*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA2_384 -->	
<#if (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true))>
            case CRYPTO_HASH_SHA2_512:
                wcShaStatus = wc_InitSha512((wc_Sha512*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA2_512 -->	
<#if (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true))>          
            case CRYPTO_HASH_SHA2_512_224:
                wcShaStatus = wc_InitSha512_224((wc_Sha512*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA2_512_224 -->	       
<#if (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true))>                                
            case CRYPTO_HASH_SHA2_512_256:
                wcShaStatus = wc_InitSha512_256((wc_Sha512*)ptr_shaCtx_st);
                break;
</#if><#-- CRYPTO_WC_SHA2_512_256 -->	
<#if (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))>                
            case CRYPTO_HASH_SHA3_224:
                wcShaStatus = wc_InitSha3_224((wc_Sha3*)ptr_shaCtx_st, NULL, INVALID_DEVID);
            break;
</#if><#-- CRYPTO_WC_SHA3_224 -->	            
<#if (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))>            
            case CRYPTO_HASH_SHA3_256:
                wcShaStatus = wc_InitSha3_256((wc_Sha3*)ptr_shaCtx_st, NULL, INVALID_DEVID);
            break;
</#if><#-- CRYPTO_WC_SHA3_256 -->	
<#if (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))>            
            case CRYPTO_HASH_SHA3_384:
                wcShaStatus = wc_InitSha3_384((wc_Sha3*)ptr_shaCtx_st, NULL, INVALID_DEVID);
            break;
</#if><#-- CRYPTO_WC_SHA3_384 -->	
<#if (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>           
            case CRYPTO_HASH_SHA3_512:
                wcShaStatus = wc_InitSha3_512((wc_Sha3*)ptr_shaCtx_st, NULL, INVALID_DEVID);
            break;
</#if><#-- CRYPTO_WC_SHA3_512 -->	         
            default:
                ret_shaStat_en = CRYPTO_HASH_ERROR_ALGO;
                break;
        }

        if(ret_shaStat_en == CRYPTO_HASH_ERROR_ALGO)
        {
            //do nothing
        }
        else if(wcShaStatus == 0)
        {
            ret_shaStat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcShaStatus == BAD_FUNC_ARG)
        {
            ret_shaStat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_CTX;
    }
    return ret_shaStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_ShaUpdate(void *ptr_shaCtx_st, uint8_t *ptr_data, uint32_t dataLen, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcShaStatus = BAD_FUNC_ARG;
	
	switch(hashAlgo_en)
	{
<#if (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))>
		case CRYPTO_HASH_SHA1:
			wcShaStatus = wc_ShaUpdate((wc_Sha*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA1 -->		 
<#if (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true))>
		case CRYPTO_HASH_SHA2_224:
			wcShaStatus = wc_Sha224Update((wc_Sha224*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA2_224 -->	            
<#if (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))>          
		case CRYPTO_HASH_SHA2_256:
			wcShaStatus = wc_Sha256Update((wc_Sha256*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA2_256 -->           
<#if (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true))>
		case CRYPTO_HASH_SHA2_384:
			wcShaStatus = wc_Sha384Update((wc_Sha384*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA2_384 -->	
<#if (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true))>
		case CRYPTO_HASH_SHA2_512:
			wcShaStatus = wc_Sha512Update((wc_Sha512*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;	
</#if><#-- CRYPTO_WC_SHA2_512 -->	
<#if (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true))>            
        case CRYPTO_HASH_SHA2_512_224:
            wcShaStatus = wc_Sha512_224Update((wc_Sha512*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA2_512_224 -->         
<#if (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true))>          
        case CRYPTO_HASH_SHA2_512_256:
            wcShaStatus = wc_Sha512_256Update((wc_Sha512*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;            
</#if><#-- CRYPTO_WC_SHA2_512_256 -->	            
<#if (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))>             
		case CRYPTO_HASH_SHA3_224:
			wcShaStatus = wc_Sha3_224_Update((wc_Sha3*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA3_224 -->	            
<#if (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))>                 
		case CRYPTO_HASH_SHA3_256:
			wcShaStatus = wc_Sha3_256_Update((wc_Sha3*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA3_256 -->	
<#if (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))>              
		case CRYPTO_HASH_SHA3_384:
			wcShaStatus = wc_Sha3_384_Update((wc_Sha3*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA3_384 -->	
<#if (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>              
		case CRYPTO_HASH_SHA3_512:
			wcShaStatus = wc_Sha3_512_Update((wc_Sha3*)ptr_shaCtx_st, (const byte*)ptr_data, (word32)dataLen);
            break;
</#if><#-- CRYPTO_WC_SHA3_512 -->	                        
        default:
            ret_shaStat_en = CRYPTO_HASH_ERROR_ALGO;
            break;
	}

	if(wcShaStatus == 0)
	{
		ret_shaStat_en = CRYPTO_HASH_SUCCESS;
	}
    else if(ret_shaStat_en == CRYPTO_HASH_ERROR_ALGO)
    {
        //do nothing
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    
	return ret_shaStat_en;  
}

crypto_Hash_Status_E Crypto_Hash_Wc_ShaFinal(void *ptr_shaCtx_st, uint8_t *ptr_digest, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shaStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcShaStatus = BAD_FUNC_ARG;
	
	switch(hashAlgo_en)
	{
<#if (CRYPTO_WC_SHA1?? &&(CRYPTO_WC_SHA1 == true))>
		case CRYPTO_HASH_SHA1:
			wcShaStatus = wc_ShaFinal((wc_Sha*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA1 -->		 
<#if (CRYPTO_WC_SHA2_224?? &&(CRYPTO_WC_SHA2_224 == true))>
		case CRYPTO_HASH_SHA2_224:
			wcShaStatus = wc_Sha224Final((wc_Sha224*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA2_224 -->		            
<#if (CRYPTO_WC_SHA2_256?? &&(CRYPTO_WC_SHA2_256 == true))>              
		case CRYPTO_HASH_SHA2_256:
			wcShaStatus = wc_Sha256Final((wc_Sha256*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA2_256 -->           
<#if (CRYPTO_WC_SHA2_384?? &&(CRYPTO_WC_SHA2_384 == true))>
		case CRYPTO_HASH_SHA2_384:
			wcShaStatus = wc_Sha384Final((wc_Sha384*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA2_384 -->	
<#if (CRYPTO_WC_SHA2_512?? &&(CRYPTO_WC_SHA2_512 == true))>
		case CRYPTO_HASH_SHA2_512:
			wcShaStatus = wc_Sha512Final((wc_Sha512*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;	
</#if><#-- CRYPTO_WC_SHA2_512 -->	
<#if (CRYPTO_WC_SHA2_512_224?? &&(CRYPTO_WC_SHA2_512_224 == true))>             
        case CRYPTO_HASH_SHA2_512_224:
            wcShaStatus = wc_Sha512_224Final((wc_Sha512*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA2_512_224 -->	            
<#if (CRYPTO_WC_SHA2_512_256?? &&(CRYPTO_WC_SHA2_512_256 == true))>             
        case CRYPTO_HASH_SHA2_512_256:
            wcShaStatus = wc_Sha512_256Final((wc_Sha512*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA2_512_256 -->	           
<#if (CRYPTO_WC_SHA3_224?? &&(CRYPTO_WC_SHA3_224 == true))>              
		case CRYPTO_HASH_SHA3_224:
			wcShaStatus = wc_Sha3_224_Final((wc_Sha3*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA3_224 -->	            
<#if (CRYPTO_WC_SHA3_256?? &&(CRYPTO_WC_SHA3_256 == true))>             
		case CRYPTO_HASH_SHA3_256:
			wcShaStatus = wc_Sha3_256_Final((wc_Sha3*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA3_256 -->	
<#if (CRYPTO_WC_SHA3_384?? &&(CRYPTO_WC_SHA3_384 == true))>              
		case CRYPTO_HASH_SHA3_384:
			wcShaStatus = wc_Sha3_384_Final((wc_Sha3*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA3_384 -->	
<#if (CRYPTO_WC_SHA3_512?? &&(CRYPTO_WC_SHA3_512 == true))>             
		case CRYPTO_HASH_SHA3_512:
			wcShaStatus = wc_Sha3_512_Final((wc_Sha3*)ptr_shaCtx_st, (byte*)ptr_digest);
            break;
</#if><#-- CRYPTO_WC_SHA3_512 -->       
        default:
            ret_shaStat_en = CRYPTO_HASH_ERROR_ALGO;
            break;
	}

	if(wcShaStatus == 0)
	{
		ret_shaStat_en = CRYPTO_HASH_SUCCESS;
	}
    else if(ret_shaStat_en == CRYPTO_HASH_ERROR_ALGO)
    {
        //do nothing
    }
    else
    {
        ret_shaStat_en = CRYPTO_HASH_ERROR_FAIL;
    }
    
	return ret_shaStat_en;  
}
</#if>
<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true)) || (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>

crypto_Hash_Status_E Crypto_Hash_Wc_ShakeDigest(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_digest, uint32_t digestLen, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;

    if( (ptr_data != NULL) && (dataLen > 0u) && (ptr_digest != NULL) && (digestLen > 0u) )
    {
        wc_Shake ptr_shakeCtx_st[1];
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true))>       
            case CRYPTO_HASH_SHA3_SHAKE128:
                ret_shakeStat_en = Crypto_Hash_Wc_ShakeInit(ptr_shakeCtx_st, CRYPTO_HASH_SHA3_SHAKE128);
                if(ret_shakeStat_en == CRYPTO_HASH_SUCCESS)
                {
                    ret_shakeStat_en = Crypto_Hash_Wc_ShakeUpdate(ptr_shakeCtx_st, ptr_data, dataLen, CRYPTO_HASH_SHA3_SHAKE128);
                    if(ret_shakeStat_en == CRYPTO_HASH_SUCCESS)
                    {
                        ret_shakeStat_en = Crypto_Hash_Wc_ShakeFinal(ptr_shakeCtx_st, ptr_digest, digestLen, CRYPTO_HASH_SHA3_SHAKE128);
                    }
                }
                break;
</#if><#-- CRYPTO_WC_SHAKE_128 -->
<#if (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>      
            case CRYPTO_HASH_SHA3_SHAKE256:
                ret_shakeStat_en = Crypto_Hash_Wc_ShakeInit(ptr_shakeCtx_st, CRYPTO_HASH_SHA3_SHAKE256);
                if(ret_shakeStat_en == CRYPTO_HASH_SUCCESS)
                {
                    ret_shakeStat_en = Crypto_Hash_Wc_ShakeUpdate(ptr_shakeCtx_st, ptr_data, dataLen, CRYPTO_HASH_SHA3_SHAKE256);
                    if(ret_shakeStat_en == CRYPTO_HASH_SUCCESS)
                    {
                        ret_shakeStat_en = Crypto_Hash_Wc_ShakeFinal(ptr_shakeCtx_st, ptr_digest, digestLen, CRYPTO_HASH_SHA3_SHAKE256);
                    }
                }
                break;
</#if><#-- CRYPTO_WC_SHAKE_256 --> 
            default:
                ret_shakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
                break; 
        }
    }
    else
    {
        ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }   
    return ret_shakeStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_ShakeInit(void *ptr_shakeCtx_st, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;    
     int wcShakeStatus = BAD_FUNC_ARG;
    if(ptr_shakeCtx_st != NULL)
    {
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true))>       
            case CRYPTO_HASH_SHA3_SHAKE128:
                wcShakeStatus = wc_InitShake128((wc_Shake*)ptr_shakeCtx_st, NULL, INVALID_DEVID);
                break;
</#if><#-- CRYPTO_WC_SHAKE_128 -->
<#if (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>           
            case CRYPTO_HASH_SHA3_SHAKE256:
                wcShakeStatus = wc_InitShake256((wc_Shake*)ptr_shakeCtx_st, NULL, INVALID_DEVID);
                break;
</#if><#-- CRYPTO_WC_SHAKE_256 -->  
            default:
                ret_shakeStat_en = CRYPTO_HASH_ERROR_ALGO;
                break; 
        }
        
        if(ret_shakeStat_en != CRYPTO_HASH_ERROR_ALGO)
        {
            if(wcShakeStatus == 0)
            {
                ret_shakeStat_en = CRYPTO_HASH_SUCCESS;
            }
            else if (wcShakeStatus == BAD_FUNC_ARG)
            {
                ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
            }
            else
            {
                ret_shakeStat_en = CRYPTO_HASH_ERROR_FAIL;
            }
        }
    }
    else
    {
        ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }   
    return ret_shakeStat_en;
}          

crypto_Hash_Status_E Crypto_Hash_Wc_ShakeUpdate(void *ptr_shakeCtx_st, uint8_t *ptr_data, uint32_t dataLen, crypto_Hash_Algo_E hashAlgo_en)
{
    crypto_Hash_Status_E ret_shakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcShakeStatus = BAD_FUNC_ARG;
    if( (ptr_shakeCtx_st != NULL) && (ptr_data != NULL) && (dataLen > 0u) )
    {
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true))>      
            case CRYPTO_HASH_SHA3_SHAKE128:
                wcShakeStatus = wc_Shake128_Update((wc_Shake*)ptr_shakeCtx_st, (const byte*)ptr_data, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_SHAKE_128 --> 
<#if (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>           
            case CRYPTO_HASH_SHA3_SHAKE256:
                wcShakeStatus = wc_Shake256_Update((wc_Shake*)ptr_shakeCtx_st, (const byte*)ptr_data, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_SHAKE_256 --> 
            default:
                ret_shakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
                break; 
        }

        if(wcShakeStatus == 0)
        {
            ret_shakeStat_en = CRYPTO_HASH_SUCCESS;
        }
        else if (wcShakeStatus == BAD_FUNC_ARG)
        {
            ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
        }
        else
        {
            ret_shakeStat_en = CRYPTO_HASH_ERROR_FAIL;
        }
    }
    else
    {
        ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }  
    return ret_shakeStat_en;
} 

crypto_Hash_Status_E Crypto_Hash_Wc_ShakeFinal(void *ptr_shakeCtx_st, uint8_t *ptr_digest, uint32_t digestLen, crypto_Hash_Algo_E hashAlgo_en)
{
   crypto_Hash_Status_E ret_shakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcShakeStatus = BAD_FUNC_ARG;	
    if( (ptr_shakeCtx_st != NULL) && (ptr_digest != NULL) )
    {
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_SHAKE_128?? &&(CRYPTO_WC_SHAKE_128 == true))>    
            case CRYPTO_HASH_SHA3_SHAKE128:
                wcShakeStatus = wc_Shake128_Final((wc_Shake*)ptr_shakeCtx_st, ptr_digest, digestLen);
                break;
</#if><#-- CRYPTO_WC_SHAKE_128 --> 
<#if (CRYPTO_WC_SHAKE_256?? &&(CRYPTO_WC_SHAKE_256 == true))>           
            case CRYPTO_HASH_SHA3_SHAKE256:
                wcShakeStatus = wc_Shake256_Final((wc_Shake*)ptr_shakeCtx_st, ptr_digest, digestLen);
                break;
</#if><#-- CRYPTO_WC_SHAKE_256 -->  
            default:
                ret_shakeStat_en = CRYPTO_HASH_ERROR_ALGO;
                break; 
        }
        
        if(ret_shakeStat_en != CRYPTO_HASH_ERROR_ALGO)
        {
            if(wcShakeStatus == 0)
            {
                ret_shakeStat_en = CRYPTO_HASH_SUCCESS;
            }
            else if (wcShakeStatus == BAD_FUNC_ARG)
            {
                ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
            }
            else
            {
                ret_shakeStat_en = CRYPTO_HASH_ERROR_FAIL;
            }
        }
        else
        {
            //do nothing
        }
    }
    else
    {
        ret_shakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }  
    return ret_shakeStat_en;
} 
</#if><#-- CRYPTO_WC_SHAKE_128 || CRYPTO_WC_SHAKE_256 -->
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true)) || (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))>

crypto_Hash_Status_E Crypto_Hash_Wc_BlakeDigest(uint8_t *ptr_data, uint32_t dataLen, 
                                                uint8_t *ptr_blakeKey, uint32_t keySize, uint8_t *ptr_digest, uint32_t digestLen, crypto_Hash_Algo_E blakeAlgorithm_en)
{   
    crypto_Hash_Status_E ret_blakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;   

	if( (ptr_data != NULL) && (dataLen > 0u) && (ptr_digest != NULL) && (digestLen > 0u) )
    {
<#if (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))>      
        if(blakeAlgorithm_en == CRYPTO_HASH_BLAKE2B)
        {
            Blake2b arr_blakeCtx_st[1];

            ret_blakeStat_en =  Crypto_Hash_Wc_BlakeInit((void *)arr_blakeCtx_st, CRYPTO_HASH_BLAKE2B, ptr_blakeKey, keySize, digestLen); 

            if(ret_blakeStat_en == CRYPTO_HASH_SUCCESS)
            {
                ret_blakeStat_en =  Crypto_Hash_Wc_BlakeUpdate((void *)arr_blakeCtx_st, ptr_data, dataLen, CRYPTO_HASH_BLAKE2B);

                if(ret_blakeStat_en == CRYPTO_HASH_SUCCESS)
                {
                  ret_blakeStat_en =  Crypto_Hash_Wc_BlakeFinal((void *)arr_blakeCtx_st, ptr_digest, digestLen, CRYPTO_HASH_BLAKE2B);  
                }  
            }
        }
</#if><#-- CRYPTO_WC_BLAKE2B -->        
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true))> 
        if(blakeAlgorithm_en == CRYPTO_HASH_BLAKE2S)
        {
            Blake2s arr_blakeCtx_st[1];

            ret_blakeStat_en =  Crypto_Hash_Wc_BlakeInit((void *)arr_blakeCtx_st, CRYPTO_HASH_BLAKE2S, ptr_blakeKey, keySize, digestLen); 

            if(ret_blakeStat_en == CRYPTO_HASH_SUCCESS)
            {
                ret_blakeStat_en =  Crypto_Hash_Wc_BlakeUpdate((void *)arr_blakeCtx_st, ptr_data, dataLen, CRYPTO_HASH_BLAKE2S);

                if(ret_blakeStat_en == CRYPTO_HASH_SUCCESS)
                {
                  ret_blakeStat_en =  Crypto_Hash_Wc_BlakeFinal((void *)arr_blakeCtx_st, ptr_digest, digestLen, CRYPTO_HASH_BLAKE2S);  
                }  
            }
        }
</#if><#-- CRYPTO_WC_BLAKE2S -->
    }
    else
    {
        ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }   
    return ret_blakeStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_BlakeInit(void *ptr_blakeCtx_st, crypto_Hash_Algo_E hashAlgo_en, uint8_t *ptr_blakeKey, uint32_t keySize, uint32_t digestLen)        
{	   
    crypto_Hash_Status_E ret_blakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcBlakeStatus = BAD_FUNC_ARG;
	if(ptr_blakeCtx_st != NULL)
    {
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))> 
            case CRYPTO_HASH_BLAKE2B:
                if( (ptr_blakeKey != NULL) && (keySize != 0u) )
                {
                    wcBlakeStatus = wc_InitBlake2b_WithKey((Blake2b*)ptr_blakeCtx_st, digestLen, ptr_blakeKey, keySize);
                }
                else
                {
                    wcBlakeStatus = wc_InitBlake2b((Blake2b*)ptr_blakeCtx_st, digestLen);
                }
                break;
</#if><#-- CRYPTO_WC_BLAKE2B -->                
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true))> 
            case CRYPTO_HASH_BLAKE2S:
                if( (ptr_blakeKey != NULL) && (keySize != 0u) )
                {
                   wcBlakeStatus = wc_InitBlake2s_WithKey((Blake2s*)ptr_blakeCtx_st, digestLen, ptr_blakeKey, keySize); 
                }
                else
                {
                    wcBlakeStatus = wc_InitBlake2s((Blake2s*)ptr_blakeCtx_st, digestLen); 
                }
                break;
</#if><#-- CRYPTO_WC_BLAKE2S -->
            default:
                ret_blakeStat_en = CRYPTO_HASH_ERROR_ALGO;
                break;
        }
        
        if(ret_blakeStat_en != CRYPTO_HASH_ERROR_ALGO)
        {
            if(wcBlakeStatus == 0)
            {
                 ret_blakeStat_en = CRYPTO_HASH_SUCCESS;
            }
            else if (wcBlakeStatus == BAD_FUNC_ARG)
            {
                ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
            }
            else
            {
                ret_blakeStat_en = CRYPTO_HASH_ERROR_FAIL;
            }
        }
        else
        {
            //do nothing
        }
    }
    else
    {
        ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }   
    return ret_blakeStat_en;
}

crypto_Hash_Status_E Crypto_Hash_Wc_BlakeUpdate(void *ptr_blakeCtx_st, uint8_t *ptr_data, uint32_t dataLen, crypto_Hash_Algo_E hashAlgo_en)
{   
    crypto_Hash_Status_E ret_blakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcBlakeStatus = BAD_FUNC_ARG;
	if(ptr_blakeCtx_st != NULL)
    {
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))> 
            case CRYPTO_HASH_BLAKE2B:
                wcBlakeStatus = wc_Blake2bUpdate((Blake2b*)ptr_blakeCtx_st, (const byte*)ptr_data, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_BLAKE2B -->                    
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true))> 
            case CRYPTO_HASH_BLAKE2S:
                
                wcBlakeStatus = wc_Blake2sUpdate((Blake2s*)ptr_blakeCtx_st, (const byte*)ptr_data, (word32)dataLen);
                break;
</#if><#-- CRYPTO_WC_BLAKE2S -->  
            default:
                ret_blakeStat_en = CRYPTO_HASH_ERROR_ALGO;
                break;
        }
        
        if(ret_blakeStat_en != CRYPTO_HASH_ERROR_ALGO)
        {
            if(wcBlakeStatus == 0)
            {
                 ret_blakeStat_en = CRYPTO_HASH_SUCCESS;
            }
            else if (wcBlakeStatus == BAD_FUNC_ARG)
            {
                ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
            }
            else
            {
                ret_blakeStat_en = CRYPTO_HASH_ERROR_FAIL;
            }
        }
        else
        {
            //do nothing
        }
    }
    else
    {
        ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }    
    return ret_blakeStat_en;       
}

crypto_Hash_Status_E Crypto_Hash_Wc_BlakeFinal(void *ptr_blakeCtx_st, uint8_t *ptr_digest, uint32_t digestLen, crypto_Hash_Algo_E hashAlgo_en)
{   
    crypto_Hash_Status_E ret_blakeStat_en = CRYPTO_HASH_ERROR_NOTSUPPTED;
    int wcBlakeStatus = BAD_FUNC_ARG;
	if(ptr_blakeCtx_st != NULL)
    {
        switch(hashAlgo_en)
        {
<#if (CRYPTO_WC_BLAKE2B?? &&(CRYPTO_WC_BLAKE2B == true))> 
            case CRYPTO_HASH_BLAKE2B:
                wcBlakeStatus = wc_Blake2bFinal((Blake2b*)ptr_blakeCtx_st, (byte*)ptr_digest, (word32)digestLen);
                break;
</#if><#-- CRYPTO_WC_BLAKE2B -->                   
<#if (CRYPTO_WC_BLAKE2S?? &&(CRYPTO_WC_BLAKE2S == true))> 
            case CRYPTO_HASH_BLAKE2S:
                
                wcBlakeStatus = wc_Blake2sFinal((Blake2s*)ptr_blakeCtx_st, (byte*)ptr_digest, (word32)digestLen);
                break;
</#if><#-- CRYPTO_WC_BLAKE2S --> 
            default:
                ret_blakeStat_en = CRYPTO_HASH_ERROR_ALGO;
                break;
        }
        
        if(ret_blakeStat_en != CRYPTO_HASH_ERROR_ALGO)
        {
            if(wcBlakeStatus == 0)
            {
                 ret_blakeStat_en = CRYPTO_HASH_SUCCESS;
            }
            else if (wcBlakeStatus == BAD_FUNC_ARG)
            {
                ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
            }
            else
            {
                ret_blakeStat_en = CRYPTO_HASH_ERROR_FAIL;
            }
        }
        else
        {
            //do nothing
        }
    }
    else
    {
        ret_blakeStat_en = CRYPTO_HASH_ERROR_ARG;
    }   
    return ret_blakeStat_en;       
}
</#if><#-- CRYPTO_WC_BLAKE2S || CRYPTO_WC_BLAKE2B -->
