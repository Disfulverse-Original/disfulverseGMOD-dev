Slawer = Slawer or {}
Slawer.Jobs = Slawer.Jobs or {}
Slawer.Jobs.CFG = Slawer.Jobs.CFG or {}

local strMainDir = "slawer_jobs/"

local function loadDirectory(strDir, strFileType)
    local tblFiles = file.Find(strMainDir .. strDir .. "*", "LUA")

    for k, v in pairs(tblFiles) do
        if strFileType == "server" then
            if SERVER then include(strMainDir .. strDir .. v) end
        elseif strFileType == "client" then
            if SERVER then
                AddCSLuaFile(strMainDir .. strDir .. v)
            else
                include(strMainDir .. strDir .. v)
            end
        elseif strFileType == "shared" then
            if SERVER then AddCSLuaFile(strMainDir .. strDir .. v) end
            include(strMainDir .. strDir .. v)
        end
    end
end

loadDirectory("", "shared")

local sDir = "slawer_jobs/languages/" .. (Slawer.Jobs.CFG.Lang or "en") .. ".lua"
AddCSLuaFile(sDir)
local tLang = include(sDir)

function Slawer.Jobs:L(strTag)
    return tLang[strTag] or strTag
end

loadDirectory("shared/", "shared")
loadDirectory("client/", "client" )
loadDirectory("client/vgui/", "client")
loadDirectory("server/", "server")
