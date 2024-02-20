if SERVER then 
	
	AddCSLuaFile("sd_scoreboard/cl_init.lua")

	AddCSLuaFile("sd_scoreboard/client/cl_colors.lua")
	AddCSLuaFile("sd_scoreboard/client/cl_languages.lua")
	AddCSLuaFile("sd_scoreboard/client/cl_utils.lua")
	AddCSLuaFile("sd_scoreboard/client/cl_config.lua")

	AddCSLuaFile("sd_scoreboard/client/vgui/cl_circleavatar.lua")
	AddCSLuaFile("sd_scoreboard/client/vgui/cl_grid.lua")
	AddCSLuaFile("sd_scoreboard/client/vgui/cl_scroll.lua")

	AddCSLuaFile("sd_scoreboard/client/panels/cl_base.lua")
	AddCSLuaFile("sd_scoreboard/client/panels/cl_players.lua")
	AddCSLuaFile("sd_scoreboard/client/panels/cl_profile.lua")
	AddCSLuaFile("sd_scoreboard/client/panels/cl_settings.lua")
	AddCSLuaFile("sd_scoreboard/client/panels/cl_admin_settings.lua")
	AddCSLuaFile("sd_scoreboard/client/panels/cl_web.lua")

	include("sd_scoreboard/sv_init.lua")

elseif CLIENT then
	hook.Add("OnGamemodeLoaded", "sd_scoreboard_wait", function()
		include("sd_scoreboard/cl_init.lua")
	end)
end