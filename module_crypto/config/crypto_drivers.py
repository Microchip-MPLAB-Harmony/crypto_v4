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

Crypto_HW_AllSupportedDriver = []

#---------------------------------------------------------------------------------------

Crypto_Hw_Aes_6149_DriverSymbol = None
Crypto_Hw_SHA_6156_DriverSymbol = None
Crypto_Hw_TRNG_6334_DriverSymbol = None
Crypto_Hw_CPKCC_44163_DriverSymbol = None
Crypto_Hw_HSM_03785_DriverSymbol = None
Crypto_Hw_ICM_11105_DriverSymbol = None
Crypto_Hw_TDES_6150_DriverSymbol = None

Crypto_HW_AllDriversList = [
        #AES_6149
        ["AES", "6149", "", "AES_6149", "HAVE_CRYPTO_HW_AES_6149_DRIVER", "Crypto_Hw_Aes_6149_DriverSymbol", "AES_6149 Driver Supported"],   #AES_6149
        ["SHA", "6156", "", "SHA_6156",  "HAVE_CRYPTO_HW_SHA_6156_DRIVER", "Crypto_Hw_SHA_6156_DriverSymbol", "SHA_6156 Driver Supported"],    #SHA_6156
        ["TRNG", "6334", "", "TRNG_6334", "HAVE_CRYPTO_HW_TRNG_6334_DRIVER", "Crypto_Hw_TRNG_6334_DriverSymbol", "TRNG_6334 Driver Supported"],   #TRNG_6334
        ["CPKCC", "44163", "", "CPKCC_44163", "HAVE_CRYPTO_HW_CPKCC_44163_DRIVER", "Crypto_Hw_CPKCC_44163_DriverSymbol", "CPKCC_44163 Driver Supported"], #CPKCC_44163
        ["HSM", "03785", "", "HSM_03785", "HAVE_CRYPTO_HW_HSM_03785_DRIVER", "Crypto_Hw_HSM_03785_DriverSymbol", "HSM_03785 Driver Supported"],    #HSM_03785
        ["ICM", "11105", "", "ICM_11105", "HAVE_CRYPTO_HW_ICM_11105_DRIVER", "Crypto_Hw_ICM_11105_DriverSymbol", "ICM_11105 Driver Supported"],    #ICM_11105
        ["TDES", "6150", "", "TDES_6150", "HAVE_CRYPTO_HW_TDES_6150_DRIVER", "Crypto_Hw_TDES_6150_DriverSymbol", "TDES_6150 Driver Supported"],     #TDES_6150
        ["TRNG", "03597", "", "TRNG_03597", "HAVE_CRYPTO_HW_TRNG_03597_DRIVER", "Crypto_Hw_TRNG_03597_DriverSymbol", "TRNG_03597 Driver Supported"],    #TRNG_03597
]

