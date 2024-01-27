--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

function PROJECT0.FUNC.GetSkinRarity( skinID )
	return (PROJECT0.CONFIG.CUSTOMISER.Skins[skinID] or {}).Rarity or PROJECT0.FUNC.GetFirstRarity()
end

function PROJECT0.FUNC.GetCosmeticKey( type, itemKey )
	return type .. "_" .. itemKey
end

function PROJECT0.FUNC.ReverseCosmeticKey( key )
	local split = string.Split( key, "_" )
	return tonumber( split[1] or "0" ), tonumber( split[2] or "0" )
end

PROJECT0.COSMETIC_TYPES = {
	CHARM = 1,
	STICKER = 2,
	SKIN = 3
}

for k, v in pairs( PROJECT0.COSMETIC_TYPES ) do
	PROJECT0.COSMETIC_TYPES[v] = k
end

-- WEAPON PACK META --
PROJECT0.TEMP.WeaponPacks = {}

local weaponPackMeta = {
	Register = function( self )
        PROJECT0.TEMP.WeaponPacks[self.ID] = self
	end,
	SetTitle = function( self, title )
        self.Title = title
	end,
	AddWeapon = function( self, weaponClass, weaponData )
        self.Weapons[weaponClass] = isstring( weaponData ) and util.JSONToTable( weaponData ) or weaponData
	end
}

weaponPackMeta.__index = weaponPackMeta

function PROJECT0.FUNC.CreateWeaponsPack( id )
	local weaponPack = {
		ID = id,
		Weapons = {}
	}
	
	setmetatable( weaponPack, weaponPackMeta )
	
	return weaponPack
end

for k, v in ipairs( file.Find( "projectzero/configured_weapons/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/configured_weapons/" .. v )
	include( "projectzero/configured_weapons/" .. v )
end

function PROJECT0.FUNC.LoadConfiguredWeapons()
	local weaponsList = {}
	for _, weaponPack in pairs( table.Copy( PROJECT0.TEMP.WeaponPacks ) ) do
		for weaponClass, weaponData in pairs( weaponPack.Weapons ) do
			weaponsList[weaponClass] = weaponData
		end
	end

	for weaponClass, weaponData in pairs( table.Copy( (PROJECT0.CONFIG.CUSTOMISER or {}).Weapons or {} ) ) do
		if( not weaponsList[weaponClass] ) then
			weaponsList[weaponClass] = weaponData
			continue
		elseif( weaponData.Disabled == true ) then
			weaponsList[weaponClass] = nil
			continue
		end

		for k, v in pairs( weaponData ) do
			weaponsList[weaponClass][k] = v
		end
	end

	PROJECT0.TEMP.ConfiguredWeapons = weaponsList
end
PROJECT0.FUNC.LoadConfiguredWeapons()

hook.Add( "Project0.Hooks.ConfigUpdated", "Project0.Hooks.ConfigUpdated.ConfiguredWeapons", function() 
	PROJECT0.FUNC.LoadConfiguredWeapons()
end )

function PROJECT0.FUNC.GetConfiguredWeapons()
	if( not PROJECT0.TEMP.ConfiguredWeapons ) then
		PROJECT0.FUNC.LoadConfiguredWeapons()
	end

	return PROJECT0.TEMP.ConfiguredWeapons
end

function PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )
	return PROJECT0.FUNC.GetConfiguredWeapons()[weaponClass]
end

-- STORE CURRENCY --
function PROJECT0.FUNC.TakeStoreCurrency( ply, amount )
	local currency = PROJECT0.TEMP.Currencies[PROJECT0.CONFIG.CUSTOMISER.StoreCurrency]
	if( not currency or not currency.IsInstalled() ) then
		print( "[PROJECT0] Error, cosmetic store currency is invalid." )
		return
	end

	currency.TakeCurrency( ply, amount )
end

function PROJECT0.FUNC.GetStoreCurrency( ply )
	local currency = PROJECT0.TEMP.Currencies[PROJECT0.CONFIG.CUSTOMISER.StoreCurrency]
	if( not currency or not currency.IsInstalled() ) then
		print( "[PROJECT0] Error, cosmetic store currency is invalid." )
		return 0
	end

	return currency.GetCurrency( ply, amount )
end

function PROJECT0.FUNC.FormatStoreCurrency( amount )
	local currency = PROJECT0.TEMP.Currencies[PROJECT0.CONFIG.CUSTOMISER.StoreCurrency]
	if( not currency or not currency.IsInstalled() ) then
		print( "[PROJECT0] Error, cosmetic store currency is invalid." )
		return amount
	end

	return currency.FormatCurrency( amount )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
