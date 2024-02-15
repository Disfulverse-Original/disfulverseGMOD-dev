--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Lockpicks"
HOOK.Description = "Shows whenever someone started/completed/failed a lockpick"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "lockpickStarted"
HOOK.enableCheck = function() return DarkRP != nil end

hook.Add("onLockpickCompleted", HOOK.hook_name .. "complete", function(ply, success, ent)
	if not IsValid(ply) then return end
	if not IsValid(ent) then return end
	
	local plyName = mLog.getInfoLine(ply)
	local failed = "failed"
	if success then failed = "completed" end
	mLog.Log("lockpickStarted", plyName .. " has ".. failed .." lockpicking " .. tostring(ent))
end)