/**************************************************************************
  Crypto Framework Library Source

  Company:
    Microchip Technology Inc.

  File Name:
    drv_crypto_ecc_hw_cpkcl.h

  Summary:
    Crypto Framework Library header file for hardware Cryptography.

  Description:
    This file provides the memory mapping to interface with the CPKCC 
    module. It also includes common functions to handle the interface and 
    the definitions of curves.
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

#ifndef DRV_CRYPTO_ECC_HW_CPKCL_H
#define DRV_CRYPTO_ECC_HW_CPKCL_H

// *****************************************************************************
// *****************************************************************************
// Section: Included Files
// *****************************************************************************
// *****************************************************************************

#include <stdint.h>
#include "../cpkcl_lib/cryptolib_typedef_pb.h"
#include "../cpkcl_lib/cryptolib_headers_pb.h"

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif
// DOM-IGNORE-END
        
// *****************************************************************************
// *****************************************************************************
// Section: Extern Declarations
// *****************************************************************************
// *****************************************************************************

extern PCPKCL_PARAM    pvCPKCLParam;
extern CPKCL_PARAM     CPKCLParam;

// *****************************************************************************
// *****************************************************************************
// Section: Macro Definitions
// *****************************************************************************
// *****************************************************************************

//******************************************************************************
// Memory mapping for ECC scalar multiplication
//******************************************************************************
#define BASE_SCA_MUL_MODULO(a,b)        (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_SCA_MUL_CNS(a,b)           (BASE_SCA_MUL_MODULO(a,b) + a + 4)
#define BASE_SCA_MUL_POINT_A(a,b)       (BASE_SCA_MUL_CNS(a,b) + a + 12)
#define BASE_SCA_MUL_POINT_A_X(a,b)     (BASE_SCA_MUL_POINT_A(a,b))
#define BASE_SCA_MUL_POINT_A_Y(a,b)     (BASE_SCA_MUL_POINT_A_X(a,b) + a + 4)
#define BASE_SCA_MUL_POINT_A_Z(a,b)     (BASE_SCA_MUL_POINT_A_Y(a,b) + a + 4)
#define BASE_SCA_MUL_A(a,b)             (BASE_SCA_MUL_POINT_A_Z(a,b) + a + 4 + 8)
#define BASE_SCA_MUL_SCALAR(a,b)        (BASE_SCA_MUL_A(a,b) + a + 4)
#define BASE_SCA_MUL_ORDER(a,b)         (BASE_SCA_MUL_SCALAR(a,b) + b + 4)
#define BASE_SCA_MUL_WORKSPACE(a,b)     (BASE_SCA_MUL_ORDER(a,b) + b + 4)

//******************************************************************************
// Memory mapping for ECDSA signature
//******************************************************************************
#define BASE_ECDSA_MODULO(a,b)          (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_ECDSA_CNS(a,b)             (BASE_ECDSA_MODULO(a,b) + a + 4)
#define BASE_ECDSA_POINT_A(a,b)         (BASE_ECDSA_CNS(a,b) + b + 12)
#define BASE_ECDSA_POINT_A_X(a,b)       (BASE_ECDSA_POINT_A(a,b))
#define BASE_ECDSA_POINT_A_Y(a,b)       (BASE_ECDSA_POINT_A_X(a,b) + a + 4)
#define BASE_ECDSA_POINT_A_Z(a,b)       (BASE_ECDSA_POINT_A_Y(a,b) + a + 4)
#define BASE_ECDSA_A(a,b)               (BASE_ECDSA_POINT_A_Z(a,b) + a + 4)
#define BASE_PRIVATE_KEY(a,b)           (BASE_ECDSA_A(a,b) + a + 4)
#define BASE_ECDSA_SCALAR(a,b)          (BASE_PRIVATE_KEY(a,b) + b + 4)
#define BASE_ECDSA_ORDER(a,b)           (BASE_ECDSA_SCALAR(a,b) + b + 4)
#define BASE_ECDSA_HASH(a,b)            (BASE_ECDSA_ORDER(a,b) + b + 4)
#define BASE_ECDSA_WORKSPACE(a,b)       (BASE_ECDSA_HASH(a,b) + b + 4)

//******************************************************************************
// Memory mapping for ECDSA signature verification
//******************************************************************************
#define BASE_ECDSAV_MODULO(a,b)         (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_ECDSAV_CNS(a,b)            (BASE_ECDSAV_MODULO(a,b) + a + 4)
#define BASE_ECDSAV_ORDER(a,b)          (BASE_ECDSAV_CNS(a,b) + b + 12)
#define BASE_ECDSAV_SIGNATURE(a,b)      (BASE_ECDSAV_ORDER(a,b) + b + 12)
#define BASE_ECDSAV_HASH(a,b)           (BASE_ECDSAV_SIGNATURE(a,b) + 2*b + 8)
#define BASE_ECDSAV_POINT_A(a,b)        (BASE_ECDSAV_HASH(a,b) + b + 4)
#define BASE_ECDSAV_POINT_A_X(a,b)      (BASE_ECDSAV_POINT_A(a,b))
#define BASE_ECDSAV_POINT_A_Y(a,b)      (BASE_ECDSAV_POINT_A_X(a,b) + a + 4)
#define BASE_ECDSAV_POINT_A_Z(a,b)      (BASE_ECDSAV_POINT_A_Y(a,b) + a + 4)
#define BASE_ECDSAV_PUBLIC_KEY(a,b)     (BASE_ECDSAV_POINT_A_Z(a,b) + a + 4)
#define BASE_ECDSAV_PUBLIC_KEY_X(a,b)   (BASE_ECDSAV_PUBLIC_KEY(a,b))
#define BASE_ECDSAV_PUBLIC_KEY_Y(a,b)   (BASE_ECDSAV_PUBLIC_KEY_X(a,b) + a + 4)
#define BASE_ECDSAV_PUBLIC_KEY_Z(a,b)   (BASE_ECDSAV_PUBLIC_KEY_Y(a,b) + a + 4)
#define BASE_ECDSAV_A(a,b)              (BASE_ECDSAV_PUBLIC_KEY_Z(a,b) + a + 4)
#define BASE_ECDSAV_WORKSPACE(a,b)      (BASE_ECDSAV_A(a,b) + a + 4)

//******************************************************************************
// Memory mapping for ECDH key agreement
//******************************************************************************
#define BASE_ECDH_MODULO(a,b)           (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_ECDH_CNS(a,b)              (BASE_ECDSAV_MODULO(a,b) + a + 4)
#define BASE_ECDH_POINT_Ab              (BASE_ECDSAV_CNS(a,b) + b + 12)
#define BASE_ECDH_POINT_A_X(a,b)        (BASE_ECDSAV_POINT_A(a,b))
#define BASE_ECDH_POINT_A_Y(a,b)        (BASE_ECDSAV_POINT_A_X(a,b) + a + 4)
#define BASE_ECDH_POINT_A_Z(a,b)        (BASE_ECDSAV_POINT_A_Y(a,b) + a + 4)
#define BASE_ECDH_A(a,b)                (BASE_ECDSAV_POINT_A_Z(a,b) + a + 4)
#define BASE_ECDH_SCALAR(a,b)           (BASE_ECDH_A(a,b) + a + 4)
#define BASE_ECDH_ORDER(a,b)            (BASE_ECDH_SCALAR(a,b) + b + 4)
#define BASE_ECDH_WORKSPACE(a,b)        (BASE_ECDH_ORDER(a,b) + b + 4)

//******************************************************************************
// Memory mapping for conversion
//******************************************************************************
#define BASE_CONV_MODULO(a)             (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_CONV_CNS(a)                (BASE_CONV_MODULO(a) + a + 4)
#define BASE_CONV_POINT_A(a)            (BASE_CONV_CNS(a) + a + 8)
#define BASE_CONV_POINT_A_X(a)          (BASE_CONV_POINT_A(a))
#define BASE_CONV_POINT_A_Y(a)          (BASE_CONV_POINT_A_X(a) + a + 4)
#define BASE_CONV_POINT_A_Z(a)          (BASE_CONV_POINT_A_Y(a) + a + 4)
#define BASE_CONV_RANDOM(a)             (BASE_CONV_POINT_A_Z(a) + a + 4)
#define BASE_CONV_A(a)                  (BASE_CONV_RANDOM(a) + a + 4)
#define BASE_CONV_B(a)                  (BASE_CONV_A(a) + a + 4)
#define BASE_CONV_WORKSPACE(a)          (BASE_CONV_B(a) + a + 4)

//******************************************************************************
// Memory mapping for doubling
//******************************************************************************
#define BASE_DOUBLING_MODULO(a)         (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_DOUBLING_CNS(a)            (BASE_DOUBLING_MODULO(a) + a + 4)
#define BASE_DOUBLING_POINT_A(a)        (BASE_DOUBLING_CNS(a) + a + 8)
#define BASE_DOUBLING_POINT_A_X(a)      (BASE_DOUBLING_POINT_A(a))
#define BASE_DOUBLING_POINT_A_Y(a)      (BASE_DOUBLING_POINT_A_X(a) + a + 4)
#define BASE_DOUBLING_POINT_A_Z(a)      (BASE_DOUBLING_POINT_A_Y(a) + a + 4)
#define BASE_DOUBLING_A(a)              (BASE_DOUBLING_POINT_A_Z(a) + a + 4)
#define BASE_DOUBLING_WORKSPACE(a)      (BASE_DOUBLING_A(a) + a + 4)

//******************************************************************************
// Memory mapping for addition
//******************************************************************************
#define BASE_ADDITION_MODULO(a)         (MSB_EXTENT_CRYPTORAM | nu1CRYPTORAM_BASE)
#define BASE_ADDITION_CNS(a)            (BASE_ADDITION_MODULO(a) + a + 4)
#define BASE_ADDITION_POINT_A(a)        (BASE_ADDITION_CNS(a) + a + 8)
#define BASE_ADDITION_POINT_A_X(a)      (BASE_ADDITION_POINT_A(a))
#define BASE_ADDITION_POINT_A_Y(a)      (BASE_ADDITION_POINT_A_X(a) + a + 4)
#define BASE_ADDITION_POINT_A_Z(a)      (BASE_ADDITION_POINT_A_Y(a) + a + 4)
#define BASE_ADDITION_POINT_B(a)        (BASE_ADDITION_POINT_A_Z(a) + a + 4)
#define BASE_ADDITION_POINT_B_X(a)      (BASE_ADDITION_POINT_B(a))
#define BASE_ADDITION_POINT_B_Y(a)      (BASE_ADDITION_POINT_B_X(a) + a + 4)
#define BASE_ADDITION_POINT_B_Z(a)      (BASE_ADDITION_POINT_B_Y(a) + a + 4)
#define BASE_ADDITION_WORKSPACE(a)      (BASE_ADDITION_POINT_B_Z(a) + a + 4)

// *****************************************************************************
// Size of ECC public keys
// *****************************************************************************

#define P192_PUBLIC_KEY_SIZE      48
#define P224_PUBLIC_KEY_SIZE      56
#define P256_PUBLIC_KEY_SIZE      64
#define P384_PUBLIC_KEY_SIZE      96
#define P521_PUBLIC_KEY_SIZE      132

// *****************************************************************************
// Size of ECC coordinates for public keys
// *****************************************************************************

#define P192_PUBLIC_KEY_COORDINATE_SIZE      24
#define P224_PUBLIC_KEY_COORDINATE_SIZE      28
#define P256_PUBLIC_KEY_COORDINATE_SIZE      32
#define P384_PUBLIC_KEY_COORDINATE_SIZE      48
#define P521_PUBLIC_KEY_COORDINATE_SIZE      66

// *****************************************************************************
// *****************************************************************************
// Section: Data Types
// *****************************************************************************
// *****************************************************************************

/* Result of CPKCL operation */
typedef enum 
{
    CRYPTO_CPKCL_RESULT_INIT_SUCCESS,
    CRYPTO_CPKCL_RESULT_INIT_ERROR,    
    CRYPTO_CPKCL_RESULT_CURVE_SUCCESS,        
    CRYPTO_CPKCL_RESULT_CURVE_ERROR,
    CRYPTO_CPKCL_RESULT_COORD_SUCCESS,
    CRYPTO_CPKCL_RESULT_COORD_COMPRESS_ERROR,
} CRYPTO_CPKCL_RESULT;

