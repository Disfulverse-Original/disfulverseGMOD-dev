local PANEL = {}

function PANEL:Init()
	local divW = ScrW() > 1600 and 1.6 or 1.2
	local divH = ScrW() > 1600 and 1.4 or 1.1

	local fullScr = SD_SCOREBOARD_GMS.fullScreen

	self.w = fullScr == 0 and ScrW()/divW or ScrW()
	self.h = fullScr == 0 and ScrH()/divH or ScrH()

	self:SetSize(ScrW() , ScrH()) 
	self:BasePanel()
	self:SetZPos(-1)
end
----------
-- base --
----------
function PANEL:BasePanel()
	local button = vgui.Create("DButton", self)
	button:Dock(FILL)
	button:SetText("")
	button.Paint = function(this, w, h) end
	button.DoClick = function(this)
		GAMEMODE:ScoreboardHide()
	end

	local basePanel = vgui.Create("EditablePanel", self)
	basePanel:SetSize(self.w, self.h) 
	basePanel:Center()
	basePanel:MakePopup()
	basePanel:SetKeyboardInputEnabled(false)
	basePanel.Paint = function(this, w, h)
		if (GetConVarNumber("sd_scoreboard_blur") == 1) then 
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.backgroundBlur)
			SD_SCOREBOARD_GMS.Blur(w, h, this)
		else
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.background)
		end
	end

	local contentPanel = vgui.Create("DPanel", basePanel)
	contentPanel:Dock(FILL) 
	contentPanel:SetText("")
	contentPanel.Paint = function(this, w, h) end

	self.canvas = basePanel
	self.basePanel = contentPanel
	self:LeftSide(basePanel)
end
---------------
-- animation --
---------------
function PANEL:EasyInOut(x)
	return 1-math.pow(1-x*2,3)
end

function PANEL:Animation(act)
	local STime = SysTime()

	local from = self.canvas:GetPos()
	local to = act == "close" and -self.w or (ScrW()/2)-(self.w/2)
	local pos = 0

	if act == "close" then 
		self.canvas:SetKeyboardInputEnabled(false)
		self.canvas:SetMouseInputEnabled(false)
	else
		self.canvas:SetPos(-self.w,0)
	end

	self.canvas.Think = function(this)
		pos = Lerp(self:EasyInOut((SysTime() - STime)/3), this:GetPos(), to)
		this:SetPos(pos,(ScrH()/2)-(self.h/2))

		if (act == "close") and (pos <= to+1) then 
			self:Remove()
		end
	end
