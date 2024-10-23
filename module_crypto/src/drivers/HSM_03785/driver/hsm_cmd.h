/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_cmd.h

  @Summary

  @Description
 */
/* ************************************************************************** */

#ifndef HSM_CMD_H
#define HSM_CMD_H

#include "hsm_common.h"
#include "device.h"
#define MBRXSTATUS_RXINT_MASK     (0x00100000UL)

#define HSM_CMD_STATUS_BUSY  ((HSM_REGS->HSM_STATUS & HSM_STATUS_BUSY_Msk) >> HSM_STATUS_BUSY_Pos)
#define HSM_CMD_STATUS_ECODE ((HSM_REGS->HSM_STATUS & HSM_STATUS_ECODE_Msk) >> HSM_STATUS_ECODE_Pos)
#define HSM_CMD_STATUS_SBS   ((HSM_REGS->HSM_STATUS & HSM_STATUS_SBS_Msk) >> HSM_STATUS_SBS_Pos)
#define HSM_CMD_STATUS_LCS   ((HSM_REGS->HSM_STATUS & HSM_STATUS_LCS_Msk) >> HSM_STATUS_LCS_Pos)
#define HSM_CMD_STATUS_PS    ((HSM_REGS->HSM_STATUS & HSM_STATUS_PS_Msk) >> HSM_STATUS_PS_Pos)




void HSM_Cmd_Send(st_Hsm_SendCmdLayout sendCmd_st);
void Hsm_Cmd_ReadCmdResponse(st_Hsm_ResponseCmd *response_st);
hsm_Cmd_Status_E Hsm_Cmd_CheckCmdRespParms(st_Hsm_ResponseCmd respParms_st, uint32_t expMailbox, uint32_t expCmdHeader); 

#endif /* HSM_CMD_H */