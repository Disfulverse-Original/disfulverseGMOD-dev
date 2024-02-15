--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Door Ram"
HOOK.Description = "Shows whenever someone used a door ram"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "onDoorRamUsed"
HOOK.enableCheck = function() return DarkRP != nil end

hook.Add("onDoorRamUsed", HOOK.hook_name, function(success, ply, trace)
	if not IsValid(ply) then return end
	if not success then return end
	local plyName = mLog.getInfoLine(ply)
	mLog.Log("onDoorRamUsed", plyName .. " has used a door ram on " .. tostring(trace.Entity))
end)