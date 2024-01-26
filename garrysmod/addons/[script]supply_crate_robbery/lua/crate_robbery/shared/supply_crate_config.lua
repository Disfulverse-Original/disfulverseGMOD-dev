CH_SupplyCrate = CH_SupplyCrate or {}
CH_SupplyCrate.Config = CH_SupplyCrate.Config or {}
CH_SupplyCrate.Design = CH_SupplyCrate.Design or {}
CH_SupplyCrate.Content = CH_SupplyCrate.Content or {}
CH_SupplyCrate.ShipWhiteList = CH_SupplyCrate.ShipWhiteList or {}

CH_SupplyCrate.ScriptVersion = "1.0.5"

-- SET LANGUAGE
-- Available languages: English: en - Danish: da
CH_SupplyCrate.Config.Language = "ru" -- Set the language of the script.

-- TEAM CONFIGURATION
CH_SupplyCrate.Config.RequiredTeams = { -- These are the names of the jobs that counts the police required. The amount of players on these teams are calculated together in the count.
	"Патрульная полиция",
	"Отдел Disag [Dis+]",
	"Детектив",
	"Администратор города [WL]",
	"Отдел Контрразведки MI5",
	"Спецназ CTSFO"
}

CH_SupplyCrate.Config.GovernmentTeams = { -- These are your government teams. They will receive messages when robberies start. Use the actual team name, as shown below.
	"Патрульная полиция",
	"Отдел Disag [Dis+]",
	"Детектив",
	"Администратор города [WL]",
	"Отдел Контрразведки MI5",
	"Спецназ CTSFO"
}

CH_SupplyCrate.Config.AllowedTeams = { -- These are the teams that are allowed to rob the supply crate.
	"Мафиози",
	"Оператор ЧВК [Dis+]",
	"Хакер-взломщик",
	"Наёмник-Мародер",
	"Головорез Мафии [Dis+]",
	"Бандит",
	"Бегущий" -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}

-- General settings.
CH_SupplyCrate.Config.RobberyAliveTime = 5 -- The amount of MINUTES the player must stay alive before he will receive what the supply crate has. IN MINUTES! [Default = 5]
CH_SupplyCrate.Config.RobberyCooldownTime = 30 -- The amount of MINUTES the supply crate is on a cooldown after a robbery! (Doesn't matter if the robbery failed or not) [Default = 30]
CH_SupplyCrate.Config.RobberyDistance = 300000 -- The amount of space the player can move away from the supply crate entity, before the robbery fails. [Default = 300000]
CH_SupplyCrate.Config.PlayerLimit = 6 -- The amount of players there must be on the server before you can rob the supply crate. [Default = 6]
CH_SupplyCrate.Config.KillReward = 500 -- The amount of money a person is rewarded for killing the supply crate robber. [Default = 500]
CH_SupplyCrate.Config.PoliceRequired = 4 -- The amount of police officers there must be before a person can rob the supply crate. [Default = 4]

CH_SupplyCrate.Config.EmitSoundOnRob = true -- Should an alarm go off when the bank vault gets robbed. [Default = true]
CH_SupplyCrate.Config.TheSound = "ambient/alarms/alarm_citizen_loop1.wav" -- The sound to be played. [Default = ambient/alarms/alarm1.wav - default gmod sound]
CH_SupplyCrate.Config.SoundDuration = 20 -- Amount of seconds the sound should play for. [Default = 20]
CH_SupplyCrate.Config.SoundVolume = 100 -- The sound volume for the alarm sound. [Default = 100] -- AVAILABLE VALUES https://wiki.facepunch.com/gmod/Enums/SNDLVL

-- Section one. Handles money in the supply crate.
CH_SupplyCrate.Config.EnableMoneyLoot = true -- Should the money element be enabled?
CH_SupplyCrate.Config.MoneyTimer = 120 -- This is the time that defines when money is added to the supply crate. In seconds! [Default = 120 (2 Minute)]
CH_SupplyCrate.Config.MoneyOnTime = 1000 -- This is the amount of money to be added to the supply crate every x minutes/seconds. Defined by the setting above. [Default = 1000]
CH_SupplyCrate.Config.MaxMoney = 15000 -- The maximum amount of money the supply crate can have. Set to 0 for no limit. [Default = 15000]

-- Section two. Handles the ammonition part.
CH_SupplyCrate.Config.EnableAmmoLoot = true -- Should the ammo element be enabled?
CH_SupplyCrate.Config.AmmoTimer = 300 -- This is the time that defines when ammo is added to the supply crate. In seconds! [Default = 300 5 Minutes)]
CH_SupplyCrate.Config.AmmoOnTime = 20 -- This is the amount of ammo to be added to the supply crate every x minutes/seconds. Defined by the setting above. [Default = 20]
CH_SupplyCrate.Config.MaxAmmo = 120 -- The maximum amount of ammo the supply crate can have. Set to 0 for no limit. [Default = 120]

