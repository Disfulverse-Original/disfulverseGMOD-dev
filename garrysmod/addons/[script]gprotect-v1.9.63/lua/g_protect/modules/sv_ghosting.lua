local blacklist, cfg = gProtect.getConfig("blacklist", "general"), gProtect.getConfig(nil, "ghosting")
local welds = {}
local redoWelds = {}

gProtect = gProtect or {}

local function Ghost(ent, nofreeze)
	local physics = ent:GetPhysicsObject()
		
	if IsValid(physics) and !nofreeze and !cfg.enableMotion then
		physics:EnableMotion(false)
	end

	if ent.sppghosted then return end

	ent.SPPData = ent.SPPData or {}
	
	ent.SPPData.color = ent:GetColor() and ent:GetColor() or Color(255,255,255)
	ent.SPPData.collision = ent:GetCollisionGroup() and ent:GetCollisionGroup() or COLLISION_GROUP_NONE
	ent.SPPData.rendermode = ent:GetRenderMode() and ent:GetRenderMode() or RENDERMODE_NORMAL
	ent.SPPData.material = ent:GetMaterial() and ent:GetMaterial() or ""
	
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	ent:SetRenderMode(RENDERGROUP_TRANSLUCENT)
	
	ent:SetColor(cfg.ghostColor)

	
	
	ent.sppghosted = true
end

local function unGhost(ent)
	if !ent.SPPData then return end
	ent:SetRenderMode(ent.SPPData.rendermode and ent.SPPData.rendermode or RENDERMODE_NORMAL)
	ent:SetCollisionGroup(ent.SPPData.collision and ent.SPPData.collision or COLLISION_GROUP_NONE)
	
	if ent.SPPData.color then
		ent:SetColor(ent.SPPData.color)
	end

	ent:SetMaterial(ent.SPPData.material and ent.SPPData.material or "")
	
	ent.SPPData = nil	
	ent.sppghosted = false
end

gProtect.GhostHandler = function(ent, todo, nofreeze, closedloop, ignore)
	if !cfg.enabled or !IsValid(ent) then return end
	
	if !ignore and ((cfg.useBlacklist and !blacklist[ent:GetClass()]) and !cfg.entities[ent:GetClass()]) then return end

	if cfg.antiObscuring and !todo then
		local colliders = gProtect.obscureDetection(ent)
		
		for k, v in pairs(colliders) do
			if v == ent then continue end
			if cfg.antiObscuring[v:GetClass()] then todo = true break end
		end
	end

	if todo then
		Ghost(ent, nofreeze)
	else
		unGhost(ent)
	end

	if !closedloop then
		local constraintedEnts = constraint.GetAllConstrainedEntities(ent)
		if constraintedEnts then
			local action = !!todo
			local stopIt = false

			if !action then
				for k, v in pairs(constraintedEnts) do
					if v.BeingPhysgunned and !table.IsEmpty(v.BeingPhysgunned) then
						stopIt = true
					end
				end
			end

			if !stopIt then
				for k, v in pairs(constraintedEnts) do
					if v == ent then continue end
					local physobj = v:GetPhysicsObject()
					if IsValid(physobj) and !physobj:IsMotionEnabled() then
						continue
					end
					local physobj = v:GetPhysicsObject()
					physobj:EnableMotion(false)
					gProtect.GhostHandler(v, action, true, true)

					physobj:EnableMotion(true)
				end
			end
		end
	end

	return ent.sppghosted
end

hook.Add("OnPhysgunPickup", "gP:GhostPhysgun", function(ply, ent)
	if cfg.onPhysgun and IsValid(ent) and ((blacklist[ent:GetClass()] and cfg.useBlacklist) or cfg.entities[ent:GetClass()]) then
		gProtect.GhostHandler(ent, true)
	end
end)

hook.Add("PhysgunDropped", "gP:UnGhostPhysgunDrop", function(ply, ent, obstructed)
	if obstructed then return end

	if IsValid(ent) then
		ent.BeingPhysgunned = ent.BeingPhysgunned or {}
		if ent.sppghosted and table.IsEmpty(ent.BeingPhysgunned) then
			local result = gProtect.GhostHandler(ent, false)

			if result then slib.notify(gProtect.config.Prefix..slib.getLang("gprotect", gProtect.config.SelectedLanguage, "entity-ghosted"), ply) end
		end
	end
end)

hook.Add("OnTool", "gP:GhostPhysgunHandle", function(ply, tr)
	local ent = tr.Entity
	if !cfg.enabled or !IsValid(ent) then return end

	gProtect.GhostHandler(ent, false)
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateGhosting", function(updated)
	if updated ~= "ghosting" and updated ~= "general" then return end
	cfg = gProtect.getConfig(nil, "ghosting")
	blacklist = gProtect.getConfig("blacklist", "general")
end)


hook.Add("PhysgunDrop", "gP:GhostingGhostUnfrozen", function(ply, ent)
	if cfg.enabled and cfg.forceUnfrozen and IsValid(ent) and cfg.forceUnfrozenEntities[ent:GetClass()] then
		if !IsValid(ent) then return end
		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then
			if phys:IsMotionEnabled() then
				gProtect.GhostHandler(ent, true)
			end
		end
	end
end)

hook.Add("OnEntityCreated", "gP:GhostingHandeler", function(ent)
	timer.Simple(.05, function()
		if !IsValid(ent) then return end
		
		local phys = ent:GetPhysicsObject()

		if cfg.enabled and cfg.forceUnfrozen and cfg.forceUnfrozenEntities[ent:GetClass()] and IsValid(phys) and phys:IsMotionEnabled() then
			gProtect.GhostHandler(ent, true)
		end
	end)
end)