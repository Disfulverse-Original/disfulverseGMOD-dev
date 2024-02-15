--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Wanted"
HOOK.Description = "Shows whenever someone is wanted/unwanted"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "playerWanted"
HOOK.enableCheck = function() return DarkRP != nil end

hook.Add("playerWanted", HOOK.hook_name, function(target,cop, reason)
	if target and type(target) != "entity" then return end
	if cop and type(cop) != "entity" then return end
	if not IsValid(target) then return end
	if not IsValid(cop) then return end

 	local targetS = mLog.getInfoLine(target)
 	local copS = mLog.getInfoLine(cop)
	
	local freason = "no specified reason"
	if reason and type(reason) == "string" and reason != "" then
		freason = reason
	end
	
	mLog.Log("playerWanted", copS .. " wanted " .. targetS .. " for " .. freason)
end)