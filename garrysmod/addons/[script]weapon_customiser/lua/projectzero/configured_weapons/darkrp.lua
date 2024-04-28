--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local WEAPONS = PROJECT0.FUNC.CreateWeaponsPack( "darkrp" )
WEAPONS:SetTitle( "DarkRP" )

    -- ["ls_sniper"] = {
    --     Name = "Silenced Sniper",
    --     Class = "Sniper",
    --     Model = "models/weapons/w_snip_g3sg1.mdl"
    -- },
    -- ["weapon_ak472"] = {
    --     Name = "AK47",
    --     Class = "Rifle",
    --     Model = "models/weapons/w_rif_ak47.mdl"
    -- },
    -- ["weapon_m42"] = {
    --     Name = "M4",
    --     Class = "Rifle",
    --     Model = "models/weapons/w_rif_m4a1.mdl"
    -- },
    -- ["weapon_mp52"] = {
    --     Name = "MP5",
    --     Class = "SMG",
    --     Model = "models/weapons/w_smg_mp5.mdl"
    -- },
    -- ["weapon_mac102"] = {
    --     Name = "Mac 10",
    --     Class = "SMG",
    --     Model = "models/weapons/w_smg_mac10.mdl"
    -- },
    -- ["weapon_pumpshotgun2"] = {
    --     Name = "Pump Shotgun",
    --     Class = "Shotgun",
    --     Model = "models/weapons/w_shot_m3super90.mdl"
    -- },
    -- ["weapon_deagle2"] = {
    --     Name = "Deagle",
    --     Class = "Pistol",
    --     Model = "models/weapons/w_pist_deagle.mdl"
    -- },
    -- ["weapon_fiveseven2"] = {
    --     Name = "Five Seven",
    --     Class = "Pistol",
    --     Model = "models/weapons/w_pist_fiveseven.mdl"
    -- },
    -- ["weapon_glock2"] = {
    --     Name = "Glock",
    --     Class = "Pistol",
    --     Model = "models/weapons/w_pist_glock18.mdl"
    -- },
    -- ["weapon_p2282"] = {
    --     Name = "P228",
    --     Class = "Pistol",
    --     Model = "models/weapons/w_pist_p228.mdl"
    -- }

WEAPONS:AddWeapon( "ls_sniper", {
    Name = "Silenced Sniper",
    Class = "Sniper",
    Model = "models/weapons/w_snip_g3sg1.mdl",

    Charm = {
        ViewModelPos = Vector( 0.4, -14, -1 ),
        ViewModelAngle = Angle( 180, 0, 0 ),
        WorldModelPos = Vector( 9.5, -2, 3 ),
        WorldModelAngle = Angle( 0, 90, 0 )
    },
    
    Skin = {
        ViewModelMats = { 2, 3, 4, 5, 6, 7, 8 },
        WorldModelMats = { 1, 2, 3, 4, 5, 6, 7, 8 }
    },

    Sticker = {
        ViewModelPos = Vector( 16, 0.3, 0.41 ),
        ViewModelAngle = Angle( 180, 270, 90 ),
        WorldModelPos = Vector( 0, 0, 0 ),
        WorldModelAngle = Angle( 0, 0, 0 )
    }
} )

WEAPONS:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
