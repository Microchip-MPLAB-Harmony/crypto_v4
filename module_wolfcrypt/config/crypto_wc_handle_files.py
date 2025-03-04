# coding: utf-8
#/*****************************************************************************
# Copyright (C) 2025 Microchip Technology Inc. and its subsidiaries.
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

# Initialize an empty dictionary to store file data
wolfCrypt_Files = {}

# Create a MCC file symbol with a unique identifier and an identical 
def make_file_symbol(component, file_name, relative_src_path, prefix, dest_path, project_path, markup, enabled):
    # Source path:  relative to where the xml is for this module.
    # Dest_path:    relative to config/default
    # Project_path: relative to proj categories

    file_id = os.path.join(prefix, file_name.replace('.', '_'))
    file_name = file_name[:-4] if markup else file_name
    
    file_symbol = component.createFileSymbol(file_id, None)
    file_symbol.setMarkup(markup)
    file_symbol.setOverwrite(True)
    file_symbol.setProjectPath(project_path)
    file_symbol.setSourcePath(relative_src_path)
    file_symbol.setOutputName(file_name)
    file_symbol.setDestPath(dest_path)

    file_symbol.setSecurity("SECURE" if Variables.get("__TRUSTZONE_ENABLED") else "NON_SECURE")

    if prefix in {'misc', 'imp'}:
        file_type = "IMPORTANT"
    elif file_name.endswith('.h'):
        file_type = "HEADER"
    else:
        file_type = "SOURCE"

    file_symbol.setType(file_type)
    file_symbol.setEnabled(enabled)

    return file_symbol

def create_setting_symbol(component, symbol_name, category, key, value, append=True, separator=";"):
    
    setting_symbol = component.createSettingSymbol(symbol_name, None)
    setting_symbol.setCategory(category)
    setting_symbol.setKey(key)
    setting_symbol.setValue(value)
    setting_symbol.setAppend(append, separator)

    setting_symbol.setSecurity("SECURE" if Variables.get("__TRUSTZONE_ENABLED") else "NON_SECURE")

    return setting_symbol

# Create a MCC bool symbol with a unique identifier with _flag appended
def make_file_symbol_flag(component, file_name, prefix, enabled):

    file_id = os.path.join(prefix, file_name.replace('.', '_')) + "_flag"

    file_symbol_flag = component.createBooleanSymbol(file_id, None)
    file_symbol_flag.setDefaultValue(enabled)
    file_symbol_flag.setVisible(False)

    return file_symbol_flag

# Insert row into wolfCrypt_Files dict and place files inside config/crypto
def add_file_to_dict(component, file_name, file_path, lowest_level_dir, enabled):
    
    config_name = Variables.get("__CONFIGURATION_NAME")
    module_path = Module.getPath()

    # Settings for file being added
    prefix = ""                                                                          # set important (unused)
    pre_path = "src" if file_name.endswith(".c") or file_name.endswith(".c.ftl") else "" # sorts .c into /src
    markup = file_name.endswith(".ftl")                                                  # check if markup
                                          
    # Remove auto appended portion ex. ~\crypto_v4\Module_CommonCrypto\
    relative_path = file_path.replace(module_path, '')

    # Configure destination (crypto/common_crypto)
    dest_path = os.path.join("crypto", lowest_level_dir, pre_path)

    # Configure MPLABX proj tree (config/default/crypto/common_crypto)
    project_path = os.path.join("config", config_name, "crypto", lowest_level_dir)

    # Create symbol
    file_symbol = make_file_symbol(component,
                              file_name, 
                              relative_path,            # Source 
                              prefix, 
                              dest_path,                # Destination
                              project_path,             # MPLABX proj tree
                              markup,
                              enabled                   # Initial state 
                              )

    file_symbol_flag = make_file_symbol_flag(component, 
                                             file_name,
                                             prefix, 
                                             enabled      # Initial state 
                                             )
    
    # Track the file (relative_path, file_symbol) if not enabled on startup 
    if not enabled:
        wolfCrypt_Files[file_name] = (lowest_level_dir, file_symbol, file_symbol_flag)

