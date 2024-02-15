--[[ LUA CONFIG ]]--
BRICKS_SERVER.ESSENTIALS.LUACFG = {}
BRICKS_SERVER.ESSENTIALS.LUACFG.UseMySQL = false -- Whether or not MySQL should be used (enter your details in bricks-essentials/lua/bricks_server/bricks_essentials/sv_mysql.lua)
--[[
BRICKS_SERVER.ESSENTIALS.LUACFG.F4Commands = { -- The commands that show up in the F4 menu, 1st value is the title, 2nd is the table of commands and 3rd is a custom check
    { "General", {
        { "Drop Money", "/dropmoney", { { "number", "How much money do you want to drop?" } } },
        { "Give Money", "/give", { { "number", "How much do you want to give?" } } },
        --{ "Change Name", "/rpname", { { "string", "What should your new name be?" } } },
        { "Drop Weapon", "/drop" },
        { "Holster Weapon", "/holster" },
        --{ "Sell All Doors", "/sellalldoors" },
        --{ "Change Job Name", "/job", { { "string", "What should your new job name be?" } } },
    } },
    { "Police", {
        { "Make Wanted", "/wanted", { { "players", "What player do you want to make wanted?" }, { "string", "What is the reason for them being wanted?" } } },
        { "Make Unwanted", "/unwanted", { { "players", "What player do you want to make unwanted?" }, { "string", "What is the reason for them being unwanted?" } } },
        { "Request Warrant", "/warrant", { { "players", "What player do you want a warrant for?" }, { "string", "What is the reason for the warrant?" } } }
    }, function( ply ) 
        if( ply:isCP() ) then
            return true
        else
            return false
        end
    end }
}
--]]
BRICKS_SERVER.ESSENTIALS.LUACFG.ItemDescriptions = { -- Give an item a custom description, put the class of the weapon or name of the resource
    ["revival_tool"] = "Возвращает к жизни смертельно раненых.",
    ["bricks_server_axe"] = "Инструмент для добычи дерева.",
    ["bricks_server_axe1"] = "Инструмент для добычи дерева.",
    ["bricks_server_axe2"] = "Инструмент для добычи дерева.",
    ["bricks_server_axe3"] = "Инструмент для добычи дерева.",
    ["bricks_server_axe4"] = "Инструмент для добычи дерева.",
    ["bricks_server_pickaxe"] = "Инструмент для добычи полезных ископаемых из камней.",
    ["bricks_server_pickaxe1"] = "Инструмент для добычи полезных ископаемых из камней.",
    ["bricks_server_pickaxe2"] = "Инструмент для добычи полезных ископаемых из камней.",
    ["bricks_server_pickaxe3"] = "Инструмент для добычи полезных ископаемых из камней.",
    ["bricks_server_pickaxe4"] = "Инструмент для добычи полезных ископаемых из камней.",
    ["spawned_weapon"] = "Ящик с содержимым.",
    ["arccw_go_shield"] = "Щит сотрудников полиции: эффективное средство защиты,\nобеспечивает надежный барьер от пуль и взрывов.",
	["arccw_ud_870"] = "Ружье 870: мощное дробовое оружие с высокой убойностью,\nидеально подходит для ближнего боя.",
	["arccw_ud_glock"] = "Пистолет Glock: надежный самозарядный пистолет,\nобладающий хорошей точностью и скорострельностью.",
	["arccw_ud_m16"] = "Винтовка M16: классическая винтовка с высокой скорострельностью\nи отличной точностью на средних дистанциях.",
	["arccw_ud_m79"] = "Гранатомет M79: мощное оружие для стрельбы гранатами,\nспособное нанести значительный ущерб врагам и структурам.",
	["arccw_ud_m1014"] = "Дробовик M1014: полуавтоматическое дробовое оружие\nс высокой огневой мощью, подходит для быстрого поражения целей на коротких дистанциях.",
	["arccw_ud_mini14"] = "Винтовка Mini-14: легкая винтовка с хорошей точностью,\nобеспечивающая эффективный контроль на больших расстояниях.",
	["arccw_ud_uzi"] = "Пистолет-пулемет Uzi: компактное оружие с высокой\nскорострельностью, отлично подходит для стрельбы вблизи.",
	["arccw_ur_329"] = "Револьвер 329: мощное оружие с высокой убойностью,\nидеально подходит для точных выстрелов на средних дистанциях.",
	["arccw_ur_ak"] = "Штурмовая винтовка AKM: надежная штурмовая винтовка\nс высокой огневой мощью, эффективная на средних и длинных дистанциях.",
	["arccw_ur_aw"] = "Снайперская винтовка AWM: мощное снайперское оружие\nс высокой точностью и убойностью, предназначенное для долгих дистанций.",
	["arccw_ur_db"] = "Дробовик IZH-58: надежное дробовое оружие, подходит\nдля эффективной стрельбы на близких расстояниях.",
	["arccw_ur_deagle"] = "Пистолет Desert Eagle: мощный пистолет калибра .50,\nобладающий высокой убойностью и прекрасной точностью.",
	["arccw_ur_g3"] = "Штурмовая винтовка G3A3: тяжелая штурмовая винтовка\nс высокой пробиваемостью брони, эффективная на средних и длинных дистанциях.",
	["arccw_ur_m1911"] = "Пистолет M1911: классический самозарядный пистолет\nс высокой точностью и надежностью.",
	["arccw_ur_mp5"] = "Пистолет-пулемет MP5: популярное оружие среди спецназа,\nобладает высокой точностью и умеренной скорострельностью.",
	["arccw_ur_spas12"] = "Дробовик SPAS-12: универсальное дробовое оружие\nс возможностью переключения режима стрельбы, эффективное как на ближних, так и на средних дистанциях."
}

BRICKS_SERVER.ESSENTIALS.LUACFG.HolsterCommands = {
    ["!holster"] = true,
    ["/holster"] = true,
    ["!invholster"] = true,
    ["/invholster"] = true
}