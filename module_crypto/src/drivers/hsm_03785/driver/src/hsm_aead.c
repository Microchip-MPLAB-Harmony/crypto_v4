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

#include <stdlib.h>

#include "crypto/drivers/driver/hsm_common.h"
#include "crypto/drivers/driver/hsm_cmd.h"
#include "crypto/drivers/driver/hsm_aead.h"

hsm_Cmd_Status_E Hsm_Aead_AesGcm_Init(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, hsm_Aes_CmdTypes_E aesCipherOper_en, uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, uint32_t ivLen)
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    
     //Mailbox Header
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x1c;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = aesCipherOper_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesMode = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x01; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x00; //this is not the last data
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = ((uint32_t)aesKeyLen_en*8UL+16UL);  //here key length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    //Input SG-DMA Descriptor 2 for IV
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)ivLen;  //here IV length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

    // Input SG-DMA Descriptor 3 for the AAD
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)0;  //here AAD length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 
    
    // Input SG-DMA Descriptor 4 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].ptr_dataAddr = NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)0x00;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"       
    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_aesGcmCtx;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop       
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x000000;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = 32;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Parameter 1 : Length of Plain/Cipher Text
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
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,((*aesGcmSendCmd_st.mailBoxHdr)-16U), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_AddAad(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_aad, uint32_t aadLen)
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;

    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x00; //this is the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x00; //this no the last data
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"
    //Input SG-DMA Descriptor 2 for Context
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_aesGcmCtx;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop    
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;  //here ctx length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    //Input SG-DMA Descriptor 3 for AAD
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_aad;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)aadLen;  //here IV length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
    
    //So Input SG-DMA Descriptor 4 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = 0x0000; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)0;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"  
    //Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_aesGcmCtx;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"      
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16U), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_UpdateCipher(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_outData)
{ 
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //Input SG-DMA Descriptor 2 for Context
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_aesGcmCtx;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;  //here ctx length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    //So Input SG-DMA Descriptor 3 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_dataIn;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop         
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = 0x0000; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)inputDataLen;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    //Output SG-DMA Descriptor 1 for Cipher Text
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_outData;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop       
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1])>>2);
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen;//INput and Output data length will be same always
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_aesGcmCtx;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"     
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16U), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_Final(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_tag, uint8_t tagLen)
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;

    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x00; //this is not the first data
    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x01; //this is the last data

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //Input SG-DMA Descriptor 2 for Context
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_aesGcmCtx;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)32;  //here ctx length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //So Input SG-DMA Descriptor 3 for the Plain Text
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)NULL;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = 0x0000; //((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[4])>>2);
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)0;  //here Plain Text length is entered
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //Output SG-DMA Descriptor 2 for CTX
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_tag;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop       
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //Stop
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)tagLen;
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"     
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&ptr_aesGcmCmd_st->aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_aesGcmCmd_st->arr_aesOutSgDmaDes_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop    
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(ptr_aesGcmCmd_st->inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16U), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_DirectEncrypt(uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_outputData,uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en,
                                                    uint8_t *ptr_initVect, uint32_t ivLen, uint8_t *ptr_aad, uint32_t aadLen, uint8_t *ptr_tagMac, uint8_t tagLen)
{       
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    st_Hsm_Aead_AesGcm_Cmd aesGcmCmd_st = {0};
    
    //Mailbox Header
    aesGcmCmd_st.aesMailBoxHdr_st.msgSize =  0x1c;
    aesGcmCmd_st.aesMailBoxHdr_st.unProtection = 0x1;
    aesGcmCmd_st.aesMailBoxHdr_st.reserved1 = 0x00;
    aesGcmCmd_st.aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    aesGcmCmd_st.aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    aesGcmCmd_st.aesCmdHeader_st.aesGcmCmdType_en = HSM_SYM_AES_GCM_ENCRYPT;
    aesGcmCmd_st.aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    aesGcmCmd_st.aesCmdHeader_st.aesMode = 0x06;
    aesGcmCmd_st.aesCmdHeader_st.initialMsg = 0x01; //this is the first data
    aesGcmCmd_st.aesCmdHeader_st.lastMsg = 0x01; //this is first and last message
    aesGcmCmd_st.aesCmdHeader_st.aesGcmAuthInc = 0x00;
    aesGcmCmd_st.aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    aesGcmCmd_st.aesCmdHeader_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"      
    //Input SG-DMA Descriptor 1 for AES Key
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[1])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = ((uint32_t)aesKeyLen_en*8UL+16UL);  //here key length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"      
    //Input SG-DMA Descriptor 2 for IV
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[2])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)ivLen;  //here IV length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00; 
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"  
    // Input SG-DMA Descriptor 3 for the AAD
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_aad;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr = ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[3])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)aadLen;  //here AAD length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"     
    // Input SG-DMA Descriptor 4 for the Plain Text
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_dataIn;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x01; //Stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)inputDataLen;  //here Plain Text length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    // Output SG-DMA Descriptor 1 for Cipher Text
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_outputData;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop       
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&aesGcmCmd_st.arr_aesOutSgDmaDes_st[1])>>2);
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen;//INput and Output data length will be same always
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"     
    //As there will not be context Output SG-DMA Descriptor 2 for MAC or Tag
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_tagMac;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop    
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //stop
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = tagLen;//Tag Len
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

    //Parameter 1 : Length of Cipher Text
    aesGcmCmd_st.inputDataLenParm1 = inputDataLen;
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 2.2" "H3_MISRAC_2012_R_2_2_DR_1" 
    //Parameter 2
    aesGcmCmd_st.aesGcmCmdParm2_st.useIV = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.resetIV = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.useAad = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.varSlotNum = 0x00;
    
    aesGcmCmd_st.aesGcmCmdParm2_st.reserved1 = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3 : AAD Length
    aesGcmCmd_st.aadLengthParm3 = aadLen;