/* Curve Types */
typedef enum 
{
    /* Prime Curves */
    /* Weierstrass Curves */
    CRYPTO_CPKCL_CURVE_P192 = 1,     
    CRYPTO_CPKCL_CURVE_P224 = 2,
    CRYPTO_CPKCL_CURVE_P256 = 3,        
    CRYPTO_CPKCL_CURVE_P384 = 4,
    CRYPTO_CPKCL_CURVE_P521 = 5, 
} CRYPTO_CPKCL_CURVE;

// *****************************************************************************
/* ECC Data

  Summary:
    Structure to hold ECC data.
    
  Remarks:
    Data pointed by this structure is in MSB mode with 4 "0" bytes padding on 
    the MSB side.
*/
typedef struct
{
    // Prime P
    pfu1 pfu1ModuloP;

    // Size of modulo P
    u2 u2ModuloPSize;

    // Size of the order n
    u2 u2OrderSize;

    // "a" parameter in curve equation
    // x^3 = x^2 + a*x + b
    pfu1 pfu1ACurve;

    // "b" parameter in curve equation
    // x^3 = x^2 + a*x + b
    pfu1 pfu1BCurve;

    // Abscissa of the base point of the curve
    pfu1 pfu1APointX;

    // Ordinate of the base point of the curve
    pfu1 pfu1APointY;

    // Height of the base point of the curve
    pfu1 pfu1APointZ;

    // Abscissa of second point for addition
    pfu1 pfu1BPointX;

    // Ordinate of second point for addition
    pfu1 pfu1BPointY;

    // Height of second point for addition
    pfu1 pfu1BPointZ;

    // Order of the curve
    pfu1 pfu1APointOrder;

    // Private key
    pfu1 pfu1PrivateKey;

    // Abscissa of public key
    pfu1 pfu1PublicKeyX;

    // Ordinate of public key
    pfu1 pfu1PublicKeyY;

    // Height of public key
    pfu1 pfu1PublicKeyZ;

    // Reduction constant
    pfu1 pfu1Cns;

    // Random number
    pfu1 pfu1RandomNumber;

    // Hash Value
    pfu1 pfu1HashValue;
} CPKCL_ECC_DATA;

// *****************************************************************************
// *****************************************************************************
// Section: CPKCL Common Interface 
// *****************************************************************************
// *****************************************************************************

CRYPTO_CPKCL_RESULT DRV_CRYPTO_ECC_InitCpkcl(void);

CRYPTO_CPKCL_RESULT DRV_CRYPTO_ECC_InitCurveParams(CPKCL_ECC_DATA *pEcc, 
    CRYPTO_CPKCL_CURVE curveType);
    
CRYPTO_CPKCL_RESULT DRV_CRYPTO_ECC_SetPubKeyCoordinates(CPKCL_ECC_DATA *pEcc,
    pfu1 pubKey, pfu1 pubKeyX, pfu1 pubKeyY, CRYPTO_CPKCL_CURVE curveType);
    
void DRV_CRYPTO_ECC_SecureCopy(pu1 pu1Dest, pu1 pu1Src, u2 u2Length);

// DOM-IGNORE-BEGIN
#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif
// DOM-IGNORE-END

#endif /* DRV_CRYPTO_ECC_HW_CPKCL_H */
