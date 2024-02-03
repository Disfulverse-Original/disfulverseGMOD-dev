CITYWORKER = CITYWORKER or {}

CITYWORKER.Config = CITYWORKER.Config or {}

--[[
  /$$$$$$  /$$   /$$                     /$$      /$$                     /$$                          
 /$$__  $$|__/  | $$                    | $$  /$ | $$                    | $$                          
| $$  \__/ /$$ /$$$$$$   /$$   /$$      | $$ /$$$| $$  /$$$$$$   /$$$$$$ | $$   /$$  /$$$$$$   /$$$$$$ 
| $$      | $$|_  $$_/  | $$  | $$      | $$/$$ $$ $$ /$$__  $$ /$$__  $$| $$  /$$/ /$$__  $$ /$$__  $$
| $$      | $$  | $$    | $$  | $$      | $$$$_  $$$$| $$  \ $$| $$  \__/| $$$$$$/ | $$$$$$$$| $$  \__/
| $$    $$| $$  | $$ /$$| $$  | $$      | $$$/ \  $$$| $$  | $$| $$      | $$_  $$ | $$_____/| $$      
|  $$$$$$/| $$  |  $$$$/|  $$$$$$$      | $$/   \  $$|  $$$$$$/| $$      | $$ \  $$|  $$$$$$$| $$      
 \______/ |__/   \___/   \____  $$      |__/     \__/ \______/ |__/      |__/  \__/ \_______/|__/      
                         /$$  | $$                                                                     
                        |  $$$$$$/                                                                     
                         \______/                                                                      
                                
                                                v104
                                    By: Silhouhat (76561198072551027)
                                      Licensed to: 76561198366199837

--]]

-- How often should we check (in seconds) for City Workers with no assigned jobs, so we can give them?
CITYWORKER.Config.Time = 15

-- Configuration for the DarkRP job.
CITYWORKER.Config.Job = {
    name = "Городской работник / 0 lvl",

    color = Color( 20, 150, 20, 255 ),
    model = {
        "models/arty/codmw2022/mp/dmz/shadowcompany/boss/trap/trap_pm.mdl"
    },
    description = "Работа городского рабочего состоит в том, чтобы ходить и устранять утечки, пожарные гидранты, завалы и проблемы с электричеством по всему городу, и получать за это деньги!",
    weapons = { "cityworker_pliers", "cityworker_shovel", "cityworker_wrench" },
    command = "cityworker",
    max = 0,
    salary = 15,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Нейтральные",
}

------------
-- RUBBLE --
------------

CITYWORKER.Config.Rubble = {}

-- Whether or not rubble is enabled or disabled.
CITYWORKER.Config.Rubble.Enabled = true

-- Rubble models and the range of time (in seconds) it takes to clear them.
CITYWORKER.Config.Rubble.Models = {
    ["models/props_debris/concrete_debris128pile001a.mdl"] = { min = 20, max = 30 },
    ["models/props_debris/concrete_debris128pile001b.mdl"] = { min = 10, max = 15 },
    ["models/props_debris/concrete_floorpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_cornerpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_spawnplug001a.mdl"] = { min = 5, max = 10 },
    ["models/props_debris/plaster_ceilingpile001a.mdl"] = { min = 10, max = 15 },
}

-- Payout per second it takes to clear a given pile of rubble.
-- (i.e. 10 seconds = 10 * 30 = 300)
CITYWORKER.Config.Rubble.Payout = 30

-------------------
-- FIRE HYDRANTS --
-------------------

CITYWORKER.Config.FireHydrant = {}

-- Whether or not fire hydrants are enabled or disabled.
CITYWORKER.Config.FireHydrant.Enabled = true

-- The range for how long it takes to fix a fire hydrant.
-- Maximum value: 255 seconds.
CITYWORKER.Config.FireHydrant.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix a fire hydrant.
CITYWORKER.Config.FireHydrant.Payout = 5

-----------
-- LEAKS --
-----------

CITYWORKER.Config.Leak = CITYWORKER.Config.Leak or {}

-- Whether or not leaks are enabled or disabled.
CITYWORKER.Config.Leak.Enabled = true

-- The range for how long it takes to fix a leak.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Leak.Time = { min = 10, max = 30 }

-- Payout per second it takes to fix a leak.
CITYWORKER.Config.Leak.Payout = 20

--------------
-- ELECTRIC --
--------------

CITYWORKER.Config.Electric = CITYWORKER.Config.Electric or {}

-- Whether or not electrical problems are enabled or disabled.
CITYWORKER.Config.Electric.Enabled = true

-- The range for how long it takes to fix an electrical problem.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Electric.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix an electrical problem.
CITYWORKER.Config.Electric.Payout = 30

----------------------------
-- LANGUAGE CONFIGURATION --
----------------------------

CITYWORKER.Config.Language = {
    ["FireHydrant"]         = "Чиним пожарный гидрант...",
    ["Leak"]                = "Чиним утечку газа..",
    ["Electric"]            = "Чиним электрику...",
    ["Rubble"]              = "Очистка завала...",

    ["CANCEL"]              = "Нажмите F2, чтобы отменить действие.",
    ["PAYOUT"]              = "Вы заработали %s за свою работу!",
    ["CANCELLED"]           = "Вы отменили действие!",
    ["NEW_JOB"]             = "У тебя новая работа!",
    ["NOT_CITY_WORKER"]     = "Вы не городской работник!",
    ["JOB_WORKED"]          = "Эта работа уже выполняется!",
    ["ASSIGNED_ELSE"]       = "Эта работа была назначена другому!",
}