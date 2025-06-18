if not RSRP then RSRP = {} end 
RSRP.PoliceRadio = {}
local path = "rsrp_policeradio/"

if SERVER then
    -- Load shared config
    local configPath = path .. 'sh_config.lua'
    if file.Exists(configPath, "LUA") then
        include(configPath)
        print("[POLICE_RADIO] Loaded shared config")
    else
        print("[POLICE_RADIO] ERROR: Shared config not found")
    end
    
    -- Load server files
    local serverFiles = {
        path .. 'sv_policeradio.lua',
        path .. 'sv_net.lua'
    }
    
    for _, filePath in ipairs(serverFiles) do
        if file.Exists(filePath, "LUA") then
            include(filePath)
            print("[POLICE_RADIO] Loaded server: " .. string.GetFileFromFilename(filePath))
        else
            print("[POLICE_RADIO] ERROR: Server file not found - " .. filePath)
        end
    end
 
    -- Add client files to download
    local clientPath = path .. 'cl_policeradio.lua'
    if file.Exists(clientPath, "LUA") then
        AddCSLuaFile(clientPath)
        print("[POLICE_RADIO] Added client file")
    else
        print("[POLICE_RADIO] ERROR: Client file not found")
    end
    
    -- Add shared config to download
    if file.Exists(configPath, "LUA") then
        AddCSLuaFile(configPath)
    end
end 

if CLIENT then 
    -- Load shared config
    local configPath = path .. 'sh_config.lua'
    if file.Exists(configPath, "LUA") then
        include(configPath)
        print("[POLICE_RADIO] Loaded shared config")
    else
        print("[POLICE_RADIO] ERROR: Shared config not found")
    end
    
    -- Load client file
    local clientPath = path .. 'cl_policeradio.lua'
    if file.Exists(clientPath, "LUA") then
        include(clientPath)
        print("[POLICE_RADIO] Loaded client file")
    else
        print("[POLICE_RADIO] ERROR: Client file not found")
    end
end