local PANEL = {}

function PANEL:Init()
	SD_SCOREBOARD_GMS.ActiveAdminSettings = SD_SCOREBOARD_GMS.ActiveAdminSettings or 1

	self:Header()
	self:AddMenu()
	self.Paint = function(this, w, h)
		draw.DrawText("SD Scoreboard Ver "..SD_SCOREBOARD_GMS.Ver, "sd_scoreboard_14_100", w-45 , h-20, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_RIGHT)
	end
end
--------------------------------
-- Host name and player count --
--------------------------------
function PANEL:Header()
	local header = vgui.Create("DPanel", self)
	header:SetText("")
	header:Dock(TOP)
	header:DockMargin(45, 0, 45, 0)
	header:SetHeight(84)
	header.Paint = function(this, w, h) end

	local panel = vgui.Create("DPanel", header)
	panel:SetText("")
	panel:Dock(RIGHT)
	panel:DockMargin(0, 20, 0, 20)
	panel:SetSize(100,0)
	panel.Paint = function(this, w, h) 
		draw.DrawText( player.GetCount().."/"..game.MaxPlayers() , "sd_scoreboard_25_100", 100 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_RIGHT)
	end

	local panel = vgui.Create("DPanel", header)
	panel:SetText("")
	panel:Dock(FILL)
	panel:DockMargin(0, 20, 0, 20)
	panel.Paint = function(this, w, h)
		draw.DrawText( SD_SCOREBOARD_GMS.ServerConfig.hostName or GetHostName() , "sd_scoreboard_25_100", 0 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end
end
---------------
-- Menu data --
---------------
function PANEL:GetList()
	local tbl = {
		{"theme", "selectColor", function(panel, tbl)
			self:Themes(self:GetBasePanel(panel), tbl)
		end},
		{"language", "SelectLanguage", function(panel, tbl)
			self:Languages(self:GetBasePanel(panel), tbl)
		end},
	}
	return tbl
end
----------------
-- Menu panel --
----------------
function PANEL:ShowContent(index)
	SD_SCOREBOARD_GMS.ActiveSettings = index and index or SD_SCOREBOARD_GMS.ActiveSettings or 1

	data = self:GetList()[SD_SCOREBOARD_GMS.ActiveSettings]
	data[3](self.settingsPanel, data)
end

function PANEL:AddMenu()
	local menuPanel = vgui.Create("DPanel", self)
	menuPanel:Dock(LEFT)
	menuPanel:SetWidth(300)
	menuPanel:DockMargin(45, 0, 8, 45)
	menuPanel.Paint = function(this, w, h) end

	local top = vgui.Create("DPanel", menuPanel)
	top:Dock(FILL)
	top:SetWidth(300)
	top:DockMargin(0, 0, 0, 8)
	top.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel, true, false, false, false)
	end
	SD_SCOREBOARD_GMS.Shadow(top, 9, true)

	local bottom = vgui.Create("DPanel", menuPanel)
	bottom:Dock(BOTTOM)
	bottom:SetHeight(100)
	bottom:DockMargin(0, 0, 0, 0)
	bottom.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel, false, false, true, false)
	end
	SD_SCOREBOARD_GMS.Shadow(bottom, 9, true)

	self:BottomPanel(bottom)

	local header = vgui.Create("DPanel", top)
	header:Dock(TOP)
	header:SetHeight(60)
	header.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

		draw.DrawText(SD_SCOREBOARD_GMS.Language.settings, "sd_scoreboard_20_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		draw.DrawText(SD_SCOREBOARD_GMS.Language.selectSettingsTab, "sd_scoreboard_16_100", 10 , 31, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT) 
	end

	local settingsPanel = vgui.Create("DPanel", self)
	settingsPanel:Dock(FILL)
	settingsPanel:SetWidth(size)
	settingsPanel:DockMargin(0, 0, 45, 45)
	settingsPanel.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel, false, true, false, true)
	end
	SD_SCOREBOARD_GMS.Shadow(settingsPanel, 9, false)
	self.settingsPanel = settingsPanel

	local scroll = self:GetScroll(top)
	local lang = SD_SCOREBOARD_GMS.Language

	for k, v in ipairs(self:GetList()) do
		local button = vgui.Create("DButton")
		button:SetText("")
		button:Dock(TOP)
		button:SetHeight(40)
		button.Paint = function(this, w, h) 
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
			draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
			draw.DrawText(lang[v[1]] or v[1], "sd_scoreboard_16_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		end
		button.DoClick = function()
			self:ShowContent(k) 
		end

		scroll:Add(button)

		self:ShowContent()
	end
end
------------
-- Scroll --
------------
function PANEL:GetScroll(panel)
	local scroll = vgui.Create("sd_scoreboard_scroll", panel)
	scroll:Dock(FILL)

	return scroll
end
------------
-- Bottom --
------------
function PANEL:BottomPanel(panel)
	local base = vgui.Create("DPanel", panel)
	base:Dock(LEFT)
	base:DockMargin(0, 0, 0, 0)
	base:SetWidth(300)
	base.Paint = function(this, w, h) end
	-- fullscreen --
	local button = vgui.Create("DButton", base)
	button:Dock(TOP)
	button:SetText("")
	button:DockMargin(0, 0, 0, 0)
	button:SetHeight(50)
	button.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
		draw.DrawText(SD_SCOREBOARD_GMS.Language.fullscreen, "sd_scoreboard_16_100", 10 , 16, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)

		draw.RoundedBox(0, 240, 17, 30, 16, SD_SCOREBOARD_GMS.Colors.switchButtonBg)
		SD_SCOREBOARD_GMS.Circle(270, 25, 8, 70,SD_SCOREBOARD_GMS.Colors.switchButtonBg)
		SD_SCOREBOARD_GMS.Circle(240, 25, 8, 70, SD_SCOREBOARD_GMS.Colors.switchButtonBg)

		if SD_SCOREBOARD_GMS.fullScreen == 1 then
			SD_SCOREBOARD_GMS.Circle(270, 25, 12, 70, SD_SCOREBOARD_GMS.Colors.switchButtonIn)
		else
			SD_SCOREBOARD_GMS.Circle(240, 25, 12, 70, SD_SCOREBOARD_GMS.Colors.switchButtonOut)
		end
	end
	button.DoClick = function()
		SD_SCOREBOARD_GMS.fullScreen = SD_SCOREBOARD_GMS.fullScreen == 1 and 0 or 1

		RunConsoleCommand("sd_scoreboard_fullscreen", SD_SCOREBOARD_GMS.fullScreen)
		GAMEMODE:ScoreboardShow(true)
	end
	-- blur --
	local button = vgui.Create("DButton", base)
	button:Dock(TOP)
	button:SetText("")
	button:DockMargin(0, 0, 0, 0)
	button:SetHeight(50)
	button.Paint = function(this, w, h)
		draw.DrawText(SD_SCOREBOARD_GMS.Language.bcgBlur, "sd_scoreboard_16_100", 10 , 16, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)

		draw.RoundedBox(0, 240, 17, 30, 16, SD_SCOREBOARD_GMS.Colors.switchButtonBg)
		SD_SCOREBOARD_GMS.Circle(270, 25, 8, 70,SD_SCOREBOARD_GMS.Colors.switchButtonBg)
		SD_SCOREBOARD_GMS.Circle(240, 25, 8, 70, SD_SCOREBOARD_GMS.Colors.switchButtonBg)

		if SD_SCOREBOARD_GMS.BackgroundBlur == 1 then
			SD_SCOREBOARD_GMS.Circle(270, 25, 12, 70, SD_SCOREBOARD_GMS.Colors.switchButtonIn)
		else
			SD_SCOREBOARD_GMS.Circle(240, 25, 12, 70, SD_SCOREBOARD_GMS.Colors.switchButtonOut)
		end
	end
	button.DoClick = function()
		SD_SCOREBOARD_GMS.BackgroundBlur = SD_SCOREBOARD_GMS.BackgroundBlur == 1 and 0 or 1

		RunConsoleCommand("sd_scoreboard_blur", SD_SCOREBOARD_GMS.BackgroundBlur)
		GAMEMODE:ScoreboardShow(true)
	end
end
----------------
-- Base panel --
----------------
function PANEL:GetBasePanel(panel)
	if ispanel(self.base) then self.base:Remove() end

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(FILL)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
	end

	self.base = panel
	return panel
end
----------------
-- Add Header --
----------------
function PANEL:AddHeader(panel, tbl)
	local lang = SD_SCOREBOARD_GMS.Language

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(TOP)
	panel:SetHeight(100)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

		draw.DrawText(lang[tbl[1]] or tbl[1], "sd_scoreboard_20_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		draw.DrawText(lang[tbl[2]] or tbl[2], "sd_scoreboard_16_100", 10 , 31, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT) 
	end	
end
------------
-- Add sw --
------------
function PANEL:Sw(panel, index, const, func)
	for k, v in ipairs(SD_SCOREBOARD_GMS[index]) do

		local button = vgui.Create("DButton", panel)
		button:SetText("")
		button:Dock(TOP)
		button:SetSize(0,40)
		button.Paint = function(this, w, h) 
			if SD_SCOREBOARD_GMS[const] == k then 
				SD_SCOREBOARD_GMS.Circle( 28, 20, 13, 32, SD_SCOREBOARD_GMS.Colors.circleButtonAct )
				SD_SCOREBOARD_GMS.Circle( 28, 20, 10, 32, SD_SCOREBOARD_GMS.Colors.panel )
				SD_SCOREBOARD_GMS.Circle( 28, 20, 6, 32, SD_SCOREBOARD_GMS.Colors.circleButtonAct )
			else 
				SD_SCOREBOARD_GMS.Circle( 28, 20, 13, 32, SD_SCOREBOARD_GMS.Colors.circleButton )
				SD_SCOREBOARD_GMS.Circle( 28, 20, 10, 32, SD_SCOREBOARD_GMS.Colors.panel )
			end
			draw.DrawText( v.name , "sd_scoreboard_16_100", 55 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)

			draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
		end
		button.DoClick = function(this)
			func(k)
		end
	end
end
------------
-- Themes --
------------
function PANEL:Themes(panel, tbl)
	self:AddHeader(panel, tbl)
	self:Sw(self:GetScroll(panel), "ColorSchemes", "ActiveColor", SD_SCOREBOARD_GMS.SetColorScheme)
end
---------------
-- Languages --
---------------
function PANEL:Languages(panel, tbl)
	self:AddHeader(panel, tbl)
	self:Sw(self:GetScroll(panel), "Languages", "ActiveLanguage", SD_SCOREBOARD_GMS.SetLanguage)
end

vgui.Register("sd_scoreboard_settings", PANEL)