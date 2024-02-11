--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

-- Продавец оружия

--Resources
DarkRP.createEntity("Механические Части", {
    ent = "bricks_server_resource_Механ.Части",
    cmd = "fasdfg325n3jh5132",
    model = "models/2rek/brickwall/bwall_scrap_1.mdl",
    price = 1000,
    max = 0,
    allowed = {
        TEAM_PRODOR
    },
    category = "Ресурсы",
})
DarkRP.createEntity("Железо", {
    ent = "bricks_server_resource_Железо",
    cmd = "fasdfg3ds25n3jh5132",
    model = "models/2rek/brickwall/bwall_ore_1.mdl",
    price = 50,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB
    },
    category = "Ресурсы",
})
DarkRP.createEntity("Оружейное Масло", {
    ent = "bricks_server_resource_ОружейноеМасло",
    cmd = "fasdfg32gfd5n3jh5132",
    model = "models/props_junk/glassjug01.mdl",
    price = 750,
    max = 0,
    allowed = {
        TEAM_PRODOR
    },
    category = "Ресурсы",
})
DarkRP.createEntity("Порох", {
    ent = "bricks_server_resource_Порох",
    cmd = "fasdfg32asdsdf5n3jh5132",
    model = "models/props_junk/cardboard_box004a.mdl",
    price = 150,
    max = 0,
    allowed = {
        TEAM_PRODOR
    },
    category = "Ресурсы",
})
-- Продавец оружия







-- Контрабандист

--Resources
DarkRP.createEntity("Электроника", {
    ent = "bricks_server_resource_Электроника",
    cmd = "fasdfg32asdsdfd5n3jh5132",
    model = "models/props/cs_office/computer_caseb_p3a.mdl",
    price = 750,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Ресурсы",
})
DarkRP.createEntity("Пластик", {
    ent = "bricks_server_resource_Пластик",
    cmd = "fasdfg32asdsdfd5n3jh5f132",
    model = "models/2rek/brickwall/bwall_plastic_1.mdl",
    price = 50,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Ресурсы",
})
DarkRP.createEntity("Провода", {
    ent = "bricks_server_resource_Провода",
    cmd = "fasdfg32asdsdfd5n3jh25f132",
    model = "models/Items/CrossbowRounds.mdl",
    price = 100,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Ресурсы",
})
--т1 кирка,топор
DarkRP.createEntity("Титан", {
    ent = "bricks_server_resource_Титан",
    cmd = "fasdfg32asdsdfd5n3jh25f1432",
    model = "models/2rek/brickwall/bwall_ore_1.mdl",
    price = 500,
    max = 0,
    allowed = {
        TEAM_ZARUB, TEAM_BARACH
    },
    category = "Ресурсы",
})

