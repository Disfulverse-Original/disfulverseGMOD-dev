WasiedAdminSystem = WasiedAdminSystem or {}
WasiedAdminSystem.Config = WasiedAdminSystem.Config or {}
WasiedAdminSystem.Constants = WasiedAdminSystem.Constants or {}
WasiedAdminSystem.Language = WasiedAdminSystem.Language or {}

local addonFolder = "wasied_admin_system/"
local libFolder = "wasied_admin_system/"
local name = "Admin System"

--[[ LOADING ]]--
--[[ LOADING ]]--
--[[ LOADING ]]--

-- Config files
include(addonFolder.."config.lua")
include(addonFolder.."constants.lua")

-- Shared files
include(addonFolder.."shared/sh_functions.lua")

-- Languages files
local files = file.Find(addonFolder.."languages/*.lua", "LUA")
for _,v in ipairs(files) do
    include(addonFolder.."languages/"..v)
end

if SERVER then

    -- Load font
    resource.AddSingleFile("resource/fonts/SourceSansPro-Black.ttf")

    -- Config files
    AddCSLuaFile(addonFolder.."config.lua")
    AddCSLuaFile(addonFolder.."constants.lua")

    -- Languages files
    local files = file.Find(addonFolder.."languages/*.lua", "LUA")
    for _,v in ipairs(files) do
        AddCSLuaFile(addonFolder.."languages/"..v)
    end

    -- Shared files
    AddCSLuaFile(addonFolder.."shared/sh_functions.lua")

    -- Server files
    include(addonFolder.."server/sv_functions.lua")
    include(addonFolder.."server/sv_networking.lua")
    include(addonFolder.."server/sv_hooks.lua")

    -- Client files
    AddCSLuaFile(addonFolder.."client/cl_functions.lua")
    AddCSLuaFile(addonFolder.."client/cl_admin_menu.lua")
    AddCSLuaFile(addonFolder.."client/cl_draw_infos.lua")
    AddCSLuaFile(addonFolder.."client/cl_player_management.lua")
    AddCSLuaFile(addonFolder.."client/cl_refund_menu.lua")
    AddCSLuaFile(addonFolder.."client/cl_tickets_admin.lua")
    AddCSLuaFile(addonFolder.."client/cl_tickets_player.lua")

else

    -- Client files
    include(addonFolder.."client/cl_functions.lua")
    include(addonFolder.."client/cl_admin_menu.lua")
    include(addonFolder.."client/cl_draw_infos.lua")
    include(addonFolder.."client/cl_player_management.lua")
    include(addonFolder.."client/cl_refund_menu.lua")
    include(addonFolder.."client/cl_tickets_admin.lua")
    include(addonFolder.."client/cl_tickets_player.lua")

end
