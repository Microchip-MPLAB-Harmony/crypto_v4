import crypto_defs as g #Modified globals

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
                        try:
                            if config_symbol.getValue() is True:
                                HwEnable = True
                                print("set HwEnable by function:", function)
                        except Exception as e:
                            print("g.CONFIG_USE_HW not initialized for: ", function)

                    # Enable/Disable COMMON
                    if HwEnable:
                        print("Enabling COMMON for driver %s and function %s" % (driver, function))

                        if "COMMON" in functionDict:
                            
                            for filename in functionDict["COMMON"]:

                                for fSym in g.hwDriverFileDict["COMMON"]:

                                    # Remove .ftl from filename
                                    if filename.endswith(".ftl"):
                                        filename = filename[:-4]

                                    if fSym.getOutputName() == filename:
                                        fSym.setEnabled(True)
                                        print("COMMON:  update [COMMON]%s(%s)"%(
                                            fSym.getOutputName(),fSym.getEnabled()))
                        else:
                            print("No COMMON files found to enable for driver: ", driver)
                    else:
                        print("Disabling COMMON for driver %s and function %s" % (driver, function))

                        if "COMMON" in functionDict:
                            for filename in functionDict["COMMON"]:

                                for fSym in g.hwDriverFileDict["COMMON"]:

                                    # Remove .ftl from filename
                                    if filename.endswith(".ftl"):
                                        filename = filename[:-4]

                                    if fSym.getOutputName() == filename:
                                        fSym.setEnabled(False)
                                        print("COMMON:  update [COMMON]%s(%s)"%(
                                            fSym.getOutputName(),fSym.getEnabled()))
                        else:
                            print("No COMMON files found to disable for driver: ", driver)
                        
                else:
                    print("driver NOT supported: ", driver)

    return