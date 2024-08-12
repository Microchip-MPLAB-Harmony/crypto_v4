/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_hash.c

  @Summary
    SHA, MD5 hashing

  @Description
    SHA, MD5 hashing

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
#include "hsm_hash.h"
#include "hsm_cmd.h"

uint8_t Hsm_Hash_HashLen(hsm_Hash_Types_E hashType_en)
{
    uint8_t hashLen = 0u;
    switch(hashType_en)
    {
        case HSM_CMD_HASH_MD5:
        	hashLen	= HSM_HASH_DIGESTSIZE_MD5;
            break;
        case HSM_CMD_HASH_SHA1:
            hashLen	= HSM_HASH_DIGESTSIZE_SHA1;
            break;
        case HSM_CMD_HASH_SHA224:
            hashLen	= HSM_HASH_DIGESTSIZE_SHA224;
            break;    
        case HSM_CMD_HASH_SHA256:
            hashLen	= HSM_HASH_DIGESTSIZE_SHA256;
            break;  
        case HSM_CMD_HASH_SHA384:
            hashLen	= HSM_HASH_DIGESTSIZE_SHA384;
            break;   
        case HSM_CMD_HASH_SHA512:
            hashLen	= HSM_HASH_DIGESTSIZE_SHA512;
            break;              
        default:
            hashLen = 0u;
            break;
    }
    return hashLen; 
}

uint8_t Hsm_Hash_HashCtxLen(hsm_Hash_Types_E hashType_en)
{
    uint8_t hashCtxLen = 0u;
    switch(hashType_en)
    {
        case HSM_CMD_HASH_MD5:
        	hashCtxLen	= HSM_HASH_DIGESTSIZE_MD5;
            break;
        case HSM_CMD_HASH_SHA1:
            hashCtxLen	= HSM_HASH_DIGESTSIZE_SHA1;
            break;
        case HSM_CMD_HASH_SHA224:
        case HSM_CMD_HASH_SHA256:
            hashCtxLen	= HSM_HASH_DIGESTSIZE_SHA256;
            break;  
        case HSM_CMD_HASH_SHA384:
        case HSM_CMD_HASH_SHA512:
            hashCtxLen	= HSM_HASH_DIGESTSIZE_SHA512;
            break;              
        default:
            hashCtxLen = 0u;
            break;
    }
    return hashCtxLen; 
}

void HSM_Hash_BlockCmd(st_Hsm_Hash_BlockCmd *ptr_hashBlockCtx_st, hsm_Hash_Types_E hashType_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    uint8_t hashLen = 0u;
	
    SYS_PRINT("-------------Block CMD FILLING STARTED----------\r\n");
    //Mailbox Header
    ptr_hashBlockCtx_st->mailBoxHdr_st.msgSize =  0x18;
    ptr_hashBlockCtx_st->mailBoxHdr_st.unProtection = 0x1;
    ptr_hashBlockCtx_st->mailBoxHdr_st.reserved1 = 0x00;
    ptr_hashBlockCtx_st->mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    ptr_hashBlockCtx_st->cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    ptr_hashBlockCtx_st->cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_BLOCK;
    ptr_hashBlockCtx_st->cmdHeader_st.hashType_en = hashType_en;
    ptr_hashBlockCtx_st->cmdHeader_st.hashAuthInc = 0x00;
    ptr_hashBlockCtx_st->cmdHeader_st.hashSlotParamInc = 0x00;
    ptr_hashBlockCtx_st->cmdHeader_st.reserved1 = 0x00;
    ptr_hashBlockCtx_st->cmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor
    ptr_hashBlockCtx_st->inSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_inputData;
    ptr_hashBlockCtx_st->inSgDmaDes_st.nextDes_st.stop = 0x01;
    ptr_hashBlockCtx_st->inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x0000;
    ptr_hashBlockCtx_st->inSgDmaDes_st.flagAndLength_st.dataLen = dataLen;
    ptr_hashBlockCtx_st->inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
    ptr_hashBlockCtx_st->inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
    ptr_hashBlockCtx_st->inSgDmaDes_st.flagAndLength_st.discard = 0x00;
	ptr_hashBlockCtx_st->inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
    ptr_hashBlockCtx_st->inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
                
    hashLen = Hsm_Hash_HashLen(hashType_en);
        
    //Output SG-DMA Descriptor
    ptr_hashBlockCtx_st->outSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_outData;
    ptr_hashBlockCtx_st->outSgDmaDes_st.nextDes_st.stop = 0x01;
    ptr_hashBlockCtx_st->outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
    ptr_hashBlockCtx_st->outSgDmaDes_st.flagAndLength_st.dataLen = hashLen; //length of the hash
    ptr_hashBlockCtx_st->outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
    ptr_hashBlockCtx_st->outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
    ptr_hashBlockCtx_st->outSgDmaDes_st.flagAndLength_st.discard = 0x00;
    ptr_hashBlockCtx_st->outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
    ptr_hashBlockCtx_st->outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
	
    //Hash Parameter 1
    ptr_hashBlockCtx_st->inputLenParm1 = dataLen;
    
    //Hash Parameter 2
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotNum = 0;
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotData_st.apl = 0;
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotData_st.exStorage = 0;
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotData_st.hsmOnly = 0;
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotData_st.storageType = 0;
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotData_st.valid = 0;
    ptr_hashBlockCtx_st->blockCmdParm2_st.reserved1 = 0x00;
    ptr_hashBlockCtx_st->blockCmdParm2_st.reserved2 = 0x00;
    ptr_hashBlockCtx_st->blockCmdParm2_st.varSlotData_st.reserved1 = 0x00;
    SYS_PRINT("-------------Block CMD FILLING FINISHED----------\r\n");
}

