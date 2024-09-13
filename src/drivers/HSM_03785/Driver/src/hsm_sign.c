/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_sign.c

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
#include "stdlib.h"
#include "hsm_sign.h"
#include "hsm_cmd.h"

static void Hsm_DigiSign_Cmd(st_Hsm_DigiSign_Cmd *ptr_digiSignCmd_st, uint8_t cmdLen, hsm_DigiSign_CmdType_E cmdType_en,
                                     hsm_DigiSign_HashAlgo_E hashAlgo_en, hsm_DigiSign_PadType_E padType_en, hsm_DigiSign_KeyType_E keyType_en,
                                     uint8_t rngInclude)
{
    //Mailbox Header
    ptr_digiSignCmd_st->mailBoxHdr_st.msgSize =  cmdLen;
    ptr_digiSignCmd_st->mailBoxHdr_st.unProtection = 0x1;
    ptr_digiSignCmd_st->mailBoxHdr_st.reserved1 = 0x00;
    ptr_digiSignCmd_st->mailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_digiSignCmd_st->cmdHeader_st.cmdGroup_en = HSM_CMD_SIGN;
    ptr_digiSignCmd_st->cmdHeader_st.cmdType_en = cmdType_en; //Command Type is 0 for Dh
    ptr_digiSignCmd_st->cmdHeader_st.hashAlgo_en = hashAlgo_en;
    ptr_digiSignCmd_st->cmdHeader_st.padType_en = padType_en;
    ptr_digiSignCmd_st->cmdHeader_st.authInc = 0x00;
    ptr_digiSignCmd_st->cmdHeader_st.slotParamInc = 0x00;
    
    ptr_digiSignCmd_st->cmdHeader_st.keyType_en = keyType_en;
    if(rngInclude == 0x01U)
    {
        ptr_digiSignCmd_st->cmdHeader_st.nounceK = 0x01; //Random number is included in the descriptor
    }
    else
    {
        ptr_digiSignCmd_st->cmdHeader_st.nounceK = 0x00; //Random number is not included in the descriptor
    }
    ptr_digiSignCmd_st->cmdHeader_st.reserved1 = 0x00;
    ptr_digiSignCmd_st->cmdHeader_st.reserved2 = 0x00;
    ptr_digiSignCmd_st->cmdHeader_st.reserved3 = 0x00;
    ptr_digiSignCmd_st->cmdHeader_st.reserved4 = 0x00;
}

hsm_Cmd_Status_E Hsm_DigiSign_Ecdsa_SignData(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_outSign, 
                                uint8_t *ptr_privKey, uint32_t privKeyLen, hsm_DigiSign_HashAlgo_E hashType_en, uint8_t *ptr_randomNumber, hsm_Ecc_CurveType_E keyCurveType_en)
{
    st_Hsm_DigiSign_Cmd ecdsaCmd_st = {0};
    st_Hsm_Vss_Ecc_AsymKeyDataType privKeyType_st; 
    hsm_Cmd_Status_E ret_ecdsaStatus_en; 
    int status = -1;
    if(ptr_randomNumber == NULL)
    {
        Hsm_DigiSign_Cmd(&ecdsaCmd_st, 0x1c, HSM_DIGISIGN_CMD_SIGN, hashType_en, HSM_DIGISIGN_NOPADDING, HSM_DIGISIGN_KEY_ECC, 0x00);
    }
    else
    {
        Hsm_DigiSign_Cmd(&ecdsaCmd_st, 0x1c, HSM_DIGISIGN_CMD_SIGN, hashType_en, HSM_DIGISIGN_NOPADDING, HSM_DIGISIGN_KEY_ECC, 0x01);
    }
    
    status = Hsm_Vsm_Ecc_FillEccKeyProperties(&privKeyType_st, keyCurveType_en, HSM_VSM_ASYMKEY_PRIVATEKEY,HSM_VSM_ASYMKEY_ECC_SIGNATURE,HSM_VSM_ASYMKEY_ECC_ECDSA);

    if(status == 0)
    {              
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&privKeyType_st;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[1])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_privKey;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[2])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
    if(ptr_randomNumber != NULL)
    {    
        //Input SG-DMA Descriptor 3 for Random Number Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_randomNumber;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[3])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = privKeyLen;  //here Random Number length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 4 for Hash Data Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_data;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].nextDes_st.stop = 0x01; // stop
        ecdsaCmd_st.arr_inSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.dataLen = dataLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;
    }
    else
    {
        //Input SG-DMA Descriptor 3 for Hash Data Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_data;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.stop = 0x01; // stop
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = dataLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
    }   
        //Output SG-DMA Descriptor 1 for Signature Output
        ecdsaCmd_st.arr_outSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&ptr_outSign[0];
        ecdsaCmd_st.arr_outSgDmaDes_st[0].nextDes_st.stop = 0x00; //stop
        ecdsaCmd_st.arr_outSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_outSgDmaDes_st[1])>>2);
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Output SG-DMA Descriptor 1 for Signature Output
        ecdsaCmd_st.arr_outSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)&ptr_outSign[privKeyLen];
        ecdsaCmd_st.arr_outSgDmaDes_st[1].nextDes_st.stop = 0x01; //stop
        ecdsaCmd_st.arr_outSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[1].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_outSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_outSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
        
        //Parameter 1 for Ecdsa
        ecdsaCmd_st.digiSignParm1_st.useInputSlot = 0x00;
        ecdsaCmd_st.digiSignParm1_st.useOutputSlot = 0x00;
        ecdsaCmd_st.digiSignParm1_st.inputSlotIndex = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.apl = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.hsmOnly = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.storageType = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.valid = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.ExtStorage = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.reserved1 = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outSlotIndex = 0x00;
        ecdsaCmd_st.digiSignParm1_st.reserved1 = 0x00;
        
        //Parameter 2 for ECDSA //Input Hash Data
        ecdsaCmd_st.dataLenParm2 = dataLen;

        //Parameter 3 for ECDSA //Salt Len
        ecdsaCmd_st.saltLenParm3 = 0x00;
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ecdsaCmd_st.mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ecdsaCmd_st.cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ecdsaCmd_st.arr_inSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ecdsaCmd_st.arr_outSgDmaDes_st;
    sendCmd_st.ptr_params = (uint32_t*)&(ecdsaCmd_st.digiSignParm1_st);
    sendCmd_st.paramsCount = (uint8_t)((ecdsaCmd_st.mailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for ECDSA Signing Cmd
    ret_ecdsaStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-12U), *sendCmd_st.algocmdHdr);
    
    //Here Result pass or failed condition needs to be added???????????????????
    
    return ret_ecdsaStatus_en;
}

