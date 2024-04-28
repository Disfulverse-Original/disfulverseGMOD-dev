--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- VARIABLE TYPES --
PROJECT0.TYPE = {
	Int = "Int",
	String = "String",
	Bool = "Bool",
	Table = "Table"
}

PROJECT0.TYPEFUNCS = {
	Int = {
		NetWrite = function( value )
			net.WriteInt( value, 32 )
		end,
		NetRead = function()
			return net.ReadInt( 32 )
		end
	},
	String = {
		NetWrite = function( value )
			net.WriteString( value )
		end,
		NetRead = function()
			return net.ReadString()
		end
	},
	Bool = {
		NetWrite = function( value )
			net.WriteBool( value )
		end,
		NetRead = function()
			return net.ReadBool()
		end
	},
	Table = {
		NetWrite = function( value )
			net.WriteString( util.TableToJSON( value ) )
		end,
		NetRead = function()
			return util.JSONToTable( net.ReadString() )
		end,
		CopyFunc = function( value )
			return table.Copy( value )
		end
	}
}

function PROJECT0.FUNC.GetConfigVariableType( module, variable )
	if( not PROJECT0.CONFIGMETA[module] or not PROJECT0.CONFIGMETA[module].Variables ) then return end
	return PROJECT0.CONFIGMETA[module].Variables[variable].Type
end

function PROJECT0.FUNC.CopyTypeValue( type, value )
	if( not type or not PROJECT0.TYPEFUNCS[type] or not PROJECT0.TYPEFUNCS[type].CopyFunc ) then return value end
	return PROJECT0.TYPEFUNCS[type].CopyFunc( value )
end

function PROJECT0.FUNC.WriteTypeValue( type, value )
	if( not type or not PROJECT0.TYPEFUNCS[type] ) then return end
	PROJECT0.TYPEFUNCS[type].NetWrite( value )
end

function PROJECT0.FUNC.ReadTypeValue( type )
	if( not type or not PROJECT0.TYPEFUNCS[type] ) then return end
	return PROJECT0.TYPEFUNCS[type].NetRead()
end

-- MODULE META --
PROJECT0.CONFIGMETA = {}

local cfgModuleMeta = {
	Register = function( self )
        PROJECT0.CONFIGMETA[self.ID] = self
	end,
	SetTitle = function( self, title )
        self.Title = title
	end,
	SetIcon = function( self, icon )
        self.Icon = icon
	end,
	SetDescription = function( self, description )
        self.Description = description
	end,
	SetSortOrder = function( self, sortOrder )
        self.SortOrder = sortOrder
	end,
	AddVariable = function( self, variable, name, description, type, default, vguiElement, getOptions )
        self.Variables[variable] = {
			Name = name,
			Description = description,
			Type = type,
			VguiElement = vguiElement or (type == PROJECT0.TYPE.Table && "DPanel"),
			GetOptions = getOptions,
			Default = default,
			Order = table.Count( self.Variables )+1
		}
	end,
	GetSortedVariables = function( self )
		local sortedVariables = {}
        for k, v in pairs( self.Variables ) do
			local data = v
			data.Key = k

			table.insert( sortedVariables, data )
		end

		table.SortByMember( sortedVariables, "Order", true )
		return sortedVariables
	end,
	GetConfigDefaultValue = function( self, variable )
		return self.Variables[variable].Default
	end,
	GetConfigValue = function( self, variable )
		return PROJECT0.FUNC.CopyTypeValue( self.Variables[variable].Type, PROJECT0.CONFIG[self.ID][variable] or self.Variables[variable].Default )
	end
}

cfgModuleMeta.__index = cfgModuleMeta

function PROJECT0.FUNC.CreateConfigModule( id )
	local module = {
		ID = id,
		Variables = {},
		SortOrder = 0
	}
	
	setmetatable( module, cfgModuleMeta )
	
	return module
end

-- CONFIG LOAD --
for k, v in ipairs( file.Find( "projectzero/config/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/config/" .. v )
	include( "projectzero/config/" .. v )
end

if( not file.Exists( "projectzero/config", "DATA" ) ) then
	file.CreateDir( "projectzero/config" )
end

PROJECT0.CONFIG = {}
for k, v in pairs( PROJECT0.CONFIGMETA ) do
	local savedModule = util.JSONToTable( file.Read( "projectzero/config/" .. k .. ".txt", "DATA" ) or "" ) or {}

	local module = {}
	for key, val in pairs( v.Variables ) do
		module[key] = savedModule[key] or val.Default
	end

	PROJECT0.CONFIG[k] = module
end

PROJECT0.CONFIG_LOADED = true
hook.Run( "Project0.Hooks.ConfigLoaded" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
