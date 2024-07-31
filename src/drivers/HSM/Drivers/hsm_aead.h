/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_aead.h

  @Summary

  @Description
 */
/* ************************************************************************** */

#ifndef HSM_AEAD_H
#define HSM_AEAD_H

#include <stdint.h>
#include <stdbool.h>
//#include "hsm_command.h"
#include "hsm_common.h"

typedef struct
{
	hsm_CommandGroups_E aesGcmCmdGroup_en           :8; //It represent the command group here command group is always HSM_CMD_AES for Hash Algorithm
    hsm_Aes_CmdTypes_E aesGcmCmdType_en             :8;
    hsm_Aes_KeySize_E aesGcmKeySize_en              :2; //Aes Key Size
    uint8_t reserved1                               :4;
    uint8_t initialMsg                              :1;
    uint8_t lastMsg                                 :1;                    
    uint8_t aesGcmAuthInc                           :1; //Authentication Included in input bit
    uint8_t aesGcmSlotParamInc                      :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2                               :6; //Reserved
}st_Hsm_Aead_AesGcm_CmdHeader;

typedef struct
{
    uint8_t useIV           :1;
    uint8_t resetIV         :1;
    uint8_t useAad          :1;
    uint8_t reserved1       :5;
    uint8_t varSlotNum      :8;
	uint16_t reserved2      :16; //Reserved
}st_Hsm_Aead_AesGcm_Param2;

typedef struct
{
	st_Hsm_MailBoxHeader            aesMailBoxHdr_st;
	st_Hsm_Aead_AesGcm_CmdHeader	aesCmdHeader_st;
	st_Hsm_SgDmaDescriptor          arr_aesInSgDmaDes_st[6] __attribute__((aligned(4)));
	st_Hsm_SgDmaDescriptor          arr_aesOutSgDmaDes_st[3]  __attribute__((aligned(4)));
	uint32_t                        inputDataLenParm1;
	st_Hsm_Aead_AesGcm_Param2       aesGcmCmdParm2_st;
    uint32_t                        aadLengthParm3;
}st_Hsm_Aead_AesGcm_Cmd;

hsm_Cmd_Status_E Hsm_Aead_AesGcm_InitEncrypt(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_aesGcmCtx, uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, hsm_Aes_CmdTypes_E cmdType_en);

hsm_Cmd_Status_E Hsm_Aead_AesGcm_DirectEncrypt(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_dataIn, uint16_t inputDataLen, uint8_t *ptr_outputData,
                                        uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, 
                                        uint8_t *ptr_aad, uint16_t aadLen, uint8_t *ptr_tagMac, uint8_t tagLen);
hsm_Cmd_Status_E Hsm_Aead_AesGcm_DirectDecrypt(st_Hsm_Aead_AesGcm_Cmd *ptr_aesGcmCmd_st, uint8_t *ptr_dataIn, uint16_t inputDataLen, uint8_t *ptr_outputData,
                                        uint8_t *ptr_aeskey, hsm_Aes_KeySize_E aesKeyLen_en, uint8_t *ptr_initVect, uint8_t *ptr_aad, uint16_t aadLen, 
                                        uint8_t *ptr_inputTagMac, uint8_t tagLen);
#endif /* HSM_AEAD_H*/