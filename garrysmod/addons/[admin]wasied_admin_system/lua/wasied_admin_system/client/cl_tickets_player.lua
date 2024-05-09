surface.CreateFont( "TicketFont", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

local AdminSystem_TicketTimer = 0
function WasiedAdminSystem:OpenTicketMenu()
	if not LocalPlayer():Alive() then return end
	if not WasiedAdminSystem.Config.TicketEnabled then return end

	if WasiedAdminSystem.Config.AdminSystemEnabled and not WasiedAdminSystem.Config.TicketOnlyAdmin then
		local staffConnected = 0
		for k,v in pairs(player.GetAll()) do
			if IsValid(v) and WasiedAdminSystem:CheckStaff(v) and v:GetNWInt(WasiedAdminSystem.Constants["strings"][12]) > 0 then
				staffConnected = staffConnected + 1
			end
		end

		if staffConnected == 0 then chat.AddText(WasiedAdminSystem.Constants["colors"][3], WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem:Lang(68)) return end
	end

	local selectedPlayer = {}

	local basicFrame = vgui.Create("WASIED_DFrame")
	basicFrame:SetRSize(900, 535)
	basicFrame:Center()
	basicFrame:CloseButton(true)
	if WasiedAdminSystem:CheckStaff(LocalPlayer()) then basicFrame:ReturnAdminButton(true) end
	basicFrame:SetLibTitle(WasiedAdminSystem:Lang(10).." "..WasiedAdminSystem:Lang(3).." "..WasiedAdminSystem.Config.ServerName)
	function basicFrame:PaintOver(w, h)
		draw.SimpleText(WasiedAdminSystem:Lang(69), WasiedAdminSystem:Font(20), WasiedAdminSystem:RespX(145), WasiedAdminSystem:RespX(75), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(WasiedAdminSystem:Lang(70), WasiedAdminSystem:Font(20), WasiedAdminSystem:RespX(315), WasiedAdminSystem:RespX(80), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(WasiedAdminSystem:Lang(71), WasiedAdminSystem:Font(20), WasiedAdminSystem:RespX(315), WasiedAdminSystem:RespX(163), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	--[[ PLAYER LIST ]]--
	local scrollPanel = vgui.Create("DScrollPanel", basicFrame)
	scrollPanel:SetSize(WasiedAdminSystem:RespX(250), WasiedAdminSystem:RespX(380))
	scrollPanel:SetPos(WasiedAdminSystem:RespX(25), WasiedAdminSystem:RespX(110))
	scrollPanel:GetVBar():SetHideButtons(true)
	scrollPanel.antiSpamActive = false
	function scrollPanel:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.DrawLine(w-1, 0, w-1, h)
	end
	local sbar = scrollPanel:GetVBar()
	function sbar:Paint(w, h)
	end
	function sbar.btnGrip:Paint(w, h)
	end

	for k,v in pairs(player.GetAll()) do
		if IsValid(v) then
			if v == LocalPlayer() then continue end

			local panel = scrollPanel:Add("DPanel")
			panel:SetSize(scrollPanel:GetWide(), WasiedAdminSystem:RespX(60))
			panel:Dock(TOP)
			panel:DockMargin(WasiedAdminSystem:RespX(5), WasiedAdminSystem:RespX(5), WasiedAdminSystem:RespX(10), WasiedAdminSystem:RespX(2))
			panel.clicked = false
			panel.hovered = false
			function panel:Paint(w, h)
				if panel.clicked or panel.hovered and #selectedPlayer < WasiedAdminSystem.Config.TicketMaxPlayers then
					draw.RoundedBox(5, 0, 0, w, h, WasiedAdminSystem.Constants["colors"][1])
				elseif #selectedPlayer >= WasiedAdminSystem.Config.TicketMaxPlayers then
					draw.RoundedBox(5, 0, 0, w, h, Color(20, 20, 20, 150))
				else
					draw.RoundedBox(5, 0, 0, w, h, WasiedAdminSystem.Constants["colors"][8])
				end

				surface.SetDrawColor(color_white)
				surface.DrawRect(WasiedAdminSystem:RespX(4), WasiedAdminSystem:RespX(4), WasiedAdminSystem:RespX(52), WasiedAdminSystem:RespX(52))
			end

			local avatar = vgui.Create("AvatarImage", panel)
			avatar:SetSize(WasiedAdminSystem:RespX(50), WasiedAdminSystem:RespX(50))
			avatar:SetPos(WasiedAdminSystem:RespX(5), WasiedAdminSystem:RespX(5))
			avatar:SetPlayer(v, 128)

			local button = vgui.Create("DButton", panel)
			button:Dock(FILL)
			button:SetText("")
			function button:Paint(w, h)
				if not IsValid(v) then return end
				draw.SimpleText(v:Nick(), WasiedAdminSystem:Font(23), w/2+avatar:GetWide()/2, h/2, color_white, 1, 1)
			end
			function button:DoClick()
				if panel.clicked then
					panel.clicked = false
					if table.HasValue(selectedPlayer, v) then
						table.RemoveByValue(selectedPlayer, v)
					end
				elseif not panel.clicked and #selectedPlayer < WasiedAdminSystem.Config.TicketMaxPlayers then
					panel.clicked = true
					if not table.HasValue(selectedPlayer, v) then
						table.insert(selectedPlayer, v)
					end
				end
			end
			function button:OnCursorEntered()
				panel.hovered = true
			end
			function button:OnCursorExited()
				panel.hovered = false
			end

		end
	end

	--[[ REPORT PANEL ]]--
	local dboxcombo = vgui.Create("DComboBox", basicFrame)
	dboxcombo:SetSize(WasiedAdminSystem:RespX(550), WasiedAdminSystem:RespX(40))
	dboxcombo:SetPos(WasiedAdminSystem:RespX(300), WasiedAdminSystem:RespX(110))
	dboxcombo:SetValue(WasiedAdminSystem:Lang(88))
	for _,val in ipairs(WasiedAdminSystem.Config.TicketsReasons) do
		dboxcombo:AddChoice(val)
	end

	local descriptionEntry = vgui.Create("DTextEntry", basicFrame)
	descriptionEntry:SetSize(WasiedAdminSystem:RespX(550), WasiedAdminSystem:RespX(200))
	descriptionEntry:SetPos(WasiedAdminSystem:RespX(300), WasiedAdminSystem:RespX(190))
	descriptionEntry:SetMultiline(true)
	descriptionEntry:SetFont(WasiedAdminSystem:Font(25))

	local validButton = vgui.Create("WASIED_DButton", basicFrame)
	validButton:SetRSize(450, 65)
	validButton:SetRPos(350, 415)
	validButton:SetLibText("Отправить", color_white)
	function validButton:DoClick()
		if AdminSystem_TicketTimer < CurTime() then

			local descriptionText = descriptionEntry:GetValue()
			local subjectText = dboxcombo:GetSelected()

			if isstring(subjectText) and isstring(descriptionText) and string.len(descriptionText) > WasiedAdminSystem.Config.MinDescriptionLen and string.len(descriptionText) < 5000 and dboxcombo:GetValue() ~= WasiedAdminSystem.Language.DefaultText then
				
				net.Start("AdminSystem:Tickets:SendTicket")
					net.WriteString(subjectText)
					net.WriteTable(selectedPlayer)
					net.WriteString(descriptionText)
				net.SendToServer()

				chat.AddText(Color(40, 255, 40), WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem:Lang(72))
				AdminSystem_TicketTimer = CurTime() + WasiedAdminSystem.Config.TicketTimer
				basicFrame:Close()

			else
				chat.AddText(WasiedAdminSystem.Constants["colors"][4], WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem:Lang(73))
			end
		
		else
			chat.AddText(WasiedAdminSystem.Constants["colors"][4], WasiedAdminSystem.Constants["strings"][4]..WasiedAdminSystem:Lang(74))
		end
	end

end
net.Receive("AdminSystem:Tickets:Open", WasiedAdminSystem.OpenTicketMenu)