local PANEL = {}

function PANEL:Init()
	SD_SCOREBOARD_GMS.ActiveAdminSettings = SD_SCOREBOARD_GMS.ActiveAdminSettings or 1

	self:Header()
	self:AddMenu(self)
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
function PANEL:GetIconsList()
	local tbl = {
		"bitcoin", "cloud", "discord", "email", "facebook", "settings", 
		"steam", "store", "support", "telegram", "twitch", "vk", "web", "youtube"
	}
	return tbl
end

function PANEL:GetList()
	local temp = {}

	local tbl = {
		{"tablsLinks", "tablsLinksDesc", function(panel, tbl) 
			self:Tabs(self:GetBasePanel(panel), tbl, "links") 
		end},
		{"tablsCmds", "tablsCmdsDesc", function(panel, tbl) 
			self:Tabs(self:GetBasePanel(panel), tbl, "commands") 
		end},
		{"hidePlayers", "hidePlayersDesc", function(panel, tbl) 
			self:HidePly(self:GetBasePanel(panel), tbl) 
		end},
		{"catUserGroups", "catUserGroupsDesc", function(panel, tbl) 
			self:CategoriesGroups(self:GetBasePanel(panel), tbl)
		end},
	}

	for k, v in ipairs(SD_SCOREBOARD_GMS.Config.boolean) do
		if not temp[v[1]] then temp[v[1]] = v[1] else continue end

		local tempTbl = {v[1], v[2], function(panel, tbl) 
			self:Bool(self:GetBasePanel(panel), tbl) 
		end}

		table.insert(tbl, tempTbl)
	end

	return tbl
end

function PANEL:SendStringToServer(class, str)
	net.Start( "sd_scoreboard_gsfc" )
	net.WriteString(class)
	net.WriteString(str)
	net.SendToServer()
end

function PANEL:SendBoolToServer(str)
	net.Start("sd_scoreboard_gbfc")
	net.WriteString(str)
	net.SendToServer()
end

function PANEL:SendDataToServer(class, arg2, arg3, arg4, index)
	local argsStr = {class, arg2, arg3, arg4}

	net.Start("sd_scoreboard_gd")
	for k, v in ipairs(argsStr) do
		net.WriteString(v)
	end
	net.WriteUInt(index, 10)
	net.SendToServer()
end

function PANEL:RemoveDataFromServer(class, index)
	net.Start("sd_scoreboard_rd")
	net.WriteString(class)
	net.WriteUInt(index, 10)
	net.SendToServer()
end

function PANEL:DataSetPos(class, index, pos)
	net.Start("sd_scoreboard_pc")
	net.WriteString(class)
	net.WriteUInt(index, 10)
	net.WriteString(pos)
	net.SendToServer()
end
----------------
-- Menu panel --
----------------
function PANEL:ShowContent(index)
	SD_SCOREBOARD_GMS.ActiveAdminSettings = index and index or SD_SCOREBOARD_GMS.ActiveAdminSettings or 1

	local data = self:GetList()[SD_SCOREBOARD_GMS.ActiveAdminSettings]
	data[3](self.settingsPanel, data)
end

