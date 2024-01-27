--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

util.AddNetworkString( "Project0.RequestPlayerSkin" )
util.AddNetworkString( "Project0.SendPlayerSkin" )
net.Receive( "Project0.RequestPlayerSkin", function( len, ply )
    local projectMeta = ply:Project0()

    if( CurTime() < (projectMeta.LastWeaponSkinRequest or 0)+PROJECT0.CONFIG.CUSTOMISER.SkinNetworkDelay-1 ) then return end
    projectMeta.LastWeaponSkinRequest = CurTime()

    local requestVictim = net.ReadEntity()
    if( not IsValid( requestVictim ) or not requestVictim:IsPlayer() ) then return end

    local currentWeapon = requestVictim:GetActiveWeapon()
    if( not IsValid( currentWeapon ) ) then return end

    local weaponClass = currentWeapon:GetClass()
    local equippedSkin = requestVictim:Project0():GetEquippedCosmetic( "Skin", weaponClass )
    if( ((projectMeta.RequestedWeapons or {})[weaponClass] or 0) == equippedSkin ) then return end

    projectMeta.RequestedWeapons = projectMeta.RequestedWeapons or {}
    projectMeta.RequestedWeapons[weaponClass] = equippedSkin

    net.Start( "Project0.SendPlayerSkin" )
        net.WriteEntity( requestVictim )
        net.WriteString( weaponClass )
        net.WriteUInt( equippedSkin, 8 )
    net.Send( ply )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
