--[[ Global Variables/Tables ]]--
BRICKS_SERVER = BRICKS_SERVER or {}
BRICKS_SERVER.Func = BRICKS_SERVER.Func or {}
BRICKS_SERVER.TEMP = BRICKS_SERVER.TEMP or {}

--[[ Modules Prep ]]--
BRICKS_SERVER.Modules = {}
local moduleMeta = {
	GetFolderName = function( self )
		return self.FolderName
	end,
	AddSubModule = function( self, folderName, name )
		BRICKS_SERVER.Modules[self:GetFolderName()][3][folderName] = name
	end
}

moduleMeta.__index = moduleMeta

function BRICKS_SERVER.Func.AddModule( folderName, name, icon, version )
	BRICKS_SERVER.Modules[folderName] = { name, icon, {}, version }
	
	local module = {
		FolderName = folderName
	}
	
	setmetatable( module, moduleMeta )
	
	return module
end

--[[ Autorun files ]]--
for k, v in pairs( file.Find( "bricks_server/*.lua", "LUA" ) ) do
	if( string.StartWith( v, "bricks_server_autorun_" ) ) then
		AddCSLuaFile( "bricks_server/" .. v )
		include( "bricks_server/" .. v )
	end
end

--[[ CONFIG LOADER ]]--
for k, v in pairs( file.Find( "bricks_server/*.lua", "LUA" ) ) do
	if( string.StartWith( v, "bricks_server_luacfg_" ) ) then
		AddCSLuaFile( "bricks_server/" .. v )
		include( "bricks_server/" .. v )
	end
end

BRICKS_SERVER.BASECONFIG = {}
AddCSLuaFile( "bricks_server/bricks_server_basecfg_main.lua" )
include( "bricks_server/bricks_server_basecfg_main.lua" )
hook.Run( "BRS.Hooks.BaseConfigLoad" )

BRICKS_SERVER.CONFIG = table.Copy( BRICKS_SERVER.BASECONFIG )


resource.AddFile("resource/fonts/montserrat-medium.ttf")
resource.AddFile("resource/fonts/montserrat-bold.ttf")

BRICKS_SERVER.CONFIG_LOADED = false
function BRICKS_SERVER.Func.LoadConfig()
	for k, v in pairs( file.Find( "bricks_server/config/*", "DATA" ) ) do
		local dataTable = util.JSONToTable( file.Read( "bricks_server/config/" .. v, "DATA" ) )

		if( dataTable and istable( dataTable ) ) then
			BRICKS_SERVER.CONFIG[string.upper( string.Replace( v, ".txt", "" ) )] = dataTable
		end
	end

	-- 23/03/2022 config update for crafting skills
	if( BRICKS_SERVER.CONFIG.CRAFTING and not BRICKS_SERVER.CONFIG.CRAFTING.Skills ) then
		BRICKS_SERVER.CONFIG.CRAFTING.Skills = table.Copy( BRICKS_SERVER.BASECONFIG.CRAFTING.Skills )
	end

	if( BRICKS_SERVER.CONFIG.CRAFTING and not BRICKS_SERVER.CONFIG.CRAFTING.CraftTools ) then
		BRICKS_SERVER.CONFIG.CRAFTING.CraftTools = table.Copy( BRICKS_SERVER.BASECONFIG.CRAFTING.CraftTools )
		print("CRAFT TOOLS LOADED!")
	end

	if( BRICKS_SERVER.CONFIG.CRAFTING and not BRICKS_SERVER.CONFIG.CRAFTING.Blueprints ) then
		BRICKS_SERVER.CONFIG.CRAFTING.Blueprints = table.Copy( BRICKS_SERVER.BASECONFIG.CRAFTING.Blueprints )
		print("BLUEPRINTS LOADED!")
	end
	
end
BRICKS_SERVER.Func.LoadConfig()

BRICKS_SERVER.CONFIG_LOADED = true
hook.Run( "BRS.Hooks.ConfigLoad" )

function BRICKS_SERVER.Func.AddLanguageStrings( languageKey, stringTable )
	if( not BRICKS_SERVER.Languages[languageKey] ) then
		BRICKS_SERVER.Languages[languageKey] = stringTable
	else
		table.Merge( BRICKS_SERVER.Languages[languageKey], stringTable )
	end
end

function BRICKS_SERVER.Func.LoadLanguages()
	BRICKS_SERVER.Languages = {}
	local files, directories = file.Find( "bricks_server/languages/*", "LUA" )
	for k, v in pairs( directories ) do
		for key, val in pairs( file.Find( "bricks_server/languages/" .. v .. "/*", "LUA" ) ) do
			AddCSLuaFile( "bricks_server/languages/" .. v .. "/" .. val )
			include( "bricks_server/languages/" .. v .. "/" .. val )
		end
	end
end
BRICKS_SERVER.Func.LoadLanguages()

function BRICKS_SERVER.Func.L( languageKey, ... )
	local languageTable = BRICKS_SERVER.Languages[BRICKS_SERVER.CONFIG.LANGUAGE.Language or "english"] or BRICKS_SERVER.Languages["english"]

	local languageString = ((languageTable or {})[languageKey] or BRICKS_SERVER.Languages["english"][languageKey]) or "MISSING LANGUAGE"

	local configLanguageTable = (BRICKS_SERVER.CONFIG.LANGUAGE.Languages or {})[BRICKS_SERVER.CONFIG.LANGUAGE.Language or "english"]

	if( configLanguageTable and configLanguageTable[2] and configLanguageTable[2][languageKey] ) then
		languageString = configLanguageTable[2][languageKey]
	end

	return (not ... and languageString) or string.format( languageString, ... )
