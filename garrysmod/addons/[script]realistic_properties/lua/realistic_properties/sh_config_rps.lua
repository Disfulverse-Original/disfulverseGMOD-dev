-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]
-------------------------------------------------------------------------------------------------------------------
------------------------------------------ Main Configuration ----------------------------------------------------- 
-------------------------------------------------------------------------------------------------------------------

Realistic_Properties = Realistic_Properties or {}

Realistic_Properties.Language = "ru" -- You can Choose fr , en , de, pl , ru , pt , tr , cn

Realistic_Properties.TypeProperties = { -- Type of Properties
    "Дом",
    "Квартира",
    "Забегаловка",
    "Мероприятие",
    "Ангар",
    "Ресторан",
    "Магазин",
}

Realistic_Properties.Sell = 30 -- Pourcent that recive player when he sell Property (%) 

Realistic_Properties.TimeToDelivery = 5 -- Time to delivery your entity (seconds)

Realistic_Properties.DayEqual = 1 -- If day = 1 (24h) , day = 0.5 (12h)

Realistic_Properties.MaxProperties = 2 -- How Much properties can buy player 

Realistic_Properties.NameDeliveryEnterprise = "Доставка" -- Name of the properties which delivery 

Realistic_Properties.CommandModification = "/rpsconfig" -- Command for the configuration of property 

Realistic_Properties.DistanceEnt = 200 -- Distance to spawn the entity which was delivery 

Realistic_Properties.Package = 3 -- How much order can do the player

Realistic_Properties.NameNpc = "Риелтор" -- Name of the NPC

Realistic_Properties.DoorsLock = true -- If all doors which is in the data was lock 

Realistic_Properties.EntitiesRemove = false -- If when the property was sell the entities are removed

Realistic_Properties.DeliverySystem = true -- true == Activate / false == Desactivate

Realistic_Properties.SaveProps = true -- Save props when the property is rented 

Realistic_Properties.SpawnProps = true -- Desactivate = false / Activate = true spawn props outside property

Realistic_Properties.MaxRentalDay = 25 -- Max Rental Day

Realistic_Properties.ModelOfTheBox = "models/kobralost/case/caseveeds.mdl" -- Model of the Delivery Box 

Realistic_Properties.Activate3D2DNpc = true -- Activate / Desactivate the 3D2D of the npc 

Realistic_Properties.Activate3D2DComputer = false -- Activate / Desactivate the 3D2D of the computer

Realistic_Properties.HudDoor = true -- Activate/Desactivate the HUD on the door  

Realistic_Properties.PlayerSeeOwner = true -- If the player can see the owner of the door  

Realistic_Properties.AdminCanSpawnProps = true -- If admins can spawn props outside his property 

Realistic_Properties.DefaultTheme = "lighttheme" -- You can choose darktheme/lighttheme

Realistic_Properties.OverridingF2 = true -- If you want than the player can't buy/sell property with f2 

Realistic_Properties.CanBuyPropertyWithF2 = false  -- When you buy a property with f2 all door will be buy
 
Realistic_Properties.PropsDelivery = true -- Delivery system for the props 

Realistic_Properties.PriceProps = 0 -- Price when you try to spawn a props with the props delivery system 

Realistic_Properties.EntityCompatibility = { -- Here is the entity which is compatible with my addon
    ["darkrp_tip_jar"] = true, 
    ["money_printer"] = true, 
    ["tierp_printer"] = true, 
    ["lithium_bronze_printer"] = true, 
    ["lithium_iron_printer"] = true, 
    ["lithium_printer_rack"] = true, 
    ["lithium_economic_printer"] = true, 
    ["lithium_donator_printer"] = true, 
    ["lithium_bronze_printer"] = true, 
    ["rprint_bronzeprinter"] = true, 
    ["rprint_goldprinter"] = true, 
    ["rprint_silverprinter"] = true, 
}

Realistic_Properties.JobCanSpawnProps = { -- Which job can spawn props outside his property when the Realistic_Properties.SpawnProps = false 
    ["Отдел Disag"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Properties.PropertiesDelivery = true -- If when the player don't have property he can buy an entity ( The entity will spawn on him )

Realistic_Properties.BuyEntitiesWithoutProperties = { -- Which job can buy entities without property when Realistic_Properties.PropertiesDelivery = false
    ["Fruit Slicer"] = true,
    ["Scientific Police"] = true,
}

Realistic_Properties.PoliceJob = { -- Police Job which can see the owner of property 
    ["Отдел Контрразведки MI5"] = true,
    ["Администратор города [WL]"] = true,
    ["Детектив"] = true, 
    ["Отдел Disag [Dis+]"] = true,
    ["Спецназ CTSFO"] = true,
    ["Патрульная полиция"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Properties.AdminRank = { -- Admin rank 
    ["superadmin"] = true,
    ["admin"] = true,
}

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
