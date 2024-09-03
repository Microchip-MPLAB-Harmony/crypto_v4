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

//#define HSM_PRINT (1U)
#define HSM_ECC_MAX_CURVE (4U)

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
    HSM_CMD_PS_RESET = 0x00U,
    HSM_CMD_PS_BOOT = 0x01U,
    HSM_CMD_PS_OPERATIONAL = 0x02U,        
    HSM_CMD_PS_SAFEMODE = 0x3U,         
}hsm_Cmd_StatusPs_E;


typedef enum
{
    HSM_CMD_RC_UNKNOWN = 0x00000000U,
    HSM_CMD_RC_SUCCESS = 0x00000001U,
    HSM_CMD_RC_GENERAL = 0x80000000U,
    HSM_CMD_RC_CANCEL  = 0x80000001U,
    HSM_CMD_RC_NOTSUPPORTED = 0x80000002U,
    HSM_CMD_RC_INVALIDPARAM = 0x80000003U,
    HSM_CMD_RC_INVALIDINPUT = 0x80000004U,
    HSM_CMD_RC_INPUTDMA = 0x80000005U,
    HSM_CMD_RC_OUTPUTDMA = 0x80000006U,
    HSM_CMD_RC_SYSTEMMEM = 0x80000007U,
    HSM_CMD_RC_INPUTAUTH = 0x80000008U,
    HSM_CMD_RC_AUTHFAILED = 0x8000002EU,
    HSM_CMD_RC_SIGNVERIFYFAILED = 0x8000002FU,        
}hsm_CmdResultCodes_E;

typedef enum
{
    HSM_CMD_INVALID = 0xFFU,
    HSM_CMD_BOOT   	= 0U,  // Boot Command
    HSM_CMD_SDBG   	= 1U,  //Secure Debug Command
    HSM_CMD_TMPR   	= 2U,	 //Tamper Response Command	
    HSM_CMD_VSM    	= 3U,  //Variable Slot Management Command
    HSM_CMD_KEYMGM 	= 4U,  //Key Management Commands
    HSM_CMD_HASH   	= 5U,  //Hash Commands
    HSM_CMD_AES    	= 6U,  //AES Commands
    HSM_CMD_CHACHA 	= 7U,  //ChaCha Commands
    HSM_CMD_TDES   	= 8U,  //Triple-DES/3DES Commands
    HSM_CMD_DES    	= 9U,  //DES Commands
    HSM_CMD_RSA    	= 10U, //RSA Commands 
    HSM_CMD_SIGN   	= 11U, //Signature Commands 
    HSM_CMD_X509   	= 12U, //X.509 Certificate Commands 
    HSM_CMD_DH     	= 13U, // Diffie-Hellmen Commands
    HSM_CMD_DICE   	= 14U,  //?? jk
    HSM_CMD_MISC   	= 0xF0U, //?? jk
}hsm_CommandGroups_E;

typedef enum
{
    HSM_ECC_CURVETYPE_P192 = 0x00U,
    HSM_ECC_CURVETYPE_P256 = 0x01U,        
    HSM_ECC_CURVETYPE_P384 = 0x02U,
    HSM_ECC_CURVETYPE_P521 = 0x03U,
    HSM_ECC_MAXIMUM_CURVES_LIMIT,
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
    HSM_SYM_AES_KEY_128 = 0UL,
    HSM_SYM_AES_KEY_192 = 1UL,
    HSM_SYM_AES_KEY_256 = 2UL,
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
    HSM_CMD_AEAD_CHACHA20_ENCRYPT = 0x00U,            
    HSM_CMD_AEAD_CHACHA20_DECRYPT = 0x01U,
    HSM_CMD_SYM_CHACHA20_ENCRYPT = 0x02U,
    HSM_CMD_SYM_CHACHA20_DECRYPT = 0x03U,
    HSM_CMD_MAC_CHACHA20_POLY1305 = 0x04U,
}hsm_ChaCha_CmdTypes_E;

typedef enum
{
    HSM_CMD_ERROR_MAILBOX = -127,
    HSM_CMD_ERROR_CMDHEADER = -126,
    HSM_CMD_ERROR_RESULTCODE = -125,        
    HSM_CMD_ERROR_STATUSREG = -124,
    HSM_CMD_ERROR_INTFLAG = -123,
    HSM_CMD_ERROR_FAILED = -122,
    HSM_CMD_ERROR_AEADAUTH_FAILED = -121,
    HSM_CMD_ERROR_SIGVERIFYFAIL = -120,        
    HSM_CMD_SUCCESS = 0,    
}hsm_Cmd_Status_E;

typedef enum
{
    HSM_VSM_ASYMKEY_ECC = 0x00,
    HSM_VSM_ASYMKEY_RSA = 0x01,
    HSM_VSM_ASYMKEY_DH  = 0x02,
    HSM_VSM_ASYMKEY_DSA = 0x03,            
}hsm_Vsm_Asym_KeyTypes_E;

typedef enum
{
    HSM_VSM_ASYMKEY_ECC_KEYEXCHANGE = 0x00,
    HSM_VSM_ASYMKEY_ECC_SIGNATURE   = 0x01,       
}hsm_Vsm_Asym_Ecc_SignUsed_E;

typedef enum
{
    HSM_VSM_ASYMKEY_ECC_ECDSA   = 0x00,
    HSM_VSM_ASYMKEY_ECC_ECKCDSA = 0x01,       
}hsm_Vsm_Asym_Ecc_AlgoUsed_E;

typedef enum
{
    HSM_VSM_ASYMKEY_PRIVATEKEY = 0x01,
    HSM_VSM_ASYMKEY_PUBLICKEY = 0x02        
}hsm_Vsm_Asym_Ecc_PrivPubKeyType_E;
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
	uint8_t  reserved1              :1;   //reserved
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

typedef struct
{
    hsm_Vsm_Asym_KeyTypes_E asymKeyType_en      :3; 
    uint8_t reserved1                           :1;
    hsm_Vsm_Asym_Ecc_KeyType_E eccKeyType_en    :3;
    uint8_t reserved2                           :1;
    uint8_t eccKeySize                          :8;
    uint8_t paramA                              :2;
    uint8_t reserved3                           :2;
    hsm_Vsm_Asym_Ecc_SignUsed_E signUsed_en     :1;
    uint8_t reserved4                           :3;
    hsm_Vsm_Asym_Ecc_AlgoUsed_E algoUsed_en     :1;
    uint8_t reserved5                           :3;
    uint8_t domainIncBit                        :1;
    uint8_t publicKeyIncBit                     :1;
    uint8_t privateKeyIncBit                    :1;
    uint8_t reserved6                           :1;                   
}st_Hsm_Vss_Ecc_AsymKeyDataType;


int Hsm_Vsm_Ecc_FillEccKeyProperties(st_Hsm_Vss_Ecc_AsymKeyDataType *ptr_eccKey_st, hsm_Ecc_CurveType_E curveType_en, hsm_Vsm_Asym_Ecc_PrivPubKeyType_E PrivPubkeyType,
                                                hsm_Vsm_Asym_Ecc_SignUsed_E eccSignUsed_en, hsm_Vsm_Asym_Ecc_AlgoUsed_E eccAlgoUsed_en);

#endif /* HSM_COMMON_H */