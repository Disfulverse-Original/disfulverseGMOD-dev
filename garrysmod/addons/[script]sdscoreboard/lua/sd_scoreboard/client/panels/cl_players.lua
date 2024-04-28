local PANEL = {}

function PANEL:Init()
	self.padding = 45

	if SD_SCOREBOARD_GMS.fullScreen == 1 and ScrW() > 1200 then
		self.padding = 150
	end

	self:Header()
	self:HeaderColumn(self)
	self:InitBase()
end
------------------
-- Search panel --
------------------
function PANEL:Search(panel)
	local bool = false
	local animation = {pos = 255, start = 255, stop = 0, STime = 1}

	local base = vgui.Create("DPanel", panel)
	base:SetText("")
	base:Dock(RIGHT)
	base:DockMargin(0, 20, 0, 20)
	base:SetSize(45,0)
	base.Paint = function(this, w, h) 
		draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.panel, animation.pos))
	end
	-- entry --
	local entry = vgui.Create( "DTextEntry", base )
	entry:SetSize( 10, 30 )
	entry:Dock(FILL)
	entry:SetValue("")
	entry:SetFont("sd_scoreboard_16_100")
	entry:DockMargin(0, 3, 6, 0)
	entry:SetDrawLanguageID(false)
	entry.Paint = function (this, w, h)	
		this:DrawTextEntryText( SD_SCOREBOARD_GMS.Colors.mainText, SD_SCOREBOARD_GMS.Colors.subText, SD_SCOREBOARD_GMS.Colors.mainText)
		draw.DrawText(this:GetValue() == "" and SD_SCOREBOARD_GMS.Language.Search or "", "sd_scoreboard_16_100", 3, 11, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT) 
	end
	entry.OnLoseFocus = function( this ) 
		if IsValid(self) then 
			SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false) 
		end 
	end
	entry.OnGetFocus = function( this ) 
		SD_SCOREBOARD_GMS.PanelFocus()
	end
	entry.OnChange = function( this ) 
		self:InitBase()
	end
	self.entry = entry
	-- Close & Open button --
	local button = vgui.Create("DButton", base)
	button:SetText("")
	button:Dock(LEFT)
	button:SetSize(45,0)
	button.Paint = function(this, w, h) end

	button.Think = function(this, w, h)
		if animation.pos == animation.stop then return end

		animation.pos = Lerp(SD_SCOREBOARD_GMS.Easing((SysTime()-animation.STime)*3), animation.start, animation.stop)
		base:SetWide(math.Remap(animation.pos, 0, 255, 45, 200))
	end

	local image = vgui.Create("DImage", button )
	image:Dock(FILL)
	image:DockMargin(8, 8, 8, 8)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.search)

	button.DoClick = function() 
		bool = !bool
		if bool then 
			animation = {pos = 0, start = 0, stop = 255, STime = SysTime()}
			image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.delete)
		else
			animation = {pos = 255, start = 255, stop = 0, STime = SysTime()}
			image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.search)
			entry:SetValue("")
			self:InitBase()
		end
	end
