/*******************************************************************************
  Secure Project System Configuration Header

  File Name:
    wolfcrypt_config.h

  Summary:
    Build-time configuration header for the TrustZone secure system defined by 
    this project.

  Description:
    An MPLAB Project may have multiple configurations.  This file defines the
    build-time options for a single configuration.

  Remarks:
    This configuration header must not define any prototypes or data
    definitions (or include any files that do).  It only provides macro
    definitions for build-time configuration options

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

#ifndef WOLFCRYPT_CONFIG_H
#define WOLFCRYPT_CONFIG_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

//#include "user.h"
#include "device.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

extern "C" {

#endif
// DOM-IGNORE-END

/*** Crypto Library Configuration ***/

//Crypto V4 Common Crypto API - WolfCrypt Library Support
<#lt>#define CRYPTO_WOLFCRYPT_SUPPORT_ENABLE

//JK
#define CRYPTO_DIGISIGN_ALGO_EN
#define CRYPTO_KAS_ALGO_EN    

<#lt>/*** wolfCrypt Library Configuration ***/
<#lt>
<#lt>//configuration.h included in config.h and user_settings.h allowing these
<#lt>//files to configure WolfSSL library
<#lt>//--WolfSSL project defines to use these files are WOLFSSL_USER_SETTINGS and
<#lt>//  HAVE_CONFIG_H

// ---------- WOLFCRYPT FUNCTIONAL CONFIGURATION START ----------

<#lt>#define MICROCHIP_PIC32
<#lt>#define MICROCHIP_MPLAB_HARMONY
<#lt>#define MICROCHIP_MPLAB_HARMONY_3
<#lt>#define HAVE_MCAPI 

<#lt>#define SIZEOF_LONG_LONG 8
<#lt>#define WOLFSSL_USER_IO
<#lt>#define NO_WRITEV
<#lt>#define NO_FILESYSTEM
<#lt>#define USE_FAST_MATH  //Conflicts with WOLFSSL_SP_MATH
<#lt>#define NO_INLINE 

<#lt>//Math Model Defines
<#lt>//Using this to declare wolfmath functions:
<#lt>//mp_reverse used by fp_to_unsigned_bin (tfm.c)unctions: 
<#lt>//get_digit_count,get_digit in ecc.c 
<#lt>#define WOLFSSL_SP_MATH   

//Needed when WOFSSL_SP_MATH defined
<#lt>//#define WOLFSSL_HAVE_SP_RSA  
<#lt>//#define WOLFSSL_HAVE_SP_DH

<#lt>//To prevent usage of SP functions defined by this: 
<#lt>//#if defined(HAVE_FIPS_VERSION) && HAVE_FIPS_VERSION == 2 
<#lt>//&& ( defined(WOLFSSL_SP_ARM32_ASM) || defined(WOLFSSL_SP_ARM64_ASM) ) 
<#lt>//#define WOLFSSL_SP_NO_256   
<#lt>#define WOLFSSL_SP_384   

<#lt>//#define WOLFSSL_SP_ARM32_ASM   //Dependent on MCU Arch.

<#lt>#define WOLFSSL_SP_MATH_ALL   //JK
<#lt>#define WOLFSSL_HAVE_SP_ECC  //JK

<#lt>#define WOLFSSL_SP_NO_MALLOC //JK
<#lt>#define WOLFSSL_SP_SMALL     //JK
<#lt>#define WOLFSSL_SP_NONBLOCK  //JK
<#lt>#define WC_ECC_NONBLOCK      //JK

<#lt>#define NO_PWDBASED
<#lt>//#define WOLF_CRYPTO_CB     //Provide call-back support 
<#lt>#define WOLFCRYPT_ONLY
<#lt>#define HAVE_COMP_KEY        //JK 

