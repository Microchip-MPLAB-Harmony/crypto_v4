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


#################################################################################
#### Function to Instantiate the Harmony 3 TM Component - dynamic    
#### Crypto V4 API Library Component - specific to processor
#
# Description:
#    Function that is called during component activation (added to the project
#    graph). The component is allowed to establish dependencies and create
#    symbols.
#     --Code is generated later based on configuration settings
#
# Parameters:
#    component (LocalComponent) – local interface to the newly added component
#    [index (integer)] - for instanced components only, indicates the instance index
#
#### NOTE(s): 
####    1) crypto component module defined by module.py in crypto/config
#################################################################################
from email import message
import os
execfile( Module.getPath() + os.path.join("config", "Crypto_HW_Driver.py"))
execfile( Module.getPath() + os.path.join("config", "Crypto_HW_MenuInGUI.py"))
execfile( Module.getPath() + os.path.join("config", "crypto_handle_files.py"))
execfile( Module.getPath() + os.path.join("config", "crypto_globals.py"))

def instantiateComponent(CommonCryptoComponent):

    # Check against ATDF for supported hardware and create necessary symbols
    supported_drivers = Crypto_HW_GetSupportedDriverList(CommonCryptoComponent)

    # Use supported drivers list to assemble list of sets containing relevant file symbols 
    setup_hw_files(CommonCryptoComponent, supported_drivers)

    # Turn directories that are being requested in Crypto_HW_DriverAndWrapperFilesDict{} into its files
    expand_dir_entries_in_driver_requests()
  
    # Build GUI
    Crypto_Hw_DetectDriverAlgosAndShowMenu(CommonCryptoComponent)


# Insert messages into Crypto_Attached_Category_Reqs
def handleMessage(messageID, args):
    # TODO: Cleanse input and error check

    # Insert algoCategories from message into global dict
    for key in args.keys():
        Crypto_Attached_Category_Reqs[key] = args[key]

    Refresh_Files()


# Clean up entries into Crypto_Attached_Category_Reqs
def onAttachmentDisconnected(source, target):
    print("Disconnected" + source["component"].getID() + " and " + target["component"].getID())

    for key in list(Crypto_Attached_Category_Reqs.keys()):
        if key == source["component"].getID() or key == target["component"].getID():
            del Crypto_Attached_Category_Reqs[key]

    Refresh_Files()


# Figure out how to remove Component Symbols so that re-adding the module works
def destroyComponent(CommonCryptoComponent):

    print("goodbye :)")
    idList = Database.getActiveComponentIDs()
    symIDList = Database.getComponentSymbolIDs(CommonCryptoComponent.getID())
    symIDList_str = [str(item) for item in symIDList]
    print(idList)
    print(symIDList)
    
    return
