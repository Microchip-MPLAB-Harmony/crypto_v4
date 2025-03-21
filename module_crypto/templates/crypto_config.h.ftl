/*******************************************************************************
  Secure Project System Configuration Header

  File Name:
    configuration.h

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

#ifndef CRYPTO_CONFIG_H
#define CRYPTO_CONFIG_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

<#if hsm_boot_h_ftl_flag?? &&(hsm_boot_h_ftl_flag == true)>
    <#lt> /* HSM Initialization */
    <#lt>#include "crypto/drivers/driver/hsm_boot.h"

</#if>
/* Crypto v4 API */
<#if crypto_common_h_ftl_flag?? &&(crypto_common_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_common.h"
</#if>
<#if crypto_aead_cipher_h_ftl_flag?? &&(crypto_aead_cipher_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_aead_cipher.h"
</#if>
<#if crypto_digsign_h_ftl_flag?? &&(crypto_digsign_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_digsign.h"
</#if>
<#if crypto_hash_h_ftl_flag?? &&(crypto_hash_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_hash.h"
</#if>
<#if crypto_kas_h_ftl_flag?? &&(crypto_kas_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_kas.h"
</#if>
<#if crypto_mac_cipher_h_ftl_flag?? &&(crypto_mac_cipher_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_mac_cipher.h"
</#if>
<#if crypto_rng_h_ftl_flag?? &&(crypto_rng_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_rng.h"
</#if>
<#if crypto_sym_cipher_h_ftl_flag?? &&(crypto_sym_cipher_h_ftl_flag == true)>
    <#lt>#include "crypto/common_crypto/crypto_sym_cipher.h"
</#if>

#include "device.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END
<#-- Define hexDigits outside of any macro to make it globally accessible -->
<#assign hexDigits = "0123456789ABCDEF">

<#--  Provide custom define for HSM boot  -->
<#macro decimalToHex decimalNumber>
    <#local hexString = _decimalToHex(decimalNumber)>
    <#local trimmedHexString = _trimLeadingZeros(hexString)>
    <#lt>#define CUSTOM_HSM_BOOT_FIRMWARE_ADDR (0x${trimmedHexString})
</#macro>

<#--  Recursive calculation of BASE16 from BASE10 -->
<#function _decimalToHex decimalNumber>
    <#local remainder = decimalNumber % 16>
    <#local quotient = decimalNumber / 16?floor>

    <#if quotient != 0>
        <#return _decimalToHex(quotient) + hexDigits?substring(remainder, remainder + 1)>
    <#else>
        <#return hexDigits?substring(remainder, remainder + 1)>
    </#if>
</#function>

<#--  Remove first 10 digits, attempt to do it in general way -->
<#function _trimLeadingZeros hexString>
    <#local firstNonZeroIndex = 10>   <#-- Remove 10 leading char -->
    <#list 0..hexString?length - 1 as i>
        <#if hexString?substring(i, i + 1) != "0">
        <#break>
        </#if>
        <#assign firstNonZeroIndex = i + 1>
    </#list>
    <#return hexString?substring(firstNonZeroIndex)>
</#function>

<#lt>/* HSM metadata address for provided HSM .hex file */
<#if DEFAULT_HSM_BOOT_FIRMWARE_ADDR?has_content>
#define DEFAULT_HSM_BOOT_FIRMWARE_ADDR (${DEFAULT_HSM_BOOT_FIRMWARE_ADDR})
</#if>

<#if FLASH_START_ADDR?has_content && core.IDAU_AS_SIZE?has_content && core.IDAU_ANSC_SIZE?has_content>
  <#assign bytesIndexAS = core.IDAU_AS_SIZE?index_of(" Bytes")>
  <#assign bytesIndexANSC = core.IDAU_ANSC_SIZE?index_of(" Bytes")>
  <#if (bytesIndexAS != -1) && (bytesIndexANSC != -1)>
    <#assign flashStartNumber = FLASH_START_ADDR?number>
    <#assign idauAsSizeNumber = core.IDAU_AS_SIZE?substring(0, bytesIndexAS)?number>
    <#assign idauAnscSizeNumber = core.IDAU_ANSC_SIZE?substring(0, bytesIndexANSC)?number>
    <#assign sum = flashStartNumber + (idauAsSizeNumber + idauAnscSizeNumber)>
    <#assign hsm_addr = sum - 133120>   <#--  130 KB offset  -->
    <#if hsm_addr < flashStartNumber>
      <#-- Error condition: HSM address is less than flash start address -->
      <#lt>/*
      <#lt>   WARNING: HSM metadata address (0x${_trimLeadingZeros(_decimalToHex(hsm_addr))}) 
      <#lt>   is less than flash start address (${FLASH_START_ADDR}U). 
      <#lt>*/
      <#lt>#warning "Allow at least 130 KB of secure flash for the HSM."
      <#lt><@decimalToHex hsm_addr/>      <#-- Custom address calculation  -->
    <#else>
      <#lt>/* HSM metadata address for custom-sized secure flash HSM .hex file. */
      <#lt><@decimalToHex hsm_addr/>      <#-- Custom address calculation  -->
    </#if>
  </#if>
</#if>
<#--  
        TO DO
        * error handle for if START_ADDR doesn't have actual number
  -->
/* 
    HSM_BOOT_METADATA_ADDR must match the address 
    to the HSM metadata in the HSM .hex file. 
 */
#ifndef HSM_METADATA_ADDR_WARNING_DISABLE
#if DEFAULT_HSM_BOOT_FIRMWARE_ADDR == CUSTOM_HSM_BOOT_FIRMWARE_ADDR
#define HSM_BOOT_METADATA_ADDR (DEFAULT_HSM_BOOT_FIRMWARE_ADDR)
#else
#define HSM_BOOT_METADATA_ADDR (CUSTOM_HSM_BOOT_FIRMWARE_ADDR)
#warning "CUSTOM_HSM_BOOT_FIRMWARE_ADDR has been used. " \
         "Ensure that the new HSM .hex has been attached to this project." \
         "Disable warning with macro HSM_METADATA_ADDR_WARNING_DISABLE" \
         "                                                          " \
         "The default HSM .hex is configured to use the lower 130 KB " \
         "address range of secure flash. CUSTOM_HSM_BOOT_FIRMWARE_ADDR" \
         "reflects the updated metadata address, but the .hex must as well." \
         "The steps for this can be found in the App Note, linked " \
         "inside of ```/crypto_v4/readme.md/```."
#endif
#endif

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif // CRYPTO_HW_CONFIG_H
/*******************************************************************************
 End of File
*/