<#lt>#define WOLFSSL_AES_SMALL_TABLES
<#lt>#define NO_MD4
<#lt>#define WOLFSSL_SHA224
<#lt>#define WOLFSSL_SHA384
<#lt>#define WOLFSSL_SHA512
<#lt>#define HAVE_SHA512
<#lt>#define WOLFSSL_SHA3
<#lt>#define HAVE_BLAKE2
<#lt>#define WOLFSSL_RIPEMD
<#lt>//#define NO_HMAC            //JK
<#lt>#define WOLFSSL_AES_128
<#lt>#define WOLFSSL_AES_192
<#lt>#define WOLFSSL_AES_256
<#lt>#define WOLFSSL_AES_DIRECT
<#lt>#define HAVE_AES_DECRYPT
<#lt>#define HAVE_AES_ECB
<#lt>#define HAVE_AES_CBC
<#lt>#define WOLFSSL_AES_COUNTER
<#lt>#define WOLFSSL_AES_CFB
<#lt>#define WOLFSSL_AES_OFB
<#lt>#define HAVE_AESGCM
<#lt>#define WOLFSSL_AES_XTS
<#lt>#define HAVE_AESCCM
<#lt>#define WOLFSSL_CMAC
<#lt>#define WOLFSSL_DES_ECB
<#lt>#define HAVE_CAMELLIA
<#lt>#define HAVE_IDEA
<#lt>#define HAVE_HC128
<#lt>#define HAVE_RABBIT

<#lt>#define HAVE_ECC
<#lt>//#define HAVE_ECC_KEY_EXPORT //JK //Required for WOLFCRYPT_HAVE_ECCSI
<#lt>#define HAVE_X963_KDF
<#lt>#define ECC_SHAMIR
<#lt>#define WOLFSSL_CUSTOM_CURVES
<#lt>//#define HAVE_CURVE25519     //JK 
<#lt>//#define HAVE_ED25519        //JK
<#lt>#define FP_ECC
<#lt>#define HAVE_ECC521           //ECC_MAX_BITS

<#lt>//#define HAVE_DH
<#lt>//#define WOLFSSL_HAVE_SP_DH
    
<#lt>#define HAVE_ANON
<#lt>#define WOLFSSL_OLD_PRIME_CHECK
<#lt>#define NO_DSA
<#lt>#define FP_MAX_BITS 4096
<#lt>#define USE_CERT_BUFFERS_2048
<#lt>//#define WOLFSSL_RSA_PUBLIC_ONLY  //JK //Conflict with WOLFSSL_HAVE_SP_DH
<#lt>//#define WC_RSA_PSS               //JK
<#lt>//#define WOLFSSL_STATIC_RSA       //JK
<#lt>#define NO_DEV_RANDOM
<#lt>#define HAVE_HASHDRBG
<#lt>#define WC_NO_HARDEN
<#lt>#define SINGLE_THREADED
<#lt>#define NO_ERROR_STRINGS
<#lt>#define NO_WOLFSSL_MEMORY

<#lt>//********************************************************
<#lt>//#define WOLFSSL_SHAKE128  //Manually Commented, Not supported by Wolfcrypt
<#lt>#define WOLFSSL_SHAKE256 
<#lt>#define HAVE_BLAKE2S    
<#lt>#define HAVE_BLAKE2B   
<#lt>#define HAVE_CHACHA      
<#lt>#define HAVE_AES_KEYWRAP
<#lt>#define HAVE_ECC_DHE   
<#lt>//#define WOLFCRYPT_HAVE_ECCSI  //JK
<#lt>#define WOLFSSL_AES_EAX 
<#lt>#define WOLFSSL_AESGCM_STREAM
<#lt>//*********************************************************
<#lt>int Crypto_Rng_Wc_Prng_EntropySource(void); //User-modifiable entropy for PRNG 
<#lt>int Crypto_Rng_Wc_Prng_Srand(uint8_t* output, unsigned int sz);

<#lt>//*********************************************************
<#lt>#define CUSTOM_RAND_GENERATE_SEED Crypto_Rng_Wc_Prng_Srand
<#lt>//#define WC_NO_RNG //when using RNG
<#lt>//#define WC_NO_HASHDRBG
<#lt>//#define HAVE_ECC_ENCRYPT
<#lt>#define NO_RSA                 //JK
<#lt>#define NO_DH                  //JK
<#lt>//#define NO_SIG_WRAPPER
<#lt>//**********************************************************

<#lt>// ---------- WOLFCRYPT CONFIGURATION END ----------

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif // WOLFCRYPT_CONFIG_H
/*******************************************************************************
 End of File
*/
