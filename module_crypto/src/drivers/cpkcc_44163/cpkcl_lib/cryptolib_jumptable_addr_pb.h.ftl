/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    CryptoLib_JumpTable_Addr_pb.h

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

#ifndef CRYPTOLIB_JUMPTABLE_ADDR_PB_INCLUDED_
#define CRYPTOLIB_JUMPTABLE_ADDR_PB_INCLUDED_

#include "cryptolib_typedef_pb.h"
#include "cryptolib_mapping_pb.h"
#include "cryptolib_headers_pb.h"

/* MISRA C-2012 deviation block start */
/* MISRA C-2012 Rule 8.2 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_8_2_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 8.2" "H3_MISRAC_2012_R_8_2_DR_1"
</#if>
typedef void (*PPKCL_FUNC) (PCPKCL_PARAM);
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 8.2"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
/* MISRAC 2012 deviation block end */

// JumpTable address + 1 as it is thumb code
#define vCPKCLCsJumpTableStart                0x02020001
#define vCPKCLCsNOP							      ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x00 ))
#define vCPKCLCsSelfTest						  ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x04 ))
#define vCPKCLCsFill          				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x08 ))
#define vCPKCLCsSwap          				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x0c ))
#define vCPKCLCsFastCopy      				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x10 ))
#define vCPKCLCsCondCopy      				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x14 ))
#define vCPKCLCsClearFlags    				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x18 ))
#define vCPKCLCsComp          				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x1c ))
#define vCPKCLCsFmult         				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x20 ))
#define vCPKCLCsSmult         				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x24 ))
#define vCPKCLCsSquare        				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x28 ))
#define vCPKCLCsDiv           				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x2c ))
#define vCPKCLCsRedMod        				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x30 ))
#define vCPKCLCsExpMod        				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x34 ))
#define vCPKCLCsCRT           				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x38 ))
#define vCPKCLCsGCD           				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x3c ))
#define vCPKCLCsPrimeGen      				((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x40 ))
#define vCPKCLCsZpEcPointIsOnCurve			((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x44 ))
#define vCPKCLCsZpEcRandomiseCoordinate       ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x48 ))
#define vCPKCLCsZpEcConvAffineToProjective    ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x4c ))
#define vCPKCLCsZpEccAddFast                  ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x50 ))
#define vCPKCLCsZpEccDblFast                  ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x54 ))
#define vCPKCLCsZpEccMulFast                  ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x58 ))
#define vCPKCLCsZpEcDsaGenerateFast           ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x5c ))
#define vCPKCLCsZpEcDsaVerifyFast             ((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x60 ))
#define vCPKCLCsZpEcConvProjToAffine			((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x64 ))
#define vCPKCLCsGF2NEcRandomiseCoordinate	  	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x68 ))
#define vCPKCLCsGF2NEcConvProjToAffine       	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x6c ))
#define vCPKCLCsGF2NEcConvAffineToProjective 	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x70 ))
#define vCPKCLCsGF2NEcPointIsOnCurve         	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x74 ))
#define vCPKCLCsGF2NEccAddFast               	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x78 ))
#define vCPKCLCsGF2NEccDblFast               	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x7C ))
#define vCPKCLCsGF2NEccMulFast               	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x80 ))
#define vCPKCLCsGF2NEcDsaGenerateFast        	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x84 ))
#define vCPKCLCsGF2NEcDsaVerifyFast          	((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x88 ))
#define vCPKCLCsRng         					((PPKCL_FUNC)(vCPKCLCsJumpTableStart + 0x8C ))


#endif // CRYPTOLIB_JUMPTABLE_ADDR_PB_INCLUDED_
