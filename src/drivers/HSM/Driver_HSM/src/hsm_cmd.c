/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Microchip Technology         

  @File Name
    hsm_cmd.c

  @Summary
    Common Cmd function for HSM

  @Description
   Common Cmd function for HSM

 */
/* ************************************************************************** */

/* ************************************************************************** */
/* ************************************************************************** */
/* Section: Included Files                                                    */
/* ************************************************************************** */
/* ************************************************************************** */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "pic32cz8110ca90208.h"
#include "system/system_module.h"
#include "core_cm7.h"
#include "user.h"
#include "hsm_common.h"
//#include "hsm_command.h"
#include "hsm_cmd.h"

void HSM_Cmd_Send(st_Hsm_SendCmdLayout sendCmd_st) 
{
    
    SYS_PRINT("-------------Cmd Send Started----------\r\n");
    // Make sure the HSM is not busy
    while (HSM_REGS->HSM_STATUS & HSM_STATUS_BUSY_Msk);
    
    HSM_REGS->HSM_MBCONFIG = HSM_MBCONFIG_RXINT(0);
    
    // Write the Mailbox Header
    HSM_REGS->HSM_MBTXHEAD  = (uint32_t)*sendCmd_st.mailBoxHdr;

    // Write the Command Header
    HSM_REGS->HSM_MBFIFO[0] = (uint32_t)*sendCmd_st.algocmdHdr; //why FIFO index is 0 always??

    //Input Scatter-Gather DMA Descriptors
    HSM_REGS->HSM_MBFIFO[0] = (uint32_t)sendCmd_st.ptr_sgDescriptorIn;
    
    //Output Scatter-Gather DMA Descriptors
    HSM_REGS->HSM_MBFIFO[0] = (uint32_t)sendCmd_st.ptr_sgDescriptorOut;

    //Send Parameters
    for(int count = 0; count < sendCmd_st.paramsCount; count++)
    {
        HSM_REGS->HSM_MBFIFO[0] = sendCmd_st.ptr_params[count];
    }
    
    //Print all the parameters
    //--------------------------------------------------------------------------
    SYS_PRINT("ptr_mailBoxHeader = 0x%08lx\r\n",*sendCmd_st.mailBoxHdr);
    SYS_PRINT("ptr_cmdHeader = 0x%08lx\r\n",*sendCmd_st.algocmdHdr);
    SYS_PRINT("ptr_sgDesInput = 0x%08lx\r\n", *sendCmd_st.ptr_sgDescriptorIn);
    SYS_PRINT("ptr_sgDesIOutput = 0x%08lx\r\n", *sendCmd_st.ptr_sgDescriptorOut);
    for(int count = 0; count < sendCmd_st.paramsCount; count++)
    {
        SYS_PRINT("Params[%d] = 0x%08lx\r\n",count, sendCmd_st.ptr_params[count]);
    }
    //--------------------------------------------------------------------------
    
    SYS_PRINT("-------------Cmd Send Finished----------\r\n");
}


void Hsm_Cmd_ReadCmdResponse(st_Hsm_ResponseCmd *response_st) 
{
    uint32_t mbrxstatus;
    uint8_t cmdLen = 0;
    uint8_t count = 0;
    
    SYS_PRINT("-------------Cmd Response Reading Started----------\r\n");
    // Check for response received by reading RXINT
    mbrxstatus = HSM_REGS->HSM_MBRXSTATUS;

    //Poll RXINT in non-interrupt mode  //????????????????????????????????????????????????? what to do in interrupt mode??????????
    //  (in interrupt mode this 'while' acts as an 'if')
    while ((mbrxstatus & MBRXSTATUS_RXINT_MASK) != MBRXSTATUS_RXINT_MASK) 
        { mbrxstatus = HSM_REGS->HSM_MBRXSTATUS; }
    
    // Check Mailbox Header
    response_st->respMailBoxHdr = HSM_REGS->HSM_MBRXHEAD;          
    
    // Check Mailbox Command Header
    response_st->respCmdHeader = HSM_REGS->HSM_MBFIFO[0];
    
    // Check Result Code
    response_st->resultCode_en  = HSM_REGS->HSM_MBFIFO[0];    

    
    //Command Length in 32-bit WORD
    cmdLen = (uint8_t) ((response_st->respMailBoxHdr & 0x0000FFFF) / 4);
    for(count = 0; count < cmdLen; count++)
    {
        response_st->arr_params[count] = HSM_REGS->HSM_MBFIFO[count]; 
    }
    
     SYS_PRINT("-------------Cmd Response Reading Finished----------\r\n");
}

