--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

PROJECT0 = {
    FUNC = {},
    CONFIG = {},
	DEVCONFIG = {},
    TEMP = (PROJECT0 and PROJECT0.TEMP) or {},
	PLAYERMETA = {}
}

PROJECT0.PLAYERMETA.__index = PROJECT0.PLAYERMETA

hook.Add( "InitPostEntity", "Project0.InitPostEntity.Loaded", function()
	PROJECT0.INITPOSTENTITY_LOADED = true
end )

hook.Add( "Initialize", "Project0.Initialize.Loaded", function()
	PROJECT0.INITIALIZE_LOADED = true
end )

AddCSLuaFile( "projectzero/sh_config_loader.lua" )
include( "projectzero/sh_config_loader.lua" )

if( CLIENT ) then
	include( "projectzero/cl_projectzero_core.lua" )
else
	AddCSLuaFile( "projectzero/cl_projectzero_core.lua" )
	include( "projectzero/sv_projectzero_core.lua" )
end

-- SHARED LOAD --
for k, v in ipairs( file.Find( "projectzero/shared/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/shared/" .. v )
	include( "projectzero/shared/" .. v )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
