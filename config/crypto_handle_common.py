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
def CheckCpkclHwFiles(config_symbol, driver):
    if (config_symbol in [g.CONFIG_USE_ECDSA_HW, g.CONFIG_USE_ECDH_HW]) and (driver == "CPKCC"):
        print("CPKCL Driver Files Enabled:(%s)"%(True))
        for fSym in g.cpkclDriverFileSyms:
            fSym.setEnabled(True)
    else:
        print("CPKCL Driver Files Enabled:(%s)"%(False))
        for fSym in g.cpkclDriverFileSyms:
            fSym.setEnabled(False)

################################################################################
# Determines whether files that are shared between functions 
# in a specific driver need to be enabled.
#   - Called by each func. menu's HwScan
################################################################################
def CheckCommonHwFiles():

    # Loop over driver keys (ex. CPKCC, HSM, ...) and get the values which are dicts
    for driver, functionDict in g.hwDriverDict.items():

        # Loop over functions in dict (ex. SHA, AES, ...)
        for function in functionDict.keys():

            if function in g.hwFunctionDriverDict and g.hwFunctionDriverDict[function]:

                # Reset HW accl. logic
                HwEnable = False

                if driver in g.hwFunctionDriverDict.get(function, []):
                    print("driver supported: ", driver)
                    print("function: ", function)

                    # HW config symbols for MCC
                    config_symbols = {
                        "TRNG": g.CONFIG_USE_TRNG_HW,
                        "SHA": g.CONFIG_USE_SHA_HW,
                        "AES": g.CONFIG_USE_AES_HW,
                        #"TDES": g.CONFIG_USE_TDES_HW,
                        #"RSA": g.CONFIG_USE_RSA_HW,
                        #"ECC": g.CONFIG_USE_ECC_HW,
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
                                print("set HwEnable by function:", function)
                                
                                # Special case to enable CryptoLib_CPKCL
                                CheckCpkclHwFiles(config_symbol, driver)
                        except:
                            javaException = sys.exc_info()[1]
                            print("Module not loaded (javaException): ", javaException)

                    print("Checking COMMON for driver %s and function %s" % (driver, function))

                    if "COMMON" in functionDict:
                        for filename in functionDict["COMMON"]:
                            for fSym in g.hwDriverFileDict["COMMON"]:

                                # Remove .ftl from filename
                                if filename.endswith(".ftl"):
                                    filename = filename[:-4]

                                if fSym.getOutputName() == filename:
                                    fSym.setEnabled(HwEnable)                   # Enable/Disable by HwEnable val
                                    print("COMMON:  update [COMMON]%s(%s)"%(
                                        fSym.getOutputName(),fSym.getEnabled()))
                    else:
                        print("No COMMON files found to enable for driver: ", driver)
                        
                else:
                    print("driver NOT supported: ", driver)

    return