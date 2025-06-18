/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___|_|  \___/ 
                                      |___/                                        
*/

if not PermaProps then PermaProps = {} end

print("---------------------------------")
print("| Loading ServerSide PermaProps |")
print("---------------------------------")

local serverFiles = file.Find("permaprops/sv_*.lua", "LUA")
if serverFiles then
	for k, v in ipairs(serverFiles) do
		local filePath = "permaprops/" .. v
		if file.Exists(filePath, "LUA") then
			include(filePath)
			print("[PERMAPROPS] Loaded server: " .. v)
		else
			print("[PERMAPROPS] ERROR: Server file not found - " .. v)
		end
	end
end

print("-----------------------------")
print("| Loading Shared PermaProps |")
print("-----------------------------")

local sharedFiles = file.Find("permaprops/sh_*.lua", "LUA")
if sharedFiles then
	for k, v in ipairs(sharedFiles) do
		local filePath = "permaprops/" .. v
		if file.Exists(filePath, "LUA") then
			AddCSLuaFile(filePath)
			include(filePath)
			print("[PERMAPROPS] Loaded shared: " .. v)
		else
			print("[PERMAPROPS] ERROR: Shared file not found - " .. v)
		end
	end
end

print("---------------------------------")
print("| Loading ClientSide PermaProps |")
print("---------------------------------")

local clientFiles = file.Find("permaprops/cl_*.lua", "LUA")
if clientFiles then
	for k, v in ipairs(clientFiles) do
		local filePath = "permaprops/" .. v
		if file.Exists(filePath, "LUA") then
			AddCSLuaFile(filePath)
			print("[PERMAPROPS] Added client: " .. v)
		else
			print("[PERMAPROPS] ERROR: Client file not found - " .. v)
		end
	end
end

print("-------------------------------")