-- Section tree. Handles the shitment part.
CH_SupplyCrate.Config.EnableShipmentLoot = true -- Should the shipment element be enabled?
CH_SupplyCrate.Config.ShipmentsTimer = 300 -- This is the time that defines when shipments are added to the supply crate. In seconds! [Default = 360 (6 Minutes)]
CH_SupplyCrate.Config.ShipmentsOnTime = 1 -- This is the amount of shipments to be added to the supply crate every x minutes/seconds. Defined by the setting above. [Default = 1]
CH_SupplyCrate.Config.MaxShipments = 5 -- The maximum amount of shipments the supply crate can have. Set to 0 for no limit. [Default = 5]
CH_SupplyCrate.Config.ShipmentsWepAmount = 3 -- Amount of weapons inside of one shipment. [Default = 3]

CH_SupplyCrate.Config.ShipmentAutoRemove = 360 -- TO AVOID SPAM: if you want shipments to be deleted after x seconds of spawning after robbery, you can use this config. Setting it to 0 will disable it and not delete anything. [Default = 360]
CH_SupplyCrate.Config.OverwriteModel = true -- Do you want to overwrite the default shipment model with the one that comes with the script, even when users buys them through the F4 menu? [Default = true]

-- Police Money Bag (from successful robbery)
CH_SupplyCrate.Config.MoneyBag_Health = 80 -- Amount of health the money bag has. [Default = 80]
CH_SupplyCrate.Config.MoneyBag_StealTime = 5 -- Amount of seconds it takes to steal the money from the bag. [Default = 5]

CH_SupplyCrate.Design.TheMoneyColor = Color( 48, 151, 48, 255 )
CH_SupplyCrate.Design.TheMoneyBoarder = Color( 0, 0, 0, 230 )

-- Rank Restrictions
CH_SupplyCrate.Config.RobberyRankRestrictions = false -- Should the supply crate be restricted to ranks (who can rob?) - false restricts to the teams from AllowedTeams config.

CH_SupplyCrate.Config.RankRestrictions = {
	{ UserGroup = "user", CanRob = true },
	{ UserGroup = "vip", CanRob = true },
	{ UserGroup = "admin", CanRob = true },
	{ UserGroup = "superadmin", CanRob = true },
	{ UserGroup = "owner", CanRob = true },
}

-- XP System Support
CH_SupplyCrate.Config.DarkRPLevelSystemEnabled = false -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
CH_SupplyCrate.Config.SublimeLevelSystemEnabled = true -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
CH_SupplyCrate.Config.BricksLevelSystemEnabled = true

CH_SupplyCrate.Config.XPSuccessfulRobbery = 200 -- Amount of experience to give on successfully robbing the supply crate.
CH_SupplyCrate.Config.XPStoppingRobber = 200 -- Amount of experience to give if a cop kills a player robbing the supply crate.

-- 3d2d display configs
CH_SupplyCrate.Design.CooldownTextColor = Color( 48, 151, 209, 255 )
CH_SupplyCrate.Design.CooldownTextBoarder = Color( 0, 0, 0, 255 )

CH_SupplyCrate.Design.CooldownTimerTextColor = Color( 255, 255, 255, 255 )
CH_SupplyCrate.Design.CooldownTimerTextBoarder = Color( 0, 0, 0, 255 )

CH_SupplyCrate.Design.DistanceTo3D2D = 400000 -- Distance between player and supply crate/money bag before text appears.