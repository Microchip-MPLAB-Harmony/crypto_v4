/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_boot.h

  @Summary

  @Description
 */
/* ************************************************************************** */
#ifndef HSM_BOOT_H
#define HSM_BOOT_H

#include "hsm_common.h"

#define HSM_BOOT_FIRMWARE_INIT_ADDR (0x0c7df800)
#define HSM_BOOT_FIRMWARE_ADDR      (0x0c7e0000)

typedef enum
{
    HSM_CMD_BOOT_GETSBC   			= 0,
    HSM_CMD_BOOT_LOADFIRMWARE 		= 1,
    HSM_CMD_BOOT_PROCESSFIRMWARE	= 2,
    HSM_CMD_BOOT_FINALZESB			= 3,
    HSM_CMD_BOOT_SELFTEST			= 4,
}hsm_Boot_CmdTypes_E;

typedef struct
{
	hsm_CommandGroups_E bootCmdGroup_en     :8; 
    hsm_Boot_CmdTypes_E bootCmdType_en		:8;  
    uint8_t reserved1          				:8; //Reserved 1
    uint8_t bootAuthInc		      			:1; 
    uint8_t bootSlotParamInc				:1; 
    uint8_t	reserved2          				:6; //Reserved 2
}st_Hsm_Boot_CmdHeader;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_Boot_CmdHeader		cmdHeader_st;
    st_Hsm_SgDmaDescriptor      arr_bootInSgDmaDes_st[1] __attribute__((aligned(4)));
    st_Hsm_SgDmaDescriptor      arr_bootOutSgDmaDes_st[1]  __attribute__((aligned(4)));
	uint32_t					metaData0Parm1;
	uint32_t 					metaData1Parm2;
}st_Hsm_Boot_LoadFimwareCmd;


void Hsm_Boot_Intialisation(void);

#endif /* HSM_BOOT_H */