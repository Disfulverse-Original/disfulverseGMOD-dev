--[[
	mLogs (M4D Logs)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead | legal@m4d.one
	Copyright © 2016 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

HOOK.Name = "Damage"
HOOK.Description = "The damage logs of all players"
HOOK.hook_name = mLog.prefix .. HOOK.Name
HOOK.hook_tag = "EntityTakeDamage"

hook.Add("EntityTakeDamage", HOOK.hook_name, function(ply, dmg)
	if not IsValid(ply) then return end
	if not dmg then return end
	if not ply:IsPlayer() then return end
	
	local victim = mLog.getInfoLine(ply)
	local attacker = "<something>"
	local weapon = "<something>"
	if IsValid(dmg:GetAttacker()) then
		if dmg:GetAttacker():IsPlayer() then
			attacker = mLog.getInfoLine(dmg:GetAttacker())
		elseif dmg:GetAttacker():GetClass() == "prop_physics" then
			attacker = mLog.getInfoLine(dmg:GetAttacker())
			weapon = dmg:GetAttacker():GetClass().."("..dmg:GetAttacker():GetModel()..")"
		elseif dmg:GetAttacker():IsVehicle() and IsValid(dmg:GetAttacker():GetDriver()) then
			attacker = mLog.getInfoLine(dmg:GetAttacker():GetDriver())
			weapon = dmg:GetAttacker():GetClass()
		else
			attacker = dmg:GetAttacker():GetClass()
		end
	end
	
	if IsValid(dmg:GetInflictor()) and dmg:GetInflictor():IsPlayer() then
		weapon = dmg:GetInflictor():GetActiveWeapon():GetClass() or dmg:GetInflictor().dying_wep or "a weapon"
	end
	
	local totalDmg = math.Round(dmg:GetDamage())
	if (ply:Health() - totalDmg) <= 0 then return end
	
	if not weapon or weapon == "ERROR_WEAPON" then
		if dmg:GetAttacker():IsWeapon() or dmg:GetInflictor().Projectile then
			weapon = dmg:GetAttacker():GetClass()
		end

		if dmg:GetInflictor():IsWeapon() or dmg:GetInflictor().Projectile then
			weapon = dmg:GetInflictor():GetClass()
		end
	end
	
	if not weapon or weapon == "ERROR_WEAPON" then
		weapon = tostring(dmg:GetInflictor())
	end
	
	if dmg:IsFallDamage() then
		weapon = "<unknown>/fall_damage"
		attacker = "worldspawn"
	end
	
	
	if table.HasValue(mLog.blacklist.damage or {}, weapon) then return end
	
	mLog.Log("EntityTakeDamage", attacker .. " hurt " .. victim .. " using " .. weapon .. " for " .. totalDmg .. " damage")
	
end)