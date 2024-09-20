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

Crypto_Wc_Hash_Menu = None,
Crypto_Wc_Md5 = None,
Crypto_Wc_Ripemd160 = None,
Crypto_Wc_Sha1 = None,
Crypto_Wc_Sha2_Menu = None,
Crypto_Wc_Sha2_224 = None,
Crypto_Wc_Sha2_256 = None,
Crypto_Wc_Sha2_384 = None,
Crypto_Wc_Sha2_512 = None,
Crypto_Wc_Sha2_512_224 = None,
Crypto_Wc_Sha2_512_256 = None,
Crypto_Wc_Sha3_Menu = None,
Crypto_Wc_Sha3_224 = None,
Crypto_Wc_Sha3_256 = None,
Crypto_Wc_Sha3_384 = None,
Crypto_Wc_Sha3_512 = None,
Crypto_Wc_Shake_224 = None,
Crypto_Wc_Shake_256 = None,
Crypto_Wc_Blake2_Menu = None,
Crypto_Wc_Blake2s = None,
Crypto_Wc_Blake2b = None,
Crypto_Wc_Sym_Menu = None,
Crypto_Wc_Aes_Menu = None,
Crypto_Wc_Aes_Ecb = None,
Crypto_Wc_Aes_Cbc = None,
Crypto_Wc_Aes_Ctr = None,
Crypto_Wc_Aes_Ofb = None,
Crypto_Wc_Aes_Cfb_Menu = None,
Crypto_Wc_Aes_Cfb1 = None,
Crypto_Wc_Aes_Cfb8 = None,
Crypto_Wc_Aes_Cfb128 = None,
Crypto_Wc_Aes_Xts = None,
Crypto_Wc_Aes_Kw = None,
Crypto_Wc_Tdes_Menu = None,
Crypto_Wc_Tdes_Ecb = None,
Crypto_Wc_Tdes_Cbc = None,
Crypto_Wc_Camellia_Menu = None,
Crypto_Wc_Camellia_Ecb = None,
Crypto_Wc_Camellia_Cbc = None,
Crypto_Wc_Chacha20 = None,
Crypto_Wc_Mac_Menu = None,
Crypto_Wc_Aes_Cmac = None,
Crypto_Wc_Aes_Gmac = None,
Crypto_Wc_Aead_Menu = None,
Crypto_Wc_Aes_Gcm = None,
Crypto_Wc_Aes_Ccm = None,
Crypto_Wc_Aes_Eax = None,
Crypto_Wc_Digisign_Menu = None,
Crypto_Wc_Ecdsa = None,
Crypto_Wc_Kas_Menu = None,
Crypto_Wc_Ecdh = None,
Crypto_Wc_Rng_Menu = None,
Crypto_Wc_Trng = None,
Crypto_Wc_Prng = None,
#----------------------------------------------------------------------------------------- 
wolfcrypt_AllMenuList = [
    # Menu Label                        # Menu Symbol ID                # Menu Symbols                    # Menu Parent                  # Visible  # Default Value
    ["Hash Algorithms",                 "CRYPTO_WC_HASH_MENU",          "Crypto_Wc_Hash_Menu",             None,                          True,   None],
    ["MD-5",                            "CRYPTO_WC_MD5",                "Crypto_Wc_Md5",                   "Crypto_Wc_Hash_Menu",         True,   False],
    ["RIPEMD-160",                      "CRYPTO_WC_RIPEMD160",          "Crypto_Wc_Ripemd160",             "Crypto_Wc_Hash_Menu",         True,   False],
    ["SHA1",                            "CRYPTO_WC_SHA1",               "Crypto_Wc_Sha1",                  "Crypto_Wc_Hash_Menu",         True,   False],
    ["SHA2 Algorithm",                  "CRYPTO_WC_SHA2_MENU",          "Crypto_Wc_Sha2_Menu",             "Crypto_Wc_Hash_Menu",         True,   None],
    ["SHA2-224",                        "CRYPTO_WC_SHA2_224",           "Crypto_Wc_Sha2_224",              "Crypto_Wc_Sha2_Menu",         True,   False],
    ["SHA2-256",                        "CRYPTO_WC_SHA2_256",           "Crypto_Wc_Sha2_256",              "Crypto_Wc_Sha2_Menu",         True,   False],
    ["SHA2-384",                        "CRYPTO_WC_SHA2_384",           "Crypto_Wc_Sha2_384",              "Crypto_Wc_Sha2_Menu",         True,   False],
    ["SHA2-512",                        "CRYPTO_WC_SHA2_512",           "Crypto_Wc_Sha2_512",              "Crypto_Wc_Sha2_Menu",         True,   False],
    ["SHA2-512/224",                    "CRYPTO_WC_SHA2_512_224",       "Crypto_Wc_Sha2_512_224",          "Crypto_Wc_Sha2_Menu",         True,   False],
    ["SHA2-512/256",                    "CRYPTO_WC_SHA2_512_256",       "Crypto_Wc_Sha2_512_256",          "Crypto_Wc_Sha2_Menu",         True,   False],
    ["SHA3 Algorithm",                  "CRYPTO_WC_SHA3_MENU",          "Crypto_Wc_Sha3_Menu",             "Crypto_Wc_Hash_Menu",         True,   None],
    ["SHA3-224",                        "CRYPTO_WC_SHA3_224",           "Crypto_Wc_Sha3_224",              "Crypto_Wc_Sha3_Menu",         True,   False],
    ["SHA3-256",                        "CRYPTO_WC_SHA3_256",           "Crypto_Wc_Sha3_256",              "Crypto_Wc_Sha3_Menu",         True,   False],
    ["SHA3-384",                        "CRYPTO_WC_SHA3_384",           "Crypto_Wc_Sha3_384",              "Crypto_Wc_Sha3_Menu",         True,   False],
    ["SHA3-512",                        "CRYPTO_WC_SHA3_512",           "Crypto_Wc_Sha3_512",              "Crypto_Wc_Sha3_Menu",         True,   False],
    ["SHAKE-224",                       "CRYPTO_WC_SHAKE_224",          "Crypto_Wc_Shake_224",             "Crypto_Wc_Sha3_Menu",         True,   False],
    ["SHAKE-256",                       "CRYPTO_WC_SHAKE_256",          "Crypto_Wc_Shake_256",             "Crypto_Wc_Sha3_Menu",         True,   False],
    ["BLAKE2 Algorithm",                "CRYPTO_WC_BLAKE2_MENU",        "Crypto_Wc_Blake2_Menu",           "Crypto_Wc_Hash_Menu",         True,   None],
    ["BLAKE2s",                         "CRYPTO_WC_BLAKE2S",            "Crypto_Wc_Blake2s",               "Crypto_Wc_Blake2_Menu",       True,   False],
    ["BLAKE2b",                         "CRYPTO_WC_BLAKE2B",            "Crypto_Wc_Blake2b",               "Crypto_Wc_Blake2_Menu",       True,   False],
    ["Symmetric Algorithms",            "CRYPTO_WC_SYM_MENU",           "Crypto_Wc_Sym_Menu",              None,                          True,   None],
    ["AES Algorithm",                   "CRYPTO_WC_AES_MENU",           "Crypto_Wc_Aes_Menu",              "Crypto_Wc_Sym_Menu",          True,   None],
    ["AES-ECB",                         "CRYPTO_WC_AES_ECB",            "Crypto_Wc_Aes_Ecb",               "Crypto_Wc_Aes_Menu",          True,   False],
    ["AES-CBC",                         "CRYPTO_WC_AES_CBC",            "Crypto_Wc_Aes_Cbc",               "Crypto_Wc_Aes_Menu",          True,   False],
    ["AES-CTR",                         "CRYPTO_WC_AES_CTR",            "Crypto_Wc_Aes_Ctr",               "Crypto_Wc_Aes_Menu",          True,   False],
    ["AES-OFB",                         "CRYPTO_WC_AES_OFB",            "Crypto_Wc_Aes_Ofb",               "Crypto_Wc_Aes_Menu",          True,   False],
    ["AES-CFB",                         "CRYPTO_WC_AES_CFB_MENU",       "Crypto_Wc_Aes_Cfb_Menu",          "Crypto_Wc_Aes_Menu",          True,   None],
    ["AES-CFB1",                        "CRYPTO_WC_AES_CFB1",           "Crypto_Wc_Aes_Cfb1",              "Crypto_Wc_Aes_Cfb_Menu",      True,   False],
    ["AES-CFB8",                        "CRYPTO_WC_AES_CFB8",           "Crypto_Wc_Aes_Cfb8",              "Crypto_Wc_Aes_Cfb_Menu",      True,   False],
    ["AES-CFB128",                      "CRYPTO_WC_AES_CFB128",         "Crypto_Wc_Aes_Cfb128",            "Crypto_Wc_Aes_Cfb_Menu",      True,   False],
    ["AES-XTS",                         "CRYPTO_WC_AES_XTS",            "Crypto_Wc_Aes_Xts",               "Crypto_Wc_Aes_Menu",          True,   False],
    ["AES-KW",                          "CRYPTO_WC_AES_KW",             "Crypto_Wc_Aes_Kw",                "Crypto_Wc_Aes_Menu",          True,   False],
    ["TDES/3DES Algorithm",             "CRYPTO_WC_TDES_MENU",          "Crypto_Wc_Tdes_Menu",             "Crypto_Wc_Sym_Menu",          True,   None],
    ["TDES-ECB",                        "CRYPTO_WC_TDES_ECB",           "Crypto_Wc_Tdes_Ecb",              "Crypto_Wc_Tdes_Menu",         True,   False],
    ["TDES-CBC",                        "CRYPTO_WC_TDES_CBC",           "Crypto_Wc_Tdes_Cbc",              "Crypto_Wc_Tdes_Menu",         True,   False],
    ["Camellia Algorithm",              "CRYPTO_WC_CAMELLIA_MENU",      "Crypto_Wc_Camellia_Menu",         "Crypto_Wc_Sym_Menu",          True,   None],
    ["Camellia-ECB",                    "CRYPTO_WC_CAMELLIA_ECB",       "Crypto_Wc_Camellia_Ecb",          "Crypto_Wc_Camellia_Menu",     True,   False],
    ["Camellia-CBC",                    "CRYPTO_WC_CAMELLIA_CBC",       "Crypto_Wc_Camellia_Cbc",          "Crypto_Wc_Camellia_Menu",     True,   False],
    ["ChaCha20",                        "CRYPTO_WC_CHACHA20",           "Crypto_Wc_Chacha20",              "Crypto_Wc_Sym_Menu",          True,   False],
    ["MAC Algorithms",                  "CRYPTO_WC_MAC_MENU",           "Crypto_Wc_Mac_Menu",              None,                          True,   None],
    ["AES-CMAC",                        "CRYPTO_WC_AES_CMAC",           "Crypto_Wc_Aes_Cmac",              "Crypto_Wc_Mac_Menu",          True,   False],
    ["AES-GMAC",                        "CRYPTO_WC_AES_GMAC",           "Crypto_Wc_Aes_Gmac",              "Crypto_Wc_Mac_Menu",          True,   False],
    ["AEAD Algorithms",                 "CRYPTO_WC_AEAD_MENU",          "Crypto_Wc_Aead_Menu",             None,                          True,   None],
    ["AES-GCM",                         "CRYPTO_WC_AES_GCM",            "Crypto_Wc_Aes_Gcm",               "Crypto_Wc_Aead_Menu",         True,   False],
    ["AES-CCM",                         "CRYPTO_WC_AES_CCM",            "Crypto_Wc_Aes_Ccm",               "Crypto_Wc_Aead_Menu",         True,   False],
    ["AES-EAX",                         "CRYPTO_WC_AES_EAX",            "Crypto_Wc_Aes_Eax",               "Crypto_Wc_Aead_Menu",         True,   False],
    ["Digital Signature Algorithms",    "CRYPTO_WC_DIGISIGN_MENU",      "Crypto_Wc_Digisign_Menu",         None,                          True,   None],
    ["ECDSA",                           "CRYPTO_WC_ECDSA",              "Crypto_Wc_Ecdsa",                 "Crypto_Wc_Digisign_Menu",     True,   False],
    ["Key Agreement Algorithms(KAS)",   "CRYPTO_WC_KAS_MENU",           "Crypto_Wc_Kas_Menu",              None,                          True,   None],
    ["ECDH",                            "CRYPTO_WC_ECDH",               "Crypto_Wc_Ecdh",                  "Crypto_Wc_Kas_Menu",          True,   False],
    ["Random Number Algorithms(RNG)",   "CRYPTO_WC_RNG_MENU",           "Crypto_Wc_Rng_Menu",              None,                          True,   None],
    ["TRNG",                            "CRYPTO_WC_TRNG",               "Crypto_Wc_Trng",                  "Crypto_Wc_Rng_Menu",          True,   False],
    ["PRNG",                            "CRYPTO_WC_PRNG",               "Crypto_Wc_Prng",                  "Crypto_Wc_Rng_Menu",          True,   False],
]
#----------------------------------------------------------------------------------------- 
def func_wolfcryptSetUpAllMenu(WolfcryptComponent):
    for menu in wolfcrypt_AllMenuList:
        if(menu[5] == None):
            if(menu[3] == None):
               globals()[menu[2]] = WolfcryptComponent.createMenuSymbol(menu[1], None)
            else:
               globals()[menu[2]] = WolfcryptComponent.createMenuSymbol(menu[1], globals()[menu[3]])
        else:    
            globals()[menu[2]] = WolfcryptComponent.createBooleanSymbol(menu[1], globals()[menu[3]])
            globals()[menu[2]].setDefaultValue(menu[5])
                
        globals()[menu[2]].setLabel(menu[0])
        #menu[2].setDescription("Hash Algorithms Supported by Wolfcrypt:")
        globals()[menu[2]].setVisible(menu[4])   
#-----------------------------------------------------------------------------------------         
        