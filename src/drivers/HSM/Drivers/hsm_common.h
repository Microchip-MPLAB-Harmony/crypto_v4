/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_common.h

  @Summary
    Decodes ascii hsm commands from serial byte string sent from PC

  @Description
    Decodes ascii hsm commands from serial byte string sent from PC
 */
/* ************************************************************************** */

#ifndef HSM_COMMON_H /* Guard against multiple inclusion */
#define HSM_COMMON_H

#include <stdint.h>
#include <stdbool.h>


typedef enum
{
    HSM_CMD_SBS_RESET = 0x00,
    HSM_CMD_SBS_DISABLED = 0x01,
    HSM_CMD_SBS_BOOT_FLASH_AUTH = 0x02,
    HSM_CMD_SBS_ADDITION_AUTH = 0x03,
    HSM_CMD_SBS_SECURE_BOOT_FAILED = 0x04,
    HSM_CMD_SBS_SECURE_BOOT_PASSED = 0x05,           
}hsm_Cmd_StatusSbs_E;

typedef enum
{
    HSM_CMD_LCS_RESET = 0x00,
    HSM_CMD_LCS_IC = 0x01,
    HSM_CMD_LCS_ERASED = 0x02,        
    HSM_CMD_LCS_OPEN = 0x3,
    HSM_CMD_LCS_SECURED = 0x04,          
}hsm_Cmd_StatusLcs_E;

typedef enum
{
    HSM_CMD_PS_RESET = 0x00,
    HSM_CMD_PS_BOOT = 0x01,
    HSM_CMD_PS_OPERATIONAL = 0x02,        
    HSM_CMD_PS_SAFEMODE = 0x3,         
}hsm_Cmd_StatusPs_E;


typedef enum
{
    HSM_CMD_ERROR_UNKNOWN = 0x00000000,
    HSM_CMD_ERROR_SUCCESS = 0x00000001,
    HSM_CMD_ERROR_GENERAL = 0x80000000,
    HSM_CMD_ERROR_CANCEL  = 0x80000001,
    HSM_CMD_ERROR_NOTSUPPORTED = 0x80000002,
    HSM_CMD_ERROR_INVALIDPARAM = 0x80000003,
    HSM_CMD_ERROR_INVALIDINPUT = 0x80000004,
    HSM_CMD_ERROR_INPUTDMA = 0x80000005,
    HSM_CMD_ERROR_OUTPUTDMA = 0x80000006,
    HSM_CMD_ERROR_SYSTEMMEM = 0x80000007,
    HSM_CMD_ERROR_INPUTAUTH = 0x80000008,    
}hsm_CmdResultCodes_E;

typedef enum
{
    HSM_CMD_INVALID = 0xFF,
    HSM_CMD_BOOT   	= 0,  // Boot Command
    HSM_CMD_SDBG   	= 1,  //Secure Debug Command
    HSM_CMD_TMPR   	= 2,	 //Tamper Response Command	
    HSM_CMD_VSM    	= 3,  //Variable Slot Management Command
    HSM_CMD_KEYMGM 	= 4,  //Key Management Commands
    HSM_CMD_HASH   	= 5,  //Hash Commands
    HSM_CMD_AES    	= 6,  //AES Commands
    HSM_CMD_CHACHA 	= 7,  //ChaCha Commands
    HSM_CMD_TDES   	= 8,  //Triple-DES/3DES Commands
    HSM_CMD_DES    	= 9,  //DES Commands
    HSM_CMD_RSA    	= 10, //RSA Commands 
    HSM_CMD_SIGN   	= 11, //Signature Commands 
    HSM_CMD_X509   	= 12, //X.509 Certificate Commands 
    HSM_CMD_DH     	= 13, // Diffie-Hellmen Commands
    HSM_CMD_DICE   	= 14,  //?? jk
    HSM_CMD_MISC   	= 0xF0, //?? jk
}hsm_CommandGroups_E;