function PANEL:AddMenu(panel)
	local menuPanel = vgui.Create("DPanel", panel)
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
	bottom:SetHeight(210)
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

		draw.DrawText( SD_SCOREBOARD_GMS.Language.admSettings, "sd_scoreboard_20_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		draw.DrawText( SD_SCOREBOARD_GMS.Language.selectSettingsTab, "sd_scoreboard_16_100", 10 , 31, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT) 
	end

	local settingsPanel = vgui.Create("DPanel", panel)
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
		local button = vgui.Create("DButton", scroll)
		button:SetText("")
		button:Dock(TOP)
		button:SetHeight(40)
		button.Paint = function(this, w, h) 
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
			draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
			draw.DrawText( lang[v[1]] or v[1], "sd_scoreboard_16_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		end
		button.DoClick = function()
			self:ShowContent(k) 
		end
		self:ShowContent()
	end
end
---------------------
-- Bottom settings --
---------------------
function PANEL:BottomPanel(panel)
	local base = vgui.Create("DPanel", panel)
	base:Dock(LEFT)
	base:DockMargin(0, 0, 0, 0)
	base:SetWidth(300)
	base.Paint = function(this, w, h) end

	local entry1Base = vgui.Create("DPanel", base)
	entry1Base:Dock(TOP)
	entry1Base:DockMargin(0, 0, 0, 0)
	entry1Base:SetHeight(70)
	entry1Base.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
		draw.DrawText(SD_SCOREBOARD_GMS.Language.customHostName, "sd_scoreboard_16_100", 10 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
	end

	local panel = vgui.Create("DPanel", entry1Base)
	panel:Dock(LEFT)
	panel:DockMargin(10, 30, 5, 10)
	panel:SetWidth(190)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
	end

	local entry = vgui.Create( "DTextEntry", panel)
	entry:SetValue(SD_SCOREBOARD_GMS.ServerConfig.hostName or "da")
	entry:Dock(FILL)
	entry:DockMargin(5, 0, 2, 0)
	entry:SetFont("sd_scoreboard_16_100")
	entry:SetDrawLanguageID(false)
	entry.Think = function (this) end

	entry.Paint = function (this, w, h) 
		this:DrawTextEntryText(SD_SCOREBOARD_GMS.Colors.mainText, SD_SCOREBOARD_GMS.Colors.subText, SD_SCOREBOARD_GMS.Colors.mainText) 
	end

	entry.OnLoseFocus = function(this) 
		SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false) 
	end
	entry.OnGetFocus = function(this) 
		SD_SCOREBOARD_GMS.PanelFocus()
	end

	local button = vgui.Create("DButton", entry1Base)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button:SetText("")
	button:Dock(FILL)
	button:DockMargin(0, 30, 10, 10)
	button:SetWide(70)
	button.Paint = function(this, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, true, true, true, true)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), true, true, true, true)

		draw.DrawText(SD_SCOREBOARD_GMS.Language.update, "sd_scoreboard_16_100", w/2 , 7, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function()
		self:SendStringToServer("hostName", entry:GetValue())
	end

	local panel = vgui.Create("DPanel", base)
	panel:Dock(TOP)
	panel:DockMargin(0, 0, 0, 0)
	panel:SetHeight(70)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
		draw.DrawText(SD_SCOREBOARD_GMS.Language.CategoriesBy, "sd_scoreboard_16_100", 10 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
	end

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(LEFT)
	panel:DockMargin(10, 30, 60, 10)
	panel:SetWidth(280)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
		draw.DrawText(SD_SCOREBOARD_GMS.Language[SD_SCOREBOARD_GMS.ServerConfig.categoriesBy] or SD_SCOREBOARD_GMS.ServerConfig.categoriesBy or "", "sd_scoreboard_16_100", 10 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end

	self:PopUpList(panel, self, {"ByNone" ,"ByGroup", "ByTeam"}, "categoriesBy", function(cfg, v, basePanel) 
		self:SendStringToServer(cfg, v) 
	end)

	local panel = vgui.Create("DPanel", base)
	panel:Dock(TOP)
	panel:DockMargin(0, 0, 0, 0)
	panel:SetHeight(70)
	panel.Paint = function(this, w, h)
		draw.DrawText(SD_SCOREBOARD_GMS.Language.playerSortBy, "sd_scoreboard_16_100", 10 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
	end

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(LEFT)
	panel:DockMargin(10, 30, 60, 10)
	panel:SetWidth(280)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
		draw.DrawText(SD_SCOREBOARD_GMS.Language[SD_SCOREBOARD_GMS.ServerConfig.sortBy] or SD_SCOREBOARD_GMS.ServerConfig.sortBy or "", "sd_scoreboard_16_100", 10 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end

	self:PopUpList(panel, self, {"ByNone" ,"ping", "deaths", "kills", "plyTime"}, "sortBy", function(cfg, v, basePanel) 
		self:SendStringToServer(cfg, v) 
	end)
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
------------
-- Scroll --
------------
function PANEL:GetScroll(panel)
	local scroll = vgui.Create("sd_scoreboard_scroll", panel)
	scroll:Dock(FILL)

	return scroll
end
----------------
-- Poly table --
----------------
function PANEL:GetPoly()
	local tbl = {
		{x = 0, y = 1},
		{x = 3, y = 4},
		{x = 3, y = 36},
		{x = 0, y = 39}
	}
	return tbl
end
-----------------
-- Entry panel --
-----------------
function PANEL:AddEntry(panel, dock, size, entryType, text)
	local panel = vgui.Create("DPanel", panel)
	panel:Dock(dock)
	panel:DockMargin(5, 0, 0, 0)
	panel:SetWidth(size)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
	end

	local entry = vgui.Create( "DTextEntry", panel )
	entry:SetValue( text or "" )
	entry:Dock(FILL)
	entry:DockMargin(0, 0, 0, 0)
	entry:SetFont("sd_scoreboard_16_100")
	entry:SetDrawLanguageID(false)
	entry.Think = function (this)
		x, y = this:GetParent():GetSize()
	end

	local defText = entryType == "group" 	and SD_SCOREBOARD_GMS.Language.enterGroup 
	or entryType == "name" 					and SD_SCOREBOARD_GMS.Language.enterName 
	or entryType == "SteamID" 				and SD_SCOREBOARD_GMS.Language.enterSteamid
	or entryType == "links" 				and SD_SCOREBOARD_GMS.Language.enterLink 
	or entryType == "commands" 				and SD_SCOREBOARD_GMS.Language.enterCmd

	entry.Paint = function (this, w, h)
		this:DrawTextEntryText(SD_SCOREBOARD_GMS.Colors.mainText, SD_SCOREBOARD_GMS.Colors.subText, SD_SCOREBOARD_GMS.Colors.mainText)
		draw.DrawText(this:GetValue() == "" and defText or "", "sd_scoreboard_16_100", 3, 7, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT) 
	end

	entry.OnLoseFocus = function( this ) 
		SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false)
	end

	entry.OnGetFocus = function( this ) 
		SD_SCOREBOARD_GMS.PanelFocus()
	end

	if (entryType == "group" and ulx) or entryType == "SteamID" then 
		if entryType == "group" and ulx then
			self:PopUpList(entry, self, ulx.group_names, "", function(cfg,v,basePanel,panel) 
				panel:SetValue(v)
			end)
		elseif entryType == "SteamID" then
			self:PopUpList(entry, self, player.GetAll(), "", function(cfg,v,basePanel,panel)
				panel:SetValue(IsEntity(v) and v:IsPlayer() and v:SteamID() or "")
			end)
		end
	end
	return entry
end
-----------------------
-- Image for buttons --
-----------------------
function PANEL:AddImage(panel, path)
	local image = vgui.Create("DImage", panel )
	image:Dock(FILL)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons[path])
end
-------------------
-- Editable base --
-------------------
function PANEL:AddEditablePanel(panel, tbl)
	if ispanel(self.EditablePanel) then self.EditablePanel:Remove() end

	local panel = self:AddHeader(panel, tbl)

	local line = vgui.Create("DPanel", panel)
	line:Dock(TOP)
	line:DockMargin(5, 5, 0, 0)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local closeButton = vgui.Create("DButton", line)
	SD_SCOREBOARD_GMS.ButtonAnim(closeButton)
	closeButton:SetText("")
	closeButton:Dock(RIGHT)
	closeButton:DockMargin(0, 0, 5, 0)
	closeButton:SetWide(29)
	closeButton.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
		draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel2, this.anim.pos))
	end
	closeButton.DoClick = function()
		panel:Remove()
	end
	self:AddImage(closeButton, "delete")

	self.EditablePanel = panel
	return panel
end
-----------------
-- Icons panel --
-----------------
function PANEL:AddIconPanel(panel)
	local x, y = self:LocalCursorPos()

	local basePanel = vgui.Create("DPanel",self)
	basePanel:SetText("")
	basePanel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)

		local x, y = this:LocalCursorPos()
		if (x > w) or (x < 0) or (y > h) or (y < 0) then 
			this:Remove() 
			SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false) 
		end
	end

	local grid = vgui.Create("sd_scoreboard_grid",basePanel)
	grid:Dock(TOP)
	grid:SetColHeight(60)
	grid:SetMargin(1,1)
	grid:SetCol(4)
	grid:InvalidateLayout(true)

	for k, v in ipairs(self:GetIconsList()) do
		local button = vgui.Create("DButton")
		SD_SCOREBOARD_GMS.ButtonAnim(button)
		button:SetText("")
		button:Dock(FILL)
		button:DockPadding(5, 5, 5, 5)
		button.Paint = function(this, w, h)
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
			draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos))
		end
		button.DoClick = function()
			panel.img = v
			basePanel:Remove()
		end
		self:AddImage(button, v)
		grid:AddItem(button)
	end

	basePanel:InvalidateLayout(true)
	basePanel:SizeToChildren(false,true)

	local x, y = self:LocalCursorPos()

	basePanel:SetPos(x-241,y-2)
	basePanel:SetWide(243)
	basePanel:SetZPos(10)

	SD_SCOREBOARD_GMS.Shadow(basePanel, 8, false)
