/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_sign.h

  @Summary

  @Description
 */
/* ************************************************************************** */
#ifndef HSM_SIGN_H
#define HSM_SIGN_H

#include "hsm_common.h"


typedef enum
{
    HSM_DIGISIGN_CMD_SIGN   = 0x00,
    HSM_DIGISIGN_CMD_VERIFY = 0x01,
    HSM_DIGISIGN_CMD_EDDSA_SIGN = 0x02,
    HSM_DIGISIGN_CMD_EDDSA_VERIFY = 0x03,        
}hsm_DigiSign_CmdType_E;

typedef enum
{
    HSM_DIGISIGN_MD5 = 0x01,
    HSM_DIGISIGN_SHA1 = 0x02,
    HSM_DIGISIGN_SHA224 = 0x03,
    HSM_DIGISIGN_SHA256 = 0x04,
    HSM_DIGISIGN_SHA384 = 0x05,
    HSM_DIGISIGN_SHA512 = 0x06,        
}hsm_DigiSign_HashAlgo_E;

typedef enum
{
    HSM_DIGISIGN_NOPADDING = 0x00,
    HSM_DIGISIGN_EMSAPKCS = 0x03,
    HSM_DIGISIGN_PSS = 0x04,             
}hsm_DigiSign_PadType_E;

typedef enum
{
    HSM_DIGISIGN_KEY_ECC = 0x00U,
    HSM_DIGISIGN_KEY_RSA = 0x01U,
    HSM_DIGISIGN_KEY_DSA = 0x03U,        
}hsm_DigiSign_KeyType_E;

typedef struct
{
	hsm_CommandGroups_E cmdGroup_en     :8; //It represent the command group here command group is always HSM_CMD_AES for Hash Algorithm
    hsm_DigiSign_CmdType_E cmdType_en   :8;
    hsm_DigiSign_HashAlgo_E hashAlgo_en :3; //Reserved
    uint8_t reserved1                   :1; //Authentication Included in input bit
    hsm_DigiSign_PadType_E padType_en   :3; //This field indicates if slot parameters are included in the list of parameters
    uint8_t reserved2                   :1;
    uint8_t authInc                     :1;
    uint8_t slotParamInc                :1;
    uint8_t	reserved3                   :2;
    hsm_DigiSign_KeyType_E keyType_en   :2; 
    uint8_t nounceK                		:1;
    uint8_t	reserved4                   :1; //Reserved
}st_Hsm_DigiSign_CmdHeader;

typedef struct
{
    uint8_t useInputSlot                       		:1;
    uint8_t useOutputSlot                      	 	:1;
    uint8_t reserved1                    		 	:6;
    uint8_t inputSlotIndex    						:8;
    st_Hsm_Vsm_VaSlotStoDaLy outputSlotStorDes_st;
    uint8_t outSlotIndex                       :8;
}st_Hsm_DigiSign_Param1;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_DigiSign_CmdHeader   cmdHeader_st;
	st_Hsm_SgDmaDescriptor      arr_inSgDmaDes_st[4] __attribute__((aligned(4)));
	st_Hsm_SgDmaDescriptor      arr_outSgDmaDes_st[2] __attribute__((aligned(4)));
	st_Hsm_DigiSign_Param1		digiSignParm1_st __attribute__((aligned(4)));
    uint32_t dataLenParm2;
    uint32_t saltLenParm3;
}st_Hsm_DigiSign_Cmd __attribute__((aligned(4)));

hsm_Cmd_Status_E Hsm_DigiSign_Ecdsa_SignData(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_outSign, 
                                            uint8_t *ptr_privKey, uint32_t privKeyLen, hsm_DigiSign_HashAlgo_E hashType_en, uint8_t *ptr_randomNumber,
                                            hsm_Ecc_CurveType_E keyCurveType_en);

hsm_Cmd_Status_E Hsm_DigiSign_Ecdsa_VerifyData(uint8_t *ptr_data, uint32_t dataLen, uint8_t *ptr_inputSign, 
                                                uint8_t *ptr_pubKey, uint32_t pubKeyLen, hsm_DigiSign_HashAlgo_E hashType_en, int8_t *ptr_verifyStatus,
                                                hsm_Ecc_CurveType_E keyCurveType_en);

#endif /* HSM_SIGN_H */
