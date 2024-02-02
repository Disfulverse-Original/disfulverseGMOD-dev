--[[
    !!WARNING!!
        ALL CONFIG IS DONE INGAME, DONT EDIT ANYTHING HERE
        Type !bricksserver ingame
    !!WARNING!!
]]--

--[[ MODULES CONFIG ]]--
BRICKS_SERVER.BASECONFIG.MODULES = BRICKS_SERVER.BASECONFIG.MODULES or {}
BRICKS_SERVER.BASECONFIG.MODULES["default"] = { true, {
    ["currencies"] = true
} }

--[[ GENERAL CONFIG ]]--
BRICKS_SERVER.BASECONFIG.GENERAL = BRICKS_SERVER.BASECONFIG.GENERAL or {}
BRICKS_SERVER.BASECONFIG.GENERAL["Donate Link"] = ""
BRICKS_SERVER.BASECONFIG.GENERAL["Server Name"] = "Disfulverse"
BRICKS_SERVER.BASECONFIG.GENERAL["3D2D Display Distance"] = 500000
BRICKS_SERVER.BASECONFIG.GENERAL["Use Textured Gradients (Better FPS)"] = true
BRICKS_SERVER.BASECONFIG.GENERAL.AdminPermissions = { 
    ["superadmin"] = true, 
    ["founder"] = true, 
    ["owner"] = true 
}
BRICKS_SERVER.BASECONFIG.GENERAL.Groups = {
    [1] = { "Staff", { ["moderator"] = true, ["admin"] = true, ["superadmin"] = true } },
    [2] = { "Dis+", { ["disfulversed"] = true }, Color(112, 46, 255) },
    [5] = { "User", {}, Color(201, 70, 70), true }
}
BRICKS_SERVER.BASECONFIG.GENERAL.Rarities = {
    [1] = { "Common", "Gradient", { Color( 154, 154, 154 ), Color( 154*1.5, 154*1.5, 154*1.5 ) } },
    [2] = { "Uncommon", "Gradient", { Color( 104, 255, 104 ), Color( 104*1.5, 255*1.5, 104*1.5 ) } },
    [3] = { "Rare", "Gradient", { Color( 42, 133, 219 ),Color( 42*1.5, 133*1.5, 219*1.5 )  } },
    [4] = { "Epic", "Gradient", { Color( 152, 68, 255 ), Color( 152*1.5, 68*1.5, 255*1.5 ) } },
    [5] = { "Legendary", "Gradient", { Color( 253, 162, 77 ), Color( 253*1.5, 162*1.5, 77*1.5 ) } },
    [6] = { "Glitched", "Rainbow" }
}

--[[ LANGUAGE CONFIG ]]--
BRICKS_SERVER.BASECONFIG.LANGUAGE = {}
BRICKS_SERVER.BASECONFIG.LANGUAGE.Language = "russian"
BRICKS_SERVER.BASECONFIG.LANGUAGE.Languages = {}

--[[ THEME CONFIG ]]--
BRICKS_SERVER.BASECONFIG.THEME = {}
BRICKS_SERVER.BASECONFIG.THEME[0] = Color(33, 33, 33, 250)
BRICKS_SERVER.BASECONFIG.THEME[1] = Color(29, 29, 29, 250)
BRICKS_SERVER.BASECONFIG.THEME[2] = Color(42, 42, 42, 250)
BRICKS_SERVER.BASECONFIG.THEME[3] = Color(48, 47, 49, 245)
BRICKS_SERVER.BASECONFIG.THEME[4] = Color(94, 125, 247)
BRICKS_SERVER.BASECONFIG.THEME[5] = Color(129, 129, 252)
BRICKS_SERVER.BASECONFIG.THEME[6] = Color(255, 255, 255)
BRICKS_SERVER.BASECONFIG.THEME[7] = Color(79, 80, 92, 250)
BRICKS_SERVER.BASECONFIG.THEME[8] = Color(0, 0, 0, 150)

--[[ INVENTORY ]]--
BRICKS_SERVER.BASECONFIG.INVENTORY = BRICKS_SERVER.BASECONFIG.INVENTORY or {}
BRICKS_SERVER.BASECONFIG.INVENTORY.ItemRarities = {
    --["Wood"] = "Uncommon",
    --["Scrap"] = "Uncommon",
    --["Iron"] = "Common",
    --["Plastic"] = "Common",
    --["Ruby"] = "Rare",
    --["Diamond"] = "Epic",
    --["weapon_ak472"] = "Legendary",
}
BRICKS_SERVER.BASECONFIG.INVENTORY.Whitelist = {
    ["bricks_server_resource"] = { false, true },
    ["spawned_shipment"] = { true, true },
    ["spawned_weapon"] = { true, true },
    ["bricks_server_ink"] = { false, true }
--[[
    ["bricks_server_resource_wood"] = { false, true },
    ["bricks_server_resource_scrap"] = { false, true },
    ["bricks_server_resource_iron"] = { false, true },
    ["bricks_server_resource_plastic"] = { false, true },
    ["bricks_server_resource_ruby"] = { false, true },
    ["bricks_server_resource_diamond"] = { false, true }
--]]
}

--[[ NPCS ]]--
BRICKS_SERVER.BASECONFIG.NPCS = BRICKS_SERVER.BASECONFIG.NPCS or {}