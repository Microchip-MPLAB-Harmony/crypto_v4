/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_sym.c

  @Summary
    AES Encrypt/Decrypt

  @Description
    AES  Encrypt/Decrypt
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
#include "hsm_sym.h"
#include "hsm_cmd.h"

hsm_Cmd_Status_E Hsm_Sym_Tdes_CipherDirect(st_Hsm_Sym_Tdes_Cmd *ptr_tdesCmd_st, hsm_Sym_Tdes_ModeTypes_E tdesModeType_en, hsm_Tdes_CmdTypes_E tdesOperType_en, 
                            uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut, uint8_t *tdesKey, uint8_t *ptr_initVect, uint8_t varslotNum)
{
    hsm_Cmd_Status_E ret_status_en = HSM_CMD_ERROR_FAILED;
    Hsm_Sym_Tdes_Init(ptr_tdesCmd_st, tdesModeType_en, tdesOperType_en, tdesKey, ptr_initVect, varslotNum);
    ret_status_en = Hsm_Sym_Tdes_Cipher(ptr_tdesCmd_st, ptr_dataIn, inputDataLen, ptr_dataOut);
    
    return ret_status_en;
}

//Init will initialize the Key, IV, AES Mode and Operation type (encryption or decryption) 
void Hsm_Sym_Tdes_Init(st_Hsm_Sym_Tdes_Cmd *ptr_tdesCmd_st, hsm_Sym_Tdes_ModeTypes_E tdesModeType_en, hsm_Tdes_CmdTypes_E tdesOperType_en, 
                        uint8_t *tdesKey, uint8_t *ptr_initVect, uint8_t varslotNum)
{
    //Mailbox Header
    ptr_tdesCmd_st->tdesMailBoxHdr_st.msgSize =  0x18;
    ptr_tdesCmd_st->tdesMailBoxHdr_st.unProtection = 0x1;
    ptr_tdesCmd_st->tdesMailBoxHdr_st.reserved1 = 0x00;
    ptr_tdesCmd_st->tdesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_tdesCmd_st->tdesCmdHeader_st.tdesCmdGroup_en = HSM_CMD_TDES;
    ptr_tdesCmd_st->tdesCmdHeader_st.tdesCmdType_en = tdesOperType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_tdesCmd_st->tdesCmdHeader_st.tdesMode_en = tdesModeType_en;
    ptr_tdesCmd_st->tdesCmdHeader_st.desAuthInc = 0x00;
    ptr_tdesCmd_st->tdesCmdHeader_st.desSlotParamInc = 0x00;
    ptr_tdesCmd_st->tdesCmdHeader_st.reserved1 = 0x00;
    ptr_tdesCmd_st->tdesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)tdesKey;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[1])>>2);
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].flagAndLength_st.dataLen = 24;  //here key length is entered
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    
    //Input SG-DMA Descriptor 2 for IV
    if(tdesModeType_en == HSM_SYM_DES_OPMODE_ECB)
    {

    }
    else
    {
        //do nothing //because IV is not required for ECB mode
    }
    
    //AES Parameter 2
    ptr_tdesCmd_st->tdesCmdParm2_st.useCtx = 0x00;
    ptr_tdesCmd_st->tdesCmdParm2_st.resetIV = 0x00;  //this need to study ??????????????????????????????
    ptr_tdesCmd_st->tdesCmdParm2_st.varSlotNum = varslotNum; //This also need to develop when slot number is used to fetch key//?????????
    ptr_tdesCmd_st->tdesCmdParm2_st.reserved1 = 0x00;
    
}

