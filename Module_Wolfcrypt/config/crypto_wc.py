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
# TODO: Figure out how to remove Component Symbols so that re-adding the module works
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
def setup_wc_settings(component):
    #Global Preprocessor define - HAVE_CONFIG_H
    #NOTE:  Used by WolfSSL library to use config.h
    wolfcryptConfigH = component.createSettingSymbol("wolfsslConfigH", None)
    wolfcryptConfigH.setCategory("C32")
    wolfcryptConfigH.setKey("preprocessor-macros")
    wolfcryptConfigH.setValue("HAVE_CONFIG_H")
    wolfcryptConfigH.setAppend(True, ";")

    #Global Preprocessor define - WOLFSSL_USER_SETTINGS
    #NOTE:  Used by WolfSSL library to use user_settings.h
    wolfcryptUserSettingsH = component.createSettingSymbol("wolfsslUserSettingsH", None)
    wolfcryptUserSettingsH.setCategory("C32")
    wolfcryptUserSettingsH.setKey("preprocessor-macros")
    wolfcryptUserSettingsH.setValue("WOLFSSL_USER_SETTINGS")
    wolfcryptUserSettingsH.setAppend(True, ";")

    #Global Preprocessor define - WOLFSSL_IGNORE_FILE_WARN
    wolfcryptIgnoreFileWarn = component.createSettingSymbol("wolfsslIgnoreFileWarn", None)
    wolfcryptIgnoreFileWarn.setCategory("C32")
    wolfcryptIgnoreFileWarn.setKey("preprocessor-macros")
    wolfcryptIgnoreFileWarn.setValue("WOLFSSL_IGNORE_FILE_WARN")
    wolfcryptIgnoreFileWarn.setAppend(True, ";")