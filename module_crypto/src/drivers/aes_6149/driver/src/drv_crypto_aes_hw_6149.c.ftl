/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_aes_hw_6149.c

  Summary:
    Crypto Framework Library source file for hardware AES.

  Description:
    This source file contains the functions that make up the AES hardware 
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "definitions.h"
#include "../drv_crypto_aes_hw_6149.h"

// *****************************************************************************
// *****************************************************************************
// Section: AES Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

void DRV_CRYPTO_AES_GetConfigDefault(CRYPTO_AES_CONFIG *aesCfg)
{
	/* Default configuration values */
	aesCfg->encryptMode = CRYPTO_AES_DECRYPTION;
	aesCfg->keySize = CRYPTO_AES_KEY_SIZE_128;
	aesCfg->startMode = CRYPTO_AES_MANUAL_START;
	aesCfg->opMode = CRYPTO_AES_MODE_ECB;
	aesCfg->cfbSize = CRYPTO_AES_CFB_SIZE_128BIT;
	aesCfg->lod = false;
	aesCfg->gtagEn = false;
	aesCfg->processingDelay = 0;

<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
    aesCfg->algo = CRYPTO_AES_ALGORITHM_AES;
</#if>    
    
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
	aesCfg->tampclr = false;
	aesCfg->bpe = false;
	aesCfg->apen = false;
	aesCfg->apm = CRYPTO_AES_AUTO_PADDING_IPSEC;
	aesCfg->padLen = 0;
	aesCfg->nhead = 0;
</#if>
}

void DRV_CRYPTO_AES_Init(void)
{
    /* Software reset */
    AES_REGS->AES_CR = AES_CR_SWRST_Msk;
}

void DRV_CRYPTO_AES_SetConfig(CRYPTO_AES_CONFIG *aesCfg)
{
    CRYPTO_AES_MR aesMR = {0};
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
    CRYPTO_AES_EMR aesEMR = {0};
</#if>
      
    /* MR fields */
    aesMR.s.CKEY = 0xE;
    
    aesMR.s.CIPHER = aesCfg->encryptMode;
    aesMR.s.SMOD = aesCfg->startMode;
    aesMR.s.KEYSIZE = aesCfg->keySize;
    aesMR.s.OPMODE = aesCfg->opMode;
    aesMR.s.CFBS = aesCfg->cfbSize;
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 10.3 deviated: 2. Deviation record ID - H3_MISRAC_2012_R_10_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.3" "H3_MISRAC_2012_R_10_3_DR_1"
</#if>
    aesMR.s.LOD = aesCfg->lod;
    aesMR.s.PROCDLY = aesCfg->processingDelay;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */
    
    if ((aesCfg->opMode == CRYPTO_AES_MODE_GCM) && (aesCfg->gtagEn == true))
    {
        /* MISRA C-2012 deviation block start */
        /* MISRA C-2012 Rule 10.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_10_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.3" "H3_MISRAC_2012_R_10_3_DR_1"
</#if>
        aesMR.s.GTAGEN = true;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
        /* MISRA C-2012 deviation block end */
    }
    
    /* Activate dual buffer in DMA mode */
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
    if ((aesCfg->startMode == CRYPTO_AES_IDATAR0_START) && (!aesCfg->apen))
<#else>
    if (aesCfg->startMode == CRYPTO_AES_IDATAR0_START)
</#if>
    {
        aesMR.s.DUALBUFF = 0;
    }
    
<#if __PROCESSOR?matches("PIC32CX.*MT.*") || __PROCESSOR?matches("SAMA7D65.*")>
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 10.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_10_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.3" "H3_MISRAC_2012_R_10_3_DR_1"
</#if>
    aesMR.s.TAMPCLR = aesCfg->tampclr;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */

    /* EMR fields */
<#if __PROCESSOR?matches("PIC32CX.*MT.*")>
    aesEMR.s.ALGO = aesCfg->algo;
</#if>
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 10.3 deviated: 2. Deviation record ID - H3_MISRAC_2012_R_10_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.3" "H3_MISRAC_2012_R_10_3_DR_1"
</#if>
    aesEMR.s.BPE = aesCfg->bpe; 
    aesEMR.s.APEN = aesCfg->apen;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */
    aesEMR.s.APM = aesCfg->apm;
    aesEMR.s.PADLEN = aesCfg->padLen;
    aesEMR.s.NHEAD = aesCfg->nhead;
    
    aesEMR.s.PLIPEN = 0;
    aesEMR.s.KSEL = CRYPTO_AES_KEY_FIRST;
    aesEMR.s.PKRS = CRYPTO_AES_PRIVATE_KEY_KEYWR;

    AES_REGS->AES_EMR = aesEMR.v;
</#if>

    AES_REGS->AES_MR = aesMR.v;
}

