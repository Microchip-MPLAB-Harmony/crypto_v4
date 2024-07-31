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
//
//
//
//RSP_DATA rspDigest;

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
    st_Hsm_Hash_InitCmd arr_hashInitCmd_st;
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    
    //Mailbox Header
    arr_hashInitCmd_st.mailBoxHdr_st.msgSize =  0x14;
    arr_hashInitCmd_st.mailBoxHdr_st.unProtection = 0x00;
    arr_hashInitCmd_st.mailBoxHdr_st.reserved1 = 0x00;
    arr_hashInitCmd_st.mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    arr_hashInitCmd_st.cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    arr_hashInitCmd_st.cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_INIT;
    arr_hashInitCmd_st.cmdHeader_st.hashType_en = hashType_en;
    arr_hashInitCmd_st.cmdHeader_st.hashAuthInc = 0x00;
    arr_hashInitCmd_st.cmdHeader_st.hashSlotParamInc = 0x00;
    arr_hashInitCmd_st.cmdHeader_st.reserved1 = 0x00;
    arr_hashInitCmd_st.cmdHeader_st.reserved2 = 0x00;

    arr_hashInitCmd_st.inSgDmaDes_st.ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    arr_hashInitCmd_st.inSgDmaDes_st.nextDes_st.stop = 0x01;
    arr_hashInitCmd_st.inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.dataLen = 32; //context Length decided based on hash algo 
    arr_hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
    arr_hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
    arr_hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.discard = 0x00;
    arr_hashInitCmd_st.inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
    arr_hashInitCmd_st.inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
    
    //Output SG-DMA Descriptor
    arr_hashInitCmd_st.outSgDmaDes_st.ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    arr_hashInitCmd_st.outSgDmaDes_st.nextDes_st.stop = 0x01;
    arr_hashInitCmd_st.outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.dataLen = 32;//hashCtxLen; //context Length decided based on hash algo 
    arr_hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
    arr_hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
    arr_hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.discard = 0x00;
    arr_hashInitCmd_st.outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
    arr_hashInitCmd_st.outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
    
    arr_hashInitCmd_st.initCmdParm1_st.varSlotNum = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.varSlotData_st.apl = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.varSlotData_st.exStorage = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.varSlotData_st.hsmOnly = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.varSlotData_st.storageType = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.varSlotData_st.valid = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.varSlotData_st.reserved1 = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.reserved1 = 0x00;
    arr_hashInitCmd_st.initCmdParm1_st.reserved2 = 0x00; 
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&arr_hashInitCmd_st.mailBoxHdr_st;
    sendCmd_st.algocmdHdr = (uint32_t*)&arr_hashInitCmd_st.cmdHeader_st;
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)&(arr_hashInitCmd_st.inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(arr_hashInitCmd_st.outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(arr_hashInitCmd_st.initCmdParm1_st);
    sendCmd_st.paramsCount = (uint8_t) ((arr_hashInitCmd_st.mailBoxHdr_st.msgSize/4) - 4);
    
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
    st_Hsm_Hash_UpdateCmd arr_hashUpdateCmd_st[1];
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    uint8_t hashCtxLen = 0u;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    
    //Mailbox Header
    arr_hashUpdateCmd_st[0].mailBoxHdr_st.msgSize =  0x18;
    arr_hashUpdateCmd_st[0].mailBoxHdr_st.unProtection = 0x00;
    arr_hashUpdateCmd_st[0].mailBoxHdr_st.reserved1 = 0x00;
    arr_hashUpdateCmd_st[0].mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    arr_hashUpdateCmd_st[0].cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    arr_hashUpdateCmd_st[0].cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_UPDATE;
    arr_hashUpdateCmd_st[0].cmdHeader_st.hashType_en = hashType_en;
    arr_hashUpdateCmd_st[0].cmdHeader_st.hashAuthInc = 0x00;
    arr_hashUpdateCmd_st[0].cmdHeader_st.hashSlotParamInc = 0x00;
    arr_hashUpdateCmd_st[0].cmdHeader_st.reserved1 = 0x00;
    arr_hashUpdateCmd_st[0].cmdHeader_st.reserved2 = 0x00;

    //Get Hash Length based on Hash Type
    hashCtxLen = Hsm_Hash_HashCtxLen(hashType_en);
    
    //Input SG-DMA Descriptor 1
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].nextDes_st.stop = 0x01;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_inputData;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].nextDes_st.stop = 0x01;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.dataLen = dataLen; //context Length decided based on hash algo 
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    arr_hashUpdateCmd_st[0].inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Output SG-DMA Descriptor
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].nextDes_st.stop = 0x01;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    arr_hashUpdateCmd_st[0].outSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    arr_hashUpdateCmd_st[0].inputLenParm1 = dataLen;
            
    arr_hashUpdateCmd_st[0].updateCmdParm2_st.varSlotNum = 0x00;
    arr_hashUpdateCmd_st[0].updateCmdParm2_st.useVsForCtx = 0x00;
    arr_hashUpdateCmd_st[0].updateCmdParm2_st.reserved1 = 0x00;
    arr_hashUpdateCmd_st[0].updateCmdParm2_st.reserved2 = 0x00; 
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(arr_hashUpdateCmd_st[0].mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(arr_hashUpdateCmd_st[0].cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)&(arr_hashUpdateCmd_st[0].inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(arr_hashUpdateCmd_st[0].outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(arr_hashUpdateCmd_st[0].inputLenParm1);
    sendCmd_st.paramsCount = (uint8_t) ((arr_hashUpdateCmd_st[0].mailBoxHdr_st.msgSize/4) - 4);
    
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
    st_Hsm_Hash_UpdateCmd arr_hashFinalCmd_st[1];
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    uint8_t hashCtxLen = 0u;
    uint8_t hashLen = 0u;
    hsm_Cmd_Status_E ret_hashCmdStat_en;
    
    //Mailbox Header
    arr_hashFinalCmd_st[0].mailBoxHdr_st.msgSize =  0x18;
    arr_hashFinalCmd_st[0].mailBoxHdr_st.unProtection = 0x00;
    arr_hashFinalCmd_st[0].mailBoxHdr_st.reserved1 = 0x00;
    arr_hashFinalCmd_st[0].mailBoxHdr_st.reserved2 = 0x00;
    
    //command Header
    arr_hashFinalCmd_st[0].cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
    arr_hashFinalCmd_st[0].cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_FINALIZE;
    arr_hashFinalCmd_st[0].cmdHeader_st.hashType_en = hashType_en;
    arr_hashFinalCmd_st[0].cmdHeader_st.hashAuthInc = 0x00;
    arr_hashFinalCmd_st[0].cmdHeader_st.hashSlotParamInc = 0x00;
    arr_hashFinalCmd_st[0].cmdHeader_st.reserved1 = 0x00;
    arr_hashFinalCmd_st[0].cmdHeader_st.reserved2 = 0x00;

    //Get Hash Length based on Hash Type
    hashCtxLen = Hsm_Hash_HashCtxLen(hashType_en);
    
    //Input SG-DMA Descriptor 1
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].nextDes_st.stop = 0x01;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.dataLen = hashCtxLen; //context Length decided based on hash algo 
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 2
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_leftoverInData;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].nextDes_st.stop = 0x01;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.dataLen = dataLen; //context Length decided based on hash algo 
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    arr_hashFinalCmd_st[0].inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    hashLen = Hsm_Hash_HashLen(hashType_en);
    
    //Output SG-DMA Descriptor
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].ptr_dataAddr = (uint32_t *)ptr_hashCtx;
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].nextDes_st.stop = 0x01;
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.dataLen = hashLen; //Hash Length decided based on hash algorithm 
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    arr_hashFinalCmd_st[0].outSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    arr_hashFinalCmd_st[0].inputLenParm1 = dataLen;
            
    arr_hashFinalCmd_st[0].updateCmdParm2_st.varSlotNum = 0x00;
    arr_hashFinalCmd_st[0].updateCmdParm2_st.useVsForCtx = 0x00;
    arr_hashFinalCmd_st[0].updateCmdParm2_st.reserved1 = 0x00;
    arr_hashFinalCmd_st[0].updateCmdParm2_st.reserved2 = 0x00; 
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(arr_hashFinalCmd_st[0].mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(arr_hashFinalCmd_st[0].cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)&(arr_hashFinalCmd_st[0].inSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)&(arr_hashFinalCmd_st[0].outSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(arr_hashFinalCmd_st[0].inputLenParm1);
    sendCmd_st.paramsCount = (uint8_t) ((arr_hashFinalCmd_st[0].mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for Hash Update Cmd
    ret_hashCmdStat_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-8), *sendCmd_st.algocmdHdr);
    SYS_PRINT("-------------Hash Final CMD END----------\r\n");
    
    return ret_hashCmdStat_en;
}

//void HSM_Hash_InitCmd(st_Hsm_Hash_InitCmd *ptr_hashInitCtx_st, hsm_Hash_Types_E hashType_en)
//{
//    uint32_t hashLen = 0u;
//	
//    SYS_PRINT("-------------Hash Init CMD STARTED----------\r\n");
//    //Mailbox Header
//    ptr_hashInitCtx_st->mailBoxHdr_st.msgSize =  0x14;
//    ptr_hashInitCtx_st->mailBoxHdr_st.unProtection = 0x1;
//    ptr_hashInitCtx_st->mailBoxHdr_st.reserved1 = 0x00;
//    ptr_hashInitCtx_st->mailBoxHdr_st.reserved2 = 0x00;
//    
//    //command Header
//    ptr_hashInitCtx_st->cmdHeader_st.hashCmdGroup_en = HSM_CMD_HASH;
//    ptr_hashInitCtx_st->cmdHeader_st.hashCmdType_en = HSM_CMD_HASH_INIT;
//    ptr_hashInitCtx_st->cmdHeader_st.hashType_en = hashType_en;
//    ptr_hashInitCtx_st->cmdHeader_st.hashAuthInc = 0x00;
//    ptr_hashInitCtx_st->cmdHeader_st.hashSlotParamInc = 0x00;
//    ptr_hashInitCtx_st->cmdHeader_st.reserved1 = 0x00;
//    ptr_hashInitCtx_st->cmdHeader_st.reserved2 = 0x00;
//    
//    //Input SG-DMA Descriptor
//    ptr_hashInitCtx_st->inSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_inputData;
//    ptr_hashInitCtx_st->inSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_hashInitCtx_st->inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x0000;
//    ptr_hashInitCtx_st->inSgDmaDes_st.flagAndLength_st.dataLen = dataLen;
//    ptr_hashInitCtx_st->inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_hashInitCtx_st->inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_hashInitCtx_st->inSgDmaDes_st.flagAndLength_st.discard = 0x00;
//	ptr_hashInitCtx_st->inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_hashInitCtx_st->inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//                
//    switch(hashType_en)
//    {
//        case HSM_CMD_HASH_MD5:
//        	hashLen	= HSM_HASH_DIGESTSIZE_MD5;
//            break;
//        case HSM_CMD_HASH_SHA1:
//            hashLen	= HSM_HASH_DIGESTSIZE_SHA1;
//            break;
//        case HSM_CMD_HASH_SHA224:
//            hashLen	= HSM_HASH_DIGESTSIZE_SHA224;
//            break;    
//        case HSM_CMD_HASH_SHA256:
//            hashLen	= HSM_HASH_DIGESTSIZE_SHA256;
//            break;  
//        case HSM_CMD_HASH_SHA384:
//            hashLen	= HSM_HASH_DIGESTSIZE_SHA384;
//            break;   
//        case HSM_CMD_HASH_SHA512:
//            hashLen	= HSM_HASH_DIGESTSIZE_SHA512;
//            break;              
//        default:
//            hashLen = 0;
//            break;
//    }
//        
//    //Output SG-DMA Descriptor
//    ptr_hashInitCtx_st->outSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_outData;
//    ptr_hashInitCtx_st->outSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_hashInitCtx_st->outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_hashInitCtx_st->outSgDmaDes_st.flagAndLength_st.dataLen = hashLen; //length of the hash
//    ptr_hashInitCtx_st->outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_hashInitCtx_st->outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_hashInitCtx_st->outSgDmaDes_st.flagAndLength_st.discard = 0x00;
//    ptr_hashInitCtx_st->outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_hashInitCtx_st->outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//	
//    //Hash Parameter 1
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotNum = 0;
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotData_st.apl = 0;
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotData_st.exStorage = 0;
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotData_st.hsmOnly = 0;
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotData_st.storageType = 0;
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotData_st.valid = 0;
//    ptr_hashInitCtx_st->initCmdParm1_st.reserved1 = 0x00;
//    ptr_hashInitCtx_st->initCmdParm1_st.reserved2 = 0x00;
//    ptr_hashInitCtx_st->initCmdParm1_st.varSlotData_st.reserved1 = 0x00;
//    SYS_PRINT("-------------Block CMD FINISHED----------\r\n");
//}

void HSM_Hash_CmdResponse(st_Hsm_Hash_CmdResponse cmdResp_st) 
{
//    uint32_t                mbrxstatus;
//    uint16_t                cmdSizeWds;
//    uint8_t                 i;
//    //uint32_t cmdHeader;
//    uint32_t hdr;

//    // Check for response recieved by reading RXINT
//    mbrxstatus = HSM_REGS->HSM_MBRXSTATUS;
//
//    //Poll RXINT in non-interrupt mode 
//    //  (in interrupt mode this 'while' acts as an 'if')
//    while ((mbrxstatus & MBRXSTATUS_RXINT_MASK) != MBRXSTATUS_RXINT_MASK) 
//        { mbrxstatus = HSM_REGS->HSM_MBRXSTATUS; }
//    
//    // Check Mailbox Header
//    hdr = HSM_REGS->HSM_MBRXHEAD;
//    cmdResp_st.mailBoxHdr_st.msgSize = (uint16_t)(mailBxHdr & 0xFF) ;
//    cmdResp_st.mailBoxHdr_st.unProtection = (uint8_t) ( (mailBxHdr >> 21) & 0x1);
//    
//    // Check Mailbox Command Header
//    hdr = HSM_REGS->HSM_MBFIFO[0]
//    cmdResp_st.cmdHeader_st. = (st_Hsm_Hash_CmdHeader);
//    
//    // Check Response Code
//    cmdResp_st.result_code = HSM_REGS->HSM_MBFIFO[0];
//    
//    // Read the Command Result Data
//    cmdSizeWds = (uint16_t) ((cmdResp_st.mailBoxHdr_st.msgSize) / 4);
//    //cmdSizeWds = min(cmdSizeWds,MAX_RSP_RESULT_WORDS);
//    gHsmCmdResp.numResultWords = cmdSizeWds - 3;
//    for (i = 0; i < cmdSizeWds - 3; i++) 
//    { 
//        gHsmCmdResp.resultData[i] = HSM_REGS->HSM_MBFIFO[0]; 
//        //SYS_PRINT("RSP  W%d: 0x%08lx\r\n", i, gHsmCmdResp.resultData[i]);
//    }
}

//st_Hsm_Hash_InitCmd HashInitCmd =   {   
//                                        //Mail Box Header
//                                        {
//                                            .mailBoxHdr_st.msgSize      = 0x14,
//                                            .mailBoxHdr_st.unProtection = 0x00,
//                                        },
//
//                                        //Command Header    
//                                        {
//                                            .cmdHeader_st.hashCmdGroup_en   = HSM_CMD_HASH, 
//                                            .cmdHeader_st.hashCmdType_en    = HSM_CMD_HASH_INIT,
//                                            .cmdHeader_st.hashType_en       = HSM_CMD_HASH_SHA1, //by default SHA1 but it can be anything
//                                            .cmdHeader_st.hashAuthInc       = 0x00,
//                                            .cmdHeader_st.hashSlotParamInc  = 0x00
//                                        },
//
//                                        //Input SG-DMA Descriptor
//                                        {
//                                            .inSgDmaDes_st.ptr_dataAddr         = NULL, //Input data for Hash calculation 
//                                            .inSgDmaDes_st.stop                 = 0x1,
//                                            .inSgDmaDes_st.nextDescriptorAddr   = NULL,
//                                            .inSgDmaDes_st.dataLen              = 0x00, //Length of the input data 
//                                            .inSgDmaDes_st.cstAddr              = 0x00,
//                                            .inSgDmaDes_st.reAlign              = 0x1,
//                                            .inSgDmaDes_st.discard              = 0x00
//                                        },
//
//                                        //Output SG-DMA Descriptor        
//                                        {
//                                            .outSgDmaDes_st.ptr_dataAddr        = NULL, //Address of buffer to store Hash Data
//                                            .outSgDmaDes_st.stop                = 0x1,  
//                                            .outSgDmaDes_st.nextDescriptorAddr  = NULL,  
//                                            .outSgDmaDes_st.dataLen             = 0x00, //Len of the Hash
//                                            .outSgDmaDes_st.cstAddr             = 0x00,
//                                            .outSgDmaDes_st.reAlign             = 0x1,
//                                            .outSgDmaDes_st.discard             = 0x00
//                                        },
//
//                                        //Command Parameter 1        
//                                        {
//                                            .initCmdParm1_st.varSlotNum     = 0x00,
//                                            .initCmdParm1_st.varSlotData    = 0x00
//                                        },
//                                    };	


