if not RSRP then RSRP = {} end 
RSRP.PoliceRadio = {}
local path = "rsrp_policeradio/"
if SERVER then
    include('autorun/sh_config.lua')
    include(path..'sv_policeradio.lua')
    include(path..'sv_net.lua')
 
    AddCSLuaFile(path..'cl_policeradio.lua')
    AddCSLuaFile('autorun/sh_config.lua')
end 
if CLIENT then 
    include('autorun/sh_config.lua')
    include(path..'cl_policeradio.lua')
end