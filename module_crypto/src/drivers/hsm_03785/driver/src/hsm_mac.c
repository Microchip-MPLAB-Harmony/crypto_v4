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
#include "hsm_mac.h"

//void Hsm_Mac_AesGcm_DirectEncryption(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_aeskey, uint8_t *ptr_initVect)
//{
//     //Mailbox Header
//    ptr_aesGcmCmd_st->aesMailBoxHdr_st.msgSize =  0x28;
//    ptr_aesGcmCmd_st->aesMailBoxHdr_st.unProtection = 0x1;
//    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved1 = 0x00;
//    ptr_aesGcmCmd_st->aesMailBoxHdr_st.reserved2 = 0x00;
//    
//    //Command Header
//    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdGroup_en = HSM_CMD_AES;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmCmdType_en = HSM_SYM_AES_GCM_ENCRYPT; //this argument can be other instead of Cmd type because here we support encrypt or decrypt not GCM and others type.
//    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmKeySize_en = aesKeyLen_en;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.initialMsg = 0x00;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.lastMsg = 0x00;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmAuthInc = 0x00;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.aesGcmSlotParamInc = 0x00;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved1 = 0x00;
//    ptr_aesGcmCmd_st->aesCmdHeader_st.reserved2 = 0x00;
//    
//    //Input SG-DMA Descriptor 1 for AES Key
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].ptr_dataAddr = (uint32_t*)ptr_aeskey;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.stop = 0x00; //do not stop
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1])>>2);
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.dataLen = (uint32_t)((uint16_t)aesKeyLen_en*(uint16_t)8+16);  //here key length is entered
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.cstAddr = 0x00;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.reAlign = 0x01;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.discard = 0x00;
//	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].flagAndLength_st.intEn = 0x00;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[0].nextDes_st.reserved1 = 0x00;
//    
//    //Input SG-DMA Descriptor 2 for IV
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)12;  //here IV length is entered
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
//	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
//    
//    //Input SG-DMA Descriptor 3 for Context
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].ptr_dataAddr = (uint32_t*)ptr_initVect;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.stop = 0x00; //do not stop
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.nextDescriptorAddr =  ((uint32_t)(&ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[2])>>2);
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.dataLen = (uint32_t)12;  //here IV length is entered
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.cstAddr = 0x00;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.reAlign = 0x01;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.discard = 0x00;
//	ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].flagAndLength_st.intEn = 0x00;
//    ptr_aesGcmCmd_st->arr_aesInSgDmaDes_st[1].nextDes_st.reserved1 = 0x00;
//}