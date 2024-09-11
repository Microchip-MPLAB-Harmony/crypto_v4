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

import inspect
import os
import sys
import glob
import ntpath

import crypto_defs as g #Modified globals
import crypto_handle_common

################################################################################
# Scan to see if any DS Hardware algorithm was enabled and then enable or
# disable driver files accordingly. 
################################################################################
def UpdateDigSignHwDriverFiles():

    useHw = g.CONFIG_USE_ECDSA_HW.getValue()

    #Enable/Disable ECDSA specific HW Driver Files
    print("DSA: Update ECDSA specific HW Driver (%s)"%(useHw))
    for fSym in g.hwDriverFileDict["ECDSA"]:
        fSym.setEnabled(useHw)
        print("  %s(%s)"%(fSym.getID(), fSym.getEnabled()))

    crypto_handle_common.CheckCommonHwFiles()

    return True

################################################################################
# Setup the DS Menu Items and File Generation
# --HW File symbols are listed in g.hwFileDict["ECDSA"] list dictionary
################################################################################
def SetupCryptoDsMenu(cryptoComponent):

    ##########################################################
    # General DS File Generation Enable (MCHP_Crypto_DigSign_Config.h)
    g.CONFIG_USE_DS= cryptoComponent.createBooleanSymbol("CONFIG_USE_DS", None)
    g.CONFIG_USE_DS.setVisible(False)
    g.CONFIG_USE_DS.setLabel("Crypto")
    g.CONFIG_USE_DS.setDefaultValue(False)

    #DS - Crypto DS Algorithms Main Menu
    g.dsMenu = cryptoComponent.createMenuSymbol("crypto_ds_menu", None)
    g.dsMenu.setLabel("Digital Signing Algorithms")
    g.dsMenu.setDescription("Digial Signing Algorithms")
    g.dsMenu.setVisible(True)
    g.dsMenu.setHelp('MC_CRYPTO_DS_API_H')
    
    ##########################################################
    #ECDSA File Generation Enable
    g.CONFIG_USE_ECDSA= cryptoComponent.createBooleanSymbol("CONFIG_USE_ECDSA", None)
    g.CONFIG_USE_ECDSA.setVisible(False)
    g.CONFIG_USE_ECDSA.setLabel("Crypto ECDSA")
    g.CONFIG_USE_ECDSA.setDefaultValue(False)

    g.CONFIG_USE_ECDSA_HW= cryptoComponent.createBooleanSymbol("CONFIG_USE_ECDSA_HW", None)
    g.CONFIG_USE_ECDSA_HW.setVisible(False)
    g.CONFIG_USE_ECDSA_HW.setLabel("Crypto ECDSA HW")
    g.CONFIG_USE_ECDSA_HW.setDefaultValue(False)

    # KAS Option: ECDSA Enable
    g.cryptoDsEcdsaEnabledSymbol = cryptoComponent.createBooleanSymbol("crypto_ds_ecdsa_en", g.dsMenu)
    g.cryptoDsEcdsaEnabledSymbol.setLabel("ECDSA?")
    g.cryptoDsEcdsaEnabledSymbol.setDescription("Enable support for the Digital Signing ECDSA protocol")
    g.cryptoDsEcdsaEnabledSymbol.setVisible(True)
    g.cryptoDsEcdsaEnabledSymbol.setDefaultValue(False)
    g.cryptoDsEcdsaEnabledSymbol.setHelp('CRYPT_ECDSA_SUM')

    #KAS Option: ECDSA Hardware Enable
    g.cryptoHwDsEcdsaEnabledSymbol = cryptoComponent.createBooleanSymbol("crypto_ds_ecdsa_hw_en", g.cryptoDsEcdsaEnabledSymbol)
    g.cryptoHwDsEcdsaEnabledSymbol.setLabel("Use Hardware Acceleration?")
    g.cryptoHwDsEcdsaEnabledSymbol.setDescription("Turn on hardware acceleration for the ECDSA Signing Algorithm")
    g.cryptoHwDsEcdsaEnabledSymbol.setVisible(False)
    g.cryptoHwDsEcdsaEnabledSymbol.setDefaultValue(False)

    if g.cryptoHwDsEcdsaSupported:
        g.cryptoDsEcdsaEnabledSymbol.setDependencies(
            handleDsEcdsaEnabled,
            ["crypto_ds_ecdsa_en", "crypto_ds_ecdsa_hw_en"]
        )
        if g.cryptoDsEcdsaEnabledSymbol.getValue():
            g.cryptoHwDsEcdsaEnabledSymbol.setVisible(True)

    #Check to see if any of the Ds selections is True
    print("CRYPTO: DS Update Hw Driver Files")
    UpdateDigSignHwDriverFiles()

#-----------------------------------------------------
#DS-ECDSA Handlers

def handleDsEcdsaEnabled(symbol, event):

    # If algorithm toggle (In this case, ECDSA) is what triggered the callback
    if symbol.getID() == event["id"]:
        if not symbol.getValue():
            g.CONFIG_USE_ECDSA.setValue(False)
            g.CONFIG_USE_ECDSA_HW.setValue(False)
            g.cryptoHwDsEcdsaEnabledSymbol.setVisible(False)
        else:
            g.CONFIG_USE_ECDSA.setValue(True)
            g.cryptoHwDsEcdsaEnabledSymbol.setVisible(True)

    # Logic to Enable/Disable ECDSA Hardware
    if g.cryptoHwDsEcdsaEnabledSymbol.getValue() and g.cryptoHwDsEcdsaEnabledSymbol.getVisible():
        g.CONFIG_USE_ECDSA_HW.setValue(True)
    else:
        g.CONFIG_USE_ECDSA_HW.setValue(False)
    
    print("g.CONFIG_USE_ECDSA: ", g.CONFIG_USE_ECDSA.getValue())
    print("g.CONFIG_USE_ECDSA_HW: ", g.CONFIG_USE_ECDSA_HW.getValue())

    # Enable/Disable DS Hardware Driver Files 
    UpdateDigSignHwDriverFiles()