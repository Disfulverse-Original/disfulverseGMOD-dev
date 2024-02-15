--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Disconnects"
HOOK.Description = "The disconnect logs of all players"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "PlayerDisconnected"

hook.Add("PlayerDisconnected", HOOK.hook_name, function(ply)
	if not IsValid(ply) then return end
	local info = mLog.getInfoLine(ply)
	mLog.Log("PlayerDisconnected", info .. " has disconnected")
end)