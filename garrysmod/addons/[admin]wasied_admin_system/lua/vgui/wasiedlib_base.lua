local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
	self:MakePopup()
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self.title = ""
end

function PANEL:SetRPos(x, y)
	self:SetPos(WasiedAdminSystem:RespX(x), WasiedAdminSystem:RespY(y))
end

function PANEL:SetRSize(x, y)
	self:SetSize(WasiedAdminSystem:RespX(x), WasiedAdminSystem:RespY(y))
end

function PANEL:SetLibTitle(str)
	self.title = str
end

function PANEL:CloseButton(bool)
	if not bool then return end

	local closeButton = vgui.Create("DButton", self)
	closeButton:SetSize(WasiedAdminSystem:RespX(16), WasiedAdminSystem:RespY(16))
	closeButton:SetPos(self:GetWide()-closeButton:GetWide()-WasiedAdminSystem:RespX(5), WasiedAdminSystem:RespY(1))
	closeButton:SetText("")
	closeButton.Paint = function(s, w, h)
		draw.SimpleText(WasiedAdminSystem.Constants["strings"][21], WasiedAdminSystem:Font(20), w/2, h/2, color_white, 1, 1)
	end
	closeButton.DoClick = function()
		self:Remove()
	end
end

function PANEL:ReturnAdminButton(bool)
	if not bool then return end
	
	local returnButton = vgui.Create("DButton", self)
	returnButton:SetSize(WasiedAdminSystem:RespX(16), WasiedAdminSystem:RespY(16))
	returnButton:SetPos(self:GetWide()-returnButton:GetWide()-WasiedAdminSystem:RespX(20), WasiedAdminSystem:RespY(1))
	returnButton:SetText("")
	returnButton.Paint = function(s, w, h)
		draw.SimpleText(WasiedAdminSystem.Constants["strings"][23], WasiedAdminSystem:Font(20), w/2, h/2, color_white, 1, 1)
	end
	returnButton.DoClick = function()
		WasiedAdminSystem:RemoveManagementPanels()
		WasiedAdminSystem:OpenAdminMenu()
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][11])
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(WasiedAdminSystem.Constants["colors"][12])
	surface.DrawRect(0, 0, w, WasiedAdminSystem:RespY(20))
	surface.DrawRect(0, h-WasiedAdminSystem:RespX(30), w, WasiedAdminSystem:RespY(30))

	surface.SetDrawColor(Color( math.abs(math.sin(CurTime()))*255, math.abs(math.sin(CurTime())*.8)*255, math.abs(math.sin(CurTime()*.9))*255 ))
	surface.DrawLine(0, WasiedAdminSystem:RespX(20), w, WasiedAdminSystem:RespY(20))
	surface.DrawLine(0, h-WasiedAdminSystem:RespX(30), w, h-WasiedAdminSystem:RespY(30))

	draw.SimpleText(self.title, WasiedAdminSystem:Font(50), WasiedAdminSystem:RespX(340), WasiedAdminSystem:RespY(70), color_white, 0, 4)
	--draw.SimpleText("by "..WasiedAdminSystem.Config.ServerName, WasiedAdminSystem:Font(20), WasiedAdminSystem:RespX(8), h-WasiedAdminSystem:RespY(5), color_white, 0, 4)
end
derma.DefineControl("WASIED_DFrame", "WasiedLib DFrame", PANEL, "DFrame")