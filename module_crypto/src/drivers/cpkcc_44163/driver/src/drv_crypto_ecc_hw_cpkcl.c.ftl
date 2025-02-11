/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_ecc_hw_cpkcl.c

  Summary:
    Crypto Framework Library source file for hardware Cryptography.

  Description:
    This file provides the memory mapping to interface with the CPKCC 
    module. It also includes common functions to handle the interface and 
    the definitions of curves.
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

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdio.h>
#include <string.h>
#include "crypto/drivers/driver/drv_crypto_ecc_hw_cpkcl.h"
#include "crypto/drivers/cpkcl_lib/cryptolib_typedef_pb.h"
#include "crypto/drivers/cpkcl_lib/cryptolib_mapping_pb.h"
#include "crypto/drivers/cpkcl_lib/cryptolib_headers_pb.h"
#include "crypto/drivers/cpkcl_lib/cryptolib_jumptable_addr_pb.h"
#include "crypto/drivers/cpkcl_lib/cryptolib_cf.h"

// *****************************************************************************
// *****************************************************************************
// Section: Extern Declarations
// *****************************************************************************
// *****************************************************************************

PCPKCL_PARAM    pvCPKCLParam;
CPKCL_PARAM     CPKCLParam;

// *****************************************************************************
// *****************************************************************************
// Section: Macros
// *****************************************************************************
// *****************************************************************************

#define CPKCL_SELFTEST_CHECKSUM1   0x6E70DDD2
#define CPKCL_SELFTEST_CHECKSUM2   0x25C8D64F

// *****************************************************************************
// *****************************************************************************
// Section: Data Definitions
// *****************************************************************************
// *****************************************************************************

// *****************************************************************************
/* 192-bit Elliptic Curve Parameters

  Summary:
    Recommended 192-bit Elliptic Curve Domain Parameters.
*/
// P = 2^192 - 2^64 + 1
static const u1 p192_au1ModuloP[28] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF
};

// "a" parameter in curve equation
// x^3 = x^2 + a*x + b
static const u1 p192_au1ACurve[28] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFC
};

// Base point A abscissa
static const u1 p192_au1PtA_X[28] = {
0x00, 0x00, 0x00, 0x00, 0x18, 0x8d, 0xa8, 0x0e, 0xb0, 0x30, 0x90, 0xf6,
0x7c, 0xbf, 0x20, 0xeb, 0x43, 0xa1, 0x88, 0x00, 0xf4, 0xff, 0x0a, 0xfd,
0x82, 0xff, 0x10, 0x12
};

// Base point A ordinate
static const u1 p192_au1PtA_Y[28] = {
0x00, 0x00, 0x00, 0x00, 0x07, 0x19, 0x2b, 0x95, 0xff, 0xc8, 0xda, 0x78,
0x63, 0x10, 0x11, 0xed, 0x6b, 0x24, 0xcd, 0xd5, 0x73, 0xf9, 0x77, 0xa1,
0x1e, 0x79, 0x48, 0x11
};

// Base point A height
static const u1 p192_au1PtA_Z[28] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x01
};

// OrderPointBase
static const u1 p192_au1OrderPoint[28] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0x99, 0xDE, 0xF8, 0x36, 0x14, 0x6B, 0xC9, 0xB1,
0xB4, 0xD2, 0x28, 0x31
};

// Reduction constant
static const u1 p192_au1Cns[32] = {
0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
};

// "b" parameter in curve equation
// x^3 = x^2 + a*x + b
static const u1 p192_au1BCurve[28] = {
0x00, 0x00, 0x00, 0x00, 0x64, 0x21, 0x05, 0x19, 0xe5, 0x9c, 0x80, 0xe7,
0x0f, 0xa7, 0xe9, 0xab, 0x72, 0x24, 0x30, 0x49, 0xfe, 0xb8, 0xde, 0xec,
0xc1, 0x46, 0xb9, 0xb1
};

// *****************************************************************************
/* 224-bit Elliptic Curve Parameters

  Summary:
    Recommended 224-bit Elliptic Curve Domain Parameters.
*/
// P = 2^192 - 2^64 - 1
static const u1 p224_au1ModuloP[32] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01
};

