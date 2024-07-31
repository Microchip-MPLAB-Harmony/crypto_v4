/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_mac.c

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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "stdbool.h"
#include "pic32cz8110ca90208.h"
#include "system/system_module.h"
#include "core_cm7.h"
#include "user.h"
#include "hsm_common.h"
#include "hsm_cmd.h"
#include "hsm_aead.h"

hsm_Cmd_Status_E Hsm_Aead_AesGcm_InitEncrypt(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, hsm_Aes_CmdTypes_E cmdType_en)
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    
     //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = cmdType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x01; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x00; //this no the last data
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2 for IV
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)12;  //here IV length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //So Input SG-DMA Descriptor 3 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = 0x0000;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)0;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 

    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)NULL;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    ////Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_aesGcmCtx;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

    //Parameter 1 : Length of Encrypted Text
    ptr_aesGcmCmd_st->inputDataLenParm1 = 0;
    
    //Parameter 2
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.resetIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useAad = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3 : AAD Length
    ptr_aesGcmCmd_st->aadLengthParm3 = 0;
    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_addAad(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_aad, uint16_t aadLen)
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    
     //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = HSM_SYM_AES_GCM_ENCRYPT; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x00; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x00; //this no the last data
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Input SG-DMA Descriptor 2 for Context
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_aesGcmCtx;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;  //here ctx length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 3 for AAD
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_aad;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)aadLen;  //here IV length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
    
    //So Input SG-DMA Descriptor 4 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = 0x0000; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)0;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00; 

    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)NULL;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0;//INput and Output data length will be same always
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_aesGcmCtx;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //Parameter 1: Length of Encrypted Text
    ptr_aesGcmCmd_st->inputDataLenParm1 = 0;
    
    //Parameter 2
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.resetIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useAad = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 2:  AAD Length
    ptr_aesGcmCmd_st->aadLengthParm3 = aadLen;
    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_UpdateEncryption(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_dataIn, uint16_t inputDataLen)// uint8_t *ptr_aad, uint16_t aadLen)
{ 
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    
     //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = cmdType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x00; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x00; //this no the last data
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Input SG-DMA Descriptor 2 for Context
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_aesGcmCtx;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;  //here ctx length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //So Input SG-DMA Descriptor 3 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_dataIn;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = 0x0000; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)inputDataLen;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 
    
    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)NULL;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0;//INput and Output data length will be same always
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_aesGcmCtx;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //Parameter 1 : Length of Encrypted Text
    ptr_aesGcmCmd_st->inputDataLenParm1 = inputDataLen;
    
    //Parameter 2
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.resetIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useAad = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3 : AAD Length
    ptr_aesGcmCmd_st->aadLengthParm3 = 0;
    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_Final(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_mac, uint8_t macLen)
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    
     //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = cmdType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x00; //this is not the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x01; //this is the last data
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Input SG-DMA Descriptor 2 for Context
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_aesGcmCtx;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;  //here ctx length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //So Input SG-DMA Descriptor 3 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = 0x0000; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)0;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 
    
    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)NULL;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0;//INput and Output data length will be same always
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_mac;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)macLen;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //Parameter 1 : Length of Encrypted Text
    ptr_aesGcmCmd_st->inputDataLenParm1 = 0;
    
    //Parameter 2
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.resetIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useAad = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3 : AAD Length
    ptr_aesGcmCmd_st->aadLengthParm3 = 0;
    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_DirectEncrypt(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_dataIn, uint16_t inputDataLen, uint8_t *ptr_outputData,
                                        uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, uint8_t *ptr_aad, uint16_t aadLen, uint8_t *ptr_tagMac, uint8_t tagLen)
{
        
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    
    //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = HSM_SYM_AES_GCM_ENCRYPT; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x01; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x01; //this is first and last message
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2 for IV
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)12;  //here IV length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00; 
    
    //The Context won't be required as it is first and last message
    //So Input SG-DMA Descriptor 3 for the AAD
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_aad;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)aadLen;  //here AAD length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 
    
    //So Input SG-DMA Descriptor 4 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_dataIn;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = 0x00; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)inputDataLen;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00; 

    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_outputData;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen;//INput and Output data length will be same always
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //As there will not be context Output SG-DMA Descriptor 2 for MAC or Tag
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_tagMac;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = tagLen;//Tag Len
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

    //Parameter 1 : Length of Cipher Text
    ptr_aesGcmCmd_st->inputDataLenParm1 = inputDataLen;
    
    //Parameter 2
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.resetIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useAad = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3 : AAD Length
    ptr_aesGcmCmd_st->aadLengthParm3 = aadLen;
    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_DirectDecrypt(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_dataIn, uint16_t inputDataLen, uint8_t *ptr_outputData,
                                        uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, uint8_t *ptr_aad, uint16_t aadLen, 
                                        uint8_t *ptr_inputTagMac, uint8_t tagLen)
{
        
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
            
    //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = HSM_SYM_AES_GCM_DECRYPT; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x01; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x01; //this is first and last message
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2 for IV
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)12;  //here IV length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00; 
    
    //So Input SG-DMA Descriptor 3 for the AAD
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_aad;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)aadLen;  //here AAD length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 
    
    //So Input SG-DMA Descriptor 4 for the Cipher Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_dataIn;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x00; //do not Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)inputDataLen;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00; 

    //So Input SG-DMA Descriptor 5 for the MAC/Tag
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].ptr_dataAddr = (uint32_t*)ptr_inputTagMac;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].nextDes_st.nextDescriptorAddr = 0x0000;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].flagAndLength_st.dataLen = (uint32_t)tagLen;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].flagAndLength_st.reAlign = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4].nextDes_st.reserved1 = 0x00; 
    
    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_outputData;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x01; //stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x0000;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen; //Input and Output data length will be same always
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    
    //Parameter 1 : length of Plain-Text
    ptr_aesGcmCmd_st->inputDataLenParm1 = inputDataLen;
    
    //Parameter 2
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.resetIV = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.useAad = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3: Length of AAD
    ptr_aesGcmCmd_st->aadLengthParm3 = aadLen;
    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);
    
    //Check the command response with expected values for AES-GCM Decrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}
