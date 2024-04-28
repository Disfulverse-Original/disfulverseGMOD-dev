-- Do not touch if you don't know what you are doing

-- Constants
WasiedAdminSystem.Constants = {
    ["strings"] = {
        [1] = "ERROR",
        [2] = "ULX",
        [3] = "FADMIN",
        [4] = "[ADMIN SYSTEM] ",
        [5] = "ULib can't be detected by the system ! Not all features of the Admin System will be functional.",
        [6] = "Commands system (ULX/Fadmin) defined in the configuration is not valid !",
        [7] = "Font size is not valid !",
        [8] = "player/suit_sprint.wav",
        [9] = "icon16/cross.png",
        [10] = "X", 
        [11] = "buttons/button14.wav",
        [12] = "AdminSystem:AdminMode",
        [13] = 3,
        [14] = "●",
        [15] = "%",
        [16] = "prop_vehicle_jeep",
        [17] = 17,
        [18] = "https://steamcommunity.com/profiles/STEAMID_HERE/",
        [19] = "buttons/blip1.wav",
        [20] = "√",
        [21] = "✘",
        [22] = "buttons/button14.wav",
        [23] = "↩"
    },
    ["colors"] = {
        [1] = Color(math.Clamp(WasiedAdminSystem.Config.MainColor.r+20, 0, 255), math.Clamp(WasiedAdminSystem.Config.MainColor.g-30, 0, 255), math.Clamp(WasiedAdminSystem.Config.MainColor.b-30, 0, 255)), -- Hovered Color
        [2] = Color(39, 174, 96),
        [3] = Color(231, 76, 60),
        [4] = Color(255, 0, 0, 90),
        [5] = Color(255, 255, 255, 200),
        [6] = Color(40, 40, 255),
        [7] = Color(20, 20, 20, 245),
        [8] = WasiedAdminSystem.Config.MainColor,
        [9] = Color(255, 255, 255, 10),
        [10] = Color(68, 143, 207),
        [11] = Color(32, 32, 32),
        [12] = Color(24, 24, 24)
    },
    ["materials"] = {
        [1] = Material("icon16/vcard.png"),
        [2] = Material("icon16/user_suit.png"),
        [3] = Material("icon16/money.png"),
        [4] = Material("icon16/heart.png"),
        [5] = Material("icon16/shield.png"),
        [6] = Material("icon16/cup.png"),
        [7] = Material("icon16/key.png")
    }
}

-- Commands constants
WasiedAdminSystem.Constants["cmd"] = {
    ["god"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "god", ply:Nick()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "God", ply:Nick()) end
    },
    ["ungod"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "ungod", ply:Nick()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "UnGod", ply:Nick()) end
    },
    ["cloak"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "cloak", ply:Nick()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "Cloak", ply:Nick()) end
    },
    ["uncloak"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "uncloak", ply:Nick()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "UnCloak", ply:Nick()) end
    },
    ["ban"] = {
        ["ULX"] = function(ply, args) RunConsoleCommand("ulx", "banid", ply:SteamID(), tostring(args.time), args.reason) end,
        ["FADMIN"] = function(ply, args) RunConsoleCommand("_FAdmin", "ban", ply:Nick(), args.time, args.reason) end
    },
    ["kick"] = {
        ["ULX"] = function(ply, args) RunConsoleCommand("ulx", "kick", ply:SteamID(), args.reason) end,
        ["FADMIN"] = function(ply, args) RunConsoleCommand("_FAdmin", "kick", ply:Nick(), args.reason) end
    },
    ["goto"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "goto", "$"..ply:SteamID()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "goto", ply:Nick()) end
    },
    ["teleport"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "teleport", "$"..ply:SteamID()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "teleport", ply:Nick()) end
    },
    ["freeze"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "freeze", "$"..ply:SteamID()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "freeze", ply:Nick()) end
    },
    ["unfreeze"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "unfreeze", "$"..ply:SteamID()) end,
        ["FADMIN"] = function(ply) RunConsoleCommand("_FAdmin", "unfreeze", ply:Nick()) end
    },
    ["return"] = {
        ["ULX"] = function(ply) RunConsoleCommand("ulx", "return", "$"..ply:SteamID()) end
    }
}