end

function PANEL:AddIconImage(panel, path)
	local panel = vgui.Create("DPanel", panel)
	panel:Dock(RIGHT)
	panel:DockPadding(2, 2, 2, 2)
	panel:DockMargin(0, 5, 5, 6)
	panel:SetWide(29)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
	end
	self:AddImage(panel, path)

	return panel
end

function PANEL:AddIconButton(panel)
	local panel = vgui.Create("DButton", panel)
	panel:SetText("")
	panel:Dock(RIGHT)
	panel:DockPadding(2, 2, 2, 2)
	panel:DockMargin(5, 0, 0, 0)
	panel:SetWide(30)
	panel.img = "web"
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
	end
	panel.DoClick = function()
		self:AddIconPanel(panel)
	end

	local image = vgui.Create("DImage", panel )
	image:Dock(FILL)
	image.Think = function(this)
		this:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons[panel.img])
	end
	return panel
end
-----------------
-- Color panel --
-----------------
function PANEL:AddColorPanel(data)
	local x, y = self:LocalCursorPos()
	SD_SCOREBOARD_GMS.PanelFocus()

	local colorPanel = vgui.Create("DPanel", self)
	colorPanel:SetText("")
	colorPanel:SetSize(200,200)
	colorPanel:SetPos(x-200,y)
	colorPanel:SetZPos(2)
	colorPanel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
		draw.RoundedBox(4, 141, 82, 49, 68, data.color)

		local x, y = this:LocalCursorPos()
		if (x > w) or (x < 0) or (y > h) or (y < 0) then 
			this:Remove() 
			SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false) 
		end
	end
	SD_SCOREBOARD_GMS.Shadow(colorPanel, 8, false)

	local color = vgui.Create("DColorMixer", colorPanel)
	color:Dock(FILL)		
	color:DockMargin(10, 10, 10, 10)
	color:SetSize(200,180)		
	color:SetPalette(false)  			
	color:SetAlphaBar(false)
	color:SetWangs(true) 		
	color:SetColor(data.color)	
	color.Think = function(this)
		data.color = this:GetColor()
	end

	local panel = vgui.Create("DPanel", colorPanel)
	panel:SetText("")
	panel:Dock(BOTTOM)
	panel:SetSize(200,40)
	panel:SetZPos(1)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, 0, w, 1, SD_SCOREBOARD_GMS.Colors.line2)
	end

	local button = vgui.Create("DButton", panel)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button:SetText("")
	button:Dock(BOTTOM)
	button:DockMargin(120, 5, 5, 5)
	button:SetSize(30,30)
	button.Paint = function(this, w, h)
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered)
		draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos))

		draw.DrawText(SD_SCOREBOARD_GMS.Language.ok, "sd_scoreboard_14_100", w/2 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function(this)
		colorPanel:Remove()
		SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false)
	end
	SD_SCOREBOARD_GMS.Shadow(button, 8, false)
