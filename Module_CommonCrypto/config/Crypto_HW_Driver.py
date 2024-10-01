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

Crypto_HW_AllSupportedDriver = []

Crypto_Hw_Aes_6149_DriverSymbol = None
Crypto_Hw_SHA_6156_DriverSymbol = None
Crypto_Hw_TRNG_6334_DriverSymbol = None
Crypto_Hw_CPKCC_44163_DriverSymbol = None
Crypto_Hw_HSM_03785_DriverSymbol = None
Crypto_Hw_ICM_11105_DriverSymbol = None
Crypto_Hw_TDES_6150_DriverSymbol = None

#---------------------------------------------------------------------------------------
Crypto_HW_AllDriversList = [
        #AES_6149
        ["AES", "6149", "ZN", "AES_6149", "HAVE_CRYPTO_HW_AES_6149_DRIVER", "Crypto_Hw_Aes_6149_DriverSymbol", "AES_6149 Driver Supported"],   #AES_6149
        ["SHA", "6156", "S", "SHA_6156",  "HAVE_CRYPTO_HW_SHA_6156_DRIVER", "Crypto_Hw_SHA_6156_DriverSymbol", "SHA_6156 Driver Supported"],    #SHA_6156
        ["TRNG", "6334", "S", "TRNG_6334", "HAVE_CRYPTO_HW_TRNG_6334_DRIVER", "Crypto_Hw_TRNG_6334_DriverSymbol", "TRNG_6334 Driver Supported"],   #TRNG_6334
        ["CPKCC", "44163", "B", "CPKCC_44163", "HAVE_CRYPTO_HW_CPKCC_44163_DRIVER", "Crypto_Hw_CPKCC_44163_DriverSymbol", "CPKCC_44163 Driver Supported"], #CPKCC_44163
        ["HSM", "03785", "", "HSM_03785", "HAVE_CRYPTO_HW_HSM_03785_DRIVER", "Crypto_Hw_HSM_03785_DriverSymbol", "HSM_03785 Driver Supported"],    #HSM_03785
        ["ICM", "11105", "", "ICM_11105", "HAVE_CRYPTO_HW_ICM_11105_DRIVER", "Crypto_Hw_ICM_11105_DriverSymbol", "ICM_11105 Driver Supported"],    #ICM_11105
        ["TDES", "6150", "", "TDES_6150", "HAVE_CRYPTO_HW_TDES_6150_DRIVER", "Crypto_Hw_TDES_6150_DriverSymbol", "TDES_6150 Driver Supported"]     #TDES_6150
]

#---------------------------------------------------------------------------------------        
Crypto_HW_CommonCryptoFilesDict = {
    "HashAlgo": [
        "MCHP_Crypto_Hash.h",
        "MCHP_Crypto_Hash.c.ftl",
        "MCHP_Crypto_Hash_Config.h.ftl",
        "MCHP_Crypto_Common.h",
        "crypto_config.h.ftl"
    ],
    "SymAlgo": [
        "MCHP_Crypto_Sym_Cipher.h",
        "MCHP_Crypto_Sym_Cipher.c.ftl",
        "MCHP_Crypto_Sym_Config.h.ftl",
        "MCHP_Crypto_Common.h",
        "crypto_config.h.ftl"
    ],
    "MacAlgo": [],
    "AeadAlgo": [
        "MCHP_Crypto_Aead_Cipher.h",
        "MCHP_Crypto_Aead_Cipher.c.ftl",
        "MCHP_Crypto_Aead_Config.h.ftl",
        "MCHP_Crypto_Common.h",
        "crypto_config.h.ftl"
    ],
    "DigisignAlgo": [
        "MCHP_Crypto_DigSign.h",
        "MCHP_Crypto_DigSign.c.ftl",
        "MCHP_Crypto_DigSign_Config.h.ftl",
        "MCHP_Crypto_Common.h",
        "crypto_config.h.ftl"
    ],
    "KasAlgo": [
        "MCHP_Crypto_Kas.h",
        "MCHP_Crypto_Kas.c.ftl",
        "MCHP_Crypto_Kas_Config.h.ftl",
        "MCHP_Crypto_Common.h",
        "crypto_config.h.ftl"
    ],
    "RngAlgo": [
        "MCHP_Crypto_Rng.h",
        "MCHP_Crypto_Rng.c",
        "MCHP_Crypto_Rng_Config.h.ftl",
        "MCHP_Crypto_Common.h",
        "crypto_config.h.ftl"
    ]
}

