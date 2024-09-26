import os
import sys
import inspect

# Initialize an empty dictionary to store file data
Crypto_HW_Files = {}

# Create a MCC file symbol with a unique identifier and an identical 
# output name to a source or header file. This means the .ftl will be removed
# from the output name but remain in the identifier. 
# - dest_path:  Files from Crypto_v4 Library moved into current project's src/config 
# - project_path: Make src/config files visible in project file browser in MPLABX
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

    if prefix in {'misc', 'imp'}:
        file_type = "IMPORTANT"
    elif file_name.endswith('.h'):
        file_type = "HEADER"
    else:
        file_type = "SOURCE"

    file_symbol.setType(file_type)
    file_symbol.setEnabled(enabled)

    return file_symbol


# Insert row into Crypto_HW_Files dict
def add_file_to_dict(component, file_name, file_path):
    
    config_name = Variables.get("__CONFIGURATION_NAME")
    module_path = Module.getPath()

    # Settings for file being added
    prefix = ""                                                                             # set impportant 
    pre_path = "src" if file_name.endswith(".c") or file_name.endswith(".c.ftl") else ""  # sorts .c into /src
    markup = file_name.endswith(".ftl")                                                     # check if markup
    lowest_level_dir = os.path.join("common_crypto" if file_name.startswith("MCHP") else "drivers",
                                     "CryptoLib_CPKCL" if file_name.startswith("CryptoLib") else "")
    
    # Remove auto appended portion ex. ~\crypto_v4\Module_CommonCrypto\
    relative_path = file_path.replace(module_path, '')

    # Configure destination (crypto/common_crypto)
    dest_path = os.path.join("crypto", lowest_level_dir, pre_path)

    # Configure MPLABX proj tree (config/default/crypto/common_crypto)
    project_path = os.path.join("config", config_name, "crypto", lowest_level_dir, pre_path)
    
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
    
    # Add the file as key and tuple (file_path, file_symbol) as the value
    Crypto_HW_Files[file_name] = (file_path, file_symbol)


# Make symbols for files in src/common_crypto and add to global dict
def setup_common_crypto(component):

    module_path = Module.getPath()
    common_crypto_path = os.path.join(module_path, "src", "common_crypto")

    # Recursively go through the common_crypto directory and collect all file paths
    if os.path.exists(common_crypto_path):
        for root, dirs, files in os.walk(common_crypto_path):
            for file in files:
                
                file_path = os.path.join(root, file)
                file_name = os.path.basename(file_path)

                add_file_to_dict(component, file_name, file_path)
    else:
        print("src/common_crypto directory damaged. Check that it exists.")

    return True


# Make symbols for *relevant* files in src/drivers and add to global dict
def setup_drivers(component, supported_drivers):
    
    module_path = Module.getPath()
    
    # Recursively go through the driver's directory and collect all relevant file paths
    for driver in supported_drivers:
        driver_path = os.path.join(module_path, "src", "drivers", driver)
        
        if os.path.exists(driver_path):
            for root, dirs, files in os.walk(driver_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    file_name = os.path.basename(file_path)

                    add_file_to_dict(component, file_name, file_path)
        else:
            print("src/drivers/%s directory damaged. Check that this driver exists." %driver)
   
    return True


# Make file symbols (.createFileSymbol) for crypto_v4
def setup_hw_files(component, supported_drivers):

    setup_common_crypto(component)
    setup_drivers(component, supported_drivers)

    # Print the data structure
    for file_name, (file_path, file_symbol) in Crypto_HW_Files.items():
        print("File: %s" % file_name)
        print("  File Path: %s" % file_path)
        print("  File Symbol: %s" % file_symbol)

    return
