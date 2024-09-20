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
Crypto_Rng_Menu_Wc = None
Crypto_Rng_Trng_Menu_Wc_bool = None
Crypto_Rng_Prng_Menu_Wc_bool = None

wolfcrypt_Rng_MenuList = [    
    #Menu Label                         #Menu Symbol ID                     #Menu Symbols                       #Menu Parent            #Visible   #Default Value
    ["Random Number Algortihms(RNG)",   "CRYPTO_RNG_MENU_WC",               "Crypto_Rng_Menu_Wc",               None,                   True,       None],
    ["TRNG",                            "CRYPTO_RNG_TRNG_MENU_WC_BOOL",     "Crypto_Rng_Trng_Menu_Wc_bool",     "Crypto_Rng_Menu_Wc",   True,       False],
    ["PRNG",                            "CRYPTO_RNG_PRNG_MENU_WC_BOOL",     "Crypto_Rng_Prng_Menu_Wc_bool",     "Crypto_Rng_Menu_Wc",   True,       False],
]