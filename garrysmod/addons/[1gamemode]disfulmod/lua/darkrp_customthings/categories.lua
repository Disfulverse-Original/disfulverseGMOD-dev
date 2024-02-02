--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

-- Контрабандист, Продавец Оружия, Барахольщик
DarkRP.createCategory {
    name = "Ресурсы",
    categorises = "entities",
    startExpanded = true,
    color = Color(142, 137, 239),
    sortOrder = 1,
    canSee = function(ply) 
         return table.HasValue({TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Вооружение",
    categorises = "shipments",
    startExpanded = true,
    color = Color(224, 187, 92),
    sortOrder = 2,
    canSee = function(ply) 
         return table.HasValue({TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Разное",
    categorises = "entities",
    startExpanded = true,
    color = Color(215, 247, 238),
    sortOrder = 3,
    canSee = function(ply) 
         return table.HasValue({TEAM_BARACH}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Аммуниция",
    categorises = "entities",
    startExpanded = true,
    color = Color(170, 255, 84),
    sortOrder = 4,
    canSee = function(ply) 
         return table.HasValue({TEAM_PRODOR, TEAM_ZARUB, TEAM_BARACH}, ply:Team()) 
    end,
}

-- Контрабандист
DarkRP.createCategory {
    name = "Оптика",
    categorises = "entities",
    startExpanded = true,
    color = Color(222, 255, 237),
    sortOrder = 3,
    canSee = function(ply) 
         return table.HasValue({TEAM_ZARUB}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Типы патронов",
    categorises = "entities",
    startExpanded = true,
    color = Color(222, 255, 247),
    sortOrder = 4,
    canSee = function(ply) 
         return table.HasValue({TEAM_ZARUB}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Модификации",
    categorises = "entities",
    startExpanded = true,
    color = Color(222, 245, 255),
    sortOrder = 5,
    canSee = function(ply) 
         return table.HasValue({TEAM_ZARUB}, ply:Team()) 
    end,
}



-- Варщик Мета
DarkRP.createCategory {
    name = "Метоварка",
    categorises = "entities",
    startExpanded = true,
    color = Color(92, 224, 209),
    sortOrder = 6,
    canSee = function(ply) 
         return table.HasValue({TEAM_GROVER}, ply:Team()) 
    end,
}