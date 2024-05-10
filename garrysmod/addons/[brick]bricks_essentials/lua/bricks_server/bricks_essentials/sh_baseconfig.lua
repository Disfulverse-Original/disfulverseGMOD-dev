--[[
    !!WARNING!!
        ALL CONFIG IS DONE INGAME, DONT EDIT ANYTHING HERE
        Type !bricksserver ingame or use the f4menu
    !!WARNING!!
]]--

--[[ MODULES CONFIG ]]--
BRICKS_SERVER.BASECONFIG.MODULES = BRICKS_SERVER.BASECONFIG.MODULES or {}
BRICKS_SERVER.BASECONFIG.MODULES["essentials"] = { true, {
    ["boosters"] = false,
    ["boss"] = true,
    ["crafting"] = true,
    ["deathscreens"] = false,
    ["f4menu"] = true,
    --["hud"] = false, -- удалены
    ["inventory"] = true,
    ["levelling"] = true,
    ["logging"] = true,
    ["marketplace"] = true,
    ["printers"] = true,
    ["swepupgrader"] = false,
    ["zones"] = true
} }

--[[ GENERAL CONFIG ]]--
BRICKS_SERVER.BASECONFIG.GENERAL = BRICKS_SERVER.BASECONFIG.GENERAL or {}
BRICKS_SERVER.BASECONFIG.GENERAL["F4 Use Spawn Icons"] = false
BRICKS_SERVER.BASECONFIG.GENERAL["Client Logs Limit"] = 100
BRICKS_SERVER.BASECONFIG.GENERAL.JobGroups = {}
BRICKS_SERVER.BASECONFIG.GENERAL.EntityGroups = {}
BRICKS_SERVER.BASECONFIG.GENERAL.ShipmentGroups = {}
BRICKS_SERVER.BASECONFIG.GENERAL.AmmoGroups = {}

--[[ F4 CONFIG ]]--
BRICKS_SERVER.BASECONFIG.F4 = {}
BRICKS_SERVER.BASECONFIG.F4.Tabs = {
    [1] = { "Профессии", "jobs_24.png", 1 },
    [2] = { "Поставки", "shop_24.png", 2 },
    [3] = { "Инвентарь", "inventory_24.png", { 
        { "Главная", 3 }, 
        { "Принтеры", 4 }, 
        --{ "Boosters", 5 }
    } },
    [4] = { "Крафтинг", "crafting_24.png", 6 },
    [5] = { "Профиль", "profile_24.png", { 
        { "Статистика", 7 }, 
        { "Логи", 8 }
    } },
    [6] = { "Организации", "gangs.png", 12 },
    --[6] = { true },
    --[7] = { "Discord", "discord_24.png", "https://discord.gg/crBpKpR" },
    --[8] = { "Контент", "crate_24.png", "https://steamcommunity.com/sharedfiles/filedetails/?id=3148772701" },
}

--[[ LEVELING ]]--
BRICKS_SERVER.BASECONFIG.LEVELING = {}
BRICKS_SERVER.BASECONFIG.LEVELING["Max Level"] = 45
BRICKS_SERVER.BASECONFIG.LEVELING["Original EXP Required"] = 1000
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Required Increase"] = 0.2
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Killing NPC"] = 500
BRICKS_SERVER.BASECONFIG.LEVELING["Playing On Server Reward Time"] = 300
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Playing On Server"] = 250
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Lockpick"] = 75
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Entered Lottery"] = 50
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Lottery Won"] = 1000
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Hit Completed"] = 750
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Rock Mined"] = 250
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Tree Chopped"] = 250
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Garbage Searched"] = 175
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Money Printing"] = 25
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Armory Robbery"] = 0
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - Laundering"] = 0
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - CityWorker"] = 500
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - ROBBERY SUCCESS"] = 1500
BRICKS_SERVER.BASECONFIG.LEVELING["EXP Gained - ROBBERY KILL"] = 750
BRICKS_SERVER.BASECONFIG.LEVELING.JobLevels = {}
BRICKS_SERVER.BASECONFIG.LEVELING.EntityLevels = {}
BRICKS_SERVER.BASECONFIG.LEVELING.ShipmentLevels = {}
BRICKS_SERVER.BASECONFIG.LEVELING.AmmoLevels = {}

