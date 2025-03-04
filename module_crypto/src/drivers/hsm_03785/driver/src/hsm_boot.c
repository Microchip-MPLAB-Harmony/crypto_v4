/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_boot.c

  @Summary
    Common Cmd function for HSM

  @Description
   Common Cmd function for HSM

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
#include "stdio.h"
#include "crypto/drivers/driver/hsm_boot.h"
#include "crypto/drivers/driver/hsm_common.h"
#include "string.h"
#include "crypto/drivers/driver/hsm_cmd.h"

static hsm_Cmd_Status_E Hsm_Boot_LoadBootFirmware(void)
{
    st_Hsm_ResponseCmd bootCmdResponse_st;
    st_Hsm_SendCmdLayout bootSendCmd_st;
    hsm_Cmd_Status_E ret_cmdStat_en;
    st_Hsm_Boot_LoadFimwareCmd bootLoadFirmware_st[1];
    // st_Hsm_SgDmaDescriptor *cmddes_st = 0x00000000;
    st_Hsm_Boot_LoadFimwareCmd *ptr_loadFimrwareCmd_st = bootLoadFirmware_st;
    
    //Mailbox Header
    ptr_loadFimrwareCmd_st->mailBoxHdr_st.msgSize = 0x14;       // 0x14 for one metadata pointer, 0x18 for two
    ptr_loadFimrwareCmd_st->mailBoxHdr_st.unProtection = 0x1;
    ptr_loadFimrwareCmd_st->mailBoxHdr_st.reserved1 = 0x00;
    ptr_loadFimrwareCmd_st->mailBoxHdr_st.reserved2 = 0x00;
   
    //Command Header
    ptr_loadFimrwareCmd_st->cmdHeader_st.bootCmdGroup_en = HSM_CMD_BOOT;
    ptr_loadFimrwareCmd_st->cmdHeader_st.bootCmdType_en = HSM_CMD_BOOT_LOADFIRMWARE;
    ptr_loadFimrwareCmd_st->cmdHeader_st.bootAuthInc = 0x00;
    ptr_loadFimrwareCmd_st->cmdHeader_st.bootSlotParamInc = 0x00;
    ptr_loadFimrwareCmd_st->cmdHeader_st.reserved1 = 0x00;
    ptr_loadFimrwareCmd_st->cmdHeader_st.reserved2 = 0x00;

    //Parameter 1: Pointer to Firmware Meta Data #0
    ptr_loadFimrwareCmd_st->metaData0Parm1 = HSM_BOOT_FIRMWARE_INIT_ADDR;
    
    //Parameter 2: Pointer to Firmware Meta Data #1
    ptr_loadFimrwareCmd_st->metaData1Parm2 = 0x00000000UL;      // Not being sent when msgSize = 0x14 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    bootSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_loadFimrwareCmd_st->mailBoxHdr_st;
    bootSendCmd_st.algocmdHdr = (uint32_t*)&ptr_loadFimrwareCmd_st->cmdHeader_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    bootSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)0x00000000;//ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st;
    bootSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)0x00000000;//ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st;
    bootSendCmd_st.ptr_params = (uint32_t*)&(ptr_loadFimrwareCmd_st->metaData0Parm1);
    bootSendCmd_st.paramsCount = (uint8_t) ((ptr_loadFimrwareCmd_st->mailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(bootSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&bootCmdResponse_st);

    //Check the command response with expected values for Boot Load Firmware Cmd
    ret_cmdStat_en = Hsm_Cmd_CheckCmdRespParms(bootCmdResponse_st,(*bootSendCmd_st.mailBoxHdr - 8UL), *bootSendCmd_st.algocmdHdr);
    
    return ret_cmdStat_en;
}

int Hsm_Boot_Initialization(void)
{
    int ret_status = 0x00;
    hsm_Cmd_Status_E initStat_en = HSM_CMD_ERROR_FAILED;
    
    //HSM Firmware image is loaded via .hex project to flash
    initStat_en = Hsm_Boot_LoadBootFirmware(); 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.4" "H3_MISRAC_2012_R_10_4_DR_1"    
    if( (initStat_en == HSM_CMD_SUCCESS) && (HSM_CMD_STATUS_PS == HSM_CMD_PS_OPERATIONAL))
    {
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.4"
#pragma GCC diagnostic pop        
        ret_status = 0x01;
        #ifdef HSM_PRINT 
        printf("\r\nHSM is Operational\n");
        #endif 
    }
    else
    {
        ret_status = 0x00;
        #ifdef HSM_PRINT
        printf("\r\nHSM waiting for Operational State");
        #endif
    }

    return ret_status;
}
   
int Hsm_Boot_GetStatus(void)
{
    int retStatus = 0x00;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.4" "H3_MISRAC_2012_R_10_4_DR_1"    
    if( ((bool) ((HSM_REGS->HSM_STATUS & HSM_STATUS_BUSY_Msk) >> HSM_STATUS_BUSY_Pos) == 0x00U) && (HSM_CMD_STATUS_PS == HSM_CMD_PS_OPERATIONAL))
    {
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.4"
#pragma GCC diagnostic pop         
        #ifdef HSM_PRINT
        printf("\r\nHSM is operation\r\n");
        #endif
        retStatus = 0x01;
    }
    return retStatus;
}
