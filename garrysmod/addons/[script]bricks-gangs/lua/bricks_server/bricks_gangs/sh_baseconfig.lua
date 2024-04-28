--[[
    !!WARNING!!
        ALL CONFIG IS DONE INGAME, DONT EDIT ANYTHING HERE
        Type !bricksserver ingame or use the f4menu
    !!WARNING!!
]]--

--[[ MODULES CONFIG ]]--
BRICKS_SERVER.BASECONFIG.MODULES = BRICKS_SERVER.BASECONFIG.MODULES or {}
BRICKS_SERVER.BASECONFIG.MODULES["gangs"] = { true, {
    ["achievements"] = true,
    ["associations"] = true,
    ["leaderboards"] = true,
    ["printers"] = true,
    ["storage"] = true,
    ["territories"] = true
} }

--[[ GANGS CONFIG ]]--
BRICKS_SERVER.BASECONFIG.GANGS = {}
BRICKS_SERVER.BASECONFIG.GANGS["Max Level"] = 15
BRICKS_SERVER.BASECONFIG.GANGS["Original EXP Required"] = 10000
BRICKS_SERVER.BASECONFIG.GANGS["EXP Required Increase"] = 1.01
BRICKS_SERVER.BASECONFIG.GANGS["Creation Fee"] = 75000
BRICKS_SERVER.BASECONFIG.GANGS["Minimum Deposit"] = 500
BRICKS_SERVER.BASECONFIG.GANGS["Minimum Withdraw"] = 500
BRICKS_SERVER.BASECONFIG.GANGS["Max Storage Item Stack"] = 30
BRICKS_SERVER.BASECONFIG.GANGS["Territory Capture Distance"] = 200000
BRICKS_SERVER.BASECONFIG.GANGS["Territory UnCapture Time"] = 25
BRICKS_SERVER.BASECONFIG.GANGS["Territory Capture Time"] = 15
BRICKS_SERVER.BASECONFIG.GANGS["Leaderboard Refresh Time"] = 300
BRICKS_SERVER.BASECONFIG.GANGS["Gang Display Limit"] = 10
BRICKS_SERVER.BASECONFIG.GANGS["Gang Friendly Fire"] = true
BRICKS_SERVER.BASECONFIG.GANGS["Disable Gang Chat"] = false
BRICKS_SERVER.BASECONFIG.GANGS["Gang Display Distance"] = 10000

BRICKS_SERVER.BASECONFIG.GANGS.Upgrades = {
    ["MaxMembers"] = {
        Name = "Кол-во участников", 
        Description = "Количество участников в банде.",
        Icon = "members_upgrade.png",
        Default = { 5 },
        Tiers = {
            [1] = {
                Price = 25000,
                ReqInfo = { 7 }
            },
            [2] = {
                Price = 50000,
                ReqInfo = { 10 }
            },
            [3] = {
                Price = 100000,
                ReqInfo = { 15 }
            }
        }
    },
    ["MaxBalance"] = {
        Name = "Кол-во денег в бюджете", 
        Description = "Количество денег в бюджете банды.",
        Icon = "balance.png",
        Default = { 25000 },
        Tiers = {
            [1] = {
                Price = 25000,
                ReqInfo = { 50000 }
            },
            [2] = {
                Price = 50000,
                ReqInfo = { 150000 }
            },
            [3] = {
                Price = 150000,
                ReqInfo = { 750000 }
            }
        }
    },
    ["StorageSlots"] = {
        Name = "Хранилище банды", 
        Description = "Количество слотов в хранилище банды.",
        Icon = "storage_64.png",
        Default = { 0 },
        Tiers = {
            [1] = {
                Price = 25000,
                ReqInfo = { 5 }
            },
            [2] = {
                Price = 50000,
                ReqInfo = { 15 }
            },
            [3] = {
                Price = 100000,
                ReqInfo = { 20 }
            },
            [4] = {
                Price = 200000,
                ReqInfo = { 25 }
            }
        }
    },
    ["Health"] = {
        Name = "Увеличенное ХП", 
        Description = "Увеличивает кол-во ХП при спавне.",
        Icon = "health_upgrade.png",
        Default = { 0 },
        Tiers = {
            [1] = {
                Price = 200000,
                ReqInfo = { 5 }
            },
            [2] = {
                Price = 750000,
                ReqInfo = { 10 }
            }
        }
    },
    ["Armor"] = {
        Name = "Увеличенная Броня", 
        Description = "Увеличивает кол-во БРОНИ при спавне.",
        Icon = "armor_upgrade.png",
        Default = { 0 },
        Tiers = {
            [1] = {
                Price = 200000,
                ReqInfo = { 5 }
            },
            [2] = {
                Price = 750000,
                ReqInfo = { 10 }
            }
        }
    }
}

