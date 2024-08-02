/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_hash.h

  @Summary

  @Description
 */
/* ************************************************************************** */

#ifndef HSM_HASH_H
#define HSM_HASH_H
#include "hsm_common.h"
//#include "hsm_host/hsm_command.h"

typedef enum
{
    HSM_CMD_HASH_BLOCK    = 0,
    HSM_CMD_HASH_INIT     = 1,
    HSM_CMD_HASH_UPDATE   = 2,
    HSM_CMD_HASH_FINALIZE = 3,
    HSM_CMD_HASH_HMAC     = 4,
    HSM_CMD_HASH_VALIDATE = 5,
}hsm_Hash_CmdTypes_E;

typedef enum
{
	HSM_CMD_HASH_INVALID 		= 0x00,
    HSM_CMD_HASH_MD5    		= 0x01,
    HSM_CMD_HASH_SHA1   		= 0x02,
    HSM_CMD_HASH_SHA224 		= 0x03,
    HSM_CMD_HASH_SHA256 		= 0x04,
    HSM_CMD_HASH_SHA384 		= 0x05,
    HSM_CMD_HASH_SHA512 		= 0x06,
}hsm_Hash_Types_E;

typedef enum
{
	HSM_CMD_HASH_MD5_HMAC 		= 0x0B,
	HSM_CMD_HASH_SHA1_HMAC 		= 0x0C,
	HSM_CMD_HASH_SHA2_224_HMAC 	= 0x0D,
	HSM_CMD_HASH_SHA2_256_HMAC	= 0x0E,
	HSM_CMD_HASH_SHA2_384_HMAC	= 0x0F,
	HSM_CMD_HASH_SHA2_512_HMAC 	= 0x10,
	HSM_CMD_HASH_MAX
}hsm_Hmac_Types_E;

typedef enum
{
    HSM_HASH_DIGESTSIZE_MD5     = 0x10, //16 bytes
    HSM_HASH_DIGESTSIZE_SHA1    = 0x14, //20 bytes   
    HSM_HASH_DIGESTSIZE_SHA224  = 0x1C, //28 bytes
    HSM_HASH_DIGESTSIZE_SHA256  = 0x20, //32 bytes
    HSM_HASH_DIGESTSIZE_SHA384  = 0x30, //48 bytes
    HSM_HASH_DIGESTSIZE_SHA512  = 0x40, //64 bytes                  
}hsm_Hash_DigestSizes_E;

typedef struct
{
	hsm_CommandGroups_E hashCmdGroup_en     :8; //It represent the command group here command group is always HSM_CMD_HASH for Hash Algorithm
    hsm_Hash_CmdTypes_E hashCmdType_en		:8; //Hash Command Type
    hsm_Hash_Types_E hashType_en  			:4; //Hash Algorithm Type
    uint8_t reserved1          				:4; //Reserved
    uint8_t hashAuthInc		      			:1; //Authentication Included in input bit
    uint8_t hashSlotParamInc				:1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2          				:6; //Reserved
}st_Hsm_Hash_CmdHeader;

typedef struct
{
   st_Hsm_MailBoxHeader mailBoxHdr_st;
   st_Hsm_Hash_CmdHeader cmdHeader_st;
   uint16_t  reserved1           :16; //reserved
   hsm_CmdResultCodes_E result_code :32;
   hsm_Hash_DigestSizes_E hashSize : 8;
   uint32_t  reserved2           :24; //reserved    
}st_Hsm_Hash_CmdResponse;

typedef struct
{
    uint8_t apl             :2;
    uint8_t reserved1       :1; //reserved
    uint8_t hsmOnly         :1;
    uint8_t storageType     :2;
    uint8_t valid           :1;
    uint8_t exStorage       :1; //
}st_Hsm_Hash_VarSlotHeader;

typedef struct
{
	uint8_t reserved1          :8; //Reserved	
	uint8_t	varSlotNum         :8;
    st_Hsm_Hash_VarSlotHeader   varSlotData_st;
	uint8_t reserved2          :8; //Reserved
}st_Hsm_Hash_BlockCmdParam2, st_Hsm_Hash_InitCmdParam1;

typedef struct
{
	uint8_t useVsForCtx :1;
	uint8_t	reserved1	:7;//Reserved
	uint8_t varSlotNum;
	uint16_t reserved2  :16; //Reserved
}st_Hsm_Hash_UpdateCmdParam2;

typedef struct
{
	uint8_t useVsForCtx 	:1;
	uint8_t	reserved1				:7;//Reserved
	uint8_t ctxVarSlotNum	:8;
	uint8_t	useVsForVal		:1;
	uint8_t accessprogLvl	:2;
	uint8_t	hsmOnly			:1;
	uint8_t	reserved2				:4; //Reserved		
	uint8_t	valVarSlotNum	:8;
}st_Hsm_Hash_FinalCmdParam2;

