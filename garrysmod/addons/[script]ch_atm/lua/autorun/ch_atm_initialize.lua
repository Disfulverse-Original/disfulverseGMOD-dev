-- INITIALIZE SCRIPT

if SERVER then
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          ATM by Crap-Head | ", color_white, "Initializing server files.\n")
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	
	-- Load shared files efficiently
	local sharedFiles = file.Find( "ch_atm/shared/*.lua", "LUA" )
	for k, v in ipairs( sharedFiles ) do
		local filePath = "ch_atm/shared/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			AddCSLuaFile( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Load shared currencies efficiently
	local currencyFiles = file.Find( "ch_atm/shared/currencies/*.lua", "LUA" )
	for k, v in ipairs( currencyFiles ) do
		local filePath = "ch_atm/shared/currencies/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			AddCSLuaFile( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Load server files
	local serverFiles = file.Find( "ch_atm/server/*.lua", "LUA" )
	for k, v in ipairs( serverFiles ) do
		local filePath = "ch_atm/server/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Load server mysql files
	local mysqlFiles = file.Find( "ch_atm/server/mysql/*.lua", "LUA" )
	for k, v in ipairs( mysqlFiles ) do
		local filePath = "ch_atm/server/mysql/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Load server integrations
	local integrationFiles = file.Find( "ch_atm/server/integrations/*.lua", "LUA" )
	for k, v in ipairs( integrationFiles ) do
		local filePath = "ch_atm/server/integrations/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Add client files to download
	local clientFiles = file.Find( "ch_atm/client/*.lua", "LUA" )
	for k, v in ipairs( clientFiles ) do
		local filePath = "ch_atm/client/" .. v
		if file.Exists( filePath, "LUA" ) then
			AddCSLuaFile( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Added client file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: Client file not found ", color_white, v .."\n" )
		end
	end
	
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          ATM by Crap-Head | ", color_white, "Server files initialized\n" )
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
end

if CLIENT then
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "       ATM by Crap-Head | ", color_white, "Initializing client/shared files\n")
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	
	-- Load shared files
	local sharedFiles = file.Find( "ch_atm/shared/*.lua", "LUA" )
	for k, v in ipairs( sharedFiles ) do
		local filePath = "ch_atm/shared/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Load shared currencies
	local currencyFiles = file.Find( "ch_atm/shared/currencies/*.lua", "LUA" )
	for k, v in ipairs( currencyFiles ) do
		local filePath = "ch_atm/shared/currencies/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	-- Load client files
	local clientFiles = file.Find( "ch_atm/client/*.lua", "LUA" )
	for k, v in ipairs( clientFiles ) do
		local filePath = "ch_atm/client/" .. v
		if file.Exists( filePath, "LUA" ) then
			include( filePath )
			MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
		else
			MsgC( Color( 255, 0, 0 ), "ATM by Crap-Head | ERROR: File not found ", color_white, v .."\n" )
		end
	end
	
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          ATM by Crap-Head | ", color_white, "Client/shared files initialized\n" )
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
end