-- Send to admins
net.Receive("AdminSystem:Tickets:SendToAdmins", function()

	--[[ VARIABLES ]]--
	local drawTicket = net.ReadBool()
	if drawTicket then

		local tbl = net.ReadTable()
		local sender, plys, subject, description = tbl.sender, tbl.plys, tbl.subject, tbl.description
		local TicketSideColor = WasiedAdminSystem.Constants["colors"][3]
		if not IsValid(sender) then return end
		local plyNick = sender:Nick()
		local plysname = {}

		-- If multiple players reported
		if istable(plys) and #plys > 0 then
			for k,v in pairs(plys) do
				table.insert(plysname, v:Nick())
			end
		end
	
		surface.PlaySound(WasiedAdminSystem.Constants["strings"][19])
		if IsValid(sender.ticketPanel) then sender.ticketPanel:Remove() end

		-- Create a panel for a player
		sender.ticketPanel = vgui.Create("DPanel")
		sender.ticketPanel:Dock(TOP)
		sender.ticketPanel:DockMargin(WasiedAdminSystem:RespX(5), WasiedAdminSystem:RespY(5), WasiedAdminSystem:RespX(1520), WasiedAdminSystem:RespY(10))
		sender.ticketPanel:SetTall(WasiedAdminSystem:RespY(155))
		sender.ticketPanel.time = CurTime() + 1
		sender.ticketPanel.expire = WasiedAdminSystem.Config.DeleteTicketTime
		sender.ticketPanel.block = false
		sender.ticketPanel.isTaken = false
		sender.ticketPanel.TicketOwner = "N/A"
		sender.ticketPanel.Paint = function(self, w, h)
			if not IsValid(sender) then self:Remove() return end

			draw.RoundedBox(5, 0, 0, w, h, WasiedAdminSystem.Constants["colors"][7])
			if self.isTaken then
				draw.RoundedBoxEx(2, 0, 0, w, WasiedAdminSystem:RespY(3), WasiedAdminSystem.Constants["colors"][2], true, true, false, false)
				draw.RoundedBoxEx(2, 0, h-WasiedAdminSystem:RespY(3), w, WasiedAdminSystem:RespY(3), WasiedAdminSystem.Constants["colors"][2], true, true, false, false)
				draw.SimpleText(WasiedAdminSystem:Lang(59).." "..self.TicketOwner, WasiedAdminSystem:Font(15), w-WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(10), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			else
				draw.RoundedBoxEx(2, 0, 0, w, WasiedAdminSystem:RespY(3), WasiedAdminSystem.Constants["colors"][3], true, true, false, false)
				draw.RoundedBoxEx(2, 0, h-WasiedAdminSystem:RespY(3), w, WasiedAdminSystem:RespY(3), WasiedAdminSystem.Constants["colors"][3], true, true, false, false)
			end

			draw.SimpleText(sender:Nick(), WasiedAdminSystem:Font(25), WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(subject, WasiedAdminSystem:Font(18), WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(30), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			if not self.block then
				if self.time <= CurTime() and self.expire > 0 then
					self.time = CurTime() + 1
					self.expire = self.expire - 1
				end
				
				if self.expire > 0 and self.expire <= 10 then
					draw.SimpleText(self.expire.."s", WasiedAdminSystem:Font(18), w-WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(8), WasiedAdminSystem.Constants["colors"][3], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				elseif self.expire > 10 then
					draw.SimpleText(self.expire.."s", WasiedAdminSystem:Font(18), w-WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(8), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				elseif self.expire <= 0 then
					if IsValid(self) then
						self:Remove()
					end
				end
			end

			surface.SetDrawColor(Color(255, 255, 255, 5))
			surface.DrawRect(WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(50), WasiedAdminSystem:RespX(255), WasiedAdminSystem:RespY(75))

			if istable(plysname) and #plysname > 0 then
				draw.SimpleText(WasiedAdminSystem:Lang(60).." : "..table.concat(plysname, ", "), WasiedAdminSystem:Font(18), WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(150), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			else
				draw.SimpleText(WasiedAdminSystem:Lang(61), WasiedAdminSystem:Font(18), WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespY(150), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			end

		end

		local descriptionLabel = vgui.Create("RichText", sender.ticketPanel)
		descriptionLabel:SetSize(WasiedAdminSystem:RespX(245), WasiedAdminSystem:RespY(65))
		descriptionLabel:SetPos(WasiedAdminSystem:RespX(15), WasiedAdminSystem:RespY(55))
		descriptionLabel:InsertColorChange(255, 255, 255, 255)
		descriptionLabel:AppendText(description)
		descriptionLabel:SetContentAlignment(7)
		function descriptionLabel:PerformLayout(w, h)
			self:SetFontInternal(WasiedAdminSystem:Font(18))
		end

		local takeButton = vgui.Create("WASIED_DButton", sender.ticketPanel)
		takeButton:SetRSize(100, 25)
		takeButton:SetRPos(275, 30)
		takeButton:SetLibText(WasiedAdminSystem:Lang(90), color_white, WasiedAdminSystem:Font(19))
		takeButton.DoClick = function(self)
			
			if not self:GetParent().isTaken then
				net.Start("AdminSystem:Tickets:AdminTaking")
					net.WriteBool(false) -- should delete ?
					net.WriteEntity(sender)
				net.SendToServer()
			else
				if self:GetParent().TicketOwner == LocalPlayer():Nick() then
					net.Start("AdminSystem:Tickets:AdminTaking")
						net.WriteBool(true) -- should delete ?
						net.WriteEntity(sender)
					net.SendToServer()
				end
			end

		end
		takeButton.Think = function(self)
			if self:GetParent().isTaken then
				if self:GetParent().TicketOwner == LocalPlayer():Nick() then
					self:SetLibText(WasiedAdminSystem:Lang(62), color_white)
				else
					self:SetLibText(WasiedAdminSystem:Lang(63), color_white)
				end
			end
		end

		local gotoButton = vgui.Create("WASIED_DButton", sender.ticketPanel)
		gotoButton:SetRSize(100, 25)
		gotoButton:SetRPos(275, 60)
		gotoButton:SetLibText(WasiedAdminSystem:Lang(64), color_white, WasiedAdminSystem:Font(19))
		gotoButton.DoClick = function(s)
			WasiedAdminSystem:Command(sender, "goto")
			chat.AddText(WasiedAdminSystem.Constants["colors"][2], WasiedAdminSystem.Constants["strings"][4]..string.Replace(WasiedAdminSystem:Lang(66), "PLAYER_HERE", plyNick))
		end

		local tpButton = vgui.Create("WASIED_DButton", sender.ticketPanel)
		tpButton:SetRSize(100, 25)
		tpButton:SetRPos(275, 90)
		tpButton:SetLibText(WasiedAdminSystem:Lang(65), color_white, WasiedAdminSystem:Font(19))
		tpButton.DoClick = function(s)
			WasiedAdminSystem:Command(sender, "teleport")
			chat.AddText(WasiedAdminSystem.Constants["colors"][2], WasiedAdminSystem.Constants["strings"][4]..string.Replace(WasiedAdminSystem:Lang(67), "PLAYER_HERE", plyNick))
		end

		if WasiedAdminSystem:ULXorFAdmin() then
			local returnButton = vgui.Create("WASIED_DButton", sender.ticketPanel)
			returnButton:SetRSize(100, 25)
			returnButton:SetRPos(275, 120)
			returnButton:SetLibText(WasiedAdminSystem:Lang(89), color_white, WasiedAdminSystem:Font(19))
			returnButton.DoClick = function(s)
				WasiedAdminSystem:Command(sender, "return")
				chat.AddText(WasiedAdminSystem.Constants["colors"][2], WasiedAdminSystem.Constants["strings"][4]..string.Replace(WasiedAdminSystem:Lang(67), "PLAYER_HERE", plyNick))
			end
		end

		local closeTicket = vgui.Create("DButton", sender.ticketPanel)
		closeTicket:SetSize(WasiedAdminSystem:RespX(15), WasiedAdminSystem:RespY(15))
		closeTicket:SetPos(WasiedAdminSystem:RespX(250), WasiedAdminSystem:RespY(130))
		closeTicket:SetText("")
		closeTicket.Paint = function(s, w, h)
			draw.SimpleText(WasiedAdminSystem.Constants["strings"][21], WasiedAdminSystem:Font(20), w/2, h/2, color_white, 1, 1)
		end
		closeTicket.DoClick = function(s)
			if IsValid(sender.ticketPanel) then
				sender.ticketPanel:Remove()
			end
		end
	
	else
		
		local shouldDelete = net.ReadBool()
		local bestAdmin = net.ReadEntity()
		local sender = net.ReadEntity()

		if IsValid(sender.ticketPanel) then
			if shouldDelete then
				sender.ticketPanel:Remove()
			else
				sender.ticketPanel.isTaken = true
				sender.ticketPanel.block = true
				sender.ticketPanel.TicketOwner = bestAdmin:Nick()
			end
		end

	end

end)