typedef enum
{
    HSM_ECC_CURVETYPE_P192 = 0x00,
    HSM_ECC_CURVETYPE_P256 = 0x01,        
    HSM_ECC_CURVETYPE_P384 = 0x02,
    HSM_ECC_CURVETYPE_P521 = 0x03,
    HSM_ECC_MAX_CURVE,        
}hsm_Ecc_CurveType_E;


//This enum needs to be in Common.h //?????????????
typedef enum
{
    HSM_SYM_AES_ENCRYPT     = 0x00,
    HSM_SYM_AES_DECRYPT     = 0x01,
    HSM_SYM_AES_GCM_ENCRYPT = 0x02,
    HSM_SYM_AES_GCM_DECRYPT = 0x03,
    HSM_SYM_AES_CMAC        = 0x04,
    HSM_SYM_AES_CCM_ENCRYPT = 0x05,
    HSM_SYM_AES_CCM_DECRYPT = 0x06,
}hsm_Aes_CmdTypes_E;  //This structure needs to be improved

typedef enum
{
    HSM_SYM_AES_KEY_128 = 0,
    HSM_SYM_AES_KEY_192 = 1,
    HSM_SYM_AES_KEY_256 = 2,
}hsm_Aes_KeySize_E;

//AES algorithms Enums
typedef enum
{
    
    HSM_SYM_AES_OPMODE_ECB = 0x0,
    HSM_SYM_AES_OPMODE_CBC = 0x1,
    HSM_SYM_AES_OPMODE_CTR = 0x2,
//    HSM_SYM_AES_OPMODE_CFB = 0x03, //Not supported
//    HSM_SYM_AES_OPMODE_OFB = 0x04, //Not supported
//    HSM_SYM_AES_OPMODE_XTS = 0x05, //Not Supported
    HSM_SYM_AES_OPMODE_INVALID = 0xF,
}hsm_Aes_ModeTypes_E, hsm_Sym_Aes_ModeTypes_E;

//This enum needs to be in Common.h //?????????????
typedef enum
{
    HSM_CMD_AEAD_CHACHA20_ENCRYPT = 0x00,            
    HSM_CMD_AEAD_CHACHA20_DECRYPT = 0x01,
    HSM_CMD_SYM_CHACHA20_ENCRYPT = 0x02,
    HSM_CMD_SYM_CHACHA20_DECRYPT = 0x03,
    HSM_CMD_MAC_CHACHA20_POLY1305 = 0x04,
}hsm_ChaCha_CmdTypes_E;

typedef enum
{
    HSM_CMD_ERROR_MAILBOX = -127,
    HSM_CMD_ERROR_CMDHEADER = -126,
    HSM_CMD_ERROR_RESULTCODE = -125,        
    HSM_CMD_ERROR_STATUSREG = -124,
    HSM_CMD_ERROR_INTFLAG = -123,
    HSM_CMD_ERROR_FAILED = -122,
    HSM_CMD_SUCCESS = 0,
}hsm_Cmd_Status_E;

//Each communication on the mailbox must be started with a mailbox header. When writing to the mailbox, the header
//is written to a special register as defined by the mailbox IP, and then the rest of the message is written to the
//mailbox FIFO,
typedef struct
{
	uint16_t	msgSize			:16; //The size of the message that is placed in the mailbox, including the 4 bytes for this message
	uint8_t		reserved1		:5; //Reserved
	uint8_t		unProtection	:1; //Bit to determine whether(0) or not(1) the protection bits //HSM pays attention to the mailbox protection bits else Ignore
	uint16_t	reserved2		:10; //Reserved
}st_Hsm_MailBoxHeader;

typedef struct 
{
   	uint8_t stop                    :1;   //This bit is used to tell the DMA Hardware to stop after this descriptor is processed  
	uint8_t  reserved1                       :1;   //reserved
	uint32_t nextDescriptorAddr     :30;  //This is pointer or not , need to check //jk ?? 
}st_Hsm_SgDesNextAddr;

