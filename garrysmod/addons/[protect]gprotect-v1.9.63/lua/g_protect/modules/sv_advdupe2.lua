local cfg = gProtect.getConfig(nil, "advdupe2")

gProtect = gProtect or {}

local function isReasonableAngle(val)
	if !isnumber(val) or math.abs(val) > 360 then return false end

	return true
end

local function isReasonableVector(val)
	if !isnumber(val) or math.abs(val) > 32000 then return false end

	return true
end

local function isValidAngle(ang)
	if !isReasonableAngle(ang.x) or !isReasonableAngle(ang.y) or !isReasonableAngle(ang.z) then return false end

	return true
end

local function isValidVector(pos)
	if !isReasonableVector(pos.x) or !isReasonableVector(pos.y) or !isReasonableVector(pos.z) then return false end

	return true
end

gProtect.HandleAdvDupe2ToolGun = function(ply, tr, tool)
	if cfg.enabled then
		if tool == "advdupe2" and ply.AdvDupe2 then
			if cfg.PreventUnfreezeAll then
				local toolgun = ply:GetTool(tool)
				if tobool(toolgun:GetClientInfo("paste_unfreeze")) then
				if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-unfreeze-all", 3) end
				return false end
			end

			if cfg.PreventScaling > 0 or cfg.PreventNoGravity > 0 then
				if cfg.PreventUnreasonableValues and ply.AdvDupe2.HeadEnt then
					if ply.AdvDupe2.HeadEnt.Pos then
						if !isValidVector(ply.AdvDupe2.HeadEnt.Pos) then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-advdupe-out-of-bounds", 3) end return false end
					end
				end

				if ply.AdvDupe2.Entities then
					for k, v in pairs(ply.AdvDupe2.Entities) do
						if cfg.PreventUnreasonableValues and v.PhysicsObjects then
							for k, ent in pairs(v.PhysicsObjects) do
								if !isValidVector(ent.Pos) then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-advdupe-out-of-bounds", 3) end return false end
								if !isValidAngle(ent.Angle) then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-advdupe-weird-angles", 3) end return false end
							end
						end

						if v.ModelScale then
							if cfg.PreventScaling == 1 then
								if v.ModelScale != 1 then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-upscaled-ent", 3) end return false end
							end
							
							if cfg.PreventScaling == 2 then
								if v.ModelScale != 1 then if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-upscaled-ent", 3) end ply.AdvDupe2.Entities[k].ModelScale = 1 end
							end
						end

						if istable(v.BoneMods) then
							for i, z in pairs(v.BoneMods) do
								if z.physprops and !z.physprops.GravityToggle then 
									if cfg.PreventNoGravity == 1 then
										if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-no-gravity", 3) end return false
									end

									if cfg.PreventNoGravity == 2 then
										ply.AdvDupe2.Entities[k].BoneMods[i].physprops.GravityToggle = true
										if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-no-gravity", 3) end
									end	
								end
							end
						end

						if v.EntityMods and v.EntityMods.trail then
							if cfg.PreventTrail == 1 then
								if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-trail", 3) end return false
							end

							if cfg.PreventTrail == 2 then
								ply.AdvDupe2.Entities[k].EntityMods.trail = nil
								if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-trail", 3) end
							end	
						end

						if v.CollisionGroup then
							if cfg.BlacklistedCollisionGroups[v.CollisionGroup] then
								ply.AdvDupe2.Entities[k].CollisionGroup = 0
							end
						end
					end
				end
			end
			
			if ply.AdvDupe2.Constraints and cfg.PreventRopes > 0 then
				if istable(ply.AdvDupe2.Constraints) then					
					for k, v in pairs(ply.AdvDupe2.Constraints) do
						if !v.Type then continue end

						if !cfg.WhitelistedConstraints[string.lower(v.Type)] then
							ply.AdvDupe2.Constraints[k] = nil
						end

						if string.lower(v.Type) == "rope" then
							if cfg.PreventRopes == 1 then
								if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-rope-spawning", 3) end
								return false
							end
							if cfg.PreventRopes == 2 then
								ply.AdvDupe2.Constraints[k] = nil 
								if cfg.notifyStaff then gProtect.NotifyStaff(ply, "attempted-rope-spawning", 3) end
							end
						end
					end
				end
			end
		end
	end

	return true
end

gProtect.IsWhitelistedAdvDupe2 = function(_, className)
	local curStack = debug.getinfo(4)
	local src = curStack.source

	if string.sub(src, #src - 24) != "advdupe2/sv_clipboard.lua" or curStack.name != "CreateEntityFromTable" then return end
	if !cfg.whitelistedClasses[className] then return end

	return true
end

hook.Add("AdvDupe_FinishPasting", "gP:handlePasted", function(info, info2, c, d, e)
	if cfg.DelayBetweenUse then
		local time = cfg.DelayBetweenUse or 0

		if time <= 0 then return end

		local ply = info[1].Player
		if !IsValid(ply) or !ply.AdvDupe2 then return end

		ply.AdvDupe2.Downloading = true 

		timer.Simple(time, function() if !IsValid(ply) then return end ply.AdvDupe2.Downloading = false end)
	end
end)

hook.Add("gP:ConfigUpdated", "gP:UpdateAdvDupe2", function(updated)
	if updated ~= "advdupe2" then return end
	cfg = gProtect.getConfig(nil, "advdupe2")
end)