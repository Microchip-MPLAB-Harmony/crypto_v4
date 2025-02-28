/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_common.c

  @Summary
    AES 

  @Description
    AES  
 */
/* ************************************************************************** */

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

/* ************************************************************************** */
/* ************************************************************************** */
/* Section: Included Files                                                    */
/* ************************************************************************** */
/* ************************************************************************** */

#include "crypto/drivers/driver/hsm_common.h"

static st_Hsm_Vsm_Ecc_CurveData CurveData[HSM_ECC_MAX_CURVE] = 
{
    {HSM_ECC_CURVETYPE_P192, HSM_VSM_ASYMKEY_ECC_WCPRIME, 24, 24/*48*/},
    {HSM_ECC_CURVETYPE_P256, HSM_VSM_ASYMKEY_ECC_WCPRIME, 32, 32/*64*/},
    {HSM_ECC_CURVETYPE_P384, HSM_VSM_ASYMKEY_ECC_WCPRIME, 48, 48 /*96*/},
    {HSM_ECC_CURVETYPE_P521, HSM_VSM_ASYMKEY_ECC_WCPRIME, 66, 66 /*132*/},
};

static int Hsm_Vsm_Ecc_FindCurveIndex(hsm_Ecc_CurveType_E curveType_en, uint8_t *ptr_index)
{
    int ret_status = -1;
    uint8_t count = 0;

    for(count = 0; count < HSM_ECC_MAX_CURVE; count++)
    {
        if(curveType_en == CurveData[count].curveCurveType_en)
        {
            *ptr_index = count;
            ret_status = 0;
            break;
        }
    }
    return ret_status;
}

int Hsm_Vsm_Ecc_FillEccKeyProperties(st_Hsm_Vss_Ecc_AsymKeyDataType *ptr_eccKey_st, hsm_Ecc_CurveType_E curveType_en, hsm_Vsm_Asym_Ecc_PrivPubKeyType_E PrivPubkeyType,
                                                hsm_Vsm_Asym_Ecc_SignUsed_E eccSignUsed_en, hsm_Vsm_Asym_Ecc_AlgoUsed_E eccAlgoUsed_en)
{
    int curveIndexStatus = -1;
    uint8_t curveIndex = 0;
    int ret_status = -1;

    curveIndexStatus = Hsm_Vsm_Ecc_FindCurveIndex(curveType_en, &curveIndex);
    
    if(curveIndexStatus == 0)
    {
        //Public and Private ECC Key properties for data type
        ptr_eccKey_st->asymKeyType_en = HSM_VSM_ASYMKEY_ECC;
        ptr_eccKey_st->eccKeyType_en = CurveData[curveIndex].curveKeyType_en;
        
        ptr_eccKey_st->paramA = 0x00;
        ptr_eccKey_st->signUsed_en = eccSignUsed_en;  
        ptr_eccKey_st->algoUsed_en = eccAlgoUsed_en;
        ptr_eccKey_st->domainIncBit = 0x00;
 
        ret_status = 0;
        
        if(PrivPubkeyType == HSM_VSM_ASYMKEY_PRIVATEKEY)
        {
			ptr_eccKey_st->eccKeySize = CurveData[curveIndex].privKeySize;
            ptr_eccKey_st->publicKeyIncBit = 0x00;
            ptr_eccKey_st->privateKeyIncBit = 0x01;
        }
        else if(PrivPubkeyType == HSM_VSM_ASYMKEY_PUBLICKEY)
        {
			ptr_eccKey_st->eccKeySize = CurveData[curveIndex].pubKeySize;
            ptr_eccKey_st->publicKeyIncBit = 0x01;
            ptr_eccKey_st->privateKeyIncBit = 0x00; 
        }
        else
        {
          ret_status = -1;  
        }        
        
        ptr_eccKey_st->reserved1 = 0x00;
        ptr_eccKey_st->reserved2 = 0x00;
        ptr_eccKey_st->reserved3 = 0x00;
        ptr_eccKey_st->reserved4 = 0x00;
        ptr_eccKey_st->reserved5 = 0x00;
        ptr_eccKey_st->reserved6 = 0x00;
    }
    else
    {
        ret_status = -1;
    }
    
    return ret_status;
}