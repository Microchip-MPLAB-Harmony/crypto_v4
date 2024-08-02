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

#include "hsm_sign.h"
#include "hsm_cmd.h"

extern st_Hsm_Vsm_Ecc_CurveData CurveData[HSM_ECC_MAX_CURVE];

int Hsm_Vsm_Ecc_FillEccKeyProperties(st_Hsm_Vss_Ecc_AsymKeyDataType *ptr_eccKey_st, hsm_Ecc_CurveType_E curveType_en, uint8_t PrivPubkeyType)
{
    int curveIndexStatus = -1;
    uint8_t curveIndex = 0;
    int ret_status = -1;

    curveIndexStatus = Hsm_Vsm_Ecc_FindCurveIndex(curveType_en, &curveIndex);
    
    if(curveIndexStatus == 0)
    {
        //Public and Private ECC Key properties for data type
        ptr_eccKey_st->asymKeyType_en = HSM_VSM_ASYMKEY_ECC;
        ptr_eccKey_st->eccKeyType_en = CurveData[curveIndex].curveKeyType_en;
        ptr_eccKey_st->eccKeySize = CurveData[curveIndex].privKeySize;
        ptr_eccKey_st->paramA = 0x00; //This also can be enum but need to analysis and correct ??????????????????????????????????
        ptr_eccKey_st->signUsed_en = HSM_VSM_ASYMKEY_ECC_SIGNATURE;  //This value need to confirm ??????? ??????? 
        ptr_eccKey_st->algoUsed_en = HSM_VSM_ASYMKEY_ECC_ECDSA; //This value need to confirm ??????????????
        ptr_eccKey_st->domainIncBit = 0x00;
 
        ret_status = 0;
        
        if(PrivPubkeyType == 0x01u)
        {
            ptr_eccKey_st->publicKeyIncBit = 0x00;
            ptr_eccKey_st->privateKeyIncBit = 0x01;
        }
        else if(PrivPubkeyType == 0x02u)
        {
            ptr_eccKey_st->publicKeyIncBit = 0x01;
            ptr_eccKey_st->privateKeyIncBit = 0x00; 
        }
        else
        {
          ret_status = -1;  
        }        
        
        ptr_eccKey_st->reserved1 = 0x00;
        ptr_eccKey_st->reserved2 = 0x00;
        ptr_eccKey_st->reserved3 = 0x00;
        ptr_eccKey_st->reserved4 = 0x00;
        ptr_eccKey_st->reserved5 = 0x00;
        ptr_eccKey_st->reserved6 = 0x00;
    }
    else
    {
        ret_status = -1;
    }
    
    return ret_status;
}

static void Hsm_DigiSign_Cmd(st_Hsm_DigiSign_Cmd *ptr_digiSignCmd_st, uint8_t cmdLen, hsm_DigiSign_CmdType_E cmdType_en,
                                     hsm_DigiSign_HashAlgo_E hashAlgo_en, hsm_DigiSign_PadType_E padType_en, hsm_DigiSign_KeyType_E keyType_en)
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
    ptr_digiSignCmd_st->cmdHeader_st.reserved1 = 0x00;
    ptr_digiSignCmd_st->cmdHeader_st.reserved2 = 0x00;
    ptr_digiSignCmd_st->cmdHeader_st.reserved3 = 0x00;
     ptr_digiSignCmd_st->cmdHeader_st.reserved4 = 0x01; //this is for random number
}

