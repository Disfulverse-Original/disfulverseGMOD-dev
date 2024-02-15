--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Loot Pickups"
HOOK.Description = "Shows whenever someone has picked up loot"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "PlayerPickupLoot"
HOOK.enableCheck = function() return string.lower( gmod.GetGamemode( ).Name ) == "murder" end

hook.Add("PlayerPickupLoot", HOOK.hook_name, function(ply, ent)
	if not IsValid(ply) then return end
	if not IsValid(ent) then return end
	local plyName = mLog.getInfoLine(ply)
	mLog.Log("PlayerPickupLoot", plyName .. " has picked up loot (".. (ply and ply.GetLootCollected and ply:GetLootCollected() or ply.LootCollected or 1)+1 ..")!")
end)