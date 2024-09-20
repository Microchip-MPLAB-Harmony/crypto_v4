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
Crypto_Sym_Menu_Wc = None
Crypto_Sym_Aes_Menu_Wc = None
Crypto_Sym_Aes_Ecb_Menu_Wc_bool = None
Crypto_Sym_Aes_Cbc_Menu_Wc_bool = None
Crypto_Sym_Aes_Ctr_Menu_Wc_bool = None
Crypto_Sym_Aes_Ofb_Menu_Wc_bool = None
Crypto_Sym_Aes_Cfb_Menu_Wc = None
Crypto_Sym_Aes_Cfb1_Menu_Wc_bool = None
Crypto_Sym_Aes_Cfb8_Menu_Wc_bool = None
Crypto_Sym_Aes_Cfb128_Menu_Wc_bool = None
Crypto_Sym_Aes_Xts_Menu_Wc_bool = None
Crypto_Sym_Aes_Kw_Menu_Wc_bool = None
Crypto_Sym_Tdes_Menu_Wc = None
Crypto_Sym_Tdes_Ecb_Menu_Wc_bool = None
Crypto_Sym_Tdes_Cbc_Menu_Wc_bool = None
Crypto_Sym_Camellia_Menu_Wc = None
Crypto_Sym_Camellia_Ecb_Menu_Wc_bool = None
Crypto_Sym_Camellia_Cbc_Menu_Wc_bool = None
Crypto_Sym_Chacha20_Menu_Wc_bool = None

wolfcrypt_Sym_MenuList = [    
    #Menu Label                 #Menu Symbol ID                             #Menu Symbols                              #Menu Parent                   #Visible  #Default Value
    ["Symmetric Algorithms",    "CRYPTO_SYM_MENU_WC",                       "Crypto_Sym_Menu_Wc",                       None,                           True,   None],
    ["AES Algorithm",           "CRYPTO_SYM_AES_MENU_WC",                   "Crypto_Sym_Aes_Menu_Wc",                   "Crypto_Sym_Menu_Wc",           True,   None],
    ["AES-ECB",                 "CRYPTO_SYM_AES_ECB_MENU_WC_BOOL",          "Crypto_Sym_Aes_Ecb_Menu_Wc_bool",          "Crypto_Sym_Aes_Menu_Wc",       True,   False],
    ["AES-CBC",                 "CRYPTO_SYM_AES_CBC_MENU_WC_BOOL",          "Crypto_Sym_Aes_Cbc_Menu_Wc_bool",          "Crypto_Sym_Aes_Menu_Wc",       True,   False],
    ["AES-CTR",                 "CRYPTO_SYM_AES_CTR_MENU_WC_BOOL",          "Crypto_Sym_Aes_Ctr_Menu_Wc_bool",          "Crypto_Sym_Aes_Menu_Wc",       True,   False],
    ["AES-OFB",                 "CRYPTO_SYM_AES_OFB_MENU_WC_BOOL",          "Crypto_Sym_Aes_Ofb_Menu_Wc_bool",          "Crypto_Sym_Aes_Menu_Wc",       True,   False],
    ["AES-CFB",                 "CRYPTO_SYM_AES_CFB_MENU_WC",               "Crypto_Sym_Aes_Cfb_Menu_Wc",               "Crypto_Sym_Aes_Menu_Wc",       True,   None],
    ["AES-CFB1",                "CRYPTO_SYM_AES_CFB1_MENU_WC_BOOL",         "Crypto_Sym_Aes_Cfb1_Menu_Wc_bool",         "Crypto_Sym_Aes_Cfb_Menu_Wc",   True,   False],
    ["AES-CFB8",                "CRYPTO_SYM_AES_CFB8_MENU_WC_BOOL",         "Crypto_Sym_Aes_Cfb8_Menu_Wc_bool",         "Crypto_Sym_Aes_Cfb_Menu_Wc",   True,   False],
    ["AES-CFB128",              "CRYPTO_SYM_AES_CFB128_MENU_WC_BOOL",       "Crypto_Sym_Aes_Cfb128_Menu_Wc_bool",       "Crypto_Sym_Aes_Cfb_Menu_Wc",   True,   False],
    ["AES-XTS",                 "CRYPTO_SYM_AES_XTS_MENU_WC_BOOL",          "Crypto_Sym_Aes_Xts_Menu_Wc_bool",          "Crypto_Sym_Aes_Menu_Wc",       True,   False],
    ["AES-KW",                  "CRYPTO_SYM_AES_KW_MENU_WC_BOOL",           "Crypto_Sym_Aes_Kw_Menu_Wc_bool",           "Crypto_Sym_Aes_Menu_Wc",       True,   False],
    ["TDES/3DES Algorithm",     "CRYPTO_SYM_TDES_MENU_WC",                  "Crypto_Sym_Tdes_Menu_Wc",                  "Crypto_Sym_Menu_Wc",           True,   None],
    ["TDES-ECB",                "CRYPTO_SYM_TDES_ECB_MENU_WC_BOOL",         "Crypto_Sym_Tdes_Ecb_Menu_Wc_bool",         "Crypto_Sym_Tdes_Menu_Wc",      True,   False],
    ["TDES-CBC",                "CRYPTO_SYM_TDES_CBC_MENU_WC_BOOL",         "Crypto_Sym_Tdes_Cbc_Menu_Wc_bool",         "Crypto_Sym_Tdes_Menu_Wc",      True,   False],
    ["Camellia Algorithm",      "CRYPTO_SYM_CAMELLIA_MENU_WC",              "Crypto_Sym_Camellia_Menu_Wc",              "Crypto_Sym_Menu_Wc",           True,   None],
    ["Camellia-ECB",            "CRYPTO_SYM_CAMELLIA_ECB_MENU_WC_BOOL",     "Crypto_Sym_Camellia_Ecb_Menu_Wc_bool",     "Crypto_Sym_Camellia_Menu_Wc",  True,   False],
    ["Camellia-CBC",            "CRYPTO_SYM_CAMELLIA_CBC_MENU_WC_BOOL",     "Crypto_Sym_Camellia_Cbc_Menu_Wc_bool",     "Crypto_Sym_Camellia_Menu_Wc",  True,   False],
    ["ChaCha20",                "CRYPTO_SYM_CHACHA20_MENU_WC_BOOL",         "Crypto_Sym_Chacha20_Menu_Wc_bool",         "Crypto_Sym_Menu_Wc",           True,   False],    
]
