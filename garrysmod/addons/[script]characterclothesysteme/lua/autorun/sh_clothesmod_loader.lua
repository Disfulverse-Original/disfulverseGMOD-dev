MsgC(Color(255,0,0), "[CLOTHESMOD]", Color(255,255,255), "Loading files...")

CLOTHESMOD = {}
CLOTHESMOD.Config = {}
CLOTHESMOD.Config.Sentences = {}
CLOTHESMOD.Male = {}
CLOTHESMOD.Male.ListDefaultPM = {}
CLOTHESMOD.Female = {}
CLOTHESMOD.Female.ListDefaultPM = {}

for i=1, 69 do
	CLOTHESMOD.Config.Sentences[i] = {}
end

if CLIENT then
	for i=1, 100 do
		surface.CreateFont( "Bariol"..i, {
			font = "Roboto",
			extended = true,
			size = i,
			weight = 1000,
			blursize = 0,
			scanlines = 0,
			antialias = true,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = false,
			additive = false,
			outline = false,
		} )
	end
end

-- include shared
include("clothesmod/sh_config.lua")
include("clothesmod/shared/sh_advanced_config.lua")
include("clothesmod/shared/sh_functions.lua")
for k, v in pairs( file.Find( "clothesmod/languages/*", "LUA" ) ) do
	include("clothesmod/languages/"..v)
end

if SERVER then

	resource.AddWorkshop("1455944872")

	-- AddCSLuaFile shared
	AddCSLuaFile("clothesmod/sh_config.lua")
	AddCSLuaFile("clothesmod/shared/sh_advanced_config.lua")
	AddCSLuaFile("clothesmod/shared/sh_functions.lua")
	for k, v in pairs( file.Find( "clothesmod/languages/*", "LUA" ) ) do
		AddCSLuaFile("clothesmod/languages/"..v)
	end

	-- AddCSLuaFile client
	AddCSLuaFile("clothesmod/client/cl_hooks.lua")
	AddCSLuaFile("clothesmod/client/cl_net.lua")
	AddCSLuaFile("clothesmod/client/cl_functions.lua")
	AddCSLuaFile("clothesmod/client/cl_notifications.lua")
	AddCSLuaFile("clothesmod/client/cl_new_character.lua")
	AddCSLuaFile("clothesmod/client/cl_clothesshop.lua")
	AddCSLuaFile("clothesmod/client/cl_clothesarmory.lua")
	AddCSLuaFile("clothesmod/client/cl_admin_createclothes.lua")
	
	-- include server
	include("clothesmod/server/sv_functions.lua")
	include("clothesmod/server/sv_hooks.lua")
	include("clothesmod/server/sv_notifications.lua")
	include("clothesmod/server/sv_net.lua")
	include("clothesmod/server/sv_admin.lua")
	
elseif CLIENT then
	
	-- include client
	include("clothesmod/client/cl_hooks.lua")
	include("clothesmod/client/cl_net.lua")
	include("clothesmod/client/cl_functions.lua")
	include("clothesmod/client/cl_notifications.lua")
	include("clothesmod/client/cl_new_character.lua")
	include("clothesmod/client/cl_clothesshop.lua")
	include("clothesmod/client/cl_clothesarmory.lua")
	include("clothesmod/client/cl_admin_createclothes.lua")
	
end