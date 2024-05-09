-- Draw informations
local contextIsOpen = WasiedAdminSystem.Config.ShowExtraInfos

hook.Add("HUDPaint", "Wasied:AdminSystem:HUDPaint", function()
	local ply = LocalPlayer()
    if ply:GetNWInt(WasiedAdminSystem.Constants["strings"][12]) < 1 then return end

	if WasiedAdminSystem.Config.AdminSystemEnabled then

		draw.SimpleTextOutlined((WasiedAdminSystem.Config.HighRanks[LocalPlayer():GetUserGroup()] and WasiedAdminSystem:Lang(75) or WasiedAdminSystem:Lang(91)), WasiedAdminSystem:Font(50), ScrW()/2, WasiedAdminSystem:RespY(5) + 38, Color(52,152,219), 1, 3, 1, color_black)
		
		if WasiedAdminSystem:ULXorFAdmin() then
			draw.SimpleTextOutlined(WasiedAdminSystem:Lang(14), WasiedAdminSystem:Font(35), ScrW()/2, WasiedAdminSystem:RespY(50) + 35, Color(52,152,219), 1, 3, 1, color_black) -- can't get godmode on client w/ ulx :(
		else
			draw.SimpleTextOutlined(WasiedAdminSystem:Lang(14), WasiedAdminSystem:Font(35), ScrW()/2, WasiedAdminSystem:RespY(50) + 35, (ply:FAdmin_GetGlobal("FAdmin_godded") and Color(52,152,219) or WasiedAdminSystem.Constants["colors"][3]), 1, 3, 1, color_black)
		end
		
		draw.SimpleTextOutlined(WasiedAdminSystem:Lang(15), WasiedAdminSystem:Font(35), ScrW()/2-WasiedAdminSystem:RespX(100), WasiedAdminSystem:RespY(50) + 35, (ply:GetMoveType() == MOVETYPE_NOCLIP and Color(52,152,219) or WasiedAdminSystem.Constants["colors"][3]), 1, 3, 1, color_black)
		draw.SimpleTextOutlined(WasiedAdminSystem:Lang(16), WasiedAdminSystem:Font(35), ScrW()/2+WasiedAdminSystem:RespX(100), WasiedAdminSystem:RespY(50) + 35, ((ply:GetNoDraw() or ply:GetRenderMode() == RENDERMODE_TRANSALPHA) and Color(52,152,219) or WasiedAdminSystem.Constants["colors"][3]), 1, 3, 1, color_black)
	
		draw.RoundedBox(4, ScrW()/2 - WasiedAdminSystem:RespX(37.5) + math.sin(CurTime()*.5)*100, WasiedAdminSystem:RespY(90) + 35, WasiedAdminSystem:RespX(75) + math.cos(CurTime()*1.5)*30, WasiedAdminSystem:RespY(8), Color(52,152,219), 1)
	end

	-- Show basic infos
	if WasiedAdminSystem.Config.ShowBasicsInfos then

		for _,victim in pairs(player.GetAll()) do

			if not IsValid(victim) then continue end
			if victim == ply then continue end
			
			-- Hide admins to low-staff
			if not WasiedAdminSystem.Config.HighRanks[ply:GetUserGroup()] then
				if WasiedAdminSystem.Config.HighRanks[victim:GetUserGroup()] then continue end
			end

			local pos = victim:GetShootPos()
			if ply:GetPos():DistToSqr(pos) > WasiedAdminSystem.Config.DistToShow^2 then continue end

			pos.z = pos.z + 15
			pos = pos:ToScreen()
			if not pos.visible then continue end
			local x, y = pos.x+10, pos.y

			draw.SimpleTextOutlined(WasiedAdminSystem.Constants["strings"][14], WasiedAdminSystem:Font(22), x-10, y-20, team.GetColor(victim:Team()), 1, 1, 1, color_black)

			local plyNick = victim:Nick()
			local plyNickLen = string.len(plyNick)

			-- Name
			surface.SetDrawColor(Color(0, 0, 0, 65))
			surface.DrawRect(x-62, y-71, 50+plyNickLen*8, 20)

			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(WasiedAdminSystem.Constants["materials"][1])
			surface.DrawTexturedRect(x-60, y-69, 16, 16)

			draw.SimpleTextOutlined(plyNick, WasiedAdminSystem:Font(20), x-35, y-72, color_white, 0, 3, 1, color_black)

			-- Job
			local jobColor = team.GetColor(victim:Team())
			local jobName = team.GetName(victim:Team())
			local jobLen = string.len(jobName)

			surface.SetDrawColor(Color(0, 0, 0, 65))--surface.SetDrawColor(jobColor) 
			surface.DrawRect(x-62, y-50, 50+jobLen*8, 20)

			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(WasiedAdminSystem.Constants["materials"][2])
			surface.DrawTexturedRect(x-60, y-48, 16, 16)

			draw.SimpleTextOutlined(jobName, WasiedAdminSystem:Font(20), x-35, y-50, WasiedAdminSystem.Constants["colors"][5], 0, 3, 1, color_black)

			if --[[contextIsOpen &&]] ply:GetPos():DistToSqr(victim:GetShootPos()) < WasiedAdminSystem.Config.DistToShowExtra^2 then

				-- Money
				local money = victim:getDarkRPVar("money") or 0
				local moneyString = string.len(tostring(money))

				surface.SetDrawColor(Color(0, 0, 0, 65))
				surface.DrawRect(x-62, y-92, 58+moneyString*8, 20)

				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(WasiedAdminSystem.Constants["materials"][3])
				surface.DrawTexturedRect(x-60, y-90, 16, 16)

				draw.SimpleTextOutlined(money..WasiedAdminSystem:Lang(17), WasiedAdminSystem:Font(20), x-35, y-93, color_white, 0, 3, 1, color_black)

				-- Health
				local plyHealth = math.Clamp(victim:Health(), 0, 100)
				local plyHealthLen = string.len(tostring(plyHealth))

				surface.SetDrawColor(Color(0, 0, 0, 65))
				surface.DrawRect(x-62, y-114, 58+plyHealthLen*8, 20)

				surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][3])
				surface.SetMaterial(WasiedAdminSystem.Constants["materials"][4])
				surface.DrawTexturedRect(x-60, y-112, 16, 16)

				draw.SimpleTextOutlined(victim:Health()..WasiedAdminSystem.Constants["strings"][15], WasiedAdminSystem:Font(20), x-35, y-114, WasiedAdminSystem.Constants["colors"][5], 0, 3, 1, color_black)

				-- Armor
				local plyArmor = math.Clamp(victim:Armor(), 0, 100)
				local plyArmorLen = string.len(tostring(plyArmor))

				surface.SetDrawColor(Color(0, 0, 0, 65))
				surface.DrawRect(x-62, y-136, 58+plyArmorLen*8, 20)
				
				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(WasiedAdminSystem.Constants["materials"][5])
				surface.DrawTexturedRect(x-60, y-134, 16, 16)

				draw.SimpleTextOutlined(victim:Armor()..WasiedAdminSystem.Constants["strings"][15], WasiedAdminSystem:Font(20), x-35, y-136, WasiedAdminSystem.Constants["colors"][5], 0, 3, 1, color_black)

				--[[-- Hunger
				local plyHunger = math.Round(victim:getDarkRPVar("Energy") or 0)
				local plyHungerLen = string.len(tostring(plyHunger))

				surface.SetDrawColor(Color(255, 110, 0, 90))
				surface.DrawRect(x-62, y-158, 58+plyHungerLen*8, 20)
				
				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(WasiedAdminSystem.Constants["materials"][6])
				surface.DrawTexturedRect(x-60, y-156, 16, 16)

				draw.SimpleTextOutlined(plyHunger..WasiedAdminSystem.Constants["strings"][15], WasiedAdminSystem:Font(20), x-35, y-158, color_white, 0, 3, 1, color_black)]]
				-- Rank
				local plyRank = victim:GetUserGroup()
				local plyRankLen = string.len(plyRank)

				surface.SetDrawColor(Color(0, 0, 0, 65))
				surface.DrawRect(x-62, y-158, 58+plyRankLen*8, 20)

				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(WasiedAdminSystem.Constants["materials"][7])
				surface.DrawTexturedRect(x-60, y-156, 16, 16)

				draw.SimpleTextOutlined(plyRank, WasiedAdminSystem:Font(20), x-35, y-159, color_white, 0, 3, 1, color_black)

			end
		end
	end

	if WasiedAdminSystem.Config.ShowVehiclesInfos then
		for _,veh in pairs(ents.FindByClass(WasiedAdminSystem.Constants["strings"][16])) do
			if not veh:IsVehicle() then continue end

			local pos = veh:GetPos()
			if ply:GetPos():DistToSqr(pos) > WasiedAdminSystem.Config.DistToShow^2 then continue end
			
			pos.z = pos.z + 75
			pos = pos:ToScreen()
			if not pos.visible then continue end
			local x, y = pos.x, pos.y

			local vName = veh:GetVehicleClass()
			if VC and isstring(veh:VC_getName()) then 
				vName = veh:VC_getName()
			end

			draw.SimpleTextOutlined(WasiedAdminSystem.Constants["strings"][14], WasiedAdminSystem:Font(22), x-10, y-20, WasiedAdminSystem.Constants["colors"][6], 1, 1, 1, color_black)
			draw.SimpleTextOutlined(vName, WasiedAdminSystem:Font(20), x-15, y-40, color_white, 1, 1, 1, color_black)

		end
	end

end)

hook.Add("OnContextMenuOpen", "Wasied:AdminSystem:OpenContext", function()
	if not WasiedAdminSystem.Config.ShowExtraInfos then contextIsOpen = true end
	-- return (not WasiedAdminSystem.Config.DisableContextMenu)
end)

hook.Add("OnContextMenuClose", "Wasied:AdminSystem:CloseContext", function()
	if not WasiedAdminSystem.Config.ShowExtraInfos then contextIsOpen = false end
end)