/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    CryptoLib_PrimeGen_pb.h

  Summary:
    Crypto Framework Library interface file for hardware Cryptography.

  Description:
    This file provides an example for interfacing with the CPKCC module.
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

#ifndef CRYPTOLIB_PRIMEGEN_PB_INCLUDED
#define CRYPTOLIB_PRIMEGEN_PB_INCLUDED

// Structure definition
typedef struct struct_CPKCL_primegen {
               nu1       nu1NBase;           //
               nu1       nu1CnsBase;
               u2        u2NLength;

               nu1       nu1RndBase;         // (3*u2NLength + 6) words
               nu1       nu1PrecompBase;     // (u2NLength + 2) words
               nu1       padding0;
               nu1       nu1RBase;           // (Significant length of 'N' without the padding word)
               nu1       nu1ExpBase;         // (u2NLength) words
               u1        u1MillerRabinIterations;
               u1        padding1;
               u2        u2MaxIncrement;
               } CPKCL_PRIMEGEN_STRUCT, *PPKCL_PRIMEGEN_STRUCT;

// Options definition
#define CPKCL_PRIMEGEN_TEST          0x02
#define CPKCL_PRIMEGEN_MASK          0x03


#endif // CRYPTOLIB_PRIMEGEN_PB_INCLUDED