end
---------------------
-- Left Side panel --
---------------------
function PANEL:LeftSide(panel)
	self.alphaPanel = 0
	local bool, animation, image = SD_SCOREBOARD_GMS.LeftSide, {}, 0

	if (!bool) then 
		animation = {pos = 60, start = 250, stop = 60, STime = 1} 
		image = SD_SCOREBOARD_GMS.Colors.icons.menu
	else 
		animation = {pos = 250, start = 60, stop = 250, STime = 1} 
		image = SD_SCOREBOARD_GMS.Colors.icons.arrowBack
	end

	local leftPanel = vgui.Create("DPanel", panel)
	leftPanel:SetSize(animation.pos,0)
	leftPanel:Dock(LEFT)
	leftPanel:SetZPos(10)
	leftPanel.Paint = function(this, w, h) 
		draw.RoundedBoxEx(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.leftSide, true, false, true, false)
	end

	leftPanel.Think = function(this)
		animation.pos = Lerp(SD_SCOREBOARD_GMS.Easing((SysTime() - animation.STime)*3), animation.start, animation.stop)
		self.alphaPanel = math.Remap(animation.pos,200,250,0,255)

		this:SetWidth(animation.pos)
	end

	SD_SCOREBOARD_GMS.Shadow(leftPanel, 10, false)
	self.leftPanel = leftPanel

	local name = LocalPlayer():Nick()
	local group = LocalPlayer():GetUserGroup()

	local base = vgui.Create("DPanel", self.leftPanel)
	base:SetSize(60, 60)
	base:SetText("")
	base:Dock(TOP)
	base:DockMargin(0, 0, 0, 0)
	base.Paint = function(this, w, h) 
		SD_SCOREBOARD_GMS.Circle(w/2, 90, 34, 80, SD_SCOREBOARD_GMS.Colors.panel2)

		draw.DrawText(name, "sd_scoreboard_16_100", w / 2 , 130, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
		draw.DrawText(group, "sd_scoreboard_16_100", w / 2 , 147, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_CENTER)
	end

	base.Think = function(this, w, h)
		this:SetHeight(math.Remap(animation.pos,60,250,60,210))
	end

	local avatar = vgui.Create("sd_circleavatar", base)
	avatar:SetData(LocalPlayer(), 80, 40)
	avatar:SetSize(60,60)
	avatar:SetPos(95,60)
	avatar.Think = function(this)
		local x, y = base:GetSize()
		this:SetPos(-30+x/2, 60)
	end

	local panel = vgui.Create("DPanel", base)
	panel:SetText("")
	panel:DockMargin(0, 0, 0, 0)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.leftSide, 255 - self.alphaPanel))
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.leftSideLine)
	end
	panel.Think = function(this)
		this:SetSize(base:GetSize())
	end

	local panel = vgui.Create("DPanel", base)
	panel:SetSize(60, 60 )
	panel:SetText("")
	panel:Dock(RIGHT)
	panel:DockMargin(0, 0, 0, 0)
	panel.Paint = function(this, w, h) end

	local button = vgui.Create("DButton", panel)
	button:SetSize(60, 60 )
	button:SetText("")
	button:Dock(TOP)
	button:DockMargin(0, 0, 0, 0)
	button.Paint = function(this, w, h) end

	local buttonImage = vgui.Create("DImage", button )
	buttonImage:Dock(FILL)
	buttonImage:DockMargin(15, 15, 15, 15)
	buttonImage:SetMaterial(image)

	button.DoClick = function(this)
		bool = !bool

		if (!bool) then 
			animation = {pos = 60, start = 250, stop = 60, STime = SysTime()} 
			image = SD_SCOREBOARD_GMS.Colors.icons.menu
		else 
			animation = {pos = 250, start = 60, stop = 250, STime = SysTime()} 
			image = SD_SCOREBOARD_GMS.Colors.icons.arrowBack
		end

		buttonImage:SetMaterial(image)
		SD_SCOREBOARD_GMS.LeftSide = !SD_SCOREBOARD_GMS.LeftSide
	end

	self.scroll = vgui.Create("sd_scoreboard_scroll", leftPanel)
	self.scroll:Dock(FILL)
	self.scroll:scrollBarEnable(false)
	-----------------
	-- Create tabs --
	-----------------
	for k, v in ipairs(SD_SCOREBOARD_GMS.Tabs) do
		if v.vgui == "sd_scoreboard_admin_settings" and !LocalPlayer():IsSuperAdmin() then continue end
		if SD_SCOREBOARD_GMS.ActiveTab == 1 then SD_SCOREBOARD_GMS.ActiveTab = v.vgui end
		
		self:AddTab("panel", v.name, v.icon, v.vgui, v.color, v.type)
	end

	if SD_SCOREBOARD_GMS.ServerConfig.commands and #SD_SCOREBOARD_GMS.ServerConfig.commands >= 1 then self:AddTab("space", _)  end

	for k, v in ipairs(SD_SCOREBOARD_GMS.ServerConfig.commands or {}) do
		self:AddTab("cmds", v[1], v[3], v[2])
	end

	if SD_SCOREBOARD_GMS.ServerConfig.links and #SD_SCOREBOARD_GMS.ServerConfig.links >= 1 then self:AddTab("space", _)  end

	for k, v in ipairs(SD_SCOREBOARD_GMS.ServerConfig.links or {}) do
		self:AddTab("link", v[1], v[3], v[2])
	end
