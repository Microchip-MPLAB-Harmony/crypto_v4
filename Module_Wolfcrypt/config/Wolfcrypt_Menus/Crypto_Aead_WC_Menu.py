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
Crypto_Aead_Menu_Wc = None
Crypto_Aead_Aes_Gcm_Menu_Wc_bool = None
Crypto_Aead_Aes_Ccm_Menu_Wc_bool = None
Crypto_Aead_Aes_Eax_Menu_Wc_bool = None

wolfcrypt_Aead_MenuList = [    
    #Menu Label             #Menu Symbol ID                         #Menu Symbols                           #Menu Parent                #Visible    #Default Value
    ["AEAD Algorithms",     "CRYPTO_AEAD_MENU_WC",                  "Crypto_Aead_Menu_Wc",                  None,                       True,       None],
    ["AES-GCM",             "CRYPTO_AEAD_AES_GCM_MENU_WC_BOOL",     "Crypto_Aead_Aes_Gcm_Menu_Wc_bool",     "Crypto_Aead_Menu_Wc",      True,       False],
    ["AES-CCM",             "CRYPTO_AEAD_AES_CCM_MENU_WC_BOOL",     "Crypto_Aead_Aes_Ccm_Menu_Wc_bool",     "Crypto_Aead_Menu_Wc",      True,       False],
    ["AES-EAX",             "CRYPTO_AEAD_AES_EAX_MENU_WC_BOOL",     "Crypto_Aead_Aes_Eax_Menu_Wc_bool",     "Crypto_Aead_Menu_Wc",      True,       False],
]
