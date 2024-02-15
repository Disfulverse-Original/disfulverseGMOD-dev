--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Hits"
HOOK.Description = "Shows whenever someone accepted/failed/completed a hit"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "onHitAccepted"
HOOK.enableCheck = function() return HitModule != nil end

hook.Add("HMHitComplete", HOOK.hook_name .. "completed_hm", function(hitman, target, reward)
	if not IsValid(target) then return end
	if not IsValid(hitman) then return end
	
	local plyName = mLog.getInfoLine(target)
	local hitmanName = mLog.getInfoLine(hitman)
	mLog.Log("onHitAccepted", hitmanName .. " completed a hit on " .. plyName .. " for $" .. (reward or "<unknown>"))
end)
