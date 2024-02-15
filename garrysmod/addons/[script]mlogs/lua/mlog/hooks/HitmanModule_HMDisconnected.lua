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

hook.Add("HMDisconnected", HOOK.hook_name .. "disconnect_hm", function(hitman, ply)
	if not IsValid(hitman) then return end
	if not IsValid(ply) then return end
	
	local plyName = mLog.getInfoLine(ply)
	local hitmanName = mLog.getInfoLine(hitman)
	
	local reason = "The requester/target has left the server"
	if ply == hitman then
		reason = "The hitman has left the server"
	end
	
	mLog.Log("onHitAccepted", hitmanName .. " failed a hit involving " .. plyName .. " because: " .. reason)
end)