CRYPTO_AES_KEY_SIZE DRV_CRYPTO_AES_GetKeySize(uint32_t keyLen)
{
    CRYPTO_AES_KEY_SIZE keySize;
    
    switch (keyLen)
    {
        case 4:
            keySize = CRYPTO_AES_KEY_SIZE_128;
            break;

        case 6:
            keySize = CRYPTO_AES_KEY_SIZE_192;
            break;

        case 8:
            keySize = CRYPTO_AES_KEY_SIZE_256;
            break;
            
        default:
            keySize = CRYPTO_AES_KEY_SIZE_128;
            break;
    }

    return keySize;
}

void DRV_CRYPTO_AES_WriteKey(const uint32_t *key)
{
    uint8_t i, keyLen;
    uint32_t keySize;
            
    keySize = (AES_REGS->AES_MR & AES_MR_KEYSIZE_Msk) >> AES_MR_KEYSIZE_Pos;
    
    switch ((CRYPTO_AES_KEY_SIZE)keySize) 
    {
        case CRYPTO_AES_KEY_SIZE_128: 
            keyLen = 4;
            break;

        case CRYPTO_AES_KEY_SIZE_192: 
            keyLen = 6;
            break;

        case CRYPTO_AES_KEY_SIZE_256: 
            keyLen = 8;
            break;
        
        default:
            keyLen = 0;
            break;
    }

    for (i = 0; i < keyLen; i++) 
    {
        AES_REGS->AES_KEYWR[i] = *key;
        key++;
    }
}

void DRV_CRYPTO_AES_WriteInitVector(const uint32_t *iv)
{
    uint8_t i;
    
    for (i = 0; i < 4U; i++)
    {
        AES_REGS->AES_IVR[i] = *iv;
        iv++;        
    }
}

void DRV_CRYPTO_AES_WriteInputData(const uint32_t *inputDataBuffer)
{
    uint8_t i;

    for (i = 0; i < 4U; i++) 
    {
        AES_REGS->AES_IDATAR[i] = *inputDataBuffer;
        inputDataBuffer++;
    }
}

void DRV_CRYPTO_AES_ReadOutputData(uint32_t *outputDataBuffer)
{
    uint8_t i;
	
    for (i = 0; i < 4U; i++) 
    {
        *outputDataBuffer = AES_REGS->AES_ODATAR[i];
        outputDataBuffer++;
    }
}

void DRV_CRYPTO_AES_ReadTag(uint32_t *tagBuffer)
{
    uint8_t i;
	
    for (i = 0; i < 4U; i++) 
    {
        *tagBuffer = AES_REGS->AES_TAGR[i];
        tagBuffer++;
    }
}

void DRV_CRYPTO_AES_WriteAuthDataLen(uint32_t length)
{
    AES_REGS->AES_AADLENR = length;
}

void DRV_CRYPTO_AES_WritePCTextLen(uint32_t length)
{
    AES_REGS->AES_CLENR = length;
}

bool DRV_CRYPTO_AES_CipherIsReady(void)
{
    uint32_t datRdy = AES_REGS->AES_ISR & AES_ISR_DATRDY_Msk;
    if (datRdy != 0U)
    { 
        return true;
    }
    
    return false;
}

bool DRV_CRYPTO_AES_TagIsReady(void)
{
    uint32_t tagRdy = AES_REGS->AES_ISR & AES_ISR_TAGRDY_Msk;
    if (tagRdy != 0U)
    { 
        return true;
    }
    
    return false;
}

void DRV_CRYPTO_AES_ReadGcmHash(uint32_t *ghashBuffer)
{
    uint8_t i;

    for (i = 0; i < 4U; i++) 
    {
        *ghashBuffer = AES_REGS->AES_GHASHR[i];
        ghashBuffer++;
    }
}

void DRV_CRYPTO_AES_WriteGcmHash(uint32_t *ghashBuffer)
{
    uint8_t i;

    for (i = 0; i < 4U; i++) 
    {
        AES_REGS->AES_GHASHR[i] = ghashBuffer[i];
    }
}

void DRV_CRYPTO_AES_ReadGcmH(uint32_t *hBuffer)
{
    uint8_t i;

    for (i = 0; i < 4U; i++) 
    {
        *hBuffer = AES_REGS->AES_GCMHR[i];
        hBuffer++;
    }
}

<#if __PROCESSOR?matches("SAMA7D65.*")>
void DRV_CRYPTO_AES_WriteTweak(const uint32_t *tweakBuffer)
{
    uint8_t i;

    for (i = 0; i < 4U; i++) 
    {
        AES_REGS->AES_TWR[i] = *tweakBuffer;
        tweakBuffer++;
    }
}

void DRV_CRYPTO_AES_WriteAlpha(const uint32_t *alphaBuffer)
{
    uint8_t i;

    for (i = 0; i < 4U; i++) 
    {
        AES_REGS->AES_ALPHAR[i] = *alphaBuffer;
        alphaBuffer++;
    }
}
</#if>