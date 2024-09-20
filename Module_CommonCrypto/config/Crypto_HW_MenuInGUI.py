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

import os
execfile( Module.getPath() + os.path.join("config", "Crypto_HW_AllMenusList.py"))
execfile( Module.getPath() + os.path.join("config", "Crypto_HW_Driver.py"))

Crypto_Hw_disorderAlgoMenuList = []
Crypto_Hw_orderAlgoMenuList = Crypto_HW_AllMenusList

global func_Crypto_HW_GetAllSupportMenuList
global func_Crypto_HW_GetAllSupportAlgoMenuInOrder
global func_Crypto_HW_CreateMenuInGUI
#--------------------------------------------------------------------------------------- 
def func_Crypto_Hw_DetectDriverAlgosAndShowMenu(CommonCryptoComponent):
    func_Crypto_HW_GetAllSupportMenuList()
    func_Crypto_HW_GetAllSupportAlgoMenuInOrder()
    func_Crypto_HW_CreateMenuInGUI(CommonCryptoComponent)
#---------------------------------------------------------------------------------------
def func_Crypto_HW_GetAllSupportMenuList():
    for driver in Crypto_HW_AllSupportedDriver:
        for menu in Crypto_HW_AllMenusList:
            if menu[6] is not None: #if it is not a Menu Heading, Only Boolean Menu Allowed, Here menu[6] represent Default value of particular menu
                if driver[3] in menu[8]:#if menu is support by driver then only include in the list, Here menu[8] represent list of drivers in the boolean menu, And driver[3] represent driver name
                    if menu not in Crypto_Hw_disorderAlgoMenuList:#Do not duplicate Menus in the list
                            Crypto_Hw_disorderAlgoMenuList.append(menu)             
#--------------------------------------------------------------------------------------- 
def func_Crypto_HW_GetAllSupportAlgoMenuInOrder():
    for booleanMenu in Crypto_Hw_orderAlgoMenuList[:]:
        if booleanMenu[6] is not None:#if it is not a Menu Heading, Only Boolean Menu Allowed, Here menu[6] represent Default value of particular menu
            if booleanMenu not in Crypto_Hw_disorderAlgoMenuList:
                Crypto_Hw_orderAlgoMenuList.remove(booleanMenu)
                
    for menu in Crypto_Hw_orderAlgoMenuList[:]:
        if menu[6] is None:#if it is a Menu Heading, Only Menu Heading Allowed, Here menu[6] represent Default value of particular menu
            parentMenuReq = False
            for menuItem in Crypto_Hw_orderAlgoMenuList[:]:
                if(menuItem[4] == menu[0]):#if it is a Menu Heading is parent of supported Menu,here menuItem[4] repsent that menu-parent and menu[0] represent menu 
                    parentMenuReq = True
                    break;
            if(parentMenuReq == False):
                Crypto_Hw_orderAlgoMenuList.remove(menu)      
#---------------------------------------------------------------------------------------
def func_Crypto_HW_CreateMenuInGUI(CommonCryptoComponent):
    for menu in Crypto_Hw_orderAlgoMenuList:
        if(menu[6] == None):
            if(menu[3] == None):
               globals()[menu[2]] = CommonCryptoComponent.createMenuSymbol(menu[1], None)
            else:
               globals()[menu[2]] = CommonCryptoComponent.createMenuSymbol(menu[1], globals()[menu[3]])
        else:    
            globals()[menu[2]] = CommonCryptoComponent.createBooleanSymbol(menu[1], globals()[menu[3]])
            globals()[menu[2]].setDefaultValue(menu[6])
                
        globals()[menu[2]].setLabel(menu[0])
        #globals()[menu[2]].setDescription(menu[0])
        globals()[menu[2]].setVisible(menu[5])          
#-----------------------------------------------------------------------------------------