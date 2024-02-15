--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

// For help visit: http://tracker.m4d.one/help/#configuration

mLog.config = mLog.config or {}
mLog.config.permissions = {}

// Server Settings
mLog.config.provider = "flatfile" // This can be either mysql, flatfile or mtracker | MAKE SURE TO GO INTO THE mlogs/lua/mlog/providers and edit the values inside the file with your credentials!

// Optimization
mLog.config.cluster_push = 5 // How long before each log save, recommended: 5 seconds (default), do not set this to 0 or negative numbers.
mLog.config.logClientside = true // Should clients receive a local copy on their computer? true = yes, false = no | Set to false if clients are getting lag.

// Permissions
mLog.config.permissions.view = {"superadmin", "admin", "owner", "moderator", "d-admin", "d-moder", "OWNER"} // Who can see the menu via the command? These can be usergroups or SteamIDs or SteamID64
mLog.config.permissions.edit = {"superadmin", "owner", "founder"} // Who can edit mLog permissions (all permissions are edited via the menu) | NOTE: THEY MUST BE ABLE TO VIEW THE MENU TO EDIT PERMISSIONS!
mLog.config.permissions.checkOnJoin = true // Adds people to the log list to receive client logs (to be saved to their computer) | If true then it will store a list when they join/leave.
//											  If false it will check who can receive logs on EVERY LOG (can cause lag)

// Logging Information
mLog.config.logUsergroup = true // Should we log their usergroup as well? e.g. superadmin, admin, user
mLog.config.logTeam = true // Should we log their team their in? (This counts as jobs in DarkRP) e.g. Traitor, Citizen

// Data Fetching
mLog.config.logsPerPage = 20 // How much data should we fetch?

// Commands
mLog.config.chatCommand = "/logs"
mLog.config.consoleCommand = "mlog_menu"

// IP Connection
mLog.config.logIPOnConnect = false // Should we log their IP on Connect? NOTE: All people able to see Connection logs can see people's IPs if enabled!
mLog.config.logCountryOnConnect = true // Should we log their country on Connect? NOTE: This will use a third party site below
mLog.config.logCountryWebsite = "http://ip-api.com/json/%s" // The site used to find their location, only change if you know what you're doing | Only used if logCountryOnConnect is enabled

// Do not edit below this line
hook.Call("mLog_ConfigLoaded")
if not mLog.config then
	mLog.Print("Error! The config is invalid!")
	return
end

if file.Exists(mLog.root .. "/providers/" .. mLog.config.provider .. ".lua", "LUA") then
	include(mLog.root .. "/providers/" .. mLog.config.provider .. ".lua")
else
	mLog.Print("Invalid Provider!")
end

mLog.Print("Loaded Config Successfully!")