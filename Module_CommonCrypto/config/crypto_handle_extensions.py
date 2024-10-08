# Purpose of this file is to handle components that are connected to lib_crypto.
# WolfCrypt is the main example currently. 
# 
# Steps for extending lib_crypto functionality: 
# 
# 1. create folder (ex. Module_Wolfcrypt) for the component 
# 2. build component that populates its menus
# 3. create symbols for files and handle file by itself
# 5. use sendMessage() to lib_crypto to enable needed API files 
#       - tell which fileCategories
#       - TODO: maybe allow for someone to request HW files too if the component is not a SW implementation        
#       - lib_crypto will save this request into a global data 
#         structure and will reference it upon every "generate"
# 
#         ex.
#           connectedAlgoReqs{
#               key           : algoSet()
#
#               lib_wolfcrypt : (HashAlgo, SymAlgo, AeadAlgo)
#               lib_random_sw : (RngAlgo)
#            }