     
--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                                  
--]]


Realistic_Police = Realistic_Police or {}
Realistic_Police.PlateConfig = Realistic_Police.PlateConfig or {}
Realistic_Police.Application = Realistic_Police.Application or {}
Realistic_Police.PlateVehicle = Realistic_Police.PlateVehicle or {}
Realistic_Police.FiningPolice = Realistic_Police.FiningPolice or {}
Realistic_Police.Trunk = Realistic_Police.Trunk or {}
Realistic_Police.TrunkPosition = Realistic_Police.TrunkPosition or {}
 
-----------------------------------------------------------------------------
---------------------------- Main Configuration------------------------------
-----------------------------------------------------------------------------

Realistic_Police.Langage = "ru" -- You can choose fr , en , tr , cn 

Realistic_Police.DefaultJob = false -- Default Job Activate/Desactivate (Camera Repairer )

Realistic_Police.TrunkSystem = false -- Do you want to use the trunk system ? 

Realistic_Police.KeyOpenTablet = KEY_L -- Key for open the tablet into a vehicle  

Realistic_Police.WantedMessage = "Разыскивается полицией" -- Message when you wanted someone with the computer 

Realistic_Police.StungunAmmo = 10 

Realistic_Police.CanConfiscateWeapon = false -- If the functionality for confiscate is activate or desactivate

Realistic_Police.UseDefaultArrest = false 

Realistic_Police.AdminRank = { -- Rank Admin 
    ["superadmin"] = true,
--    ["admin"] = true, 
}

Realistic_Police.OpenComputer = { -- Which job can open the computer 
    ["Патрульная полиция"] = false,
    ["Спецназ CTSFO"] = false,
    ["Отдел Disag [Dis+]"] = false, 
    ["Детектив"] = false,
    ["Администратор города"] = false,
    ["Отдел Безопасности"] = false,
    ["Отдел поддержки [ADM]"] = false,
}

Realistic_Police.PoliceVehicle = { -- Police Vehicle
    ["loui's_5008_police_nationnal"] = false,
    ["cupra_formentor_2020_police_alexcars"] = false, 
	["ford_transit_police_nationale"] = false,
}

Realistic_Police.TrunkPosition["Chevrolet Tahoe - RAID"] = {
    ["Pos"] = Vector(0,0,0),
    ["Ang"] = Angle(0,0,0),
}

-----------------------------------------------------------------------------
------------------------- Computer Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.MaxReport = 0 -- Max report per persson

Realistic_Police.MaxCriminalRecord = 0 -- Max Criminal Record per persson

