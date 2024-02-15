--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Arrests"
HOOK.Description = "Arrest Logs"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "playerArrested"
HOOK.enableCheck = function() return DarkRP != nil end

hook.Add("playerArrested", HOOK.hook_name, function(ply, time, arrester)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end
	
	local victim = mLog.getInfoLine(ply)
	local arrester = mLog.getInfoLine(arrester)

	mLog.Log("playerArrested", arrester .. " arrested " .. victim)
end)