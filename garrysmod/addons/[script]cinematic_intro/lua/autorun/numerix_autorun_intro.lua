Intro = Intro or {}

Intro.Settings = Intro.Settings or {}

if SERVER then

    include("intro/shared/sh_config_intro.lua")
    AddCSLuaFile("intro/shared/sh_config_intro.lua")

    AddCSLuaFile("intro/client/cl_intro.lua")
    AddCSLuaFile("intro/client/cl_fonts.lua")

    include("intro/server/sv_intro.lua")
    
    if not file.Exists("numerix_intro", "DATA") then
        file.CreateDir("numerix_intro")
    end
    if not file.Exists("numerix_intro/"..game.GetMap().."/player", "DATA") then
        file.CreateDir("numerix_intro/"..game.GetMap().."/player")
    end
    
end

if CLIENT then

    include("intro/shared/sh_config_intro.lua")
    include("intro/client/cl_intro.lua")
    include("intro/client/cl_fonts.lua")

end