#---------------------------------------------------------------------------------------        
Crypto_HW_CommonCryptoFilesDict = {
    "HashAlgo": [
        "crypto_hash.h.ftl",
        "crypto_hash.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ],
    "SymAlgo": [
        "crypto_sym_cipher.h.ftl",
        "crypto_sym_cipher.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ],
    "MacAlgo": [
        "crypto_mac_cipher.h.ftl",
        "crypto_mac_cipher.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ],
    "AeadAlgo": [
        "crypto_aead_cipher.h.ftl",
        "crypto_aead_cipher.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ],
    "DigisignAlgo": [
        "crypto_digsign.h.ftl",
        "crypto_digsign.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ],
    "KasAlgo": [
        "crypto_kas.h.ftl",
        "crypto_kas.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ],
    "RngAlgo": [
        "crypto_rng.h.ftl",
        "crypto_rng.c.ftl",
        "crypto_common.h.ftl",
        "crypto_config.h.ftl"
    ]
}

#---------------------------------------------------------------------------------------
Crypto_HW_DriverAndWrapperFilesDict = {
    "HSM_03785": {
        "HashAlgo": {
            "WrapperFiles": [
                "crypto_hash_hsm03785_wrapper.h.ftl", "crypto_hash_hsm03785_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "hsm_hash.h", "hsm_hash.c", 
                "hsm_common.h", 
                "hsm_cmd.h", "hsm_cmd.c", 
                "hsm_boot.h.ftl", "hsm_boot.c"
            ],
        },
        "SymAlgo": {
            "WrapperFiles": [
                "crypto_sym_hsm03785_wrapper.h.ftl", "crypto_sym_hsm03785_wrapper.c.ftl", 
                "crypto_hsm03785_common_wrapper.h.ftl", "crypto_hsm03785_common_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "hsm_sym.h", "hsm_sym.c",
                "hsm_common.h",
                "hsm_cmd.h", "hsm_cmd.c",
                "hsm_boot.h.ftl", "hsm_boot.c"
            ],
        },
        "AeadAlgo": {
            "WrapperFiles": [
                "crypto_aead_hsm03785_wrapper.h.ftl", "crypto_aead_hsm03785_wrapper.c.ftl", 
                "crypto_hsm03785_common_wrapper.h.ftl", "crypto_hsm03785_common_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "hsm_aead.h", "hsm_aead.c",
                "hsm_common.h", 
                "hsm_cmd.h", "hsm_cmd.c",
                "hsm_boot.h.ftl", "hsm_boot.c"
            ],
        },
        "DigisignAlgo": {
            "WrapperFiles": [
                "crypto_digisign_hsm03785_wrapper.h.ftl", "crypto_digisign_hsm03785_wrapper.c.ftl", 
                "crypto_hsm03785_common_wrapper.h.ftl", "crypto_hsm03785_common_wrapper.c.ftl", 
                "crypto_hash_hsm03785_wrapper.h.ftl", "crypto_hash_hsm03785_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "hsm_sign.h", "hsm_sign.c",
                "hsm_common.h", "hsm_common.c",
                "hsm_cmd.h", "hsm_cmd.c", 
                "hsm_boot.h.ftl", "hsm_boot.c",
                "hsm_hash.h", "hsm_hash.c"
            ],
        },
        "KasAlgo": {
            "WrapperFiles": [
                "crypto_kas_hsm03785_wrapper.h.ftl", "crypto_kas_hsm03785_wrapper.c.ftl", 
                "crypto_hsm03785_common_wrapper.h.ftl", "crypto_hsm03785_common_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "hsm_kas.h", "hsm_kas.c",
                "hsm_common.h", "hsm_common.c",
                "hsm_cmd.h", "hsm_cmd.c", 
                "hsm_boot.h.ftl", "hsm_boot.c",
                "hsm_hash.h", "hsm_hash.c"
            ],
        },
    },

    "AES_6149": {
        "SymAlgo": {
            "WrapperFiles": [
                "crypto_sym_aes6149_wrapper.h.ftl", "crypto_sym_aes6149_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_aes_hw_6149.h.ftl", "drv_crypto_aes_hw_6149.c.ftl"
            ],
        },
        "AeadAlgo": {
            "WrapperFiles": [
                "crypto_aead_aes6149_wrapper.h.ftl", "crypto_aead_aes6149_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_aes_hw_6149.h.ftl", "drv_crypto_aes_hw_6149.c.ftl"
            ],
        },
    },

    "CPKCC_44163": {
        "DigisignAlgo": {
            "WrapperFiles": [
                "crypto_digisign_cpkcc44163_wrapper.h.ftl", "crypto_digisign_cpkcc44163_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_ecdsa_hw_cpkcl.h", "drv_crypto_ecdsa_hw_cpkcl.c.ftl", 
                "drv_crypto_ecc_hw_cpkcl.h", "drv_crypto_ecc_hw_cpkcl.c.ftl"
            ],
            "LibraryFiles": ["CPKCL_Lib"]
        },
        "KasAlgo": {
            "WrapperFiles": [
                "crypto_kas_cpkcc44163_wrapper.h.ftl", "crypto_kas_cpkcc44163_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_ecdh_hw_cpkcl.h", "drv_crypto_ecdh_hw_cpkcl.c.ftl", 
                "drv_crypto_ecc_hw_cpkcl.h", "drv_crypto_ecc_hw_cpkcl.c.ftl"
            ],
            "LibraryFiles": ["CPKCL_Lib"]
        },
    },
    "SHA_6156": {
        "HashAlgo": {
            "WrapperFiles": [
                "crypto_hash_sha6156_wrapper.h.ftl", "crypto_hash_sha6156_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_sha_hw_6156.h.ftl", "drv_crypto_sha_hw_6156.c.ftl"
            ],
        },
    },

    "TRNG_6334": {
        "RngAlgo": {
            "WrapperFiles": [
                "crypto_rng_trng6334_wrapper.h.ftl", "crypto_rng_trng6334_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_trng_hw_6334.h", "drv_crypto_trng_hw_6334.c"
            ],
        },
    },

    "TRNG_03597": {
        "RngAlgo": {
            "WrapperFiles": [
                "crypto_rng_trng03597_wrapper.h.ftl", "crypto_rng_trng03597_wrapper.c.ftl"
            ],
            "DriverFiles": [
                "drv_crypto_trng_hw_03597.h", "drv_crypto_trng_hw_03597.c"
            ],
        },
    },
}
   
#---------------------------------------------------------------------------------------
def Crypto_HW_GetSupportedDriverList(CommonCryptoComponent):
    
    # Harmony installed DSP:    %USERPROFILE%\.mcc\HarmonyContent\dev_packs\Microchip
    # MPLABX installed DSP:     %USERPROFILE%\.mchp_packs\Microchip

    periphNode = ATDF.getNode("/avr-tools-device-file/devices/device/peripherals")
    atdf_Modules = periphNode.getChildren()
    print("List of supported drivers (.atdf): ")

    # Initialize a set to hold the supported driver labels
    supported_drivers = set()

    for module in atdf_Modules:
        for driver in Crypto_HW_AllDriversList:
            
            name = module.getAttribute("name")
            id = module.getAttribute("id")
            version = module.getAttribute("version")

            if ((name == driver[0]) 
                and (id == driver[1]) 
                and ((version == driver[2]) or driver[2] == "")):
                
                print("%s | %s | %s" % (name, id, version))
                Crypto_HW_AllSupportedDriver.append(driver)
                
                # Add the driver's label to the supported drivers set
                supported_drivers.add(driver[3])

    Crypto_HW_CreateDriverSymbols(CommonCryptoComponent)

    return supported_drivers

#--------------------------------------------------------------------------------------- 
def Crypto_HW_GetMemorySegments(CommonCryptoComponent, supported_drivers):
    ''' Pulls size of flash from ATDF to determine HSM firmware location
    
    Args:
        CommonCryptoComponent:  Harmony component
        supported_drivers:      set() of drivers supported by this board

    Returns:
        No direct return. String symbols created and used if hsm_boot.h.ftl
        is relevant to the project.
    '''

    # Return early if HSM is not used
    if "HSM_03785" not in supported_drivers:
        return
    
    # Check if TrustZone is enabled
    sec_enabled_node = ATDF.getNode('/avr-tools-device-file/devices/device/parameters/param@[name="__SEC_ENABLED"]')
    trustzone_enabled = False

    if sec_enabled_node is not None:
        trustzone_enabled = sec_enabled_node.getAttribute("value") == "1"

    # Maintain set of ways to refer to flash size in .atdf 
    pfm_names = set(['FCR_PFM', 'FLASH_PFM'])

    HSM_BOOT_FIRMWARE_INIT_ADDR = CommonCryptoComponent.createStringSymbol("HSM_BOOT_FIRMWARE_INIT_ADDR", None)
    HSM_BOOT_FIRMWARE_INIT_ADDR.setVisible(False)
    HSM_BOOT_FIRMWARE_ADDR = CommonCryptoComponent.createStringSymbol("HSM_BOOT_FIRMWARE_ADDR", None)
    HSM_BOOT_FIRMWARE_ADDR.setVisible(False)
    
    for pfm in pfm_names:
        flash_pfm_node = ATDF.getNode(
            '/avr-tools-device-file/devices/device/address-spaces/address-space/memory-segment@[name="{}"]'.format(pfm)
        )

        if flash_pfm_node is not None:
            found_node = True

            print("Node found           | %s" % (pfm))
            flash_start = int(flash_pfm_node.getAttribute("start"), 16)
            flash_end = int(flash_pfm_node.getAttribute("size"), 16)
            
            # HSM placed from midpoint of flash address space if TZ
            if trustzone_enabled:
                flash_end = flash_end // 2
            
            flash_size = flash_start + flash_end
            
            # Save to string obj
            HSM_BOOT_FIRMWARE_INIT_ADDR.setDefaultValue(hex(flash_size - 0x20800))  # 130kB
            HSM_BOOT_FIRMWARE_ADDR.setDefaultValue(hex(flash_size - 0x20000))       # 128kB
    
    if not found_node:
        HSM_BOOT_FIRMWARE_INIT_ADDR.setDefaultValue("/* Unable to automatically fill address */")
        HSM_BOOT_FIRMWARE_ADDR.setDefaultValue("/* Unable to automatically fill address */")
        
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

def dir_item_to_files(path):
    all_files = []

    if os.path.exists(path): 
        for root, dirs, files in os.walk(path):
            all_files.extend(files)
    else: 
        print("%s damaged. Check that this path exists." % path)
        return []
    
    return all_files

# Function to check if an entry is a directory (no extension)
def is_directory(item):
    return os.path.splitext(item)[1] == ''

def expand_dir_entries_in_driver_requests():
    module_path = Module.getPath()

    for driver, algorithms in Crypto_HW_DriverAndWrapperFilesDict.items():
        driver_path = os.path.join(module_path, "src", "drivers", driver)

        # Loop through algorithms and file types
        for algo, file_types in algorithms.items():
            for file_type, files in file_types.items():
                # Loop through files in the file type list
                for i, item in enumerate(files):
                    if is_directory(item):
                        # If it's a directory, replace it with the files inside it
                        for root, dirs, _ in os.walk(driver_path):
                            if item in dirs:
                                dir_path = os.path.join(root, item)
                                files_in_dir = dir_item_to_files(dir_path)
                                
                                files[i:i+1] = files_in_dir

    # Show the updated dict structure
    # for driver, algorithms in Crypto_HW_DriverAndWrapperFilesDict.items():
    #     print("Driver: %s" % driver)
    #     for algo, file_types in algorithms.items():
    #         for file_type, files in file_types.items():
    #             print("  %s: %s" % (file_type, files))
