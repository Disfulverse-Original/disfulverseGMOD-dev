Slawer = Slawer or {}
Slawer.Jobs = Slawer.Jobs or {}
Slawer.Jobs.CFG = Slawer.Jobs.CFG or {}

local strMainDir = "slawer_jobs/"

local function loadDirectory(strDir, strFileType)
    local tblFiles = file.Find(strMainDir .. strDir .. "*", "LUA")

    for k, v in pairs(tblFiles) do
        local filePath = strMainDir .. strDir .. v
        if file.Exists(filePath, "LUA") then
            if strFileType == "server" then
                if SERVER then include(filePath) end
            elseif strFileType == "client" then
                if SERVER then
                    AddCSLuaFile(filePath)
                else
                    include(filePath)
                end
            elseif strFileType == "shared" then
                if SERVER then AddCSLuaFile(filePath) end
                include(filePath)
            end
        else
            print("[SLAWER_JOBS] ERROR: File not found - " .. filePath)
        end
    end
end

loadDirectory("", "shared")

-- Load language file with error handling
local defaultLang = "en"
local configLang = Slawer.Jobs.CFG.Lang or defaultLang
local sDir = "slawer_jobs/languages/" .. configLang .. ".lua"

if file.Exists(sDir, "LUA") then
    AddCSLuaFile(sDir)
    local tLang = include(sDir)
    
    function Slawer.Jobs:L(strTag)
        if tLang and tLang[strTag] then
            return tLang[strTag]
        else
            return strTag or "Missing translation"
        end
    end
else
    print("[SLAWER_JOBS] ERROR: Language file not found - " .. sDir)
    
    -- Fallback function
    function Slawer.Jobs:L(strTag)
        return strTag or "Missing translation"
    end
end

loadDirectory("shared/", "shared")
loadDirectory("client/", "client" )
loadDirectory("client/vgui/", "client")
loadDirectory("server/", "server")
