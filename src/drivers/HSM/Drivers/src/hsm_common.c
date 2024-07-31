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

/* ************************************************************************** */
/* ************************************************************************** */
/* Section: Included Files                                                    */
/* ************************************************************************** */
/* ************************************************************************** */

#include "crypto/drivers/hsm_common.h"

st_Hsm_Vsm_Ecc_CurveData CurveData[HSM_ECC_MAX_CURVE] = 
{
    {HSM_ECC_CURVETYPE_P192, HSM_VSM_ASYMKEY_ECC_WCPRIME, 24, 24/*48*/},
    {HSM_ECC_CURVETYPE_P256, HSM_VSM_ASYMKEY_ECC_WCPRIME, 32, 32/*64*/},
    {HSM_ECC_CURVETYPE_P384, HSM_VSM_ASYMKEY_ECC_WCPRIME, 48, 48 /*96*/},
    {HSM_ECC_CURVETYPE_P521, HSM_VSM_ASYMKEY_ECC_WCPRIME, 66, 66 /*132*/},
};

int Hsm_Vsm_Ecc_FindCurveIndex(hsm_Ecc_CurveType_E curveType_en, uint8_t *ptr_index)
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
