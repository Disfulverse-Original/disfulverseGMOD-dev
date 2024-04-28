--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

ACC2 = ACC2 or {}

local filesCompatibilities, directoriesCompatibilities = file.Find("advanced_character_creator/compatibilities/*", "LUA")
local files, directories = file.Find("advanced_character_creator/languages/*", "LUA")

for k, v in ipairs(files) do
    include("advanced_character_creator/languages/"..v)
end

include("advanced_character_creator/sh_advanced_config.lua")
include("advanced_character_creator/sh_materials.lua")
include("advanced_character_creator/shared/sh_functions.lua")
include("advanced_character_creator/sh_config.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

if SERVER then
    AddCSLuaFile("advanced_character_creator/sh_advanced_config.lua")
    AddCSLuaFile("advanced_character_creator/sh_materials.lua")
    AddCSLuaFile("advanced_character_creator/shared/sh_functions.lua")
    AddCSLuaFile("advanced_character_creator/sh_config.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */

    include("advanced_character_creator/server/sv_sql.lua")
    include("advanced_character_creator/server/sv_functions.lua")
    include("advanced_character_creator/server/sv_hooks.lua")
    include("advanced_character_creator/server/sv_nets.lua")
    include("advanced_character_creator/server/sv_compatibilities.lua")
    include("advanced_character_creator/server/sv_transfert.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

    for k, v in ipairs(files) do
        AddCSLuaFile("advanced_character_creator/languages/"..v)
    end

    for k, v in ipairs(filesCompatibilities) do
        include("advanced_character_creator/compatibilities/"..v)
    end

    AddCSLuaFile("advanced_character_creator/client/cl_fonts.lua")
    AddCSLuaFile("advanced_character_creator/client/cl_main.lua")
    AddCSLuaFile("advanced_character_creator/client/cl_notify.lua")
    AddCSLuaFile("advanced_character_creator/client/cl_functions.lua")
    AddCSLuaFile("advanced_character_creator/client/cl_admin.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */
    
    AddCSLuaFile("advanced_character_creator/vgui/cl_button.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_toggle.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_dmodel.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_slider_button.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_colormixer.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_checkbox.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_dscroll.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_dtextentry.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_dcombobox.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_accordion.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_slider.lua")
    AddCSLuaFile("advanced_character_creator/vgui/cl_circular_avatar.lua")
else
    include("advanced_character_creator/client/cl_fonts.lua")
    include("advanced_character_creator/client/cl_notify.lua")
    include("advanced_character_creator/client/cl_main.lua")
    include("advanced_character_creator/client/cl_admin.lua")
    include("advanced_character_creator/client/cl_functions.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
    
    include("advanced_character_creator/vgui/cl_button.lua")
    include("advanced_character_creator/vgui/cl_toggle.lua")
    include("advanced_character_creator/vgui/cl_dmodel.lua")
    include("advanced_character_creator/vgui/cl_slider_button.lua")
    include("advanced_character_creator/vgui/cl_colormixer.lua")
    include("advanced_character_creator/vgui/cl_checkbox.lua")
    include("advanced_character_creator/vgui/cl_dscroll.lua")
    
    include("advanced_character_creator/vgui/cl_dtextentry.lua")
    include("advanced_character_creator/vgui/cl_dcombobox.lua")
    include("advanced_character_creator/vgui/cl_accordion.lua")
    include("advanced_character_creator/vgui/cl_slider.lua")
    include("advanced_character_creator/vgui/cl_circular_avatar.lua")
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
