/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_aes_hw_6149.h

  Summary:
    Crypto Framework Libarary interface file for hardware AES.

  Description:
    This header file contains the interface that make up the AES hardware 
    driver for the following families of Microchip microcontrollers:
    PIC32CXMTxx, SAMx70, SAMA5D2, SAM9X60, SAMA7D65.
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

#ifndef DRV_CRYPTO_AES_HW_6149_H
#define DRV_CRYPTO_AES_HW_6149_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "device.h"

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

typedef enum  {
    CRYPTO_AES_DECRYPTION = 0, /* Decryption of data will be performed */
    CRYPTO_AES_ENCRYPTION,     /* Encryption of data will be performed */
} CRYPTO_AES_CIPHER_MODE;

typedef enum  {
    CRYPTO_AES_KEY_SIZE_128 = 0,
    CRYPTO_AES_KEY_SIZE_192,
    CRYPTO_AES_KEY_SIZE_256,    
} CRYPTO_AES_KEY_SIZE;

typedef enum {
    CRYPTO_AES_MANUAL_START = 0,  /* Manual start mode */
    CRYPTO_AES_AUTO_START,        /* Auto start mode */
    CRYPTO_AES_IDATAR0_START      /* AES_IDATAR0 access only Auto Mode */
} CRYPTO_AES_START_MODE;

typedef enum {
    CRYPTO_AES_MODE_ECB = 0,       /* Electronic Codebook (ECB) */
    CRYPTO_AES_MODE_CBC,           /* Cipher Block Chaining (CBC) */
    CRYPTO_AES_MODE_OFB,           /* Output Feedback (OFB) */
    CRYPTO_AES_MODE_CFB,           /* Cipher Feedback (CFB) */
    CRYPTO_AES_MODE_CTR,           /* Counter (CTR) */
    CRYPTO_AES_MODE_GCM,           /* Galois Counter Mode (GCM) */
<#if __PROCESSOR?matches("SAMA7D65.*")>
    CRYPTO_AES_MODE_XTS,           /* XEX-based tweaked-codebook mode (XTS) */
</#if>
} CRYPTO_AES_OPERATION_MODE;

typedef enum  {
    CRYPTO_AES_CFB_SIZE_128BIT = 0,   /* Cipher feedback data size is 128-bit */
    CRYPTO_AES_CFB_SIZE_64BIT,        /* Cipher feedback data size is 64-bit */
    CRYPTO_AES_CFB_SIZE_32BIT,        /* Cipher feedback data size is 32-bit */
    CRYPTO_AES_CFB_SIZE_16BIT,        /* Cipher feedback data size is 16-bit */
    CRYPTO_AES_CFB_SIZE_8BIT,         /* Cipher feedback data size is 8-bit */
} CRYPTO_AES_CFB_SIZE;

<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
typedef enum {
    CRYPTO_AES_ALGORITHM_AES = 0,  /* AES algorithm used for encryption */
    CRYPTO_AES_ALGORITHM_ARIA,     /* ARIA algorithm used for encryption */
} CRYPTO_AES_ALGORITHM;
</#if>

<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
typedef enum {
    CRYPTO_AES_KEY_FIRST = 0,  /* First key loaded by software */
    CRYPTO_AES_KEY_SECOND,     /* Second key loaded by software */
} CRYPTO_AES_KEY_SELECTION;

typedef enum {
    CRYPTO_AES_PRIVATE_KEY_KEYWR = 0,   /* AES key in KEYWRx registers */
    CRYPTO_AES_PRIVATE_KEY_INTERNAL,    /* AES key in key internal register */
} CRYPTO_AES_PRIVATE_KEY_SELECTION;

typedef enum {
    CRYPTO_AES_AUTO_PADDING_IPSEC = 0, /* AES auto padding according to IPSEC standard */
    CRYPTO_AES_AUTO_PADDING_SSL,       /* AES auto padding according to SSL standard */
} CRYPTO_AES_AUTO_PADDING_MODE;

