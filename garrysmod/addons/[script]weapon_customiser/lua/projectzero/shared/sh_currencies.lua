--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

PROJECT0.TEMP.Currencies = {}

local currencyMeta = {
	Register = function( self )
        PROJECT0.TEMP.Currencies[self.ID] = self
	end,
	SetTitle = function( self, title )
        self.Title = title
	end,
	SetInstalledFunction = function( self, func )
        self.IsInstalled = func
	end,
	SetAddCurrency = function( self, func )
        self.AddCurrency = func
	end,
	SetTakeCurrency = function( self, func )
        self.TakeCurrency = func
	end,
	SetGetCurrency = function( self, func )
        self.GetCurrency = func
	end,
	SetFormatCurrency = function( self, func )
        self.FormatCurrency = func
	end
}

currencyMeta.__index = currencyMeta

function PROJECT0.FUNC.CreateCurrency( id )
	local currency = {
		ID = id
	}
	
	setmetatable( currency, currencyMeta )
	
	return currency
end

for k, v in ipairs( file.Find( "projectzero/currencies/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/currencies/" .. v )
	include( "projectzero/currencies/" .. v )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