hsm_Cmd_Status_E HSM_Hash_DigestDirect(hsm_Hash_Types_E hashType_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData)
{
    st_Hsm_Hash_BlockCmd hashBlockCtx_st;
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    
    //Fill the Command's values
    HSM_Hash_BlockCmd(&hashBlockCtx_st, hashType_en, ptr_inputData, dataLen, ptr_outData);
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&hashBlockCtx_st.mailBoxHdr_st;
    sendCmd_st.algocmdHdr = (uint32_t*)&hashBlockCtx_st.cmdHeader_st;
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)&(hashBlockCtx_st.inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(hashBlockCtx_st.outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(hashBlockCtx_st.inputLenParm1);
    sendCmd_st.paramsCount = (uint8_t) ((hashBlockCtx_st.mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);

    //Check the command response with expected values for Hash Block Cmd
    ret_hashCmdStat_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-8), *sendCmd_st.algocmdHdr);

    return ret_hashCmdStat_en;
}

hsm_Cmd_Status_E HSM_Hash_InitCmd(uint8_t *ptr_hashCtx, hsm_Hash_Types_E hashType_en)
{
    SYS_PRINT("-------------Hash Init CMD STARTED----------\r\n");
    st_Hsm_Hash_InitCmd hashInitCmd_st;
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    uint8_t hashCtxLen = 0U;
    
    //Mailbox Header
    hashInitCmd_st.mailBoxHdr_st.msgSize =  0x14;
    hashInitCmd_st.mailBoxHdr_st.unProtection = 0x00;
    hashInitCmd_st.mailBoxHdr_st.reserved1 = 0x00;
    hashInitCmd_st.mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    hashInitCmd_st.cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    hashInitCmd_st.cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_INIT;
    hashInitCmd_st.cmdHeader_st.hashType_en = hashType_en;
    hashInitCmd_st.cmdHeader_st.hashAuthInc = 0x00;
    hashInitCmd_st.cmdHeader_st.hashSlotParamInc = 0x00;
    hashInitCmd_st.cmdHeader_st.reserved1 = 0x00;
    hashInitCmd_st.cmdHeader_st.reserved2 = 0x00;

//    hashInitCmd_st.inSgDmaDes_st.ptr_dataAddr = (uint32_t *)ptr_hashCtx;
//    hashInitCmd_st.inSgDmaDes_st.nextDes_st.stop = 0x01;
//    hashInitCmd_st.inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
//    hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.dataLen = 32; //context Length decided based on hash algo 
//    hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.discard = 0x00;
//    hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    hashInitCmd_st.inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
    
        //Get Hash Length based on Hash Type
    hashCtxLen = Hsm_Hash_HashCtxLen(hashType_en);
    
    //Output SG-DMA Descriptor
    hashInitCmd_st.outSgDmaDes_st.ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    hashInitCmd_st.outSgDmaDes_st.nextDes_st.stop = 0x01;
    hashInitCmd_st.outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
    hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
    hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
    hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.discard = 0x00;
    hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
    hashInitCmd_st.outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
    
    hashInitCmd_st.initCmdParm1_st.varSlotNum = 0x00;
    hashInitCmd_st.initCmdParm1_st.varSlotData_st.apl = 0x00;
    hashInitCmd_st.initCmdParm1_st.varSlotData_st.exStorage = 0x00;
    hashInitCmd_st.initCmdParm1_st.varSlotData_st.hsmOnly = 0x00;
    hashInitCmd_st.initCmdParm1_st.varSlotData_st.storageType = 0x00;
    hashInitCmd_st.initCmdParm1_st.varSlotData_st.valid = 0x00;
    hashInitCmd_st.initCmdParm1_st.varSlotData_st.reserved1 = 0x00;
    hashInitCmd_st.initCmdParm1_st.reserved1 = 0x00;
    hashInitCmd_st.initCmdParm1_st.reserved2 = 0x00; 
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&hashInitCmd_st.mailBoxHdr_st;
    sendCmd_st.algocmdHdr = (uint32_t*)&hashInitCmd_st.cmdHeader_st;
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)0x00000000; //&(hashInitCmd_st.inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(hashInitCmd_st.outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(hashInitCmd_st.initCmdParm1_st);
    sendCmd_st.paramsCount = (uint8_t) ((hashInitCmd_st.mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for Hash Init Cmd
    ret_hashCmdStat_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-8), *sendCmd_st.algocmdHdr);
    
    SYS_PRINT("-------------Hash Init CMD END----------\r\n");
    
    return ret_hashCmdStat_en;
}

