-- INITIALIZE SCRIPT
if SERVER then
	-- Load shared files efficiently
	local sharedFiles = file.Find( "ch_bitminers/shared/*.lua", "LUA" )
	for k, v in ipairs( sharedFiles ) do
		local filePath = "ch_bitminers/shared/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			AddCSLuaFile( filePath )
		else
			print( "[CH_BITMINERS] ERROR: Shared file not found - " .. v )
		end
	end
	
	-- Load server files
	local serverFiles = file.Find( "ch_bitminers/server/*.lua", "LUA" )
	for k, v in ipairs( serverFiles ) do
		local filePath = "ch_bitminers/server/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
		else
			print( "[CH_BITMINERS] ERROR: Server file not found - " .. v )
		end
	end
	
	-- Add client files to download
	local clientFiles = file.Find( "ch_bitminers/client/*.lua", "LUA" )
	for k, v in ipairs( clientFiles ) do
		local filePath = "ch_bitminers/client/" .. v
		if file.Exists( filePath, "LUA" ) then
			AddCSLuaFile( filePath )
		else
			print( "[CH_BITMINERS] ERROR: Client file not found - " .. v )
		end
	end
end

if CLIENT then
	-- Load shared files
	local sharedFiles = file.Find( "ch_bitminers/shared/*.lua", "LUA" )
	for k, v in ipairs( sharedFiles ) do
		local filePath = "ch_bitminers/shared/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
		else
			print( "[CH_BITMINERS] ERROR: Shared file not found - " .. v )
		end
	end
	
	-- Load client files
	local clientFiles = file.Find( "ch_bitminers/client/*.lua", "LUA" )
	for k, v in ipairs( clientFiles ) do
		local filePath = "ch_bitminers/client/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
		else
			print( "[CH_BITMINERS] ERROR: Client file not found - " .. v )
		end
	end
end