# Make symbols for files in src/wolfcrypt_wrapper and add to global dict
def setup_wolfcrypt_wrappers(component):
    module_path = Module.getPath()
    wolfcrypt_wrapper_path = os.path.join(module_path, "src", "wolfcrypt_wrapper")

    # Recursively go through the common_crypto directory and collect all file paths
    if os.path.exists(wolfcrypt_wrapper_path):
        for root, dirs, files in os.walk(wolfcrypt_wrapper_path):
            for file in files:                
                file_path = os.path.join(root, file)
                file_name = os.path.basename(file_path)

                add_file_to_dict(component, file_name, file_path, "wolfcrypt", False)
        print("src/wolfcrypt_wrapper directory file symbols created.")
    else:
        Log.writeWarningMessage("src/common_crypto directory damaged. Check that it exists.")

    return True

def setup_templates(component):
      
    config_name = Variables.get("__CONFIGURATION_NAME")         # default
    module_path = Module.getPath()                              # \crypto_v4\Module_CommonCrypto
    templates_path = os.path.join(module_path, "templates")     # \crypto_v4\Module_CommonCrypto\templates

    # Recursively go through the common_crypto directory and collect all file paths
    if os.path.exists(templates_path):
        for root, dirs, files in os.walk(templates_path):
            for file in files:
                file_path = os.path.join(root, file)
                file_name = os.path.basename(file_path)

                add_file_to_dict(component, file_name, file_path, "wolfcrypt", True)
        print("/templates file symbols created.")
    else:
        Log.writeWarningMessage("/templates directory damaged. Check that it exists.")

