BRICKS_SERVER = BRICKS_SERVER or {}
BRICKS_SERVER.GANGS = {}

if not BRICKS_SERVER.Func or not BRICKS_SERVER.Func.AddModule then
	print("[BRICKS_GANGS] ERROR: BRICKS_SERVER framework not found")
	return
end

local module = BRICKS_SERVER.Func.AddModule( "gangs", "Brick's Gangs", "materials/bricks_server/gangs.png", "1.7.3" )
if module then
	module:AddSubModule( "achievements", "Achievements" )
	module:AddSubModule( "associations", "Associations" )
	module:AddSubModule( "leaderboards", "Leaderboards" )
	module:AddSubModule( "printers", "Printers" )
	module:AddSubModule( "storage", "Storage" )
	module:AddSubModule( "territories", "Territories" )
else
	print("[BRICKS_GANGS] ERROR: Failed to create gangs module")
end

hook.Add( "BRS.Hooks.BaseConfigLoad", "BricksServerHooks_BRS_BaseConfigLoad_Gangs", function()
    local configPath = "bricks_server/bricks_gangs/sh_baseconfig.lua"
    if file.Exists(configPath, "LUA") then
        AddCSLuaFile( configPath )
        include( configPath )
    else
        print("[BRICKS_GANGS] ERROR: Base config not found - " .. configPath)
    end
end )

hook.Add( "BRS.Hooks.ClientConfigLoad", "BricksServerHooks_BRS_ClientConfigLoad_Gangs", function()
    local configPath = "bricks_server/bricks_gangs/sh_clientconfig.lua"
    if file.Exists(configPath, "LUA") then
        AddCSLuaFile( configPath )
        include( configPath )
    else
        print("[BRICKS_GANGS] ERROR: Client config not found - " .. configPath)
    end
end )

hook.Add( "BRS.Hooks.DevConfigLoad", "BricksServerHooks_BRS_DevConfigLoad_Gangs", function()
    local configPath = "bricks_server/bricks_gangs/sh_devconfig.lua"
    if file.Exists(configPath, "LUA") then
        AddCSLuaFile( configPath )
        include( configPath )
    else
        print("[BRICKS_GANGS] ERROR: Dev config not found - " .. configPath)
    end
end )

if( SERVER ) then
    resource.AddWorkshop( "2172708113" ) -- Brick's Gangs
    resource.AddWorkshop( "2136421687" ) -- Brick's Server

    hook.Add( "BRS.Hooks.SQLLoad", "BricksServerHooks_BRS_SQLLoad_Gangs", function()
        if BRICKS_SERVER.GANGS and BRICKS_SERVER.GANGS.LUACFG and BRICKS_SERVER.GANGS.LUACFG.UseMySQL then
            local mysqlPath = "bricks_server/bricks_gangs/sv_mysql.lua"
            if file.Exists(mysqlPath, "LUA") then
                include( mysqlPath )
            else
                print("[BRICKS_GANGS] ERROR: MySQL file not found - " .. mysqlPath)
            end
        else
            local sqlitePath = "bricks_server/bricks_gangs/sv_sqllite.lua"
            if file.Exists(sqlitePath, "LUA") then
                include( sqlitePath )
            else
                print("[BRICKS_GANGS] ERROR: SQLite file not found - " .. sqlitePath)
            end
        end
    end )
end