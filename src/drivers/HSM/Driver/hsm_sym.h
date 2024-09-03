/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_sym.h

  @Summary

  @Description
 */
/* ************************************************************************** */

#ifndef HSM_SYM_H
#define HSM_SYM_H

#include <stdint.h>
#include <stdbool.h>
#include "hsm_common.h"
//#include "hsm_command.h"

//DES Algorithms Enums
typedef enum
{
    HSM_SYM_DES_OPMODE_ECB = 0x00,
    HSM_SYM_DES_OPMODE_CBC = 0x01,      
}hsm_Sym_Des_ModeTypes_E, hsm_Sym_Tdes_ModeTypes_E;

typedef enum
{
    HSM_CMD_DES_ENCRYPT = 0x00,
    HSM_CMD_DES_DECRYPT = 0x01,
    HSM_CMD_DES_CMAC = 0x02,        
}hsm_Des_CmdTypes_E, hsm_Tdes_CmdTypes_E;



typedef struct
{
    uint8_t useNonce        :1;
    uint8_t useAadIv        :1;
	uint8_t reserved1       :6; //Reserved
	uint8_t varSlotNum      :8;  //Can variable slot be negative ???????????
	uint16_t reserved2      :16; //Reserved
}st_Hsm_Aead_ChaCha20_CmdParam2, st_Hsm_Sym_ChaCha20_CmdParam2;

typedef struct
{
    uint8_t useCtx          :1;
    uint8_t resetIV         :1;
	uint8_t reserved1       :6; //Reserved
	uint8_t varSlotNum      :8;  //Can variable slot be negative ??
	uint16_t reserved2      :16; //Reserved
}st_Hsm_Sym_Aes_CmdParam2, st_Hsm_Sym_Tdes_CmdParam2, st_Hsm_Sym_Des_CmdParam2;

typedef struct
{
    uint8_t useCtx          :1;
	uint8_t reserved1       :7; //Reserved
	uint8_t varSlotNum      :8;  //Can variable slot be negative ??
	uint16_t reserved2      :16; //Reserved
}st_Hsm_Mac_TdesCmac_CmdParam2, st_Hsm_Mac_DesCmac_CmdParam2;
        

typedef struct
{
    uint8_t useNonce        :1;
	uint8_t reserved1       :7; //Reserved
	uint8_t varSlotNum      :8;  //Can variable slot be negative ???????????
	uint16_t reserved2      :16; //Reserved
}st_Hsm_Mac_Poly1305_CmdParam2;

typedef struct
{
	hsm_CommandGroups_E chachaCmdGroup_en       :8; //It represent the command group here command group is always HSM_CMD_CHACHA for Hash Algorithm
    hsm_ChaCha_CmdTypes_E chachaCmdType_en      :8;
    uint8_t reserved1                           :8; //Reserved
    uint8_t chaChaAuthInc                       :1; //Authentication Included in input bit
    uint8_t chaChaSlotParamInc                  :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2                           :6; //Reserved
}st_Hsm_ChaCha_CmdHeader;

typedef struct
{
	hsm_CommandGroups_E tdesCmdGroup_en     :8; //It represent the command group here command group is always HSM_CMD_TDES for Hash Algorithm
    hsm_Tdes_CmdTypes_E tdesCmdType_en      :8;
    hsm_Sym_Tdes_ModeTypes_E tdesMode_en    :1;
    uint8_t reserved1                       :7; //Reserved
    uint8_t desAuthInc                      :1; //Authentication Included in input bit
    uint8_t desSlotParamInc                 :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2                       :6; //Reserved
}st_Hsm_Sym_Tdes_CmdHeader;

typedef struct
{
	hsm_CommandGroups_E desCmdGroup_en      :8; //It represent the command group here command group is always HSM_CMD_TDES for Hash Algorithm
    hsm_Des_CmdTypes_E desCmdType_en        :8;
    hsm_Sym_Des_ModeTypes_E desMode_en      :1;
    uint8_t reserved1                       :7; //Reserved
    uint8_t desAuthInc                      :1; //Authentication Included in input bit
    uint8_t desSlotParamInc                 :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2                       :6; //Reserved
}st_Hsm_Sym_Des_CmdHeader;

