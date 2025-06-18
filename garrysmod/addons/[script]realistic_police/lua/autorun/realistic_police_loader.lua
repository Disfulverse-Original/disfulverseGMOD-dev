--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

Realistic_Police = Realistic_Police or {}

-- Load shared files efficiently
local sharedFiles = {
	"realistic_police/sh_rpt_config.lua",
	"realistic_police/sh_rpt_lang.lua",
	"realistic_police/sh_rpt_materials.lua",
	"realistic_police/sh_rpt_advanced.lua"
}

for _, filePath in ipairs(sharedFiles) do
	if file.Exists(filePath, "LUA") then
		include(filePath)
	else
		print("[REALISTIC_POLICE] ERROR: Shared file not found - " .. filePath)
	end
end

if SERVER then 
	-- Load server files
	local serverFiles = {
		"realistic_police/server/sv_rpt_function.lua",
		"realistic_police/server/sv_rpt_hook.lua",
		"realistic_police/server/sv_rpt_net.lua",
		"realistic_police/server/sv_rpt_tool.lua"
	}
	
	for _, filePath in ipairs(serverFiles) do
		if file.Exists(filePath, "LUA") then
			include(filePath)
		else
			print("[REALISTIC_POLICE] ERROR: Server file not found - " .. filePath)
		end
	end

	-- Add client files to download
	local clientFiles = {
		"realistic_police/client/cl_rpt_main.lua",
		"realistic_police/client/cl_rpt_fonts.lua",
		"realistic_police/client/cl_rpt_criminal.lua",
		"realistic_police/client/cl_rpt_listreport.lua",
		"realistic_police/client/cl_rpt_report.lua",
		"realistic_police/client/cl_rpt_firefox.lua",
		"realistic_police/client/cl_rpt_camera.lua",
		"realistic_police/client/cl_rpt_license.lua",
		"realistic_police/client/cl_rpt_cmd.lua",
		"realistic_police/client/cl_rpt_fining.lua",
		"realistic_police/client/cl_rpt_handcuff.lua",
		"realistic_police/client/cl_rpt_notify.lua"
	}
	
	for _, filePath in ipairs(clientFiles) do
		if file.Exists(filePath, "LUA") then
			AddCSLuaFile(filePath)
		else
			print("[REALISTIC_POLICE] ERROR: Client file not found - " .. filePath)
		end
	end
	
	-- Add shared files to download
	for _, filePath in ipairs(sharedFiles) do
		if file.Exists(filePath, "LUA") then
			AddCSLuaFile(filePath)
		end
	end
	
else 
	-- Load client files
	local clientFiles = {
		"realistic_police/client/cl_rpt_criminal.lua",
		"realistic_police/client/cl_rpt_listreport.lua",
		"realistic_police/client/cl_rpt_report.lua",
		"realistic_police/client/cl_rpt_firefox.lua",
		"realistic_police/client/cl_rpt_camera.lua",
		"realistic_police/client/cl_rpt_license.lua",
		"realistic_police/client/cl_rpt_cmd.lua",
		"realistic_police/client/cl_rpt_fining.lua",
		"realistic_police/client/cl_rpt_handcuff.lua",
		"realistic_police/client/cl_rpt_notify.lua",
		"realistic_police/client/cl_rpt_main.lua",
		"realistic_police/client/cl_rpt_fonts.lua"
	}
	
	for _, filePath in ipairs(clientFiles) do
		if file.Exists(filePath, "LUA") then
			include(filePath)
		else
			print("[REALISTIC_POLICE] ERROR: Client file not found - " .. filePath)
		end
	end
end 