end
----------------------------------------
-- Host name, player count and search --
--------------------------------------
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
		draw.DrawText(player.GetCount().."/"..game.MaxPlayers() , "sd_scoreboard_25_100", 100 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_RIGHT)
	end

	self:Search(header)

	local panel = vgui.Create("DPanel", header)
	panel:SetText("")
	panel:Dock(FILL)
	panel:DockMargin(0, 20, 0, 20)
	panel.Paint = function(this, w, h)
		draw.DrawText(SD_SCOREBOARD_GMS.ServerConfig.hostName or GetHostName() , "sd_scoreboard_25_100", 0 , 8, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end
end
------------------
-- Column names --
------------------
function PANEL:HeaderColumn(panel)
	local function AddColumn(panel, cfg)
		local panel = vgui.Create("DPanel", panel)
		panel:SetText("")
		panel:Dock(cfg.align)
		panel:SetSize(cfg.size, 30)
		panel.Paint = function(this, w, h)
			local textPos = cfg.textAlign == TEXT_ALIGN_CENTER and w/2 or cfg.textAlign == TEXT_ALIGN_LEFT and 0 or w

			DisableClipping(true)
				draw.DrawText(SD_SCOREBOARD_GMS.Language[cfg.id] or cfg.id, "sd_scoreboard_14_100", textPos, 8, SD_SCOREBOARD_GMS.Colors.subText, cfg.textAlign) 
			DisableClipping(false)
		end
		return panel
	end

	local base = AddColumn(panel, {id = "", align = TOP, size = 0})
	base:DockMargin(self.padding, 0, self.padding, 0)

	AddColumn(base, {id = "mute", align = RIGHT, size = 100, textAlign = TEXT_ALIGN_RIGHT})

	local columnCfg = {}

	for k, v in ipairs(SD_SCOREBOARD_GMS.Columns) do
		if not SD_SCOREBOARD_GMS.ServerConfig.boolean or SD_SCOREBOARD_GMS.ServerConfig.boolean[v.id] == false then continue end
		AddColumn(base,v)
	end
end
-----------------
-- base scroll --
-----------------
function PANEL:InitBase()
	self.data = {}

	if IsValid(self.scroll) then self.scroll:Remove() end

	self.scroll = vgui.Create("sd_scoreboard_scroll", self)
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(self.padding, 0, self.padding, 15)
	self.scroll:scrollBarEnable(false)

	self.PlyPanel = vgui.Create("DPanel", self.scroll)
	self.PlyPanel:SetText("")
	self.PlyPanel:Dock(TOP)
	self.PlyPanel:SetSize(30, 30)
	self.PlyPanel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.category)
	end

	SD_SCOREBOARD_GMS.Shadow(self.PlyPanel, 10, false)

	self:DataUpdate()
	self:PlyUpdate()
end
------------------
-- players list --
------------------
function PANEL:DataUpdate(panel)
	self.data.player = self.data.player or {}
		local hidePlyTable = {}
		if SD_SCOREBOARD_GMS.ServerConfig.hide then 
			for k, v in ipairs(SD_SCOREBOARD_GMS.ServerConfig.hide) do
				hidePlyTable[v[1]] = true
			end
		end
	for k, v in ipairs(player.GetAll()) do
		if hidePlyTable[v:SteamID()] then continue end

		if (self.entry:GetValue() != "") and !string.find(string.lower(v:Nick()), string.lower(self.entry:GetValue()),_,true) then continue end
		self:AddPlayer(v, self.PlyPanel)
	end
	self:PlySort()

	for k, v in pairs(self.data.player) do
		if !IsValid(k) then
			v.panel:Remove()
			self.data.player[k] = nil
		end
	end

	self.PlyPanel:InvalidateLayout(true)
	self.PlyPanel:SizeToChildren(false, true)
