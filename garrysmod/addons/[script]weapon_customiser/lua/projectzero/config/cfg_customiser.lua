--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local MODULE = PROJECT0.FUNC.CreateConfigModule( "CUSTOMISER" )

MODULE:SetTitle( "Customiser" )
MODULE:SetIcon( "project0/icons/paint_64.png" )
MODULE:SetDescription( "Config for the weapon customiser." )

MODULE:AddVariable( "SkinNetworkDelay", "Skin Network Delay", "The delay between requesting player weapon skins in seconds.", PROJECT0.TYPE.Int, 5 )
MODULE:AddVariable( "StatisticsNetworkDelay", "Statistics Network Delay", "How often a client is allowed to request statistics in seconds.", PROJECT0.TYPE.Int, 60 )
MODULE:AddVariable( "StoreCurrency", "Store Currency", "The currency used in the cosmetic store.", PROJECT0.TYPE.String, "darkrp", false, function()
    local options = {}
    for k, v in pairs( PROJECT0.TEMP.Currencies ) do
        if( not v.IsInstalled() ) then continue end
        options[v.ID] = v.Title
    end

    return options
end )

MODULE:AddVariable( "Weapons", "Configured Weapons", "Data for weapon skins and charms.", PROJECT0.TYPE.Table, {}, "pz_config_customiser_weapons" )

MODULE:AddVariable( "Skins", "Skins", "Config for skins.", PROJECT0.TYPE.Table, {
    [1] = { Rarity = "glitched" },
    [2] = { Rarity = "legendary" },
    [3] = { Rarity = "epic" },
    [4] = { Rarity = "rare" },
    [5] = { Rarity = "uncommon" },
    [6] = { Rarity = "epic" },
    [7] = { Rarity = "rare" },
    [8] = { Rarity = "epic" },
    [9] = { Rarity = "common" },
    [10] = { Rarity = "uncommon" },
    [11] = { Rarity = "common" },
    [12] = { Rarity = "common" },
    [13] = { Rarity = "common" },
    [14] = { Rarity = "uncommon" },
    [15] = { Rarity = "rare" },
    [16] = { Rarity = "rare" },
    [17] = { Rarity = "uncommon" },
    [18] = { Rarity = "glitched" },
    [19] = { Rarity = "legendary" },
    [20] = { Rarity = "rare" }
}, "pz_config_customiser_skins" )

MODULE:AddVariable( "Charms", "Charms", "Config for charms.", PROJECT0.TYPE.Table, {
    [1] = {
        Name = "Hotair Balloon",
        Model = "models/sterling/cosmic_hotairballoon.mdl",
        Rarity = "uncommon"
    },
    [2] = {
        Name = "Dice",
        Model = "models/sterling/smodel_dice.mdl",
        Rarity = "rare"
    },
    [3] = {
        Name = "Gamer Keyboard",
        Model = "models/sterling/smodel_gamerkeyboard.mdl",
        Rarity = "glitched"
    },
    [4] = {
        Name = "sModel",
        Model = "models/sterling/smodel_keytag.mdl",
        Rarity = "common"
    },
    [5] = {
        Name = "Nuke",
        Model = "models/sterling/smodel_nukebomb.mdl",
        Rarity = "legendary"
    },
    [6] = {
        Name = "Retro",
        Model = "models/sterling/smodel_retrocontroller.mdl",
        Rarity = "epic"
    },
    [7] = {
        Name = "Cheese",
        Model = "models/sterling/smodel_slicedcheese.mdl",
        Rarity = "epic"
    },
    [8] = {
        Name = "Toxic Barrel",
        Model = "models/sterling/smodel_toxicbarrel.mdl",
        Rarity = "rare"
    }
}, "pz_config_customiser_charms" )

MODULE:AddVariable( "Stickers", "Stickers", "Config for stickers.", PROJECT0.TYPE.Table, {
    [1] = {
        Name = "Masterchief",
        Icon = "https://i.imgur.com/ynMWYER.png",
        Rarity = "glitched"
    },
    [2] = {
        Name = "Karambit",
        Icon = "https://i.imgur.com/dfcmOUN.png",
        Rarity = "epic"
    },
    [3] = {
        Name = "Brick",
        Icon = "https://i.imgur.com/cMH5GN9.png",
        Rarity = "legendary"
    }
}, "pz_config_customiser_stickers" )

MODULE:AddVariable( "StoreCategories", "Store Categories", "Config for store categories.", PROJECT0.TYPE.Table, {
    [1] = {
        Name = "Limited",
        Icon = "project0/icons/time.png",
        Order = 1
    },
    [2] = {
        Name = "Skins/Charms/Stickers",
        Icon = "project0/icons/paint_64.png",
        Order = 2
    }
}, "pz_config_customiser_storecategories" )

MODULE:AddVariable( "Store", "Store", "Config for the cosmetic store.", PROJECT0.TYPE.Table, {
    [1] = {
        Price = 10000,
        Category = 2,
        Type = 3,
        ItemID = 2,
        Weapons = { "m9k_m416", "m9k_scar" },
        Featured = true
    },
    [2] = {
        Price = 250000,
        Category = 1,
        Type = 3,
        ItemID = 1,
        Weapons = { "m9k_m416" }
    },
    [3] = {
        Price = 3000,
        Category = 2,
        Type = 1,
        ItemID = 1
    },
    [4] = {
        Price = 15000,
        Category = 2,
        Type = 2,
        ItemID = 2
    },
    [5] = {
        Price = 25000,
        Category = 1,
        Type = 2,
        ItemID = 3,
        Featured = true
    },
    [6] = {
        Price = 250000,
        Category = 1,
        Type = 1,
        ItemID = 7,
        Featured = true
    }
}, "pz_config_customiser_store" )

MODULE:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