--[[ PRINTERS ]]--
BRICKS_SERVER.BASECONFIG.PRINTERS = {}
BRICKS_SERVER.BASECONFIG.PRINTERS["Max Level"] = 5
BRICKS_SERVER.BASECONFIG.PRINTERS["Original EXP Required"] = 5000
BRICKS_SERVER.BASECONFIG.PRINTERS["EXP Required Increase"] = 1.5
BRICKS_SERVER.BASECONFIG.PRINTERS["Printer EXP Per Print"] = 50
BRICKS_SERVER.BASECONFIG.PRINTERS["Money Increase Per Level"] = 0.025
BRICKS_SERVER.BASECONFIG.PRINTERS["Ink Lost Per Print"] = 1
BRICKS_SERVER.BASECONFIG.PRINTERS["Replace Cooldown"] = 600
BRICKS_SERVER.BASECONFIG.PRINTERS.Tiers = {
    [1] = {
        Name = "Принтер Т1",
        UpgradeCost = 0,
        ModelColor = Color( 192, 192, 192 ),
        ScreenColor = Color( 192, 192, 192 ),
        Health = 150,
        MaxInk = 50,
        PrintAmount = 50,
        MoneyStorage = 20000,
        PrintSpeed = 40
    },
    [2] = {
        Name = "Принтер Т2",
        UpgradeCost = 20000,
        ModelColor = Color( 238, 191, 39 ),
        ScreenColor = Color( 234, 213, 39 ),
        Health = 150,
        MaxInk = 50,
        PrintAmount = 150,
        MoneyStorage = 30000,
        PrintSpeed = 30
    },
    [3] = {
        Name = "Принтер Т3",
        UpgradeCost = 30000,
        ModelColor = Color( 16, 231, 255 ),
        ScreenColor = Color( 74, 255, 245 ),
        Health = 150,
        MaxInk = 50,
        PrintAmount = 250,
        MoneyStorage = 40000,
        PrintSpeed = 20
    },
    [4] = {
        Name = "Принтер Т4",
        UpgradeCost = 40000,
        ModelColor = Color( 65, 34, 119 ),
        ScreenColor = Color( 83, 63, 112 ),
        Health = 150,
        MaxInk = 50,
        PrintAmount = 300,
        MoneyStorage = 50000,
        PrintSpeed = 10
    }
}
BRICKS_SERVER.BASECONFIG.PRINTERS.PrinterSlots = {
    [1] = {
        Price = 10000,
        Level = 30,       
    },
    [2] = {
        Group = "Dis+",
    },
--[[ 
    [3] = {
        Price = 20000,
        Level = 5,
    },
    [4] = {
        Group = "VIP",
    },
--]]
}

--[[ INVENTORY ]]--
BRICKS_SERVER.BASECONFIG.INVENTORY = BRICKS_SERVER.BASECONFIG.INVENTORY or {}
BRICKS_SERVER.BASECONFIG.INVENTORY["Max Item Stack"] = 10
BRICKS_SERVER.BASECONFIG.INVENTORY["Inventory Slots"] = {
    ["Staff"] = 40,
    --["VIP++"] = 35,
    --["VIP+"] = 30,
    ["Disfulversed"] = 20,
    ["Default"] = 15
}
BRICKS_SERVER.BASECONFIG.INVENTORY["Bank Slots"] = {
    ["Staff"] = 40,
    --["VIP++"] = 35,
    --["VIP+"] = 30,
    ["Disfulversed"] = 20,
    ["Default"] = 10
}

--[[ BOOSTERS ]]--
BRICKS_SERVER.BASECONFIG.BOOSTERS = {
--[[
    [1] = {
        Title = "2X EXP",
        Type = 1,
        Multiplier = 2,
        Time = 60,
        Icon = "https://i.imgur.com/MoWl39V.png"
    },
    [2] = {
        Title = "4X EXP",
        Type = 1,
        Multiplier = 4,
        Time = 60,
        Icon = "https://i.imgur.com/DzvUBFv.png"
    },
    [3] = {
        Title = "2X Printer EXP",
        Type = 2,
        Multiplier = 2,
        Time = 60,
        Icon = "https://i.imgur.com/B2PVgUV.png"
    },
    [4] = {
        Title = "4X Printer EXP",
        Type = 2,
        Multiplier = 4,
        Time = 60,
        Icon = "https://i.imgur.com/BfzvXDH.png"
    }
--]]
}

