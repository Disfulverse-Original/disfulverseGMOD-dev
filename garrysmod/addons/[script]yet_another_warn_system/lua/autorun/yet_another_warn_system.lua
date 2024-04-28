-- shitty table names are a small price compared to the meme of calling your
-- premium gmodstore addon people pay for "yet another warn system"
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



-- #4dd8b3 = Color(77, 216, 179)
function YAWS.Core.Print(msg) 
    -- cant cache this color since it's called before the cache is created
    MsgC(Color(77, 216, 179), "[YAWS] ", color_white, msg, "\n") 
end

YAWS.Core.Print("Loading.")
YAWS.Core.Print("")

-- woah is it a new autoloader? holy shit it is. incredible.
function YAWS.Core.RecursiveLoad(folder, depth) -- yes, depth is just for the visuals.
    -- Load the files in that directory first.
    if(SERVER) then 
        for k,v in ipairs(file.Find(folder .. "/sv*.lua", "LUA")) do
            YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
            include(folder .. "/" .. v)
        end
        for k,v in ipairs(file.Find(folder .. "/sh*.lua", "LUA")) do
            YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
            include(folder .. "/" .. v)
            AddCSLuaFile(folder .. "/" .. v)
        end
        for k,v in ipairs(file.Find(folder .. "/cl*.lua", "LUA")) do
            YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
            AddCSLuaFile(folder .. "/" .. v)
        end
    else 
        for k,v in ipairs(file.Find(folder .. "/sh*.lua", "LUA")) do
            YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
            include(folder .. "/" .. v)
        end
        for k,v in ipairs(file.Find(folder .. "/cl*.lua", "LUA")) do
            YAWS.Core.Print(string.rep("  ", depth) .. "- " .. v)
            include(folder .. "/" .. v)
        end
    end

    -- Find the others
    local _,dirs = file.Find(folder .. "/*", "LUA")
    for k,v in ipairs(dirs) do 
        YAWS.Core.Print(string.rep("  ", depth) .. v)
        YAWS.Core.RecursiveLoad(folder .. "/" .. v, depth + 1)
    end 
end 
YAWS.Core.RecursiveLoad("yaws", 0)

YAWS.Core.Print("")
YAWS.Core.Print("Loaded.")
hook.Run("yaws.core.initalize")

if(!CAMI) then 
    -- The only thing that would actually break is the permissions ui, since
    -- it'll be unable to get all the usergroups. Still, nothing like a nice
    -- scary warning for unsuspecting users >:)
    YAWS.Core.Print("------------------------------------------------------------------------------------")
    YAWS.Core.Print("WARNING - CAMI was not detected on this server. YET ANOTHER WARNING SYSTEM WILL NOT ")
    YAWS.Core.Print("                               FUCKING WORK WITHOUT IT!                             ")
    YAWS.Core.Print("------------------------------------------------------------------------------------")
    YAWS.Core.Print("Please get a admin mod that was coded competentely. YAWS will try to work around it")
    YAWS.Core.Print("but some features might be wonky or outright broken. https://github.com/glua/CAMI")
end 