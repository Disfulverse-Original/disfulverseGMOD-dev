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

hook.Add("playerUnWanted", HOOK.hook_name .. "un", function(target,cop)
	if not IsValid(target) then return end

	local targetS = mLog.getInfoLine(target)
	local copS = mLog.getInfoLine(cop)
	
	if IsValid(cop) then
		mLog.Log("playerUnWanted", copS .. " made " .. targetS .. " no longer wanted")
	else
		mLog.Log("playerUnWanted", targetS .. " is no longer wanted")
	end
end)