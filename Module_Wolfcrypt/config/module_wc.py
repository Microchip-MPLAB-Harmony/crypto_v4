def loadModule():
    ########################## CRYPTO Module ###############################
    WolfcryptComponent = Module.CreateComponent("WOLFCRYPT_LIB", "WolfCrypt", "/Third Party Libraries/wolfSSL/", "config/crypto_wc.py")     
    WolfcryptComponent.addDependency("COMMON_CRYPTO_DEPENDENENCY_WC", "COMMON_CRYPTO", "Crypto_v4", False, True)