// "a" parameter in curve equation = -3
// x^3 = x^2 + a*x + b
static const u1 p224_au1ACurve[32] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE
};

// Base point A abscissa
static const u1 p224_au1PtA_X[32] = {
0x00, 0x00, 0x00, 0x00, 0xB7, 0x0E, 0x0C, 0xBD, 0x6B, 0xB4, 0xBF, 0x7F,
0x32, 0x13, 0x90, 0xB9, 0x4A, 0x03, 0xC1, 0xD3, 0x56, 0xC2, 0x11, 0x22,
0x34, 0x32, 0x80, 0xD6, 0x11, 0x5C, 0x1D, 0x21
};

// Base point A ordinate
static const u1 p224_au1PtA_Y[32] = {
0x00, 0x00, 0x00, 0x00, 0xBD, 0x37, 0x63, 0x88, 0xB5, 0xF7, 0x23, 0xFB,
0x4C, 0x22, 0xDF, 0xE6, 0xCD, 0x43, 0x75, 0xA0, 0x5A, 0x07, 0x47, 0x64,
0x44, 0xD5, 0x81, 0x99, 0x85, 0x00, 0x7E, 0x34
};

// Base point A height
static const u1 p224_au1PtA_Z[32] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01
};

// OrderPointBase
static const u1 p224_au1OrderPoint[32] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x16, 0xA2, 0xE0, 0xB8, 0xF0, 0x3E,
0x13, 0xDD, 0x29, 0x45, 0x5C, 0x5C, 0x2A, 0x3D
};

// Reduction constant
static const u1 p224_au1Cns[36] = {
0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
};

// "b" parameter in curve equation
// x^3 = x^2 + a*x + b
static const u1 p224_au1BCurve[32] = {
0x00, 0x00, 0x00, 0x00, 0xb4, 0x05, 0x0a, 0x85, 0x0c, 0x04, 0xb3, 0xab,
0xf5, 0x41, 0x32, 0x56, 0x50, 0x44, 0xb0, 0xb7, 0xd7, 0xbf, 0xd8, 0xba,
0x27, 0x0b, 0x39, 0x43, 0x23, 0x55, 0xff, 0xb4
};

// *****************************************************************************
/* 256-bit Elliptic Curve Parameters

  Summary:
    Recommended 256-bit Elliptic Curve Domain Parameters.
*/
// P = 2^256 - 2^224 - 2^96 + 1
static const u1 p256_au1ModuloP[36] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x01,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};

// "a" parameter in curve equation = -3
// x^3 = x^2 + a*x + b
static const u1 p256_au1ACurve[36] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x01,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC
};

// Base point A abscissa
static const u1 p256_au1PtA_X[36] = {
0x00, 0x00, 0x00, 0x00, 0x6b, 0x17, 0xd1, 0xf2, 0xe1, 0x2c, 0x42, 0x47,
0xf8, 0xbc, 0xe6, 0xe5, 0x63, 0xa4, 0x40, 0xf2, 0x77, 0x03, 0x7d, 0x81,
0x2d, 0xeb, 0x33, 0xa0, 0xf4, 0xa1, 0x39, 0x45, 0xd8, 0x98, 0xc2, 0x96
};

// Base point A ordinate
static const u1 p256_au1PtA_Y[36] = {
0x00, 0x00, 0x00, 0x00, 0x4f, 0xe3, 0x42, 0xe2, 0xfe, 0x1a, 0x7f, 0x9b,
0x8e, 0xe7, 0xeb, 0x4a, 0x7c, 0x0f, 0x9e, 0x16, 0x2b, 0xce, 0x33, 0x57,
0x6b, 0x31, 0x5e, 0xce, 0xcb, 0xb6, 0x40, 0x68, 0x37, 0xbf, 0x51, 0xf5
};

// Base point A height
static const u1 p256_au1PtA_Z[36] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01
};

// OrderPointBase
static const u1 p256_au1OrderPoint[36] = {
0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00,
0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbc, 0xe6, 0xfa, 0xad,
0xa7, 0x17, 0x9e, 0x84, 0xf3, 0xb9, 0xca, 0xc2, 0xfc, 0x63, 0x25, 0x51
};

