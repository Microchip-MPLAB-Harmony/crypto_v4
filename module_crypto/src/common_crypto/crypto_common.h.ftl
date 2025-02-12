/*******************************************************************************
  MPLAB Harmony Application Header File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_common.h

  Summary:
    This header file provides prototypes and definitions for the application.

  Description:
    This header file provides function prototypes and data type definitions for
    the application.  Some of these are required by the system (such as the
    "APP_Initialize" and "APP_Tasks" prototypes) and some of them are only used
    internally by the application (such as the "APP_STATES" definition).  Both
    are defined here for convenience.
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

#ifndef CRYPTO_COMMON_H
#define CRYPTO_COMMON_H


// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
<#if lib_wolfcrypt??>
#include "crypto/wolfcrypt/wolfcrypt_config.h"
</#if>
//******************************************************************************
#define CRYPTO_ECC_MAX_KEY_LENGTH (66) //Max size of Private key; Public Key will be double of it for ECC

// *****************************************************************************
// *****************************************************************************
// Section: Type Definitions
// *****************************************************************************
// *****************************************************************************
typedef enum {
	CRYPTO_HANDLER_INVALID = 0,
	CRYPTO_HANDLER_HW_INTERNAL = 1,     //Enum used when HW crypto engine is used
#ifdef CRYPTO_WOLFCRYPT_SUPPORT_ENABLE            
	CRYPTO_HANDLER_SW_WOLFCRYPT = 2,    //Enum used when SW library Wolfssl is used
#endif /* CRYPTO_WOLFCRYPT_SUPPORTED */            
	CRYPTO_HANDLER_EXTERNAL_TA100 = 3,  //When external TA100 used for crypto
	CRYPTO_HANDLER_EXTERNAL_ECC508 = 4, //When external ECC508 used for crypto
	CRYPTO_HANDLER_MAX
}crypto_HandlerType_E;

<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM == true))) 
		|| (CRYPTO_HW_AES_GCM?? &&(CRYPTO_HW_AES_GCM == true))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true))) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true))) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true))) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true))) || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true))) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true))) 
		|| (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))     || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
		|| (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))   || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))   
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true))) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true))) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CMAC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CMAC == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GMAC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GMAC == true)))
		|| (lib_wolfcrypt?? &&((lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true))))
		|| (lib_wolfcrypt?? &&((lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true))))>
//This needs to be taken care when no using any AES algorithm variant
typedef enum
{
    CRYPTO_AESKEYSIZE_128 = 16, //Enum used for AES key size of 128 bits
    CRYPTO_AESKEYSIZE_192 = 24, //Enum used for AES key size of 192 bits
    CRYPTO_AESKEYSIZE_256 = 32  //Enum used for AES key size of 256 bits        
}crypto_AesKeySize_E;
</#if>
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CCM == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM?? &&(lib_wolfcrypt.CRYPTO_WC_AES_GCM == true))) 
		|| (CRYPTO_HW_AES_GCM?? &&(CRYPTO_HW_AES_GCM == true))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX?? &&(lib_wolfcrypt.CRYPTO_WC_AES_EAX == true)))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_ECB == true))) || (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CBC == true))) || (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CTR == true))) || (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB?? &&(lib_wolfcrypt.CRYPTO_WC_AES_OFB == true))) || (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB1 == true))) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB8 == true))) 
		|| (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))     || (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true)) 
		|| (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))   || (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))   
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128?? &&(lib_wolfcrypt.CRYPTO_WC_AES_CFB128 == true))) || (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS?? &&(lib_wolfcrypt.CRYPTO_WC_AES_XTS == true))) || (CRYPTO_HW_AES_XTS?? &&(CRYPTO_HW_AES_XTS == true))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW?? &&(lib_wolfcrypt.CRYPTO_WC_AES_KW == true)))
		|| (lib_wolfcrypt?? &&((lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_ECB == true)) 
			|| (lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_CAMELLIA_CBC == true))))
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_ECB == true))) 
		|| (CRYPTO_HW_TDES_ECB?? &&(CRYPTO_HW_TDES_ECB == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC?? &&(lib_wolfcrypt.CRYPTO_WC_TDES_CBC == true))) 
		|| (CRYPTO_HW_TDES_CBC?? &&(CRYPTO_HW_TDES_CBC == true))>

//This needs to be taken care when no using any Sym or Asym algorithm variant
typedef enum
{
    CRYPTO_CIOP_INVALID = 0,    //INVALID to define Min. range for Enum
    CRYPTO_CIOP_ENCRYPT = 1,    //Enum used for Encryption cipher operation
    CRYPTO_CIOP_DECRYPT = 2,    //Enum used for Decryption cipher operation
    CRYPTO_CIOP_MAX,            //Max. to check Enum value range
}crypto_CipherOper_E;
</#if>
<#if (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDH?? &&(lib_wolfcrypt.CRYPTO_WC_ECDH == true))) 
		|| (CRYPTO_HW_ECDH?? &&(CRYPTO_HW_ECDH == true))
		|| (CRYPTO_HW_ECDSA?? &&(CRYPTO_HW_ECDSA == true)) 
		|| (lib_wolfcrypt?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA?? &&(lib_wolfcrypt.CRYPTO_WC_ECDSA == true)))>

/* Curve Types */
typedef enum 
{
    CRYPTO_ECC_CURVE_INVALID = 0,

    /* Prime Curves */
    
    //Weierstrass Curves
    CRYPTO_ECC_CURVE_P192 = 1,        
    CRYPTO_ECC_CURVE_SECP192R1 = 1, //also called as NIST P-192 or prime192v1 
    
    CRYPTO_ECC_CURVE_P224 = 2,
    CRYPTO_ECC_CURVE_SECP224R1 = 2,
     
    CRYPTO_ECC_CURVE_P256 = 3,        
    CRYPTO_ECC_CURVE_SECP256R1 = 3, //also called as NIST P-256 or prime256v1

    CRYPTO_ECC_CURVE_P384 = 4,
    CRYPTO_ECC_CURVE_SECP384R1 = 4, //also called as NIST P-384
            
    CRYPTO_ECC_CURVE_P521 = 5,
    CRYPTO_ECC_CURVE_SECP521R1 = 5,        
          
    /* Twisted Edwards Curves */

    CRYPTO_ECC_CURVE_MAX
}crypto_EccCurveType_E;
</#if>

// *****************************************************************************
#endif //CRYPTO_COMMON_H