hsm_Cmd_Status_E Hsm_DigiSign_Ecdsa_VerifyData(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_inputSign, uint8_t *ptr_pubKey, uint32_t pubKeyLen,
                                            hsm_DigiSign_HashAlgo_E hashType_en, int8_t *ptr_verifyStatus, hsm_Ecc_CurveType_E keyCurveType_en)
{
    st_Hsm_DigiSign_Cmd ecdsaCmd_st;
    st_Hsm_Vss_Ecc_AsymKeyDataType pubKeyType_st;
    hsm_Cmd_Status_E ret_ecdsaStatus_en;     
    int status = -1;
    *ptr_verifyStatus = 0x00; //Default set the signature verification to 0
    
    Hsm_DigiSign_Cmd(&ecdsaCmd_st, 0x1c, HSM_DIGISIGN_CMD_VERIFY, hashType_en, HSM_DIGISIGN_NOPADDING, HSM_DIGISIGN_KEY_ECC, 0x00); //?? hash type
    
    status = Hsm_Vsm_Ecc_FillEccKeyProperties(&pubKeyType_st, keyCurveType_en, HSM_VSM_ASYMKEY_PUBLICKEY,HSM_VSM_ASYMKEY_ECC_KEYEXCHANGE,HSM_VSM_ASYMKEY_ECC_ECDSA);
    
    if(status == 0)
    {
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&pubKeyType_st;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[1])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_pubKey;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[2])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.dataLen = pubKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 3 for Random Number Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_data;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[3])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = dataLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 4 for Hash Data Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_inputSign;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].nextDes_st.stop = 0x01; // stop
        ecdsaCmd_st.arr_inSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.dataLen = pubKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;
        
        //Parameter 1 for Ecdsa Verification
        ecdsaCmd_st.digiSignParm1_st.useInputSlot = 0x00;
        ecdsaCmd_st.digiSignParm1_st.useOutputSlot = 0x00;
        ecdsaCmd_st.digiSignParm1_st.reserved1 = 0x00;
        ecdsaCmd_st.digiSignParm1_st.inputSlotIndex = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.apl = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.hsmOnly = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.storageType = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.valid = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.ExtStorage = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outputSlotStorDes_st.reserved1 = 0x00;
        ecdsaCmd_st.digiSignParm1_st.outSlotIndex = 0x00;
        
        //Parameter 2 for ECDSA
        ecdsaCmd_st.dataLenParm2 = dataLen;

        //Parameter 3 for ECDSA
        ecdsaCmd_st.saltLenParm3 = 0x00;
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ecdsaCmd_st.mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ecdsaCmd_st.cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ecdsaCmd_st.arr_inSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)0x00000000;
    sendCmd_st.ptr_params = (uint32_t*)&(ecdsaCmd_st.digiSignParm1_st);
    sendCmd_st.paramsCount = (uint8_t)((ecdsaCmd_st.mailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);   
    
    //Check the command response with expected values for ECDSA Verification Cmd
    ret_ecdsaStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-16U), *sendCmd_st.algocmdHdr);
    
    if(ret_ecdsaStatus_en != HSM_CMD_SUCCESS)
    {
        if(cmdResponse_st.resultCode_en == HSM_CMD_RC_SIGNVERIFYFAILED)
        {
            *ptr_verifyStatus = 0x00;
            ret_ecdsaStatus_en = HSM_CMD_SUCCESS;
        }
    }
    else
    {
        *ptr_verifyStatus = 0x01;
    }
    
    return ret_ecdsaStatus_en;
}