// Reduction constant
static const u1 p256_au1Cns[40] = {
0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFE,
0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,
0x00, 0x00, 0x00, 0x05
};

// "b" parameter in curve equation
// x^3 = x^2 + a*x + b
static const u1 p256_au1BCurve[36] = {
0x00, 0x00, 0x00, 0x00, 0x5a, 0xc6, 0x35, 0xd8, 0xaa, 0x3a, 0x93, 0xe7,
0xb3, 0xeb, 0xbd, 0x55, 0x76, 0x98, 0x86, 0xbc, 0x65, 0x1d, 0x06, 0xb0,
0xcc, 0x53, 0xb0, 0xf6, 0x3b, 0xce, 0x3c, 0x3e, 0x27, 0xd2, 0x60, 0x4b
};

// *****************************************************************************
/* 384-bit Elliptic Curve Parameters

  Summary:
    Recommended 384-bit Elliptic Curve Domain Parameters.
*/
// P = 2^384 - 2^224 +2^192 + 2^96 - 1
static const u1 p384_au1ModuloP[52] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,
0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0xFF, 0xFF, 0xFF, 0xFF
};

// "a" parameter in curve equation = -3
// x^3 = x^2 + a*x + b
static const u1 p384_au1ACurve[52] = {
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,
0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0xFF, 0xFF, 0xFF, 0xFC
};

// Base point A abscissa
static const u1 p384_au1PtA_X[52] = {
0x00, 0x00, 0x00, 0x00, 0xaa, 0x87, 0xca, 0x22, 0xbe, 0x8b, 0x05, 0x37,
0x8e, 0xb1, 0xc7, 0x1e, 0xf3, 0x20, 0xad, 0x74, 0x6e, 0x1d, 0x3b, 0x62,
0x8b, 0xa7, 0x9b, 0x98, 0x59, 0xf7, 0x41, 0xe0, 0x82, 0x54, 0x2a, 0x38,
0x55, 0x02, 0xf2, 0x5d, 0xbf, 0x55, 0x29, 0x6c, 0x3a, 0x54, 0x5e, 0x38,
0x72, 0x76, 0x0a, 0xb7
};

// Base point A ordinate
static const u1 p384_au1PtA_Y[52] = {
0x00, 0x00, 0x00, 0x00, 0x36, 0x17, 0xde, 0x4a, 0x96, 0x26, 0x2c, 0x6f,
0x5d, 0x9e, 0x98, 0xbf, 0x92, 0x92, 0xdc, 0x29, 0xf8, 0xf4, 0x1d, 0xbd,
0x28, 0x9a, 0x14, 0x7c, 0xe9, 0xda, 0x31, 0x13, 0xb5, 0xf0, 0xb8, 0xc0,
0x0a, 0x60, 0xb1, 0xce, 0x1d, 0x7e, 0x81, 0x9d, 0x7a, 0x43, 0x1d, 0x7c,
0x90, 0xea, 0x0e, 0x5f
};

// Base point A height
static const u1 p384_au1PtA_Z[52] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x01
};

// OrderPointBase
static const u1 p384_au1OrderPoint[52] = {
0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
0xff, 0xff, 0xff, 0xff, 0xc7, 0x63, 0x4d, 0x81, 0xf4, 0x37, 0x2d, 0xdf,
0x58, 0x1a, 0x0d, 0xb2, 0x48, 0xb0, 0xa7, 0x7a, 0xec, 0xec, 0x19, 0x6a,
0xcc, 0xc5, 0x29, 0x73
};

// Reduction constant
static const u1 p384_au1Cns[56] = {
0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00
};

// "b" parameter in curve equation
// x^3 = x^2 + a*x + b
static const u1 p384_au1BCurve[52] = {
0x00, 0x00, 0x00, 0x00, 0xb3, 0x31, 0x2f, 0xa7, 0xe2, 0x3e, 0xe7, 0xe4,
0x98, 0x8e, 0x05, 0x6b, 0xe3, 0xf8, 0x2d, 0x19, 0x18, 0x1d, 0x9c, 0x6e,
0xfe, 0x81, 0x41, 0x12, 0x03, 0x14, 0x08, 0x8f, 0x50, 0x13, 0x87, 0x5a,
0xc6, 0x56, 0x39, 0x8d, 0x8a, 0x2e, 0xd1, 0x9d, 0x2a, 0x85, 0xc8, 0xed,
0xd3, 0xec, 0x2a, 0xef
};