hsm_Cmd_Status_E Hsm_DigiSign_Ecdsa_Sign(st_Hsm_DigiSign_Cmd *ptr_ecdsaCmd_st, uint8_t *ptr_hashData, uint32_t hashDataLen, uint8_t *ptr_outSign, 
                                uint32_t signLen, uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_randomNumber, hsm_Ecc_CurveType_E keyCurveType_en)
{
    
    st_Hsm_Vss_Ecc_AsymKeyDataType privKeyType_st; 
    hsm_Cmd_Status_E ret_ecdsaStatus_en; 
    int status = -1;
    
    Hsm_DigiSign_Cmd(ptr_ecdsaCmd_st, 0x1c, HSM_DIGISIGN_CMD_SIGN, HSM_DIGISIGN_SHA256, 0x00, HSM_DIGISIGN_KEY_ECC);
    
    status = Hsm_Vsm_Ecc_FillEccKeyProperties(&privKeyType_st, keyCurveType_en, 0x01);
    
    
    if(status == 0)
    {
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&privKeyType_st;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1])>>2);
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_privKey;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2])>>2);
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 3 for Random Number Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_randomNumber;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3])>>2);
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = privKeyLen;  //here Random Number length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 4 for Hash Data Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_hashData;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].nextDes_st.stop = 0x01; // stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.dataLen = hashDataLen;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;
        
        //Output SG-DMA Descriptor 1 for Signature Output
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_outSign;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.stop = 0x01; //stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = signLen;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Parameter 1 for Ecdsa
        ptr_ecdsaCmd_st->digiSignParm1_st.useInputSlot = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.useOutputSlot = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.inputSlotIndex = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.apl = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.hsmOnly = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.storageType = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.valid = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.ExtStorage = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.reserved1 = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outSlotIndex = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.reserved1 = 0x00;
        
        //Parameter 2 for ECDSA
        ptr_ecdsaCmd_st->dataLenParm2 = hashDataLen;

        //Parameter 3 for ECDSA //Salt Len
        ptr_ecdsaCmd_st->saltLenParm3 = 0x00;
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ptr_ecdsaCmd_st->mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ptr_ecdsaCmd_st->cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_ecdsaCmd_st->arr_inSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_ecdsaCmd_st->arr_outSgDmaDes_st;
    sendCmd_st.ptr_params = (uint32_t*)&(ptr_ecdsaCmd_st->digiSignParm1_st);
    sendCmd_st.paramsCount = (uint8_t)((ptr_ecdsaCmd_st->mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for ECDSA Signing Cmd
    ret_ecdsaStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-12), *sendCmd_st.algocmdHdr);
    
    return ret_ecdsaStatus_en;
}


hsm_Cmd_Status_E Hsm_DigiSign_Ecdsa_Verify(st_Hsm_DigiSign_Cmd *ptr_ecdsaCmd_st, uint8_t *ptr_hashData, uint32_t hashDataLen, uint8_t *ptr_inputSign, 
                                uint32_t signLen, uint8_t *ptr_pubKey, uint32_t pubKeyLen, int8_t *ptr_verifyStatus, hsm_Ecc_CurveType_E keyCurveType_en)
{
    
    st_Hsm_Vss_Ecc_AsymKeyDataType pubKeyType_st;
    hsm_Cmd_Status_E ret_ecdsaStatus_en;     
    int status = -1;
    
    Hsm_DigiSign_Cmd(ptr_ecdsaCmd_st, 0x1c, HSM_DIGISIGN_CMD_VERIFY, 0x00, 0x00, HSM_DIGISIGN_KEY_ECC);
    
    status = Hsm_Vsm_Ecc_FillEccKeyProperties(&pubKeyType_st, keyCurveType_en, 0x02);
    
    
    if(status == 0)
    {
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&pubKeyType_st;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1])>>2);
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_pubKey;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2])>>2);
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.dataLen = pubKeyLen;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 3 for Random Number Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_hashData;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3])>>2);
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = hashDataLen;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 4 for Hash Data Descriptor
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_inputSign;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].nextDes_st.stop = 0x01; // stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.dataLen = signLen;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;
        
        //No Output SG-DMA Descriptor 1 for Verification
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].ptr_dataAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.stop = 0x01; //stop
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 0x00;  //here key length is entered
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdsaCmd_st->arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Parameter 1 for Ecdsa Verification
        ptr_ecdsaCmd_st->digiSignParm1_st.useInputSlot = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.useOutputSlot = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.reserved1 = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.inputSlotIndex = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.apl = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.hsmOnly = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.storageType = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.valid = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.ExtStorage = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outputSlotStorDes_st.reserved1 = 0x00;
        ptr_ecdsaCmd_st->digiSignParm1_st.outSlotIndex = 0x00;
        
        //Parameter 2 for ECDH
        ptr_ecdsaCmd_st->dataLenParm2 = hashDataLen;

        //Parameter 3 for ECDH
        ptr_ecdsaCmd_st->saltLenParm3 = 0x00;
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ptr_ecdsaCmd_st->mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ptr_ecdsaCmd_st->cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_ecdsaCmd_st->arr_inSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_ecdsaCmd_st->arr_outSgDmaDes_st;
    sendCmd_st.ptr_params = (uint32_t*)&(ptr_ecdsaCmd_st->digiSignParm1_st);
    sendCmd_st.paramsCount = (uint8_t)((ptr_ecdsaCmd_st->mailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);   
    
    //Check the command response with expected values for ECDSA Verification Cmd
    ret_ecdsaStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-12), *sendCmd_st.algocmdHdr);
    
    return ret_ecdsaStatus_en;
}