end

function PANEL:AddColorButton(panel)
	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(RIGHT)
	button:SetWide(30)
	button:DockMargin(5, 0, 0, 0)
	button.color = Color(255,0,0)
	button.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, button.color)
	end
	self:AddImage(button, "color")

	button.DoClick = function()
		self:AddColorPanel(button)
	end
	return button
end
-----------------------------
-- Position change buttons --
-----------------------------
function PANEL:PosButtons(tbl, data, panel, index)
	local buttonDown = vgui.Create("DButton", panel)
	SD_SCOREBOARD_GMS.ButtonAnim(buttonDown)
	buttonDown:SetText("")
	buttonDown:Dock(RIGHT)
	buttonDown:DockMargin(0, 5, 5, 6)
	buttonDown:SetWide(29)
	buttonDown.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, false, true, false, true)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), false, true, false, true)
		draw.RoundedBox(0, 0, 0, 1, h, SD_SCOREBOARD_GMS.Colors.line)
	end
	buttonDown.DoClick = function()
		self:DataSetPos(data, index, "down")
	end
	self:AddImage(buttonDown, "down")

	local buttonUp = vgui.Create("DButton", panel)
	SD_SCOREBOARD_GMS.ButtonAnim(buttonUp)
	buttonUp:SetText("")
	buttonUp:Dock(RIGHT)
	buttonUp:DockMargin(0, 5, 0, 6)
	buttonUp:SetWide(29)
	buttonUp.Paint = function(this, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, true, false, true, false)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), true, false, true, false)
	end
	buttonUp.DoClick = function()	
		self:DataSetPos(data, index, "up")
	end
	self:AddImage(buttonUp, "up")