end
---------------
-- SortOrder --
---------------
function PANEL:PlySort()
	local cache = {}

	for k, v in pairs(self.data.player) do
		cache[#cache + 1] = {sort = v.sort != false and v.sort or 0, ply = k}
	end

	table.sort(cache, function(a, b) if a.sort > b.sort then return true end return false end)

	for k, v in ipairs(cache) do
		self.data.player[v.ply].panel:SetZPos(k)
	end
end
---------------------------------
-- Categories names and colors --
---------------------------------
function PANEL:GetCategoryCfg(ply)
	local cfg = SD_SCOREBOARD_GMS.ServerConfig
	local name, color, index

	if cfg.categoriesBy == "ByGroup" then

		name, color = ply:GetUserGroup(), Color(0,0,0,0)
		for k, v in ipairs(cfg.groups) do 
			if v[1] == ply:GetUserGroup() then 
				name = v[2] 
				color = Color(SD_SCOREBOARD_GMS.hex2rgb(v[3])) 
				index = k 
			end 
		end

	elseif cfg.categoriesBy == "ByTeam" then
		name = team.GetName(ply:Team()) color = team.GetColor(ply:Team()) 
	end

	return name or false, color or Color(0,0,0,0), index or 0
end
---------------------------------
-- Return categories to player --
---------------------------------
function PANEL:AddCategory(panel, name, color, index)
	self.data.category = self.data.category or {}

	if IsValid(self.data.category[name]) then return self.data.category[name] end

	local category = vgui.Create("DPanel", panel)
	category:SetText("")
	category:Dock(TOP)
	category:SetZPos(index)
	category:SetSize(100,120)
	category.Paint = function(this, w, h) end

	category.OnChildAdded = function(this)
		this:InvalidateLayout(true)
		this:SizeToChildren(false,true)
	end

	category.OnChildRemoved = function(this)
		if isstring(name) and category:ChildCount() == 1 then 
			category:SetHeight(0)
		else
			this:InvalidateLayout(true)
			this:SizeToChildren(false,true)
		end

		self.PlyPanel:InvalidateLayout(true)
		self.PlyPanel:SizeToChildren(false,true)
	end

	self.data.category[name] = category

	if !name then return category end

	local cfg = SD_SCOREBOARD_GMS.ServerConfig.categoriesBy
	local header = vgui.Create("DPanel", category)
	header:SetText("")
	header:Dock(TOP)
	header:DockMargin(0, 0, 0, 0)
	header:SetSize(100,25)
	header.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.categoryHeader)
		draw.RoundedBox(0, 0, 0, 3, h, color)

		draw.DrawText( name, "sd_scoreboard_14_100", 10 , 5, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT) 
	end
	return category
end
-----------------
-- Mute button --
-----------------
function PANEL:AddMute(ply, panel)
	local base = vgui.Create("DButton", panel)
	base:SetText("")
	base:Dock(RIGHT)
	base:DockMargin(0, 0, 0, 0)
	base:SetSize(100,120)
	base.Paint = function(this, w, h)end

	local image = vgui.Create("DImage", base )
	image:SetSize(26, 30)
	image:DockMargin(5, 5, 5, 5)
	image:Dock(RIGHT)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.mute)

	base.DoClick = function()
		if ply:IsMuted() then 
			ply:SetMuted(false)
			image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.mute)
		else 
			ply:SetMuted(true) 
			image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.ismute)
		end
	end
	if ply:IsMuted() then image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.ismute) else image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.mute) end
end
--------------------------
-- Player circle avatar --
--------------------------
function PANEL:AddAvatar(ply, panel)
	local avatar = vgui.Create("sd_circleavatar", panel)
	avatar:SetData( ply, 64, 40 )
	avatar:Dock(LEFT)
	avatar:DockMargin(5, 5, 5, 5)
	avatar:SetSize(25,25)
end
-------------------------------------
-- Adds column to the player panel --
-------------------------------------
function PANEL:PlayerColumn(ply, panel)
	self.data.player[ply] = self.data.player[ply] or {}
	self.data.player[ply].sort = self.data.player[ply].sort or 0
	self.data.player[ply].zpos = self.data.player[ply].zpos or 0

	local function AddColumn(ply, panel, cfg, index, data)
		local panel = vgui.Create("DPanel", panel)
		panel:SetText("")
		panel:Dock(cfg.align)
		panel:SetSize(cfg.size, 30)
		panel.Paint = function(this, w, h)
			if data[index] then 
				local textPos = cfg.textAlign == TEXT_ALIGN_CENTER and w/2 or cfg.textAlign == TEXT_ALIGN_LEFT and 0 or w
				if data[index][2] then
					draw.DrawText(data[index][1], "sd_scoreboard_14_100", textPos, 5, SD_SCOREBOARD_GMS.Colors.mainText, cfg.textAlign)
					draw.DrawText(data[index][2], "sd_scoreboard_14_100", textPos, 18, SD_SCOREBOARD_GMS.Colors.subText, cfg.textAlign)
				else
					draw.DrawText(data[index][1], "sd_scoreboard_14_100", textPos, 12, SD_SCOREBOARD_GMS.Colors.mainText, cfg.textAlign)
				end
			end
		end
	end

	local function GetData(ply)
		self.data.player[ply].column = self.data.player[ply].column or {}

		for k, v in ipairs(SD_SCOREBOARD_GMS.Columns) do
			local main, sub, sort = v.text(ply, self)
			self.data.player[ply].column[k] = {main, sub}

			if (v.id == SD_SCOREBOARD_GMS.ServerConfig.sortBy) then self.data.player[ply].sort = sort and sort or main end
		end
	end

	if self.data.player[ply].column then GetData(ply) return end

	self:AddMute(ply, panel)
	self:AddAvatar(ply, panel)

	GetData(ply)

	for k, v in ipairs(SD_SCOREBOARD_GMS.Columns) do
		if not SD_SCOREBOARD_GMS.ServerConfig.boolean or SD_SCOREBOARD_GMS.ServerConfig.boolean[v.id] == false then continue end
		AddColumn(ply, panel, v, k, self.data.player[ply].column)
	end
