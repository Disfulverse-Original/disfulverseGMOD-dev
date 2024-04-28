--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

util.AddNetworkString( "Project0.RequestViewmodelMode" )
util.AddNetworkString( "Project0.SendViewmodelMode" )
net.Receive( "Project0.RequestViewmodelMode", function( len, ply )
    if( not PROJECT0.FUNC.HasAdminAccess( ply ) ) then return end

    ply.PROJECT0_VIEWMODEL_MODE = net.ReadBool()

    if( not ply.PROJECT0_VIEWMODEL_MODE and ply.PROJECT0_VIEWMODEL_WEAPON and ply.PROJECT0_VIEWMODEL_REMOVE ) then
        ply:StripWeapon( ply.PROJECT0_VIEWMODEL_WEAPON )
    end

    ply.PROJECT0_VIEWMODEL_WEAPON = nil

    net.Start( "Project0.SendViewmodelMode" )
        net.WriteBool( ply.PROJECT0_VIEWMODEL_MODE )
    net.Send( ply )
end )

util.AddNetworkString( "Project0.RequestViewmodelWeapon" )
util.AddNetworkString( "Project0.SendViewmodelWeapon" )
net.Receive( "Project0.RequestViewmodelWeapon", function( len, ply )
    if( not PROJECT0.FUNC.HasAdminAccess( ply ) ) then return end

    local class = net.ReadString()
    if( (ply.PROJECT0_VIEWMODEL_WEAPON or "") == class ) then
        ply:SelectWeapon( class )
        return
    end

    if( ply.PROJECT0_VIEWMODEL_WEAPON and ply.PROJECT0_VIEWMODEL_REMOVE ) then
        ply:StripWeapon( ply.PROJECT0_VIEWMODEL_WEAPON )
    end

    ply.PROJECT0_VIEWMODEL_WEAPON = class
    ply.PROJECT0_VIEWMODEL_REMOVE = not ply:HasWeapon( class )

    ply:Give( class, true )
    ply:SelectWeapon( class )

    net.Start( "Project0.SendViewmodelWeapon" )
        net.WriteString( ply.PROJECT0_VIEWMODEL_WEAPON )
    net.Send( ply )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
