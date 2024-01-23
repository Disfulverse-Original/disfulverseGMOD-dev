--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

/*****************
* CONFIGURATIONS
******************/

ECL = {};
ECL.Languages = {};

ECL.Logs = {}
ECL.Logs.Enabled = true; -- Enables logs system for this addon.
ECL.Logs.Type = 2; -- Type of logging.
-- Types: 
-- 1 - Every action with addon's commands and entities will be written.
-- 2 - Every action with addon's commands and entities will be printed and written.
-- Logs are located in `garrysmod/data/jb/ecl_logs/`.

AddCSLuaFile("ecl_functions.lua");
include("ecl_functions.lua"); 		-- Don't touch

ECL:SetLanguage("ru"); -- Setting up your language, restart server after changing.
-- Guide how to create a new one:
-- 1. Open 'enh_coca_lab/languages' directory and copy an 'ecl_language_en.lua'
-- 2. Rename it to your own language like 'ecl_language_<lang>.lua'
-- 3. Open that file and change values to your liking.
-- 4. Find in the end 'ECL.Language["en"] = Language ', change "en" to your value as in a file's name.
-- Like: if file's name " ecl_language_ru.lua " then function should be ' ECL.Language["ru"] = Language ';


------- NEW --------
ECL.CustomModels = {}
ECL.CustomModels.Stove = true; -- Replaces default model of stove to portable one.
ECL.CustomModels.Plant = true; -- Replaces default plantation model to a new one.
ECL.CustomModels.Gascan = true; -- Replaces default model of gas to gascan.
ECL.CustomModels.Cocaine = true; -- Replaces default model of cocaine to brick of cocaine.
------- NEW --------

ECL.Draw = {}
ECL.Draw.Distance = 256; -- Distance when 3D2D interface starts loading.
ECL.Draw.AimingOnEntity = true; -- Draw 3D2D Interface when player aim on entity.
ECL.Draw.FadeInOnComingCloser = true; -- Draw 3D2D Interface when player coming closer to entity.

ECL.SpawnableEntities = true; -- If it is enabled, you will see entities in Entities tab in Spawn menu (Which opens on pressing Q)

ECL.Plant = {};
ECL.Plant.Leaves = 15; -- Amount of leaves on coca plantation.
ECL.Plant.DropSeed = true; -- Drop Coca Seed with a random chance when all leaves are collected? Yes - true, No - false.
ECL.Plant.GrowingTimer = 5; -- Time to grow up plant.
ECL.Plant.RespawnTimer = 5; -- Time to re-grow up leaves.

ECL.Seed = {}
ECL.Seed.Model = "models/props/cs_office/plant01_gib1.mdl"; -- The model of Coca Seed.
ECL.Seed.RemovingTime = 120; -- Time to get removed after spawn.

ECL.Box = {}; 
ECL.Box.MaxAmount = 30; -- Maximal amount of leaves in box.

ECL.Kerosin = {}
ECL.Kerosin.MaxAmount = 45; -- Maximal amount of leaves that will allow player to shake them with kerosin.

ECL.Drafting = {}
ECL.Drafting.Timer = 3; -- Time that you should wait until start shaking.
ECL.Drafting.MaxAmount = 2; -- Maximal amount of leaves in kerosin.

ECL.Cleaning = {}
ECL.Cleaning.Timer = 5; -- Time that for cleaning semi-drug.
ECL.Cleaning.MaxAmount = 2; -- Maximal amount of drufted leaves.

ECL.Pot = {}
ECL.Pot.MaxAmount = 1; -- Maximal amount of cleaned semi-drugs.
ECL.Pot.Temperature = 70; -- Temperature of cooked dirty drug.
ECL.Pot.ExplodeTemperature = 100; -- If temperature is higher, pot will explode. 

ECL.Stove = {}
ECL.Stove.GravityGun = true; -- 'true' lets stove be used by gravity-gun.
ECL.Stove.MaxAmountOfGas = 350; -- Maximal amount of gas in stove.

ECL.Gas = {}
ECL.Gas.Amount = 350; -- Amount in one gas cylinder.

ECL.Gasoline = {}
ECL.Gasoline.Timer = 5; -- Time to clean dirty drug.
ECL.Gasoline.MaxAmount = 1; -- Maximal amount of cooked dirty drug.

ECL.Cocaine = {}
ECL.Cocaine.Reward = 40000; -- Reward for cocaine; 
-- If you want set it to random value, you should use this example: 
-- ECL.Cocaine.Reward = {<yourMinValue>, <yourMaxValue>} 
-- without "<>"
ECL.Cocaine.HideInPocketOnUse = false; -- Enables a function to hide cocaine in smuggling pocket by using entity.
-- You should press USE to get a cocaine and then press USE to sell it.
ECL.Cocaine.MaxAmountInPocket = 3; -- Amount of cocaine that can be hidden in smuggling pocket.
ECL.Cocaine.IsWorldProp = false; -- If this function turned on, cocaine after creation would be world's prop.


ECL.Dealer = {}
ECL.Dealer.Model = "models/gman_high.mdl"; -- The model of Dealer.

if CLIENT then
	ECL.Draw = {}
	ECL.Plant = {}
	ECL.Seed = {}
	ECL.Box = {}
	ECL.Kerosin = {}
	ECL.Drafting = {}
	ECL.Cleaning = {}
	ECL.Pot = {}
	ECL.Stove = {}
	ECL.Gas = {}
	ECL.Gasoline = {}
	ECL.Cocaine = {}
	ECL.Dealer = {}
end