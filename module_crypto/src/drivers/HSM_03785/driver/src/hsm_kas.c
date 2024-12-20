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

#include "crypto/drivers/driver/hsm_cmd.h"
#include "crypto/drivers/driver/hsm_kas.h"
#include "crypto/drivers/driver/hsm_common.h"

hsm_Cmd_Status_E Hsm_Kas_Dh_Ecdh_SharedSecret(st_Hsm_Kas_Dh_Cmd *ptr_ecdhCmd_st, uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_Pubkey, uint32_t pubKeyLen,
                                        uint8_t *ptr_sharedSecret, uint16_t sharedSecretLen, hsm_Ecc_CurveType_E keyCurveType_en)
{ 
    st_Hsm_Vss_Ecc_AsymKeyDataType privKeyType_st;
    st_Hsm_Vss_Ecc_AsymKeyDataType publicKeyType_st; 
    hsm_Cmd_Status_E ret_ecdhStatus_en = HSM_CMD_ERROR_FAILED;
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
       
    status = Hsm_Vsm_Ecc_FillEccKeyProperties(&privKeyType_st, keyCurveType_en, HSM_VSM_ASYMKEY_PRIVATEKEY,HSM_VSM_ASYMKEY_ECC_KEYEXCHANGE,HSM_VSM_ASYMKEY_ECC_ECDSA);
    
    status = Hsm_Vsm_Ecc_FillEccKeyProperties(&publicKeyType_st, keyCurveType_en, HSM_VSM_ASYMKEY_PUBLICKEY,HSM_VSM_ASYMKEY_ECC_KEYEXCHANGE,HSM_VSM_ASYMKEY_ECC_ECDSA);
    
    if(status == 0)
    {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&privKeyType_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1])>>2);
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_privKey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2])>>2);
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Input SG-DMA Descriptor 3 for ECC Public key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)&publicKeyType_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3])>>2);
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.dataLen = 4;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"         
        //Input SG-DMA Descriptor 4 for ECC Public key Descriptor
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_Pubkey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].nextDes_st.stop = 0x01; //do not stop
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].nextDes_st.nextDescriptorAddr =  0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.dataLen = pubKeyLen;  //here key length is entered
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.cstAddr = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.reAlign = 0x01;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.discard = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].flagAndLength_st.intEn = 0x00;
        ptr_ecdhCmd_st->arr_dhInSgDmaDes_st[3].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"          
        //Output SG-DMA Descriptor 1 for Generated Shared Secret Output
        ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_sharedSecret;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop         
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
        ptr_ecdhCmd_st->dhKeysLenParam3_st.privKeyLen = (uint16_t)privKeyLen;
        ptr_ecdhCmd_st->dhKeysLenParam3_st.pubKeyLen = (uint16_t)pubKeyLen;
        
        //Parameter 4 for ECDH
        ptr_ecdhCmd_st->dhKeyAuthDataLenParam4_st.keyAuthDataLen = 0x00;
        ptr_ecdhCmd_st->dhKeyAuthDataLenParam4_st.reserved1 = 0x00;
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"      
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ptr_ecdhCmd_st->dhMailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ptr_ecdhCmd_st->dhCmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ptr_ecdhCmd_st->arr_dhInSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ptr_ecdhCmd_st->arr_dhOutSgDmaDes_st;
    sendCmd_st.ptr_params = (uint32_t*)&(ptr_ecdhCmd_st->dhSharSecretParm1_st);
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop
    sendCmd_st.paramsCount = (uint8_t)((ptr_ecdhCmd_st->dhMailBoxHdr_st.msgSize/4U) - 4U);
    
    //Send the Command to MailBox
    HSM_Cmd_Send(sendCmd_st);

    //Read the command response 
    Hsm_Cmd_ReadCmdResponse(&cmdResponse_st);
    
    //Check the command response with expected values for ECDH Cmd
    ret_ecdhStatus_en = Hsm_Cmd_CheckCmdRespParms(cmdResponse_st,(*sendCmd_st.mailBoxHdr-20U), *sendCmd_st.algocmdHdr);
    
    return ret_ecdhStatus_en;
}