ahud = ahud or {}
ahud.Config = ahud.Config or {}

-- Track loaded directories to prevent infinite recursion
ahud.LoadedDirs = ahud.LoadedDirs or {}

local function include_dir(dir, maxDepth)
    maxDepth = maxDepth or 10 -- Prevent infinite recursion
    if maxDepth <= 0 then
        print("[AHUD] ERROR: Maximum directory depth reached - " .. dir)
        return
    end
    
    -- Check if directory was already loaded
    if ahud.LoadedDirs[dir] then
        return
    end
    ahud.LoadedDirs[dir] = true
    
    local files, folders = file.Find(dir .. "*", "LUA")

    if files then
        for k,v in ipairs(files) do
            local prefix = string.sub(v, 1, 3)
            local file_dir = dir .. v

            if file.Exists(file_dir, "LUA") then
                if prefix == "sh_" then
                    if SERVER then
                        AddCSLuaFile(file_dir)
                    end
                    include(file_dir)
                elseif prefix == "sv_" and SERVER then
                    include(file_dir)
                elseif prefix == "cl_" then
                    if SERVER then
                        AddCSLuaFile(file_dir)
                    else
                        include(file_dir)
                    end
                else
                    print("[AHUD] Can't include " .. v .. ", wrong prefix")
                end
            else
                print("[AHUD] ERROR: File not found - " .. file_dir)
            end
        end
    end

    if folders then
        for k, v in ipairs(folders) do
            include_dir(dir .. v .. "/", maxDepth - 1)
        end
    end
end

-- Load config with error handling
local configPath = "ahud/sh_config.lua"
if file.Exists(configPath, "LUA") then
    include(configPath)
else
    print("[AHUD] ERROR: Config file not found - " .. configPath)
end

if !ahud.Colors then
    print("------ AHud ------")
    print("You got a issue with installation, the config file can't be loaded")
    print("Follow these instructions to debug the config file")
    print("Check before this message in your console if there any errors OR paste your config in this file : https://fptje.github.io/glualint-web/")
    print("Most of the time, it's a missing comma or quotation marks")
    print("To prevent any issues, AHud will stop loading")
    print("--------------------")
    return
end

if SERVER then
    AddCSLuaFile("ahud/sh_config.lua")
    
    -- Load language file with error handling
    local defaultLang = "en"
    local configLang = ahud.Language or defaultLang
    local langPath = "ahud/languages/" .. configLang .. ".lua"
    
    if file.Exists(langPath, "LUA") then
        AddCSLuaFile(langPath)
    else
        print("[AHUD] ERROR: Language file not found - " .. langPath)
    end
end

-- Load language file
local defaultLang = "en"
local configLang = ahud.Language or defaultLang
local langPath = "ahud/languages/" .. configLang .. ".lua"

if file.Exists(langPath, "LUA") then
    include(langPath)
else
    print("[AHUD] ERROR: Language file not found - " .. langPath)
end

include_dir("ahud/code/")
hook.Run("ahud_PostLoad")