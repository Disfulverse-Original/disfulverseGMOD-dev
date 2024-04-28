--[[--------------------------]]--
--[[-- GLOBAL CONFIGURATION --]]--
--[[--------------------------]]--

-- Script language (availables : "english", "french")
WasiedAdminSystem.Config.ScriptLanguage = "russian"

-- Community name
WasiedAdminSystem.Config.ServerName = ""

-- Do the addon have to hide the staff commands in the chat ?
WasiedAdminSystem.Config.HideCommands = true

-- Do staff actions have to be logged in the high-rank chat?
WasiedAdminSystem.Config.ShowStaffActions = true

-- Main color of the script
WasiedAdminSystem.Config.MainColor = Color(100,152,219)

-- Ranks allowed to use the system
WasiedAdminSystem.Config.RanksAllowed = {
    ["superadmin"] = true,
    ["admin"] = true,
}

-- High-ranks allowed to use high-level features
WasiedAdminSystem.Config.HighRanks = {
    ["superadmin"] = true,
    ["admin"] = true,
}


--[[------------------------------]]--
--[[-- ADMIN MENU CONFIGURATION --]]--
--[[------------------------------]]--

-- Do this menu have to be enabled ?
WasiedAdminSystem.Config.AdminMenuEnabled = true

-- Command to open the admin menu
WasiedAdminSystem.Config.AdminMenuCommand = "!amenu"

-- Command used by YOUR logging system (to open it by the admin menu) -> blank to remove
WasiedAdminSystem.Config.LogsCommand = "/logs"

-- Command used by YOUR warnings system (to open it by the admin menu) -> blank to remove
WasiedAdminSystem.Config.WarnsCommand = "!warns"


--[[--------------------------------]]--
--[[-- ADMIN SYSTEM CONFIGURATION --]]--
--[[--------------------------------]]--

-- Do this module have to be enabled ?
-- If disabled -> only the HUD informations stay enabled on entering the command below
WasiedAdminSystem.Config.AdminSystemEnabled = true

-- Command to enable/disable admin system
WasiedAdminSystem.Config.AdminModeCommand = "!staff"

-- Do the system have to enable admin mode to staffs who enables noclip ?
WasiedAdminSystem.Config.AdminOnNoclip = true

-- Do the system have to use ULX or FAdmin commands ?
WasiedAdminSystem.Config.ULXorFAdmin = "ULX"


--[[------------------------------------]]--
--[[-- HUD INFORMATIONS CONFIGURATION --]]--
--[[------------------------------------]]--

-- Does the staff have to see the basic informations on admin mode ? (http://prntscr.com/obuwdl)
WasiedAdminSystem.Config.ShowBasicsInfos = true

-- Does the staff have to see the advanced informations on admin mode ? (http://prntscr.com/obuwa8)
-- (/!\ false = theses informations will be shown only when the admin open his context menu)
WasiedAdminSystem.Config.ShowExtraInfos = false

-- Do the staff have to see informations based on all the vehicles of the server ?
WasiedAdminSystem.Config.ShowVehiclesInfos = true

-- How far away from the staff does the player's basic informations disappear ?
WasiedAdminSystem.Config.DistToShow = 3000

-- How far away from the staff does the player's advanced informations disappear ?
WasiedAdminSystem.Config.DistToShowExtra = 1500

-- Do the addon have to disable the default context menu ?
WasiedAdminSystem.Config.DisableContextMenu = false

--[[---------------------------]]--
--[[-- TICKETS CONFIGURATION --]]--
--[[---------------------------]]--

-- Do this module have to be enabled ?
WasiedAdminSystem.Config.TicketEnabled = true

-- Command to send to open the ticket menu
WasiedAdminSystem.Config.TicketMenuCommand = "!ticket"

-- The countdown the player has to wait between 2 tickets 
WasiedAdminSystem.Config.TicketTimer = 10

-- The maximum number of players that we can select for a ticket (/!\ 3 maximum)
WasiedAdminSystem.Config.TicketMaxPlayers = 3

-- The maximum number of characters allowed to send a ticket
WasiedAdminSystem.Config.MinDescriptionLen = 5

-- Pre-defined reasons for a ticket
WasiedAdminSystem.Config.TicketsReasons = {
    "Другое"
}

-- The time in seconds after which the ticket is automatically deleted if it has not been processed.
WasiedAdminSystem.Config.DeleteTicketTime = 60*10 -- 60*10 = 10 minutes

-- Do tickets appear on the staff screens even when they are not in admin mode ?
WasiedAdminSystem.Config.TicketOnlyAdmin = true

-- Should the /// and @ command be replaced by this ticket menu ? (need restart)
WasiedAdminSystem.Config.DefaultCommandReplaced = true


--[[------------------------------------------]]--
--[[-- PLAYER MANAGEMENT MENU CONFIGURATION --]]--
--[[------------------------------------------]]--

-- Do this module have to be enabled ?
WasiedAdminSystem.Config.PlayerManagmentEnabled = false

-- Command to send to open the player management menu
WasiedAdminSystem.Config.PlayerManagMenuCommand = "!pmenu"

-- Maximum numbers of characters for a punishment reason
WasiedAdminSystem.Config.PlayerManagMaxLen = 100

-- Developers -> You can edit menu commands in client/cl_player_management.lua


--[[-------------------------------]]--
--[[-- REFUND MENU CONFIGURATION --]]--
--[[-------------------------------]]--

-- Do this module have to be enabled ?
WasiedAdminSystem.Config.RefundMenuEnabled = false

-- Command to send to open refund menu
WasiedAdminSystem.Config.RefundMenuCommand = "!rmenu"

-- Does the system have to save weapons at death ?
WasiedAdminSystem.Config.RefundWeapons = true

-- Does the system have to save money at death ?
WasiedAdminSystem.Config.RefundMoney = true

-- Does the system have to save playermodel at death ?
WasiedAdminSystem.Config.RefundPM = true

-- Does the system have to save job at death ?
WasiedAdminSystem.Config.RefundJob = true

--[[
Thank you for buying my script! Feel free to give your opinion on mTx (unless you leaked it. Then I hope it's good anyway :D)
Wasied.
]]--