// *****************************************************************************
/* 521-bit Elliptic Curve Parameters

  Summary:
    Recommended 521-bit Elliptic Curve Domain Parameters.
*/
// P = 2^521-1
static const u1 p521_au1ModuloP[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};

// "a" parameter in curve equation = -3
// x^3 = x^2 + a*x + b
static const u1 p521_au1ACurve[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC
};

// Base point A abscissa
static const u1 p521_au1PtA_X[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc6, 0x85, 0x8e, 0x06, 0xb7, 0x04,
0x04, 0xe9, 0xcd, 0x9e, 0x3e, 0xcb, 0x66, 0x23, 0x95, 0xb4, 0x42, 0x9c, 0x64,
0x81, 0x39, 0x05, 0x3f, 0xb5, 0x21, 0xf8, 0x28, 0xaf, 0x60, 0x6b, 0x4d, 0x3d,
0xba, 0xa1, 0x4b, 0x5e, 0x77, 0xef, 0xe7, 0x59, 0x28, 0xfe, 0x1d, 0xc1, 0x27,
0xa2, 0xff, 0xa8, 0xde, 0x33, 0x48, 0xb3, 0xc1, 0x85, 0x6a, 0x42, 0x9b, 0xf9,
0x7e, 0x7e, 0x31, 0xc2, 0xe5, 0xbd, 0x66
};

// Base point A ordinate
static const u1 p521_au1PtA_Y[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x18, 0x39, 0x29, 0x6a, 0x78, 0x9a,
0x3b, 0xc0, 0x04, 0x5c, 0x8a, 0x5f, 0xb4, 0x2c, 0x7d, 0x1b, 0xd9, 0x98, 0xf5,
0x44, 0x49, 0x57, 0x9b, 0x44, 0x68, 0x17, 0xaf, 0xbd, 0x17, 0x27, 0x3e, 0x66,
0x2c, 0x97, 0xee, 0x72, 0x99, 0x5e, 0xf4, 0x26, 0x40, 0xc5, 0x50, 0xb9, 0x01,
0x3f, 0xad, 0x07, 0x61, 0x35, 0x3c, 0x70, 0x86, 0xa2, 0x72, 0xc2, 0x40, 0x88,
0xbe, 0x94, 0x76, 0x9f, 0xd1, 0x66, 0x50
};

// Base point A height
static const u1 p521_au1PtA_Z[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01
};

// OrderPointBase
static const u1 p521_au1OrderPoint[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
0xfa, 0x51, 0x86, 0x87, 0x83, 0xbf, 0x2f, 0x96, 0x6b, 0x7f, 0xcc, 0x01, 0x48,
0xf7, 0x09, 0xa5, 0xd0, 0x3b, 0xb5, 0xc9, 0xb8, 0x89, 0x9c, 0x47, 0xae, 0xbb,
0x6f, 0xb7, 0x1e, 0x91, 0x38, 0x64, 0x09
};