--[[ нахуя оно надо, эта функция буквально открывает строку гугла
Realistic_Police.Application[1] = { -- Unique Id 
    ["Name"] = "Интернет", -- Name of the Application 
    ["Materials"] = Material("rpt_internet.png"), -- Material of the Application 
    ["Function"] = Realistic_Police.FireFox, -- Function Application 
    ["Type"] = "police",  
}
-- не нужны, ибо дрочная система сидения на жопе
Realistic_Police.Application[2] = { -- Unique Id 
    ["Name"] = "Камеры", -- Name of the Application 
    ["Materials"] = Material("rpt_cctv.png"), -- Material of the Application    
    ["Function"] = Realistic_Police.Camera, -- Function Application 
    ["Type"] = "police",  
}
--]]
Realistic_Police.Application[3] = { -- Unique Id 
    ["Name"] = "Криминальные записи", -- Name of the Application 
    ["Materials"] = Material("rpt_law.png"), -- Material of the Application 
    ["Function"] = Realistic_Police.CriminalRecord, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[4] = { -- Unique Id
    ["Name"] = "Составить рапорт", -- Name of the Application 
    ["Materials"] = Material("rpt_cloud.png"), -- Material of the Application   
    ["Function"] = Realistic_Police.ReportMenu, -- Function application 
    ["Type"] = "police",  
}

Realistic_Police.Application[5] = { -- Unique Id 
    ["Name"] = "Список рапортов", -- Name of the Application 
    ["Materials"] = Material("rpt_documents.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.ListReport, -- Function Application 
    ["Type"] = "police",   
}
--[[ лицензирование номеров машин, которых нет на сервере
Realistic_Police.Application[6] = { -- Unique Id 
    ["Name"] = "License Plate", -- Name of the Application  
    ["Materials"] = Material("rpt_listreport.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.License, -- Function Application 
    ["Type"] = "police",  
}
--]]
Realistic_Police.Application[7] = { -- Unique Id 
    ["Name"] = "Консоль", -- Name of the Application  
    ["Materials"] = Material("rpt_cmd.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.Cmd, -- Function Application  
    ["Type"] = "hacker", 
}

-----------------------------------------------------------------------------
--------------------------- Plate Configuration------------------------------
-----------------------------------------------------------------------------

Realistic_Police.PlateActivate = false -- If Module plate is activate

Realistic_Police.LangagePlate = "eu" -- You can choose eu or us

Realistic_Police.PlateConfig["us"] = { 
    ["Image"] = Material("rpt_plate_us.png"), -- Background of the plate 
    ["ImageServer"] = nil, -- Image server or Image of the department 
    ["TextColor"] = Color(24, 55, 66), -- Color Text of the plate 
    ["Country"] = "ARIZONA", -- Country Name 
    ["CountryPos"] = {2, 5}, -- The pos of the text 
    ["CountryColor"] = Color(26, 134, 185), -- Color of the country text 
    ["Department"] = "",  
    ["PlatePos"] = {2, 1.5}, -- Plate Pos 
    ["PlateText"] = false, -- AABCDAA
}

Realistic_Police.PlateConfig["eu"] = { 
    ["Image"] = Material("rpt_plate_eu.png"), -- Background of the plate  
    ["ImageServer"] = Material("rpt_department_eu.png"), -- Image server or Image of the department 
    ["TextColor"] = Color(0, 0, 0, 255), -- Color Text of the plate 
    ["Country"] = "F", -- Country Name 
    ["CountryPos"] = {1.065, 1.4}, -- The pos of the text 
    ["CountryColor"] = Color(255, 255, 255), -- Color of the country text 
    ["Department"] = "77", -- Department 
    ["PlatePos"] = {2, 2}, -- Plate Pos 
    ["PlateText"] = true, -- AA-BCD-AA
}

Realistic_Police.PlateVehicle["crsk_alfaromeo_8cspider"] = "eu" 

--Realistic_Police.PlateVehicle["class"] = "nameplate"

-----------------------------------------------------------------------------
---------------------------- Trunk Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.KeyForOpenTrunk = KEY_E -- https://wiki.facepunch.com/gmod/Enums/KEY

Realistic_Police.KeyTrunkHUD = false -- Activate/desactivate the hud of the vehicle 

Realistic_Police.CanOpenTrunk = {
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Police.VehiclePoliceTrunk = {
    ["Airboat"] = false, 
    ["Jeep"] = false, 
}

Realistic_Police.MaxPropsTrunk = 10 -- Max props trunk 

Realistic_Police.Trunk["models/props_wasteland/barricade002a.mdl"] = {
    ["GhostPos"] = Vector(0,0,35),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_wasteland/barricade001a.mdl"] = {
    ["GhostPos"] = Vector(0,0,30),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_junk/TrafficCone001a.mdl"] = {
    ["GhostPos"] = Vector(0,0,16),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_c17/streetsign004f.mdl"] = {
    ["GhostPos"] = Vector(0,0,12),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_c17/streetsign001c.mdl"] = {
    ["GhostPos"] = Vector(0,0,12),
    ["GhostAngle"] = Vector(0,0,0),
}

-----------------------------------------------------------------------------
-------------------------- HandCuff Configuration----------------------------
-----------------------------------------------------------------------------

Realistic_Police.MaxDay = 10 -- Max Jail Day 

Realistic_Police.DayEqual = 30 -- 1 day = 30 Seconds 

Realistic_Police.PriceDay = 2000 -- Price to pay with the bailer per day 

Realistic_Police.JailerName = "Тюремщик" -- Jailer Name 

Realistic_Police.BailerName = "Адвокат" -- Bailer Name 

Realistic_Police.SurrenderKey = KEY_T -- The key for surrender 

Realistic_Police.SurrenderInfoKey = "T" -- The Key 

Realistic_Police.SurrenderActivate = true 

Realistic_Police.CanCuff = { -- Job which can arrest someone
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}
 
Realistic_Police.CantBeCuff = { -- Job which can't be cuff
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Police.CantConfiscate = { -- Job which can't be cuff
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true, 
    ["gmod_camera"] = true, 
    ["weapon_physcannon"] = true, 
}

-----------------------------------------------------------------------------
-------------------------- Stungun Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.CantBeStun = { -- Job which can't be cuff
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

-----------------------------------------------------------------------------
--------------------------- Camera Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.CameraHealth = 50 -- Health of the Camera 

Realistic_Police.CameraRestart = 60 -- Camera restart when they don't have humans for repair 

Realistic_Police.CameraRepairTimer = 10 -- Time to repair the camera 10s 

Realistic_Police.CameraBrokeHud = false -- If when a camera was broken the Camera Worker have a Popup on his screen 

Realistic_Police.CameraBroke = false -- if camera broke sometime when a camera repairer is present on the server 

Realistic_Police.CameraWorker = { -- Job which can repair the camera 
    ["Camera Repairer"] = false,
}

Realistic_Police.CameraGiveMoney = 500 -- Money give when a player repair a camera 

-----------------------------------------------------------------------------
--------------------------- Report Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.JobDeleteReport = { -- Which job can delete Report 
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Police.JobEditReport = { -- Which job can create / edit report 
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

-----------------------------------------------------------------------------
------------------------ Criminal Record Configuration ----------------------
-----------------------------------------------------------------------------

Realistic_Police.JobDeleteRecord = { -- Which job can delete Criminal Record
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Police.JobEditRecord = { -- Which job can create / edit Criminal Record  
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

-----------------------------------------------------------------------------
---------------------------- Fining System ----------------------------------
-----------------------------------------------------------------------------

Realistic_Police.PlayerWanted = true -- if the player is wanted when he doesn't pay the fine 

Realistic_Police.PourcentPay = 10 -- The amount pourcent which are give when the player pay the fine 

Realistic_Police.MaxPenalty = 1 -- Maxe Penalty on the same player 

Realistic_Police.JobCanAddFine = { -- Which job can add fine
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Police.JobCantHaveFine = { -- Which job can't receive fine 
    ["Патрульная полиция"] = true,
    ["Спецназ CTSFO"] = true,
    ["Отдел Disag [Dis+]"] = true, 
    ["Детектив"] = true,
    ["Администратор города"] = true,
    ["Отдел Безопасности"] = true,
    ["Отдел поддержки [ADM]"] = true,
}

Realistic_Police.VehicleCantHaveFine = { -- Which vehicle can't receive fine 
    ["loui's_5008_police_nationnal"] = true,
    ["cupra_formentor_2020_police_alexcars"] = true, 
	["ford_transit_police_nationale"] = true,
}

--[[Realistic_Police.FiningPolice[2] = { 
    ["Name"] = "Prank Calls", -- Unique Name is require 
    ["Price"] = 1500,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}]]

Realistic_Police.FiningPolice[3] = { 
    ["Name"] = "Сопротивление аресту", -- Unique Name is require 
    ["Price"] = 2500,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}

Realistic_Police.FiningPolice[4] = { 
    ["Name"] = "Отказ от повиновения", -- Unique Name is require 
    ["Price"] = 1750,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}

Realistic_Police.FiningPolice[5] = { 
    ["Name"] = "Помощь подозреваемому", -- Unique Name is require 
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}

Realistic_Police.FiningPolice[6] = { 
    ["Name"] = "Несоблюдение Ком.часа", -- Unique Name is require 
    ["Price"] = 1250,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}

Realistic_Police.FiningPolice[7] = { 
    ["Name"] = "Ругань/непристойные разговоры", -- Unique Name is require 
    ["Price"] = 750,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}

Realistic_Police.FiningPolice[8] = { 
    ["Name"] = "Вандализм", -- Unique Name is require 
    ["Price"] = 2000,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}

Realistic_Police.FiningPolice[8] = { 
    ["Name"] = "Хранение наркотиков", -- Unique Name is require 
    ["Price"] = 3000,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}
--[[
Realistic_Police.FiningPolice[9] = { 
    ["Name"] = "Хранение денежных принтеров", -- Unique Name is require  
    ["Price"] = 2500,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}
--]]
Realistic_Police.FiningPolice[9] = { 
    ["Name"] = "Хранение денежных принтеров", -- Unique Name is require  
    ["Price"] = 5000,
    ["Vehicle"] = false, 
    ["Category"] = "Штраф",
}
--[[Realistic_Police.FiningPolice[10] = { 
    ["Name"] = "Using a vehicle with defective brakes", -- Unique Name is require 
    ["Price"] = 500,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[11] = { 
    ["Name"] = "Using a vehicle with defective steering", -- Unique Name is require 
    ["Price"] = 750,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[12] = { 
    ["Name"] = "Play street offences", -- Unique Name is require 
    ["Price"] = 1000,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[13] = { 
    ["Name"] = "Exceeding speed limit", -- Unique Name is require 
    ["Price"] = 250,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[14] = { 
    ["Name"] = "Failing to stop after an accident", -- Unique Name is require 
    ["Price"] = 600,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[15] = { 
    ["Name"] = "defective brakes", -- Unique Name is require 
    ["Price"] = 1200,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[16] = { 
    ["Name"] = "Undefined speed limit offence", -- Unique Name is require 
    ["Price"] = 1500,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[17] = {  
    ["Name"] = "Aggravated taking of a vehicle", -- Unique Name is require 
    ["Price"] = 700,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[18] = { 
    ["Name"] = "Undefined speed limit offence", -- Unique Name is require 
    ["Price"] = 160,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}]]

-----------------------------------------------------------------------------
--------------------------- Hacking System ----------------------------------
-----------------------------------------------------------------------------

Realistic_Police.NameOs = "Jenga" -- The name of the os 

Realistic_Police.ResolveHack = 120 -- Time which the computer will be repair 

Realistic_Police.WordCount = 2 -- How many word the people have to write for hack the computer

Realistic_Police.HackerJob = { -- Which are not able to use the computer without hack the computer 
    ["Хакер-взломщик"] = true,
    ["Оператор ЧВК [Dis+]"] = true, 
    ["Наёмник-мародер"] = true,
    ["Головорез Мафии [Dis+]"] = true,
    ["Грабитель [Dis+]"] = true,
    ["Мафиози"] = true,
    ["Взломщик"] = true,
    ["Бандит"] = true,
}

Realistic_Police.WordHack = { -- Random Word for hack the computer 
    "run.hack.exe",
    "police.access.hack",
    "rootip64",
    "delete.password", 
    "password.breaker", 
    "run.database.sql", 
    "delete.access", 
    "recompil", 
    "connect.police.system", 
    "datacompil", 
    "username", 
    "mysqlbreaker", 
    "camera.exe",
    "criminal.record.exe",
    "deleteusergroup",
    "license.plate.exe",
    "cameracitizen.exe", 
    "loaddatapublic",
    "internet.exe",
    "reportmenu.exe",
    "listreport.exe",
	"omegarp.hack",
}

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
 