BRICKS_SERVER.BASECONFIG.GANGS.Achievements = {
    [2] = {
        Name = "2 Уровень", 
        Description = "Достигните 2 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 2 },
        Rewards = { ["GangBalance"] = { 20000 }, ["GangExperience"] = { 2000 } }
    },
    [3] = {
        Name = "3 Уровень", 
        Description = "Достигните 3 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 3 },
        Rewards = { ["GangBalance"] = { 30000 }, ["GangExperience"] = { 3000 } }
    },
    [4] = {
        Name = "4 Уровень", 
        Description = "Достигните 4 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 4 },
        Rewards = { ["GangBalance"] = { 40000 }, ["GangExperience"] = { 4000 } }
    },
    [5] = {
        Name = "5 Уровень", 
        Description = "Достигните 5 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 5 },
        Rewards = { ["GangBalance"] = { 50000 }, ["GangExperience"] = { 5000 } }
    },
    [6] = {
        Name = "6 Уровень", 
        Description = "Достигните 6 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 6 },
        Rewards = { ["GangBalance"] = { 60000 }, ["GangExperience"] = { 6000 } }
    },
    [7] = {
        Name = "7 Уровень", 
        Description = "Достигните 7 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 7 },
        Rewards = { ["GangBalance"] = { 70000 }, ["GangExperience"] = { 7000 } }
    },
    [8] = {
        Name = "8 Уровень", 
        Description = "Достигните 8 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 8 },
        Rewards = { ["GangBalance"] = { 80000 }, ["GangExperience"] = { 8000 } }
    },
    [9] = {
        Name = "9 Уровень", 
        Description = "Достигните 9 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 9 },
        Rewards = { ["GangBalance"] = { 90000 }, ["GangExperience"] = { 9000 } }
    },
    [10] = {
        Name = "10 Уровень", 
        Description = "Достигните 10 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 10 },
        Rewards = { ["GangBalance"] = { 100000 }, ["GangExperience"] = { 10000 } }
    },
    [11] = {
        Name = "11 Уровень", 
        Description = "Достигните 11 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 11 },
        Rewards = { ["GangBalance"] = { 110000 }, ["GangExperience"] = { 11000 } }
    },
    [12] = {
        Name = "12 Уровень", 
        Description = "Достигните 12 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 12 },
        Rewards = { ["GangBalance"] = { 120000 }, ["GangExperience"] = { 12000 } }
    },
    [13] = {
        Name = "13 Уровень", 
        Description = "Достигните 13 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 13 },
        Rewards = { ["GangBalance"] = { 130000 }, ["GangExperience"] = { 13000 } }
    },
    [14] = {
        Name = "14 Уровень", 
        Description = "Достигните 14 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 14 },
        Rewards = { ["GangBalance"] = { 140000 }, ["GangExperience"] = { 14000 } }
    },
    [15] = {
        Name = "15 Уровень", 
        Description = "Достигните 15 уровня банды.",
        Icon = "levelling.png",
        Category = "Level Achievements",
        Type = "Level",
        ReqInfo = { 15 },
        Rewards = { ["GangBalance"] = { 150000 }, ["GangExperience"] = { 15000 } }
    }
}

BRICKS_SERVER.BASECONFIG.GANGS.Leaderboards = {
    [1] = {
        Name = "Наибольшее кол-во опыта", 
        Type = "Experience",
        Color = Color( 22, 160, 133 )
    },
    [2] = {
        Name = "Наибольшее число участников", 
        Type = "Members",
        Color = Color( 41, 128, 185 )
    },
    [3] = {
        Name = "Наибольший капитал", 
        Type = "Balance",
        Color = Color( 39, 174, 96 )
    },
    [4] = {
        Name = "Наибольшее кол-во предметов", 
        Type = "StorageItems",
        Color = Color( 231, 76, 60 )
    }
}

