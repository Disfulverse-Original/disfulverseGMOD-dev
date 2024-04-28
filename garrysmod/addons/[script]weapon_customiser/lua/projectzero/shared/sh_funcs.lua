--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

function PROJECT0.FUNC.GetWeaponName( weaponClass )
	if( weapons.GetStored( weaponClass ) and weapons.GetStored( weaponClass ).PrintName ) then
		return weapons.GetStored( weaponClass ).PrintName or weaponClass
	end

    return weaponClass
end

function PROJECT0.FUNC.GetWeaponModel( weaponClass )
	if( weapons.GetStored( weaponClass ) and weapons.GetStored( weaponClass ).WorldModel ) then
		return weapons.GetStored( weaponClass ).WorldModel
	elseif( PROJECT0.DEVCONFIG.WeaponModels[weaponClass] ) then
		return PROJECT0.DEVCONFIG.WeaponModels[weaponClass]
	end
end

function PROJECT0.FUNC.HasAdminAccess( ply )
	return ply:IsSuperAdmin()
end

function PROJECT0.FUNC.GetFirstRarity()
	local lowest
	for k, v in pairs( PROJECT0.CONFIG.GENERAL.Rarities ) do
		if( lowest and PROJECT0.CONFIG.GENERAL.Rarities[lowest].Order <= v.Order ) then continue end
		lowest = k
	end

	return lowest
end

function PROJECT0.FUNC.GetRarityOrder( rarity )
	return (PROJECT0.CONFIG.GENERAL.Rarities[rarity] or {}).Order or 0
end

function PROJECT0.FUNC.GetRarityName( rarity )
	return (PROJECT0.CONFIG.GENERAL.Rarities[rarity] or {}).Title or rarity
end

function PROJECT0.FUNC.GetRarityColor( rarity )
	return (PROJECT0.CONFIG.GENERAL.Rarities[rarity] or {}).Colors or { Color( 255, 0, 0 ) }
end

function PROJECT0.FUNC.GetModelMaterials( modelPath )
	local tempEntity = ClientsideModel( modelPath )
	tempEntity:Spawn()

	local materialsTable = {}
	for i = 0, #tempEntity:GetMaterials()-1 do
		materialsTable[i] = tempEntity:GetMaterials()[i+1]
	end

	tempEntity:Remove()
	return materialsTable
end

function PROJECT0.FUNC.UTCTime()
	return os.time( os.date( "!*t" ) )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
