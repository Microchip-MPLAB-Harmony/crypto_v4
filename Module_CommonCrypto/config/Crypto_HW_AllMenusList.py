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
Crypto_Hw_Hash_Menu = None
Crypto_Hw_Sha1 = None 
Crypto_Hw_Sha2_Menu = None
Crypto_Hw_Sha2_224 = None
Crypto_Hw_Sha2_256 = None
Crypto_Hw_Sha2_384 = None
Crypto_Hw_Sha2_512 = None
Crypto_Hw_Sha2_512_224 = None
Crypto_Hw_Sha2_512_256 = None
Crypto_Hw_Sym_Menu = None
Crypto_Hw_Aes_Menu = None
Crypto_Hw_Aes_Ecb = None
Crypto_Hw_Aes_Cbc = None
Crypto_Hw_Aes_Ctr = None
Crypto_Hw_Aes_Ofb = None
Crypto_Hw_Aes_Cfb_Menu = None
Crypto_Hw_Aes_Cfb8 = None
Crypto_Hw_Aes_Cfb16 = None
Crypto_Hw_Aes_Cfb32 = None
Crypto_Hw_Aes_Cfb64 = None
Crypto_Hw_Aes_Cfb128 = None
Crypto_Hw_Tdes_Menu = None
Crypto_Hw_Tdes_Ecb = None
Crypto_Hw_Tdes_Cbc = None
Crypto_Hw_Aead_Menu = None
Crypto_Hw_Aes_Gcm = None
Crypto_Hw_DigiSign_Menu = None
Crypto_Hw_Ecdsa = None
Crypto_Hw_Kas_Menu = None
Crypto_Hw_Ecdh = None
Crypto_Hw_Rng_Menu = None
Crypto_Hw_Rng_Trng = None

