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
#include "stdlib.h"
#include "crypto/drivers/driver/hsm_sign.h"
#include "crypto/drivers/driver/hsm_cmd.h"

static void Hsm_DigiSign_Cmd(st_Hsm_DigiSign_Cmd *ptr_digiSignCmd_st, uint8_t cmdLen, hsm_DigiSign_CmdType_E cmdType_en,
                                     hsm_Hash_Types_E hashAlgo_en, hsm_DigiSign_PadType_E padType_en, hsm_DigiSign_KeyType_E keyType_en,
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
                                uint8_t *ptr_privKey, uint32_t privKeyLen, hsm_Hash_Types_E hashType_en, uint8_t *ptr_randomNumber, hsm_Ecc_CurveType_E keyCurveType_en)
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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"         
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&privKeyType_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop           
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[1])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_privKey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"         
        //Input SG-DMA Descriptor 3 for Random Number Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_randomNumber;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop           
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[3])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = privKeyLen;  //here Random Number length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1" 
        //Input SG-DMA Descriptor 4 for Hash Data Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_data;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop           
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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"         
        //Input SG-DMA Descriptor 3 for Hash Data Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_data;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop         
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.stop = 0x01; // stop
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = dataLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Output SG-DMA Descriptor 1 for Signature Output
        ecdsaCmd_st.arr_outSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&ptr_outSign[0];
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop         
        ecdsaCmd_st.arr_outSgDmaDes_st[0].nextDes_st.stop = 0x00; //stop
        ecdsaCmd_st.arr_outSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_outSgDmaDes_st[1])>>2);
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.dataLen = privKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_outSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Output SG-DMA Descriptor 1 for Signature Output
        ecdsaCmd_st.arr_outSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)&ptr_outSign[privKeyLen];
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop            
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 2.2" "H3_MISRAC_2012_R_2_2_DR_1"       
        //Parameter 2 for ECDSA //Input Hash Data
        ecdsaCmd_st.dataLenParm2 = dataLen;
 
        //Parameter 3 for ECDSA //Salt Len
        ecdsaCmd_st.saltLenParm3 = 0x00UL;
#pragma coverity compliance end_block "MISRA C-2012 Rule 2.2"
#pragma GCC diagnostic pop         
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"      
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ecdsaCmd_st.mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ecdsaCmd_st.cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ecdsaCmd_st.arr_inSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)ecdsaCmd_st.arr_outSgDmaDes_st;
    sendCmd_st.ptr_params = (uint32_t*)&(ecdsaCmd_st.digiSignParm1_st);
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop    
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
                                            hsm_Hash_Types_E hashType_en, int8_t *ptr_verifyStatus, hsm_Ecc_CurveType_E keyCurveType_en)
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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"      
        //Input SG-DMA Descriptor 1 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)&pubKeyType_st;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[1])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.dataLen = 4;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Input SG-DMA Descriptor 2 for ECC private key Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_pubKey;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[2])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.dataLen = pubKeyLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Input SG-DMA Descriptor 3 for Random Number Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[2].ptr_dataAddr = (uint32_t*)ptr_data;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.stop = 0x00; //do not stop
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ecdsaCmd_st.arr_inSgDmaDes_st[3])>>2);
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.dataLen = dataLen;  //here key length is entered
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.cstAddr = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.reAlign = 0x01;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.discard = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].flagAndLength_st.intEn = 0x00;
        ecdsaCmd_st.arr_inSgDmaDes_st[2].nextDes_st.reserved1 = 0x00;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"        
        //Input SG-DMA Descriptor 4 for Hash Data Descriptor
        ecdsaCmd_st.arr_inSgDmaDes_st[3].ptr_dataAddr = (uint32_t*)ptr_inputSign;
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop        
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
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 2.2" "H3_MISRAC_2012_R_2_2_DR_1"        
        //Parameter 2 for ECDSA
        ecdsaCmd_st.dataLenParm2 = dataLen;
        
        //Parameter 3 for ECDSA
        ecdsaCmd_st.saltLenParm3 = 0x00UL;
#pragma coverity compliance end_block "MISRA C-2012 Rule 2.2"
#pragma GCC diagnostic pop         
    }
    
    st_Hsm_ResponseCmd cmdResponse_st;
    st_Hsm_SendCmdLayout sendCmd_st;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 11.3" "H3_MISRAC_2012_R_11_3_DR_1"    
    sendCmd_st.mailBoxHdr = (uint32_t*)&(ecdsaCmd_st.mailBoxHdr_st);
    sendCmd_st.algocmdHdr = (uint32_t*)&(ecdsaCmd_st.cmdHeader_st);
    sendCmd_st.ptr_sgDescriptorIn = (uint32_t*)ecdsaCmd_st.arr_inSgDmaDes_st;
    sendCmd_st.ptr_sgDescriptorOut = (uint32_t*)0x00000000;
    sendCmd_st.ptr_params = (uint32_t*)&(ecdsaCmd_st.digiSignParm1_st);
#pragma coverity compliance end_block "MISRA C-2012 Rule 11.3"
#pragma GCC diagnostic pop    
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


