--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Modular system to add support for weapons. Weapons can still be configured in-game but adding them to the addon itself is easier for users.
    Configurations can be overriden using the config still, config has priority over this.
*/

local WEAPONS = PROJECT0.FUNC.CreateWeaponsPack( "m9k_rifles" )
WEAPONS:SetTitle( "M9K Rifles" )

-- WEAPONS:AddWeapon( "m9k_m416", {
--     Name = "HK 416",
--     Class = "Rifle",
--     Model = "models/weapons/w_hk_416.mdl",
    
--     Charm = {
--         ViewModelPos = Vector( 0.4, -14, -1 ),
--         ViewModelAngle = Angle( 180, 0, 0 ),
--         WorldModelPos = Vector( 9.5, -2, 3 ),
--         WorldModelAngle = Angle( 0, 90, 0 )
--     },

--     Skin = {
--         ViewModelMats = { 2, 3, 4, 5, 6, 7, 8 },
--         WorldModelMats = { 1, 2, 3, 4, 5, 6, 7, 8 }
--     },

--     Sticker = {
--         ViewModelPos = Vector( 16, 0.3, 0.41 ),
--         ViewModelAngle = Angle( 180, 270, 90 ),
--         WorldModelPos = Vector( 0, 0, 0 ),
--         WorldModelAngle = Angle( 0, 0, 0 )
--     }
-- } )

WEAPONS:AddWeapon( "m9k_winchester73", [[{"Charm":{"WorldModelAngle":"{0 90 0}","ViewModelPos":"[0.4633 -23 -0.7722]","ViewModelAngle":"{270 360 270}","WorldModelPos":"[11.027 -1.7297 4.973]"},"Skin":{"WorldModelMats":[1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,0.0],"ViewModelMats":[3.0,4.0,5.0,6.0,7.0,8.0,0.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[21 0 0.5]","ViewModelAngle":"{0 0 0}","WorldModelPos":"[0 0 0]"},"Class":"Rifle","Model":"models/weapons/w_winchester_1873.mdl","Name":"73 Winchester Carbine"}]] )
WEAPONS:AddWeapon( "m9k_acr", [[{"Charm":{"WorldModelAngle":"{0 90 0}","ViewModelPos":"[0.3089 -15.7529 0]","ViewModelAngle":"{180 0 90}","WorldModelPos":"[9.5 -1.5 3]"},"Skin":{"ViewModelMats":[0.0,1.0,2.0,3.0,4.0,6.0],"WorldModelMats":[1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[16.834 -0.4633 0.4633]","ViewModelAngle":"{180 270 0}","WorldModelPos":"[0 0 0]"},"Class":"Rifle","Model":"models/weapons/w_masada_acr.mdl","Name":"ACR"}]] )
WEAPONS:AddWeapon( "m9k_ak47", [[{"Charm":{"WorldModelAngle":"{0 90 0}","ViewModelPos":"[-35.7 7.8764 -3.0888]","ViewModelAngle":"{90 180 0}","WorldModelPos":"[9.9459 -1.2973 4.3243]"},"Skin":{"ViewModelMats":[7.0,8.0,0.0,1.0],"WorldModelMats":[4.0,5.0,6.0,7.0,8.0,3.0,1.0,2.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[2.0077 -10.8108 -13.4363]","ViewModelAngle":"{90 180 0}","WorldModelPos":"[0 0 0]"},"Class":"RIfle","Model":"models/weapons/w_ak47_m9k.mdl","Name":"AK-47"}]] )
WEAPONS:AddWeapon( "m9k_ak74", [[{"Charm":{"WorldModelAngle":"{0 270 0}","ViewModelPos":"[0.1544 -17.9151 0]","ViewModelAngle":"{0 0 90}","WorldModelPos":"[0.6486 1 0.8649]"},"Skin":{"ViewModelMats":[5.0,6.0,7.0,8.0,3.0,4.0],"WorldModelMats":[3.0,4.0,5.0,6.0,7.0,8.0,1.0,2.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[20 -0.4633 0.1544]","ViewModelAngle":"{270 90 90}","WorldModelPos":"[0 0 0]"},"Class":"Weapon","Model":"models/weapons/w_tct_ak47.mdl","Name":"AK-74"}]] )
WEAPONS:AddWeapon( "m9k_amd65", [[{"Charm":{"WorldModelAngle":"{0 90 0}","ViewModelPos":"[2.9344 -13.8996 2.1622]","ViewModelAngle":"{136.9112 171.6602 280.0772}","WorldModelPos":"[12.1081 -1.7297 4.3243]"},"Skin":{"WorldModelMats":[4.0,5.0,6.0,7.0,8.0,0.0,2.0,1.0],"ViewModelMats":[5.0,6.0,7.0,8.0,2.0,3.0,1.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[15.9073 -1.2355 1.5444]","ViewModelAngle":"{184.1699 132.7413 360}","WorldModelPos":"[0 0 0]"},"Class":"Rifle","Model":"models/weapons/w_amd_65.mdl","Name":"AMD 65"}]] )
-- WEAPONS:AddWeapon( "m9k_an94", [[]] )
-- WEAPONS:AddWeapon( "m9k_val", [[]] )
-- WEAPONS:AddWeapon( "m9k_f2000", [[]] )
-- WEAPONS:AddWeapon( "m9k_famas", [[]] )
-- WEAPONS:AddWeapon( "m9k_fal", [[]] )
-- WEAPONS:AddWeapon( "m9k_g36", [[]] )
WEAPONS:AddWeapon( "m9k_m416", [[{"Charm":{"WorldModelAngle":"{0 90 0}","ViewModelPos":"[0.3089 -14 -1]","ViewModelAngle":"{180 0 0}","WorldModelPos":"[9.5 -2 3]"},"Skin":{"ViewModelMats":[2.0,3.0,4.0,5.0,6.0,7.0,8.0],"WorldModelMats":[1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[15.9073 0.3053 0.41]","ViewModelAngle":"{180 270 90}","WorldModelPos":"[0 0 0]"},"Class":"Rifle","Model":"models/weapons/w_hk_416.mdl","Name":"HK 416"}]] )
-- WEAPONS:AddWeapon( "m9k_g3a3", [[]] )
-- WEAPONS:AddWeapon( "m9k_l85", [[]] )
-- WEAPONS:AddWeapon( "m9k_m14sp", [[]] )
-- WEAPONS:AddWeapon( "m9k_m16a4_acog", [[]] )
-- WEAPONS:AddWeapon( "m9k_m4a1", [[]] )
WEAPONS:AddWeapon( "m9k_scar", [[{"Charm":{"WorldModelAngle":"{0 90 0}","ViewModelPos":"[0.4633 -14.2085 0]","ViewModelAngle":"{0 0 90}","WorldModelPos":"[9.5 -1.5 3]"},"Skin":{"WorldModelMats":[7.0,8.0],"ViewModelMats":[7.0,8.0]},"Sticker":{"WorldModelAngle":"{0 0 0}","ViewModelPos":"[16.6795 -0.7722 0.65]","ViewModelAngle":"{0 90 180}","WorldModelPos":"[0 0 0]"},"Class":"Rifle","Model":"models/weapons/w_fn_scar_h.mdl","Name":"Scar"}]] )
-- WEAPONS:AddWeapon( "m9k_vikhr", [[]] )
-- WEAPONS:AddWeapon( "m9k_auga3", [[]] )
-- WEAPONS:AddWeapon( "m9k_tar21", [[]] )

WEAPONS:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
