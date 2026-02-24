/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hsm_lite_04777_wrapper.h

  Summary:
    Crypto Framework Library wrapper header for common HSM-Lite hardware management.

  Description:
    This header file contains the wrapper interface to manage common HSM-lite hardware
    interactions for Microchip microcontrollers.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) ${.now?string("yyyy")} Microchip Technology Inc., and its subsidiaries. All rights reserved.

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

#ifndef MCHP_CRYPTO_HSM_LITE_04777_WRAPPER_H
#define MCHP_CRYPTO_HSM_LITE_04777_WRAPPER_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

// (none)

// *****************************************************************************
// *****************************************************************************
// Section: C++ Compatibility
// *****************************************************************************
// *****************************************************************************

#ifdef __cplusplus
extern "C" {
#endif

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

typedef enum
{
    CRYPTO_INT_SUCCESS = 0,
    CRYPTO_INT_INVALID_ID = -1,
    CRYPTO_INT_ALREADY_REGISTERED = -2,
    CRYPTO_INT_GENERAL_FAIL = -127
} crypto_Int_Status_E;

typedef enum
{
    CRYPTO_HSM_ENGINE_NONE = 0,
    CRYPTO_HSM_ENGINE_AES,
    CRYPTO_HSM_ENGINE_HASH,
    CRYPTO_HSM_ENGINE_PKE,
    CRYPTO_HSM_ENGINE_TRNG
} crypto_hsm_engine_t;

typedef enum
{
    CRYPTO_HSM_INT = 0
} crypto_Int_Handler_Id;

typedef enum
{
    ECDSA_SIGN = 0,
    ECDSA_VERIFY = 1,
    UNKNOWN_OPERATION = 2
} crypto_operation_Id;

typedef void (*crypto_Int_Handler)(void);

// *****************************************************************************
// *****************************************************************************
// Section: Interrupt Common Interface
// *****************************************************************************
// *****************************************************************************

/**
 * @brief Register a single HSM interrupt handler (legacy single-slot API).
 *
 * Note: This API is maintained for backward compatibility. If multiple
 * crypto engines share the same NVIC interrupt and require different ISR helpers,
 * use Crypto_Int_Hw_Register_Engine_Handler() + Crypto_Int_Hw_SelectEngine().
 */
crypto_Int_Status_E Crypto_Int_Hw_Register_Handler(crypto_Int_Handler_Id handlerID,
                                                   crypto_Int_Handler handler);

/**
 * @brief Enable the HSM interrupt in NVIC.
 */
crypto_Int_Status_E Crypto_Int_Hw_Enable(crypto_Int_Handler_Id handlerID);

/**
 * @brief Disable the HSM interrupt in NVIC.
 */
crypto_Int_Status_E Crypto_Int_Hw_Disable(crypto_Int_Handler_Id handlerID);

// *****************************************************************************
// *****************************************************************************
// Section: Per-Engine ISR Registration (Recommended)
// *****************************************************************************
// *****************************************************************************

/**
 * @brief Register an ISR helper for a specific crypto engine.
 *
 * This allows multiple engine ISR helpers (AES/HASH/PKE/TRNG) to coexist.
 */
crypto_Int_Status_E Crypto_Int_Hw_Register_Engine_Handler(crypto_hsm_engine_t engine,
                                                          crypto_Int_Handler handler);

/**
 * @brief Select which crypto engine's ISR helper should run inside HSM_Handler().
 *
 * This should be set by the wrapper right before enabling IRQ / starting an operation.
 */
void Crypto_Int_Hw_SelectEngine(crypto_hsm_engine_t engine);

// *****************************************************************************
// *****************************************************************************
// Section: ECDSA Completion Callback Registration
// *****************************************************************************
// *****************************************************************************

void CRYPTO_Int_Hw_SignComplete_CallbackRegister(void (*handler)(void));
void CRYPTO_Int_Hw_VerifyComplete_CallbackRegister(void (*handler)(void));
void CRYPTO_Int_Hw_OperationTypeHandlerRegister(crypto_operation_Id (*handler)(void));

// *****************************************************************************
// *****************************************************************************
// Section: C++ Compatibility
// *****************************************************************************
// *****************************************************************************

#ifdef __cplusplus
}
#endif

#endif /* MCHP_CRYPTO_HSM_LITE_04777_WRAPPER_H */
