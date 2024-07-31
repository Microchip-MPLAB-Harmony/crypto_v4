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