typedef struct
{
	hsm_CommandGroups_E tdesCmdGroup_en     :8; //It represent the command group here command group is always HSM_CMD_TDES for Hash Algorithm
    hsm_Tdes_CmdTypes_E tdesCmdType_en      :8;
    uint8_t reserved1                       :8; //Reserved
    uint8_t desAuthInc                      :1; //Authentication Included in input bit
    uint8_t desSlotParamInc                 :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2                       :6; //Reserved
}st_Hsm_Mac_TdesCmac_CmdHeader, st_Hsm_Mac_DesCmac_CmdHeader;


typedef struct
{
	st_Hsm_MailBoxHeader        aesMailBoxHdr_st;
	st_Hsm_Sym_Aes_CmdHeader    aesCmdHeader_st;
	st_Hsm_SgDmaDescriptor      arr_aesInSgDmaDes_st[3] __attribute__((aligned(4)));
	st_Hsm_SgDmaDescriptor      arr_aesOutSgDmaDes_st[2] __attribute__((aligned(4)));
	uint32_t					aesInputDataLenParm1;
	st_Hsm_Sym_Aes_CmdParam2 	aesCmdParm2_st;
    uint8_t                     arr_aesIvCtx[16] __attribute__((aligned(0x4)));
}st_Hsm_Sym_Aes_Cmd __attribute__((aligned(4)));

typedef struct
{
	st_Hsm_MailBoxHeader            mailBoxHdr_st;
	st_Hsm_ChaCha_CmdHeader       chacha20CmdHeader_st;
	st_Hsm_SgDmaDescriptor          inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor          outSgDmaDes_st;
	uint32_t                        inputDataLenParm1;
	st_Hsm_Aead_ChaCha20_CmdParam2 	chacha20CmdParm2_st;
    uint32_t                        aadLenParam3;
}st_Hsm_Aead_ChaCha20_Cmd;

typedef struct
{
	st_Hsm_MailBoxHeader            mailBoxHdr_st;
	st_Hsm_ChaCha_CmdHeader       chacha20CmdHeader_st;
	st_Hsm_SgDmaDescriptor          inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor          outSgDmaDes_st;
	uint32_t                        inputDataLenParm1;
	st_Hsm_Mac_Poly1305_CmdParam2 	poly1305CmdParm2_st;
}st_Hsm_Mac_Poly1305_Cmd;

typedef struct
{
	st_Hsm_MailBoxHeader            chachaMailBoxHdr_st;
	st_Hsm_ChaCha_CmdHeader         chachaCmdHeader_st;
	st_Hsm_SgDmaDescriptor          arr_chachaInSgDmaDes_st[5] __attribute__((aligned(4)));
	st_Hsm_SgDmaDescriptor          arr_chachaOutSgDmaDes_st[1]  __attribute__((aligned(4)));
	uint32_t                        chachaInputDataLenParm1;
	st_Hsm_Sym_ChaCha20_CmdParam2 	chachaCmdParm2_st;
}st_Hsm_Sym_ChaCha20_Cmd __attribute__((aligned(4)));;

typedef struct
{
	st_Hsm_MailBoxHeader            tdesMailBoxHdr_st;
	st_Hsm_Sym_Tdes_CmdHeader       tdesCmdHeader_st;
	st_Hsm_SgDmaDescriptor          arr_tdesInSgDmaDes_st[3] __attribute__((aligned(4)));
	st_Hsm_SgDmaDescriptor          arr_tdesOutSgDmaDes_st[2] __attribute__((aligned(4)));
	uint32_t                        tdesInputDataLenParm1;
	st_Hsm_Sym_Tdes_CmdParam2       tdesCmdParm2_st;
    uint8_t                         arr_tdesIvCtx[16] __attribute__((aligned(4)));
}st_Hsm_Sym_Tdes_Cmd __attribute__((aligned(4)));

