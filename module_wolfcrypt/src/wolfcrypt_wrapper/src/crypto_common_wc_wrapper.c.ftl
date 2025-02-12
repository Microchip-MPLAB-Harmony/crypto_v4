/*******************************************************************************
  MPLAB Harmony Application Source File

  Company:
    Microchip Technology Inc.

  File Name:
    crypto_common_wc_wrapper.c

  Summary:
    This file contains the Common code for the Wolfcrypt Library application.

  Description:
    This file contains the source code for the MPLAB Harmony application.  It
    implements the logic of the application's state machine and it may call
    API routines of other MPLAB Harmony modules in the system, such as drivers,
    system services, and middleware.  However, it does not call any of the
    system interfaces (such as the "Initialize" and "Tasks" functions) of any of
    the modules in the system or make any assumptions about when those functions
    are called.  That is the responsibility of the configuration-specific system
    files.
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
 
// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************
#include <stdlib.h>
#include <time.h>

#include "crypto/wolfcrypt/crypto_common_wc_wrapper.h"
<#if (CRYPTO_WC_ECDSA?? &&(CRYPTO_WC_ECDSA == true)) || (CRYPTO_WC_ECDH?? &&(CRYPTO_WC_ECDH == true))>
#include "wolfssl/wolfcrypt/ecc.h"

static const int arr_EccCurveWcMap[CRYPTO_WC_ECC_TOTAL_CURVES][2] =  {
                                                                        {(int)CRYPTO_ECC_CURVE_INVALID, (int)ECC_CURVE_INVALID},
                                                                        {(int)CRYPTO_ECC_CURVE_SECP224R1, (int)ECC_SECP224R1}, 
                                                                        {(int)CRYPTO_ECC_CURVE_SECP256R1, (int)ECC_SECP256R1},
                                                                        {(int)CRYPTO_ECC_CURVE_SECP384R1, (int)ECC_SECP384R1},
                                                                        {(int)CRYPTO_ECC_CURVE_SECP521R1, (int)ECC_SECP521R1},
                                                                    };

int Crypto_Common_Wc_Ecc_GetWcCurveId(crypto_EccCurveType_E curveType_en)
{
    int wcCurveId = -1;
    
    for(int curve = 0; curve < CRYPTO_WC_ECC_TOTAL_CURVES; curve++)
    {
        if(curveType_en == (crypto_EccCurveType_E)arr_EccCurveWcMap[curve][0])
        {
            wcCurveId = arr_EccCurveWcMap[curve][1];
            break;
        }
    }    
    return wcCurveId;
}
</#if><#-- CRYPTO_WC_ECDSA || CRYPTO_WC_ECDH -->

__attribute__((weak)) int Crypto_Rng_Wc_Prng_EntropySource(void)
{
  return (int) rand();
}

__attribute__((weak)) int Crypto_Rng_Wc_Prng_Srand(uint8_t* output, unsigned int sz)
{   
    unsigned int i;
    for (i = 0; i < sz; i++)
    {
        int randVal = Crypto_Rng_Wc_Prng_EntropySource() % 256;
        output[i] = (uint8_t)randVal;
    }
    
    return 0;
} 