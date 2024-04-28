local MODULE = BOTCHED.FUNC.CreateConfigModule( "REWARDS" )

MODULE:SetTitle( "Rewards" )
MODULE:SetIcon( "botched/icons/reward_32.png" )
MODULE:SetDescription( "Config for the Rewards module from gmodstore." )

MODULE:AddVariable( "TimeRewards", "Time Rewards", "Add/edit time rewards.", BOTCHED.TYPE.Table, {
    ["15minutes"] = {
        Time = 900,
        RewardType = "Money",
        RewardValue = 150
    },
    ["30minutes"] = {
        Time = 1800,
        RewardType = "Money",
        RewardValue = 200
    },
    ["1hour"] = {
        Time = 3600,
        RewardType = "Items",
        RewardValue = { "link", 1 }
    },
    ["2hours"] = {
        Time = 3600*2,
        RewardType = "Money",
        RewardValue = 500
    },
    ["4hours"] = {
        Time = 3600*4,
        RewardType = "Money",
        RewardValue = 800
    },
    ["8hours"] = {
        Time = 3600*8,
        RewardType = "Money",
        RewardValue = 900
    },
    ["16hours"] = {
        Time = 3600*16,
        RewardType = "Money",
        RewardValue = 1000
    },
    ["24hours"] = {
        Time = 3600*24,
        RewardType = "Items",
        RewardValue = { "astolfo_sch", 1 }
    },
    ["2days"] = {
        Time = 3600*24*2,
        RewardType = "Money",
        RewardValue = 1500
    },
    ["4days"] = {
        Time = 3600*24*4,
        RewardType = "Money",
        RewardValue = 2000
    },
    ["7days"] = {
        Time = 3600*24*7,
        RewardType = "Money",
        RewardValue = 3000
    },
    ["2weeks"] = {
        Time = 3600*24*14,
        RewardType = "Money",
        RewardValue = 4500
    },
    ["4weeks"] = {
        Time = 3600*24*28,
        RewardType = "Money",
        RewardValue = 6000
    }
}, "botched_config_timerewards" )

MODULE:AddVariable( "LoginRewards", "Login Rewards", "Add/edit login rewards for each consecutive day.", BOTCHED.TYPE.Table, {
    [1] = { 
        RewardType = "Money", 
        RewardValue = 2500 
    },
    [2] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_fiveseven2", 3 } 
    },
    [3] = { 
        RewardType = "Money", 
        RewardValue = 5000 
    },
    [4] = { 
        RewardType = "Money", 
        RewardValue = 15000 
    },
    [5] = { 
        RewardType = "Money", 
        RewardValue = 25000 
    },
    [6] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_p2282", 5 } 
    },
    [7] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_ak472", 1 } 
    },


    [8] = { 
        RewardType = "Money", 
        RewardValue = 5000 
    },
    [9] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_glock2", 3 } 
    },
    [10] = { 
        RewardType = "Money", 
        RewardValue = 10000 
    },
    [11] = { 
        RewardType = "Money", 
        RewardValue = 30000 
    },
    [12] = { 
        RewardType = "Money", 
        RewardValue = 50000 
    },
    [13] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_mp52", 5 } 
    },
    [14] = { 
        RewardType = "Items", 
        RewardValue = { "ls_sniper", 1 } 
    },

    [15] = { 
        RewardType = "Money", 
        RewardValue = 5000 
    },
    [16] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_glock2", 3 } 
    },
    [17] = { 
        RewardType = "Money", 
        RewardValue = 10000 
    },
    [18] = { 
        RewardType = "Money", 
        RewardValue = 30000 
    },
    [19] = { 
        RewardType = "Money", 
        RewardValue = 50000 
    },
    [20] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_mp52", 5 } 
    },
    [21] = { 
        RewardType = "Items", 
        RewardValue = { "ls_sniper", 1 } 
    },

    [22] = { 
        RewardType = "Money", 
        RewardValue = 5000 
    },
    [23] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_glock2", 3 } 
    },
    [24] = { 
        RewardType = "Money", 
        RewardValue = 10000 
    },
    [25] = { 
        RewardType = "Money", 
        RewardValue = 30000 
    },
    [26] = { 
        RewardType = "Money", 
        RewardValue = 50000 
    },
    [27] = { 
        RewardType = "Items", 
        RewardValue = { "weapon_mp52", 5 } 
    },
    [28] = { 
        RewardType = "Items", 
        RewardValue = { "ls_sniper", 1 } 
    },
    [29] = { 
        RewardType = "Items", 
        RewardValue = { "ls_sniper", 1 } 
    },
    [30] = { 
        RewardType = "Items", 
        RewardValue = { "1000000_money", 1 } 
    },
}, "botched_config_loginrewards" )

MODULE:AddVariable( "ReferralRewards", "Referral Rewards", "Add/edit referral rewards for referring players.", BOTCHED.TYPE.Table, {
    [1] = { 
        Money = 10000,
        Items = {
            ["weapon_pumpshotgun2"] = 1
        }
    },
    [3] = { 
        Money = 25000,
        Items = {
            ["weapon_mp52"] = 1,
            ["ls_sniper"] = 1
        }
    },
    [10] = { 
        Money = 1500,
        Items = {
            ["weapon_mp52"] = 3,
            ["weapon_ak472"] = 1
        }
    },
    [25] = { 
        Money = 50000
    }
}, "botched_config_referralrewards" )

MODULE:Register()