#---------------------------------------------------------------------------------------
Crypto_HW_DriverAndWrapperFilesDict = {
    "HSM_03785":{ 
        "HashAlgo":{
            "WrapperFiles": ["MCHP_Crypto_Hash_Hsm_HwWrapper.h", "MCHP_Crypto_Hash_Hsm_HwWrapper.c"],
            "DriverFiles":["hsm_hash.h", "hsm_hash.c", "hsm_common.h", "hsm_cmd.h", "hsm_cmd.c", "hsm_boot.h", "hsm_boot.c"],
        },
        "SymAlgo":{
            "WrapperFiles":["MCHP_Crypto_Sym_Hsm_HwWrapper.h", "MCHP_Crypto_Sym_Hsm_HwWrapper.c", "MCHP_Crypto_Hsm_Common_HwWrapper.h", "MCHP_Crypto_Hsm_Common_HwWrapper.c"],    
            "DriverFiles":["hsm_sym.h", "hsm_sym.c", "hsm_common.h", "hsm_cmd.h", "hsm_cmd.c", "hsm_boot.h", "hsm_boot.c"]
        }
    },
    "AES_6149":{ 
        "SymAlgo":{
            "WrapperFiles": ["MCHP_Crypto_Sym_Aes6149_HwWrapper.h", "MCHP_Crypto_Sym_Aes6149_HwWrapper.c.ftl"],
            "DriverFiles":["drv_crypto_aes_hw_6149.h.ftl","drv_crypto_aes_hw_6149.c.ftl"],
        },
        "AeadAlgo":{
            "WrapperFiles":["MCHP_Crypto_Aead_HwWrapper.h", "MCHP_Crypto_Aead_HwWrapper.c.ftl"],    
            "DriverFiles":["drv_crypto_aes_hw_6149.h.ftl","drv_crypto_aes_hw_6149.c.ftl"]
        }
    }
}
   
#---------------------------------------------------------------------------------------
def Crypto_HW_GetSupportedDriverList(CommonCryptoComponent):
    print("scanning atdf file")
    periphNode = ATDF.getNode("/avr-tools-device-file/devices/device/peripherals")
    atdf_Modules = periphNode.getChildren()
    print("list of supported drivers")

    # Initialize a set to hold the supported driver labels
    supported_drivers = set()

    for module in atdf_Modules:
        for driver in Crypto_HW_AllDriversList:
            if ((module.getAttribute("name") == driver[0]) 
                and (module.getAttribute("id") == driver[1]) 
                and ((module.getAttribute("version") == driver[2]) or driver[2] == "")):
                Crypto_HW_AllSupportedDriver.append(driver)
                
                # Add the driver's label to the supported drivers set
                supported_drivers.add(driver[3])
                print(driver[3])

    Crypto_HW_CreateDriverSymbols(CommonCryptoComponent)

    return supported_drivers

#--------------------------------------------------------------------------------------- 
def Crypto_HW_CreateDriverSymbols(CommonCryptoComponent):

    #String Implementation of defines for crypto_config.h.ftl
    driver_defines = CommonCryptoComponent.createStringSymbol("driver_defines", None)
    driver_defines.setVisible(False)

    for hwDriver in Crypto_HW_AllSupportedDriver:
        globals()[hwDriver[5]] = CommonCryptoComponent.createMenuSymbol(hwDriver[4], None)
        globals()[hwDriver[5]].setLabel(hwDriver[3])
        globals()[hwDriver[5]].setDescription(hwDriver[6])
        globals()[hwDriver[5]].setVisible(False)
        #globals()[driver[5]].setHelp('MC_CRYPTO_API_H')
    
    #String Implementation of defines for crypto_config.h.ftl
    #--created from each of the additional define strings
    # Accumulate all hwDriver[4] items into a string to set as default
    driver_define_strings = [hwDriver[4] for hwDriver in Crypto_HW_AllSupportedDriver]
    driver_defines.setDefaultValue(", ".join(driver_define_strings))
        
#---------------------------------------------------------------------------------------    