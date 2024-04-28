--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local function ReadConfigTable()
    local variableCount = 0

    local moduleCount = net.ReadUInt( 5 )
    for i = 1, moduleCount do
        local moduleKey = net.ReadString()
        PROJECT0.CONFIG[moduleKey] = PROJECT0.CONFIG[moduleKey] or {}

        for i = 1, net.ReadUInt( 5 ) do
            local variable = net.ReadString()
            PROJECT0.CONFIG[moduleKey][variable] = PROJECT0.FUNC.ReadTypeValue( PROJECT0.FUNC.GetConfigVariableType( moduleKey, variable ) )
            variableCount = variableCount+1
        end
    end

    return moduleCount, variableCount
end

net.Receive( "Project0.SendConfig", function()
    PROJECT0.CONFIG = {}
    local modules, variables = ReadConfigTable()

    print( "[PROJECT0] Config Received: " .. modules .. " Module(s), " .. variables .. " Variable(s)" )
    hook.Run( "Project0.Hooks.ConfigUpdated" )
end )

net.Receive( "Project0.SendConfigUpdate", function()
    local modules, variables = ReadConfigTable()

    print( "[PROJECT0] Config Updated: " .. modules .. " Module(s), " .. variables .. " Variable(s)" )
    hook.Run( "Project0.Hooks.ConfigUpdated" )

    if( PROJECT0.FUNC.HasAdminAccess( LocalPlayer() ) ) then 
        RunConsoleCommand( "spawnmenu_reload" )
    end
end )

function PROJECT0.FUNC.RequestConfigChange( module, variable, value )
    if( not PROJECT0.FUNC.HasAdminAccess( LocalPlayer() ) ) then return end

    if( not PROJECT0.TEMP.ChangedConfig ) then
        PROJECT0.TEMP.ChangedConfig = {}
    end

    if( not PROJECT0.TEMP.ChangedConfig[module] ) then
        PROJECT0.TEMP.ChangedConfig[module] = {}
    end

    PROJECT0.TEMP.ChangedConfig[module][variable] = value
end

function PROJECT0.FUNC.GetChangedVariable( module, variable )
    if( not PROJECT0.TEMP.ChangedConfig or not PROJECT0.TEMP.ChangedConfig[module] or not PROJECT0.TEMP.ChangedConfig[module][variable] ) then return end
    return PROJECT0.TEMP.ChangedConfig[module][variable]
end

local function openAdminMenu()
	if( not PROJECT0.FUNC.HasAdminAccess( LocalPlayer() ) ) then return false end

    if( IsValid( PROJECT0.TEMP.AdminMenu ) ) then
        PROJECT0.TEMP.AdminMenu:Remove()
    end

    PROJECT0.TEMP.AdminMenu = vgui.Create( "pz_config_menu" )
	
	return true
end

concommand.Add( "project0", openAdminMenu )

hook.Add( "OnPlayerChat", "Project0.OnPlayerChat.AdminMenu", function( ply, strText, bTeam, bDead ) 
    if( ply != LocalPlayer() ) then return end

	strText = string.lower( strText )

	if ( strText == "!project0" ) then return openAdminMenu() end
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
