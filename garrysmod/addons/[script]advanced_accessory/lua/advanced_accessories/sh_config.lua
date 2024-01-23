/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

AAS = AAS or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

--fr, en, pl, de, tr, ru
--[[ You can choose between this langages fr, en, de, ru, es, tr, pl ]]
AAS.Lang = "en"

--[[ Here you can change the title of the main menu ( "WELCOME, WHAT ARE YOU BUYING?" )]]
--[[ Don't touch if you want to get the basic text ]]
AAS.TitleMenu = ""

--[[ Set to true if you want to activate the download of all materials ]]
AAS.FastDL = true

--[[ If you use mysql you have to activate this and configure the mysql information and restart your server !! ]]
AAS.Mysql = false

--[[ How long the new tag remains when an object is added 1 = 1 day, 2 = 2 days, 0.5 = 12 hours ... ]]
AAS.NewTime = 1

--[[ Set to true if you want to use the notification of the addon ]]
AAS.ActivateNotification = true

--[[ If you want to open the menu with a key you need to set to true this variable ]]
AAS.OpenShopWithKey = false

--[[ Which job can open shop with the key if empty all jobs can open shop menu ]]
AAS.WhitelistJobToOpenShop = {
    -- ["Civil Protection"] = true,
}

--[[ Here you can modify key for open the shop menu https://wiki.facepunch.com/gmod/Enums/KEY ]]
AAS.ShopKey = KEY_F6

--[[ If you want to open the menu with a key you need to set to true this variable ]]
AAS.OpenBodyGroupWithKey = false

--[[ Which job can change bodygroup with the key if empty all jobs can change bodygroups ]]
AAS.WhitelistJobToChangeBodyGroup = {
    -- ["Civil Protection"] = true,
}

--[[ Here you can modify key for open the bodygroup menu https://wiki.facepunch.com/gmod/Enums/KEY ]]
AAS.BodyGroupKey = KEY_F5

--[[ If you want to open the menu with a key you need to set to true this variable ]]
AAS.OpenModelChangerWithKey = false

--[[ Which job can change model with the key if empty all jobs can change models ]]
AAS.WhitelistJobToChangeModel = {
    -- ["Civil Protection"] = true,
}

--[[ Here you can modify key for open the model changer menu https://wiki.facepunch.com/gmod/Enums/KEY ]]
AAS.ModelChangerKey = KEY_F7

--[[ If you want to reload item when you come back to the server ]]
AAS.LoadItemsSaved = true

--[[ If you want to reload the model when you come back to the server ]]
AAS.LoadModelSaved = true

--[[ Refund pourcentage of the accessory ]]
AAS.SellValue = 50

--[[ If the player can modify the offset of items bought ]]
AAS.ModifyOffset = true

--[[
    You need to restart the server when you add a new content into this table
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

    This is the table where you can load the default id of content who was configured for you
    572310302 = https://steamcommunity.com/sharedfiles/filedetails/?id=572310302 
    148215278 = https://steamcommunity.com/sharedfiles/filedetails/?id=148215278
    282958377 = https://steamcommunity.com/sharedfiles/filedetails/?id=282958377
    158532239 = https://steamcommunity.com/sharedfiles/filedetails/?id=158532239
    551144079 = https://steamcommunity.com/sharedfiles/filedetails/?id=551144079
    826536617 = https://steamcommunity.com/sharedfiles/filedetails/?id=826536617
    166177187 = https://steamcommunity.com/sharedfiles/filedetails/?id=166177187
    354739227 = https://steamcommunity.com/sharedfiles/filedetails/?id=354739227
]]
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1

AAS.LoadWorkshop = {
    ["572310302"] = true,
    ["148215278"] = false,
    ["282958377"] = false,
    ["158532239"] = false,
    ["551144079"] = false,
    ["826536617"] = false,
    ["166177187"] = false,
    ["354739227"] = false,
}

--[[ Time to wear the accessory when you use the swep ]]
AAS.WearTimeAccessory = 2

--[[ Whitch rank can add, modify and configure items ]]
AAS.AdminRank = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["admin"] = true
}

--[[ Which job can't have accessory equiped ]]
AAS.BlackListJobAccessory = {
    -- ["Civil Protection"] = true,
    -- ["Civil Protection Chief"] = true, 
}

--[[ Which command for open the admin menu ]]
AAS.AdminCommand = "/aasconfig"

--[[ Can open item menu with a command ]]
AAS.OpenItemMenuCommand = false

AAS.ItemsMenuCommand = "/aas"

--[[ Here you can modify gradient colors]]

--[[ White Theme ]]
AAS.Gradient = {
    ["upColor"] = Color(18, 30, 42, 200), 
    ["midleColor"] = Color(27, 59, 89, 200),
    ["downColor"] = Color(54, 140, 220), 
}

--[[ Dark Theme ]]
-- AAS.Gradient = {
--     ["upColor"] = Color(39,34,34), 
--     ["midleColor"] = Color(40,36,36),
--     ["downColor"] = Color(41,38,38), 
-- }

--[[ The name of the swep ]]
AAS.SwepName = "Inventory Swep"

--[[ If you want to be able to buy, sell item when you open the menu with the swep ]]
AAS.BuyItemWithSwep = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773

--[[ If you want to activate the weight module ]]
AAS.WeightActivate = false

--[[ All can have 10 items and Vip can have 30 items in his inventory ]]
AAS.WeightInventory = {
    ["all"] = 4, -- don't touch to the name of the category !!!!
    ["VIP"] = 10,
}

AAS.ItemNpcModel = "models/Humans/Group01/Female_02.mdl"

AAS.ItemNpcName = "Accessory Seller"

AAS.BodyGroupModel = "models/props_c17/FurnitureDresser001a.mdl"

AAS.BodyGroupsName = "Bodygroups Changer"

AAS.ModelChanger = "models/props_c17/FurnitureDresser001a.mdl"

AAS.ModelName = "Models Changer"

--[[ Whitch job can't change his bodygroups and can't open the bodygroups armory ]]
AAS.BlackListBodyGroup = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ Whitch job can't choose, buy, sell accessory and can't access to the menu ]]
AAS.BlackListItemsMenu = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ Whitch job can't change his models ]]
AAS.BlackListModelsMenu = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ Don't draw accessory on this job ]]
AAS.CantHaveAccessoryDraw = {
    // ["Hobo"] = true,
    // ["Civil Protection Chief"] = true,
}

--[[ If you want to use darkrp model when you try to change your model ]]
AAS.UseDarkRPModel = false

--[[ Here you can add your model]]
AAS.CustomModelTable = {
    ["Citizen"] = {
        "models/player/zelpa/male_01.mdl",
        "models/player/zelpa/male_03.mdl",
        "models/player/zelpa/male_05.mdl",
        "models/player/zelpa/male_06.mdl",
        "models/player/zelpa/male_07.mdl",
        "models/player/zelpa/male_08.mdl",
        "models/player/zelpa/male_09.mdl",
        "models/player/zelpa/male_10.mdl",
        "models/player/zelpa/male_11.mdl",
        "models/player/zelpa/female_01_b.mdl",
        "models/player/zelpa/female_06.mdl",
        "models/player/zelpa/female_02_b.mdl",
        "models/player/zelpa/female_03_b.mdl",
        "models/player/zelpa/female_04_b.mdl",
        "models/player/zelpa/female_06_b.mdl",
    },
    ["Civil Protection"] = {
        "models/player/zelpa/male_01.mdl",
        "models/player/zelpa/male_02.mdl",
        "models/player/zelpa/male_03.mdl",
        "models/player/zelpa/male_04.mdl",
    },
}


--[[ Here you can modify all color used by the addon ]]

--[[ White theme ]]
AAS.Colors = {
    ["whiteConfig"] = Color(255,255,255),
    ["white"] = Color(240,240,240),
    ["black"] = Color(0,0,0),
    ["black100"] = Color(0,0,0,100),
    ["black150"] = Color(0,0,0,150),
    ["black18"] = Color(18, 30, 42),
    ["black18230"] = Color(18, 30, 42, 230),
    ["black18200"] = Color(18, 30, 42, 200),
    ["black18100"] = Color(18, 30, 42, 100),
    ["background"] = Color(25, 40, 55),
    ["selectedBlue"] = Color(53, 139, 219),
    ["white200"] = Color(255,255,255,200),
    ["white50"] = Color(255,255,255,50),
    ["yellow"] = Color(255, 198, 57),
    ["darkBlue"] = Color(49, 98, 255),
    ["dark34"] = Color(34,34,34),
    ["blue77"] = Color(77, 128, 255),
    ["red49"] = Color(255, 49, 84), 
    ["grey"] = Color(189,190,191,255),
    ["blue75"] = Color(75, 168, 255),
    ["grey53"] = Color(53, 139, 219),
    ["grey165"] = Color(165, 165, 165),
    ["notifycolor"] = Color(54, 140, 220),
    ["white200"] = Color(240,240,240),
    ["bought"] = Color(252, 186, 3),
}

--[[ Dark Theme ]]
-- AAS.Colors = {
--     ["whiteConfig"] = Color(255,255,255),
--     ["white"] = Color(240,240,240),
--     ["black"] = Color(0,0,0),
--     ["black100"] = Color(0,0,0,100),
--     ["black150"] = Color(30,28,28,150),
--     ["black18"] = Color(34,32,32),
--     ["black18230"] = Color(37, 33, 33, 230),
--     ["black18200"] = Color(10, 10, 10, 200), 
--     ["black18100"] = Color(32, 42, 52, 100),
--     ["background"] = Color(34,32,32),  
--     ["selectedBlue"] = Color(33,29,29), 
--     ["white200"] = Color(134,132,132,200),
--     ["white50"] = Color(255,255,255,50),
--     ["yellow"] = Color(255, 198, 57), 
--     ["darkBlue"] = Color(49, 98, 255),
--     ["dark34"] = Color(34,34,34),
--     ["blue77"] = Color(34, 164, 51),
--     ["red49"] = Color(255, 49, 84), 
--     ["grey"] = Color(189,190,191,255),
--     ["blue75"] = Color(67, 161, 79),  
--     ["grey53"] = Color(45, 42, 44),
--     ["grey165"] = Color(165, 165, 165),
--     ["notifycolor"] = Color(34,32,32),
--     ["white200"] = Color(255,255,255),
--     ["bought"] = Color(252, 186, 3),
-- }

--[[ Actually you can just set € and $ but if you know what you do you can add more currencies]]
AAS.CurrentCurrency = "$"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8

--[[ You can add more currency here ]]
AAS.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end
}

--[[ This number define the max vector offset modification ( don't touch if you don't know what you do !! )]]
AAS.MaxVectorOffset = 5

--[[ This number define the max angle offset modification ( don't touch if you don't know what you do !! )]]
AAS.MaxAngleOffset = 30

// Reload item language if the language was changed
if SERVER then 
    if isfunction(AAS.ChangeLangage) then
        AAS.ChangeLangage() 
    end
end
