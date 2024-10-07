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

#----------------------------------------------------------------------------------------- 
def instantiateComponent(WolfcryptComponent):
    wolfcryptSetUpAllMenu(WolfcryptComponent)
    

    # TODO: Make dict attaching functions and their necessary files together

    # TODO: Attach callback for wc menus and put sendMessage into the callback
  
    args = {
        # filename: symbol
        "someBool": True,
        "someVal": 42,
        "someStr": "/path/to/file",
    }

    # tell lib_crypto this module needs this dict of files
    Database.sendMessage("lib_crypto", "fileReq", args)

def handleMessage(messageID, args):
    print("hey it's crypto_wc receiving")
    print("messageID: ", messageID)
    # print("args: ", args)

    # Loop through all files in Crypto_HW_Files
    for file_name, file_info in args.items():
        # Get the file symbol from the tuple (file_path, file_symbol)
        file_symbol = file_info[1]
        
        # Enable the file symbol if the file is in the all_enabled_files list, otherwise disable it
        print("sym.getID(): ", file_symbol.getID())
        print("sym.getEnabled(): ", file_symbol.getEnabled())


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