#pragma coverity compliance end_block "MISRA C-2012 Rule 2.2"
#pragma GCC diagnostic pop     

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"     
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&aesGcmCmd_st.aesMailBoxHdr_st;
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&aesGcmCmd_st.aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)aesGcmCmd_st.arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)aesGcmCmd_st.arr_aesOutSgDmaDes_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(aesGcmCmd_st.inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((aesGcmCmd_st.aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);

    //Check the command response with expected values for AES-GCM Encrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16U), *aesGcmSendCmd_st.algocmdHdr);
    
    return ret_aesGcmStat_en;
}

hsm_Cmd_Status_E Hsm_Aead_AesGcm_DirectDecrypt(uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_outputData, uint8_t *ptr_aeskey,
                                                hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, uint32_t ivLen, uint8_t *ptr_aad, uint32_t aadLen, 
                                                uint8_t *ptr_inputTagMac, uint8_t tagLen)    
{
    st_Hsm_ResponseCmd aesGcmCmdResponse_st;
    st_Hsm_SendCmdLayout aesGcmSendCmd_st;
    hsm_Cmd_Status_E ret_aesGcmStat_en;
    st_Hsm_Aead_AesGcm_Cmd aesGcmCmd_st = {0};
    
    //Mailbox Header
    aesGcmCmd_st.aesMailBoxHdr_st.msgSize =  0x1c;
    aesGcmCmd_st.aesMailBoxHdr_st.unProtection = 0x1;
    aesGcmCmd_st.aesMailBoxHdr_st.reserved1 = 0x00;
    aesGcmCmd_st.aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    aesGcmCmd_st.aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
    aesGcmCmd_st.aesCmdHeader_st.aesGcmCmdType_en = HSM_SYM_AES_GCM_DECRYPT;
    aesGcmCmd_st.aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
    aesGcmCmd_st.aesCmdHeader_st.aesMode = 0x06;
    aesGcmCmd_st.aesCmdHeader_st.initialMsg = 0x01; //this is the first data
    aesGcmCmd_st.aesCmdHeader_st.lastMsg = 0x01; //this is first and last message
    aesGcmCmd_st.aesCmdHeader_st.aesGcmAuthInc = 0x00;
    aesGcmCmd_st.aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
    aesGcmCmd_st.aesCmdHeader_st.reserved1 = 0x00;
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"  
    //Input SG-DMA Descriptor 1 for AES Key
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[1])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = ((uint32_t)aesKeyLen_en*8UL+16UL);  //here key length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    //Input SG-DMA Descriptor 2 for IV
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[2])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)ivLen;  //here IV length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //So Input SG-DMA Descriptor 3 for the AAD
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_aad;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[3])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.dataLen = (uint32_t)aadLen;  //here AAD length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"     
    // Input SG-DMA Descriptor 4 for the Cipher Text
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_dataIn;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop       
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].nextDes_st.stop = 0x00; //Stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr = ((uint32_t)(&aesGcmCmd_st.arr_aesInSgDmaDes_st[4])>>2);
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.dataLen = (uint32_t)inputDataLen;  //here Plain Text length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
    //So Input SG-DMA Descriptor 5 for the MAC/Tag
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].ptr_dataAddr = (uint32_t*)ptr_inputTagMac;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].nextDes_st.stop = 0x01; //Stop
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].nextDes_st.nextDescriptorAddr = 0x0000;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].flagAndLength_st.dataLen = (uint32_t)tagLen;  //here Plain Text length is entered
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].flagAndLength_st.discard = 0x00;
	aesGcmCmd_st.arr_aesInSgDmaDes_st[4].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesInSgDmaDes_st[4].nextDes_st.reserved1 = 0x00; 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    //Output SG-DMA Descriptor 1 for Cipher Text
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_outputData;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop     
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x01; //stop
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x0000;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen; //Input and Output data length will be same always
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    aesGcmCmd_st.arr_aesOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Parameter 1 : length of Plain-Text
    aesGcmCmd_st.inputDataLenParm1 = inputDataLen;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 2.2" "H3_MISRAC_2012_R_2_2_DR_1"    
    //Parameter 2
    aesGcmCmd_st.aesGcmCmdParm2_st.useIV = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.resetIV = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.useAad = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.varSlotNum = 0x00;

    aesGcmCmd_st.aesGcmCmdParm2_st.reserved1 = 0x00;
    aesGcmCmd_st.aesGcmCmdParm2_st.reserved2 = 0x00;
    
    //Parameter 3: Length of AAD
   aesGcmCmd_st.aadLengthParm3 = aadLen;