--[[ CRAFTING ]]--
BRICKS_SERVER.BASECONFIG.CRAFTING = {}
BRICKS_SERVER.BASECONFIG.CRAFTING["Rock Respawn Time"] = 120
BRICKS_SERVER.BASECONFIG.CRAFTING["Tree Respawn Time"] = 120
BRICKS_SERVER.BASECONFIG.CRAFTING["Garbage Respawn Time"] = 180
BRICKS_SERVER.BASECONFIG.CRAFTING["Garbage Collect Time"] = 3
BRICKS_SERVER.BASECONFIG.CRAFTING["Resource Despawn Time"] = 300
BRICKS_SERVER.BASECONFIG.CRAFTING["Add Resources Directly To Inventory"] = false
BRICKS_SERVER.BASECONFIG.CRAFTING.Resources = {
    ["Камень"] = { "models/2rek/brickwall/bwall_ore_1.mdl", Color( 17, 17, 18 ) },
    ["Опилки"] = { "models/Gibs/wood_gib01d.mdl" },
    ["Мусор"] = { "models/props_junk/Shoe001a.mdl" },
    --
    ["Железо"] = { "models/2rek/brickwall/bwall_ore_1.mdl", Color( 161, 166, 168 ) },
    ["Древесина"] = { "models/2rek/brickwall/bwall_log_1.mdl" },
    ["Пластик"] = { "models/2rek/brickwall/bwall_plastic_1.mdl" },
    --
    ["Селитра"] = { "models/props_junk/cardboard_box004a.mdl" },
    ["Провода"] = { "models/illusion/eftcontainers/powercord.mdl" },
    ["Органика"] = { "models/weapons/w_bugbait.mdl", Color( 185, 236, 216 ) },
    --
    ["Механ. части"] = { "models/illusion/eftcontainers/weaponparts.mdl" },
    ["Электроника"] = { "models/illusion/eftcontainers/militaryboard.mdl" },
    ["Оружейное масло"] = { "models/props_junk/glassjug01.mdl", Color( 204, 203, 209 ) },
    ["Чертежный лист"] = { "models/illusion/eftcontainers/intel.mdl", Color( 230, 217, 154 ) },
    ["Оружейный порох"] = { "models/illusion/eftcontainers/gpred.mdl" },
    --
    ["Алюминий"] = { "models/illusion/eftcontainers/plexiglass.mdl", Color( 242, 248, 255 ) },
    ["Латунь"] = { "models/props_junk/garbage_metalcan002a.mdl", Color( 197, 172, 122 ) },
    ["Титан"] = { "models/2rek/brickwall/bwall_ore_1.mdl", Color( 78, 73, 112 ) },
    ["Медь"] = { "models/2rek/brickwall/bwall_ore_1.mdl", Color( 252, 175, 98 ) },
}
BRICKS_SERVER.BASECONFIG.CRAFTING.Blueprints = { -- ["blueprint key(max 18 chars)"] = {"model", maxuseamount, useamount, "Name"}
--wep
    --["СхемаРамаПист"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема рамы Пистолета" },
    --["СхемаСтволПист"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема ствола Пистолета" },
    --["СхемаЗатворПист"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема затвора Пистолета" },
    ["СхемаM1911"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема M1911" },
    ["СхемаDeagle"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема Desert Eagle" },
    --
    --["СхемаРамаРев"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема рамы Револьвера" },
    --["СхемаСтволРев"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема ствола Револьвера" },
    --["СхемаБарабанРев"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема барабана Револьвера" },
    ["СхемаРев329"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема Револьвера 329" },
    --
    --["СхемаРамаПиПул"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема рамы Пистолета-пулемета" },
    --["СхемаСтволПиПул"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема ствола Пистолета-пулемета" },
    --["СхемаЗатворПиПул"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема затвора Пистолета-пулемета" },
    ["СхемаUZI"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Uzi" },
    --
    --["СхемаРамаВинт"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема рамы Винтовки" },
    --["СхемаСтволВинт"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема ствола Винтовки" },
    --["СхемаЗатворВинт"] = { "models/props_lab/clipboard.mdl", 3, 3, "Схема затвора Винтовки" },
    ["СхемаAKM"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема AKM" },
    ["Схемаg3a3"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема G3A3" },
    ["Схемаmini14"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Mini-14" },
    --
    --["СхемаРамаСнайп"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема рамы Снайп. винтовки" },
    --["СхемаСтволСнайп"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема ствола Снайп. винтовки" },
    --["СхемаЗатворСнайп"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема затвора Снайп. винтовки" },
    ["Схемаawm"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема AWM" },
    --
    --["СхемаРамаДроб"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема рамы Дробовика" },
    --["СхемаСтволДроб"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема ствола Дробовика" },
    --["СхемаЗатворДроб"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема затвора Дробовика" },
    ["Схемаrem870"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Remington 870" },
    ["Схемаizh158"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема IZh-158" },
    --
    ["СхемаМ79"] = { "models/props_lab/clipboard.mdl", 1, 1, "Схема M79" },
--tools
    ["СхемаОтвертка"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Отвертки" },
    ["СхемаПаяльник"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Паяльника" },
    ["СхемаФильтр"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Фильтра" },
    ["СхемаДрель"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Дрели" },
    ["СхемаГаечКлюч"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Гаечного ключа" },
    ["СхемаОруНаб"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Оружейного набора" },
    ["СхемаНабХим"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Набора химика" },
    ["СхемаИнжНаб"] = { "models/props_lab/clipboard.mdl", 2, 2, "Схема Инженерного набора" },
--res
    ["СхемаМехЧасти"] = { "models/props_lab/clipboard.mdl", 10, 10, "Схема Механ. частей" },
    ["СхемаЭлек"] = { "models/props_lab/clipboard.mdl", 10, 10, "Схема Электроники" },
    ["СхемаОружМасл"] = { "models/props_lab/clipboard.mdl", 10, 10, "Схема Оружейного масла" },
    ["СхемаОружПорох"] = { "models/props_lab/clipboard.mdl", 10, 10, "Схема Оружейного пороха" },
}
BRICKS_SERVER.BASECONFIG.CRAFTING.CraftTools = { -- ["tool key"] = {"model", "name"} 
    ["Отвертка"] = { "models/illusion/eftcontainers/screwdriver.mdl", "Отвертка" },
    ["Паяльник"] = { "models/illusion/eftcontainers/thermometer.mdl", "Паяльник" },
    ["Фильтр"] = { "models/illusion/eftcontainers/powerfilter.mdl", "Фильтр" },
    ["Дрель"] = { "models/illusion/eftcontainers/electricdrill.mdl", "Дрель" },
    ["Гаечный ключ"] = { "models/illusion/eftcontainers/wrench.mdl", "Гаечный ключ" },
    ["Оружейный набор"] = { "models/illusion/eftcontainers/weprepair.mdl", "Оружейный набор" },
    ["Набор химика"] = { "models/illusion/eftcontainers/sicccase.mdl", "Набор химика" },
    ["Инженерный набор"] = { "models/illusion/eftcontainers/toolset.mdl", "Инженерный набор" },
}
BRICKS_SERVER.BASECONFIG.CRAFTING.Craftables = {
--[[
    [1] = {
        Name = "Ak-47",
        Type = "Weapon",
        ReqInfo = { "weapon_ak472" },
        Blueprints = { ["name"] = true, }
        Resources = { ["Wood"] = 5, ["Iron"] = 2 },
        Model = "models/weapons/w_rif_ak47.mdl",
        Level = 3,
        CraftTime = 5
    },
    [2] = {
        Name = "M4A1",
        Type = "Weapon",
        ReqInfo = { "weapon_m42" },
        Resources = { ["Wood"] = 15, ["Iron"] = 1 },
        Model = "models/weapons/w_rif_m4a1.mdl",
        CraftTime = 2
    },
    --wep
        [3] = {
            Name = "AKM",
            Type = "Weapon",
            ReqInfo = { "name" , 1 , false },
            Resources = { ["name"] = 15, ["name"] = 1 },
            CraftTools = { ["name"] = true, ["name2"] = true },
            Blueprints = { ["name"] = true, ["name2"] = true },
            Model = "models/weapons/w_rif_ak47.mdl",
            CraftTime = 5
            Level = 1

        }

            ["Blueprints"]:
                    ["СхемаAKM"]    =   true
                    ["СхемаЗатворВинт"] =   true
                    ["СхемаРамаВинт"]   =   true
                    ["СхемаСтволВинт"]  =   true
            ["CraftTime"]   =   7
            ["CraftTools"]:
                    ["Инженерный набор"]    =   true
                    ["Оружейный набор"] =   true
            ["Level"]   =   1
            ["Model"]   =   models/weapons/arccw/c_ur_ak.mdl
            ["Name"]    =   AKM
            ["ReqInfo"]:
                    [1] =   arccw_ur_ak
                    [2] =   1
                    [3] =   false
            ["Resources"]:
                    ["Древесина"]   =   1
                    ["Механ. части"]    =   2
                    ["Оружейное масло"] =   1
                    ["Титан"]   =   1
            ["Type"]    =   Weapon

    [4]:
            ["Blueprints"]:
                    ["СхемаНабХим"] =   true
            ["CraftTime"]   =   7
            ["CraftTools"]:
                    ["Фильтр"]  =   true
            ["Level"]   =   1
            ["Model"]   =   models/illusion/eftcontainers/sicccase.mdl
            ["Name"]    =   Набор химика
            ["ReqInfo"]:
                    [1] =   Набор химика
                    [2] =   1
            ["Resources"]:
                    ["Алюминий"]    =   1
                    ["Органика"]    =   3
                    ["Пластик"] =   1
            ["Type"]    =   Craft Tool
            ["key"] =   4
--]]
}
BRICKS_SERVER.BASECONFIG.CRAFTING.RockTypes = {
--[[
    ["Iron"] = 75,
    ["Diamond"] = 3,
    ["Ruby"] = 7
--]]
}
BRICKS_SERVER.BASECONFIG.CRAFTING.TreeTypes = {
--[[
    ["Wood"] = 75
--]]
}
BRICKS_SERVER.BASECONFIG.CRAFTING.GarbageTypes = {
--[[
    ["Plastic"] = 80,
    ["Scrap"] = 10
--]]
}
BRICKS_SERVER.BASECONFIG.CRAFTING.Skills = {
--[[
    ["woodcutting"] = {
        MaxLevel = 50,
        BaseExperience = 100,
        ExpMultiplier = 1.5
    }
--]]
}

--[[ NPCS ]]--
BRICKS_SERVER.BASECONFIG.NPCS = BRICKS_SERVER.BASECONFIG.NPCS or {}
--[[
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "Скупщик",
    Type = "Trader",
    ReqInfo = { 1 },
    Buying = {}
} )
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "Аукцион",
    Type = "Marketplace"
} )
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "Bank",
    Type = "Bank"
} )
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "Money Launderer",
    Type = "Money Launderer"
} )
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "Deathscreens",
    Type = "Deathscreens"
} )
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "SWEP Upgrader",
    Type = "SWEP Upgrader"
} )
--]]
--[[ MARKETPLACE ]]--
BRICKS_SERVER.BASECONFIG.MARKETPLACE = {}
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Currency"] = "darkrp_money"
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Minimum Starting Price"] = 50
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Minimum Auction Time"] = 300
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Maximum Auction Time"] = 86400
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Minimum Bid Increment"] = 1.1
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Can Players Cancel Auction"] = true
BRICKS_SERVER.BASECONFIG.MARKETPLACE["Remove After Auction End Time"] = 259200

--[[ BANK VAULT ]]--
BRICKS_SERVER.BASECONFIG.BANKVAULT = {}
BRICKS_SERVER.BASECONFIG.BANKVAULT["Money Bags"] = 3
BRICKS_SERVER.BASECONFIG.BANKVAULT["Police Requirement"] = 0
BRICKS_SERVER.BASECONFIG.BANKVAULT["Robbery Cooldown"] = 15
BRICKS_SERVER.BASECONFIG.BANKVAULT["Alarm Duration"] = 5
BRICKS_SERVER.BASECONFIG.BANKVAULT["Open Time"] = 45
BRICKS_SERVER.BASECONFIG.BANKVAULT["Money Bag Amount"] = { 100000, 150000 }
BRICKS_SERVER.BASECONFIG.BANKVAULT["Dirty To Clean Money Multiplier"] = { 0.9, 1.1 }
BRICKS_SERVER.BASECONFIG.BANKVAULT["Pins Required"] = 3
BRICKS_SERVER.BASECONFIG.BANKVAULT["Can Pickup Multiple Bags"] = false
BRICKS_SERVER.BASECONFIG.BANKVAULT.RobberTeams = {}
BRICKS_SERVER.BASECONFIG.BANKVAULT.PoliceJobs = {}

--[[ ARMORY ]]--
BRICKS_SERVER.BASECONFIG.ARMORY = {}
BRICKS_SERVER.BASECONFIG.ARMORY["Police Requirement"] = 6
BRICKS_SERVER.BASECONFIG.ARMORY["Robbery Cooldown"] = 600
BRICKS_SERVER.BASECONFIG.ARMORY["Open Time"] = 60
BRICKS_SERVER.BASECONFIG.ARMORY["Reward Money"] = { 5000, 10000 }
BRICKS_SERVER.BASECONFIG.ARMORY["Shipment Reward Amount"] = { 2, 5 }
BRICKS_SERVER.BASECONFIG.ARMORY["Fail Cooldown"] = 600
BRICKS_SERVER.BASECONFIG.ARMORY.RewardShipments = {
    ["Glock"] = true,
    ["MP5A4"] = true,
    ["Benelli M4"] = true,
    ["SPAS-12"] = true,
    ["M16"] = true

}
BRICKS_SERVER.BASECONFIG.ARMORY.RobberTeams = {
    ["11124rrrrg"] = true,-- Бандит
    ["11124rr4rrg"] = true,-- Взломщик
    ["11124rr45rrg"] = true,-- Грабитель
    ["123tggfa"] = true,-- Мафиози
    ["123tggf1a"] = true,-- Головорез
    ["p1gbged"] = true,-- Наемник мародер
    ["ofsdaef"] = true,-- Хакер взломщик
    ["isdfgs"] = true,-- Оператор ЧВК
    ["qssw"] = true-- Бегущий
}

BRICKS_SERVER.BASECONFIG.ARMORY.PoliceJobs = {
    ["usdbsdgar"] = true,-- патрул полиция
    ["ybsdxce"] = true,-- детектив
    ["tsdg444"] = true,-- спецназ
    ["rsdffggggbn"] = true,-- дизаг спецназ
    ["wkloldd"] = true-- отдел Контрразведки
}

BRICKS_SERVER.BASECONFIG.ARMORY.Items = {
	[1] = {
        Name = "Glock",
        Category = "Оружие",
        Type = "Weapon",
        ReqInfo = { "arccw_ud_glock" },
		Model = "models/weapons/arccw/c_ud_glock.mdl"
	},
	[2] = {
        Name = "MP5A4",
        Category = "Оружие",
        Type = "Weapon",
        ReqInfo = { "arccw_ur_mp5" },
		Model = "models/weapons/arccw/c_ur_mp5.mdl",
        Level = 25
	},
	[3] = {
        Name = "Benelli M4",
        Category = "Оружие",
        Type = "Weapon",
        ReqInfo = { "arccw_ud_m1014" },
		Model = "models/weapons/arccw/c_ud_m1014.mdl",
        Level = 20
	},
    [4] = {
        Name = "SPAS-12",
        Category = "Оружие",
        Type = "Weapon",
        ReqInfo = { "arccw_ur_spas12" },
        Model = "models/weapons/arccw/c_ur_spas12.mdl",
        Level = 30,
        Restrictions = { 
            ["ybsdxce"] = true,--["Детектив / 30 lvl"] = true, 
            ["tsdg444"] = true,--["Спецназ CTSFO / 25 lvl"] = true,
            ["rsdffggggbn"] = true,--["Отдел Disag [Dis+] / 35 lvl"] = true,
            ["wkloldd"] = true--["Отдел Контрразведки MI5 [Dis+] / 35 lvl"] = true
        }
    },
    [5] = {
        Name = "M16A2",
        Category = "Оружие",
        Type = "Weapon",
        ReqInfo = { "arccw_ud_m16" },
        Model = "models/weapons/arccw/c_ud_m16.mdl",
        Level = 30,
        Restrictions = { 
            ["tsdg444"] = true,--["Спецназ CTSFO / 30 lvl"] = true,
            ["rsdffggggbn"] = true,--["Отдел Disag [Dis+] / 45 lvl"] = true,
            ["wkloldd"] = true--["Отдел Контрразведки MI5 [Dis+] / 45 lvl"] = true
        }
    },
    [6] = {
        Name = "Shield",
        Category = "Снаряжение",
        Type = "Weapon",
        ReqInfo = { "arccw_go_shield" },
        Model = "models/weapons/arccw_go/v_shield.mdl",
        Level = 30
    },
    [7] = {
        Name = "M84 Stun",
        Category = "Гранаты",
        Type = "Weapon",
        ReqInfo = { "arccw_go_nade_flash" },
        Model = "models/weapons/arccw_go/w_eq_flashbang_thrown.mdl",
        Level = 20
    },
    [8] = {
        Name = "Model 5210 Smoke",
        Category = "Гранаты",
        Type = "Weapon",
        ReqInfo = { "arccw_go_nade_smoke" },
        Model = "models/weapons/arccw_go/w_eq_smokegrenade_thrown.mdl",
        Level = 30,
        Restrictions = {
            ["ybsdxce"] = true,--["Детектив / 35 lvl"] = true, 
            ["tsdg444"] = true,--["Спецназ CTSFO / 30 lvl"] = true,
            ["rsdffggggbn"] = true,--["Отдел Disag [Dis+] / 45 lvl"] = true,
            ["wkloldd"] = true--["Отдел Контрразведки MI5 [Dis+] / 45 lvl"] = true
        }
    },
    [9] = {
        Name = "AN/M14 Thermite",
        Category = "Гранаты",
        Type = "Weapon",
        ReqInfo = { "arccw_go_nade_incendiary" },
        Model = "models/weapons/arccw_go/w_eq_incendiarygrenade_thrown.mdl",
        Level = 30,
        Restrictions = { 
            ["tsdg444"] = true,--["Спецназ CTSFO / 30 lvl"] = true,
            ["rsdffggggbn"] = true,--["Отдел Disag [Dis+] / 45 lvl"] = true,
            ["wkloldd"] = true--["Отдел Контрразведки MI5 [Dis+] / 45 lvl"] = true
        }
    },
    [10] = {
        Name = "M67 Frag",
        Category = "Гранаты",
        Type = "Weapon",
        ReqInfo = { "arccw_go_nade_frag" },
        Model = "models/weapons/arccw_go/w_eq_fraggrenade_thrown.mdl",
        Level = 30,
        Restrictions = { 
            ["tsdg444"] = true,--["Спецназ CTSFO / 30 lvl"] = true,
            ["rsdffggggbn"] = true,--["Отдел Disag [Dis+] / 45 lvl"] = true,
            ["wkloldd"] = true--["Отдел Контрразведки MI5 [Dis+] / 45 lvl"] = true
        }
    },
	[11] = {
        Name = "Pistol Ammo",
        Category = "Патроны",
        Type = "Ammo",
        ReqInfo = { "Pistol", 20, 60 },
		Model = "models/items/arccw/pistol_ammo.mdl"
	},
	[12] = {
        Name = "SMG Ammo",
        Category = "Патроны",
        Type = "Ammo",
        ReqInfo = { "SMG1", 30, 90 },
		Model = "models/items/arccw/smg_ammo.mdl",
        Level = 25
	},
    [13] = {
        Name = "Buckshot",
        Category = "Патроны",
        Type = "Ammo",
        ReqInfo = { "Buckshot", 20, 40 },
        Model = "models/items/arccw/shotgun_ammo.mdl",
        Level = 20
    },
    [14] = {
        Name = "AR Ammo",
        Category = "Патроны",
        Type = "Ammo",
        ReqInfo = { "AR2", 30, 120 },
        Model = "models/items/arccw/rifle_ammo.mdl",
        Level = 30
    },
	[15] = {
        Name = "Облегчённый бронежилет",
        Category = "Снаряжение",
        Type = "Armor",
        ReqInfo = { 25 },
        Model = "models/Items/battery.mdl",
        Level = 15
    },
	[16] = {
		Name = "Обычный бронежилет",
        Category = "Снаряжение",
        Type = "Armor",
        ReqInfo = { 75 },
		Model = "models/Items/battery.mdl",
		Level = 30
	},
	[17] = {
		Name = "Тяжелый бронежилет",
        Category = "Снаряжение",
        Type = "Armor",
        ReqInfo = { 125 },
		Model = "models/Items/battery.mdl",
		Level = 45
	}
}

--[[ BOSSES ]]--
BRICKS_SERVER.BASECONFIG.BOSS = {}
BRICKS_SERVER.BASECONFIG.BOSS["Damage Update Time"] = 1
BRICKS_SERVER.BASECONFIG.BOSS["Boss Bar Display Distance"] = 500
BRICKS_SERVER.BASECONFIG.BOSS.NPCs = {}
--[[
BRICKS_SERVER.BASECONFIG.BOSS.NPCs[1] = {
    Name = "MINI ZOMBIE BOSS",
    Model = "models/zombie/classic.mdl",
    Class = "npc_zombie",
    Health = 15000,
    Scale = 2,
    DamageScale = 10,
    Loot = {
        [1] = {
            Chance = 100,
            Name = "100 EXP",
            Icon = "https://i.imgur.com/8gXiMxX.png",
            Type = "Experience",
            ReqInfo = { 100 }
        },
        [2] = {
            Chance = 100,
            Name = "$1,000",
            Model = "models/props/cs_assault/money.mdl",
            Type = "Money",
            ReqInfo = { 1000 }
        },
        [3] = {
            Chance = 10,
            Name = "1K EXP",
            Icon = "https://i.imgur.com/8gXiMxX.png",
            Type = "Experience",
            ReqInfo = { 1000 }
        },
        [4] = {
            Chance = 10,
            Name = "$10,000",
            Model = "models/props/cs_assault/money.mdl",
            Type = "Money",
            ReqInfo = { 10000 }
        },
        [5] = {
            Chance = 50,
            Name = "AK47",
            Model = "models/weapons/w_rif_ak47.mdl",
            Type = "Weapon",
            ReqInfo = { "weapon_ak472", 1 }
        }
    }
}
--]]
--[[
--[[ DEATHSCREENS
BRICKS_SERVER.BASECONFIG.DEATHSCREENS = {}
BRICKS_SERVER.BASECONFIG.DEATHSCREENS["Default Playercard"] = "https://i.imgur.com/dJ71grf.png"
BRICKS_SERVER.BASECONFIG.DEATHSCREENS.Cards = {
    ["parasyte"] = {
        Name = "Parasyte",
        Category = "Anime",
        Image = "https://i.imgur.com/dhEmnBP.jpg",
        Price = 5000
    },
    ["neoncity"] = {
        Name = "Neon City",
        Category = "Anime",
        GIF = "https://i.imgur.com/zB4VNmi.gif",
        Price = 25000
    },
    ["oneinthechamber"] = {
        Name = "One in the chamber",
        Category = "Call of duty",
        Image = "https://i.imgur.com/jjnFoB5.png",
        Price = 15000
    },
    ["420blazeit"] = {
        Name = "420 Blaze it",
        Category = "Call of duty",
        Image = "https://i.imgur.com/gmYJ39L.png"
    },
    ["oof"] = {
        Name = "Oof",
        Category = "Call of duty",
        Image = "https://i.imgur.com/uWB78JO.png",
        Price = 25000
    },
    ["tankman"] = {
        Name = "Tank Man",
        Category = "Call of duty",
        Image = "https://i.imgur.com/Bx7u4cW.png",
        Price = 5000000
    },
    ["floater"] = {
        Name = "Floater",
        Category = "Call of duty",
        GIF = "https://i.imgur.com/pVUuorQ.gif",
        Level = 5
    },
    ["rocketman"] = {
        Name = "Rocket Man",
        Category = "Call of duty",
        GIF = "https://i.imgur.com/qAr5vRj.gif",
        Group = "VIP++"
    },
    ["mandown"] = {
        Name = "Man Down",
        Category = "Call of duty",
        GIF = "https://i.imgur.com/CSkeIBj.gif",
        Group = "VIP++"
    }
}
BRICKS_SERVER.BASECONFIG.DEATHSCREENS.Emblems = {
    ["abrickinawall"] = {
        Name = "A brick in a wall",
        Image = "https://i.imgur.com/isxAKMU.png",
		Group =	"VIP++",
		Level =	10
    },
    ["ak-47"] = {
        Name = "AK-47",
        Image = "https://i.imgur.com/V3aKj7G.png",
		Price =	50000
    },
    ["deadpool"] = {
        Name = "Deadpool",
        Image = "https://i.imgur.com/O5ID452.png",
		Price =	50000
    },
    ["weeaboo"] = {
        Name = "Weeaboo",
        Category = "Anime",
        Image = "https://i.imgur.com/YrXklOK.png",
        Level = 10,
        Group = "VIP++"
    },
    ["parasyte"] = {
        Name = "Parasyte",
        Category = "Anime",
        Image = "https://i.imgur.com/A2ogFMt.png",
        Level = 15,
        Group = "VIP++"
    },
    ["wyvernknight"] = {
        Name = "Wyvern Knight",
        GIF = "https://i.imgur.com/YIlZdsu.gif",
        Price = 56000
    }
}
BRICKS_SERVER.BASECONFIG.DEATHSCREENS.Soundtracks = {
    ["parasyte"] = {
        Name = "Parasyte",
        Category = "Anime",
        Sound = "https://sndup.net/64vg/parasyte.wav",
        Price = 5000
    },
    ["helix"] = {
        Name = "Helix",
        Sound = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        Level = 5,
        Group = "VIP++"
    }
}

BRICKS_SERVER.BASECONFIG.SWEPUPGRADES = {}
BRICKS_SERVER.BASECONFIG.SWEPUPGRADES.BaseUpgradeAmounts = 5
BRICKS_SERVER.BASECONFIG.SWEPUPGRADES.BasePrice = 10000
BRICKS_SERVER.BASECONFIG.SWEPUPGRADES.PriceIncrease = 2.5
BRICKS_SERVER.BASECONFIG.SWEPUPGRADES.UpgradeAmounts = {
    ["ls_sniper"] = 3
}
BRICKS_SERVER.BASECONFIG.SWEPUPGRADES.IncreasePercent = {
    ["Damage"] = 1,
    ["ClipSize"] = 5,
    ["Recoil"] = 1
}
BRICKS_SERVER.BASECONFIG.SWEPUPGRADES.Blacklist = {
    ["weapon_keypadchecker"] = true,
    ["arrest_stick"] = true,
    ["door_ram"] = true,
    ["keys"] = true,
    ["lockpick"] = true,
    ["med_kit"] = true,
    ["pocket"] = true,
    ["stunstick"] = true,
    ["unarrest_stick"] = true,
    ["weaponchecker"] = true,
    ["weapon_physcannon"] = true,
    ["gmod_camera"] = true,
    ["manhack_welder"] = true,
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true,
    ["bricks_server_invpickup"] = true,
    ["bricks_server_axe"] = true,
    ["bricks_server_pickaxe"] = true
}
--]]