/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_rng_trng6334_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for hardware TRNG.

  Description:
    This source file contains the wrapper interface to access the TRNG 
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/drivers/wrapper/crypto_rng_trng6334_wrapper.h"
<#if driver_defines?contains("HAVE_CRYPTO_HW_TRNG_6334_DRIVER")>
#include "crypto/drivers/driver/drv_crypto_trng_hw_6334.h"
</#if>

// *****************************************************************************
// *****************************************************************************
// Section: TRNG Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

crypto_Rng_Status_E Crypto_Rng_Hw_Trng_Generate(uint8_t *rngData, uint32_t rngLen)
{
<#if driver_defines?contains("HAVE_CRYPTO_HW_TRNG_6334_DRIVER")>
    DRV_CRYPTO_TRNG_Generate(rngData, rngLen);
    
    return CRYPTO_RNG_SUCCESS;
<#else>
    return CRYPTO_RNG_ERROR_NOTSUPPTED;
</#if>
}    