hsm_Cmd_Status_E HSM_Hash_UpdateCmd(uint8_t *ptr_hashCtx, uint8_t *ptr_inputData, uint32_t dataLen, hsm_Hash_Types_E hashType_en)
{
    SYS_PRINT("-------------Hash Update CMD STARTED----------\r\n");
    st_Hsm_Hash_UpdateCmd hashUpdateCmd_st;
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    uint8_t hashCtxLen = 0U;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    
    //Mailbox Header
    hashUpdateCmd_st.mailBoxHdr_st.msgSize =  0x18;
    hashUpdateCmd_st.mailBoxHdr_st.unProtection = 0x00;
    hashUpdateCmd_st.mailBoxHdr_st.reserved1 = 0x00;
    hashUpdateCmd_st.mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    hashUpdateCmd_st.cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    hashUpdateCmd_st.cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_UPDATE;
    hashUpdateCmd_st.cmdHeader_st.hashType_en = hashType_en;
    hashUpdateCmd_st.cmdHeader_st.hashAuthInc = 0x00;
    hashUpdateCmd_st.cmdHeader_st.hashSlotParamInc = 0x00;
    hashUpdateCmd_st.cmdHeader_st.reserved1 = 0x00;
    hashUpdateCmd_st.cmdHeader_st.reserved2 = 0x00;

    //Get Hash Length based on Hash Type
    hashCtxLen = Hsm_Hash_HashCtxLen(hashType_en);
    
    //Input SG-DMA Descriptor 1
    hashUpdateCmd_st.inSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    hashUpdateCmd_st.inSgDmaDes_st[0].nextDes_st.stop = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&hashUpdateCmd_st.inSgDmaDes_st[1])>>2);
    hashUpdateCmd_st.inSgDmaDes_st[0].flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    hashUpdateCmd_st.inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    hashUpdateCmd_st.inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2
    hashUpdateCmd_st.inSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_inputData;
    hashUpdateCmd_st.inSgDmaDes_st[1].nextDes_st.stop = 0x01;
    hashUpdateCmd_st.inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[1].flagAndLength_st.dataLen = dataLen; //context Length decided based on hash algo 
    hashUpdateCmd_st.inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    hashUpdateCmd_st.inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    hashUpdateCmd_st.inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //Output SG-DMA Descriptor
    hashUpdateCmd_st.outSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    hashUpdateCmd_st.outSgDmaDes_st[0].nextDes_st.stop = 0x01;
    hashUpdateCmd_st.outSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    hashUpdateCmd_st.outSgDmaDes_st[0].flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    hashUpdateCmd_st.outSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    hashUpdateCmd_st.outSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    hashUpdateCmd_st.outSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    hashUpdateCmd_st.outSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    hashUpdateCmd_st.outSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    hashUpdateCmd_st.inputLenParm1 = dataLen;
            
    hashUpdateCmd_st.updateCmdParm2_st.varSlotNum = 0x00;
    hashUpdateCmd_st.updateCmdParm2_st.useVsForCtx = 0x00;
    hashUpdateCmd_st.updateCmdParm2_st.reserved1 = 0x00;
    hashUpdateCmd_st.updateCmdParm2_st.reserved2 = 0x00; 
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(hashUpdateCmd_st.mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(hashUpdateCmd_st.cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)&(hashUpdateCmd_st.inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(hashUpdateCmd_st.outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(hashUpdateCmd_st.inputLenParm1);
    sendCmd_st.paramsCount = (uint8_t) ((hashUpdateCmd_st.mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for Hash Update Cmd
    ret_hashCmdStat_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-8), *sendCmd_st.algocmdHdr);
    
    SYS_PRINT("-------------Hash Update CMD END----------\r\n");
    
    return ret_hashCmdStat_en;
}

hsm_Cmd_Status_E HSM_Hash_FinalCmd(uint8_t *ptr_hashCtx, uint8_t *ptr_leftoverInData, uint32_t dataLen, uint8_t *ptr_OutputData, hsm_Hash_Types_E hashType_en)
{
    SYS_PRINT("-------------Hash Final CMD Started----------\r\n");
    st_Hsm_Hash_FinalCmd hashFinalCmd_st;
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    uint8_t hashCtxLen = 0u;
    uint8_t hashLen = 0u;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    
    //Mailbox Header
    hashFinalCmd_st.mailBoxHdr_st.msgSize =  0x1C;
    hashFinalCmd_st.mailBoxHdr_st.unProtection = 0x00;
    hashFinalCmd_st.mailBoxHdr_st.reserved1 = 0x00;
    hashFinalCmd_st.mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    hashFinalCmd_st.cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    hashFinalCmd_st.cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_FINALIZE;
    hashFinalCmd_st.cmdHeader_st.hashType_en = hashType_en;
    hashFinalCmd_st.cmdHeader_st.hashAuthInc = 0x00;
    hashFinalCmd_st.cmdHeader_st.hashSlotParamInc = 0x00;
    hashFinalCmd_st.cmdHeader_st.reserved1 = 0x00;
    hashFinalCmd_st.cmdHeader_st.reserved2 = 0x00;

    //Get Hash Length based on Hash Type
    hashCtxLen = Hsm_Hash_HashCtxLen(hashType_en);
    
    //Input SG-DMA Descriptor 1
    hashFinalCmd_st.inSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    hashFinalCmd_st.inSgDmaDes_st[0].nextDes_st.stop = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&hashFinalCmd_st.inSgDmaDes_st[1])>>2);;
    hashFinalCmd_st.inSgDmaDes_st[0].flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    hashFinalCmd_st.inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    hashFinalCmd_st.inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2
    hashFinalCmd_st.inSgDmaDes_st[1].ptr_dataAddr = (uint32_t *)ptr_leftoverInData;
    hashFinalCmd_st.inSgDmaDes_st[1].nextDes_st.stop = 0x01;
    hashFinalCmd_st.inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[1].flagAndLength_st.dataLen = 0; //context Length decided based on hash algo 
    hashFinalCmd_st.inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    hashFinalCmd_st.inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    hashFinalCmd_st.inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    hashLen = Hsm_Hash_HashLen(hashType_en);
    
    //Output SG-DMA Descriptor
    hashFinalCmd_st.outSgDmaDes_st.ptr_dataAddr = (uint32_t *)ptr_OutputData;
    hashFinalCmd_st.outSgDmaDes_st.nextDes_st.stop = 0x01;
    hashFinalCmd_st.outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
    hashFinalCmd_st.outSgDmaDes_st.flagAndLength_st.dataLen = hashLen; //Hash Length decided based on hash algorithm 
    hashFinalCmd_st.outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
    hashFinalCmd_st.outSgDmaDes_st.flagAndLength_st.discard = 0x00;
    hashFinalCmd_st.outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
    hashFinalCmd_st.outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
    
    hashFinalCmd_st.inputLenParm1 = 0;
           
    hashFinalCmd_st.finalCmdParam2_st.useVsForCtx = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.ctxVarSlotNum = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.useVsForVal = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.accessprogLvl = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.hsmOnly = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.valVarSlotNum = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.reserved1 = 0x00;
    hashFinalCmd_st.finalCmdParam2_st.reserved2 = 0x00; 
    
    
     hashFinalCmd_st.totalDataLenPara3 = 11;
             
    sendCmd_st.mailBoxHdr = (uint32_t*)&(hashFinalCmd_st.mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(hashFinalCmd_st.cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)&(hashFinalCmd_st.inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(hashFinalCmd_st.outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(hashFinalCmd_st.inputLenParm1);
    sendCmd_st.paramsCount = (uint8_t) ((hashFinalCmd_st.mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for Hash Update Cmd
    ret_hashCmdStat_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-8), *sendCmd_st.algocmdHdr);
    SYS_PRINT("-------------Hash Final CMD END----------\r\n");
    
    return ret_hashCmdStat_en;
}