hsm_Cmd_Status_E Hsm_Sym_Tdes_Cipher(st_Hsm_Sym_Tdes_Cmd *ptr_tdesCmd_st, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut)
{
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    hsm_Cmd_Status_E ret_tdesStatus_en;
            
    uint8_t inputIndex = 0;
    
    //AES Parameter 1
    ptr_tdesCmd_st->tdesInputDataLenParm1 = inputDataLen;
    
    //Output SG-DMA Descriptor 1
    ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)(ptr_dataOut);
    ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen; //length of the Output data which will be same as input Len
    ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    
    if(ptr_tdesCmd_st->tdesCmdHeader_st.tdesMode_en == HSM_SYM_DES_OPMODE_CBC)
    {
        inputIndex = 2;
        //Output SG-DMA Descriptor 1
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1])>>2);
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].nextDes_st.stop = 0x00; //Do not stop after this descriptor 1 
        
        //Output SG-DMA Descriptor 2
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)(ptr_tdesCmd_st->arr_tdesIvCtx);
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = (uint32_t)0x00;
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //stop after this descriptor 2           
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].flagAndLength_st.dataLen = 16; //length of the data in bytes and it is always 16 bytes
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        
    }
    else if(ptr_tdesCmd_st->tdesCmdHeader_st.tdesMode_en == HSM_SYM_DES_OPMODE_ECB)
    {
        inputIndex = 1;
        //Output SG-DMA Descriptor 1
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = (uint32_t)0x00;
        ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st[0].nextDes_st.stop = 0x01; //stop after this descriptor 1 for ECB mode
    }
    else
    {
        //do nothing
    }
    
    //Input SG-DMA Descriptor for Plain Text/ Encrypted Text for Any Mode
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].ptr_dataAddr = (uint32_t*)(ptr_dataIn); 
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].flagAndLength_st.dataLen = inputDataLen;  //length of input data in bytes
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].nextDes_st.stop = 0x01; //Stop after this
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].flagAndLength_st.cstAddr = 0x00;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].flagAndLength_st.reAlign = 0x01;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].flagAndLength_st.discard = 0x00;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].flagAndLength_st.intEn = 0x00;
    ptr_tdesCmd_st->arr_tdesInSgDmaDes_st[inputIndex].nextDes_st.reserved1 = 0x00; 

    sendCmd_st.mailBoxHdr = (uint32_t*)(&ptr_tdesCmd_st->tdesMailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)(&ptr_tdesCmd_st->tdesCmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)(ptr_tdesCmd_st->arr_tdesInSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)(ptr_tdesCmd_st->arr_tdesOutSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(ptr_tdesCmd_st->tdesInputDataLenParm1);
    sendCmd_st.paramsCount = (uint8_t)((ptr_tdesCmd_st->tdesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);

    //Check the command response with expected values for Tdes Cmd
    ret_tdesStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-8UL), *sendCmd_st.algocmdHdr);
     
    return ret_tdesStatus_en;
}

hsm_Cmd_Status_E Hsm_Sym_Aes_CipherDirect(st_Hsm_Sym_Aes_Cmd *ptr_aesCmd_st, hsm_Sym_Aes_ModeTypes_E modeType_en, hsm_Aes_CmdTypes_E operType_en, 
                            uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut, uint8_t *ptr_aeskey, hsm_Aes_KeySize_E keyLen_en, 
                            uint8_t *ptr_initVect, uint8_t varslotNum)
{
    hsm_Cmd_Status_E ret_aesStatus_en;
    Hsm_Sym_Aes_Init(ptr_aesCmd_st, modeType_en, operType_en, ptr_aeskey, keyLen_en, ptr_initVect, varslotNum);
    
    ret_aesStatus_en = Hsm_Sym_Aes_Cipher(ptr_aesCmd_st, ptr_dataIn, inputDataLen, ptr_dataOut);
    
    return ret_aesStatus_en;
}

