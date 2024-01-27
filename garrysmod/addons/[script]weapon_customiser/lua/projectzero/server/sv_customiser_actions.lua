--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

util.AddNetworkString( "Project0.RequestEquipSkin" )
net.Receive( "Project0.RequestEquipSkin", function( len, ply )
    local skinKey = net.ReadUInt( 8 )
    local weaponClass = net.ReadString()
    if( not skinKey or not weaponClass or not PROJECT0.FUNC.GetConfiguredWeapon( weaponClass ) ) then return end

    if( not PROJECT0.DEVCONFIG.WeaponSkins[skinKey] ) then
        if( skinKey != 0 or ply:Project0():GetEquippedCosmetic( "Skin", weaponClass ) == 0 ) then return end
        
        ply:Project0():SetCustomisedWeapon( weaponClass, skinKey )
        return
    end

    local ownedSkins = ply:Project0():GetOwnedSkins()
    if( not ownedSkins[skinKey] or not (ownedSkins[skinKey][weaponClass] or ownedSkins[skinKey]["*"]) ) then return end

    if( ply:Project0():GetEquippedCosmetic( "Skin", weaponClass ) == skinKey ) then return end
    ply:Project0():SetCustomisedWeapon( weaponClass, skinKey )
end )

util.AddNetworkString( "Project0.RequestEquipCharm" )
net.Receive( "Project0.RequestEquipCharm", function( len, ply )
    local charmKey = net.ReadUInt( 8 )
    local weaponClass = net.ReadString()
    if( not charmKey or not weaponClass ) then return end

    local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )
    if( not weaponCfg or weaponCfg.Charm.Disabled ) then return end

    if( not PROJECT0.CONFIG.CUSTOMISER.Charms[charmKey] ) then
        if( charmKey != 0 or ply:Project0():GetEquippedCosmetic( "Charm", weaponClass ) == 0 ) then return end
        
        ply:Project0():SetCustomisedWeapon( weaponClass, false, 0 )
        return
    end

    if( not ply:Project0():GetOwnsCosmetic( PROJECT0.COSMETIC_TYPES.CHARM, charmKey ) ) then return end

    if( ply:Project0():GetEquippedCosmetic( "Charm", weaponClass ) == charmKey ) then return end

    ply:Project0():SetCustomisedWeapon( weaponClass, false, charmKey )
end )

util.AddNetworkString( "Project0.RequestEquipSticker" )
net.Receive( "Project0.RequestEquipSticker", function( len, ply )
    local stickerKey = net.ReadUInt( 8 )
    local weaponClass = net.ReadString()
    if( not stickerKey or not weaponClass ) then return end

    local weaponCfg = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )
    if( not weaponCfg or weaponCfg.Sticker.Disabled ) then return end

    if( not PROJECT0.CONFIG.CUSTOMISER.Stickers[stickerKey] ) then
        if( stickerKey != 0 or ply:Project0():GetEquippedCosmetic( "Sticker", weaponClass ) == 0 ) then return end
        
        ply:Project0():SetCustomisedWeapon( weaponClass, false, false, stickerKey )
        return
    end

    if( not ply:Project0():GetOwnsCosmetic( PROJECT0.COSMETIC_TYPES.STICKER, stickerKey ) ) then return end

    if( ply:Project0():GetEquippedCosmetic( "Sticker", weaponClass ) == stickerKey ) then return end

    ply:Project0():SetCustomisedWeapon( weaponClass, false, false, stickerKey )
end )

concommand.Add( "pz_addskin", function( ply, cmd, args )
    if( IsValid( ply ) and not PROJECT0.FUNC.HasAdminAccess( ply ) ) then return end

    local victim = player.GetBySteamID64( args[1] or "" )
    if( not IsValid( victim ) ) then return end

    local skinID = tonumber( args[2] or "0" )
    if( not PROJECT0.DEVCONFIG.WeaponSkins[skinID] ) then return end

    victim:Project0():AddWeaponSkin( skinID, args[3] or "*" )
end )

concommand.Add( "pz_addcosmetic", function( ply, cmd, args )
    if( IsValid( ply ) and not PROJECT0.FUNC.HasAdminAccess( ply ) ) then return end

    local victim = player.GetBySteamID64( args[1] or "" )
    if( not IsValid( victim ) ) then return end

    victim:Project0():AddCosmeticItem( tonumber( args[2] or "0" ), tonumber( args[3] or "0" ) )
end )

util.AddNetworkString( "Project0.RequestCosmeticPurchase" )
net.Receive( "Project0.RequestCosmeticPurchase", function( len, ply )
    local storeKey = net.ReadUInt( 10 )
    if( not storeKey ) then return end

    local storeConfig = PROJECT0.CONFIG.CUSTOMISER.Store[storeKey]
    if( not storeConfig ) then return end

    if( ply:Project0():GetOwnsCosmeticType( storeConfig.Type, storeConfig.ItemID, storeConfig.Weapons ) ) then return end

    if( PROJECT0.FUNC.GetStoreCurrency( ply ) < storeConfig.Price ) then
        PROJECT0.FUNC.SendNotification( ply, "COSMETIC STORE", "You don't have enough money!", "error" )
        return
    end

    PROJECT0.FUNC.TakeStoreCurrency( ply, storeConfig.Price )

    if( storeConfig.Type == 3 ) then
        ply:Project0():AddWeaponSkin( storeConfig.ItemID, unpack( storeConfig.Weapons ) )
    else
        ply:Project0():AddCosmeticItem( storeConfig.Type, storeConfig.ItemID )
    end
    
    PROJECT0.FUNC.SendNotification( ply, "COSMETIC STORE", "Item successfully purchased.", "price" )

    PROJECT0.FUNC.AddCosmeticPurchase( ply:SteamID64(), PROJECT0.FUNC.UTCTime(), storeKey )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