end

function PANEL:AddTab(panelType, name, icon, path, color, type)
	self.TabCount, self.wait = self.TabCount or 1, self.wait or false

	local STime, alpha, CurrentTab = 1, { start = 0, stop = 255, lerp = 255 }, self.TabCount
	local color = color or Color(100,100,200)

	local button = vgui.Create("DButton", self.scroll)
	button:SetSize(45, 45 )
	button:SetText("")
	button:Dock(TOP)
	button:DockMargin(0, 0, 0, 0)
	button.Paint = function(this, w, h) 
		if ((panelType == "panel") or (panelType == "link")) then 
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.tabActive, alpha.lerp))
			draw.RoundedBox(0, 0, 0, alpha.lerp/75, h, color)
		end
		draw.DrawText(SD_SCOREBOARD_GMS.Language[name] or name or "", "sd_scoreboard_16_100", 70 , 15, ColorAlpha(SD_SCOREBOARD_GMS.Colors.mainText, self.alphaPanel), TEXT_ALIGN_LEFT)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.leftSideLine)
	end

	button.Think = function(this)
		if (SD_SCOREBOARD_GMS.ActiveTab == path) then 
			if ((alpha.stop == 0) and !self.wait) then alpha.start, alpha.stop = alpha.stop, alpha.start end
		else 
			if (alpha.stop == 255) then alpha.start, alpha.stop = alpha.stop, alpha.start end
		end

		if (alpha.lerp == alpha.stop) then STime = nil return else STime = STime or SysTime() end
		alpha.lerp = Lerp(( SysTime() - STime ) * 6, alpha.start, alpha.stop)
		if (alpha.lerp == alpha.stop) then self.wait = false end
	end

	if (panelType == "space") then return end

	if (icon != "") then 
		local image = vgui.Create("DImage", button )
		image:SetSize(32, 32)
		image:SetPos(14, 6)
		image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons[icon])
	end

	button.DoClick = function(this)
		if (panelType == "panel") then 
			self.wait = true 
			SD_SCOREBOARD_GMS.ActiveTab = path
			self:Content(path, type, panelType)

		elseif (panelType == "link") then 
			self.wait = true 
			SD_SCOREBOARD_GMS.ActiveTab = path
			self:Content("sd_scoreboard_web", path, panelType)

		elseif (panelType == "cmds") then 
			LocalPlayer():ConCommand(path)
		end
	end

	if (SD_SCOREBOARD_GMS.ActiveTab == path) then 
		if panelType == "link" then 
			self:Content("sd_scoreboard_web", path, panelType)
		else
			self:Content(path, type, panelType) 
		end
	end
	self.TabCount = self.TabCount + 1
end
--------------------
-- Create content --
--------------------
function PANEL:CreateContent(path, type, panelType)
	if IsValid(self.content) then self.content:Remove() end
	if path == "" then return end

	self.content = vgui.Create(path, self.basePanel)
	self.content:Dock(FILL) 

	if panelType == "link" then self.content:SetLink(type) end
end

function PANEL:CreateBackground(path, type, panelType)
	local alpha, bool, STime = 0, true, SysTime()

	local bcg = vgui.Create("DPanel", self.basePanel)
	bcg:SetSize(self.basePanel:GetSize())
	bcg:SetZPos(6)
	bcg.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.background, alpha))
	end
	bcg.Think = function(this)
		local x = (SysTime() - STime)*8

		if (x >= math.pi/2 and bool) then bool = !bool self:CreateContent(path, type, panelType) end
		if (x >= math.pi and !bool) then this:Remove() end

		alpha = math.ceil((math.sin(x)^2)*255)
	end
end

function PANEL:Content(path, type, panelType)
	if not ( IsValid(self.content) ) then self:CreateContent(path, type, panelType) return end
	self:CreateBackground(path, type, panelType)
end

vgui.Register("sd_scoreboard", PANEL) -- Register main UI