//Init will initialize the Key, IV, AES Mode and Operation type (encryption or decryption) 
void Hsm_Sym_Aes_Init(st_Hsm_Sym_Aes_Cmd *ptr_aesCmd_st, hsm_Sym_Aes_ModeTypes_E aesModeType_en, hsm_Aes_CmdTypes_E aesOperType_en, 
                        uint8_t *ptr_aeskey, hsm_Aes_KeySize_E keyLen_en, uint8_t *ptr_initVect, uint8_t varslotNum)
{
    //Mailbox Header
    ptr_aesCmd_st->aesMailBoxHdr_st.msgSize =  0x18;
    ptr_aesCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
    ptr_aesCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
    ptr_aesCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_aesCmd_st->aesCmdHeader_st.aesCmdGroup_en = HSM_CMD_AES;
    ptr_aesCmd_st->aesCmdHeader_st.aesCmdType_en = aesOperType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_aesCmd_st->aesCmdHeader_st.aesKeySize_en = keyLen_en;
    ptr_aesCmd_st->aesCmdHeader_st.aesModeType_en = aesModeType_en;
    ptr_aesCmd_st->aesCmdHeader_st.aesAuthInc = 0x00;
    ptr_aesCmd_st->aesCmdHeader_st.aesSlotParamInc = 0x00;
    ptr_aesCmd_st->aesCmdHeader_st.reserved1 = 0x00;
    ptr_aesCmd_st->aesCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for AES Key
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)(ptr_aeskey);
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesCmd_st->arr_aesInSgDmaDes_st[1])>>2);
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)(((uint32_t)keyLen_en*8UL)+16UL);  //here key length is entered
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    
    
    //Input SG-DMA Descriptor 2 for IV
    if(aesModeType_en != HSM_SYM_AES_OPMODE_ECB)
    {
        //copy the iv
        for(int count = 0; count < 16; count++)
        {
            ptr_aesCmd_st->arr_aesIvCtx[count] = ptr_initVect[count];
        }
    
        if( (aesModeType_en == HSM_SYM_AES_OPMODE_CBC) || (aesModeType_en == HSM_SYM_AES_OPMODE_CTR) )
        {
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)(ptr_aesCmd_st->arr_aesIvCtx);
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesCmd_st->arr_aesInSgDmaDes_st[2])>>2);
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = 16;  //128 bit of IV for AES
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
            ptr_aesCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
        }
    }
    else
    {
        //do nothing //because IV is not required for ECB mode
    }
    
    //AES Parameter 2
    ptr_aesCmd_st->aesCmdParm2_st.useCtx = 0x00;
    ptr_aesCmd_st->aesCmdParm2_st.resetIV = 0x00;  //this need to study ??????????????????????????????
    ptr_aesCmd_st->aesCmdParm2_st.varSlotNum = varslotNum; //This also need to develop when slot number is used to fetch key//?????????
    ptr_aesCmd_st->aesCmdParm2_st.reserved1 = 0x00;
}


hsm_Cmd_Status_E Hsm_Sym_Aes_Cipher(st_Hsm_Sym_Aes_Cmd *ptr_aesCmd_st, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut)
{   
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    hsm_Cmd_Status_E ret_aesStatus_en = HSM_CMD_SUCCESS;
    
    uint8_t inputIndex = 0;
    
    //AES Parameter 1
    ptr_aesCmd_st->aesInputDataLenParm1 = inputDataLen;
    
    //Output SG-DMA Descriptor 1
    ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)(ptr_dataOut);
    ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.dataLen = inputDataLen; //length of the Output data which will be same as input Len
    ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
    ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    
    if( (ptr_aesCmd_st->aesCmdHeader_st.aesModeType_en == HSM_SYM_AES_OPMODE_CBC) ||
                (ptr_aesCmd_st->aesCmdHeader_st.aesModeType_en == HSM_SYM_AES_OPMODE_CTR) )
                    
    {
        inputIndex = 2;
        //Output SG-DMA Descriptor 1
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = ((uint32_t)(&ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1])>>2);
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x00; //Do not stop after this descriptor 1 
        
        //Output SG-DMA Descriptor 2
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)(ptr_aesCmd_st->arr_aesIvCtx);
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.nextDescriptorAddr = (uint32_t)0x00;
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].nextDes_st.stop = 0x01; //stop after this descriptor 2           
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.dataLen = 16; //length of the data in bytes and it is always 16 bytes
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.reAlign = 0x00;
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        
    }