typedef struct
{
	uint8_t useVsForKey 	:1;
	uint8_t					:7;//Reserved
	uint8_t keySlotNum		:8;
	uint8_t	useVsForHmac	:1;
	uint8_t accessprogLvl	:2;
	uint8_t	hsmOnly			:1;
	uint8_t					:4; //Reserved		
	uint8_t	hmacVarSlotNum	:8;
}st_Hsm_Hash_HmacCmdParam2;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_Hash_CmdHeader		cmdHeader_st;
	st_Hsm_SgDmaDescriptor      inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor      outSgDmaDes_st;
	uint32_t					inputLenParm1;
	st_Hsm_Hash_BlockCmdParam2 	blockCmdParm2_st;
}st_Hsm_Hash_BlockCmd;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_Hash_CmdHeader		cmdHeader_st;
	st_Hsm_SgDmaDescriptor      inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor      outSgDmaDes_st;
	st_Hsm_Hash_InitCmdParam1 	initCmdParm1_st;
}st_Hsm_Hash_InitCmd;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_Hash_CmdHeader		cmdHeader_st;
	st_Hsm_SgDmaDescriptor      inSgDmaDes_st[2]; //not used in the update cmd
	st_Hsm_SgDmaDescriptor      outSgDmaDes_st[1]; //not used in the update cmd
	uint32_t					inputLenParm1;
	st_Hsm_Hash_UpdateCmdParam2 updateCmdParm2_st;
}st_Hsm_Hash_UpdateCmd;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_Hash_CmdHeader		cmdHeader_st;
	st_Hsm_SgDmaDescriptor      inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor      outSgDmaDes_st;
	uint32_t					inputLenParm1;
	st_Hsm_Hash_FinalCmdParam2 	finalCmdParam2_st;
}st_Hsm_Hash_FinalCmd;

typedef struct
{
	st_Hsm_MailBoxHeader        mailBoxHdr_st;
	st_Hsm_Hash_CmdHeader		cmdHeader_st;
	st_Hsm_SgDmaDescriptor      inSgDmaDes_st;
	st_Hsm_SgDmaDescriptor      outSgDmaDes_st;
	uint32_t					inputLenParm1;
	st_Hsm_Hash_HmacCmdParam2 	hmacCmdParm2_st;
}st_Hsm_Hash_HmacCmd;

typedef struct
{
	uint8_t varSlotNum1 	:8;
	uint8_t	varSlotNum2		:8;
	uint16_t reserved1  	:16; //Reserved
}st_Hsm_Hash_ValidateCmdParam1;

typedef struct
{
	hsm_CommandGroups_E hashCmdGroup_en     :8; //It represent the command group here command group is always HSM_CMD_HASH for Hash Algorithm
    hsm_Hash_CmdTypes_E hashCmdType_en		:8; //Hash Command Type
    uint16_t reserved1          			:16; //Reserved
}st_Hsm_Hash_RespCmdHeader;

typedef struct
{
    hsm_Hash_DigestSizes_E HashSize_en;
    uint32_t reserved1 :24;
}st_Hsm_Hash_HashSize;

typedef enum
{
	HSM_CMD_AES_INVALID = 0xFF,
	HSM_CMD_AES_ECB = 0x0,
	HSM_CMD_AES_CBC = 0x1,
	HSM_CMD_AES_CTR = 0x2,
	HSM_CMD_AES_CFB = 0x3,
	HSM_CMD_AES_OFB = 0x4,
	HSM_CMD_AES_XTS = 0x5
}hsm_Cmd_AesModes_E;
	
typedef enum
{
	HSM_CMD_AES_KEY_INVALID = -1,
	HSM_CMD_AES_KEY_128 = 0,
	HSM_CMD_AES_KEY_192 = 1,
	HSM_CMD_AES_KEY_256 = 2,
}hsm_Cmd_AesKeySizes_E;

hsm_Cmd_Status_E HSM_Hash_DigestDirect(hsm_Hash_Types_E hashType_en, uint8_t *ptr_inputData, uint32_t dataLen, uint8_t *ptr_outData);
uint8_t Hsm_Hash_HashLen(hsm_Hash_Types_E hashType_en);
uint8_t Hsm_Hash_HashCtxLen(hsm_Hash_Types_E hashType_en);
hsm_Cmd_Status_E HSM_Hash_InitCmd(uint8_t *ptr_hashCtx, hsm_Hash_Types_E hashType_en);
hsm_Cmd_Status_E HSM_Hash_UpdateCmd(uint8_t *ptr_hashCtx, uint8_t *ptr_inputData, uint32_t dataLen, hsm_Hash_Types_E hashType_en);
hsm_Cmd_Status_E HSM_Hash_FinalCmd(uint8_t *ptr_hashCtx, uint8_t *ptr_leftoverInData, uint32_t dataLen, uint8_t *ptr_OutputData, hsm_Hash_Types_E hashType_en);

#endif /* HSM_HASH_H*/