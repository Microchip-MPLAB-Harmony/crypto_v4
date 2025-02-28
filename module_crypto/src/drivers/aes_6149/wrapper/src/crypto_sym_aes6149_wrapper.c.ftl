/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_sym_aes6149_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware AES.

  Description:
    This source file contains the wrapper interface to access the symmetric 
    AES algorithms in the AES hardware driver for Microchip microcontrollers.
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
#include "crypto/drivers/wrapper/crypto_sym_aes6149_wrapper.h"
#include "crypto/drivers/driver/drv_crypto_aes_hw_6149.h"

// *****************************************************************************
// *****************************************************************************
// Section: File scope functions
// *****************************************************************************
// *****************************************************************************

static crypto_Sym_Status_E lCrypto_Sym_Hw_Aes_GetOperationMode
    (crypto_Sym_OpModes_E opMode, CRYPTO_AES_OPERATION_MODE* aesMode, 
     CRYPTO_AES_CFB_SIZE* cfbSize)
{
    *cfbSize = CRYPTO_AES_CFB_SIZE_128BIT; // Default if not used
    crypto_Sym_Status_E retStat = CRYPTO_SYM_CIPHER_SUCCESS;
    switch (opMode) 
    {
<#if (CRYPTO_HW_AES_ECB?? &&(CRYPTO_HW_AES_ECB == true))>
        case CRYPTO_SYM_OPMODE_ECB:
            *aesMode = CRYPTO_AES_MODE_ECB;
            break;
</#if><#-- CRYPTO_HW_AES_ECB -->   
<#if (CRYPTO_HW_AES_CBC?? &&(CRYPTO_HW_AES_CBC == true))>
        case CRYPTO_SYM_OPMODE_CBC:
            *aesMode = CRYPTO_AES_MODE_CBC;
            break;
</#if><#-- CRYPTO_HW_AES_CBC -->        
<#if (CRYPTO_HW_AES_OFB?? &&(CRYPTO_HW_AES_OFB == true))>
        case CRYPTO_SYM_OPMODE_OFB:
            *aesMode = CRYPTO_AES_MODE_OFB;
            break;
</#if><#-- CRYPTO_HW_AES_OFB -->           
<#if (CRYPTO_HW_AES_CFB1?? &&(CRYPTO_HW_AES_CFB1 == true))>
        case CRYPTO_SYM_OPMODE_CFB1:
            retStat = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
            break;
</#if><#-- CRYPTO_HW_AES_CFB1 -->            
<#if (CRYPTO_HW_AES_CFB8?? &&(CRYPTO_HW_AES_CFB8 == true))>
        case CRYPTO_SYM_OPMODE_CFB8:
            *aesMode = CRYPTO_AES_MODE_CFB;
            *cfbSize = CRYPTO_AES_CFB_SIZE_8BIT;
            break;
</#if><#-- CRYPTO_HW_AES_CFB8 -->            
<#if (CRYPTO_HW_AES_CFB16?? &&(CRYPTO_HW_AES_CFB16 == true))>
        case CRYPTO_SYM_OPMODE_CFB16:
            *aesMode = CRYPTO_AES_MODE_CFB;
            *cfbSize = CRYPTO_AES_CFB_SIZE_16BIT;
            break;
</#if><#-- CRYPTO_HW_AES_CFB16 -->        
<#if (CRYPTO_HW_AES_CFB32?? &&(CRYPTO_HW_AES_CFB32 == true))>
        case CRYPTO_SYM_OPMODE_CFB32:
            *aesMode = CRYPTO_AES_MODE_CFB;
            *cfbSize = CRYPTO_AES_CFB_SIZE_32BIT;
            break;
</#if><#-- CRYPTO_HW_AES_CFB32 -->          
<#if (CRYPTO_HW_AES_CFB64?? &&(CRYPTO_HW_AES_CFB64 == true))>
        case CRYPTO_SYM_OPMODE_CFB64:
            *aesMode = CRYPTO_AES_MODE_CFB;
            *cfbSize = CRYPTO_AES_CFB_SIZE_64BIT;
            break;
</#if><#-- CRYPTO_HW_AES_CFB64 -->           
<#if (CRYPTO_HW_AES_CFB128?? &&(CRYPTO_HW_AES_CFB128 == true))>
        case CRYPTO_SYM_OPMODE_CFB128:
            *aesMode = CRYPTO_AES_MODE_CFB;
            *cfbSize = CRYPTO_AES_CFB_SIZE_128BIT;
            break;
</#if><#-- CRYPTO_HW_AES_CFB128 -->      
<#if (CRYPTO_HW_AES_CTR?? &&(CRYPTO_HW_AES_CTR == true))>
        case CRYPTO_SYM_OPMODE_CTR:
            *aesMode = CRYPTO_AES_MODE_CTR;
            break;
</#if><#-- CRYPTO_HW_AES_CTR -->       
        case CRYPTO_SYM_OPMODE_INVALID:
            retStat = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
            break;        
        default:
            retStat = CRYPTO_SYM_ERROR_CIPNOTSUPPTD;
            break;
    }
    
    return retStat;
}
    
