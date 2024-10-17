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

# Create a MCC bool symbol with a unique identifier with _flag appended
def make_file_symbol_flag(component, file_name, prefix, enabled):

    file_id = os.path.join(prefix, file_name.replace('.', '_')) + "_flag"

    file_symbol_flag = component.createBooleanSymbol(file_id, None)
    file_symbol_flag.setDefaultValue(enabled)
    file_symbol_flag.setVisible(False)

    return file_symbol_flag

# Insert row into wolfCrypt_Files dict and place files inside config/crypto
def add_file_to_dict(component, file_name, file_path, lowest_level_dir):
    
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
                              False                     # Disabled initial state 
                              )

    file_symbol_flag = make_file_symbol_flag(component, 
                                             file_name,
                                             prefix, 
                                             False      # Disabled initial state 
                                             )
    
    # Add the file as key and tuple (relative_path, file_symbol) as the value
    wolfCrypt_Files[file_name] = (lowest_level_dir, file_symbol, file_symbol_flag)

# Make symbols for files in src/WolfCryptWrapper and add to global dict
def setup_wolfcrypt_wrappers(component):
    module_path = Module.getPath()
    wolfcrypt_wrapper_path = os.path.join(module_path, "src", "WolfCryptWrapper")

    # Recursively go through the common_crypto directory and collect all file paths
    if os.path.exists(wolfcrypt_wrapper_path):
        for root, dirs, files in os.walk(wolfcrypt_wrapper_path):
            for file in files:                
                file_path = os.path.join(root, file)
                file_name = os.path.basename(file_path)

                add_file_to_dict(component, file_name, file_path, "wolfcrypt")
        print("src/wolfcryptwrapper directory file symbols created.")
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

                add_file_to_dict(component, file_name, file_path, "wolfcrypt")
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