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
Crypto_Hash_Menu_Wc = None
Crypto_Hash_Md5_Menu_Wc_bool = None
Crypto_Hash_Ripemd160_Menu_Wc_bool = None
Crypto_Hash_Sha1_Menu_Wc_bool = None
Crypto_Hash_Sha2_Menu_Wc = None
Crypto_Hash_Sha2_224_Menu_Wc_bool = None
Crypto_Hash_Sha2_256_Menu_Wc_bool = None
Crypto_Hash_Sha2_384_Menu_Wc_bool = None
Crypto_Hash_Sha2_512_Menu_Wc_bool = None
Crypto_Hash_Sha2_512_224_Menu_Wc_bool = None
Crypto_Hash_Sha2_512_256_Menu_Wc_bool = None
Crypto_Hash_Sha3_Menu_Wc = None
Crypto_Hash_Sha3_224_Menu_Wc_bool = None
Crypto_Hash_Sha3_256_Menu_Wc_bool = None
Crypto_Hash_Sha3_384_Menu_Wc_bool = None
Crypto_Hash_Sha3_512_Menu_Wc_bool = None
Crypto_Hash_Shake_224_Menu_Wc_bool = None
Crypto_Hash_Shake_256_Menu_Wc_bool = None
Crypto_Hash_Blake2_Menu_Wc = None
Crypto_Hash_Blake2s_Menu_Wc_bool = None
Crypto_Hash_Blake2b_Menu_Wc_bool = None

wolfcrypt_Hash_MenuList = [    
    #Menu Label             #Menu Symbol ID                             #Menu Symbols                               #Menu Parent                 #Visible  #Default Value
    ["Hash Algorithms",     "CRYPTO_HASH_MENU_WC",                      "Crypto_Hash_Menu_Wc",                      None,                           True,   None],
    ["MD-5",                "CRYPTO_HASH_MD5_MENU_WC_BOOL",             "Crypto_Hash_Md5_Menu_Wc_bool",             "Crypto_Hash_Menu_Wc",          True,   False],
    ["RIPEMD-160",          "CRYPTO_HASH_RIPEMD160_MENU_WC_BOOL",       "Crypto_Hash_Ripemd160_Menu_Wc_bool",       "Crypto_Hash_Menu_Wc",          True,   False],
    ["SHA1",                "CRYPTO_HASH_SHA1_MENU_WC_BOOL",            "Crypto_Hash_Sha1_Menu_Wc_bool",            "Crypto_Hash_Menu_Wc",          True,   False],
    ["SHA2 Algorithm",      "CRYPTO_HASH_SHA2_MENU_WC",                 "Crypto_Hash_Sha2_Menu_Wc",                 "Crypto_Hash_Menu_Wc",          True,   None],
    ["SHA2-224",            "CRYPTO_HASH_SHA2_224_MENU_WC_BOOL",        "Crypto_Hash_Sha2_224_Menu_Wc_bool",        "Crypto_Hash_Sha2_Menu_Wc",     True,   False],
    ["SHA2-256",            "CRYPTO_HASH_SHA2_256_MENU_WC_BOOL",        "Crypto_Hash_Sha2_256_Menu_Wc_bool",        "Crypto_Hash_Sha2_Menu_Wc",     True,   False],
    ["SHA2-384",            "CRYPTO_HASH_SHA2_384_MENU_WC_BOOL",        "Crypto_Hash_Sha2_384_Menu_Wc_bool",        "Crypto_Hash_Sha2_Menu_Wc",     True,   False],
    ["SHA2-512",            "CRYPTO_HASH_SHA2_512_MENU_WC_BOOL",        "Crypto_Hash_Sha2_512_Menu_Wc_bool",        "Crypto_Hash_Sha2_Menu_Wc",     True,   False],
    ["SHA2-512/224",        "CRYPTO_HASH_SHA2_512_224_MENU_WC_BOOL",    "Crypto_Hash_Sha2_512_224_Menu_Wc_bool",    "Crypto_Hash_Sha2_Menu_Wc",     True,   False],
    ["SHA2-512/256",        "CRYPTO_HASH_SHA2_512_256_MENU_WC_BOOL",    "Crypto_Hash_Sha2_512_256_Menu_Wc_bool",    "Crypto_Hash_Sha2_Menu_Wc",     True,   False],
    ["SHA3 Algorithm",      "CRYPTO_HASH_SHA3_MENU_WC",                 "Crypto_Hash_Sha3_Menu_Wc",                 "Crypto_Hash_Menu_Wc",          True,   None],
    ["SHA3-224",            "CRYPTO_HASH_SHA3_224_MENU_WC_BOOL",        "Crypto_Hash_Sha3_224_Menu_Wc_bool",        "Crypto_Hash_Sha3_Menu_Wc",     True,   False],
    ["SHA3-256",            "CRYPTO_HASH_SHA3_256_MENU_WC_BOOL",        "Crypto_Hash_Sha3_256_Menu_Wc_bool",        "Crypto_Hash_Sha3_Menu_Wc",     True,   False],
    ["SHA3-384",            "CRYPTO_HASH_SHA3_384_MENU_WC_BOOL",        "Crypto_Hash_Sha3_384_Menu_Wc_bool",        "Crypto_Hash_Sha3_Menu_Wc",     True,   False],
    ["SHA3-512",            "CRYPTO_HASH_SHA3_512_MENU_WC_BOOL",        "Crypto_Hash_Sha3_512_Menu_Wc_bool",        "Crypto_Hash_Sha3_Menu_Wc",     True,   False],
    ["SHAKE-224",           "CRYPTO_HASH_SHAKE_224_MENU_WC_BOOL",       "Crypto_Hash_Shake_224_Menu_Wc_bool",       "Crypto_Hash_Sha3_Menu_Wc",     True,   False],
    ["SHAKE-256",           "CRYPTO_HASH_SHAKE_256_MENU_WC_BOOL",       "Crypto_Hash_Shake_256_Menu_Wc_bool",       "Crypto_Hash_Sha3_Menu_Wc",     True,   False],
    ["BLAKE2 Algorithm",    "CRYPTO_HASH_BLAKE2_MENU_WC",               "Crypto_Hash_Blake2_Menu_Wc",               "Crypto_Hash_Menu_Wc",          True,   None],
    ["BLAKE2s",             "CRYPTO_HASH_BLAKE2S_MENU_WC_BOOL",         "Crypto_Hash_Blake2s_Menu_Wc_bool",         "Crypto_Hash_Blake2_Menu_Wc",   True,   False],
    ["BLAKE2b",             "CRYPTO_HASH_BLAKE2B_MENU_WC_BOOL",         "Crypto_Hash_Blake2b_Menu_Wc_bool",         "Crypto_Hash_Blake2_Menu_Wc",   True,   False],    
]
