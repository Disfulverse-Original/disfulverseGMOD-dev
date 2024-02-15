--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Demotions"
HOOK.Description = "Shows when someone is demoted"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "onPlayerDemoted"
HOOK.enableCheck = function() return DarkRP != nil end

hook.Add("onPlayerDemoted", HOOK.hook_name, function(ply, target, reason)
	if not IsValid(target) then return end
	
	local targetS = mLog.getInfoLine(target)
	
	if IsValid(ply) then
		local plyS = mLog.getInfoLine(ply)
		mLog.Log("onPlayerDemoted", plyS .. " has demoted " .. targetS .." for " .. reason)
	else
		mLog.Log("onPlayerDemoted", targetS ..  " has been demoted for " .. reason)
	end
end)