//    else if(ptr_aesCmd_st->aesCmdHeader_st.aesModeType_en == HSM_SYM_AES_CTR)
//    {
//        
//    }
    else if(ptr_aesCmd_st->aesCmdHeader_st.aesModeType_en == HSM_SYM_AES_OPMODE_ECB)
    {
        inputIndex = 1;
        //Output SG-DMA Descriptor 1
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = (uint32_t)0x00;
        ptr_aesCmd_st->arr_aesOutSgDmaDes_st[0].nextDes_st.stop = 0x01; //stop after this descriptor 1 for ECB mode
    }
    else
    {
        //do nothing
    }
    
    //Input SG-DMA Descriptor for Plain Text/ Encrypted Text for Any Mode
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].ptr_dataAddr = (uint32_t*)ptr_dataIn; 
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].flagAndLength_st.dataLen = inputDataLen;  //length of input data in bytes
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].nextDes_st.stop = 0x01; //Stop after this
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].nextDes_st.nextDescriptorAddr = (uint32_t)0x00;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].flagAndLength_st.cstAddr = 0x00;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].flagAndLength_st.reAlign = 0x01;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].flagAndLength_st.discard = 0x00;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].flagAndLength_st.intEn = 0x00;
    ptr_aesCmd_st->arr_aesInSgDmaDes_st[inputIndex].nextDes_st.reserved1 = 0x00; 

    sendCmd_st.mailBoxHdr = (uint32_t*)&(ptr_aesCmd_st->aesMailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ptr_aesCmd_st->aesCmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)(ptr_aesCmd_st->arr_aesInSgDmaDes_st);
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)(ptr_aesCmd_st->arr_aesOutSgDmaDes_st);
    sendCmd_st.ptr_params = (uint32_t*)&(ptr_aesCmd_st->aesInputDataLenParm1);
    sendCmd_st.paramsCount = (uint8_t)((ptr_aesCmd_st->aesMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);

    //Check the command response with expected values for AES Encrypt Cmd
    ret_aesStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-12UL), *sendCmd_st.algocmdHdr);
    
    return ret_aesStatus_en;
}

//
//void Hsm_Sym_ChaCha20_CipherDirect(st_Hsm_ChaCha20_Cmd *ptr_chachaCtx_st, hsm_ChaCha20_CmdTypes_E operCmdType_en, 
//                            uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut, uint8_t *key, hsm_Sym_Aes_KeySize_E keyLen_en, uint8_t varslotNum)
//{
//    //Mailbox Header
//    ptr_aesCtx_st->mailBoxHdr_st.msgSize =  0x18;
//    ptr_aesCtx_st->mailBoxHdr_st.unProtection = 0x1;
//    ptr_aesCtx_st->mailBoxHdr_st.reserved1 = 0x00;
//    ptr_aesCtx_st->mailBoxHdr_st.reserved2 = 0x00;
//    
//    //command Header
//    ptr_aesCtx_st->aesCmdHeader_st.aesCmdGroup_en = HSM_CMD_AES;
//    ptr_aesCtx_st->aesCmdHeader_st.aesCmdType_en = operType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
//    ptr_aesCtx_st->aesCmdHeader_st.aesKeySize_en = keyLen_en;
//    ptr_aesCtx_st->aesCmdHeader_st.aesModeType_en = modeType_en;
//    ptr_aesCtx_st->aesCmdHeader_st.aesAuthInc = 0x00;
//    ptr_aesCtx_st->aesCmdHeader_st.aesSlotParamInc = 0x00;
//    ptr_aesCtx_st->aesCmdHeader_st.reserved1 = 0x00;
//    ptr_aesCtx_st->aesCmdHeader_st.reserved2 = 0x00;
//
//    //Input SG-DMA Descriptor
//    ptr_aesCtx_st->inSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_dataIn;
//    ptr_aesCtx_st->inSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_aesCtx_st->inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x0000;
//    ptr_aesCtx_st->inSgDmaDes_st.flagAndLength_st.dataLen = dataLen;
//    ptr_aesCtx_st->inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_aesCtx_st->inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_aesCtx_st->inSgDmaDes_st.flagAndLength_st.discard = 0x00;
//	ptr_aesCtx_st->inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_aesCtx_st->inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//    
//    //Output SG-DMA Descriptor
//    ptr_aesCtx_st->outSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_dataOut;
//    ptr_aesCtx_st->outSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_aesCtx_st->outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_aesCtx_st->outSgDmaDes_st.flagAndLength_st.dataLen = dataLen; //length of the data
//    ptr_aesCtx_st->outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_aesCtx_st->outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_aesCtx_st->outSgDmaDes_st.flagAndLength_st.discard = 0x00;
//    ptr_aesCtx_st->outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_aesCtx_st->outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//    
//    //AES Parameter 1
//    ptr_aesCtx_st->inputDataLenParm1 = dataLen;
//    
//    //AES Parameter 2
//    ptr_aesCtx_st->aesCmdParm2_st.useCtx = 0x00;
//    ptr_aesCtx_st->aesCmdParm2_st.resetIV = 0x01;
//    ptr_aesCtx_st->aesCmdParm2_st.varSlotNum = varslotNum;
//    ptr_aesCtx_st->aesCmdParm2_st.reserved1 = 0x00;
//}