end
-----------------------
-- Adds player panel --
-----------------------
function PANEL:AddPlayer(ply, panel)
	self.data.player[ply] = self.data.player[ply] or {}

	local data = self.data.player[ply]
	if ispanel(data.panel) and (data.panel:GetParent() != self.data.category[self:GetCategoryCfg(ply)]) then
		local name, color, index = self:GetCategoryCfg(ply)
		data.panel:SetParent(self:AddCategory(panel, name, color, index))
	end

	if self.data.player[ply] and self.data.player[ply].panel then self:PlayerColumn(ply, data.panel) return end 

	local name, color, index = self:GetCategoryCfg(ply)
	local category = self:AddCategory(panel, name, color, index)
	local panel = vgui.Create("DButton", category)
	panel:SetText("")
	panel:Dock(TOP)
	panel:SetSize(100,35)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, 1, SD_SCOREBOARD_GMS.Colors.playerLine)
	end

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:SetZPos(1)
	button.Paint = function(this, w, h) end
	button.Think = function(this) this:SetSize(panel) 
		local x, y = panel:GetSize()
		this:SetSize(x-100, y) 
	end

 	button.DoClick = function()
 		self.profile = vgui.Create("sd_scoreboard_profile", self)
 		self.profile:SetPlayer(ply)
 	end
 		button.DoRightClick = function()
		self:RightClick(panel, ply)
	end

	self:PlayerColumn(ply, panel)
	self.data.player[ply].panel = panel

	category:InvalidateLayout(true)
	category:SizeToChildren(false,true)
end
------------------
-- Update Timer --
------------------
function PANEL:PlyUpdate() 
	timer.Create( "PlyUpdateDa", 1, 0, function() 
		if IsValid(self.scroll) then self:DataUpdate() else timer.Remove("PlyUpdateDa") end
	end)
end
----------------------
-- Right click menu --
----------------------
function PANEL:RightClickCategory(panel, name)
	local panel = vgui.Create("DPanel", panel )
	panel:SetText("")
	panel:Dock(TOP)
	panel:SetSize(0,25)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.listCategory)
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line)

		draw.DrawText(SD_SCOREBOARD_GMS.Language[name] or name, "sd_scoreboard_16_100", 10, 4, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)		
	end
end

function PANEL:RightClickAddButton(panel, name, ply, func, act)
	local button = vgui.Create("DButton", panel )
	button:SetText("")
	button:Dock(TOP)
	button:SetSize(0,30)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))
		draw.RoundedBox(0, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.line)

		draw.DrawText(SD_SCOREBOARD_GMS.Language[name] or name, "sd_scoreboard_16_100", w/2, 6, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)		
	end	
	button.DoClick = function()
		func(ply, self, name, act)
		panel:Remove()
	end
end