BRICKS_SERVER.BASECONFIG.GANGS.Territories = {
    [1] = {
        Name = "[1] Канализации",
        Color = Color( 171, 171, 237 ),
        RewardTime = 60,
        Rewards = { ["GangBalance"] = { 1500 }, ["GangExperience"] = { 25 } }
    },
    [2] = {
        Name = "[2] Цех",
        Color = Color( 210, 201, 245 ),
        RewardTime = 120,
        Rewards = { ["GangBalance"] = { 2000 }, ["GangExperience"] = { 50 } }
    },
    [3] = {
        Name = "[3] Трущобы",
        Color = Color( 184, 124, 217 ),
        RewardTime = 30,
        Rewards = { ["GangBalance"] = { 500 }, ["GangExperience"] = { 75 } }
    }
}

--[[ GANG PRINTER CONFIG ]]--
BRICKS_SERVER.BASECONFIG.GANGPRINTERS = {}
BRICKS_SERVER.BASECONFIG.GANGPRINTERS["Income Update Time"] = 10
BRICKS_SERVER.BASECONFIG.GANGPRINTERS["Base Printer Health"] = 100
BRICKS_SERVER.BASECONFIG.GANGPRINTERS.Printers = {
    [1] = {
        Name = "Принтер 1",
        Price = 120000,
        ServerPrices = { 30000, 30000, 30000, 30000, 30000, 30000 },
        ServerAmount = 825,
        ServerHeat = 11,
        MaxHeat = 100,
        BaseHeat = 10,
        ServerTime = 20
    }
}
BRICKS_SERVER.BASECONFIG.GANGPRINTERS.Upgrades = {
    ["Health"] = {
        Name = "Прочность принтера",
        Tiers = {
            [1] = { 
                Price = 30000,
                Level = 1,
                ReqInfo = { 25 }
            },
            [2] = { 
                Price = 30000,
                Level = 10,
                ReqInfo = { 75 }
            }
        }
    },
    ["RGB"] = {
        Name = "RGB LEDS",
        Price = 60000
    }
}
BRICKS_SERVER.BASECONFIG.GANGPRINTERS.ServerUpgrades = {
    ["Cooling"] = {
        Name = "Охлаждение",
        Tiers = {
            [1] = { 
                Price = 1000,
                Level = 2,
                ReqInfo = { 15 }
            },
            [2] = { 
                Price = 2500,
                Level = 5,
                ReqInfo = { 30 }
            },
            [3] = { 
                Price = 2500,
                Level = 11,
                ReqInfo = { 60 }
            }
        }
    },
    ["Speed"] = {
        Name = "Скорость",
        Tiers = {
            [1] = { 
                Price = 1000,
                Level = 3,
                ReqInfo = { 10 }
            },
            [2] = { 
                Price = 2500,
                Level = 6,
                ReqInfo = { 15 }
            },
            [3] = { 
                Price = 2500,
                Level = 9,
                ReqInfo = { 20 }
            },
            [4] = { 
                Price = 5000,
                Level = 12,
                ReqInfo = { 25 }
            },
            [5] = { 
                Price = 7500,
                Level = 14,
                ReqInfo = { 35 }
            }
        }
    },
    ["Amount"] = {
        Name = "Доходность",
        Tiers = {
            [1] = { 
                Price = 1000,
                Level = 4,
                ReqInfo = { 10 }
            },
            [2] = { 
                Price = 2500,
                Level = 7,
                ReqInfo = { 25 }
            },
            [3] = { 
                Price = 5000,
                Level = 10,
                ReqInfo = { 50 }
            },
            [4] = { 
                Price = 8500,
                Level = 13,
                ReqInfo = { 75 }
            },
            [5] = { 
                Price = 8500,
                Level = 15,
                ReqInfo = { 125 }
            }
        }
    }
}


BRICKS_SERVER.BASECONFIG.NPCS = BRICKS_SERVER.BASECONFIG.NPCS or {}
--[[
table.insert( BRICKS_SERVER.BASECONFIG.NPCS, {
    Name = "Gang",
    Type = "Gang"
} )
--]]