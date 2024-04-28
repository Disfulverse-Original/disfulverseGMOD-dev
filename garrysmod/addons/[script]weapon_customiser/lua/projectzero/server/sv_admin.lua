--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- Config --
local function WriteConfigTable( ply, configTable )
    net.WriteUInt( table.Count( configTable ), 5 )

    for k, v in pairs( configTable ) do
        net.WriteString( k )
        net.WriteUInt( table.Count( v ), 5 )

        for key, val in pairs( v ) do
            net.WriteString( key )
            PROJECT0.FUNC.WriteTypeValue( PROJECT0.FUNC.GetConfigVariableType( k, key ), val )
        end
    end
end

util.AddNetworkString( "Project0.SendConfig" )
function PROJECT0.FUNC.SendConfig( ply )
    net.Start( "Project0.SendConfig" )
        WriteConfigTable( ply, PROJECT0.CONFIG )
    net.Send( ply )
end

util.AddNetworkString( "Project0.SendConfigUpdate" )
function PROJECT0.FUNC.SendConfigUpdate( ply, changedConfig )
    net.Start( "Project0.SendConfigUpdate" )
        WriteConfigTable( ply, changedConfig )
    net.Send( ply )
end

util.AddNetworkString( "Project0.RequestSaveConfigChanges" )
net.Receive( "Project0.RequestSaveConfigChanges", function( len, ply )
    if( not PROJECT0.FUNC.HasAdminAccess( ply ) ) then return end

    local changedConfig = {}

    local moduleCount = net.ReadUInt( 5 )
    for i = 1, moduleCount do
        local moduleKey = net.ReadString()
        changedConfig[moduleKey] = {}

        for i = 1, net.ReadUInt( 5 ) do
            local variable = net.ReadString()
            changedConfig[moduleKey][variable] = PROJECT0.FUNC.ReadTypeValue( PROJECT0.FUNC.GetConfigVariableType( moduleKey, variable ) )
        end
    end

    local variableCount = 0
    for k, v in pairs( changedConfig ) do
        if( not PROJECT0.CONFIG[k] ) then continue end

        for key, val in pairs( v ) do
            PROJECT0.CONFIG[k][key] = val
            variableCount = variableCount+1
        end

        file.Write( "projectzero/config/" .. k .. ".txt", util.TableToJSON( PROJECT0.CONFIG[k], true ) )
    end

    print( "[PROJECT0] Config Saved: " .. table.Count( changedConfig ) .. " Module(s), " .. variableCount .. " Variable(s)" )
    PROJECT0.FUNC.SendNotification( ply, "CONFIG SAVED", "Config successfully saved!", "admin" )

    PROJECT0.FUNC.SendConfigUpdate( player.GetAll(), changedConfig )

    hook.Run( "Project0.Hooks.ConfigUpdated" )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
