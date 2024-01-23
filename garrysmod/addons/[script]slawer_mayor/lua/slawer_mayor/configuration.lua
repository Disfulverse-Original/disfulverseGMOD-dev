local cfg = {}

-- Language of the addon (you can look at slawer_mayor/languages/ to know which are available)
cfg.Language = "ru"

-- Does everything reset when there is no mayor? (funds, upgrades, taxes)
cfg.AllResetWhenNoMayor = false

-- City funds when the server starts
cfg.DefaultFunds = 5000

-- Max city funds when the server starts
cfg.DefaultMaxFunds = 25000

-- Is the mayor able to withdraw from the safe?
cfg.CanMayorWithdrawFromSafe = true

-- MIN/MAX Values that a mayor can give as a bonus
cfg.MinMaxBonus = {100, 100000}

-- Max tax that a mayor can set (never set it greater than 100!)
cfg.MaxTax = 100

-- delay between each bonus (seconds)
cfg.BonusDelay = 10

-- Delay between each firing (seconds)
cfg.KickDelay = 10

-- Laws scrolling delay (seconds)
cfg.LawsScrollingDelay = 2

-- Time to lockpick a safe (seconds)
cfg.LockpickTime = 30

-- Lockpicked safe alarm duration (seconds)
cfg.AlarmDuration = 20

-- Size of the safe (1 = default)
cfg.SafeSize = 1

-- Jobs that cannot have salary taxes
cfg.TaxesBlacklist = {
	["Gangster"] = true
}

-- Can mayor fire a policeman?
cfg.MayorCanKickCP = true

-- Can the a job lockpick a safe? (leave empty if everyone can)
-- if you want to put a job its like this:
-- cfg.LockpickWhitelist = {
-- 		["JOB NAME"] = true
-- }
cfg.LockpickWhitelist = {}

-- Upgrades that can be bought with the funds of the city
cfg.Upgrades = {}

cfg.Upgrades[1] = {
	Name = "Полицейское снаряжение",
	Description = "Усиливает экипировку полицейских.",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
		[1] = {
			Price = 50,
			Weapons = {"weapon_ar2", "weapon_crowbar"},
		},
		[2] = {
			Price = 200,
			Weapons = {"weapon_rpg", "weapon_crowbar"},
		},
	}
}

cfg.Upgrades[2] = {
	Name = "Зарплата полиции",
	Description = "Повышает зарплату полицейским.",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
		[1] = {
			Price = 500,
			SalaryBonus = 100
		},
		[2] = {
			Price = 1000,
			SalaryBonus = 200
		},
	}
}

cfg.Upgrades[3] = {
	Name = "Полицейская защита",
	Description = "Усиливает бронежилеты полицейских.",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
		[1] = {
			Price = 500,
			DefaultArmor = 100
		},
		[2] = {
			Price = 1000,
			DefaultArmor = 200
		},
	}
}

cfg.Upgrades[4] = {
	Name = "Здоровье полиции",
	Description = "Усиливает здоровье полицейских.",
	DefaultLevel = 0,
	Condition = function(p) return p:isCP() end,
	Levels = {
		[0] = {},
		[1] = {
			Price = 500,
			DefaultHealth = 125
		},
		[2] = {
			Price = 1000,
			DefaultHealth = 150
		},
	}
}

cfg.Upgrades[5] = {
	Name = "Хранилище города",
	Description = "Увеличивает вместимость банка.",
	DefaultLevel = 0,
	Levels = {
		[0] = {},
		[1] = {
			Price = 25000,
			MaxFunds = 50000
		},
		[2] = {
			Price = 50000,
			MaxFunds = 100000
		},
		[3] = {
			Price = 100000,
			MaxFunds = 150000
		},
		[4] = {
			Price = 150000,
			MaxFunds = 200000
		},
		[5] = {
			Price = 200000,
			MaxFunds = 300000
		},
	},
	OnUpgrade = function(intID, intLevel)
		Slawer.Mayor:SetMaxFunds(Slawer.Mayor.CFG.Upgrades[intID].Levels[intLevel].MaxFunds)
	end,
}

-- don't touch at it
cfg.Pass = "76561199031675388"

Slawer.Mayor.CFG = cfg