# TODO: Find some logic behind why it was done this way
def setup_wolfssl_dir(component):
    harmony_content_path = Variables.get("__FRAMEWORK_ROOT")   # .mcc\HarmonyContent
    
    # Settings
    prefix = ""
    markup = False

    wolfcrypt_path              = os.path.join(harmony_content_path, "wolfssl", "wolfcrypt", "src")
    wolfssl_wolfcrypt_path      = os.path.join(harmony_content_path, "wolfssl", "wolfssl", "wolfcrypt")
    relative_wolfcrypt          = os.path.join(os.pardir, os.pardir, "wolfssl", "wolfcrypt")
    
    wolfcrypt_port_path         = os.path.join(wolfcrypt_path, "port", "pic32")
    wolfssl_wolfcrypt_port_path = os.path.join(wolfssl_wolfcrypt_path, "port", "pic32")
    relative_wolfssl_wolfcrypt  = os.path.join(os.pardir, os.pardir, "wolfssl", "wolfssl", "wolfcrypt")

    # Get all .c files, excluding misc.c and evp.c for wolfcrypt
    wolfcrypt_files = [f for f in os.listdir(wolfcrypt_path) if f.endswith('.c') and f not in {"misc.c", "evp.c"}]
    for file in wolfcrypt_files:

        relative_path = os.path.join(relative_wolfcrypt, "src", file)
        dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfcrypt", "src")
        project_path = os.path.join("third_party", "wolfssl", "wolfcrypt", "src")
        make_file_symbol(component, file, relative_path, prefix, dest_path, project_path, markup, True)

    # Get all .h files for wolfssl wolfcrypt
    wolfssl_wolfcrypt_files = [f for f in os.listdir(wolfssl_wolfcrypt_path) if f.endswith('.h')]
    for file in wolfssl_wolfcrypt_files:

        relative_path = os.path.join(relative_wolfssl_wolfcrypt, file)
        dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfssl", "wolfcrypt")
        project_path = os.path.join("third_party", "wolfssl", "wolfssl", "wolfcrypt")
        make_file_symbol(component, file, relative_path, prefix, dest_path, project_path, markup, True)

    # Get port files for wolfcrypt (.c)
    wolfcrypt_port_files =  [f for f in os.listdir(wolfcrypt_port_path) if f.endswith('.c')]
    for file in wolfcrypt_port_files:

        relative_path = os.path.join(relative_wolfcrypt, "src", "port", "pic32", file)
        dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfcrypt", "src", "port", "pic32")
        project_path = os.path.join("third_party", "wolfssl", "wolfcrypt", "port", "pic32")
        make_file_symbol(component, file, relative_path, prefix, dest_path, project_path, markup, True)

    # Get port files for wolfssl (.h)
    wolfssl_wolfcrypt_port_files =  [f for f in os.listdir(wolfssl_wolfcrypt_port_path) if f.endswith('.h')]
    for file in wolfssl_wolfcrypt_port_files:

        relative_path = os.path.join(relative_wolfssl_wolfcrypt, "port", "pic32", file)
        dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfssl", "wolfcrypt", "port", "pic32")
        project_path = os.path.join("third_party", "wolfssl", "wolfcrypt", "port", "pic32")
        make_file_symbol(component, file, relative_path, prefix, dest_path, project_path, markup, True)

    # Get special files (certs_test.h)
    certs_test = "certs_test.h"
    certs_test_path = os.path.join(os.pardir, os.pardir, "wolfssl", "wolfssl", certs_test)
    certs_test_dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfssl")
    certs_test_proj_path = os.path.join("third_party", "wolfssl", "wolfssl")
    make_file_symbol(component, certs_test, certs_test_path, prefix, certs_test_dest_path, certs_test_proj_path, markup, True)

    # Get special files (misc.c)
    misc = "misc.c"
    misc_path = os.path.join(relative_wolfcrypt, "src", misc)
    misc_dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfssl", "wolfcrypt", "src")
    misc_proj_path = os.path.join("third_party", "wolfssl", "wolfssl", "src", "wolfcrypt")
    make_file_symbol(component, misc, misc_path, prefix, misc_dest_path, misc_proj_path, markup, True)

    # Get special files (evp.c)
    evp = "evp.c"
    evp_path = os.path.join(relative_wolfcrypt, "src", evp)
    evp_dest_path = os.path.join(os.pardir, os.pardir, "third_party", "wolfssl", "wolfssl", "wolfcrypt", "src")
    evp_proj_path = os.path.join("third_party", "wolfssl", "wolfssl", "wolfcrypt")
    make_file_symbol(component, evp, evp_path, prefix, evp_dest_path, evp_proj_path, markup, True)

def setup_wc_settings(component):

    config_name = Variables.get("__CONFIGURATION_NAME")

    # Include directories paths
    include_dirs = [
        "../src/third_party/wolfssl/wolfssl/wolfcrypt",
        "../src/third_party/wolfssl",
        "../src/third_party/wolfcrypt"
    ]

    # Create include path symbol
    create_setting_symbol(
        component,
        "XC32_CRYPTO_INCLUDE_DIRS",
        "C32",
        "extra-include-directories",
        ";".join(include_dirs)
    )

    # Create preprocessor macro symbols
    preprocessor_macros = {
        "wolfsslConfigH": "HAVE_CONFIG_H",  # WolfSSL config.h
        "wolfsslUserSettingsH": "WOLFSSL_USER_SETTINGS",  # WolfSSL user_settings.h
        "wolfsslIgnoreFileWarn": "WOLFSSL_IGNORE_FILE_WARN"  # Ignore file warnings
    }

    for symbol_name, macro_value in preprocessor_macros.items():
        create_setting_symbol(
            component,
            symbol_name,
            "C32",
            "preprocessor-macros",
            macro_value
        )

def setup_wc_files(component):
    
    setup_wolfcrypt_wrappers(component)
    setup_templates(component)
    setup_wolfssl_dir(component)

    print("Created file symbols: ")
    for file_name, (file_path, file_symbol, file_symbol_flag) in wolfCrypt_Files.items():
        # print("File: %s" % file_name)
        # print("  Parent Dir: %s" % file_path)
        print("  File Symbol: %s (on? %s)" %(file_symbol.getID(), file_symbol_flag.getValue()))

    return