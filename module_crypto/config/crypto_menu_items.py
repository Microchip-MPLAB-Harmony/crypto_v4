# coding: utf-8
#/*****************************************************************************
# Copyright (C) 2026 Microchip Technology Inc. and its subsidiaries.
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
# *****************************************************************************/

import os

execfile( Module.getPath() + os.path.join("config", "crypto_handle_files.py"))
execfile( Module.getPath() + os.path.join("config", "crypto_globals.py"))

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
Crypto_Hw_Ecc_Menu = None
Crypto_Hw_Ecc_KeyGen = None
Crypto_Hw_Rng_Menu = None
Crypto_Hw_Rng_Trng = None

Crypto_HW_AllMenusList = [    
    #Menu Label[0]                    #Menu Symbol ID [1]          #Menu Symbols [2]           #Parent Symbol [3]         #Parent Label [4]              #Visible  #Default  #Category [7]     #Drivers [8]                     #onlinedocs [9]
    ["Hash Algorithms",               "CRYPTO_HW_HASH_MENU",       "Crypto_Hw_Hash_Menu",      None,                      None,                            True,    None,     None],
    ["SHA1",                          "CRYPTO_HW_SHA1",            "Crypto_Hw_Sha1",           "Crypto_Hw_Hash_Menu",     "Hash Algorithms",               True,    False,    "HashAlgo",       ["SHA_6156"],      "MD5_Algorithm"],
    ["SHA2 Algorithm",                "CRYPTO_HW_SHA2_MENU",       "Crypto_Hw_Sha2_Menu",      "Crypto_Hw_Hash_Menu",     "Hash Algorithms",               True,    None,     None],
    ["SHA2-224",                      "CRYPTO_HW_SHA2_224",        "Crypto_Hw_Sha2_224",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",       ["SHA_6156"],      "SHA_Algorithm"],
    ["SHA2-256",                      "CRYPTO_HW_SHA2_256",        "Crypto_Hw_Sha2_256",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",       ["SHA_6156"],      "SHA_Algorithm"],
    ["SHA2-384",                      "CRYPTO_HW_SHA2_384",        "Crypto_Hw_Sha2_384",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",       ["SHA_6156"],      "SHA_Algorithm"],
    ["SHA2-512",                      "CRYPTO_HW_SHA2_512",        "Crypto_Hw_Sha2_512",       "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",       ["SHA_6156"],      "SHA_Algorithm"],
    ["SHA2-512/224",                  "CRYPTO_HW_SHA2_512_224",    "Crypto_Hw_Sha2_512_224",   "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",       ["SHA_6156"],                   "SHA_Algorithm"],
    ["SHA2-512/256",                  "CRYPTO_HW_SHA2_512_256",    "Crypto_Hw_Sha2_512_256",   "Crypto_Hw_Sha2_Menu",     "SHA2 Algorithm",                True,    False,    "HashAlgo",       ["SHA_6156"],                   "SHA_Algorithm"],
    
    ["Symmetric Algorithms",          "CRYPTO_HW_SYM_MENU",        "Crypto_Hw_Sym_Menu",       None,                      None,                            True,    None,     None],
    ["AES Algorithm",                 "CRYPTO_HW_AES_MENU",        "Crypto_Hw_Aes_Menu",       "Crypto_Hw_Sym_Menu",      "Symmetric Algorithms",          True,    None,     None],
    ["AES-ECB",                       "CRYPTO_HW_AES_ECB",         "Crypto_Hw_Aes_Ecb",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",        ["AES_6149"],      "AES_Algorithm"],
    ["AES-CBC",                       "CRYPTO_HW_AES_CBC",         "Crypto_Hw_Aes_Cbc",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",        ["AES_6149"],      "AES_Algorithm"],
    ["AES-CTR",                       "CRYPTO_HW_AES_CTR",         "Crypto_Hw_Aes_Ctr",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",        ["AES_6149"],      "AES_Algorithm"],
    ["AES-OFB",                       "CRYPTO_HW_AES_OFB",         "Crypto_Hw_Aes_Ofb",        "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    False,    "SymAlgo",        ["AES_6149"],                   "AES_Algorithm"],
    ["AES-CFB",                       "CRYPTO_HW_AES_CFB_MENU",    "Crypto_Hw_Aes_Cfb_Menu",   "Crypto_Hw_Aes_Menu",      "AES Algorithm",                 True,    None,     None],
    ["AES-CFB8",                      "CRYPTO_HW_AES_CFB8",        "Crypto_Hw_Aes_Cfb8",       "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",        ["AES_6149"],                   "AES_Algorithm"],
    ["AES-CFB16",                     "CRYPTO_HW_AES_CFB16",       "Crypto_Hw_Aes_Cfb16",      "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",        ["AES_6149"],                   "AES_Algorithm"],
    ["AES-CFB32",                     "CRYPTO_HW_AES_CFB32",       "Crypto_Hw_Aes_Cfb32",      "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",        ["AES_6149"],                   "AES_Algorithm"],
    ["AES-CFB64",                     "CRYPTO_HW_AES_CFB64",       "Crypto_Hw_Aes_Cfb64",      "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",        ["AES_6149"],                   "AES_Algorithm"],
    ["AES-CFB128",                    "CRYPTO_HW_AES_CFB128",      "Crypto_Hw_Aes_Cfb128",     "Crypto_Hw_Aes_Cfb_Menu",  "AES-CFB",                       True,    False,    "SymAlgo",        ["AES_6149"],                   "AES_Algorithm"],
    ["TDES/3DES Algorithm",           "CRYPTO_HW_TDES_MENU",       "Crypto_Hw_Tdes_Menu",      "Crypto_Hw_Sym_Menu",      "Symmetric Algorithms",          True,    None,     None],
    ["TDES-ECB",                      "CRYPTO_HW_TDES_ECB",        "Crypto_Hw_Tdes_Ecb",       "Crypto_Hw_Tdes_Menu",     "TDES/3DES Algorithm",           True,    False,    "SymAlgo",        ["TDES_6150"],                  "TDES_Algorithm"],
    ["TDES-CBC",                      "CRYPTO_HW_TDES_CBC",        "Crypto_Hw_Tdes_Cbc",       "Crypto_Hw_Tdes_Menu",     "TDES/3DES Algorithm",           True,    False,    "SymAlgo",        ["TDES_6150"],                  "TDES_Algorithm"],
    
    ["AEAD Algorithms",               "CRYPTO_HW_AEAD_MENU",       "Crypto_Hw_Aead_Menu",      None,                      None,                            True,    None,     None],
    ["AES-GCM",                       "CRYPTO_HW_AES_GCM",         "Crypto_Hw_Aes_Gcm",        "Crypto_Hw_Aead_Menu",     "AEAD Algorithms",               True,    False,    "AeadAlgo",       ["AES_6149"],      "AES-GCM_Algorithm"],
    
    ["Digital Signature Algorithms",  "CRYPTO_HW_DIGISIGN_MENU",   "Crypto_Hw_DigiSign_Menu",  None,                      None,                            True,    None,     None],
    ["ECDSA",                         "CRYPTO_HW_ECDSA",           "Crypto_Hw_Ecdsa",          "Crypto_Hw_DigiSign_Menu", "Digital Signature Algorithms",  True,    False,    "DigisignAlgo",   ["CPKCC_44163"],   "ECDSA_Algorithm"],
    
    ["Key Agreement Algorithms(KAS)", "CRYPTO_HW_KAS_MENU",        "Crypto_Hw_Kas_Menu",       None,                      None,                            True,    None,     None],
    ["ECDH",                          "CRYPTO_HW_ECDH",            "Crypto_Hw_Ecdh",           "Crypto_Hw_Kas_Menu",      "Key Agreement Algorithms(KAS)", True,    False,    "KasAlgo",        ["CPKCC_44163"],   "ECDH_Algorithm"],
    
    ["ECC Algorithms",                "CRYPTO_HW_ECC_MENU",        "Crypto_Hw_Ecc_Menu",       None,                      None,                            True,    None,     None],
    ["ECC Key Generation",            "CRYPTO_HW_ECC_KEYGEN",      "Crypto_Hw_Ecc_KeyGen",     "Crypto_Hw_Ecc_Menu",      "ECC Algorithms",                True,    False,    "EccAlgo",        ["CPKCC_44163"],                "ECC_KeyGen_Algorithm"],
    
    ["Random Number Algortihms(RNG)", "CRYPTO_HW_RNG_MENU",        "Crypto_Hw_Rng_Menu",       None,                      None,                            True,    None,     None],
    ["TRNG",                          "CRYPTO_HW_RNG_TRNG",        "Crypto_Hw_Rng_Trng",       "Crypto_Hw_Rng_Menu",      "Random Number Algortihms(RNG)", True,    False,    "RngAlgo",        ["TRNG_6334", "TRNG_03597"],    "PRNG_Algorithm"],
]

# Cross-peripheral hard dependencies: when a HW algorithm is selected, it
# requires the listed additional peripheral clocks to be enabled, beyond
# the ones implied by its own menu[8] driver list. Currently only the CPKCC
# operations that use the on-chip TRNG internally:
#   ECDSA sign uses CPKCL_Rng for the per-signature nonce k.
#     -> drv_crypto_ecdsa_hw_cpkcl.c.ftl  vCPKCL_Process(Rng, ...)
#   ECC KeyGen uses CPKCL_Rng for the private key scalar k.
#     -> drv_crypto_ecckeygen_hw_cpkcl.c.ftl  vCPKCL_Process(Rng, ...)
# ECDH does NOT need TRNG (deterministic scalar multiply on a caller-supplied
# private key). ECDSA verify also does not need TRNG, but the menu has a
# single ECDSA checkbox covering both directions, so we conservatively
# enable TRNG whenever ECDSA is ticked.
# Keys are menu symbol IDs from Crypto_HW_AllMenusList (menu[1]); values
# are peripheral instance names ("TRNG" -> TRNG_CLOCK_ENABLE on core).
Crypto_HW_MenuClockDependencies = {
    "CRYPTO_HW_ECDSA":      ["TRNG"],
    "CRYPTO_HW_ECC_KEYGEN": ["TRNG"],
}

def Crypto_CallBack(symbol, event):
    Refresh_Files()

def Refresh_Files():
    # Collect the algoCategories the user selected through the HW algorithm
    # menu (Crypto_Hw_Sha1, Crypto_Hw_Aes_Ecb, ...).
    #
    # The boolean symbol for each menu entry is created by
    # Crypto_HW_CreateMenuInGUI (see crypto_make_gui.py), which only runs on
    # devices that have one or more supported HW crypto drivers detected from
    # the ATDF. On targets without supported HW drivers (for example any
    # non-PIC32CXMTx device using only the wolfCrypt SW path), the menu is
    # never built and the module-level 'Crypto_Hw_*' globals declared at the
    # top of this file stay at their None initial value.
    #
    # The 'globals().get(menu[2]) is not None' guard makes this loop safe in
    # that case: it returns an empty set and Refresh_Files falls through to
    # the attachment-driven path (categories requested by lib_wolfcrypt via
    # handleMessage) so common_crypto files still get enabled correctly.
    # Without the guard, calling .getValue() on the None placeholder raises
    # AttributeError and prevents common_crypto files from being emitted to
    # the project, which breaks the wolfCrypt-only build.
    crypto_selected_categories = {
        menu[7] for menu in Crypto_Hw_orderAlgoMenuList
        if menu[7] is not None
        and globals().get(menu[2]) is not None
        and globals()[menu[2]].getValue()
    }

    # Check algoCategories needed by attached modules
    print(Crypto_Attached_Category_Reqs)
    attachment_selected_categories = set()
    for category_set in Crypto_Attached_Category_Reqs.values():
        attachment_selected_categories.update(category_set)

    # Initialize sets to collect unique files
    common_crypto_reqs = set()
    wrapper_reqs = set()
    driver_reqs = set()
    library_reqs = set()

    # Superset of algoCategories that lib_crypto and it's attachments need
    user_selected_categories = crypto_selected_categories | attachment_selected_categories
    print("Enable categories:  %s" % list(user_selected_categories))
    
    # Update common crypto files list for call algoCategories
    for category in user_selected_categories:
        common_crypto_reqs.update(Crypto_HW_CommonCryptoFilesDict.get(category, []))

    # Update driver and wrapper files lists for HW-requested algoCategories
    for category in crypto_selected_categories:
        for driver in Crypto_HW_AllSupportedDriver:
            if driver[3] in Crypto_HW_DriverAndWrapperFilesDict:
                driver_files = Crypto_HW_DriverAndWrapperFilesDict[driver[3]].get(category, {})
                wrapper_reqs.update(driver_files.get("WrapperFiles", []))
                driver_reqs.update(driver_files.get("DriverFiles", []))
                library_reqs.update(driver_files.get("LibraryFiles", []))

    # Print results for debugging
    print("common_crypto_reqs: %s" % list(common_crypto_reqs))
    print("driver_reqs:        %s" % list(driver_reqs))
    print("wrapper_reqs:       %s" % list(wrapper_reqs))
    print("library_reqs:       %s" % list(library_reqs))

    # Combine all enabled files into a single set
    all_enabled_files = common_crypto_reqs | driver_reqs | wrapper_reqs | library_reqs

    # Enable or disable file symbols based on the combined list
    for file_name in Crypto_HW_Files:
        Crypto_HW_Files[file_name][1].setEnabled(file_name in all_enabled_files)
        Crypto_HW_Files[file_name][2].setValue(file_name in all_enabled_files)

    # ----------------------------------------------------------------------
    # Auto-toggle peripheral clocks (PIC32CX-MT only).
    #
    # The PIC32CX-MT clock manager (clk_pic32cx_mt) creates one Boolean
    # symbol per peripheral that has a CLOCK_ID parameter in the ATDF,
    # named "<INSTANCE>_CLOCK_ENABLE" on the "core" component. Without
    # explicit action by this component, those symbols default to False
    # and the user has to remember to tick each crypto block manually in
    # MCC's Clock Easy View, otherwise the HW responds nothing at runtime.
    #
    # On every Refresh_Files() invocation we compute the set of peripheral
    # instances that should be clocked, then drive every crypto-related
    # <INSTANCE>_CLOCK_ENABLE to True or False so the clock state tracks
    # menu state both ways (ticking and unticking).
    #
    # Two sources of "must be on":
    #   (a) The driver list (menu[8]) of every leaf menu row that is ticked.
    #   (b) Cross-peripheral hard dependencies (Crypto_HW_MenuClockDependencies):
    #       CPKCC ECDSA/keygen use the on-chip TRNG via CPKCL_Rng even when
    #       the user has not separately ticked the TRNG menu row.
    #
    # Skipped on non-PIC32CXMTx: Crypto_HW_AllSupportedDriver is empty there,
    # so this block exits early without touching any "core" symbols.
    if Crypto_HW_AllSupportedDriver:
        # driver label (e.g. "AES_6149") -> peripheral instance name ("AES").
        # Built from ATDF-matched drivers only, so we never try to clock a
        # peripheral the device does not have.
        driver_label_to_instance = {
            d[3]: d[0] for d in Crypto_HW_AllSupportedDriver
        }
        supported_instances = set(driver_label_to_instance.values())

        # Universe: every crypto peripheral instance we could potentially
        # toggle on this device. Used as the off-state sweep so we clear
        # clocks that previously were on but no longer are.
        all_crypto_instances = set()
        for m in Crypto_HW_AllMenusList:
            if m[7] is None or len(m) < 9:
                continue
            for label in m[8]:
                if label in driver_label_to_instance:
                    all_crypto_instances.add(driver_label_to_instance[label])
        # Force dependency-target instances into the universe too, so that
        # a dep-target instance still gets swept off when its dependant is
        # un-ticked.
        for extras in Crypto_HW_MenuClockDependencies.values():
            for inst in extras:
                if inst in supported_instances:
                    all_crypto_instances.add(inst)

        # Subset that should be clocked NOW.
        clocks_to_enable = set()
        for m in Crypto_HW_AllMenusList:
            if m[7] is None or len(m) < 9:
                continue
            sym = globals().get(m[2])
            if sym is None or not sym.getValue():
                continue
            # (a) Direct driver list.
            for label in m[8]:
                if label in driver_label_to_instance:
                    clocks_to_enable.add(driver_label_to_instance[label])
            # (b) Cross-peripheral hard dependencies (menu symbol ID).
            for inst in Crypto_HW_MenuClockDependencies.get(m[1], []):
                if inst in supported_instances:
                    clocks_to_enable.add(inst)

        # Drive every crypto peripheral's CLOCK_ENABLE to match the
        # algorithm menu state.
        #
        # Harmony stores symbol values at multiple priorities: default,
        # BSP, Dynamic (code-written), and User (UI click). Resolution
        # picks the highest priority that has a stored value.
        # Database.setSymbolValue writes at the Dynamic priority. A
        # previously-stored User value (from a manual click on the clock
        # checkbox in the System component UI) outranks Dynamic and wins.
        #
        # CONSEQUENCE: if the user has manually toggled a crypto clock
        # checkbox in the System UI on this project before, that User
        # value sticks and the algorithm menu cannot drive the clock
        # state. Recovery is a one-time YAML edit: close MCC and remove
        # the "type: User" block from the affected <INSTANCE>_CLOCK_ENABLE
        # symbol in <project>.X/<config>/components/core.yml. For fresh
        # projects, no User entry exists and the algorithm menu works.
        #
        # Coexistence with standalone plib components: if the user has
        # attached a dedicated plib component for a crypto peripheral
        # (e.g. the TRNG plib trng for direct CPKCL_Rng usage outside
        # lib_crypto), that component owns the clock and will have written
        # CLOCK_ENABLE=True at its own component-instantiation time. We
        # MUST NOT turn the clock off underneath it just because none of
        # our menu entries currently want it. Only TRNG has a standalone
        # plib component on the supported crypto peripherals.
        attached_plib_instances = set()
        if Database.getComponentByID("trng") is not None:
            attached_plib_instances.add("TRNG")
        for instance in all_crypto_instances:
            clock_sym_id = instance + "_CLOCK_ENABLE"
            target = instance in clocks_to_enable
            # Don't turn off a clock owned by an externally-attached plib.
            if (not target) and instance in attached_plib_instances:
                continue
            Database.setSymbolValue("core", clock_sym_id, target, 2)