// *****************************************************************************
// *****************************************************************************
// Section: Symmetric Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Init(crypto_CipherOper_E cipherOpType_en, 
    crypto_Sym_OpModes_E opMode_en, uint8_t *key, uint32_t keyLen, 
    uint8_t *initVect)
{ 
    CRYPTO_AES_CONFIG aesCfg;
    CRYPTO_AES_OPERATION_MODE opMode = CRYPTO_AES_MODE_ECB;
    CRYPTO_AES_CFB_SIZE cfbSize;
    crypto_Sym_Status_E result;
        
    /* Get operation mode for driver */
    result = lCrypto_Sym_Hw_Aes_GetOperationMode(opMode_en, &opMode, &cfbSize);
    if (result != CRYPTO_SYM_CIPHER_SUCCESS)
    {
        return result;
    }
    
    /* Get the default configuration of the driver */
    DRV_CRYPTO_AES_GetConfigDefault(&aesCfg);
    
    /* Initialize the driver */
    DRV_CRYPTO_AES_Init();
    
    /* Set the configuration for the driver */
    aesCfg.keySize = DRV_CRYPTO_AES_GetKeySize(keyLen / 4UL);
    aesCfg.startMode = CRYPTO_AES_AUTO_START;
    aesCfg.opMode = opMode;
    aesCfg.cfbSize = cfbSize;
    if (cipherOpType_en == CRYPTO_CIOP_ENCRYPT)
    {
        aesCfg.encryptMode = CRYPTO_AES_ENCRYPTION;
    }
    else 
    {
        aesCfg.encryptMode = CRYPTO_AES_DECRYPTION;
    }
    
    DRV_CRYPTO_AES_SetConfig(&aesCfg);
    
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 11.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
</#if>
    /* Write the key */
    DRV_CRYPTO_AES_WriteKey((uint32_t *)key);
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */
    
    /* Write the initialization vector */
    if (initVect != NULL)
    {
        /* MISRA C-2012 deviation block start */
        /* MISRA C-2012 Rule 11.3 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
</#if>
        DRV_CRYPTO_AES_WriteInitVector((uint32_t *) initVect);
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
        /* MISRA C-2012 deviation block end */
    }
    
    return CRYPTO_SYM_CIPHER_SUCCESS;
}
    
crypto_Sym_Status_E Crypto_Sym_Hw_Aes_Cipher(uint8_t *inputData, 
    uint32_t dataLen, uint8_t *outData)
{
    DRV_CRYPTO_AES_WritePCTextLen(dataLen);
    
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 11.3 deviated: 2. Deviation record ID - H3_MISRAC_2012_R_11_3_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
</#if>
    uint32_t *iData = (uint32_t *)inputData;
    uint32_t *oData = (uint32_t *)outData;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */
    uint32_t blockLen = dataLen / 4UL;
    uint32_t block;   /* 4 32bit block size */
    for (block = 0; block < blockLen; block += 4UL)
    {
        /* Write the data to be ciphered to the input data registers */
        DRV_CRYPTO_AES_WriteInputData(iData);
        iData += 4;

        /* Wait for the cipher process to end */
        while (!DRV_CRYPTO_AES_CipherIsReady())
        {
            ;
        }   

        /* Cipher complete - read out the data */
        DRV_CRYPTO_AES_ReadOutputData(oData);
        oData += 4;
    }
    
    return CRYPTO_SYM_CIPHER_SUCCESS;
}

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_EncryptDirect(crypto_Sym_OpModes_E opMode_en, 
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData, 
    uint8_t *key, uint32_t keyLen, uint8_t *initVect)
{
    crypto_Sym_Status_E result = CRYPTO_SYM_CIPHER_SUCCESS;
    
    result = Crypto_Sym_Hw_Aes_Init(CRYPTO_CIOP_ENCRYPT, opMode_en, key, 
                                    keyLen, initVect);
                
    if (result != CRYPTO_SYM_CIPHER_SUCCESS)
    {
        return result;
    }
    
    return Crypto_Sym_Hw_Aes_Cipher(inputData, dataLen, outData);
}

crypto_Sym_Status_E Crypto_Sym_Hw_Aes_DecryptDirect(crypto_Sym_OpModes_E opMode_en, 
    uint8_t *inputData, uint32_t dataLen, uint8_t *outData, 
    uint8_t *key, uint32_t keyLen, uint8_t *initVect)
{
    crypto_Sym_Status_E result = CRYPTO_SYM_CIPHER_SUCCESS;
    
    result = Crypto_Sym_Hw_Aes_Init(CRYPTO_CIOP_DECRYPT, opMode_en, key, 
                                    keyLen, initVect);
                
    if (result != CRYPTO_SYM_CIPHER_SUCCESS)
    {
        return result;
    }
    
    return Crypto_Sym_Hw_Aes_Cipher(inputData, dataLen, outData);
}
