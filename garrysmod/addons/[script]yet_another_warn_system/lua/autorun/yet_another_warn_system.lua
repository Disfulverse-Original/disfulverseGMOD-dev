-- Yet Another Warning System
-- A comprehensive warning system for Garry's Mod servers
YAWS = YAWS or {}
YAWS.Core = YAWS.Core or {}

YAWS.Language = YAWS.Language or {}
YAWS.Language.Languages = YAWS.Language.Languages or {}
YAWS.ManualConfig = YAWS.ManualConfig or {} -- file config
YAWS.ManualConfig.FullPerms = {}
YAWS.ManualConfig.Immunes = {}
YAWS.Config = YAWS.Config or {} -- in-game config
YAWS.Punishments = YAWS.Punishments or {}

if(SERVER) then 
    -- Serverside-only tables
    YAWS.ManualConfig.Database = {}
    YAWS.ManualConfig.Discord = {}

    YAWS.NetCooldown = {}
    YAWS.Database = YAWS.Database or {}
    YAWS.Permissions = YAWS.Permissions or {}
    YAWS.Warns = YAWS.Warns or {}
    YAWS.Players = YAWS.Players or {}
    YAWS.NiceServerNames = YAWS.NiceServerNames or {}
    YAWS.Convert = YAWS.Convert or {}

    resource.AddWorkshop("2665322617")
else 
    -- Clientside-only tables
    YAWS.UI = YAWS.UI or {}
    YAWS.UI.Tabs = YAWS.UI.Tabs or {}
    YAWS.UserSettings = YAWS.UserSettings or {}
end 

-- Track loaded directories to prevent infinite recursion
YAWS.LoadedDirs = YAWS.LoadedDirs or {}

-- #4dd8b3 = Color(77, 216, 179)
function YAWS.Core.Print(msg) 
    -- cant cache this color since it's called before the cache is created
    MsgC(Color(77, 216, 179), "[YAWS] ", color_white, msg, "\n") 
end

YAWS.Core.Print("Loading.")
YAWS.Core.Print("")

-- Improved autoloader with recursion protection
function YAWS.Core.RecursiveLoad(folder, depth, maxDepth) -- yes, depth is just for the visuals.
    maxDepth = maxDepth or 10 -- Prevent infinite recursion
    if maxDepth <= 0 then
        YAWS.Core.Print("ERROR: Maximum directory depth reached - " .. folder)
        return
    end
    
    -- Check if directory was already loaded
    if YAWS.LoadedDirs[folder] then
        return
    end
    YAWS.LoadedDirs[folder] = true
    
    -- Load the files in that directory first.
    if(SERVER) then 
        local serverFiles = file.Find(folder .. "/sv*.lua", "LUA")
        if serverFiles then
            for k,v in ipairs(serverFiles) do
                local filePath = folder .. "/" .. v
                if file.Exists(filePath, "LUA") then
                    YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
                    include(filePath)
                else
                    YAWS.Core.Print("ERROR: Server file not found - " .. filePath)
                end
            end
        end
        
        local sharedFiles = file.Find(folder .. "/sh*.lua", "LUA")
        if sharedFiles then
            for k,v in ipairs(sharedFiles) do
                local filePath = folder .. "/" .. v
                if file.Exists(filePath, "LUA") then
                    YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
                    include(filePath)
                    AddCSLuaFile(filePath)
                else
                    YAWS.Core.Print("ERROR: Shared file not found - " .. filePath)
                end
            end
        end
        
        local clientFiles = file.Find(folder .. "/cl*.lua", "LUA")
        if clientFiles then
            for k,v in ipairs(clientFiles) do
                local filePath = folder .. "/" .. v
                if file.Exists(filePath, "LUA") then
                    YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
                    AddCSLuaFile(filePath)
                else
                    YAWS.Core.Print("ERROR: Client file not found - " .. filePath)
                end
            end
        end
    else 
        local sharedFiles = file.Find(folder .. "/sh*.lua", "LUA")
        if sharedFiles then
            for k,v in ipairs(sharedFiles) do
                local filePath = folder .. "/" .. v
                if file.Exists(filePath, "LUA") then
                    YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
                    include(filePath)
                else
                    YAWS.Core.Print("ERROR: Shared file not found - " .. filePath)
                end
            end
        end
        
        local clientFiles = file.Find(folder .. "/cl*.lua", "LUA")
        if clientFiles then
            for k,v in ipairs(clientFiles) do
                local filePath = folder .. "/" .. v
                if file.Exists(filePath, "LUA") then
                    YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
                    include(filePath)
                else
                    YAWS.Core.Print("ERROR: Client file not found - " .. filePath)
                end
            end
        end
    end

    -- Find the subdirectories
    local _,dirs = file.Find(folder .. "/*", "LUA")
    if dirs then
        for k,v in ipairs(dirs) do 
            YAWS.Core.Print(string.rep("  ", depth) .. v)
            YAWS.Core.RecursiveLoad(folder .. "/" .. v, depth + 1, maxDepth - 1)
        end 
    end
end 

YAWS.Core.RecursiveLoad("yaws", 0)

YAWS.Core.Print("")
YAWS.Core.Print("Loaded.")
hook.Run("yaws.core.initalize")

if(!CAMI) then 
    -- The only thing that would actually break is the permissions ui, since
    -- it'll be unable to get all the usergroups. Still, nothing like a nice
    -- warning for unsuspecting users
    YAWS.Core.Print("------------------------------------------------------------------------------------")
    YAWS.Core.Print("WARNING - CAMI was not detected on this server. YET ANOTHER WARNING SYSTEM WILL NOT ")
    YAWS.Core.Print("                               WORK WITHOUT IT!                             ")
    YAWS.Core.Print("------------------------------------------------------------------------------------")
    YAWS.Core.Print("Please get an admin mod that was coded competently. YAWS will try to work around it")
    YAWS.Core.Print("but some features might be wonky or outright broken. https://github.com/glua/CAMI")
end 