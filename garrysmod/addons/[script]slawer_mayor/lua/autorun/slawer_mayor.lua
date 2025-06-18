Slawer = Slawer or {}
Slawer.Mayor = Slawer.Mayor or {}
Slawer.Mayor.CFG = Slawer.Mayor.CFG or {}
Slawer.Mayor.Lang = Slawer.Mayor.Lang or {}

local strMainDir = "slawer_mayor/"

local function loadDirectory( strDir, strFileType )
    local tblFiles = file.Find( strMainDir .. strDir .. "*", "LUA" )

    for k, v in pairs( tblFiles ) do
        local filePath = strMainDir .. strDir .. v
        if file.Exists(filePath, "LUA") then
            if strFileType == "server" then
                if SERVER then include( filePath ) end
            elseif strFileType == "client" then
                if SERVER then
                    AddCSLuaFile( filePath )
                else
                    include( filePath )
                end
            elseif strFileType == "shared" then
                if SERVER then AddCSLuaFile( filePath ) end
                include( filePath )
            end
        else
            print("[SLAWER_MAYOR] ERROR: File not found - " .. filePath)
        end
    end
end

loadDirectory( "", "shared" )

-- Load language with error handling
local defaultLang = "en"
local configLang = Slawer.Mayor.CFG.Language or defaultLang

function Slawer.Mayor:L(strTag)
    if Slawer.Mayor.Lang and Slawer.Mayor.Lang[configLang] and Slawer.Mayor.Lang[configLang][strTag] then
        return Slawer.Mayor.Lang[configLang][strTag]
    else
        return strTag or "Missing translation"
    end
end

loadDirectory( "shared/", "shared" )
loadDirectory( "languages/", "shared" )
loadDirectory( "client/", "client" )
loadDirectory( "client/vgui/", "client" )
loadDirectory( "client/vgui/elements/", "client" )
loadDirectory( "server/", "server" )

-- Load modules with error handling
local tblFiles, tblDirs = file.Find(strMainDir .. "modules/*", "LUA")

if tblDirs then
    for k, v in pairs(tblDirs) do
        local moduleFiles = file.Find(strMainDir .. "modules/" .. v .. "/*", "LUA")
        if moduleFiles then
            for Fk, Fv in pairs(moduleFiles) do
                local strFileDir = strMainDir .. "modules/" .. v .. "/" .. Fv
                if file.Exists(strFileDir, "LUA") then
                    if string.StartWith(Fv, "sv") then
                        if SERVER then include( strFileDir ) end
                    elseif string.StartWith(Fv, "cl") then
                        if SERVER then
                            AddCSLuaFile( strFileDir )
                        else
                            include( strFileDir )
                        end
                    elseif string.StartWith(Fv, "sh") then
                        if SERVER then AddCSLuaFile( strFileDir ) end
                        include( strFileDir )
                    end
                else
                    print("[SLAWER_MAYOR] ERROR: Module file not found - " .. strFileDir)
                end
            end
        end
    end
else
    print("[SLAWER_MAYOR] ERROR: No modules directory found")
end