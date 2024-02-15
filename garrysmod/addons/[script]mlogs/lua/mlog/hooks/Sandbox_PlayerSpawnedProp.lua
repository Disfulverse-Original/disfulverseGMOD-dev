--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Prop Spawn"
HOOK.Description = "Shows when someone spawns a prop"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "PlayerSpawnedProp"
HOOK.enableCheck = function() return GAMEMODE.IsSandboxDerived end

hook.Add("PlayerSpawnedProp", HOOK.hook_name, function(ply, model, ent)
	if not IsValid(ply) then return end
	if table.HasValue(mLog.blacklist.prop or {}, weapon) then return end
	local plS = mLog.getInfoLine(ply)

	mLog.Log("PlayerSpawnedProp", plS .. " spawned a prop: " .. model)
end)