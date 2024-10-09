# coding: utf-8
'''#*******************************************************************************
# Copyright (C) 2023 Microchip Technology Inc. and its subsidiaries.
#
# Microchip Technology Inc. and its subsidiaries.
#
# Subject to your compliance with these terms, you may use Microchip software
# and any derivatives exclusively with Microchip products. It is your
# responsibility to comply with third party license terms applicable to your
# use of third party software (including open source software) that may
# accompany Microchip software.
#
# THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
# EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
# WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A PARTICULAR
# PURPOSE.
#
# IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
# INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
# WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
# BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
# FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
# ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
# THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.
# ***************************************************************************'''
import os
execfile( Module.getPath() + os.path.join("config", "Crypto_WC_AllMenuList.py"))
execfile( Module.getPath() + os.path.join("config", "wolfcrypt_handle_files.py"))

#----------------------------------------------------------------------------------------- 
def instantiateComponent(WolfcryptComponent):
    wolfcryptSetUpAllMenu(WolfcryptComponent)

    setup_wc_files(WolfcryptComponent)

#----------------------------------------------------------------------------------------- 
# Figure out how to remove Component Symbols so that re-adding the module works
def destroyComponent(WolfcryptComponent):
    idList = Database.getActiveComponentIDs()
    symIDList = Database.getComponentSymbolIDs("lib_wolfcrypt")
    symIDList_str = [str(item) for item in symIDList]

    print("goodbye")
    idList = Database.getActiveComponentIDs()
    symIDList = Database.getComponentSymbolIDs("lib_wolfcrypt")
    print(idList)
    print(symIDList)
    
    return
#-----------------------------------------------------------------------------------------     