// Reduction constant
static const u1 p521_au1Cns[76] = {
0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

// "b" parameter in curve equation
// x^3 = x^2 + a*x + b
static const u1 p521_au1BCurve[72] = {
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x51, 0x95, 0x3e, 0xb9, 0x61, 0x8e,
0x1c, 0x9a, 0x1f, 0x92, 0x9a, 0x21, 0xa0, 0xb6, 0x85, 0x40, 0xee, 0xa2, 0xda,
0x72, 0x5b, 0x99, 0xb3, 0x15, 0xf3, 0xb8, 0xb4, 0x89, 0x91, 0x8e, 0xf1, 0x09,
0xe1, 0x56, 0x19, 0x39, 0x51, 0xec, 0x7e, 0x93, 0x7b, 0x16, 0x52, 0xc0, 0xbd,
0x3b, 0xb1, 0xbf, 0x07, 0x35, 0x73, 0xdf, 0x88, 0x3d, 0x2c, 0x34, 0xf1, 0xef,
0x45, 0x1f, 0xd4, 0x6b, 0x50, 0x3f, 0x00
};

// Self test state for initialization
static int8_t selfTestState = 0;

// *****************************************************************************
// *****************************************************************************
// Section: File Scope Functions
// *****************************************************************************
// *****************************************************************************

static int8_t lDRV_CRYPTO_ECC_SelfTest(void)
{
    // if (selfTestState != 0U)
    // {
    //     return selfTestState;
    // }
    
    /* Clear contents of CPKCL */
    (void) memset(&CPKCLParam, 0, sizeof(CPKCL_PARAM));
    
    pvCPKCLParam = &CPKCLParam;
    
    /* MISRA C-2012 deviation block start */
    /* MISRA C-2012 Rule 10.1, 11.1, 20.7 deviated below. Deviation record ID - 
       H3_MISRAC_2012_R_10_1_DR_1 & H3_MISRAC_2012_R_11_1_DR_1 & H3_MISRAC_2012_R_20_7_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block \
(deviate:2 "MISRA C-2012 Rule 10.1" "H3_MISRAC_2012_R_10_1_DR_1" )\
(deviate:1 "MISRA C-2012 Rule 11.1" "H3_MISRAC_2012_R_11_1_DR_1" )\
(deviate:1 "MISRA C-2012 Rule 20.7" "H3_MISRAC_2012_R_20_7_DR_1" )
</#if>
    vCPKCL_Process(SelfTest, pvCPKCLParam);
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.1"
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.1"
#pragma coverity compliance end_block "MISRA C-2012 Rule 20.7"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
    /* MISRA C-2012 deviation block end */
    
    if (CPKCL(u2Status) != (unsigned)CPKCL_OK)
    {
	selfTestState = -1;
    }
    else if (pvCPKCLParam->P.CPKCL_SelfTest_s.u4Version != (unsigned)CPKCL_VERSION)
    {
        selfTestState = -2;
    }
    else if (pvCPKCLParam->P.CPKCL_SelfTest_s.u4CheckNum1 != (unsigned)CPKCL_SELFTEST_CHECKSUM1)
    {
        selfTestState = -3;
    }
    else if (pvCPKCLParam->P.CPKCL_SelfTest_s.u4CheckNum2 != (unsigned)CPKCL_SELFTEST_CHECKSUM2)
    {
        selfTestState = -4;
    }
    else if (pvCPKCLParam->P.CPKCL_SelfTest_s.u1Step != 0x03U)
    {
        selfTestState = -5;
    }
    else
    {
        selfTestState = 1;
    }
    
    return selfTestState;
}

// *****************************************************************************
// *****************************************************************************
// Section: CPKCL Common Interface Implementation
// *****************************************************************************
// *****************************************************************************

CRYPTO_CPKCL_RESULT DRV_CRYPTO_ECC_InitCpkcl(void)
{
    /* Wait end of CPKCC RAM initialization */ 
    while ((CPKCCSR & (unsigned int)BIT_CPKCCSR_CLRRAM_BUSY) != 0U)
    {
        ;
    }
  
    /* Perform self test */
    if (lDRV_CRYPTO_ECC_SelfTest() < 0)
    {
        return CRYPTO_CPKCL_RESULT_INIT_ERROR;
    }
    
    return CRYPTO_CPKCL_RESULT_INIT_SUCCESS;
}

CRYPTO_CPKCL_RESULT DRV_CRYPTO_ECC_InitCurveParams(CPKCL_ECC_DATA *pEcc, 
    CRYPTO_CPKCL_CURVE curveType)
{
    CRYPTO_CPKCL_RESULT result = CRYPTO_CPKCL_RESULT_CURVE_SUCCESS;
    
     switch (curveType)
    {
         case CRYPTO_CPKCL_CURVE_P192:
            pEcc->u2ModuloPSize = sizeof(p192_au1ModuloP) - 4U;
            pEcc->u2OrderSize = sizeof(p192_au1OrderPoint) - 4U;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 8. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1ModuloP = (pfu1) p192_au1ModuloP;
            pEcc->pfu1ACurve = (pfu1) p192_au1ACurve;
            pEcc->pfu1APointX = (pfu1) p192_au1PtA_X;
            pEcc->pfu1APointY = (pfu1) p192_au1PtA_Y;
            pEcc->pfu1APointZ = (pfu1) p192_au1PtA_Z;
            pEcc->pfu1APointOrder = (pfu1) p192_au1OrderPoint;
            pEcc->pfu1Cns = (pfu1) p192_au1Cns;
            pEcc->pfu1BCurve = (pfu1) p192_au1BCurve;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
        
         case CRYPTO_CPKCL_CURVE_P224:
            pEcc->u2ModuloPSize = sizeof(p224_au1ModuloP) - 4U;
            pEcc->u2OrderSize = sizeof(p224_au1OrderPoint) - 4U;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 8. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1ModuloP = (pfu1) p224_au1ModuloP;
            pEcc->pfu1ACurve = (pfu1) p224_au1ACurve;
            pEcc->pfu1APointX = (pfu1) p224_au1PtA_X;
            pEcc->pfu1APointY = (pfu1) p224_au1PtA_Y;
            pEcc->pfu1APointZ = (pfu1) p224_au1PtA_Z;
            pEcc->pfu1APointOrder = (pfu1) p224_au1OrderPoint;
            pEcc->pfu1Cns = (pfu1) p224_au1Cns;
            pEcc->pfu1BCurve = (pfu1) p224_au1BCurve;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;   
            
        case CRYPTO_CPKCL_CURVE_P256:
            pEcc->u2ModuloPSize = sizeof(p256_au1ModuloP) - 4U;
            pEcc->u2OrderSize = sizeof(p256_au1OrderPoint) - 4U;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 8. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>            
            pEcc->pfu1ModuloP = (pfu1) p256_au1ModuloP;
            pEcc->pfu1ACurve = (pfu1) p256_au1ACurve;
            pEcc->pfu1APointX = (pfu1) p256_au1PtA_X;
            pEcc->pfu1APointY = (pfu1) p256_au1PtA_Y;
            pEcc->pfu1APointZ = (pfu1) p256_au1PtA_Z;
            pEcc->pfu1APointOrder = (pfu1) p256_au1OrderPoint;
            pEcc->pfu1Cns = (pfu1) p256_au1Cns;
            pEcc->pfu1BCurve = (pfu1) p256_au1BCurve;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
        
        case CRYPTO_CPKCL_CURVE_P384:
            pEcc->u2ModuloPSize = sizeof(p384_au1ModuloP) - 4U;
            pEcc->u2OrderSize = sizeof(p384_au1OrderPoint) - 4U;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 8. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1ModuloP = (pfu1) p384_au1ModuloP;
            pEcc->pfu1ACurve = (pfu1) p384_au1ACurve;
            pEcc->pfu1APointX = (pfu1) p384_au1PtA_X;
            pEcc->pfu1APointY = (pfu1) p384_au1PtA_Y;
            pEcc->pfu1APointZ = (pfu1) p384_au1PtA_Z;
            pEcc->pfu1APointOrder = (pfu1) p384_au1OrderPoint;
            pEcc->pfu1Cns = (pfu1) p384_au1Cns;
            pEcc->pfu1BCurve = (pfu1) p384_au1BCurve;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
        
        case CRYPTO_CPKCL_CURVE_P521:
            pEcc->u2ModuloPSize = sizeof(p521_au1ModuloP) - 4U;
            pEcc->u2OrderSize = sizeof(p521_au1OrderPoint) - 4U;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 8. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1ModuloP = (pfu1) p521_au1ModuloP;
            pEcc->pfu1ACurve = (pfu1) p521_au1ACurve;
            pEcc->pfu1APointX = (pfu1) p521_au1PtA_X;
            pEcc->pfu1APointY = (pfu1) p521_au1PtA_Y;
            pEcc->pfu1APointZ = (pfu1) p521_au1PtA_Z;
            pEcc->pfu1APointOrder = (pfu1) p521_au1OrderPoint;
            pEcc->pfu1Cns = (pfu1) p521_au1Cns;
            pEcc->pfu1BCurve = (pfu1) p521_au1BCurve;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
        
        default:  
            result = CRYPTO_CPKCL_RESULT_CURVE_ERROR;
            break;
    }
    
    return result;
}

CRYPTO_CPKCL_RESULT DRV_CRYPTO_ECC_SetPubKeyCoordinates(CPKCL_ECC_DATA *pEcc,
    pfu1 pubKey, pfu1 pubKeyX, pfu1 pubKeyY, CRYPTO_CPKCL_CURVE curveType)
{
    CRYPTO_CPKCL_RESULT result = CRYPTO_CPKCL_RESULT_CURVE_SUCCESS;
    uint8_t i;
    uint8_t keySize;
    uint8_t coordSize;
    
    /* Compressed keys not supported */
    if (pubKey[0] != 0x04U) 
    {
        return CRYPTO_CPKCL_RESULT_COORD_COMPRESS_ERROR;
    }

    switch (curveType)
    {
        case CRYPTO_CPKCL_CURVE_P192:
            keySize = (uint8_t)P192_PUBLIC_KEY_SIZE;
            coordSize = (uint8_t)P192_PUBLIC_KEY_COORDINATE_SIZE;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1PublicKeyZ = (pfu1) p192_au1PtA_Z;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
         
        case CRYPTO_CPKCL_CURVE_P224:
            keySize = (uint8_t)P224_PUBLIC_KEY_SIZE;
            coordSize = (uint8_t)P224_PUBLIC_KEY_COORDINATE_SIZE;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1PublicKeyZ = (pfu1) p224_au1PtA_Z;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
            
        case CRYPTO_CPKCL_CURVE_P256:
            keySize = (uint8_t)P256_PUBLIC_KEY_SIZE;
            coordSize = (uint8_t)P256_PUBLIC_KEY_COORDINATE_SIZE;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1PublicKeyZ = (pfu1) p256_au1PtA_Z;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;    
        
        case CRYPTO_CPKCL_CURVE_P384:
            keySize = (uint8_t)P384_PUBLIC_KEY_SIZE;
            coordSize = (uint8_t)P384_PUBLIC_KEY_COORDINATE_SIZE;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1PublicKeyZ = (pfu1) p384_au1PtA_Z;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
            
        case CRYPTO_CPKCL_CURVE_P521:
            keySize = (uint8_t)P521_PUBLIC_KEY_SIZE;
            coordSize = (uint8_t)P521_PUBLIC_KEY_COORDINATE_SIZE;
            /* MISRA C-2012 deviation block start */
            /* MISRA C-2012 Rule 11.8 deviated: 1. Deviation record ID - H3_MISRAC_2012_R_11_8_DR_1 */
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
</#if>
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.8" "H3_MISRAC_2012_R_11_8_DR_1"
</#if>
            pEcc->pfu1PublicKeyZ = (pfu1) p521_au1PtA_Z;
<#if core.COVERITY_SUPPRESS_DEVIATION?? && core.COVERITY_SUPPRESS_DEVIATION>
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.8"
<#if core.COMPILER_CHOICE == "XC32">
#pragma GCC diagnostic pop
</#if>
</#if>
            /* MISRA C-2012 deviation block end */
            break;
        
        default:  
            result = CRYPTO_CPKCL_RESULT_CURVE_ERROR;
            break;
    }
   
    if (result != CRYPTO_CPKCL_RESULT_CURVE_SUCCESS)
    { 
        return result;
    }
    
    /* Split coordinates */
    for (i = 0; i < keySize; i++)
    {
        if (i < coordSize)
        {
            pubKeyX[i] = pubKey[i + 1U];
        }
        else
        {
            pubKeyY[i - coordSize] = pubKey[i + 1U];
        }
    }
    
    return CRYPTO_CPKCL_RESULT_CURVE_SUCCESS;
}
    
void DRV_CRYPTO_ECC_SecureCopy(pu1 pu1Dest, pu1 pu1Src, u2 u2Length)
{   
    u2 u2Cpt;
    pu1 pu1PtrDest;

    /* Clean out the destination */
    (void) memset(pu1Dest, 0, u2Length);
    
    u2Cpt = 0;
    pu1PtrDest = pu1Dest;
    while (u2Cpt < u2Length) 
    {
        *(pu1PtrDest++) = pu1Src[u2Length - u2Cpt - 1U];
        u2Cpt++;
    }
}
