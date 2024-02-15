--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

function mLog.canPlayerMenu(ply)
	for k,v in pairs(mLog.config.permissions.view) do
		if ply:GetUserGroup() == v or ply:SteamID() == v or ply:SteamID64() == v then
			return true
		end
	end
	return false
end
function mLog.canPlayerEditMenu(ply)
	if not mLog.canPlayerMenu(ply) then return false end
	for k,v in pairs(mLog.config.permissions.edit) do
		if ply:GetUserGroup() == v or ply:SteamID() == v or ply:SteamID64() == v then
			return true
		end
	end
	return false
end
