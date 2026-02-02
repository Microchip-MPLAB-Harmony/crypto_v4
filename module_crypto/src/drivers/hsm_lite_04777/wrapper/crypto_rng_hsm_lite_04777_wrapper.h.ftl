/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_rng_hsm_lite_04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper file for hardware TRNG.

  Description:
    This header file contains the wrapper interface to access the TRNG
    in the HSM_LITE/CAM hardware driver for Microchip microcontrollers.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) 2026, Microchip Technology Inc., and its subsidiaries. All rights reserved.

The software and documentation is provided by microchip and its contributors
"as is" and any express, implied or statutory warranties, including, but not
limited to, the implied warranties of merchantability, fitness for a particular
purpose and non-infringement of third party intellectual property rights are
disclaimed to the fullest extent permitted by law. In no event shall microchip
or its contributors be liable for any direct, indirect, incidental, special,
exemplary, or consequential damages (including, but not limited to, procurement
of substitute goods or services; loss of use, data, or profits; or business
interruption) however caused and on any theory of liability, whether in contract,
strict liability, or tort (including negligence or otherwise) arising in any way
out of the use of the software and documentation, even if advised of the
possibility of such damage.

Except as expressly permitted hereunder and subject to the applicable license terms
for any third-party software incorporated in the software and any applicable open
source software license terms, no license or other rights, whether express or
implied, are granted under any patent or other intellectual property rights of
Microchip or any third party.
*/
//DOM-IGNORE-END

#ifndef CRYPTO_RNG_HSM_LITE_04777_WRAPPER_H
#define CRYPTO_RNG_HSM_LITE_04777_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "crypto/common_crypto/crypto_common.h"
#include "crypto/common_crypto/crypto_rng.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END

// *****************************************************************************
// *****************************************************************************
// Section: TRNG Common Interface
// *****************************************************************************
// *****************************************************************************

/**
 * @ingroup crypto_rng_hsm_lite_04777_wrapper
 * @brief Generates random data using the hardware TRNG.
 * @param [out] rngData Pointer to the buffer where the generated random data will be stored.
 * @param [in] rngLen Number of random bytes to generate.
 * @return @ref crypto_Rng_Status_E indicating operation result.
 * @retval CRYPTO_RNG_SUCCESS Random data generated successfully.
 * @retval CRYPTO_RNG_ERROR_NOTSUPPTED Hardware TRNG support is not available or not enabled.
 * @retval CRYPTO_RNG_ERROR_FAIL General failure during random number generation.
 */
 
crypto_Rng_Status_E Crypto_Rng_Hw_Trng_Generate(uint8_t *rngData, uint32_t rngLen);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* CRYPTO_RNG_HSM_LITE_04777_WRAPPER_H */
