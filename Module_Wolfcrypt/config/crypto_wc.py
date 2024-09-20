import os
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Hash_WC_Menu.py"))
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Sym_WC_Menu.py"))
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Mac_WC_Menu.py"))
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Aead_WC_Menu.py"))
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Digisign_WC_Menu.py"))
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Kas_WC_Menu.py"))
execfile( Module.getPath() + os.path.join("config", "Wolfcrypt_Menus", "Crypto_Rng_WC_Menu.py"))

global func_wolfcryptSetupOneListOfMenu
global func_wlfcryptSetUpAllMenu

def instantiateComponent(WolfcryptComponent):
    func_wlfcryptSetUpAllMenu(WolfcryptComponent)

#---------------------------------------------------------------------------------------
def func_wlfcryptSetUpAllMenu(WolfcryptComponent):
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Hash_MenuList)
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Sym_MenuList)
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Mac_MenuList)
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Aead_MenuList)
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Digisign_MenuList)
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Kas_MenuList)
    func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, wolfcrypt_Rng_MenuList)
    
#---------------------------------------------------------------------------------------
def func_wolfcryptSetupOneListOfMenu(WolfcryptComponent, menuList):
    for menu in menuList:
        if(menu[5] == None):
            if(menu[3] == None):
               globals()[menu[2]] = WolfcryptComponent.createMenuSymbol(menu[1], None)
            else:
               globals()[menu[2]] = WolfcryptComponent.createMenuSymbol(menu[1], globals()[menu[3]])
        else:    
            globals()[menu[2]] = WolfcryptComponent.createBooleanSymbol(menu[1], globals()[menu[3]])
            globals()[menu[2]].setDefaultValue(menu[5])
                
        globals()[menu[2]].setLabel(menu[0])
        #menu[2].setDescription("Hash Algorithms Supported by Wolfcrypt:")
        globals()[menu[2]].setVisible(menu[4])          
#----------------------------------------------------------------------------------------- 
    
# Figure out how to remove Component Symbols so that re-adding the module works
def destroyComponent(WolfcryptComponent):
    idList = Database.getActiveComponentIDs()
    symIDList = Database.getComponentSymbolIDs("WOLFCRYPT_LIB")
    symIDList_str = [str(item) for item in symIDList]

    print("goodbye")
    idList = Database.getActiveComponentIDs()
    symIDList = Database.getComponentSymbolIDs("WOLFCRYPT_LIB")
    print(idList)
    print(symIDList)
    
    return