typedef enum {
    CRYPTO_AES_PLIP_CIPHER = 0,  /* Protocol layer improved performance is in ciphering mode */
    CRYPTO_AES_PLIP_DECIPHER,    /* Protocol layer improved performance is in deciphering mode */
} CRYPTO_AES_PLIP;
</#if>

/* MISRA C-2012 deviation block start */
/* MISRA C-2012 Rule 6.1 deviated: 43. Deviation record ID - H3_MISRAC_2012_R_6_1_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"
</#if>

typedef union {
    struct {
        uint8_t START : 1;
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
        uint8_t KSWP : 1;
        uint8_t : 6;
<#else>
        uint8_t : 7;
</#if>
        uint8_t SWRST : 1;
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
        uint16_t : 15;
        uint8_t UNLOCK : 1;
        uint8_t : 7;
<#else>
        uint32_t : 23;
</#if>
    } s;
    uint32_t v;
} CRYPTO_AES_CR;

typedef union {
    struct {
        CRYPTO_AES_CIPHER_MODE CIPHER : 1;
        uint8_t GTAGEN : 1;
        uint8_t : 1;
        uint8_t DUALBUFF : 1;
        CRYPTO_AES_KEY_SIZE PROCDLY : 4;
        CRYPTO_AES_START_MODE SMOD : 2;
        CRYPTO_AES_KEY_SIZE KEYSIZE : 2;
        CRYPTO_AES_OPERATION_MODE OPMODE : 3;
        uint8_t LOD : 1;
        CRYPTO_AES_CFB_SIZE CFBS : 3;
        uint8_t : 1;
        uint8_t CKEY : 4;
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
        uint8_t : 7;
        uint8_t TAMPCLR;
<#else>
        uint8_t : 8;
</#if>
    } s;
    uint32_t v;
} CRYPTO_AES_MR;

<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
typedef union {
    struct {
        uint8_t APEN : 1;
        CRYPTO_AES_AUTO_PADDING_MODE APM : 1;
        CRYPTO_AES_KEY_SELECTION KSEL : 1;
        uint8_t : 1;
        uint8_t PLIPEN : 1;
        CRYPTO_AES_PLIP PLIPD : 4;
        uint8_t PKWL : 2;
        CRYPTO_AES_PRIVATE_KEY_SELECTION PKRS : 2;
        uint8_t PADLEN;
        uint8_t NHEAD;
<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
        CRYPTO_AES_ALGORITHM ALGO : 1;
<#else>
        uint8_t : 1;
</#if>
        uint8_t : 6;
        uint8_t BPE : 4;
    } s;
    uint32_t v;
} CRYPTO_AES_EMR;
</#if>

typedef union {
    struct {
        uint8_t DATRDY : 1;
<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
        uint8_t ENDRX : 1;
        uint8_t ENDTX : 1;
        uint8_t RXBUFF : 1;
        uint8_t TXBUFE : 1;
        uint8_t : 3;
<#else>
        uint8_t : 7;
</#if>
        uint8_t URAD : 1;
        uint8_t : 7;
        uint8_t TAGRDY : 1;
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
        uint8_t EOPAD : 1;
        uint8_t PLENERR : 1;
        uint8_t SECE : 1;
        uint16_t : 12;
<#else>
        uint16_t : 15;
</#if>
    } s;
    uint32_t v;
} CRYPTO_AES_IER;

<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
/* MISRAC 2012 deviation block end */

typedef CRYPTO_AES_IER CRYPTO_AES_IDR;
typedef CRYPTO_AES_IER CRYPTO_AES_IMR;

typedef enum 
{
    CRYPTO_AES_IDR_WR_PROCESSING = 0,
    CRYPTO_AES_ODR_RD_PROCESSING,
    CRYPTO_AES_MR_WR_PROCESSING,
    CRYPTO_AES_ODR_RD_SUBKGEN,
    CRYPTO_AES_MR_WR_SUBKGEN,
    CRYPTO_AES_WOR_RD_ACCESS,
} CRYPTO_AES_URAT;

