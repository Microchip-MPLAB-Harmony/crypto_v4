import os

# Initialize an empty dictionary to store file data
wolfCrypt_Files = {}

# Create a MCC file symbol with a unique identifier and an identical 
def make_file_symbol(component, file_name, relative_path, prefix, dest_path, project_path, markup, enabled):

    file_id = os.path.join(prefix, file_name.replace('.', '_'))
    file_name = file_name[:-4] if markup else file_name
    
    file_symbol = component.createFileSymbol(file_id, None)
    file_symbol.setMarkup(markup)
    file_symbol.setOverwrite(True)
    file_symbol.setProjectPath(project_path)
    file_symbol.setSourcePath(relative_path)
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

# Insert row into wolfCrypt_Files dict and place files inside config/crypto
def add_file_to_dict(component, file_name, file_path, lowest_level_dir):
    
    config_name = Variables.get("__CONFIGURATION_NAME")
    module_path = Module.getPath()

    # Settings for file being added
    prefix = ""                                                                          # set impportant (unused)
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
                              dest_path,     # Destination
                              project_path,  # MPLABX proj tree
                              markup,
                              False          # Disabled initial state 
                              )
    
    # Add the file as key and tuple (relative_path, file_symbol) as the value
    wolfCrypt_Files[file_name] = (lowest_level_dir, file_symbol)

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

def setup_wc_files(component):
    
    setup_wolfcrypt_wrappers(component)

    print("Created file symbols: ")
    for file_name, (file_path, file_symbol) in wolfCrypt_Files.items():
        # print("File: %s" % file_name)
        # print("  Parent Dir: %s" % file_path)
        print("  File Symbol: %s" % file_symbol.getID())

    return