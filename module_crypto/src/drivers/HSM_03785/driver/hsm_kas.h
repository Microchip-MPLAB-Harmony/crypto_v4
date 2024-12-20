/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology

  @File Name
    hsm_kas.h

  @Summary

  @Description
 */
/* ************************************************************************** */
#ifndef HSM_KAS_H
#define HSM_KAS_H

#include "hsm_common.h"

typedef enum
{
    HSM_KAS_DH_ECC  = 0x00,
    HSM_KAS_DH_DH   = 0x01,
}hsm_Kas_dh_KeyType_E;

typedef struct
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"    
	hsm_CommandGroups_E dhCmdGroup_en       :8; //It represent the command group here command group is always HSM_CMD_AES for Hash Algorithm
    uint8_t dhCmdType                       :8;
    uint8_t reserved1                       :8; //Reserved
    uint8_t dhAuthInc                       :1; //Authentication Included in input bit
    uint8_t dhSlotParamInc                  :1; //This field indicates if slot parameters are included in the list of parameters
    uint8_t reserved2                       :2;  
    hsm_Kas_dh_KeyType_E dhKeyType_en       :2; 
    uint8_t	reserved3                       :2; //Reserved
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
#pragma GCC diagnostic pop    
}st_Hsm_Kas_Dh_CmdHeader;

typedef struct
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"     
    uint8_t useOutputSlot                       :1;
    uint16_t reserved1                          :15;
    st_Hsm_Vsm_VaSlotStoDaLy outputSlotStorDes_st;
    uint8_t outSlotIndex                        :8;
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
#pragma GCC diagnostic pop   
}st_Hsm_Kas_Dh_Param1;

typedef struct
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"    
    uint8_t usePrivKey          :1;
    uint8_t usePubkey           :1;
    uint16_t reserved1          :14;
    uint8_t privKeyVarSlotIndx  :8;
    uint8_t pubKeyVarSlotIndx   :8;
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
#pragma GCC diagnostic pop       
}st_Hsm_Kas_Dh_Param2;

typedef struct
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"      
    uint16_t privKeyLen :16;
    uint16_t pubKeyLen  :16;
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
#pragma GCC diagnostic pop    
}st_Hsm_Kas_Dh_Param3;

typedef struct
{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 6.1" "H3_MISRAC_2012_R_6_1_DR_1"     
    uint16_t keyAuthDataLen :16;
    uint16_t reserved1      :16;
#pragma coverity compliance end_block "MISRA C-2012 Rule 6.1"
#pragma GCC diagnostic pop      
}st_Hsm_Kas_Dh_Param4;

typedef struct
{
	st_Hsm_MailBoxHeader        dhMailBoxHdr_st;
	st_Hsm_Kas_Dh_CmdHeader     dhCmdHeader_st;
	st_Hsm_SgDmaDescriptor      arr_dhInSgDmaDes_st[4] __attribute__((aligned(4)));
	st_Hsm_SgDmaDescriptor      arr_dhOutSgDmaDes_st[1] __attribute__((aligned(4)));
	st_Hsm_Kas_Dh_Param1		dhSharSecretParm1_st __attribute__((aligned(4)));
    st_Hsm_Kas_Dh_Param2        dhInputKeysParam2_st __attribute__((aligned(4)));
    st_Hsm_Kas_Dh_Param3        dhKeysLenParam3_st __attribute__((aligned(4)));
    st_Hsm_Kas_Dh_Param4        dhKeyAuthDataLenParam4_st __attribute__((aligned(4)));
}st_Hsm_Kas_Dh_Cmd __attribute__((aligned(4)));

hsm_Cmd_Status_E Hsm_Kas_Dh_Ecdh_SharedSecret(st_Hsm_Kas_Dh_Cmd *ptr_ecdhCmd_st, uint8_t *ptr_privKey, uint32_t privKeyLen, uint8_t *ptr_Pubkey, uint32_t pubKeyLen,
                                        uint8_t *ptr_sharedSecret, uint16_t sharedSecretLen, hsm_Ecc_CurveType_E keyCurveType_en);
#endif /* HSM_KAS_H */