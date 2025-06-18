-- INITIALIZE SCRIPT
if SERVER then
	-- Load server files
	local serverFiles = file.Find( "crate_robbery/server/*.lua", "LUA" )
	for k, v in ipairs( serverFiles ) do
		local filePath = "crate_robbery/server/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			print("[SUPPLY_CRATE] Loaded server file: " .. v)
		else
			print("[SUPPLY_CRATE] ERROR: Server file not found - " .. v)
		end
	end
	
	-- Add client files to download
	local clientFiles = file.Find( "crate_robbery/client/*.lua", "LUA" )
	for k, v in ipairs( clientFiles ) do
		local filePath = "crate_robbery/client/" .. v
		if file.Exists( filePath, "LUA" ) then
			AddCSLuaFile( filePath )
			print("[SUPPLY_CRATE] Added client file: " .. v)
		else
			print("[SUPPLY_CRATE] ERROR: Client file not found - " .. v)
		end
	end
	
	-- Load shared files efficiently
	local sharedFiles = file.Find( "crate_robbery/shared/*.lua", "LUA" )
	for k, v in ipairs( sharedFiles ) do
		local filePath = "crate_robbery/shared/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			AddCSLuaFile( filePath )
			print("[SUPPLY_CRATE] Loaded shared file: " .. v)
		else
			print("[SUPPLY_CRATE] ERROR: Shared file not found - " .. v)
		end
	end
end

if CLIENT then
	-- Load client files
	local clientFiles = file.Find( "crate_robbery/client/*.lua", "LUA" )
	for k, v in ipairs( clientFiles ) do
		local filePath = "crate_robbery/client/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			print("[SUPPLY_CRATE] Loaded client file: " .. v)
		else
			print("[SUPPLY_CRATE] ERROR: Client file not found - " .. v)
		end
	end
	
	-- Load shared files
	local sharedFiles = file.Find( "crate_robbery/shared/*.lua", "LUA" )
	for k, v in ipairs( sharedFiles ) do
		local filePath = "crate_robbery/shared/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			print("[SUPPLY_CRATE] Loaded shared file: " .. v)
		else
			print("[SUPPLY_CRATE] ERROR: Shared file not found - " .. v)
		end
	end
end