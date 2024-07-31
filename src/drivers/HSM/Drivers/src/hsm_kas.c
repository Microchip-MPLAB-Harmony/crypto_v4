/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_kas.c

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

#include "hsm_cmd.h"
#include "hsm_kas.h"

extern st_Hsm_Vsm_Ecc_CurveData CurveData[HSM_ECC_MAX_CURVE];


int Hsm_Vsm_Ecc_FillKeyProperties(st_Hsm_Vss_Ecc_AsymKeyDataType *ptr_eccPrivKey_st, st_Hsm_Vss_Ecc_AsymKeyDataType *ptr_eccPubKey_st, hsm_Ecc_CurveType_E curveType_en)
{
    int curveIndexStatus = -1;
    uint8_t curveIndex = 0;
    int ret_status = -1;
    
   //Public and Private ECC Key properties for data type
    ptr_eccPrivKey_st->asymKeyType_en = HSM_VSM_ASYMKEY_ECC;
    ptr_eccPubKey_st->asymKeyType_en = HSM_VSM_ASYMKEY_ECC;
    
    curveIndexStatus = Hsm_Vsm_Ecc_FindCurveIndex(curveType_en, &curveIndex);
    
    if(curveIndexStatus == 0)
    {
        ptr_eccPrivKey_st->eccKeyType_en = CurveData[curveIndex].curveKeyType_en;
        ptr_eccPrivKey_st->eccKeySize = CurveData[curveIndex].privKeySize;
                
        ptr_eccPubKey_st->eccKeyType_en = CurveData[curveIndex].curveKeyType_en;
        ptr_eccPubKey_st->eccKeySize = CurveData[curveIndex].pubKeySize;
    
        ptr_eccPrivKey_st->paramA = 0x00; //This also can be enum but need to analysis and correct ??????????????????????????????????
        ptr_eccPrivKey_st->signUsed_en = HSM_VSM_ASYMKEY_ECC_SIGNATURE;//HSM_VSM_ASYMKEY_ECC_KEYEXCHANGE;  //This value need to confirm ??????? ??????? 
        ptr_eccPrivKey_st->algoUsed_en = HSM_VSM_ASYMKEY_ECC_ECDSA; //This value need to confirm ??????????????
        ptr_eccPrivKey_st->domainIncBit = 0x00;
        ptr_eccPrivKey_st->publicKeyIncBit = 0x00;
        ptr_eccPrivKey_st->privateKeyIncBit = 0x01;

        ptr_eccPubKey_st->paramA = 0x00; //This also can be enum but need to analysis and correct ??????????????????????????????????
        ptr_eccPubKey_st->signUsed_en = HSM_VSM_ASYMKEY_ECC_SIGNATURE;//HSM_VSM_ASYMKEY_ECC_KEYEXCHANGE;  //This value need to confirm ??????????????
        ptr_eccPubKey_st->algoUsed_en = HSM_VSM_ASYMKEY_ECC_ECDSA;  //This value need to confirm //????????????
        ptr_eccPubKey_st->domainIncBit = 0x00;
        ptr_eccPubKey_st->publicKeyIncBit = 0x01;
        ptr_eccPubKey_st->privateKeyIncBit = 0x00;

        ptr_eccPrivKey_st->reserved1 = 0x00;
        ptr_eccPrivKey_st->reserved2 = 0x00;
        ptr_eccPrivKey_st->reserved3 = 0x00;
        ptr_eccPrivKey_st->reserved4 = 0x00;
        ptr_eccPrivKey_st->reserved5 = 0x00;
        ptr_eccPrivKey_st->reserved6 = 0x00;

        ptr_eccPubKey_st->reserved1 = 0x00;
        ptr_eccPubKey_st->reserved2 = 0x00;
        ptr_eccPubKey_st->reserved3 = 0x00;
        ptr_eccPubKey_st->reserved4 = 0x00;
        ptr_eccPubKey_st->reserved5 = 0x00;
        ptr_eccPubKey_st->reserved6 = 0x00;
        
        ret_status = 0;
    }
    else
    {
        ret_status = -1;
    }
    
    return ret_status;
}
hsm_Cmd_Status_E Hsm_Kas_Dh_Ecdh_SharedSecret(st_Hsm_Kas_Dh_Cmd *ptr_ecdhCmd_st, uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_Pubkey, uint32_t pubKeyLen,
                                        uint8_t *ptr_sharedSecret, uint16_t sharedSecretLen, hsm_Ecc_CurveType_E keyCurveType_en)
{
    
    st_Hsm_Vss_Ecc_AsymKeyDataType privKeyType_st;
    st_Hsm_Vss_Ecc_AsymKeyDataType publicKeyType_st; 
    hsm_Cmd_Status_E ret_ecdhStatus_en;
    int status = -1;
    
    //Mailbox Header
    ptr_ecdhCmd_st->dhMailBoxHdr_st.msgSize =  0x20;
    ptr_ecdhCmd_st->dhMailBoxHdr_st.unProtection = 0x1;
    ptr_ecdhCmd_st->dhMailBoxHdr_st.reserved1 = 0x00;
    ptr_ecdhCmd_st->dhMailBoxHdr_st.reserved2 = 0x00;
    
    //Command Header
    ptr_ecdhCmd_st->dhCmdHeader_st.dhCmdGroup_en = HSM_CMD_DH;
    ptr_ecdhCmd_st->dhCmdHeader_st.dhCmdType = 0; //Command Type is 0 for Dh
    ptr_ecdhCmd_st->dhCmdHeader_st.dhAuthInc = 0x00;
    ptr_ecdhCmd_st->dhCmdHeader_st.dhSlotParamInc = 0x00;
    ptr_ecdhCmd_st->dhCmdHeader_st.dhKeyType_en = HSM_KAS_DH_ECC;
    ptr_ecdhCmd_st->dhCmdHeader_st.reserved1 = 0x00;
    ptr_ecdhCmd_st->dhCmdHeader_st.reserved2 = 0x00;
    ptr_ecdhCmd_st->dhCmdHeader_st.reserved3 = 0x00;
       
    status = Hsm_Vsm_Ecc_FillKeyProperties(&privKeyType_st, &publicKeyType_st, keyCurveType_en);
    
    
    if(status == 0)
    {
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&privKeyType_st;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1])>>2);
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_privKey;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2])>>2);
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 3 for ECC Public key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)&publicKeyType_st;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3])>>2);
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.dataLen = 4;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
        
        //Input SG-DMA Descriptor 4 for ECC Public key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_Pubkey;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].nextDes_st.stop = 0x01; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.dataLen = pubKeyLen;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;
        
        //Output SG-DMA Descriptor 1 for Generated Shared Secret Output
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_sharedSecret;
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].nextDes_st.stop = 0x01; // stop
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].flagAndLength_st.dataLen = sharedSecretLen;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
        //Parameter 1 for ECDH
        ptr_ecdhCmd_st->dhSharSecretParm1_st.useOutputSlot = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outputSlotStorDes_st.apl = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outputSlotStorDes_st.hsmOnly = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outputSlotStorDes_st.storageType = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outputSlotStorDes_st.valid = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outputSlotStorDes_st.ExtStorage = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outputSlotStorDes_st.reserved1 = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.outSlotIndex = 0x00;
        ptr_ecdhCmd_st->dhSharSecretParm1_st.reserved1 = 0x00;
        
        //Parameter 2 for ECDH
        ptr_ecdhCmd_st->dhInputKeysParam2_st.usePrivKey = 0x00;
        ptr_ecdhCmd_st->dhInputKeysParam2_st.usePubkey = 0x00;
        ptr_ecdhCmd_st->dhInputKeysParam2_st.privKeyVarSlotIndx = 0x00;
        ptr_ecdhCmd_st->dhInputKeysParam2_st.pubKeyVarSlotIndx = 0x00;
        ptr_ecdhCmd_st->dhInputKeysParam2_st.reserved1 = 0x00;

        //Parameter 3 for ECDH
        ptr_ecdhCmd_st->dhKeysLenParam3_st.privKeyLen = privKeyLen;
        ptr_ecdhCmd_st->dhKeysLenParam3_st.pubKeyLen = pubKeyLen;
        
        //Parameter 4 for ECDH
        ptr_ecdhCmd_st->dhKeyAuthDataLenParam4_st.keyAuthDataLen = 0x00;
        ptr_ecdhCmd_st->dhKeyAuthDataLenParam4_st.reserved1 = 0x00;
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ptr_ecdhCmd_st->dhMailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ptr_ecdhCmd_st->dhCmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_ecdhCmd_st->arr_dhInSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st;
    sendCmd_st.ptr_params = (uint32_t*)&(ptr_ecdhCmd_st->dhSharSecretParm1_st);
    sendCmd_st.paramsCount = (uint8_t)((ptr_ecdhCmd_st->dhMailBoxHdr_st.msgSize/4) - 4);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for ECDH Cmd
    ret_ecdhStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-16), *sendCmd_st.algocmdHdr);
    
    return ret_ecdhStatus_en;
}