/* MISRA C-2012 deviation block start */
/* MISRA C-2012 Rule 6.1 deviated: 14. Deviation record ID - H3_MISRAC_2012_R_6_1_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"
</#if>

typedef union {    
    struct {
        uint8_t DATRDY : 1;
<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
        uint8_t ENDRX : 1;
        uint8_t ENDTX : 1;
        uint8_t RXBUFF : 1;
        uint8_t TXBUFE : 1;
        uint8_t : 3;
<#else>
        uint8_t : 7;
</#if>
        uint8_t URAD : 1;
        uint8_t : 3;
        CRYPTO_AES_URAT URAT : 4;
        uint8_t TAGRDY : 1;
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
        uint8_t EOPAD : 1;
        uint8_t PLENERR : 1;
        uint8_t SECE : 1;
        uint16_t : 12;
<#else>
        uint16_t : 15;
</#if>
    }s;
    uint32_t v;
} CRYPTO_AES_ISR;

<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
/* MISRAC 2012 deviation block end */

/* AES Configuration structure */
typedef struct {
	/* AES data mode (decryption or encryption) */
    CRYPTO_AES_CIPHER_MODE encryptMode;
	/* AES key size */
    CRYPTO_AES_KEY_SIZE keySize;
	/* Start mode */
	CRYPTO_AES_START_MODE startMode;
	/* AES block cipher operation mode */
	CRYPTO_AES_OPERATION_MODE opMode;
	/* Cipher feedback data size */
    CRYPTO_AES_CFB_SIZE cfbSize;
	/* Last output data mode enable/disable */
	bool lod;
	/* Galois Counter Mode (GCM) automatic tag generation enable/disable */
	bool gtagEn;
	/* Processing delay parameter */
	uint32_t processingDelay;
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
	/* Tamper clear enable */
	bool tampclr;
	/* Block processing end */
	bool bpe;
<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
	/* Encryption algorithm */
	CRYPTO_AES_ALGORITHM algo;
</#if>
    /* Auto padding enable/disable */
	bool apen;
	/* Auto padding mode */
	CRYPTO_AES_AUTO_PADDING_MODE apm;
	/* Auto padding length */
	uint8_t padLen;
	/* IPSEC next header */
	uint8_t nhead;
</#if>
} CRYPTO_AES_CONFIG;

// *****************************************************************************
// *****************************************************************************
// Section: AES Common Interface 
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_AES_GetConfigDefault(CRYPTO_AES_CONFIG *aesCfg);

void DRV_CRYPTO_AES_Init(void);

void DRV_CRYPTO_AES_SetConfig(CRYPTO_AES_CONFIG *aesCfg);

CRYPTO_AES_KEY_SIZE DRV_CRYPTO_AES_GetKeySize(uint32_t keyLen); 

void DRV_CRYPTO_AES_WriteKey(const uint32_t *key);

void DRV_CRYPTO_AES_WriteInitVector(const uint32_t *iv);

void DRV_CRYPTO_AES_WriteInputData(const uint32_t *inputDataBuffer);

void DRV_CRYPTO_AES_ReadOutputData(uint32_t *outputDataBuffer);

void DRV_CRYPTO_AES_ReadTag(uint32_t *tagBuffer);

void DRV_CRYPTO_AES_WriteAuthDataLen(uint32_t length);

void DRV_CRYPTO_AES_WritePCTextLen(uint32_t length);

bool DRV_CRYPTO_AES_CipherIsReady(void);

bool DRV_CRYPTO_AES_TagIsReady(void);

void DRV_CRYPTO_AES_ReadGcmHash(uint32_t *ghashBuffer);

void DRV_CRYPTO_AES_WriteGcmHash(uint32_t *ghashBuffer);

void DRV_CRYPTO_AES_ReadGcmH(uint32_t *hBuffer);

<#if __PROCESSOR?matches("SAMA7D65.*")>
void DRV_CRYPTO_AES_WriteTweak(const uint32_t *tweakBuffer);

void DRV_CRYPTO_AES_WriteAlpha(const uint32_t *alphaBuffer);
</#if>

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* DRV_CRYPTO_AES_HW_6149_H */
