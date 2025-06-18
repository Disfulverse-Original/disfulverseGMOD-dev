if SERVER then 
	-- Add client files to download
	local clientFiles = {
		"sd_scoreboard/cl_init.lua",
		"sd_scoreboard/client/cl_colors.lua",
		"sd_scoreboard/client/cl_languages.lua",
		"sd_scoreboard/client/cl_utils.lua",
		"sd_scoreboard/client/cl_config.lua",
		"sd_scoreboard/client/vgui/cl_circleavatar.lua",
		"sd_scoreboard/client/vgui/cl_grid.lua",
		"sd_scoreboard/client/vgui/cl_scroll.lua",
		"sd_scoreboard/client/panels/cl_base.lua",
		"sd_scoreboard/client/panels/cl_players.lua",
		"sd_scoreboard/client/panels/cl_profile.lua",
		"sd_scoreboard/client/panels/cl_settings.lua",
		"sd_scoreboard/client/panels/cl_admin_settings.lua",
		"sd_scoreboard/client/panels/cl_web.lua"
	}
	
	for _, filePath in ipairs(clientFiles) do
		if file.Exists(filePath, "LUA") then
			AddCSLuaFile(filePath)
		else
			print("[SDSCOREBOARD] ERROR: Client file not found - " .. filePath)
		end
	end

	-- Load server file
	local serverPath = "sd_scoreboard/sv_init.lua"
	if file.Exists(serverPath, "LUA") then
		include(serverPath)
		print("[SDSCOREBOARD] Server initialized")
	else
		print("[SDSCOREBOARD] ERROR: Server file not found - " .. serverPath)
	end

elseif CLIENT then
	-- Wait for gamemode to load before initializing
	hook.Add("OnGamemodeLoaded", "sd_scoreboard_wait", function()
		local clientPath = "sd_scoreboard/cl_init.lua"
		if file.Exists(clientPath, "LUA") then
			include(clientPath)
			print("[SDSCOREBOARD] Client initialized")
		else
			print("[SDSCOREBOARD] ERROR: Client file not found - " .. clientPath)
		end
	end)
end