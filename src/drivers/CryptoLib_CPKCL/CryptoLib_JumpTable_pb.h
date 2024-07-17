/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    CryptoLib_JumpTable_pb.h

  Summary:
    Crypto Framework Library interface file for hardware Cryptography.

  Description:
    This file provides an example for interfacing with the CPKCC module
    on the PIC32CXMxxx device family.
**************************************************************************/

//DOM-IGNORE-BEGIN
/*
Copyright (C) 2024, Microchip Technology Inc., and its subsidiaries. All rights reserved.

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

#ifndef CRYPTOLIB_JUMPTABLE_PB_INCLUDED_
#define CRYPTOLIB_JUMPTABLE_PB_INCLUDED_

extern ServiceFctType vCPKCLCsClearFlags;
extern ServiceFctType vCPKCLCsComp;
extern ServiceFctType vCPKCLCsCondCopy;
extern ServiceFctType vCPKCLCsFastCopy;
extern ServiceFctType vCPKCLCsFill;
extern ServiceFctType vCPKCLCsFmult;
extern ServiceFctType vCPKCLCsNOP;
extern ServiceFctType vCPKCLCsRng;
extern ServiceFctType vCPKCLCsSelfTest;
extern ServiceFctType vCPKCLCsSmult;
extern ServiceFctType vCPKCLCsSquare;
extern ServiceFctType vCPKCLCsSwap;
extern ServiceFctType vCPKCLCsZpEccAddFast;
extern ServiceFctType vCPKCLCsZpEcConvProjToAffine;
extern ServiceFctType vCPKCLCsZpEcPointIsOnCurve;
extern ServiceFctType vCPKCLCsZpEcConvAffineToProjective;
extern ServiceFctType vCPKCLCsZpEcRandomiseCoordinate;
extern ServiceFctType vCPKCLCsZpEccDblFast;
extern ServiceFctType vCPKCLCsZpEccMulFast;
extern ServiceFctType vCPKCLCsZpEcDsaGenerateFast;
extern ServiceFctType vCPKCLCsZpEcDsaVerifyFast;
extern ServiceFctType vCPKCLCsGF2NEccAddFast;
extern ServiceFctType vCPKCLCsGF2NEcConvProjToAffine;
extern ServiceFctType vCPKCLCsGF2NEcPointIsOnCurve;
extern ServiceFctType vCPKCLCsGF2NEcRandomiseCoordinate;
extern ServiceFctType vCPKCLCsGF2NEcConvAffineToProjective;
extern ServiceFctType vCPKCLCsGF2NEccDblFast;
extern ServiceFctType vCPKCLCsGF2NEccMulFast;
extern ServiceFctType vCPKCLCsGF2NEcDsaGenerateFast;
extern ServiceFctType vCPKCLCsGF2NEcDsaVerifyFast;
extern ServiceFctType vCPKCLCsCRT;
extern ServiceFctType vCPKCLCsDiv;
extern ServiceFctType vCPKCLCsExpMod;
extern ServiceFctType vCPKCLCsGCD;
extern ServiceFctType vCPKCLCsPrimeGen;
extern ServiceFctType vCPKCLCsRedMod;

#endif  // CRYPTOLIB_JUMPTABLE_PB_INCLUDED_