hsm_Cmd_Status_E Hsm_Cmd_CheckCmdRespParms(st_Hsm_ResponseCmd respParms_st, uint32_t expMailbox, uint32_t expCmdHeader) 
{
    uint32_t intFlag = 0;
    hsm_Cmd_Status_E ret_status_en = HSM_CMD_SUCCESS;

    SYS_PRINT("-------------Cmd Response Checking Started----------\r\n");
    //|1|Compare the Mailbox Header
    SYS_PRINT("Cmd Mail Box Header = 0x%08lx\r\n", respParms_st.respMailBoxHdr);
    if(respParms_st.respMailBoxHdr !=  expMailbox)
    {
        //issue with responses
        ret_status_en = HSM_CMD_ERROR_MAILBOX;
        SYS_PRINT("Cmd MailBox Header Matched Failed\r\n");
    }
    else
    {
        SYS_PRINT("Cmd MailBox Header Matched Passed\r\n");
    }
     
    //|2|Compare the Command Header 
    SYS_PRINT("Cmd Header = 0x%08lx\r\n", respParms_st.respCmdHeader);
    if(respParms_st.respCmdHeader != expCmdHeader)
    {
        //Issue with response
        ret_status_en = HSM_CMD_ERROR_CMDHEADER;
        SYS_PRINT("Cmd Header Matched Failed\r\n");
    }
    else
    {
        SYS_PRINT("Cmd Header Matched Passed\r\n");
    }
    
    //|3|Check the Result Code
    SYS_PRINT("Result code = 0x%08x\r\n", respParms_st.resultCode_en);
    if(respParms_st.resultCode_en != HSM_CMD_ERROR_SUCCESS)
    {
        //issue with response
        ret_status_en = HSM_CMD_ERROR_RESULTCODE;
        SYS_PRINT("result Code Failed\r\n");
    }
    else
    {
        SYS_PRINT("result Code OK Success\r\n");
    }
     
    //|4| Fetch the HSM Status Register (STATUS)
    respParms_st.status_st.busy = HSM_CMD_STATUS_BUSY;    //HSM CPU Busy Status  
    respParms_st.status_st.ps = HSM_CMD_STATUS_PS;        //Processing State Status
    respParms_st.status_st.lcs = HSM_CMD_STATUS_LCS;      //Lifecycle State Status
    respParms_st.status_st.sbs = HSM_CMD_STATUS_SBS;      //Secure Boot Status
    respParms_st.status_st.ecode = HSM_CMD_STATUS_ECODE;  //Error Code
    
    SYS_PRINT("Busy Status = 0x%08x\r\n", respParms_st.status_st.busy);
    SYS_PRINT("PS Status = 0x%08x\r\n", respParms_st.status_st.ps);
    SYS_PRINT("LCS Status = 0x%08x\r\n", respParms_st.status_st.lcs);
    SYS_PRINT("SBS Status = 0x%08x\r\n", respParms_st.status_st.sbs);
    SYS_PRINT("ECODE Status = 0x%08x\r\n", respParms_st.status_st.ecode);
    
    //Chekc status of HSM Status Registers
    if( (respParms_st.status_st.busy != 0x00)
            || (respParms_st.status_st.ps != HSM_CMD_PS_OPERATIONAL)
            || (respParms_st.status_st.lcs != HSM_CMD_LCS_OPEN)
            || ( (respParms_st.status_st.sbs != HSM_CMD_SBS_DISABLED) && (respParms_st.status_st.sbs != HSM_CMD_SBS_RESET) )
            || (respParms_st.status_st.ecode != 0x00) )

    {
        //Issue: HSM Status Failed 
        ret_status_en = HSM_CMD_ERROR_STATUSREG;
        SYS_PRINT("Status Register Failed\r\n");
    }
    else
    {
        //HSM Status Passed
        SYS_PRINT("Status Register Passed\r\n");
    } 
    
    //|5|Check the HSM Interrupt Flash Register (INTFLAG)
    intFlag = HSM_REGS->HSM_INTFLAG;

    if(intFlag == 0x00000000)
    {
        //Interrupt Flag Register status Pass;
        SYS_PRINT("Interrupt Flag Register Status Passed\r\n");
    }
    else
    {
        //Interrupt Flag Status Failed;
        ret_status_en = HSM_CMD_ERROR_INTFLAG;
        SYS_PRINT("Interrupt Flag Register Status Failed\r\n");
        // Clear the INTFLAG.ERROR If error Interrupt is SET
        //As per the data Sheet write 1 to clear, writing 0 has no effect
        if((intFlag & 0x00000001) == 0x00000001) 
        {
            HSM_REGS->HSM_INTFLAG |= 0x00000001;
        }
    }
    SYS_PRINT("-------------Cmd Response Checking Finished ----------\r\n");
    
    return ret_status_en;
}