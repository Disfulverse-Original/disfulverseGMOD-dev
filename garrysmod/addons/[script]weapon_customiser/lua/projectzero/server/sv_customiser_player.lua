--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- DATA FUNCTIONS --
hook.Add( "Project0.Hooks.PlayerLoadData", "Project0.Botched.Hooks.PlayerLoadData.Customiser", function( ply, userID )
    PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_skins WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        local ownedSkins = {}
        for k, v in ipairs( data ) do
            local skinID = tonumber( v.skinID or "" )
            if( not skinID ) then continue end

            ownedSkins[skinID] = ownedSkins[skinID] or {}
            ownedSkins[skinID][v.weaponClass] = true
        end

        ply:Project0():SetOwnedSkins( ownedSkins )
        ply:Project0():SendOwnedSkins( unpack( table.GetKeys( ownedSkins ) ) )
    end )

    PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_weapons WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        local customisedWeapons = {}
        for k, v in ipairs( data ) do
            customisedWeapons[v.weaponClass] = {
                Skin = tonumber( v.skinID or "0" ),
                Charm = tonumber( v.charmID or "0" ),
                Sticker = tonumber( v.stickerID or "0" )
            }
        end

        ply:Project0():SetCustomisedWeapons( customisedWeapons )
        ply:Project0():SendCustomisedWeapons( unpack( table.GetKeys( customisedWeapons ) ) )
    end )

    PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_cosmetics WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        local cosmeticInventory = {}
        for k, v in ipairs( data ) do
            cosmeticInventory[v.type .. "_" .. v.itemKey] = true
        end

        ply:Project0():SetCosmeticInventory( cosmeticInventory )
        ply:Project0():SendCosmeticInventory( unpack( table.GetKeys( cosmeticInventory ) ) )
    end )
end )

-- INVENTORY FUNCTIONS --
function PROJECT0.PLAYERMETA:SetCosmeticInventory( cosmeticInventory )
    self.CosmeticInventory = cosmeticInventory
end

util.AddNetworkString( "Project0.SendCosmeticInventory" )
function PROJECT0.PLAYERMETA:SendCosmeticInventory( ... )
    local inventoryKeys = { ... }

    net.Start( "Project0.SendCosmeticInventory" )
        net.WriteUInt( #inventoryKeys, 8 )
        for _, v in ipairs( inventoryKeys ) do
            net.WriteString( v )
        end
    net.Send( self.Player )
end

function PROJECT0.PLAYERMETA:AddCosmeticItem( type, itemKey )
    if( not PROJECT0.COSMETIC_TYPES[type] ) then return end
    
    local cosmeticKey = PROJECT0.FUNC.GetCosmeticKey( type, itemKey )

    local cosmeticInventory = self:GetCosmeticInventory()
    if( cosmeticInventory[cosmeticKey] ) then return end

    cosmeticInventory[cosmeticKey] = true

    self:SetCosmeticInventory( cosmeticInventory )
    self:SendCosmeticInventory( cosmeticKey )

    PROJECT0.FUNC.SQLQuery( "INSERT INTO projectzero_cosmetics( userID, type, itemKey ) VALUES(" .. self:GetUserID() .. ", " .. type .. ", '" .. itemKey .. "');" )
end

-- WEAPON FUNCTIONS --
function PROJECT0.PLAYERMETA:SetCustomisedWeapons( customisedWeapons )
    self.CustomisedWeapons = customisedWeapons
end

util.AddNetworkString( "Project0.SendCustomisedWeapons" )
function PROJECT0.PLAYERMETA:SendCustomisedWeapons( ... )
    local weaponClasses = { ... }

    net.Start( "Project0.SendCustomisedWeapons" )
        net.WriteUInt( #weaponClasses, 8 )
        for _, v in ipairs( weaponClasses ) do
            net.WriteString( v )

            local weaponInfo = self.CustomisedWeapons[v]
            net.WriteUInt( weaponInfo.Skin, 8 )
            net.WriteUInt( weaponInfo.Charm, 8 )
            net.WriteUInt( weaponInfo.Sticker, 8 )
        end
    net.Send( self.Player )
end

function PROJECT0.PLAYERMETA:SetCustomisedWeapon( weaponClass, skinID, charmID, stickerID )
    local customisedWeapons = self:GetCustomisedWeapons()
    local newCustomisation = customisedWeapons[weaponClass] or {}
    
    newCustomisation = {
        Skin = skinID or (newCustomisation.Skin or 0),
        Charm = charmID or (newCustomisation.Charm or 0),
        Sticker = stickerID or (newCustomisation.Sticker or 0)
    }

    customisedWeapons[weaponClass] = newCustomisation

    self:SetCustomisedWeapons( customisedWeapons )
    self:SendCustomisedWeapons( weaponClass )

    PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_weapons WHERE userID = '" .. self:GetUserID() .. "' AND weaponClass = '" .. weaponClass .. "';", function( data )
        if( data ) then
            PROJECT0.FUNC.SQLQuery( "UPDATE projectzero_weapons SET skinID = " .. newCustomisation.Skin .. ", charmID = " .. newCustomisation.Charm ..  ", stickerID = " .. newCustomisation.Sticker .. " WHERE userID = '" .. self:GetUserID() .. "' AND weaponClass = '" .. weaponClass .. "';" )
        else
            PROJECT0.FUNC.SQLQuery( "INSERT INTO projectzero_weapons( userID, weaponClass, skinID, charmID, stickerID ) VALUES(" .. self:GetUserID() .. ", '" .. weaponClass .. "', " .. newCustomisation.Skin .. ", " .. newCustomisation.Charm .. ", " .. newCustomisation.Sticker .. ");" )
        end
    end, true )
end

-- SKIN FUNCTIONS --
function PROJECT0.PLAYERMETA:SetOwnedSkins( ownedSkins )
    self.OwnedSkins = ownedSkins
end

util.AddNetworkString( "Project0.SendOwnedSkins" )
function PROJECT0.PLAYERMETA:SendOwnedSkins( ... )
    local skinKeys = { ... }

    net.Start( "Project0.SendOwnedSkins" )
        net.WriteUInt( #skinKeys, 8 )
        for _, v in ipairs( skinKeys ) do
            net.WriteUInt( v, 8 )

            local weaponList = self.OwnedSkins[v] or {}
            net.WriteUInt( table.Count( weaponList ), 8 )

            for k, _ in pairs( weaponList ) do
                net.WriteString( k )
            end
        end
    net.Send( self.Player )
end

function PROJECT0.PLAYERMETA:AddWeaponSkin( skinID, ... )
    if( not PROJECT0.DEVCONFIG.WeaponSkins[skinID] ) then return end

    local ownedSkins = self:GetOwnedSkins()

    if( not ownedSkins[skinID] ) then
        ownedSkins[skinID] = {}
    end

    local weapons = { ... }
    
    for k, v in ipairs( weapons ) do
        ownedSkins[skinID][v] = true
        PROJECT0.FUNC.SQLQuery( "INSERT INTO projectzero_skins( userID, skinID, weaponClass ) VALUES(" .. self:GetUserID() .. ", " .. skinID .. ", '" .. v .. "');" )
    end

    self:SetOwnedSkins( ownedSkins )
    self:SendOwnedSkins( skinID )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