typedef struct
{
  	uint32_t dataLen  				:28;
	uint8_t	cstAddr                 :1;   //Constant address bit to determine whether the DMA increment the address on every access
	uint8_t reAlign                 :1;   //Pad the pointed by this descriptor to the 32-bit boundry
	uint8_t discard                 :1;   //This is for output descriptor to determine if the DMA controller discards data written to it.
	uint8_t intEn                   :1;   //Interrupt Enable Bit  
}st_Hsm_SgDesFlagLen;

typedef struct 
{
	uint32_t *ptr_dataAddr;           //Address of the data to be DMAed  
    st_Hsm_SgDesNextAddr nextDes_st;
	st_Hsm_SgDesFlagLen flagAndLength_st;
}st_Hsm_SgDmaDescriptor __attribute__((aligned(4)));

typedef struct
{
    uint32_t *mailBoxHdr;
    uint32_t *algocmdHdr;
    uint32_t *ptr_sgDescriptorIn;
    uint32_t *ptr_sgDescriptorOut;
    uint32_t *ptr_params;
    uint8_t paramsCount;
}st_Hsm_SendCmdLayout;

typedef struct
{
    uint8_t busy : 1;
    uint8_t reserved1 : 3;
    hsm_Cmd_StatusPs_E ps : 3;
    uint8_t reserved2 : 1;
    hsm_Cmd_StatusLcs_E lcs : 3;
    uint8_t reserved3 : 1;
    hsm_Cmd_StatusSbs_E sbs : 3;
    uint8_t reserved4 : 1;
    uint8_t ecode : 4;
    uint16_t reserved5 : 12;
}st_Hsm_StatusReg;

typedef struct
{
   uint32_t respMailBoxHdr;
   uint32_t respCmdHeader;
   hsm_CmdResultCodes_E resultCode_en :32; 
   st_Hsm_StatusReg status_st;
   uint32_t arr_params[8]; 
}st_Hsm_ResponseCmd;

typedef struct
{
	hsm_CommandGroups_E aesCmdGroup_en          :8; //It represent the command group here command group is always HSM_CMD_AES for Hash Algorithm
    hsm_Aes_CmdTypes_E aesCmdType_en            :8;
    hsm_Aes_KeySize_E aesKeySize_en             :2; //Aes Key Size
    hsm_Aes_ModeTypes_E aesModeType_en  	    :4; //AES Mode Type
    uint8_t reserved1                           :2; //Reserved
    uint8_t aesAuthInc                          :1; //Authentication Included in input bit
    uint8_t aesSlotParamInc                     :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t	reserved2                           :6; //Reserved
}st_Hsm_Sym_Aes_CmdHeader, st_Hsm_Mac_AesCmac_CmdHeader, st_Hsm_Aead_AesCcm_CmdHeader;


typedef enum
{
    HSM_VSM_ASYMKEY_ECC_WCPRIME     = 0x00, //Weierstrass Curve ? Prime Field
    HSM_VSM_ASYMKEY_ECC_WCBINARY    = 0x01, //Weierstrass Curve ? Binary Field
    HSM_VSM_ASYMKEY_ECC_EDWRAD      = 0x02, //Edwards Curve
    HSM_VSM_ASYMKEY_ECC_MONTGOMERY  = 0x03, //Montgomery Curve
    HSM_VSM_ASYMKEY_ECC_EDDSA       = 0x04, //EdDSA       
}hsm_Vsm_Asym_Ecc_KeyType_E;

typedef struct
{
  hsm_Ecc_CurveType_E curveCurveType_en;
  hsm_Vsm_Asym_Ecc_KeyType_E curveKeyType_en;
  uint8_t privKeySize;
  uint8_t pubKeySize; 
}st_Hsm_Vsm_Ecc_CurveData;


int Hsm_Vsm_Ecc_FindCurveIndex(hsm_Ecc_CurveType_E curveType_en, uint8_t *ptr_index);

#endif /* HSM_COMMON_H */