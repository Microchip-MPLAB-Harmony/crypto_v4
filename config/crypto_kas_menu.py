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
# Scan to see if any KAS Hardware algorithm was enabled and then enable or
# disable driver files accordingly. 
################################################################################
def UpdateKasHwDriverFiles():

    useHw = g.CONFIG_USE_ECDH_HW.getValue()

    #Enable/Disable ECDH specific HW Driver Files
    print("KAS: Update ECDH specific HW Driver (%s)"%(useHw))
    for fSym in g.hwDriverFileDict["ECDH"]:
        fSym.setEnabled(useHw)
        print("  %s(%s)"%(fSym.getID(), fSym.getEnabled()))

    crypto_handle_common.CheckCommonHwFiles()

    return True

################################################################################
# Setup the KAS Menu Items and File Generation
# --HW Files symbols are listed in g.hwFileDict["ECDH"] list dictionary
################################################################################
def SetupCryptoKasMenu(cryptoComponent):
    print("CRYPTO: Setup KAS Menu")

    ##########################################################
    # General KAS File Generation Enable (MCHP_Crypto_Kas_Config.h)
    g.CONFIG_USE_KAS = cryptoComponent.createBooleanSymbol("CONFIG_USE_KAS", None)
    g.CONFIG_USE_KAS.setVisible(False)
    g.CONFIG_USE_KAS.setLabel("Crypto")
    g.CONFIG_USE_KAS.setDefaultValue(False)

    #KAS - Crypto KAS Algorithms Main Menu
    g.kasMenu = cryptoComponent.createMenuSymbol("crypto_kas_menu", None)
    g.kasMenu.setLabel("Key Agreement Scheme")
    g.kasMenu.setDescription("Key Agreement Algorithms")
    g.kasMenu.setVisible(True)
    g.kasMenu.setHelp('MC_CRYPTO_KAS_API_H')

    ##########################################################
    # ECDH File Generation Enable 
    g.CONFIG_USE_ECDH = cryptoComponent.createBooleanSymbol("CONFIG_USE_ECDH", None)
    g.CONFIG_USE_ECDH.setVisible(False)
    g.CONFIG_USE_ECDH.setLabel("Crypto ECDH")
    g.CONFIG_USE_ECDH.setDefaultValue(False)

    # ECDH Hardware File Generation Enable 
    g.CONFIG_USE_ECDH_HW = cryptoComponent.createBooleanSymbol("CONFIG_USE_ECDH_HW", None)
    g.CONFIG_USE_ECDH_HW.setVisible(False)
    g.CONFIG_USE_ECDH_HW.setLabel("Crypto ECDH HW")
    g.CONFIG_USE_ECDH_HW.setDefaultValue(False)

    # KAS Option: ECDH Enable
    g.cryptoKasEcdhEnabledSymbol = cryptoComponent.createBooleanSymbol("crypto_kas_ecdh_en", g.kasMenu)
    g.cryptoKasEcdhEnabledSymbol.setLabel("ECDH?")
    g.cryptoKasEcdhEnabledSymbol.setDescription("Enable support for the Digital Signing ECDH protocol")
    g.cryptoKasEcdhEnabledSymbol.setVisible(True)
    g.cryptoKasEcdhEnabledSymbol.setDefaultValue(False)
    g.cryptoKasEcdhEnabledSymbol.setHelp('CRYPT_ECDH_SUM')

    #KAS Option: ECDH Hardware Enable
    g.cryptoHwKasEcdhEnabledSymbol = cryptoComponent.createBooleanSymbol("crypto_kas_ecdh_hw_en", g.cryptoKasEcdhEnabledSymbol)
    g.cryptoHwKasEcdhEnabledSymbol.setLabel("Use Hardware Acceleration?")
    g.cryptoHwKasEcdhEnabledSymbol.setDescription("Turn on hardware acceleration for the ECDH Key Agreement Algorithm")
    g.cryptoHwKasEcdhEnabledSymbol.setVisible(False)
    g.cryptoHwKasEcdhEnabledSymbol.setDefaultValue(False)

    if g.cryptoHwKasEcdhSupported:
        g.cryptoKasEcdhEnabledSymbol.setDependencies(
            handleKasEcdhEnabled, 
            ["crypto_kas_ecdh_en", "crypto_kas_ecdh_hw_en"]
        )
        if g.cryptoKasEcdhEnabledSymbol.getValue():
            g.cryptoHwKasEcdhEnabledSymbol.setVisible(True)

    #Check to see if any of the Kas selections is True
    print("CRYPTO: KAS Update Hw Driver Files")
    UpdateKasHwDriverFiles()

#-----------------------------------------------------
#KAS-ECDH Handlers

def handleKasEcdhEnabled(symbol, event):

    # If algorithm toggle (In this case, ECDH) is what triggered the callback
    if symbol.getID() == event["id"]:
        if not symbol.getValue():
            g.CONFIG_USE_ECDH.setValue(False)
            g.CONFIG_USE_ECDH_HW.setValue(False)
            g.cryptoHwKasEcdhEnabledSymbol.setVisible(False)
        else:
            g.CONFIG_USE_ECDH.setValue(True)
            g.cryptoHwKasEcdhEnabledSymbol.setVisible(True)

    # Logic to Enable/Disable ECDH Hardware
    if g.cryptoHwKasEcdhEnabledSymbol.getValue() and g.cryptoHwKasEcdhEnabledSymbol.getVisible():
        g.CONFIG_USE_ECDH_HW.setValue(True)
    else:
        g.CONFIG_USE_ECDH_HW.setValue(False)
    
    print("g.CONFIG_USE_ECDH: ", g.CONFIG_USE_ECDH.getValue())
    print("g.CONFIG_USE_ECDH_HW: ", g.CONFIG_USE_ECDH_HW.getValue())

    # Enable/Disable KAS Hardware Driver Files 
    UpdateKasHwDriverFiles()


def PrintKasSymbol(symbol):
    print("    KAS: Symbol ID - %s"%(symbol.getID()))
    print("    KAS: Symbol Enabled - %s"%(symbol.getEnabled()))
    print("    KAS: Symbol Value   - %s"%(symbol.getValue()))
    print("    KAS: Symbol Visible - %s"%(symbol.getVisible()))
    print("    KAS: Symbol ReadOnly - %s"%(symbol.getReadOnly()))
