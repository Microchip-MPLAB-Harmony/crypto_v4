# coding: utf-8
'''#*******************************************************************************
# Copyright (C) 2024 Microchip Technology Inc. and its subsidiaries.
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

import sys

import crypto_defs as g

################################################################################
# Determines whether to enable or disable the files in
# the CryptoLib_CPKCL folder. These files are used by the 
# CPKCC driver only and require a special case due to how many
# files there are. 
#   - Called by CheckCommonHwFiles() if HwEnable is True
################################################################################
def CheckCpkclHwFiles(driver):

    if driver == "CPKCC_44163":
        try:            
            enableCpkcl = g.CONFIG_USE_ECDSA_HW.getValue() or g.CONFIG_USE_ECDH_HW.getValue()

            print("CPKCL Driver Files Enabled: (%s)" % enableCpkcl)

            # Enable or disable CPKCL driver files based on the configuration
            for fSym in g.cpkclDriverFileSyms:
                fSym.setEnabled(enableCpkcl)
        except:
            javaException = sys.exc_info()[1]
            print("Module not loaded (javaException): ", javaException)


################################################################################
# Determines whether files that are shared between functions 
# in a specific driver need to be enabled.
#   - Called by each func. menu's HwScan
################################################################################
def CheckCommonHwFiles():

    # Loop over driver keys (ex. CPKCC, HSM, ...) and get the values which are dicts
    for driver, functionDict in g.hwDriverDict.items():

        # Reset HW accl. logic
        HwEnable = False
        
        # Loop over functions in dict (ex. SHA, AES, ...)
        for function in functionDict.keys():

            if function in g.hwFunctionDriverDict and g.hwFunctionDriverDict[function]:

                if any(substring in driver for substring in g.hwFunctionDriverDict.get(function, [])):

                    # HW config symbols for MCC
                    config_symbols = {
                        "TRNG": g.CONFIG_USE_TRNG_HW,
                        "SHA": g.CONFIG_USE_SHA_HW,
                        "AES": g.CONFIG_USE_AES_HW,
                        "AEAD": g.CONFIG_USE_AEAD_HW,
                        "ECDSA": g.CONFIG_USE_ECDSA_HW,
                        "ECDH": g.CONFIG_USE_ECDH_HW,
                    }

                    config_symbol = config_symbols.get(function)

                    # Figure out if any algos require HW
                    if config_symbol:

                        # Required try-catch for case where module removed and re-added 
                        try:
                            if config_symbol.getValue() is True:
                                HwEnable = True
                                print("set HwEnable by function: %s" %(function))
                                
                        except:
                            javaException = sys.exc_info()[1]
                            print("Module not loaded (javaException): ", javaException)
                        
                    # Special case to enable CryptoLib_CPKCL
                    CheckCpkclHwFiles(driver)

                    # Enable/Disable COMMON
                    print("Checking COMMON for driver %s and function %s" % (driver, function))

                    if "COMMON" in functionDict:
                        for filename in functionDict["COMMON"]:
                            for fSym in g.hwDriverFileDict["COMMON"]:

                                # Remove .ftl from filename
                                if filename.endswith(".ftl"):
                                    filename = filename[:-4]

                                if fSym.getOutputName() == filename:
                                    fSym.setEnabled(HwEnable)
                                    # print("update [COMMON]%s(%s)"%(
                                    #     fSym.getOutputName(),fSym.getEnabled()))
                    else:
                        print("No COMMON files found to enable for driver: ", driver)
                else:
                    print("Driver: ", driver, "is not supported.")
    return