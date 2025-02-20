<#if hsm_boot_h_ftl_flag == true>
    /* Initialize HSM */
    while (true)
    {
        if (Hsm_Boot_Initialization() != 0x00 || Hsm_Boot_GetStatus() == 0x01)
        {
            break;  // Exit loop and start the application
        }
    }
</#if>