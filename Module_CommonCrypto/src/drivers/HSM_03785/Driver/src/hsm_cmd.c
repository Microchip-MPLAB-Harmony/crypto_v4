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
#include "pic32cz8110ca90208.h"
#include "hsm_common.h"
#include "hsm_cmd.h"
#ifdef HSM_PRINT 
#include <stdio.h>
#endif

void HSM_Cmd_Send(st_Hsm_SendCmdLayout sendCmd_st) 
{
#ifdef HSM_PRINT    
    printf("-------------Cmd Send Started----------\r\n");
#endif    
    // Make sure the HSM is not busy
    while ((uint32_t)(HSM_REGS->HSM_STATUS & HSM_STATUS_BUSY_Msk) == 1UL)
    {
        //do nothing
    };
    
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
    for(uint8_t count = 0U; count < sendCmd_st.paramsCount; count++)
    {
        HSM_REGS->HSM_MBFIFO[0] = sendCmd_st.ptr_params[count];
    }

#ifdef HSM_PRINT    
    //Print all the parameters
    //--------------------------------------------------------------------------
    printf("ptr_mailBoxHeader = 0x%08lx\r\n",*sendCmd_st.mailBoxHdr);
    printf("ptr_cmdHeader = 0x%08lx\r\n",*sendCmd_st.algocmdHdr);
    printf("ptr_sgDesInput = 0x%08lx\r\n", *sendCmd_st.ptr_sgDescriptorIn);
    printf("ptr_sgDesIOutput = 0x%08lx\r\n", *sendCmd_st.ptr_sgDescriptorOut);
    for(uint8_t count = 0U; count < sendCmd_st.paramsCount; count++)
    {
        printf("Params[%d] = 0x%08lx\r\n",count, sendCmd_st.ptr_params[count]);
    }
    //--------------------------------------------------------------------------
    
    printf("-------------Cmd Send Finished----------\r\n");
#endif   
}

void Hsm_Cmd_ReadCmdResponse(st_Hsm_ResponseCmd *response_st) 
{
    uint32_t mbrxstatus;
    uint8_t cmdLen = 0;
    uint8_t count = 0;
#ifdef HSM_PRINT    
    printf("-------------Cmd Response Reading Started----------\r\n");
#endif
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.3" "H3_MISRAC_2012_R_10_3_DR_1"
    // Check Result Code
    response_st->resultCode_en = HSM_REGS->HSM_MBFIFO[0];
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.3"
#pragma GCC diagnostic pop     
    
    //Command Length in 32-bit WORD
    cmdLen = (uint8_t) ((response_st->respMailBoxHdr & 0x0000FFFFUL)/4UL);
    for(count = 0; count < cmdLen; count++)
    {
        response_st->arr_params[count] = HSM_REGS->HSM_MBFIFO[count]; 
    }
#ifdef HSM_PRINT    
     printf("-------------Cmd Response Reading Finished----------\r\n");
#endif
}

