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

/* ************************************************************************** */
/* ************************************************************************** */
/* Section: Included Files                                                    */
/* ************************************************************************** */
/* ************************************************************************** */
#include "stdio.h"
#include "hsm_boot.h"
#include "hsm_common.h"
#include "string.h"
#include "hsm_cmd.h"

static hsm_Cmd_Status_E Hsm_Boot_LoadBootFirmware(void)
{
    st_Hsm_ResponseCmd bootCmdResponse_st;
    st_Hsm_SendCmdLayout bootSendCmd_st;
    hsm_Cmd_Status_E ret_cmdStat_en;
    st_Hsm_Boot_LoadFimwareCmd bootLoadFirmware_st[1];
//     st_Hsm_SgDmaDescriptor *cmddes_st = 0x00000000;
    st_Hsm_Boot_LoadFimwareCmd *ptr_loadFimrwareCmd_st = bootLoadFirmware_st;
    
    //Mailbox Header
    ptr_loadFimrwareCmd_st->mailBoxHdr_st.msgSize = 0x14; //0x18;
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
    
    //Input Descriptor : Not used in this Command
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st = cmddes_st;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].nextDes_st.stop = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.dataLen = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
  
    //Output Descriptor : Not used in this Command
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st = (st_Hsm_SgDmaDescriptor*)0x00000000;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].nextDes_st.stop = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Parameter 1: Pointer to Firmware Meta Data #0
    ptr_loadFimrwareCmd_st->metaData0Parm1 = HSM_BOOT_FIRMWARE_INIT_ADDR;
    //Parameter 2: Pointer to Firmware Meta Data #1
    ptr_loadFimrwareCmd_st->metaData1Parm2 = 0x00000000UL;
    
    bootSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_loadFimrwareCmd_st->mailBoxHdr_st;
    bootSendCmd_st.algocmdHdr = (uint32_t*)&ptr_loadFimrwareCmd_st->cmdHeader_st;
    bootSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)0x00000000;//ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st;
    bootSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)0x00000000;//ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st;
    bootSendCmd_st.ptr_params = (uint32_t*)&(ptr_loadFimrwareCmd_st->metaData0Parm1);
    bootSendCmd_st.paramsCount = (uint8_t) ((ptr_loadFimrwareCmd_st->mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(bootSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&bootCmdResponse_st);

    //Check the command response with expected values for Boot Load Firmware Cmd
    ret_cmdStat_en = Hsm_Cmd_CheckCmdRespParms(bootCmdResponse_st,(*bootSendCmd_st.mailBoxHdr-16), *bootSendCmd_st.algocmdHdr);
    
    return ret_cmdStat_en;
}

void Hsm_Boot_Intialisation(void)
{
    hsm_Cmd_Status_E initStat_en = HSM_CMD_ERROR_FAILED;
    uint8_t hsmFirmware[1024];
    //HSM Firmware image is loaded via .hex project to flash
    uint8_t *hsmFirmwareLoc = (uint8_t *) HSM_BOOT_FIRMWARE_INIT_ADDR; //0x0c7df800;
    memcpy(hsmFirmware, hsmFirmwareLoc, sizeof(hsmFirmware));

    hsmFirmwareLoc = (uint8_t *) HSM_BOOT_FIRMWARE_ADDR; //0x0c7e0000;
    memcpy(hsmFirmware, hsmFirmwareLoc, sizeof(hsmFirmware));
    
    initStat_en = Hsm_Boot_LoadBootFirmware();
    
    if( (initStat_en == HSM_CMD_SUCCESS) && (HSM_CMD_STATUS_PS == HSM_CMD_PS_OPERATIONAL))
    {
        printf("\r\nHSM is Operation\n");
    }
}



//hsm_Cmd_Status_E Hsm_Boot_SelfTest(void)
//{
//    st_Hsm_ResponseCmd bootCmdResponse_st;
//    st_Hsm_SendCmdLayout bootSendCmd_st;
//    hsm_Cmd_Status_E ret_cmdStat_en;
//    st_Hsm_Boot_LoadFimwareCmd bootLoadFirmware_st[1];
//     
//    st_Hsm_Boot_LoadFimwareCmd *ptr_loadFimrwareCmd_st = bootLoadFirmware_st;
//    
//    //Mailbox Header
//    ptr_loadFimrwareCmd_st->mailBoxHdr_st.msgSize = 0x14;
//    ptr_loadFimrwareCmd_st->mailBoxHdr_st.unProtection = 0x1;
//    ptr_loadFimrwareCmd_st->mailBoxHdr_st.reserved1 = 0x00;
//    ptr_loadFimrwareCmd_st->mailBoxHdr_st.reserved2 = 0x00;
//   
//    //Command Header
//    ptr_loadFimrwareCmd_st->cmdHeader_st.bootCmdGroup_en = HSM_CMD_BOOT;
//    ptr_loadFimrwareCmd_st->cmdHeader_st.bootCmdType_en = HSM_CMD_BOOT_SELFTEST;
//    ptr_loadFimrwareCmd_st->cmdHeader_st.bootAuthInc = 0x00;
//    ptr_loadFimrwareCmd_st->cmdHeader_st.bootSlotParamInc = 0x00;
//    ptr_loadFimrwareCmd_st->cmdHeader_st.reserved1 = 0x00;
//    ptr_loadFimrwareCmd_st->cmdHeader_st.reserved2 = 0x00;
//    
//    //Input Descriptor : Not used in this Command
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].ptr_dataAddr = 0x00000000;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].nextDes_st.stop = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.dataLen = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
//  
//    //Output Descriptor : Not used in this Command
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].ptr_dataAddr = 0x00000000;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].nextDes_st.stop = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
//    ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
//    
//    //Parameter 1: Pointer to Firmware Meta Data #0
//    ptr_loadFimrwareCmd_st->metaData0Parm1 = HSM_FIRMWARE_INIT_ADDR;
//    //Parameter 2: Pointer to Firmware Meta Data #1
//    ptr_loadFimrwareCmd_st->metaData1Parm2 = 0x00000000UL;
//    
//    bootSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_loadFimrwareCmd_st->mailBoxHdr_st;
//    bootSendCmd_st.algocmdHdr = (uint32_t*)&ptr_loadFimrwareCmd_st->cmdHeader_st;
//    bootSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_loadFimrwareCmd_st->arr_bootInSgDmaDes_st;
//    bootSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_loadFimrwareCmd_st->arr_bootOutSgDmaDes_st;
//    bootSendCmd_st.ptr_params = (uint32_t*)&(ptr_loadFimrwareCmd_st->metaData0Parm1);
//    bootSendCmd_st.paramsCount = (uint8_t) ((ptr_loadFimrwareCmd_st->mailBoxHdr_st.msgSize/4) - 4);
//    
//    //Send the Command to MailBox
//    HSM_Cmd_Send(bootSendCmd_st);
//
//    //Read the command response 
//    Hsm_Cmd_ReadCmdResponse(&bootCmdResponse_st);
//
//    //Check the command response with expected values for Boot Load Firmware Cmd
//    ret_cmdStat_en = Hsm_Cmd_CheckCmdRespParms(bootCmdResponse_st,(*bootSendCmd_st.mailBoxHdr-16), *bootSendCmd_st.algocmdHdr);
//    
//    return ret_cmdStat_en;
//}
