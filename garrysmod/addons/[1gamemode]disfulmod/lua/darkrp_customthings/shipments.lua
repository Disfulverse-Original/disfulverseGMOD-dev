--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]


-- Продавец оружия

DarkRP.createShipment("M1911 [x3]", {
    entity = "arccw_ur_m1911",
    model = "models/weapons/arccw/c_ur_m1911.mdl",
    amount = 3,
    price = 6000,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_PRODOR
    },
})

DarkRP.createShipment("Remington 870 [x3]", {
    entity = "arccw_ud_870",
    model = "models/weapons/arccw/c_ud_870.mdl",
    amount = 3,
    price = 12000,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_PRODOR
    },
})

DarkRP.createShipment("G3A3 [x3]", {
    entity = "arccw_ur_g3",
    model = "models/weapons/arccw/c_ur_g3.mdl",
    amount = 3,
    price = 14550,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_PRODOR
    },
})

-- Продавец оружия



-- Контрабандист

DarkRP.createShipment("Desert Eagle [x3]", {
    entity = "arccw_ur_deagle",
    model = "models/weapons/arccw/c_ud_deagle.mdl",
    amount = 3,
    pricesep = 10200,
    price = 10200,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_ZARUB
    },
})
DarkRP.createShipment("AWM [x3]", {
    entity = "arccw_ur_aw",
    model = "models/weapons/arccw/c_ur_aw.mdl",
    amount = 3,
    pricesep = 21000,
    price = 21000,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_ZARUB
    },
})
DarkRP.createShipment("MINI14 [x3]", {
    entity = "arccw_ud_mini14",
    model = "models/weapons/arccw/c_ud_mini14.mdl",
    amount = 3,
    pricesep = 15750,
    price = 15750,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_ZARUB
    },
})

-- Контрабандист


-- Барахольщик

DarkRP.createShipment("AKM [x5]", {
    entity = "arccw_ur_ak",
    model = "models/weapons/arccw/c_ur_ak.mdl",
    amount = 5,
    pricesep = 7500,
    price = 7500,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_BARACH
    },
})
DarkRP.createShipment("M79 [x1]", {
    entity = "arccw_ud_m79",
    model = "models/weapons/arccw/c_ud_m79.mdl",
    amount = 1,
    pricesep = 4750,
    price = 4750,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_BARACH
    },
})
DarkRP.createShipment("UZI [x1]", {
    entity = "arccw_ud_uzi",
    model = "models/weapons/arccw/c_ud_uzi.mdl",
    amount = 3,
    pricesep = 6750,
    price = 6750,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_BARACH
    },
})
DarkRP.createShipment("IZh-58 [x3]", {
    entity = "arccw_ur_db",
    model = "models/weapons/arccw/c_ur_dbs.mdl",
    amount = 3,
    pricesep = 4500,
    price = 4500,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_BARACH
    },
})
DarkRP.createShipment("Model 329PD [x3]", {
    entity = "arccw_ur_329",
    model = "models/weapons/arccw/c_ur_329pd.mdl",
    amount = 3,
    pricesep = 6000,
    price = 6000,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_BARACH
    },
})
-- Барахольщик


-- Полицейские


DarkRP.createShipment("Glock", {
    entity = "arccw_ud_glock",
    model = "models/weapons/arccw/c_ud_glock.mdl",
    amount = 0,
    pricesep = 9999999999999,
    price = 9999999999999999,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_STAFF
    },
})
DarkRP.createShipment("MP5A4", {
    entity = "arccw_ur_mp5",
    model = "models/weapons/arccw/c_ur_mp5.mdl",
    amount = 0,
    pricesep = 99999999999,
    price = 99999999999,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_STAFF
    },
})
DarkRP.createShipment("Benelli M4", {
    entity = "arccw_ud_m1014",
    model = "models/weapons/arccw/c_ud_m1014.mdl",
    amount = 0,
    pricesep = 99999999999,
    price = 999999999999,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_STAFF
    },
})
DarkRP.createShipment("SPAS-12", {
    entity = "arccw_ur_spas12",
    model = "models/weapons/arccw/c_ur_spas12.mdl",
    amount = 0,
    pricesep = 99999999999,
    price = 99999999999,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_STAFF
    },
})
DarkRP.createShipment("M16", {
    entity = "arccw_ud_m16",
    model = "models/weapons/arccw/c_ud_m16.mdl",
    amount = 0,
    pricesep = 99999999999,
    price = 99999999999,
    noship = false,
    separate = false,
    category = "Вооружение",
    allowed = {
        TEAM_STAFF
    },
})
-- Полицейские