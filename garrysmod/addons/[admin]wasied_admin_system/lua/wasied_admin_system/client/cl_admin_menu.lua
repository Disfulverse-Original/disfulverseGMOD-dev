--[[ Admin Menu ]]--
local functions = {
	{
		["text"] = WasiedAdminSystem:Lang(4),
		["func"] = function(self)
			net.Start("AdminSystem:Utils:ModifyVar")
			net.SendToServer()
		end,
	},
	--[[{
		["text"] = WasiedAdminSystem:Lang(7),
		["func"] = function(self)
			WasiedAdminSystem:OpenManagmentMenu()
			self:GetParent():Remove()
		end,
	},]]
	--[[{
		["text"] = WasiedAdminSystem:Lang(10),
		["func"] = function(self)
			WasiedAdminSystem:OpenTicketMenu()
			self:GetParent():Remove()
		end,
	},]]
	--[[{
		["text"] = WasiedAdminSystem:Lang(11),
		["func"] = function(self)
			WasiedAdminSystem:OpenRefundMenu() 
			self:GetParent():Remove()
		end,
	},]]
	{
		["text"] = WasiedAdminSystem:Lang(8),
		["func"] = function(self)
			RunConsoleCommand("say", WasiedAdminSystem.Config.LogsCommand)
		end,
	},
	{
		["text"] = WasiedAdminSystem:Lang(6),
		["func"] = function(self)
			RunConsoleCommand("say", WasiedAdminSystem.Config.WarnsCommand)
		end,
	},
	{
		["text"] = WasiedAdminSystem:Lang(9),
		["func"] = function(self)
			RunConsoleCommand("say", "!menu")
			self:GetParent():Remove()
		end,
	},
	--[[{
		["text"] = "Addon support",
		["func"] = function(self)
			gui.OpenURL("https://discord.gg/rAFcrrX")
		end,
	},]]
}

function WasiedAdminSystem:OpenAdminMenu()
	if not WasiedAdminSystem.Config.AdminMenuEnabled then return end
	if not LocalPlayer():Alive() then return end
	if not WasiedAdminSystem:CheckStaff(LocalPlayer()) then return end

	local basicFrame = vgui.Create("WASIED_DFrame")
	basicFrame:SetRSize(900, 450)
	basicFrame:Center()
	basicFrame:CloseButton(true)
	basicFrame:SetLibTitle(WasiedAdminSystem:Lang(5).." "..WasiedAdminSystem:Lang(3).." "..WasiedAdminSystem.Config.ServerName)

	local adminColor = color_white
	if LocalPlayer():GetNWInt(WasiedAdminSystem.Constants["strings"][12]) == 1 then adminColor = WasiedAdminSystem.Constants["colors"][2] else adminColor = WasiedAdminSystem.Constants["colors"][3] end

	local pos = 0
	local level = 0
	for key, butt in ipairs(functions) do

		local newButton = vgui.Create("WASIED_DButton", basicFrame)
		newButton:SetRPos(285*pos+35, 75*level+100)
		newButton:SetRSize(260, 60)
		newButton:SetLibText(butt.text, color_white)
		newButton.countdown = 0
		newButton.DoClick = function(self)
			if self.countdown < CurTime() then
				butt.func(self)
				self.countdown = CurTime() + 3
			end
		end

		level = (pos >= 2 and level + 1 or level)
		pos = (pos >= 2 and 0 or pos + 1)
	end


	--[[ Connected Staff ]]--
	local staffConnected = 0
	for _,v in pairs(player.GetAll()) do
		if WasiedAdminSystem:CheckStaff(v) then
			staffConnected = staffConnected + 1
		end
	end

	local staffConnectedLabel = vgui.Create("DLabel", basicFrame)
	staffConnectedLabel:SetSize(WasiedAdminSystem:RespX(180), WasiedAdminSystem:RespY(60))
	staffConnectedLabel:SetPos(basicFrame:GetWide()-staffConnectedLabel:GetWide(), basicFrame:GetTall()-staffConnectedLabel:GetTall()+WasiedAdminSystem:RespY(5))
	staffConnectedLabel:SetText("")
	function staffConnectedLabel:Paint(w, h)
		draw.SimpleText(WasiedAdminSystem:Lang(13).." "..staffConnected, WasiedAdminSystem:Font(20), w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

end
net.Receive("AdminSystem:AdminMenu:Open", WasiedAdminSystem.OpenAdminMenu)