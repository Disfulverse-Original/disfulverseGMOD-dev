--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- INVENTORY FUNCTIONS --
function PROJECT0.PLAYERMETA:GetCosmeticInventory()
	return self.CosmeticInventory or {}
end

function PROJECT0.PLAYERMETA:GetOwnsCosmetic( type, itemKey )
	local cosmeticInventory = self:GetCosmeticInventory()
	return tobool( cosmeticInventory[PROJECT0.FUNC.GetCosmeticKey( type, itemKey )] )
end

-- WEAPON FUNCTIONS --
function PROJECT0.PLAYERMETA:GetCustomisedWeapons()
	return self.CustomisedWeapons or {}
end

function PROJECT0.PLAYERMETA:GetEquippedCosmetic( type, weaponClass )
	local customisedWeapons = self:GetCustomisedWeapons()
	return (customisedWeapons[weaponClass] or {})[type] or 0
end

-- SKIN FUNCTIONS --
function PROJECT0.PLAYERMETA:GetOwnedSkins()
	return self.OwnedSkins or {}
end

-- GENERAL FUNCTIONS --
function PROJECT0.PLAYERMETA:GetOwnsCosmeticType( type, itemID, weapons )
	if( type == 3 ) then
        local ownedSkins = self:GetOwnedSkins()
        
        if( ownedSkins[itemID] ) then
			if( ownedSkins[itemID]["*"] ) then return true end

            local doesntOwn = false
            for k, v in ipairs( weapons ) do
                if( ownedSkins[itemID][v] ) then continue end
                doesntOwn = true
                break
            end

            return not doesntOwn
        end

		return false
    end

	return self:GetOwnsCosmetic( type, itemID )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
