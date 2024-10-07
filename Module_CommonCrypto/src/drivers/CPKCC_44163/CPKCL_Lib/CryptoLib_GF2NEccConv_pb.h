/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    CryptoLib_GF2NEccConv_pb.h

  Summary:
    Crypto Framework Library interface file for hardware Cryptography.

  Description:
    This file provides an example for interfacing with the CPKCC module.
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

#ifndef CRYPTOLIBGF2ECNCONV_INCLUDED
#define CRYPTOLIBGF2ECNCONV_INCLUDED

// Structure definition
typedef struct struct_CPKCL_GF2NEcConvProjToAffine {
               nu1       nu1ModBase;
               nu1       nu1CnsBase;
               u2        u2ModLength;

               nu1       nu1PointABase;
               nu1       padding0;
               nu1       nu1Workspace;
               } CPKCL_GF2NECCONVPROJTOAFFINE_STRUCT, *P_CPKCL_GF2NECCONVPROJTOAFFINE_STRUCT;


typedef struct struct_CPKCL_GF2NEcConvAffineToProjective {
               nu1       nu1ModBase;
               nu1       nu1CnsBase;
               u2        u2ModLength;

               nu1       nu1PointABase;
               nu1       padding0;
               nu1       nu1Workspace;
               nu1       padding1;
               nu1       padding2;
               nu1       padding3;
               nu1       padding4;
               } CPKCL_GF2NECCONVAFFINETOPROJECTIVE_STRUCT, *P_CPKCL_GF2NECCONVAFFINETOPROJECTIVE_STRUCT;

typedef struct struct_CPKCL_GF2NEcPointIsOnCurve {
               nu1       nu1ModBase;
               nu1       nu1CnsBase;
               u2        u2ModLength;

               nu1       nu1AParam;
               nu1       nu1BParam;
               nu1       nu1PointBase;
               nu1       nu1Workspace;
               u2        padding0;
               u2        padding1;               
               } CPKCL_GF2NECPOINTISONCURVE_STRUCT, *P_CPKCL_GF2NECPOINTISONCURVE_STRUCT;

typedef struct struct_CPKCL_GF2NEcRandomiseCoordinate {
               nu1       nu1ModBase;
               nu1       nu1CnsBase;
               u2        u2ModLength;

               nu1       nu1PointBase;
               nu1       nu1RandomBase;
               nu1       nu1Workspace;
               nu1       padding0;
               nu1       padding1;
               nu1       padding2;
               nu1       padding3;
               } CPKCL_GF2NECRANDOMIZECOORDINATE_STRUCT, *P_CPKCL_GF2NECRANDOMIZECOORDINATE_STRUCT;



#endif // CRYPTOLIBGF2NECCONV_INCLUDED
