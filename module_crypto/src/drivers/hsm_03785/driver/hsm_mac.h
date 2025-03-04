/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_mac.h

  @Summary

  @Description
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

#ifndef HSM_MAC_H
#define HSM_MAC_H
#include "hsm_common.h"

typedef struct
{
	uint8_t reserved1       :8; //Reserved
	uint8_t varSlotNum      :8;  //Can variable slot be negative ??
	uint16_t reserved2      :16; //Reserved
}st_Hsm_Mac_AesCmac_Param2;

typedef struct
{
    uint8_t authSize        :3;
    uint8_t reserved1       :1;
    uint8_t nonceSize       :3;
	uint32_t reserved2      :25; //Reserved
}st_Hsm_Aead_AesCcm_Param2;

typedef struct
{
	st_Hsm_MailBoxHeader            mailBoxHdr_st;
	st_Hsm_Mac_AesCmac_CmdHeader	aesCmdHeader_st;
	st_Hsm_SgDmaDescriptor          inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor          outSgDmaDes_st;
	uint32_t                        inputDataLenParm1;
	st_Hsm_Mac_AesCmac_Param2       aesCmacCmdParm2_st;
}st_Hsm_Mac_AesCmac_Cmd;

typedef struct
{
	st_Hsm_MailBoxHeader            mailBoxHdr_st;
	st_Hsm_Aead_AesCcm_CmdHeader	aesCmdHeader_st;
	st_Hsm_SgDmaDescriptor          inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor          outSgDmaDes_st;
	uint32_t                        inputDataLenParm1;
	st_Hsm_Aead_AesCcm_Param2       aesCcmCmdParm2_st;
}st_Hsm_Aead_AesCcm_Cmd;
#endif /* HSM_MAC_H */