function PANEL:RightClick(panel, ply)
	if not IsValid(ply) then return end

	local ContextMenu = vgui.Create("DPanel", self )
	ContextMenu:SetText("")
	ContextMenu:SetWidth(200)
	ContextMenu:SetZPos(8)
	ContextMenu.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)

		local x, y = this:LocalCursorPos()
		if (x > (w+5)) or (x < -5) or (y > (h+5)) or (y < -5) then this:Remove() end
	end
	SD_SCOREBOARD_GMS.Shadow(ContextMenu, 10, false)
	-- add common cmds --
	self:RightClickCategory(ContextMenu, SD_SCOREBOARD_GMS.Language.common)

	self:RightClickAddButton(ContextMenu, SD_SCOREBOARD_GMS.Language.openSteam, ply, function(ply) 
		if !IsValid(ply) then return end
		ply:ShowProfile() 
	end)

	self:RightClickAddButton(ContextMenu, SD_SCOREBOARD_GMS.Language.copySteamID, ply, function(ply) 
		if !IsValid(ply) then return end
		SetClipboardText(ply:SteamID()) 
	end)
	-- add ulx cmds --
	local cfg = SD_SCOREBOARD_GMS.ServerConfig.boolean or {}
	if cfg.ulx and ULib then
		local cmdslist = {["teleport"] = true, ["goto"] = true}
		local category = false

		for k, v in pairs(ULib.cmds.translatedCmds) do
			local name = string.gsub(k, "ulx ", "")
			if not LocalPlayer():query(v.cmd) or !cmdslist[name] then continue end

			if !category then 
				self:RightClickCategory(ContextMenu, "ULX") 
				category = true 
			end

			self:RightClickAddButton(ContextMenu, name, ply, function(ply, _, name)
				if !IsValid(ply) then return end
				ULib.cmds.execute({},LocalPlayer(), "ulx", {string.gsub(name, "ulx ", ""), ply:Nick()}) 
			end)
		end
	end
	-- add fadmin cmds --
	if cfg.fadmin and FAdmin then
		local cmdslist = {["Teleport"] = true, ["Spectate"] = true, ["Goto"] = true, ["Kick"] = true, ["Ban"] = true}
		local category = false

		for k, v in ipairs(FAdmin.ScoreBoard.Player.ActionButtons) do
			if not (isfunction(v.Visible) and v.Visible(ply)) then continue end

			local name = isfunction(v.Name) and v.Name(ply) or v.Name
			if not cmdslist[name] then continue end

			if !category then
				self:RightClickCategory(ContextMenu,"FAdmin") 
				category = true 
			end

			self:RightClickAddButton(ContextMenu, string.lower(name), ply, function(ply, self, name, act) 
				if !IsValid(ply) then return end
				act(ply, self) 
			end, v.Action)
		end
	end

	-- add xAdmin cmds --
	if cfg.xadmin and xAdmin and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		local cmdslist = {"goto", "teleport", "bring", "return", "god", "noclip", "ragdoll"}

		self:RightClickCategory(ContextMenu,"xAdmin") 

		for k, v in ipairs(cmdslist) do
			self:RightClickAddButton(ContextMenu, v, ply, function()
				if !IsValid(ply) then return end
				RunConsoleCommand("xadmin", v, ply:SteamID())
			end)
		end
	end

	-- add sadmin cmds --
	if cfg.sadmin and sAdmin and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		local cmdslist = {"goto", "teleport"}

		self:RightClickCategory(ContextMenu,"sAdmin")

		for k, v in ipairs(cmdslist) do
			self:RightClickAddButton(ContextMenu, v, ply, function()
				if !IsValid(ply) then return end
				RunConsoleCommand("sa", v, ply:SteamID())
			end)
		end
	end

	-- add sam cmds --
	if cfg.sam and sam and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		local cmdslist = {"goto", "bring", "return", "respawn"}

		self:RightClickCategory(ContextMenu,"SAM Admin Mod") 

		for k, v in ipairs(cmdslist) do
			self:RightClickAddButton(ContextMenu, v, ply, function()
				if !IsValid(ply) then return end
				RunConsoleCommand("sam", v, ply:SteamID())
			end)
		end
	end

	ContextMenu:InvalidateLayout(true)
	ContextMenu:SizeToChildren(false,true)

	local x, y = self:GetSize()
	local xc, yc = self:LocalCursorPos()
	local xp, yp = ContextMenu:GetSize()

	if yc > y/2 then 
		ContextMenu:SetPos(xc, yc - yp)
	else
		ContextMenu:SetPos(xc, yc)
	end
end

vgui.Register("sd_scoreboard_players", PANEL)