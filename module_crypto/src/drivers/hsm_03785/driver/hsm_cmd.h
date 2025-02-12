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