end
---------------------
-- Control buttons --
---------------------
function PANEL:ControllButton(color, panel, image)
	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(RIGHT)
	button:DockMargin(0, 5, 5, 6)
	button:SetWide(29)
	button.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, color)
	end
	self:AddImage(button, image)

	return button
end
------------
-- Header --
------------
function PANEL:AddHeader(panel, tbl)
	local lang = SD_SCOREBOARD_GMS.Language

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(TOP)
	panel:SetHeight(100)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

		draw.DrawText(lang[tbl[1]] or tbl[1], "sd_scoreboard_20_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		draw.DrawText(lang[tbl[2]] or tbl[2], "sd_scoreboard_16_100", 10 , 31, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT)
	end
	return panel	
end
-----------------
-- Pop-Up List --
-----------------
function PANEL:PopUpList(panel, basePanel, tbl, cfg, func)
	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(RIGHT)
	button:DockMargin(0, 2, 2, 2)
	button:SetWidth(button:GetTall()+4)
	button.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
	end
	button.DoClick = function()
		local base = vgui.Create("DPanel", basePanel)
		base:SetWide(250)
		base:SetZPos(2)
		SD_SCOREBOARD_GMS.Shadow(base, 8, false)

		local scroll = self:GetScroll(base)

		for k, v in ipairs(tbl) do
			local button = vgui.Create("DButton", scroll)
			SD_SCOREBOARD_GMS.ButtonAnim(button)
			button:Dock(TOP)
			button:SetText("")
			button:SetHeight(30)
			button.Paint = function(this, w, h)
				draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))
				if k != #tbl then draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2) end

				draw.DrawText(IsEntity(v) and v:IsPlayer() and v:Nick() or SD_SCOREBOARD_GMS.Language[v] and SD_SCOREBOARD_GMS.Language[v] or v, "sd_scoreboard_16_100", w/2 , 5, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
			end
			button.DoClick = function()
				func(cfg, v, basePanel, panel)
				base:Remove()
			end
		end

		base:SetHeight(#tbl*30 > basePanel:GetTall()/2 and basePanel:GetTall()/2 or #tbl*30)

		local x, y = basePanel:LocalCursorPos()
		
		local xOffset =  x+200 > basePanel:GetWide() and x-195 or x-5
		local yOffset = y-base:GetTall() < 0 and y-5 or (y-base:GetTall())+5

		base:SetPos(xOffset, yOffset)
		base.Paint = function(this, w, h)
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)

			local x, y = this:LocalCursorPos()
			if (x > w or x < 0) or (y > h or y < 0) then this:Remove() end 
		end
	end

	local image = vgui.Create("DImage", button)
	image:Dock(FILL)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.down)
