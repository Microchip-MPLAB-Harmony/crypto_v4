import os

execfile( Module.getPath() + os.path.join("config", "crypto_globals.py"))

#################################################################################

def make_file_symbol(component, file_name, relative_path, prefix, dest_path, project_path, markup, enabled):
    """ 
    Create an MCC file symbol with a unique identifier and an identical 
    output name to a source or header file. This means the .ftl will be removed
    from the output name but remain in the identifier. 
    - dest_path:  Files from Crypto_v4 Library moved into current project's src/config 
    - project_path: Make src/config files visible in project file browser in MPLABX
    """

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


def make_file_symbol_flag(component, file_name, prefix, enabled):
    """
    Create an MCC boolean symbol with a unique identifier (and _flag)
    appended to be referenced in FreeMarker Templates
    """

    file_id = os.path.join(prefix, file_name.replace('.', '_')) + "_flag"   # Reference this in FreeMarker Template

    file_symbol_flag = component.createBooleanSymbol(file_id, None)
    file_symbol_flag.setDefaultValue(enabled)
    file_symbol_flag.setVisible(False)

    return file_symbol_flag


def add_file_to_dict(component, file_name, file_path, lowest_level_dir):
    """
    Insert row into Crypto_HW_Files dict and 
    initialize files to appear in config/crypto/$(lowest_level_dir)
    """

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
    Crypto_HW_Files[file_name] = (lowest_level_dir, file_symbol, file_symbol_flag)

#################################################################################

def setup_common_crypto(component):
    """
    Make symbols for files in src/common_crypto and add to global dict
    """

    module_path = Module.getPath()
    common_crypto_path = os.path.join(module_path, "src", "common_crypto")

    # Recursively go through the common_crypto directory and collect all file paths
    if os.path.exists(common_crypto_path):
        for root, dirs, files in os.walk(common_crypto_path):
            for file in files:                
                file_path = os.path.join(root, file)
                file_name = os.path.basename(file_path)

                add_file_to_dict(component, file_name, file_path, "common_crypto")
        print("src/common_crypto directory file symbols created.")
    else:
        Log.writeWarningMessage("src/common_crypto directory damaged. Check that it exists.")

    return True


def setup_drivers(component, supported_drivers):
    """
    Make symbols for *relevant* files in src/drivers and add to global dict
    """

    module_path = Module.getPath()
    
    # Recursively go through the driver's directory and collect all relevant file paths
    for driver in supported_drivers:
        driver_path = os.path.join(module_path, "src", "drivers", driver)
        
        if os.path.exists(driver_path):
            for root, dirs, files in os.walk(driver_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    file_name = os.path.basename(file_path)

                    # Get the folder name right after the driver in the path
                    relative_path = file_path.split(os.sep)
                    try:
                        # Find index of the current driver and get the next folder
                        driver_index = relative_path.index(driver)
                        next_folder = relative_path[driver_index + 1] if driver_index + 1 < len(relative_path) else None
                        # print("Next folder after '%s':" % driver, next_folder)
                    except ValueError:
                        print("Driver '%s' not found in the path" % driver)

                    to_folder = os.path.join("drivers", next_folder)
                    add_file_to_dict(component, file_name, file_path, to_folder)
            print("src/drivers/%s file symbols created." %driver)
        else:
            Log.writeWarningMessage("src/drivers/%s directory damaged. Check that this driver exists." %driver)
   
    return True


def setup_templates(component):
    """
    # Will make file symbols for anything in Module_CommonCrypto/templates
    # which can then be toggled on and off by including the file in any of the file dicts
    """

    config_name = Variables.get("__CONFIGURATION_NAME")
    module_path = Module.getPath()
    templates_path = os.path.join(module_path, "templates")

    # Recursively go through the common_crypto directory and collect all file paths
    if os.path.exists(templates_path):
        for root, dirs, files in os.walk(templates_path):
            for file in files:
                
                file_path = os.path.join(root, file)
                file_name = os.path.basename(file_path)

                add_file_to_dict(component, file_name, file_path, "")
        print("/templates file symbols created.")
    else:
        Log.writeWarningMessage("/templates directory damaged. Check that it exists.")


def setup_hw_files(component, supported_drivers):
    """
    Make symbols for crypto_v4
    """

    setup_common_crypto(component)
    setup_drivers(component, supported_drivers)
    setup_templates(component)

    print("Created file symbols: ")
    for file_name, (file_path, file_symbol, file_symbol_flag) in Crypto_HW_Files.items():
        # print("File: %s" % file_name)
        # print("  Parent Dir: %s" % file_path)
        print("  File Symbol: %s (on? %s)" %(file_symbol.getID(), file_symbol_flag.getValue()))

    return