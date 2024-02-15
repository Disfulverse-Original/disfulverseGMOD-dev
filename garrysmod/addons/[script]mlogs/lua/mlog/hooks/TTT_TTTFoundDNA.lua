--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "DNA"
HOOK.Description = "Shows when someone has found the DNA of someone"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "TTTFoundDNA"
HOOK.enableCheck = function() return string.lower( gmod.GetGamemode( ).Name ) == "trouble in terrorist town" end

hook.Add("TTTFoundDNA", HOOK.hook_name, function(ply, deadply, rag)
	if not IsValid(ply) then return end
	local plS = mLog.getInfoLine(ply)
	
	if IsValid(deadply) then
		local dS = mLog.getInfoLine(deadply)
		mLog.Log("TTTBodyFound", plS .. " has found " .. dS .. "'s DNA")
	else
		mLog.Log("TTTBodyFound", plS .. " has found someone's DNA")
	end
end)