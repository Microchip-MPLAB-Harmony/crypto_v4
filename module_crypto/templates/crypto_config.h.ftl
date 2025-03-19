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

<#if HSM_BOOT_FIRMWARE_INIT_ADDR?has_content>
    <#lt>/* HSM Firmware Metadata Address */
    <#lt>#define HSM_BOOT_FIRMWARE_INIT_ADDR  (${HSM_BOOT_FIRMWARE_INIT_ADDR})
</#if>

//DOM-IGNORE-BEGIN
#ifdef __cplusplus
}
#endif
//DOM-IGNORE-END

#endif // CRYPTO_HW_CONFIG_H
/*******************************************************************************
 End of File
*/
