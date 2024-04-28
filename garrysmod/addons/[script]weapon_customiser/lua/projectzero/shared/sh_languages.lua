--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

PROJECT0.TEMP.Languages = {}

local languageMeta = {
	Register = function( self )
        PROJECT0.TEMP.Languages[self.ID] = self
	end,
	SetName = function( self, name )
        self.Name = name
	end,
	SetLanguageCode = function( self, code )
        self.LanguageCode = code
	end,
	AddLanguageStrings = function( self, strings )
        table.Merge( self.Strings, strings )
	end
}

languageMeta.__index = languageMeta

function PROJECT0.FUNC.CreateLanguage( id )
	local language = {
		ID = id,
		Strings = {}
	}
	
	setmetatable( language, languageMeta )
	
	return language
end

for k, v in ipairs( file.Find( "projectzero/languages/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/languages/" .. v )
	include( "projectzero/languages/" .. v )
end

local currentLanguage, languageStrings
function PROJECT0.L( key, ... )
	if( currentLanguage != PROJECT0.CONFIG.GENERAL.Language ) then
		currentLanguage = PROJECT0.CONFIG.GENERAL.Language
		languageStrings = PROJECT0.TEMP.Languages[PROJECT0.CONFIG.GENERAL.Language].Strings
	end

	return string.format( languageStrings[key] or "MISSING LANGUAGE", ... )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