//void Hsm_Sym_Tdes_CipherDirect(st_Hsm_Tdes_Cmd *ptr_tdesCtx_st, hsm_Tdes_CmdTypes_E operCmdType_en, hsm_Sym_Tdes_ModeTypes_E modeType_en,
//                            uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut, uint8_t *key, uint8_t varslotNum)
//{
//    //Mailbox Header
//    ptr_tdesCtx_st->mailBoxHdr_st.msgSize =  0x18;
//    ptr_tdesCtx_st->mailBoxHdr_st.unProtection = 0x1;
//    ptr_tdesCtx_st->mailBoxHdr_st.reserved1 = 0x00;
//    ptr_tdesCtx_st->mailBoxHdr_st.reserved2 = 0x00;
//    
//    //command Header
//    ptr_tdesCtx_st->tdesCmdHeader_st.tdesCmdGroup_en = HSM_CMD_TDES;
//    ptr_tdesCtx_st->tdesCmdHeader_st.tdesCmdType_en = operCmdType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
//    ptr_tdesCtx_st->tdesCmdHeader_st.tdesMode_en = modeType_en;
//    ptr_tdesCtx_st->tdesCmdHeader_st.desAuthInc = 0x00;
//    ptr_tdesCtx_st->tdesCmdHeader_st.desSlotParamInc = 0x00;
//    ptr_tdesCtx_st->tdesCmdHeader_st.reserved1 = 0x00;
//    ptr_tdesCtx_st->tdesCmdHeader_st.reserved2 = 0x00;
//
//    //Input SG-DMA Descriptor
//    ptr_tdesCtx_st->inSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_dataIn;
//    ptr_tdesCtx_st->inSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_tdesCtx_st->inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x0000;
//    ptr_tdesCtx_st->inSgDmaDes_st.flagAndLength_st.dataLen = dataLen;
//    ptr_tdesCtx_st->inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_tdesCtx_st->inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_tdesCtx_st->inSgDmaDes_st.flagAndLength_st.discard = 0x00;
//	ptr_tdesCtx_st->inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_tdesCtx_st->inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//    
//    //Output SG-DMA Descriptor
//    ptr_tdesCtx_st->outSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_dataOut;
//    ptr_tdesCtx_st->outSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_tdesCtx_st->outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_tdesCtx_st->outSgDmaDes_st.flagAndLength_st.dataLen = dataLen; //length of the data
//    ptr_tdesCtx_st->outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_tdesCtx_st->outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_tdesCtx_st->outSgDmaDes_st.flagAndLength_st.discard = 0x00;
//    ptr_tdesCtx_st->outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_tdesCtx_st->outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//    
//    //Tdes Parameter 1
//    ptr_tdesCtx_st->inputDataLenParm1 = dataLen;
//    
//    //Tdes Parameter 2
//    ptr_tdesCtx_st->tdesCmdParm2_st.useCtx = 0x00;
//    ptr_tdesCtx_st->tdesCmdParm2_st.resetIV = 0x01;
//    ptr_tdesCtx_st->tdesCmdParm2_st.varSlotNum = varslotNum;
//    ptr_tdesCtx_st->tdesCmdParm2_st.reserved1 = 0x00;
//}
//
//void Hsm_Sym_Des_CipherDirect(st_Hsm_Des_Cmd *ptr_desCtx_st, hsm_Des_CmdTypes_E operCmdType_en, hsm_Sym_Des_ModeTypes_E modeType_en,
//                            uint8_t *ptr_dataIn, uint32_t dataLen, uint8_t *ptr_dataOut, uint8_t *key, uint8_t varslotNum)
//{
//    //Mailbox Header
//    ptr_desCtx_st->mailBoxHdr_st.msgSize =  0x18;
//    ptr_desCtx_st->mailBoxHdr_st.unProtection = 0x1;
//    ptr_desCtx_st->mailBoxHdr_st.reserved1 = 0x00;
//    ptr_desCtx_st->mailBoxHdr_st.reserved2 = 0x00;
//    
//    //command Header
//    ptr_desCtx_st->desCmdHeader_st.desCmdGroup_en = HSM_CMD_TDES;
//    ptr_desCtx_st->desCmdHeader_st.desCmdType_en = operCmdType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
//    ptr_desCtx_st->desCmdHeader_st.desMode_en = modeType_en;
//    ptr_desCtx_st->desCmdHeader_st.desAuthInc = 0x00;
//    ptr_desCtx_st->desCmdHeader_st.desSlotParamInc = 0x00;
//    ptr_desCtx_st->desCmdHeader_st.reserved1 = 0x00;
//    ptr_desCtx_st->desCmdHeader_st.reserved2 = 0x00;
//
//    //Input SG-DMA Descriptor
//    ptr_desCtx_st->inSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_dataIn;
//    ptr_desCtx_st->inSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_desCtx_st->inSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x0000;
//    ptr_desCtx_st->inSgDmaDes_st.flagAndLength_st.dataLen = dataLen;
//    ptr_desCtx_st->inSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_desCtx_st->inSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_desCtx_st->inSgDmaDes_st.flagAndLength_st.discard = 0x00;
//	ptr_desCtx_st->inSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_desCtx_st->inSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//    
//    //Output SG-DMA Descriptor
//    ptr_desCtx_st->outSgDmaDes_st.ptr_dataAddr = (uint32_t*)ptr_dataOut;
//    ptr_desCtx_st->outSgDmaDes_st.nextDes_st.stop = 0x01;
//    ptr_desCtx_st->outSgDmaDes_st.nextDes_st.nextDescriptorAddr = 0x00;
//    ptr_desCtx_st->outSgDmaDes_st.flagAndLength_st.dataLen = dataLen; //length of the data
//    ptr_desCtx_st->outSgDmaDes_st.flagAndLength_st.cstAddr = 0x00;
//    ptr_desCtx_st->outSgDmaDes_st.flagAndLength_st.reAlign = 0x01;
//    ptr_desCtx_st->outSgDmaDes_st.flagAndLength_st.discard = 0x00;
//    ptr_desCtx_st->outSgDmaDes_st.flagAndLength_st.intEn = 0x00;
//    ptr_desCtx_st->outSgDmaDes_st.nextDes_st.reserved1 = 0x00;
//    
//    //Des Parameter 1
//    ptr_desCtx_st->inputDataLenParm1 = dataLen;
//    
//    //Des Parameter 2
//    ptr_desCtx_st->desCmdParm2_st.useCtx = 0x00;
//    ptr_desCtx_st->desCmdParm2_st.resetIV = 0x01;
//    ptr_desCtx_st->desCmdParm2_st.varSlotNum = varslotNum;
//    ptr_desCtx_st->desCmdParm2_st.reserved1 = 0x00;
//}


