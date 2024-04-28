--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

Realistic_Properties = {}

include("realistic_properties/sh_config_rps.lua")
include("realistic_properties/sh_lang_rps.lua")
include("realistic_properties/sh_materials_rps.lua")
	
if SERVER then

	AddCSLuaFile("realistic_properties/sh_config_rps.lua")
	AddCSLuaFile("realistic_properties/sh_lang_rps.lua")
	AddCSLuaFile("realistic_properties/sh_materials_rps.lua")

	AddCSLuaFile("realistic_properties/client/cl_main.lua")
	AddCSLuaFile("realistic_properties/client/cl_font.lua")
	AddCSLuaFile("realistic_properties/client/cl_notify.lua")
	AddCSLuaFile("realistic_properties/client/cl_hook.lua")

	include("realistic_properties/server/sv_net.lua")
	include("realistic_properties/server/sv_function.lua")
	include("realistic_properties/server/sv_hook.lua")
	include("realistic_properties/server/sv_tool.lua")

elseif CLIENT then

	include("realistic_properties/client/cl_main.lua")
	include("realistic_properties/client/cl_font.lua")
	include("realistic_properties/client/cl_notify.lua")
	include("realistic_properties/client/cl_hook.lua")

end