end
--------------------------------
-- Categories groups settings --
--------------------------------
function PANEL:CategoriesGroupsEdit(panel, tbl, data, index, baseBanel)
	local line = vgui.Create("DPanel", panel)
	line:Dock(BOTTOM)
	line:DockMargin(0, 5, 5, 5)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local entry1 = self:AddEntry(line, LEFT, 170, "group", data and data[1] or "")
	local entry2 = self:AddEntry(line, FILL, 150, "name", data and data[2] or "")

	local createButton = vgui.Create("DButton", line)
	SD_SCOREBOARD_GMS.ButtonAnim(createButton)
	createButton:SetText("")
	createButton:Dock(RIGHT)
	createButton:DockMargin(5, 0, 0, 0)
	createButton:SetWide(60)
	createButton.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, true, true, true, true)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), true, true, true, true)

		draw.DrawText( !index and SD_SCOREBOARD_GMS.Language.create or SD_SCOREBOARD_GMS.Language.update, "sd_scoreboard_16_100", w/2 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end

	local color = self:AddColorButton(line)
	color.color = data and data[3] or Color(255,0,0)

	createButton.DoClick = function()
		self:SendDataToServer("groups", entry1:GetValue(), entry2:GetValue(), SD_SCOREBOARD_GMS.rgb2Hex(color.color), index or 0)
	end
end

function PANEL:CategoriesGroups(baseBanel, tbl)
	local header = self:AddHeader(baseBanel, tbl)

	local line = vgui.Create("DPanel", header)
	line:Dock(BOTTOM)
	line:DockMargin(0, 0, 0, 5)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local green = Color(0,255,0)

	local addButton = vgui.Create("DButton", line)
	addButton:SetText("")
	addButton:Dock(RIGHT)
	addButton:DockMargin(0, 0, 5, 0)
	addButton:SetWide(29)
	addButton.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, green)
	end
	addButton.DoClick = function()
		self:CategoriesGroupsEdit(self:AddEditablePanel(header, tbl), tbl, _, _,baseBanel)
	end
	self:AddImage(addButton, "add")

	local scroll = self:GetScroll(baseBanel)
	local poly = self:GetPoly()

	for k, v in ipairs(SD_SCOREBOARD_GMS.ServerConfig.groups or {}) do
		local color = Color(SD_SCOREBOARD_GMS.hex2rgb(v[3]))

		local panel = vgui.Create("DPanel", scroll)
		panel:Dock(TOP)
		panel:SetHeight(40)
		panel.Paint = function(this, w, h)
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
			draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

			surface.SetDrawColor(color)
			draw.NoTexture()
			surface.DrawPoly(poly)

			draw.DrawText( "["..v[1].."] - "..v[2], "sd_scoreboard_16_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		end

		self:ControllButton(Color(255,0,0), panel, "remove").DoClick = function()
			self:RemoveDataFromServer("groups", k)
		end

		self:ControllButton(Color(255,150,0), panel, "edit").DoClick = function()
			self:CategoriesGroupsEdit(self:AddEditablePanel(header, tbl), tbl, {v[1],v[2],color}, k, baseBanel)
		end

		self:PosButtons(tbl, "groups", panel, k)
	end
end
----------
-- Tabs --
----------
function PANEL:TabsEdit(panel, tbl, data, index, baseBanel, tabsType)
	local line = vgui.Create("DPanel", panel)
	line:Dock(BOTTOM)
	line:DockMargin(0, 5, 5, 5)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local entry1 = self:AddEntry(line, LEFT, 160, "name", data and data[1] or "")
	local entry2 = self:AddEntry(line, FILL, 150, tabsType, data and data[2] or "")

	local createButton = vgui.Create("DButton", line)
	SD_SCOREBOARD_GMS.ButtonAnim(createButton)
	createButton:SetText("")
	createButton:Dock(RIGHT)
	createButton:DockMargin(5, 0, 0, 0)
	createButton:SetWide(60)
	createButton.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, true, true, true, true)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), true, true, true, true)

		draw.DrawText(!index and SD_SCOREBOARD_GMS.Language.create or SD_SCOREBOARD_GMS.Language.update, "sd_scoreboard_16_100", w/2 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end

	local icon = self:AddIconButton(line)
	icon.img = data and data[3] or "web"

	createButton.DoClick = function()
		self:SendDataToServer(tabsType, entry1:GetValue(), entry2:GetValue(), icon.img, index or 0)
	end
end

function PANEL:Tabs(basePanel, tbl, tabsType)
	local header = self:AddHeader(basePanel, tbl)

	local line = vgui.Create("DPanel", header)
	line:Dock(BOTTOM)
	line:DockMargin(0, 0, 0, 5)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local green = Color(0,255,0)

	local addButton = vgui.Create("DButton", line)
	addButton:SetText("")
	addButton:Dock(RIGHT)
	addButton:DockMargin(0, 0, 5, 0)
	addButton:SetWide(29)
	addButton.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, green)
	end
	addButton.DoClick = function()
		self:TabsEdit(self:AddEditablePanel(header, tbl), tbl, _, _, basePanel, tabsType)
	end

	self:AddImage(addButton, "add")

	local scroll = self:GetScroll(basePanel)

	for k, v in ipairs(SD_SCOREBOARD_GMS.ServerConfig[tabsType] or {}) do
		local panel = vgui.Create("DPanel", scroll)
		panel:Dock(TOP)
		panel:SetHeight(40)
		panel.Paint = function(this, w, h)
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
			draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

			draw.DrawText( v[1], "sd_scoreboard_16_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		end

		self:ControllButton(Color(255,0,0), panel, "remove").DoClick = function()
			self:RemoveDataFromServer(tabsType, k)
		end

		self:ControllButton(Color(255,150,0), panel, "edit").DoClick = function()
			self:TabsEdit(self:AddEditablePanel(header, tbl), tbl, {v[1],v[2],v[3]}, k, basePanel, tabsType)
		end

		self:AddIconImage(panel, v[3])
		self:PosButtons(tbl, tabsType, panel, k)
	end
end
------------------
-- Hide players --
------------------
function PANEL:HidePlyEdit(panel, tbl, baseBanel)
	local line = vgui.Create("DPanel", panel)
	line:Dock(BOTTOM)
	line:DockMargin(0, 5, 5, 5)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local entry1 = self:AddEntry(line, FILL, 180, "SteamID", "")

	local createButton = vgui.Create("DButton", line)
	SD_SCOREBOARD_GMS.ButtonAnim(createButton)
	createButton:SetText("")
	createButton:Dock(RIGHT)
	createButton:DockMargin(5, 0, 0, 0)
	createButton:SetWide(60)
	createButton.Paint = function(this, w, h) 
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, true, true, true, true)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), true, true, true, true)

		draw.DrawText( SD_SCOREBOARD_GMS.Language.create, "sd_scoreboard_16_100", w/2 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	createButton.DoClick = function()
		local name = IsValid(player.GetBySteamID(entry1:GetValue())) and player.GetBySteamID(entry1:GetValue()):Nick() or "No name"
		self:SendDataToServer("hide", entry1:GetValue(), name, "", 0)
	end
end

function PANEL:HidePly(basePanel, tbl)
	local header = self:AddHeader(basePanel, tbl)

	local line = vgui.Create("DPanel", header)
	line:Dock(BOTTOM)
	line:DockMargin(0, 0, 0, 5)
	line:SetHeight(30)
	line.Paint = function(this, w, h) end

	local green = Color(0,255,0)

	local addButton = vgui.Create("DButton", line)
	addButton:SetText("")
	addButton:Dock(RIGHT)
	addButton:DockMargin(0, 0, 5, 0)
	addButton:SetWide(29)
	addButton.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, green)
	end
	addButton.DoClick = function()
		self:HidePlyEdit(self:AddEditablePanel(header, tbl), tbl, basePanel)
	end
	self:AddImage(addButton, "add")

	local scroll = self:GetScroll(basePanel)

	for k, v in ipairs(SD_SCOREBOARD_GMS.ServerConfig.hide or {}) do
		local panel = vgui.Create("DPanel", scroll)
		panel:Dock(TOP)
		panel:SetHeight(40)
		panel.Paint = function(this, w, h)
			draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
			draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

			draw.DrawText(v[1].." - "..v[2], "sd_scoreboard_16_100", 10 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
		end

		self:ControllButton(Color(255,0,0), panel, "remove").DoClick = function()
			self:RemoveDataFromServer("hide", k)
		end
	end	
end	
----------
-- Bool --
----------
function PANEL:AddBool(panel, name, data, index)
	local g = Color(0,255,0)
	local r = Color(255,0,0)

	local poly = self:GetPoly()

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(TOP)
	panel:SetHeight(40)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

		surface.SetDrawColor(SD_SCOREBOARD_GMS.ServerConfig.boolean[data] and g or r)
		draw.NoTexture()
		surface.DrawPoly(poly)

		draw.DrawText(SD_SCOREBOARD_GMS.Language[name] or name, "sd_scoreboard_16_100", 15 , 11, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
	end

	local button = vgui.Create("DButton", panel)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button:SetText("")
	button:Dock(RIGHT)
	button:DockMargin(0, 5, 5, 6)
	button:SetWide(110)
	button.Paint = function(this, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.buttonHovered, true, true, true, true)
		draw.RoundedBoxEx(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, this.anim.pos), true, true, true, true)

		draw.DrawText(SD_SCOREBOARD_GMS.ServerConfig.boolean[data] and SD_SCOREBOARD_GMS.Language.disable or SD_SCOREBOARD_GMS.Language.enable, "sd_scoreboard_16_100", w/2 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function()
		self:SendBoolToServer(data)
	end
end

function PANEL:AddCategory(panel, name)
	local panel = vgui.Create("DPanel", panel)
	panel:Dock(TOP)
	panel:SetHeight(30)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.listCategory)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line2)

		draw.DrawText(SD_SCOREBOARD_GMS.Language[name] or name, "sd_scoreboard_16_100", 10 , 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
	end
end

function PANEL:Bool(basePanel, tbl)
	local header = self:AddHeader(basePanel, tbl)
	local scroll = self:GetScroll(basePanel)

	if SD_SCOREBOARD_GMS.ServerConfig.boolean then 
		local category = {}

		for k, v in ipairs(SD_SCOREBOARD_GMS.Config.boolean) do
			if v[1] != tbl[1] then continue end

			if not category[v[4]] and v[4] != "" then
				category[v[4]] = true
				self:AddCategory(scroll, v[4])
			end

			self:AddBool(scroll, v[3], v[5], k)
		end
	end
end

vgui.Register("sd_scoreboard_admin_settings", PANEL)