-- Attachments
DarkRP.createEntity("Holosun HS510C [1x ZOOM]", {
    ent = "acwatt_uc_optic_holosun2",
    cmd = "123142pricel1",
    model = "models/Items/item_item_crate.mdl",
    price = 1050,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Оптика",
})
DarkRP.createEntity("EOTECH 553 [1x ZOOM]", {
    ent = "acwatt_uc_optic_eotech553",
    cmd = "pricel3",
    model = "models/Items/item_item_crate.mdl",
    price = 1050,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Оптика",
})
DarkRP.createEntity("HAMR HYBRYD [1-3x ZOOM]", {
    ent = "acwatt_uc_optic_hamr",
    cmd = "pricel4",
    model = "models/Items/item_item_crate.mdl",
    price = 1850,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Оптика",
})
DarkRP.createEntity("EOTECH ACOG [4x ZOOM]", {
    ent = "acwatt_uc_optic_acog",
    cmd = "1667547pricel3",
    model = "models/Items/item_item_crate.mdl",
    price = 1950,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Оптика",
})
DarkRP.createEntity("TARS [3-8x ZOOM]", {
    ent = "acwatt_uc_optic_trijicon_tars",
    cmd = "1667547pricel6",
    model = "models/Items/item_item_crate.mdl",
    price = 2700,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Оптика",
})
--ammo type
DarkRP.createEntity(".357 Magnum [Deagle]", {
    ent = "acwatt_ur_deagle_caliber_357",
    cmd = "1667547pricel7",
    model = "models/Items/item_item_crate.mdl",
    price = 1350,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity(".338 Lapua Magnum [AWM]", {
    ent = "acwatt_ur_aw_cal_338",
    cmd = "1667547pricel8",
    model = "models/Items/item_item_crate.mdl",
    price = 2200,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity("Magnum #000 Buckshot [SHOTGUN]", {
    ent = "acwatt_uc_ammo_sg_magnum",
    cmd = "16467547dspricel8",
    model = "models/Items/item_item_crate.mdl",
    price = 2200,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity("AP/ARMOR-PIERCING [ARs]", {
    ent = "acwatt_uc_ammo_ap",
    cmd = "1667547pricel9",
    model = "models/Items/item_item_crate.mdl",
    price = 1850,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity(".45 ACP [Uzi]", {
    ent = "acwatt_ud_uzi_cal_45",
    cmd = "1667547pricel11",
    model = "models/Items/item_item_crate.mdl",
    price = 1850,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity(".45 ACP [Glock]", {
    ent = "acwatt_ud_glock_caliber_45acp",
    cmd = "1667547pricel12",
    model = "models/Items/item_item_crate.mdl",
    price = 1850,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity("10mm Auto [Glock]", {
    ent = "acwatt_ud_glock_caliber_10auto",
    cmd = "1667547pricel13",
    model = "models/Items/item_item_crate.mdl",
    price = 2100,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
DarkRP.createEntity(".44 Snakeshot [Revolver]", {
    ent = "acwatt_ur_329_caliber_snakeshot",
    cmd = "1667547pricel14",
    model = "models/Items/item_item_crate.mdl",
    price = 2150,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Типы патронов",
})
--atts
DarkRP.createEntity("PBS-1 Silencer [AKM]", {
    ent = "acwatt_uc_muzzle_supp_pbs1",
    cmd = "1667547pricel15",
    model = "models/Items/item_item_crate.mdl",
    price = 1500,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Модификации",
})
DarkRP.createEntity("Lighthouse Silencer [M16A2]", {
    ent = "acwatt_uc_muzzle_supp_lighthouse",
    cmd = "1667547pricel16",
    model = "models/Items/item_item_crate.mdl",
    price = 1500,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Модификации",
})
DarkRP.createEntity("60-round Cascet Mag [M16A2]", {
    ent = "acwatt_ud_m16_mag_60",
    cmd = "1667547pric51el17",
    model = "models/Items/item_item_crate.mdl",
    price = 1750,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Модификации",
})
DarkRP.createEntity("Dong Foregrip [AKM]", {
    ent = "acwatt_ur_ak_hg_dong",
    cmd = "1667547pricel51",
    model = "models/Items/item_item_crate.mdl",
    price = 1750,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Модификации",
})
DarkRP.createEntity("KAC Vertical Foregrip [All]", {
    ent = "acwatt_uc_grip_kacvfg",
    cmd = "1667547pricel52",
    model = "models/Items/item_item_crate.mdl",
    price = 1750,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Модификации",
})
DarkRP.createEntity("Magpul Angled Foregrip [All]", {
    ent = "acwatt_uc_grip_mafg2",
    cmd = "1667547pricel53",
    model = "models/Items/item_item_crate.mdl",
    price = 1750,
    max = 0,
    allowed = {
        TEAM_ZARUB
    },
    category = "Модификации",
})
-- Контрабандист






-- Ammo
DarkRP.createEntity("Carbine/SMG Ammo x60", {
    ent = "arccw_ammo_smg1",
    cmd = "1ammo1",
    model = "models/items/arccw/smg_ammo.mdl",
    price = 950,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH
    },
    category = "Аммуниция",
})
DarkRP.createEntity("Magnum Ammo x12", {
    ent = "arccw_ammo_357",
    cmd = "1ammo2",
    model = "models/items/arccw/magnum_ammo.mdl",
    price = 600,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH
    },
    category = "Аммуниция",
})
DarkRP.createEntity("Pistol Ammo x40", {
    ent = "arccw_ammo_pistol",
    cmd = "1ammo3",
    model = "models/items/arccw/pistol_ammo.mdl",
    price =650,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH
    },
    category = "Аммуниция",
})
DarkRP.createEntity("ARs/Rifle Ammo x30", {
    ent = "arccw_ammo_ar2",
    cmd = "1ammo4",
    model = "models/items/arccw/rifle_ammo.mdl",
    price = 900,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH
    },
    category = "Аммуниция",
})
DarkRP.createEntity("Shotgun Ammo x20", { 
    ent = "arccw_ammo_buckshot",
    cmd = "1ammo6",
    model = "models/items/arccw/shotgun_ammo.mdl",
    price = 1050,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH
    },
    category = "Аммуниция",
})
DarkRP.createEntity("Sniper Ammo x10", {
    ent = "arccw_ammo_sniper",
    cmd = "1ammo7",
    model = "models/items/arccw/sniper_ammo.mdl",
    price = 1350,
    max = 0,
    allowed = {
        TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH
    },
    category = "Аммуниция",
})
--grenade ammo барахольщик
DarkRP.createEntity("Grenade Launcher Ammo x1", {
    ent = "arccw_ammo_smg1_grenade",
    cmd = "1ammo5",
    model = "models/items/ar2_grenade.mdl",
    price = 1350,
    max = 0,
    allowed = {
        TEAM_BARACH
    },
    category = "Аммуниция",
})



-- Барахольщик

DarkRP.createEntity("Дерево", {
    ent = "bricks_server_resource_Дерево",
    cmd = "dereveo5",
    model = "models/2rek/brickwall/bwall_log_1.mdl",
    price = 50,
    max = 0,
    allowed = {
        TEAM_BARACH
    },
    category = "Ресурсы",
})
--т2 кирка,топор
DarkRP.createEntity("Сталь", {
    ent = "bricks_server_resource_Сталь",
    cmd = "dereve6",
    model = "models/phxtended/bar1x.mdl",
    price = 1000,
    max = 0,
    allowed = {
        TEAM_BARACH
    },
    category = "Ресурсы",
})
--т3 кирка,топор
DarkRP.createEntity("Латунь", {
    ent = "bricks_server_resource_Латунь",
    cmd = "dereve7",
    model = "models/props_junk/garbage_metalcan002a.mdl",
    price = 1500,
    max = 0,
    allowed = {
        TEAM_BARACH
    },
    category = "Ресурсы",
})
--т4 кирка,топор
DarkRP.createEntity("Амальгам", {
    ent = "bricks_server_resource_Амальгам",
    cmd = "dereve8",
    model = "models/props_junk/rock001a.mdl",
    price = 3000,
    max = 0,
    allowed = {
        TEAM_BARACH
    },
    category = "Ресурсы",
})
DarkRP.createEntity("Органика", {
    ent = "bricks_server_resource_Органика",
    cmd = "dereveo9",
    model = "models/props_c17/lamp001a.mdl",
    price = 350,
    max = 0,
    allowed = {
        TEAM_BARACH
    },
    category = "Ресурсы",
})

--хп и тд
DarkRP.createEntity("Стимулятор", {
    ent = "item_healthkit",
    cmd = "dergeveo1",
    model = "models/Items/HealthKit.mdl",
    price = 400,
    max = 0,
    allowed = {
        TEAM_BARACH,
        TEAM_DET
    },
    category = "Разное",
})
DarkRP.createEntity("Бронепластина", {
    ent = "item_battery",
    cmd = "derevgeo1",
    model = "models/Items/battery.mdl",
    price = 650,
    max = 0,
    allowed = {
        TEAM_BARACH,
        TEAM_DET
    },
    category = "Разное",
})

-- Барахольщик



-- Метоварщик

DarkRP.createEntity("Газ", {
    ent = "eml_gas",
    cmd = "gas5",
    model = "models/props_junk/propane_tank001a.mdl",
    price = 500,
    max = 3,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})
DarkRP.createEntity("Плита", {
    ent = "eml_gas",
    cmd = "plitastove6",
    model = "models/props_c17/furnitureStove001a.mdl",
    price = 7000,
    max = 1,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})

--kraft кристалл йод
DarkRP.createEntity("Соляная кислота", {
    ent = "eml_macid",
    cmd = "mac21id",
    model = "models/props_junk/garbage_plasticbottle001a.mdl",
    price = 750,
    max = 2,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})
DarkRP.createEntity("Жидкий йод", {
    ent = "eml_iodine",
    cmd = "iodin",
    model = "models/props_lab/jar01b.mdl",
    price = 500,
    max = 2,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})
DarkRP.createEntity("Вода", {
    ent = "eml_water",
    cmd = "wod312a",
    model = "models/props_junk/garbage_plasticbottle003a.mdl",
    price = 250,
    max = 2,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})
--крафт красный фосфор
DarkRP.createEntity("Жидкая сера", {
    ent = "eml_sulfur",
    cmd = "sulfir",
    model = "models/props_lab/jar01b.mdl",
    price = 500,
    max = 2,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})

-- крафт тейблы
DarkRP.createEntity("Банка", {
    ent = "eml_jar",
    cmd = "jararara2",
    model = "models/props_lab/jar01a.mdl",
    price = 1500,
    max = 1,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})
DarkRP.createEntity("Кастрюля под фосфор", {
    ent = "eml_pot",
    cmd = "poppoodt",
    model = "models/props_c17/metalpot001a.mdl",
    price = 2000,
    max = 1,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})
DarkRP.createEntity("Кастрюля под голубое небо", {
    ent = "eml_spot",
    cmd = "spoootptp",
    model = "models/props_c17/metalpot001a.mdl",
    price = 3500,
    max = 1,
    allowed = {
        TEAM_GROVER
    },
    category = "Метоварка",
})

-- Метоварщик