Crypto_HW_AllMenusList = [    
    #Menu Label[0]                    #Menu Symbol ID [1]          #Menu Symbols [2]           #Parent Symbol [3]         #Parent Label [4]              #Visible  #Default  #Category
    ["Hash Algorithms",               "CRYPTO_HW_HASH_MENU",       "Crypto_Hw_Hash_Menu",      None,                      None,                            True,    None,     None,],
    ["SHA1",                          "CRYPTO_HW_SHA1",            "Crypto_Hw_Sha1",           "Crypto_Hw_Hash_Menu",     "Hash Algorithms",               True,    False,    "HashAlgo", 
        ["SHA_6156", "HSM_03785"]],
    ["SHA2 Algorithm",                "CRYPTO_HW_SHA2_MENU",       "Crypto_Hw_Sha2_Menu",      "Crypto_Hw_Hash_Menu",     "Hash Algorithms",               True,    None,     None],
    ["SHA2-224",                      "CRYPTO_HW_SHA2_224",        "Crypto_Hw_Sha2_224",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",
        ["SHA_6156", "HSM_03785"]],
    ["SHA2-256",                      "CRYPTO_HW_SHA2_256",        "Crypto_Hw_Sha2_256",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",
        ["SHA_6156", "HSM_03785"]],
    ["SHA2-384",                      "CRYPTO_HW_SHA2_384",        "Crypto_Hw_Sha2_384",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",
        ["SHA_6156", "HSM_03785"]],
    ["SHA2-512",                      "CRYPTO_HW_SHA2_512",        "Crypto_Hw_Sha2_512",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",
        ["SHA_6156", "HSM_03785"]],
    ["SHA2-512/224",                  "CRYPTO_HW_SHA2_512_224",    "Crypto_Hw_Sha2_512_224",   "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",
        ["SHA_6156"]],
    ["SHA2-512/256",                  "CRYPTO_HW_SHA2_512_256",    "Crypto_Hw_Sha2_512_256",   "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",
        ["SHA_6156"]],
    ["Symmetric Algorithms",          "CRYPTO_HW_SYM_MENU",        "Crypto_Hw_Sym_Menu",       None,                      None,                            True,    None,     None],
    ["AES Algorithm",                 "CRYPTO_HW_AES_MENU",        "Crypto_Hw_Aes_Menu",       "Crypto_Hw_Sym_Menu",      "Symmetric Algorithms",          True,    None,     None],
    ["AES-ECB",                       "CRYPTO_HW_AES_ECB",         "Crypto_Hw_Aes_Ecb",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",
        ["AES_6149", "HSM_03785"]],
    ["AES-CBC",                       "CRYPTO_HW_AES_CBC",         "Crypto_Hw_Aes_Cbc",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",
        ["AES_6149", "HSM_03785"]],
    ["AES-CTR",                       "CRYPTO_HW_AES_CTR",         "Crypto_Hw_Aes_Ctr",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",
        ["AES_6149", "HSM_03785"]],
    ["AES-OFB",                       "CRYPTO_HW_AES_OFB",         "Crypto_Hw_Aes_Ofb",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",
        ["AES_6149"]],
    ["AES-CFB",                       "CRYPTO_HW_AES_CFB_MENU",    "Crypto_Hw_Aes_Cfb_Menu",   "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    None,     None],
    ["AES-CFB8",                      "CRYPTO_HW_AES_CFB8",        "Crypto_Hw_Aes_Cfb8",       "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",
        ["AES_6149"]],
    ["AES-CFB16",                     "CRYPTO_HW_AES_CFB16",       "Crypto_Hw_Aes_Cfb16",      "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",
        ["AES_6149"]],
    ["AES-CFB32",                     "CRYPTO_HW_AES_CFB32",       "Crypto_Hw_Aes_Cfb32",      "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",
        ["AES_6149"]],
    ["AES-CFB64",                     "CRYPTO_HW_AES_CFB64",       "Crypto_Hw_Aes_Cfb64",      "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",
        ["AES_6149"]],
    ["AES-CFB128",                    "CRYPTO_HW_AES_CFB128",      "Crypto_Hw_Aes_Cfb128",     "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",
        ["AES_6149"]],
    ["TDES/3DES Algorithm",           "CRYPTO_HW_TDES_MENU",       "Crypto_Hw_Tdes_Menu",      "Crypto_Hw_Sym_Menu",      "Symmetric Algorithms",          True,    None,     None],
    ["TDES-ECB",                      "CRYPTO_HW_TDES_ECB",        "Crypto_Hw_Tdes_Ecb",       "Crypto_Hw_Tdes_Menu",     "TDES/3DES Algorithm",           True,    False,    "SymAlgo",
        ["TDES_6150"]],
    ["TDES-CBC",                      "CRYPTO_HW_TDES_CBC",        "Crypto_Hw_Tdes_Cbc",       "Crypto_Hw_Tdes_Menu",     "TDES/3DES Algorithm",           True,    False,    "SymAlgo",
        ["TDES_6150"]],
    ["AEAD Algorithms",               "CRYPTO_HW_AEAD_MENU",       "Crypto_Hw_Aead_Menu",      None,                      None,                            True,    None,     None],
    ["AES-GCM",                       "CRYPTO_HW_AES_GCM",         "Crypto_Hw_Aes_Gcm",        "Crypto_Hw_Aead_Menu",     "AEAD Algorithms",               True,    False,    "AeadAlgo",
        ["AES_6149", "HSM_03785"]],
    ["Digital Signature Algorithms",  "CRYPTO_HW_DIGISIGN_MENU",   "Crypto_Hw_DigiSign_Menu",  None,                      None,                            True,    None,     None],
    ["ECDSA",                         "CRYPTO_HW_ECDSA",           "Crypto_Hw_Ecdsa",          "Crypto_Hw_DigiSign_Menu", "Digital Signature Algorithms",  True,    False,    "DigisignAlgo",
        ["CPKCC_44163", "HSM_03785"]],
    ["Key Agreement Algorithms(KAS)", "CRYPTO_HW_KAS_MENU",        "Crypto_Hw_Kas_Menu",       None,                      None,                            True,    None,     None],
    ["ECDH",                          "CRYPTO_HW_ECDH",            "Crypto_Hw_Ecdh",           "Crypto_Hw_Kas_Menu",      "Key Agreement Algorithms(KAS)", True,    False,    "KasAlgo",
        ["CPKCC_44163", "HSM_03785"]],
    ["Random Number Algortihms(RNG)", "CRYPTO_HW_RNG_MENU",        "Crypto_Hw_Rng_Menu",       None,                      None,                            True,    None,     None],
    ["TRNG",                          "CRYPTO_HW_RNG_TRNG",        "Crypto_Hw_Rng_Trng",       "Crypto_Hw_Rng_Menu",      "Random Number Algortihms(RNG)", True,    False,    "RngAlgo",
        ["TRNG_6334"]],
]

Crypto_Hw_UserSelectedCategoryList = []
Crypto_Hw_CommonCryptoFilesList = []
Crypto_Hw_DriverFilesList = []
Crypto_Hw_WrapperFilesList = []

def func_Crypto_CallBack(symbol, event):
    commcryptoFilesList = []
    WrapperDriverFilesList = []
    DriverFileList = []
    UserSelectedcategoryList = []
                    
    for menu in Crypto_Hw_orderAlgoMenuList:
        if menu[7] is not None: #if category is not None in menu List of the menu
            if(globals()[menu[2]].getValue() == True): #check menu is selected ny user ot no
                if menu[7] not in UserSelectedcategoryList:
                    UserSelectedcategoryList.append(menu[7])

    for category in UserSelectedcategoryList:
        for CommonCryptoFile in Crypto_HW_CommonCryptoFilesDict[category]:
            if CommonCryptoFile not in commcryptoFilesList:
                commcryptoFilesList.append(CommonCryptoFile)
        for driver in Crypto_HW_AllSupportedDriver:
             if driver[3] in Crypto_HW_DriverAndWrapperFilesDict:
                if category in Crypto_HW_DriverAndWrapperFilesDict[driver[3]]:
                    for file in Crypto_HW_DriverAndWrapperFilesDict[driver[3]][category].get("WrapperFiles", []):
                        if file not in WrapperDriverFilesList:
                            WrapperDriverFilesList.append(file)
                    for file in Crypto_HW_DriverAndWrapperFilesDict[driver[3]][category].get("DriverFiles", []):
                        if file not in DriverFileList:
                            DriverFileList.append(file)  
    
    Crypto_Hw_UserSelectedCategoryList = UserSelectedcategoryList    
    Crypto_Hw_CommonCryptoFilesList = commcryptoFilesList                  
    Crypto_Hw_DriverFilesList = DriverFileList 
    Crypto_Hw_WrapperFilesList = WrapperDriverFilesList

    
    