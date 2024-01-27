--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local MODULE = PROJECT0.FUNC.CreateConfigModule( "GENERAL" )

MODULE:SetTitle( "Base" )
MODULE:SetIcon( "project0/icons/base.png" )
MODULE:SetDescription( "Config for the base framework." )
MODULE:SetSortOrder( 100 )

MODULE:AddVariable( "DisplayDistance3D2D", "3D2D Render Distance", "The distance at which 3D2D panels should render in units^2.", PROJECT0.TYPE.Int, 500000 )
MODULE:AddVariable( "Language", "Language", "The language used for the addon.", PROJECT0.TYPE.String, "english", false, function()
    local options = {}
    for k, v in pairs( PROJECT0.TEMP.Languages ) do
        options[v.ID] = v.Name
    end

    return options
end )

MODULE:AddVariable( "Themes", "Colour Themes", "The colours used for various UI elements.", PROJECT0.TYPE.Table, {
    [1] = Color( 34, 40, 49 ), -- Background 1
    [2] = Color( 57, 62, 70 ), -- Background 2
    [3] = Color( 238, 238, 238 ), -- Text
    [4] = Color( 214, 90, 49 ) -- Accent
}, "pz_config_themes" )

local rainbowColors, range = {}, 10
for i = 1, range do
    table.insert( rainbowColors, HSVToColor( (i/range)*360, 1, 1 ) )
end

MODULE:AddVariable( "Rarities", "Rarities", "Colors used for certain rarities.", PROJECT0.TYPE.Table, {
    ["common"] = {
        Order = 1,
        Title = "Common", 
        Type = "Gradient", 
        Colors = { Color( 154, 154, 154 ), Color( 154*1.5, 154*1.5, 154*1.5 ) }
    },
    ["uncommon"] = {
        Order = 2,
        Title = "Uncommon", 
        Type = "Gradient", 
        Colors = { Color( 104, 255, 104 ), Color( 104*1.5, 255*1.5, 104*1.5 ) }
    },
    ["rare"] = {
        Order = 3,
        Title = "Rare", 
        Type = "Gradient", 
        Colors = { Color( 42, 133, 219 ),Color( 42*1.5, 133*1.5, 219*1.5 ) }
    },
    ["epic"] = {
        Order = 4,
        Title = "Epic", 
        Type = "Gradient", 
        Colors = { Color( 152, 68, 255 ), Color( 152*1.5, 68*1.5, 255*1.5 ) }
    },
    ["legendary"] = {
        Order = 5,
        Title = "Legendary",
        Type = "Gradient", 
        Colors = { Color( 253, 162, 77 ), Color( 253*1.5, 162*1.5, 77*1.5 ) }
    },
    ["glitched"] = {
        Order = 6,
        Title = "Glitched",
        Type = "Gradient",
        Colors = rainbowColors
    }
}, "pz_config_rarities" )

MODULE:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
