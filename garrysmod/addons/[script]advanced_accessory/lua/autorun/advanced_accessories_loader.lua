/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local files, directories = file.Find("advanced_accessories/languages/*", "LUA")
for k,v in ipairs(files) do
    include("advanced_accessories/languages/"..v)
end

include("advanced_accessories/sh_config.lua")
include("advanced_accessories/sh_materials.lua")
include("advanced_accessories/shared/sh_functions.lua")
include("advanced_accessories/sh_advanced_config.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */

if SERVER then 
    include("advanced_accessories/server/sv_sql.lua")
    include("advanced_accessories/server/sv_functions.lua")
    include("advanced_accessories/server/sv_hooks.lua")
    include("advanced_accessories/server/sv_nets.lua")
    include("advanced_accessories/server/sv_sql.lua")

    local files, directories = file.Find("advanced_accessories/languages/*", "LUA")
    for k,v in ipairs(files) do
        AddCSLuaFile("advanced_accessories/languages/"..v)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */
    
    AddCSLuaFile("advanced_accessories/sh_config.lua")
    AddCSLuaFile("advanced_accessories/sh_materials.lua")
    AddCSLuaFile("advanced_accessories/shared/sh_functions.lua")
    AddCSLuaFile("advanced_accessories/sh_advanced_config.lua")

    AddCSLuaFile("advanced_accessories/client/cl_gradients.lua")
    AddCSLuaFile("advanced_accessories/client/cl_fonts.lua")
    AddCSLuaFile("advanced_accessories/client/cl_main.lua")
    AddCSLuaFile("advanced_accessories/client/cl_functions.lua")
    AddCSLuaFile("advanced_accessories/client/cl_notify.lua")
    AddCSLuaFile("advanced_accessories/client/cl_bodygroup.lua")
    AddCSLuaFile("advanced_accessories/client/cl_admin.lua")
    AddCSLuaFile("advanced_accessories/client/cl_inventory.lua")
    AddCSLuaFile("advanced_accessories/client/cl_models.lua")
    AddCSLuaFile("advanced_accessories/client/cl_player_settings.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1
    
    AddCSLuaFile("advanced_accessories/vgui/cl_button.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_cards.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_searchbar.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_slider.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_scroll.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_textentry.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_combobox.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_dmodel.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_checkbox.lua")
else
    include("advanced_accessories/client/cl_gradients.lua")
    include("advanced_accessories/client/cl_fonts.lua")
    include("advanced_accessories/client/cl_main.lua")
    include("advanced_accessories/client/cl_functions.lua")
    include("advanced_accessories/client/cl_notify.lua")
    include("advanced_accessories/client/cl_bodygroup.lua")
    include("advanced_accessories/client/cl_admin.lua")
    include("advanced_accessories/client/cl_inventory.lua")
    include("advanced_accessories/client/cl_models.lua")
    include("advanced_accessories/client/cl_player_settings.lua")
    
    include("advanced_accessories/vgui/cl_button.lua")
    include("advanced_accessories/vgui/cl_cards.lua")
    include("advanced_accessories/vgui/cl_searchbar.lua")
    include("advanced_accessories/vgui/cl_slider.lua")
    include("advanced_accessories/vgui/cl_scroll.lua")
    include("advanced_accessories/vgui/cl_textentry.lua")
    include("advanced_accessories/vgui/cl_combobox.lua")
    include("advanced_accessories/vgui/cl_dmodel.lua")
    include("advanced_accessories/vgui/cl_checkbox.lua")
end