end

function BRICKS_SERVER.Func.GetTheme( key, alpha )
	local color = Color( 0, 0, 0 )
	if( BRICKS_SERVER.BASECONFIG.THEME[key] ) then
		if( (BS_ConfigCopyTable or BRICKS_SERVER.CONFIG).THEME[key] ) then
			color = (BS_ConfigCopyTable or BRICKS_SERVER.CONFIG).THEME[key]
		else
			color = BRICKS_SERVER.BASECONFIG.THEME[key]
		end
	end

	if( alpha ) then
		color = Color( color.r, color.g, color.b, alpha )
	end

	return color
end

function BRICKS_SERVER.Func.IsModuleEnabled( moduleName )
	if( BRICKS_SERVER.Modules[moduleName] ) then
		return BRICKS_SERVER.CONFIG.MODULES[moduleName] and BRICKS_SERVER.CONFIG.MODULES[moduleName][1] == true
	end
	
	return false
end

function BRICKS_SERVER.Func.IsSubModuleEnabled( moduleName, subModuleName )
	if( BRICKS_SERVER.Modules[moduleName] ) then
		return BRICKS_SERVER.Func.IsModuleEnabled( moduleName ) and BRICKS_SERVER.CONFIG.MODULES[moduleName][2][subModuleName]
	end
	
	return false
end

local function LoadClientConfig()
	BRICKS_SERVER.BASECLIENTCONFIG = BRICKS_SERVER.BASECLIENTCONFIG or {}
	hook.Run( "BRS.Hooks.ClientConfigLoad" )
end

local function LoadDevConfig()
	BRICKS_SERVER.DEVCONFIG = BRICKS_SERVER.DEVCONFIG or {}
	AddCSLuaFile( "bricks_server/bricks_server_devcfg_main.lua" )
	include( "bricks_server/bricks_server_devcfg_main.lua" )
	hook.Run( "BRS.Hooks.DevConfigLoad" )
end

hook.Run( "BRS.Hooks.SQLLoad" )

LoadClientConfig()
LoadDevConfig()

--[[ Automatic autoruns ]]--
local AutorunTable = {}
AutorunTable[1] = {
	Location = "bricks_server/core/shared/",
	Type = "Shared"
}
AutorunTable[2] = {
	Location = "bricks_server/core/server/",
	Type = "Server"
}
AutorunTable[3] = {
	Location = "bricks_server/core/client/",
	Type = "Client"
}
AutorunTable[4] = {
	Location = "bricks_server/vgui/",
	Type = "Client"
}

for key, val in ipairs( AutorunTable ) do
	for k, v in ipairs( file.Find( val.Location .. "*.lua", "LUA" ) ) do
		if( val.Type == "Shared" ) then
			AddCSLuaFile( val.Location .. v )
			include( val.Location .. v )
		elseif( val.Type == "Client" ) then	
			AddCSLuaFile( val.Location .. v )
		elseif( val.Type == "Server" ) then	
			include( val.Location .. v )
		end
	end
end

hook.Run( "BRS.Hooks.CoreLoaded" )

--[[ MODULES AUTORUN ]]--
local function loadModuleFiles( filePath )
	local moduleFiles, moduleDirectories = file.Find( filePath .. "/*", "LUA" )

	if( not moduleDirectories ) then return end

	for key, val in pairs( moduleDirectories ) do
		for key2, val2 in pairs( file.Find( filePath .. "/" .. val .. "/*.lua", "LUA" ) ) do
			if( val == "shared" ) then
				AddCSLuaFile( filePath .. "/" .. val .. "/" .. val2 )
				include( filePath .. "/" .. val .. "/" .. val2 )
			elseif( val == "server" ) then
				include( filePath .. "/" .. val .. "/" .. val2 )
			elseif( val == "client" or val == "vgui" ) then
				AddCSLuaFile( filePath .. "/" .. val .. "/" .. val2 )
			end
		end
	end
end

if( not BRICKS_SERVER.CONFIG.MODULES["default"] or not BRICKS_SERVER.CONFIG.MODULES["default"][1] ) then
	BRICKS_SERVER.CONFIG.MODULES["default"] = { true, {} }
end

for k, v in pairs( BRICKS_SERVER.CONFIG.MODULES or {} ) do
	if( BRICKS_SERVER.Modules[k] and v[1] == true ) then
		loadModuleFiles( "bricks_server/modules/" .. k )
	else
		continue
	end

	if( table.Count( v[2] ) > 0 ) then
		for key, val in pairs( v[2] ) do
			if( BRICKS_SERVER.Modules[k][3][key] and val == true ) then
				loadModuleFiles( "bricks_server/modules/" .. k .. "/submodules/" .. key )
			end
		end
	end
end

hook.Add( "InitPostEntity", "BRS.InitPostEntity.Loaded", function()
	BRICKS_SERVER.INITPOSTENTITY_LOADED = true
end )

hook.Add( "Initialize", "BRS.Initialize.Loaded", function()
	BRICKS_SERVER.INITIALIZE_LOADED = true
end )