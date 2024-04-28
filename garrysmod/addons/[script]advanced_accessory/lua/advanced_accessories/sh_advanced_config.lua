/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

AAS = AAS or {}

--[[ If you want to add more category in the main menu you can just copy/past this 
    [YOUNEEDTOCHANGETHIS] = {    
        ["uniqueName"] = "Hat",
        ["material"] = Material("aas_materials/ass_icon_hat.png", "smooth"),
        ["margin"] = 0.006,
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

    DON'T TOUCH THE CATEGORY OF adminMenu AND positionMenu please !
]]
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */



AAS.SimilarityBones = {
    ["ValveBiped.Bip01_Head1"] = {
        ["Head"] = true,
        ["LrigScull"] = true,
    },
    ["ValveBiped.Bip01_Spine"] = {
        ["Spine1"] = true,
        ["Spine2"] = true,
        ["Spine3"] = true,
        ["L_Clavicle"] = true,
        ["LrigSpine1"] = true,
        ["LrigSpine2"] = true,
    },
    ["ValveBiped.Bip01_Neck1"] = {
        ["Neck"] = true,
    },
}

AAS.Category = {
    ["mainMenu"] = {
        [1] = {
            ["uniqueName"] = "Все",
            ["material"] = Material("aas_materials/ass_icon_all.png", "smooth"),
            ["all"] = true,
            ["margin"] = 0,
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [2] = {
            ["uniqueName"] = "Голова",
            ["material"] = Material("aas_materials/ass_icon_hat.png", "smooth"),
            ["margin"] = 0.006,
            ["bone"] = "ValveBiped.Bip01_Head1",
        }, 
        [3] = {
            ["uniqueName"] = "Глаза",
            ["material"] = Material("aas_materials/ass_icon_glasses.png", "smooth"),
            ["margin"] = 0.005,
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [4] = {
            ["uniqueName"] = "Маска",
            ["material"] = Material("aas_materials/aas_mask_2.png", "smooth"),
            ["margin"] = 0.008,
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [5] = {
            ["uniqueName"] = "Спина",
            ["material"] = Material("aas_materials/ass_icon_bag.png", "smooth"),
            ["margin"] = 0.01,
            ["bone"] = "ValveBiped.Bip01_Neck1",
        },
        [6] = {    
            ["uniqueName"] = "Шея",
            ["material"] = Material("aas_materials/ass_mask_1.png", "smooth"),
            ["margin"] = 0.009,
            ["bone"] = "ValveBiped.Bip01_Neck1",
        },
        [7] = {    
            ["uniqueName"] = "Плащ",
            ["material"] = Material("aas_materials/ass_icon_bag.png", "smooth"),
            ["margin"] = 0.009,
            ["bone"] = "ValveBiped.Bip01_Neck1",
        },
        [8] = {    
            ["uniqueName"] = "Пояс",
            ["material"] = Material("aas_materials/ass_icon_bag.png", "smooth"),
            ["margin"] = 0.009,
            ["bone"] = "ValveBiped.Bip01_Neck1",
        },
    },
    --[[ Don't touch to this part please !! ]]
    ["adminMenu"] = {
        [1] = {
            ["uniqueName"] = "Settings",
            ["material"] = Material("aas_materials/aas_settings.png", "smooth"),
            ["sizeX"] = 0.015, 
            ["sizeY"] = 0.027,
            ["callBack"] = function() 
                AAS.AdminSetting()
            end,
        },
        [2] = {
            ["uniqueName"] = "Add",
            ["material"] = Material("aas_materials/aas_plus.png", "smooth"),
            ["sizeX"] = 0.015, 
            ["sizeY"] = 0.026,
            ["callBack"] = function()
                AAS.CreateAccessory()
            end,
        }, 
    },
    --[[ Don't touch to this part please !! ]]
    ["positionMenu"] = {
        [1] = {
            ["uniqueName"] = "Add",
            ["material"] = Material("aas_materials/aas_plus.png", "smooth"),
            ["sizeX"] = 0.015, 
            ["sizeY"] = 0.026,
            ["callBack"] = function()
                AAS.PositionSettings()
            end,
        }, 
    },
}

function AAS.BaseItemTable()
    AAS.BaseItems = {
        ["572310302"] = {
            {
                ["scale"] = Vector(1, 1, 1),
                ["options"] = {
                    ["skin"] = "0",
                    ["activate"] = true,
                    ["iconPos"] = Vector(1.75, -0.875, -33.75),
                    ["color"] = Color(240, 240, 240, 255),
                    ["vip"] = false,
                    ["bone"] = "ValveBiped.Bip01_Head1",
                    ["iconFov"] = -40,
                    ["new"] = true,
                },
                ["uniqueId"] = 1,
                ["model"] = "models/sal/gingerbread.mdl",
                ["pos"] = Vector(1.875, 0, 0),
                ["category"] = "Маска",
                ["job"] = {},
                ["ang"] = Angle(-75.125, 0, -89.59400177002),
                ["price"] = 1000,
                ["name"] = AAS.GetSentence("titleGingerBread"),
                ["description"] = AAS.GetSentence("descGingerBread"),
            },
        }
    }
end
AAS.BaseItemTable()