void Hsm_Sym_ChaCha_Init(st_Hsm_Sym_ChaCha20_Cmd *ptr_chachaCmd_st, hsm_ChaCha_CmdTypes_E chaChaOperType_en, uint8_t *ptr_tdesKey, 
                            uint8_t *ptr_initVect, uint32_t counter, uint8_t varslotNum)
{
    //Mailbox Header
    ptr_chachaCmd_st->chachaMailBoxHdr_st.msgSize =  0x18;
    ptr_chachaCmd_st->chachaMailBoxHdr_st.unProtection = 0x1;
    ptr_chachaCmd_st->chachaMailBoxHdr_st.reserved1 = 0x00;
    ptr_chachaCmd_st->chachaMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_chachaCmd_st->chachaCmdHeader_st.chachaCmdGroup_en = HSM_CMD_CHACHA;
    ptr_chachaCmd_st->chachaCmdHeader_st.chachaCmdType_en = chaChaOperType_en; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
    ptr_chachaCmd_st->chachaCmdHeader_st.chaChaAuthInc = 0x00;
    ptr_chachaCmd_st->chachaCmdHeader_st.chaChaSlotParamInc = 0x00;
    ptr_chachaCmd_st->chachaCmdHeader_st.reserved1 = 0x00;
    ptr_chachaCmd_st->chachaCmdHeader_st.reserved2 = 0x00;
    
    //Input SG-DMA Descriptor 1 for ChaCha Key
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)(ptr_tdesKey);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1])>>2);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].flagAndLength_st.dataLen = 32;  //here key length is entered in bytes
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
	ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

    //Input SG-DMA Descriptor 2 for IV
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)(ptr_initVect);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2])>>2);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].flagAndLength_st.dataLen = 4;  //here key length is entered in bytes
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
	ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    
    //Input SG-DMA Descriptor 3 for Nonce
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)&counter;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2])>>2);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].flagAndLength_st.dataLen = 12;  //here key length is entered in bytes
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
	ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
    
    //ChaCha Parameter 2
    ptr_chachaCmd_st->chachaCmdParm2_st.useNonce = 0x00;
    ptr_chachaCmd_st->chachaCmdParm2_st.useAadIv = 0x00;  //this need to study ??????????????????????????????
    ptr_chachaCmd_st->chachaCmdParm2_st.varSlotNum = varslotNum; //This also need to develop when slot number is used to fetch key//?????????
    ptr_chachaCmd_st->chachaCmdParm2_st.reserved1 = 0x00;
    ptr_chachaCmd_st->chachaCmdParm2_st.reserved2 = 0x00;
}

void Hsm_Sym_ChaCha20_Cipher(st_Hsm_Sym_ChaCha20_Cmd *ptr_chachaCmd_st, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut)
{
    //Input SG-DMA Descriptor 4 for ChaCha Cipher
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)(ptr_dataIn);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].nextDes_st.stop = 0x01; //do not stop
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00; //((uint32_t)(&ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[1])>>2);
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].flagAndLength_st.dataLen = inputDataLen;  //here key length is entered in bytes
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
	ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
    ptr_chachaCmd_st->arr_chachaInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;
    
    //ChaCha Parameter 1
    ptr_chachaCmd_st->chachaInputDataLenParm1 = inputDataLen;
    
    //Output SG-DMA Descriptor 1 for ChaCha Cipher
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)(ptr_dataOut);
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr = 0x00;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].nextDes_st.stop = 0x01;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].flagAndLength_st.dataLen = 0x00;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
    ptr_chachaCmd_st->arr_chachaOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x00;
}
