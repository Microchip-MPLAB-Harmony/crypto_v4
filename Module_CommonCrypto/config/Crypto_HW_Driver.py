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

global func_Crypto_HW_CreateDriverSymbols

#---------------------------------------------------------------------------------------
Crypto_HW_AllDriversList = [
        #AES_6149
        ["AES", "6149", "ZN", "AES_6149", "HAVE_CRYPTO_HW_AES_6149_DRIVER_ID", "Crypto_Hw_Aes_6149_DriverSymbol", "AES_6149 Driver Supported",],   #AES_6149
        ["SHA", "6156", "S", "SHA_6156",  "HAVE_CRYPTO_HW_SHA_6156_DRIVER_ID", "Crypto_Hw_SHA_6156_DriverSymbol", "SHA_6156 Driver Supported"],    #SHA_6156
        ["TRNG", "6334", "S", "TRNG_6334", "HAVE_CRYPTO_HW_TRNG_6334_DRIVER_ID", "Crypto_Hw_TRNG_6334_DriverSymbol", "TRNG_6334 Driver Supported"],   #TRNG_6334
        ["CPKCC", "44163", "B", "CPKCC_44163", "HAVE_CRYPTO_HW_CPKCC_44163_DRIVER_ID", "Crypto_Hw_CPKCC_44163_DriverSymbol", "CPKCC_44163 Driver Supported"], #CPKCC_44163
        ["HSM", "03785", "", "HSM_03785", "HAVE_CRYPTO_HW_HSM_03785_DRIVER_ID", "Crypto_Hw_HSM_03785_DriverSymbol", "HSM_03785 Driver Supported"],    #HSM_03785
        ["ICM", "11105", "", "ICM_11105", "HAVE_CRYPTO_HW_ICM_11105_DRIVER_ID", "Crypto_Hw_ICM_11105_DriverSymbol", "ICM_11105 Driver Supported"],    #ICM_11105
        ["TDES", "6150", "", "TDES_6150", "HAVE_CRYPTO_HW_TDES_6150_DRIVER_ID", "Crypto_Hw_TDES_6150_DriverSymbol", "TDES_6150 Driver Supported"]     #TDES_6150
]

#---------------------------------------------------------------------------------------        
Crypto_HW_CommonCryptoFilesDict = {
    "HashAlgo":["MCHP_Crypto_Hash.h", "MCHP_Crypto_Hash.c", "MCHP_Crypto_Hash_Config.h", "MCHP_Crypto_Common.h", "crypto_config.h"],
    "SymAlgo":["MCHP_Crypto_Sym_Cipher.h", "MCHP_Crypto_Sym_Cipher.c", "MCHP_Crypto_Sym_Config.h", "MCHP_Crypto_Common.h", "crypto_config.h"],
    "MacAlgo":[],
    "AeadAlgo":["MCHP_Crypto_Aead_Cipher.h", "MCHP_Crypto_Aead_Cipher.c", "MCHP_Crypto_Aead_Config.h", "MCHP_Crypto_Common.h", "crypto_config.h"],
    "DigisignAlgo":["MCHP_Crypto_DigSign.h", "MCHP_Crypto_DigSign.c", "MCHP_Crypto_DigSign_Config.h", "MCHP_Crypto_Common.h", "crypto_config.h"],
    "KasAlgo":["MCHP_Crypto_Kas.h", "MCHP_Crypto_Kas.c", "MCHP_Crypto_Kas_Config.h", "MCHP_Crypto_Common.h", "crypto_config.h"],
    "RngAlgo":[]
}

#---------------------------------------------------------------------------------------
Crypto_HW_DriverAndWrapperFilesDict = {
    "HSM_03785":{ 
        "HashAlgo":{
            "WrapperFiles": ["Crypto_Hash_Hsm_HwWrapper.h", "Crypto_Hash_Hsm_HwWrapper.c"],
            "DriverFiles":["hsm_hash.h", "hsm_hash.c", "hsm_common.h", "hsm_cmd.h", "hsm_cmd.c", "hsm_boot.h", "hsm_boot.c"],
        },
        "SymAlgo":{
            "WrapperFiles":["Crypto_Sym_Hsm_HwWrapper.h", "Crypto_Sym_Hsm_HwWrapper.c", "Crypto_Hsm_Common_HwWrapper.h", "Crypto_Hsm_Common_HwWrapper.c"],    
            "DriverFiles":["hsm_sym.h", "hsm_sym.c", "hsm_common.h", "hsm_cmd.h", "hsm_cmd.c", "hsm_boot.h", "hsm_boot.c"]
        }
    },
    "AES_6149":{ 
        "SymAlgo":{
            "WrapperFiles": ["Crypto_Sym_Aes6149_HwWrapper.h", "Crypto_Sym_Aes6149_HwWrapper.c.ftl"],
            "DriverFiles":["drv_crypto_aes_hw_6149.h.ftl","drv_crypto_aes_hw_6149.c.ftl"],
        },
        "AeadAlgo":{
            "WrapperFiles":["Crypto_Aead_Aes6149_HwWrapper.h", "Crypto_Aead_Aes6149_HwWrapper.c.ftl"],    
            "DriverFiles":["drv_crypto_aes_hw_6149.h.ftl","drv_crypto_aes_hw_6149.c.ftl"]
        }
    }
} 
   
#---------------------------------------------------------------------------------------
def func_Crypto_HW_GetSupportedDriverList(CommonCryptoComponent):
    print("scanning atdf file")
    periphNode = ATDF.getNode("/avr-tools-device-file/devices/device/peripherals")
    atdf_Modules = periphNode.getChildren()
    print("list of supported drivers")
    for module in atdf_Modules:
        for driver in Crypto_HW_AllDriversList:
            if ((module.getAttribute("name") == driver[0]) 
                and (module.getAttribute("id") == driver[1]) 
                and ((module.getAttribute("version") == driver[2]) or driver[2] == "")):
                Crypto_HW_AllSupportedDriver.append(driver)
                print(driver[3])
    func_Crypto_HW_CreateDriverSymbols(CommonCryptoComponent)            
#--------------------------------------------------------------------------------------- 
def func_Crypto_HW_CreateDriverSymbols(CommonCryptoComponent):
    for hwDriver in Crypto_HW_AllSupportedDriver:
        globals()[hwDriver[5]] = CommonCryptoComponent.createMenuSymbol(hwDriver[4], None)
        globals()[hwDriver[5]].setLabel(hwDriver[3])
        globals()[hwDriver[5]].setDescription(hwDriver[6])
        globals()[hwDriver[5]].setVisible(False)
        #globals()[driver[5]].setHelp('MC_CRYPTO_API_H')
#---------------------------------------------------------------------------------------    
            
        
    