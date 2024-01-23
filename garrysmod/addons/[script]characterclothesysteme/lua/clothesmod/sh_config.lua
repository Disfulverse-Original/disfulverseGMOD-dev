CLOTHESMOD.Config.CommunityName = "Project DisFul"

--[[
	A list of all languages can be found in the clothesmod/languages folder
	Add the name of the .lua file with the lang you want between the quotes
	( ex : put "english" to use the translation of the english.lua file in the lanaguages folder )
]]
CLOTHESMOD.Config.Lang = "english"


CLOTHESMOD.Config.PriceChangingName = 30000
CLOTHESMOD.Config.MoneyUnit = "$"

--[[
	Players are able to create their own clothes for money,
	define bellow the prices that they have to pay for the empty t-shirt and that
	they have to add for each element. ( img/text )
]]
CLOTHESMOD.Config.EditableTop = 800000
CLOTHESMOD.Config.PricePerText = 100000
CLOTHESMOD.Config.PricePerImg = 2000000

-- surgery prices
CLOTHESMOD.Config.PriceToChangeSex = 25000
CLOTHESMOD.Config.PriceToChangeHead = 20000
CLOTHESMOD.Config.PriceToChangeEyes = 50000

--[[
	Set CLOTHESMOD.Config.CanOpenInventory to false to prevent all players to drop their clothes by opening their inventory ( it prevents nudity )
	You also can change the key to open the inventory by edit CLOTHESMOD.Config.KeyInventory
	A list of keys is available there :
	http://wiki.garrysmod.com/page/Enums/BUTTON_CODE
]]

CLOTHESMOD.Config.CanOpenInventory = false
CLOTHESMOD.Config.KeyInventory = KEY_00

--[[
	When you open the wardrobe, you are able to remove your clothes.
	This option allow you to not show the "Remove" button on the clothes.
	By this way, players can't remove their clothes in the wardrobe.
	true = activated,
	false = deactivated
]]
CLOTHESMOD.Config.CanRemoveClothesInWardrobe = false

-- Sound in the introduction menu? true = yes, false = no
CLOTHESMOD.Config.HasSound = false

-- upload a .mp3 of your sound and put the link to it here
CLOTHESMOD.Config.IntroSoundURL = ""

-- list of jobs with uniforms, the players will have the models of the job instead of their one.
	
--[[
	Jobs added in the ForbiddenJobs list will not be affected by this script.
	They'll keep the head that you've chosen in your jobs.lua file
	Add between the quotation marks the name of the job
]]
CLOTHESMOD.Config.ForbiddenJobs = {
	["Medic"]=true,
	["Cook"]=true,
}

--[[
	ForbiddenJobsWithHeads is a most advanced feature.
	You can use it to do that jobs with uniforms ( police, medic, etc. ) keep their head when they take their uniform.
	In the following example :
	["Police"]={
		["male01"] = "models/taggart/police01/male_01.mdl",
		["male02"] = "models/taggart/police01/male_02.mdl",
		["male03"] = "models/taggart/police01/male_03.mdl",
		["male04"] = "models/taggart/police01/male_04.mdl",
		["male05"] = "models/taggart/police01/male_05.mdl",
		["male06"] = "models/taggart/police01/male_06.mdl",
		["male07"] = "models/taggart/police01/male_07.mdl",
		["male08"] = "models/taggart/police01/male_08.mdl",
		["male09"] = "models/taggart/police01/male_09.mdl",
		["female01"] = "models/taggart/police01/male_01.mdl", -- i don't find any for women sorry
		["female02"] = "models/taggart/police01/male_02.mdl",
		["female03"] = "models/taggart/police01/male_03.mdl",
		["female04"] = "models/taggart/police01/male_04.mdl",
		["female05"] = "models/taggart/police01/male_05.mdl",
		["female06"] = "models/taggart/police01/male_06.mdl"
	},

	Do not touch the ["male01"], ["male02"] etc. which are used by the script to work well.
	Change the "Police" by the name of the team.
	Change "models/taggart/police01/male_01.mdl" by the model with the head of the male_01 ( https://www.combinecontrol.com/chars/citizens_male_01.png )
	You can use this list https://www.combinecontrol.com/allowedmodels.php to know the male_number and the female_number
]]
-- https://steamcommunity.com/sharedfiles/filedetails/?id=576517817
CLOTHESMOD.Config.ForbiddenJobsWithHeads = {
	["Civil Protection"]={
		["male01"] = "models/taggart/police01/male_01.mdl",
		["male02"] = "models/taggart/police01/male_02.mdl",
		["male03"] = "models/taggart/police01/male_03.mdl",
		["male04"] = "models/taggart/police01/male_04.mdl",
		["male05"] = "models/taggart/police01/male_05.mdl",
		["male06"] = "models/taggart/police01/male_06.mdl",
		["male07"] = "models/taggart/police01/male_07.mdl",
		["male08"] = "models/taggart/police01/male_08.mdl",
		["male09"] = "models/taggart/police01/male_09.mdl",
		["female01"] = "models/taggart/police01/male_01.mdl", -- i don't find any for women sorry
		["female02"] = "models/taggart/police01/male_02.mdl",
		["female03"] = "models/taggart/police01/male_03.mdl",
		["female04"] = "models/taggart/police01/male_04.mdl",
		["female05"] = "models/taggart/police01/male_05.mdl",
		["female06"] = "models/taggart/police01/male_06.mdl"
	},
}

-- Usergroups who can use the admin commands ( see the list in the addon description )
CLOTHESMOD.Config.ModGroups = {
	"superadmin"
}