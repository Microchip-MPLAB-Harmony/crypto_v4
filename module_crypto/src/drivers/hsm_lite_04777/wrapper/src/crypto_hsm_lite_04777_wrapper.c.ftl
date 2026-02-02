/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_hsm_lite_04777_wrapper.c

  Summary:
    Crypto Framework Library wrapper file for common HSM-Lite hardware management.

  Description:
    This source file contains the wrapper interface to manage common HSM-Lite hardware
    interactions for Microchip microcontrollers.
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

// *****************************************************************************
// Section: Included Files
// *****************************************************************************

#include <stdint.h>
#include <stddef.h>
#include <xc.h>
#include "definitions.h"
#include "crypto/drivers/wrapper/crypto_hsm_lite_04777_wrapper.h"

// *****************************************************************************
// Section: Static Variables and Function Pointers
// *****************************************************************************

// Interrupt number for HSM in PIC32CM-SG00 (from ATDF: index 139)
#define HSM_IRQn  ((IRQn_Type)139)

// Single (HSM) interrupt handler slot, as there is only one
static crypto_Int_Handler cryptoHsmHandler = NULL;

// --- ECDSA operation callback pointers and type check ---
static void (*CRYPTO_HSM_SignOperationCompleteHandler)(void) = NULL;
static void (*CRYPTO_HSM_VerifyOperationCompleteHandler)(void) = NULL;
static crypto_operation_Id (*CRYPTO_HSM_OperationTypeHandler)(void) = NULL;

// *****************************************************************************
// Section: Callback Registration for ECDSA Operations
// *****************************************************************************

void CRYPTO_Int_Hw_SignComplete_CallbackRegister(void (*handler)(void))
{
    if (handler != NULL)
    {
        CRYPTO_HSM_SignOperationCompleteHandler = handler;
    }
}

void CRYPTO_Int_Hw_VerifyComplete_CallbackRegister(void (*handler)(void))
{
    if (handler != NULL)
    {
        CRYPTO_HSM_VerifyOperationCompleteHandler = handler;
    }
}

void CRYPTO_Int_Hw_OperationTypeHandlerRegister(crypto_operation_Id (*handler)(void))
{
    if (handler != NULL)
    {
        CRYPTO_HSM_OperationTypeHandler = handler;
    }
}

// *****************************************************************************
// Section: HSM Interrupt Handler
// *****************************************************************************

void HSM_Handler(void)
{
    if (cryptoHsmHandler != NULL)
    {
        cryptoHsmHandler();
    }
    if (CRYPTO_HSM_OperationTypeHandler != NULL)
    {
        crypto_operation_Id op = CRYPTO_HSM_OperationTypeHandler();

        if ((CRYPTO_HSM_SignOperationCompleteHandler != NULL) && (op == ECDSA_SIGN))
        {
            CRYPTO_HSM_SignOperationCompleteHandler();
        }

        if ((CRYPTO_HSM_VerifyOperationCompleteHandler != NULL) && (op == ECDSA_VERIFY))
        {
            CRYPTO_HSM_VerifyOperationCompleteHandler();
        }
    }
    // Clear interrupt flag if required (handled by hardware for most Cortex-M peripherals)
    // If software clear is needed, add code here.
}

// *****************************************************************************
// Section: Interrupts Common Interface Implementation
// *****************************************************************************

crypto_Int_Status_E Crypto_Int_Hw_Register_Handler(crypto_Int_Handler_Id handlerID, crypto_Int_Handler handler)
{
    if (handlerID != CRYPTO_HSM_INT)
        return CRYPTO_INT_INVALID_ID;

    if ((handler != NULL) && (cryptoHsmHandler != NULL))
        return CRYPTO_INT_ALREADY_REGISTERED;

    cryptoHsmHandler = handler;
    return CRYPTO_INT_SUCCESS;
}

crypto_Int_Status_E Crypto_Int_Hw_Enable(crypto_Int_Handler_Id handlerID)
{
    if (handlerID != CRYPTO_HSM_INT)
        return CRYPTO_INT_INVALID_ID;

    NVIC_ClearPendingIRQ(HSM_IRQn);
    NVIC_EnableIRQ(HSM_IRQn);
    return CRYPTO_INT_SUCCESS;
}

crypto_Int_Status_E Crypto_Int_Hw_Disable(crypto_Int_Handler_Id handlerID)
{
    if (handlerID != CRYPTO_HSM_INT)
        return CRYPTO_INT_INVALID_ID;

    NVIC_DisableIRQ(HSM_IRQn);
    NVIC_ClearPendingIRQ(HSM_IRQn);
    return CRYPTO_INT_SUCCESS;
}