typedef struct
{
	st_Hsm_MailBoxHeader                tdesMailBoxHdr_st;
	st_Hsm_Mac_TdesCmac_CmdHeader       tdesCmacCmdHeader_st;
	st_Hsm_SgDmaDescriptor              tdesInSgDmaDes_st;
	st_Hsm_SgDmaDescriptor              tdesOutSgDmaDes_st;
	uint32_t                            tdesInputDataLenParm1;
	st_Hsm_Mac_TdesCmac_CmdParam2       tdesCmacCmdParm2_st;
}st_Hsm_Mac_TdesCmac_Cmd ;

typedef struct
{
	st_Hsm_MailBoxHeader            mailBoxHdr_st;
	st_Hsm_Sym_Des_CmdHeader        desCmdHeader_st;
	st_Hsm_SgDmaDescriptor          inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor          outSgDmaDes_st;
	uint32_t                        inputDataLenParm1;
	st_Hsm_Sym_Des_CmdParam2        desCmdParm2_st;
}st_Hsm_Sym_Des_Cmd;

typedef struct
{
	st_Hsm_MailBoxHeader            mailBoxHdr_st;
	st_Hsm_Mac_DesCmac_CmdHeader    desCmacCmdHeader_st;
	st_Hsm_SgDmaDescriptor          inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor          outSgDmaDes_st;
	uint32_t                        inputDataLenParm1;
	st_Hsm_Mac_DesCmac_CmdParam2    desCmacCmdParm2_st;
}st_Hsm_Mac_DesCmac_Cmd;

void Hsm_Sym_Aes_Init(st_Hsm_Sym_Aes_Cmd *ptr_aesCmd_st, hsm_Sym_Aes_ModeTypes_E aesModeType_en, hsm_Aes_CmdTypes_E aesOperType_en, 
                        uint8_t *ptr_aeskey, hsm_Aes_KeySize_E keyLen_en, uint8_t *ptr_initVect, uint8_t varslotNum);

hsm_Cmd_Status_E Hsm_Sym_Aes_Cipher(st_Hsm_Sym_Aes_Cmd *ptr_aesCmd_st, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut);

hsm_Cmd_Status_E Hsm_Sym_Aes_CipherDirect(st_Hsm_Sym_Aes_Cmd *ptr_aesCmd_st, hsm_Sym_Aes_ModeTypes_E modeType_en, hsm_Aes_CmdTypes_E operType_en, 
                            uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut, uint8_t *ptr_aeskey, hsm_Aes_KeySize_E keyLen_en, 
                            uint8_t *ptr_initVect, uint8_t varslotNum);

void Hsm_Sym_Tdes_Init(st_Hsm_Sym_Tdes_Cmd *ptr_tdesCmd_st, hsm_Sym_Tdes_ModeTypes_E tdesModeType_en, hsm_Tdes_CmdTypes_E tdesOperType_en, 
                        uint8_t *tdesKey, uint8_t *ptr_initVect, uint8_t varslotNum);

hsm_Cmd_Status_E Hsm_Sym_Tdes_Cipher(st_Hsm_Sym_Tdes_Cmd *ptr_tdesCmd_st, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut);

hsm_Cmd_Status_E Hsm_Sym_Tdes_CipherDirect(st_Hsm_Sym_Tdes_Cmd *ptr_tdesCmd_st, hsm_Sym_Tdes_ModeTypes_E tdesModeType_en, hsm_Tdes_CmdTypes_E tdesOperType_en, 
                            uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut, uint8_t *tdesKey, uint8_t *ptr_initVect, uint8_t varslotNum);

void Hsm_Sym_ChaCha_Init(st_Hsm_Sym_ChaCha20_Cmd *ptr_chachaCmd_st, hsm_ChaCha_CmdTypes_E chaChaOperType_en, uint8_t *ptr_tdesKey, 
                            uint8_t *ptr_initVect, uint32_t counter, uint8_t varslotNum);

void Hsm_Sym_ChaCha20_Cipher(st_Hsm_Sym_ChaCha20_Cmd *ptr_chachaCmd_st, uint8_t *ptr_dataIn, uint32_t inputDataLen, uint8_t *ptr_dataOut);
#endif /* HSM_SYM_H*/