#pragma coverity compliance end_block "MISRA C-2012 Rule 2.2"
#pragma GCC diagnostic pop 

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"   
    aesGcmSendCmd_st.mailBoxHdr = (uint32_t*)&aesGcmCmd_st.aesMailBoxHdr_st;   
    aesGcmSendCmd_st.algocmdHdr = (uint32_t*)&aesGcmCmd_st.aesCmdHeader_st;
    aesGcmSendCmd_st.ptr_sgDescriptorIn = (uint32_t*)aesGcmCmd_st.arr_aesInSgDmaDes_st;
    aesGcmSendCmd_st.ptr_sgDescriptorOut = (uint32_t*)aesGcmCmd_st.arr_aesOutSgDmaDes_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop      
    aesGcmSendCmd_st.ptr_params = (uint32_t*)&(aesGcmCmd_st.inputDataLenParm1);
    aesGcmSendCmd_st.paramsCount = (uint8_t) ((aesGcmCmd_st.aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(aesGcmSendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&aesGcmCmdResponse_st);
    
    //Check the command response with expected values for AES-GCM Decrypt Cmd
    ret_aesGcmStat_en = Hsm_Cmd_CheckCmdRespParms(aesGcmCmdResponse_st,(*aesGcmSendCmd_st.mailBoxHdr-16U), *aesGcmSendCmd_st.algocmdHdr);
    
    if(aesGcmCmdResponse_st.resultCode_en == HSM_CMD_RC_AUTHFAILED)
    {
        ret_aesGcmStat_en = HSM_CMD_ERROR_AEADAUTH_FAILED;
    }
    return ret_aesGcmStat_en;
}
