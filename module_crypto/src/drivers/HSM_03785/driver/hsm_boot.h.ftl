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

<#if HSM_BOOT_FIRMWARE_INIT_ADDR?has_content>
  <#lt>#define HSM_BOOT_FIRMWARE_INIT_ADDR  (${HSM_BOOT_FIRMWARE_INIT_ADDR})
</#if>
<#if HSM_BOOT_FIRMWARE_ADDR?has_content>
  <#lt>#define HSM_BOOT_FIRMWARE_ADDR       (${HSM_BOOT_FIRMWARE_ADDR})
</#if>

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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"
	hsm_CommandGroups_E bootCmdGroup_en     :8; 
    hsm_Boot_CmdTypes_E bootCmdType_en		:8;  
    uint8_t reserved1          				:8; //Reserved 1
    uint8_t bootAuthInc		      			:1; 
    uint8_t bootSlotParamInc				:1; 
    uint8_t	reserved2          				:6; //Reserved 2
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
#pragma GCC diagnostic pop
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

int Hsm_Boot_Intialisation(void);
int Hsm_Boot_GetStatus(void);
void Hsm_Initialsation(void);
#endif /* HSM_BOOT_H */