hsm_Cmd_Status_E Hsm_Cmd_CheckCmdRespParms(st_Hsm_ResponseCmd respParms_st, uint32_t expMailbox, uint32_t expCmdHeader) 
{
    uint32_t intFlag = 0;
    hsm_Cmd_Status_E ret_status_en = HSM_CMD_SUCCESS;
#ifdef HSM_PRINT
    printf("-------------Cmd Response Checking Started----------\r\n");
    //|1|Compare the Mailbox Header
    printf("Cmd Mail Box Header = 0x%08lx\r\n", respParms_st.respMailBoxHdr);
#endif    
    if(respParms_st.respMailBoxHdr !=  expMailbox)
    {
        //issue with responses
        ret_status_en = HSM_CMD_ERROR_MAILBOX;
#ifdef HSM_PRINT        
        printf("Cmd MailBox Header Matched Failed\r\n");
#endif
    }
    else
    {
#ifdef HSM_PRINT
        printf("Cmd MailBox Header Matched Passed\r\n");
#endif        
    }
     
    //|2|Compare the Command Header 
#ifdef HSM_PRINT
    printf("Cmd Header = 0x%08lx\r\n", respParms_st.respCmdHeader);
#endif    
    if(respParms_st.respCmdHeader != expCmdHeader)
    {
        //Issue with response
        ret_status_en = HSM_CMD_ERROR_CMDHEADER;
#ifdef HSM_PRINT        
        printf("Cmd Header Matched Failed\r\n");
#endif        
    }
    else
    {
#ifdef HSM_PRINT
        printf("Cmd Header Matched Passed\r\n");
#endif        
    }
    
    //|3|Check the Result Code
#ifdef HSM_PRINT    
    printf("Result code = 0x%08x\r\n", respParms_st.resultCode_en);
#endif    
    if(respParms_st.resultCode_en != HSM_CMD_RC_SUCCESS)
    {
        //issue with response
        ret_status_en = HSM_CMD_ERROR_RESULTCODE;
#ifdef HSM_PRINT        
        printf("result Code Failed\r\n");
#endif        
    }
    else
    {
#ifdef HSM_PRINT        
        printf("result Code OK Success\r\n");
#endif        
    }
    //delay before HSM status register read //?? how much delay exactly, that needs to confirm???????????????
    for(uint32_t i = 0UL; i < 10000UL; i++)
    {
	    //|4| Fetch the HSM Status Register (STATUS)
	    respParms_st.status_st.busy = (uint8_t)HSM_CMD_STATUS_BUSY;    //HSM CPU Busy Status  
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunknown-pragmas"
#pragma coverity compliance block deviate "MISRA C-2012 Rule 10.8" "H3_MISRAC_2012_R_10_8_DR_1"        
	    respParms_st.status_st.ps = (hsm_Cmd_StatusPs_E)HSM_CMD_STATUS_PS;        //Processing State Status        
	    respParms_st.status_st.lcs = (hsm_Cmd_StatusLcs_E)HSM_CMD_STATUS_LCS;      //Lifecycle State Status
	    respParms_st.status_st.sbs = (hsm_Cmd_StatusSbs_E)HSM_CMD_STATUS_SBS;      //Secure Boot Status
#pragma coverity compliance end_block "MISRA C-2012 Rule 10.8"
#pragma GCC diagnostic pop         
	    respParms_st.status_st.ecode = (uint8_t)HSM_CMD_STATUS_ECODE;  //Error Code
#ifdef HSM_PRINT    
	    printf("Busy Status = 0x%08x\r\n", respParms_st.status_st.busy);
	    printf("PS Status = 0x%08x\r\n", respParms_st.status_st.ps);
	    printf("LCS Status = 0x%08x\r\n", respParms_st.status_st.lcs);
	    printf("SBS Status = 0x%08x\r\n", respParms_st.status_st.sbs);
	    printf("ECODE Status = 0x%08x\r\n", respParms_st.status_st.ecode);
#endif    
        //Check status of HSM Status Registers
        if( (respParms_st.status_st.busy != 0x00U)
                || (respParms_st.status_st.ps != HSM_CMD_PS_OPERATIONAL)
                || (respParms_st.status_st.lcs != HSM_CMD_LCS_OPEN)
                || ( (respParms_st.status_st.sbs != HSM_CMD_SBS_DISABLED) && (respParms_st.status_st.sbs != HSM_CMD_SBS_RESET) )
                || (respParms_st.status_st.ecode != 0x00U) )

        {
            if(i == 9999UL)
            {
                 //Issue: HSM Status Failed 
                ret_status_en = HSM_CMD_ERROR_STATUSREG;
#ifdef HSM_PRINT 
        		printf("Status Register Failed\r\n");
#endif 
            }
        }
        else
        {
            //HSM Status Passed
#ifdef HSM_PRINT        
        	printf("Status Register Passed\r\n");
#endif        
            break;
        } 
    }
    
    //|5|Check the HSM Interrupt Flash Register (INTFLAG)
    intFlag = HSM_REGS->HSM_INTFLAG;

    if(intFlag == 0x00000000UL)
    {
        //Interrupt Flag Register status Pass;
#ifdef HSM_PRINT        
        printf("Interrupt Flag Register Status Passed\r\n");
#endif        
    }
    else
    {
        //Interrupt Flag Status Failed;
        ret_status_en = HSM_CMD_ERROR_INTFLAG;
#ifdef HSM_PRINT        
        printf("Interrupt Flag Register Status Failed\r\n");
#endif        
        // Clear the INTFLAG.ERROR If error Interrupt is SET
        //As per the data Sheet write 1 to clear, writing 0 has no effect
        if((intFlag & 0x00000001UL) == 0x00000001UL) 
        {
            HSM_REGS->HSM_INTFLAG |= 0x00000001UL;
        }
    }
#ifdef HSM_PRINT    
    printf("-------------Cmd Response Checking Finished ----------\r\n");
#endif    
    return ret_status_en;
}