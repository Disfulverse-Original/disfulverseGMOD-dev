local PANEL = {}

function PANEL:Init()
	self:SetSize(self:GetParent():GetSize())
end
----------------
-- Set Player --
----------------
function PANEL:SetPlayer(ply) 
	self:CreateBackground(ply)
end
-----------------------
-- Create base panel --
-----------------------
function PANEL:CreateBackground(ply)
	local background = vgui.Create("DButton", self)
	background:SetText("")
	background:Dock(FILL)
	background.Paint = function(this, w, h) end

	self:CreateProfile(ply, background)
end
-------------------------
-- Create profile base --
-------------------------
function PANEL:CreateProfile(ply, bkg)
	local base = vgui.Create("DPanel", bkg)
	base:SetWidth(310)
	base:SetHeight(bkg:GetParent():GetTall())
	base:SetPos(-base:GetWide(),0)
	base.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
	end
	SD_SCOREBOARD_GMS.Shadow(base, 10, false)
	
	self.MainPanel = base

	base.anim = {start = base:GetPos(), stop = 0, STime = SysTime()}

	bkg.DoClick = function()
		base.anim = {start = base:GetPos(), stop = -base:GetWide(), STime = SysTime()}
	end

	base.Think = function(this)
		local time = SD_SCOREBOARD_GMS.Easing((SysTime() - base.anim.STime)*4)
		base:SetPos(Lerp(time, base.anim.start, base.anim.stop),0)

		if base.anim.stop < 0 and time >= 1 then self:Remove() end
	end

	local panel = vgui.Create("DPanel", base)
	panel:Dock(TOP)
	panel.Paint = function(this, w, h) end
	SD_SCOREBOARD_GMS.Shadow(panel, 10, false)

	local headerButton = self:CreateHeader(ply, panel)

	headerButton.DoClick = function()
		bkg:DoClick()
	end

	local line = self:AddButtonLine(panel)

	self:AddButton(line, SD_SCOREBOARD_GMS.Language.report, LEFT, function()
		self:EntryPanel(ply, self:PopUp(SD_SCOREBOARD_GMS.Language.report, 2), {SD_SCOREBOARD_GMS.Language.reason}, function(tbl)
			if not IsValid(ply) then return end

			net.Start( "sd_scoreboard_rp" )
			net.WriteEntity(ply)
			net.WriteString(tbl[1]:GetValue())
			net.SendToServer()
		end)
	end)

	self:AddButton(line, SD_SCOREBOARD_GMS.Language.commands, RIGHT, function()
		self:CommandsPanel(ply, self:PopUp(SD_SCOREBOARD_GMS.Language.commands, 2), background, panel:GetParent())
	end)

	self:AddSecondaryButton(SD_SCOREBOARD_GMS.Language.copySteamID, panel, function()
		if not IsValid(ply) then return end 
		SetClipboardText(ply:SteamID()) 
	end)
	self:AddSecondaryButton(SD_SCOREBOARD_GMS.Language.copySteamID64, panel, function()
		if not IsValid(ply) then return end
		SetClipboardText(ply:SteamID64()) 
	end)
	self:AddSecondaryButton(SD_SCOREBOARD_GMS.Language.openSteam, panel, function()
		if not IsValid(ply) then return end 
		ply:ShowProfile() 
	end)

	panel:InvalidateLayout(true)
	panel:SizeToChildren(false,true)
end

function PANEL:GetMainPanel()
	return self.MainPanel
end
-----------------------
-- Secondary buttons --
-----------------------
function PANEL:AddSecondaryButton(name, panel, func)

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(TOP)
	button:SetHeight(30)
	button:DockMargin(0, 1, 0, 0)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))

		draw.DrawText(name, "sd_scoreboard_14_100", 15, 8, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT)
	end
	button.DoClick = function(this)
		func()
	end
end
------------------
-- Header panel --
------------------
function PANEL:AddPlyText(panel, name, text, size, font, color)
	local panel = vgui.Create("DPanel", panel)
	panel:SetText("")
	panel:Dock(TOP)
	panel:SetHeight(size)
	panel.Paint = function(this, w, h)
		draw.DrawText(name, font, 15, 4, color, TEXT_ALIGN_LEFT)
		draw.DrawText(text, font, w-15, 4, color, TEXT_ALIGN_RIGHT)
	end	
end

function PANEL:CreateHeader(ply, panel, background)
	local base = vgui.Create("DPanel", panel)
	base:SetText("")
	base:Dock(TOP)
	base:SetHeight(300)
	base.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
	end

	local blurBase = vgui.Create("DPanel", base)
	blurBase:SetText("")
	blurBase:Dock(TOP)
	blurBase:SetHeight(150)
	blurBase.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
	end

	local avatar = vgui.Create("AvatarImage", blurBase)
	avatar:SetPos(0, -75)
	avatar:SetSize(310,310)
	avatar:SetPlayer(ply, 128)

	local BlurColor = Color(0,0,0,200)

	local blur = vgui.Create("DPanel", avatar)
	blur:Dock(FILL)
	blur.Paint = function (this, w, h)
		draw.RoundedBoxEx(0, 0, 0, w, h, BlurColor, true, true, false, false)
		SD_SCOREBOARD_GMS.Blur(w, h, this)
		SD_SCOREBOARD_GMS.Circle(w/2, 225, 44, 32, SD_SCOREBOARD_GMS.Colors.panel2)
	end

	local panel = vgui.Create("DPanel", blurBase)
	panel:Dock(TOP)
	panel:SetHeight(60)
	panel.Paint = function(this, w, h) end

	self:CreateLikesPanel(ply, panel)

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(RIGHT)
	button:SetWidth(60)
	button.Paint = function(this, w, h) end

	local image = vgui.Create("DImage", button )
	image:Dock(FILL)
	image:DockMargin(15, 15, 15, 15)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.arrowWhite)

	self:AddPlyText(base,"", "", 50, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.mainText)

	local avatar = vgui.Create("sd_circleavatar", base)
	avatar:SetData(ply, 80, 80)
	avatar:DockMargin(5, 5, 5, 5)
	avatar:SetPos(115, 110)
	avatar:SetSize(80, 80 )

	self:AddPlyText(base, SD_SCOREBOARD_GMS.Language.UserName, ply:Nick(), 25, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.mainText)
	self:AddPlyText(base, "SteamID", ply:SteamID(), 25, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.subText)
	self:AddPlyText(base, SD_SCOREBOARD_GMS.Language.userGroups, ply:GetUserGroup(), 25, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.subText)

	if DarkRP then 
		self:AddPlyText(base, SD_SCOREBOARD_GMS.Language.jobs, ply:getDarkRPVar("job"), 25, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.subText)

		if LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() then
			self:AddPlyText(base, SD_SCOREBOARD_GMS.Language.Money, DarkRP.formatMoney(ply:getDarkRPVar("money")), 25, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.subText)
		end
	end

	self:AddPlyText(base,"", "", 10, "sd_scoreboard_16_100", SD_SCOREBOARD_GMS.Colors.mainText)

	base:InvalidateLayout(true)
	base:SizeToChildren(false,true)

	return button
end
-----------------
-- Like button --
-----------------
function PANEL:GetLikes(ply)
	net.Start("sd_scoreboard_gl")
	net.WriteEntity(ply)
	net.SendToServer()
end

function PANEL:CreateLikesPanel(ply, panel)
	local likes = 0

	local panel = vgui.Create("DPanel", panel)
	panel:Dock(LEFT)
	panel:SetWidth(155)
	panel.Paint = function(this, w, h)
		draw.DrawText( likes, "sd_scoreboard_16_100", 55, 22, SD_SCOREBOARD_GMS.Colors.whiteText, TEXT_ALIGN_LEFT)
	end

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(LEFT)
	button:SetWidth(60)
	button.Paint = function(this, w, h) end
	button.DoClick = function(this)
		if not IsValid(ply) then return end

		net.Start( "sd_scoreboard_sl" )
    	net.WriteEntity(ply)
   		net.SendToServer()

   		self:GetLikes(ply)
	end

	local image = vgui.Create("DImage", button )
	image:Dock(FILL)
	image:DockMargin(15, 15, 15, 15)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.likesFalse)

	self:GetLikes(ply)

	net.Receive("sd_scoreboard_gl", function()
		likes = net.ReadUInt(31)

		if net.ReadBool() then 
			if IsValid(image) then
				image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.likesTrue)
			end
		end
	end)
end
-----------------
-- PopUp Panel --
-----------------
function PANEL:PopUp(name, zPos)
	local STime = SysTime()
	local bool = true

	local pos = 0

	local base = vgui.Create("DPanel", self:GetMainPanel():GetParent())
	base:SetText("")
	base:SetZPos(-2)
	base:SetSize(310, self:GetTall())
	base.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
	end

	local scroll = vgui.Create("sd_scoreboard_scroll", base)
	scroll:SetSize(base:GetSize())
	scroll:Dock(FILL)

	scroll.Close = function() 
		STime = SysTime()
		bool = true
	end

	local header = vgui.Create("DButton", base)
	header:SetText("")
	header:Dock(TOP)
	header:SetHeight(59)
	header.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.DrawText( name, "sd_scoreboard_20_100", 15, 20, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end
	header.DoClick = function(this)
		scroll:Close()
	end

	local image = vgui.Create("DImage", header)
	image:Dock(RIGHT)
	image:DockMargin(15, 15, 15, 15)
	image:SetWidth(30)
	image:SetMaterial(SD_SCOREBOARD_GMS.Colors.icons.arrowBack)

	base.Think = function(this)
		local time = (SysTime() - STime)*8 >= math.pi and math.pi or (SysTime() - STime)*8

		this:SetPos(self:GetMainPanel():GetPos()+math.sin(time)*base:GetWide(), 0)

		if time >= math.pi and base:GetZPos() != zPos then base:Remove() end
		if bool and time >= math.pi/2 then 
			base:SetZPos(base:GetZPos() == zPos and -2 or zPos) 
			bool = false
		end
	end

	return scroll
end
-------------
-- buttons --
-------------
function PANEL:AddButtonLine(panel)
	local panel = vgui.Create("DButton", panel)
	panel:SetText("")
	panel:Dock(TOP)
	panel:SetHeight(45)
	panel.Paint = function(this, w, h) end

	return panel
end
function PANEL:AddButton(panel, name, dock, func)
	local size = dock == LEFT and 155 or 154

	local button = vgui.Create("DButton", panel)
	button:SetText("")
	button:Dock(dock)
	button:DockMargin(0, 1, 0, 0)
	button:SetWidth(size)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))

		draw.DrawText(name, "sd_scoreboard_16_100", w/2, 14, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function(this)
		func()
	end
end
-----------------
-- Entry panel --
-----------------
function PANEL:AddEntry(name, panel)
	local panel = vgui.Create("DPanel", panel)
	panel:Dock(TOP)
	panel:SetHeight(89)
	panel:DockMargin(0, 1, 0, 0)
	panel.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
		draw.DrawText(name, "sd_scoreboard_16_100", 17, 14, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end

	local entry = vgui.Create("DTextEntry", panel)
	entry:SetSize(10, 30)
	entry:Dock(TOP)
	entry:SetValue("")
	entry:SetFont("sd_scoreboard_16_100")
	entry:DockMargin(15, 40, 15, 20)
	entry:SetDrawLanguageID(false)
	entry.Paint = function (this, w, h)	
		this:DrawTextEntryText(SD_SCOREBOARD_GMS.Colors.mainText, SD_SCOREBOARD_GMS.Colors.subText, SD_SCOREBOARD_GMS.Colors.mainText)
		draw.RoundedBox(4, 0, h-1, w, 1, SD_SCOREBOARD_GMS.Colors.subText)
		draw.DrawText(this:GetValue() == "" and SD_SCOREBOARD_GMS.Language.enterText or "", "sd_scoreboard_16_100", 3, 7, SD_SCOREBOARD_GMS.Colors.subText, TEXT_ALIGN_LEFT) 
	end
	entry.OnLoseFocus = function(this)
		SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false) 
	end
	entry.OnGetFocus = function(this)
		SD_SCOREBOARD_GMS.PanelFocus()
	end
	entry.OnEnter = function(this) end

	return entry
end

function PANEL:EntryPanel(ply, BasePanel, tbl, func, mainTable)
	local entryTable = {}

	local base = vgui.Create("DPanel", BasePanel)
	base:Dock(TOP)
	base:SetHeight(89)
	base:DockMargin(0, 0, 0, 0)
	base.Paint = function(this, w, h) end
	SD_SCOREBOARD_GMS.Shadow(base, 10, false)

	for k, v in ipairs(tbl) do
		entryTable[k] = self:AddEntry(v, base)
	end

	local line = self:AddButtonLine(base)

	self:AddButton(line, SD_SCOREBOARD_GMS.Language.cancel, LEFT, function() BasePanel.Close() end)
	self:AddButton(line, SD_SCOREBOARD_GMS.Language.ok, RIGHT, function() BasePanel.Close() func(entryTable, ply, mainTable) end)

	base:InvalidateLayout(true)
	base:SizeToChildren(false,true)
end
----------
-- CMDs --
----------
function PANEL:AddCmdsButton(ply, panel, name, func)
	local button = vgui.Create("DButton")
	button:SetText("")
	button:Dock(FILL)
	SD_SCOREBOARD_GMS.ButtonAnim(button)
	button.Paint = function(this, w, h)
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
		draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(SD_SCOREBOARD_GMS.Colors.buttonHovered, this.anim.pos))
		draw.DrawText(name, "sd_scoreboard_14_100", w/2, 7, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_CENTER)
	end
	button.DoClick = function()
		func()
	end

	panel:AddItem(button)
end

function PANEL:AddCmdsGrid(panel)
	local grid = vgui.Create("sd_scoreboard_grid",panel)
	grid:Dock(TOP)
	grid:DockMargin(0, 1, 0, 0)
	grid:SetColHeight(30)
	grid:SetMargin(1,1)
	grid:SetCol(2)

	return grid
end

function PANEL:CommandsPanel(ply, panel, background, parent)
	local base = vgui.Create("DPanel", panel)
	base:SetSize(panel:GetSize())
	base:Dock(TOP)
	base:SetHeight(89)
	base:DockMargin(0, 0, 0, 0)
	base.Paint = function(this, w, h) end

	base.buttonCount = 0
	base.line = nil

	SD_SCOREBOARD_GMS.Shadow(base, 10, false)

	local cfg = SD_SCOREBOARD_GMS.ServerConfig.boolean or {}
	-- Add FAdmin commands --
	if cfg.fadmin and FAdmin then
		local entry = self:AddCmdsHeader(base,"FAdmin")
		local grid = self:AddCmdsGrid(base,"FAdmin")

		entry.OnChange = function(this)
			if !IsValid(ply) then return end

			grid:Clear()
			self:AddFAdminCmds(grid,ply,entry:GetValue())

			base:InvalidateLayout(true)
			base:SizeToChildren(false,true)
		end

		entry:OnChange()
	end
	-- Add ulx commands --
	if cfg.ulx and ULib then
		local entry = self:AddCmdsHeader(base,"ULX")
		local grid = self:AddCmdsGrid(base,"ULX")

		entry.OnChange = function(this)
			if !IsValid(ply) then return end
			
			grid:Clear()
			self:AddULXCmds(grid,ply,entry:GetValue())

			base:InvalidateLayout(true)
			base:SizeToChildren(false, true)
		end

		entry:OnChange()
	end

	-- add xAdmin cmds --
	if cfg.xadmin and xAdmin and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		local entry = self:AddCmdsHeader(base,"xAdmin")
		local grid = self:AddCmdsGrid(base,"xAdmin")

		entry.OnChange = function(this)
			if !IsValid(ply) then return end
			
			grid:Clear()
			self:AddxAdminCmds(grid,ply,entry:GetValue())

			base:InvalidateLayout(true)
			base:SizeToChildren(false, true)
		end

		entry:OnChange()
	end
	-- add sAdmin cmds --
	if cfg.sadmin and sAdmin and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		local entry = self:AddCmdsHeader(base,"sAdmin")
		local grid = self:AddCmdsGrid(base,"sAdmin")

		entry.OnChange = function(this)
			if !IsValid(ply) then return end
			
			grid:Clear()
			self:AddsAdminCmds(grid,ply,entry:GetValue())

			base:InvalidateLayout(true)
			base:SizeToChildren(false, true)
		end

		entry:OnChange()
	end

	-- add SAM Admin Mod cmds --
	if cfg.sam and sam and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
		local entry = self:AddCmdsHeader(base,"SAM")
		local grid = self:AddCmdsGrid(base,"SAM")

		entry.OnChange = function(this)
			if !IsValid(ply) then return end
			
			grid:Clear()
			self:AddSamAdminCmds(grid,ply,entry:GetValue())

			base:InvalidateLayout(true)
			base:SizeToChildren(false, true)
		end

		entry:OnChange()
	end
end

function PANEL:AddCmdsHeader(panel,name,zpos)
	local header = vgui.Create("DPanel", panel)
	header:SetZPos(zpos)
	header:Dock(TOP)
	header:SetHeight(44)
	header:DockMargin(0,1,0,0)
	header.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel2)
		draw.DrawText(name, "sd_scoreboard_16_100", 17, 14, SD_SCOREBOARD_GMS.Colors.mainText, TEXT_ALIGN_LEFT)
	end

	local panel = vgui.Create("DPanel", header)
	panel:Dock(RIGHT)
	panel:SetWide(200)
	panel:DockMargin(0,5,5,5)
	panel.Paint = function(this, w, h) 
		draw.RoundedBox(0, 0, 0, w, h, SD_SCOREBOARD_GMS.Colors.panel)
	end

	local entry = vgui.Create( "DTextEntry", panel)
	entry:Dock(FILL)
	entry:SetWide(100)
	entry:SetFont("sd_scoreboard_16_100")
	entry:DockMargin(5,0,5,0)
	entry:SetDrawLanguageID(false)
	entry.Paint = function (this, w, h)	
		this:DrawTextEntryText(SD_SCOREBOARD_GMS.Colors.mainText, SD_SCOREBOARD_GMS.Colors.subText, SD_SCOREBOARD_GMS.Colors.mainText)
		draw.DrawText(this:GetValue() == "" and SD_SCOREBOARD_GMS.Language.SearchCmds or "","sd_scoreboard_16_100",3,10,SD_SCOREBOARD_GMS.Colors.subText,TEXT_ALIGN_LEFT) 
	end
	entry.OnLoseFocus = function( this ) 
		if IsValid(self) then 
			SD_SCOREBOARD_GMS.BasePanel:SetKeyboardInputEnabled(false) 
		end
	end
	entry.OnGetFocus = function( this ) 
		SD_SCOREBOARD_GMS.PanelFocus()
	end

	return entry
end

function PANEL:AddSamAdminCmds(panel,ply,filter)
	local cmdsNoArg = {
		{"Goto","goto"},
		{"Bring","bring"},
		{"Return","return"},
		{"Mute","mute","Minutes (0 for permament)","Reason"},
		{"Unmute","unmute"},
		{"Gag","gag","Minutes (0 for permament)","Reason"},
		{"Ungag","ungag"},
		{"jail","jail","Minutes (0 for permament)","Reason"},
		{"Unjail","unjail"},
		{"Kick","kick","Reason"},
		{"Ban","ban","Minutes (0 for permament)","Reason"},
		{"Freeze","freeze"},
		{"Unfreeze","unfreeze"},
		{"Slay","slay"},
		{"Slap","slap","Damage"},
		{"God","god"},
		{"UnGod","ungod"},
		{"Noclip","noclip"},
		{"Strip Weapons","strip"},
		{"Set Health","hp","Health"},
		{"Set Armor","armor","Armor"},
		{"Ignite","ignite"},
		{"UnIgnite","unignite"},
		{"Respawn","respawn"},
		{"Give Ammo","giveammo","Ammo"},
		{"Scale","scale","Scale"},
		{"Exit","exit"},
	}

	for k, v in ipairs(cmdsNoArg) do
		if filter != "" and !string.find(string.lower(v[1]),string.lower(filter),_,true) then continue end

		if #v == 2 then
			self:AddCmdsButton(ply, panel, v[1], function()
				if !IsValid(ply) then return end
				RunConsoleCommand("sam", v[2], ply:SteamID())
			end)
		elseif #v == 3 then
			self:AddCmdsButton(ply, panel, v[1], function()
				self:EntryPanel(ply, self:PopUp(k, 3), {v[3]}, function(tbl)
					if !IsValid(ply) then return end
					RunConsoleCommand("sam", v[2], ply:SteamID(), tbl[1]:GetValue())
				end)
			end)			
		elseif #v == 4 then
			self:AddCmdsButton(ply, panel, v[1], function()
				self:EntryPanel(ply, self:PopUp(k, 3), {v[3], v[4]}, function(tbl)
					if !IsValid(ply) then return end
					RunConsoleCommand("sam", v[2], ply:SteamID(), tbl[1]:GetValue(), tbl[2]:GetValue())
				end)
			end)
		end
	end
end

function PANEL:AddxAdminCmds(panel,ply,filter)
	local cmdsNoArg = {
		{"Teleport","teleport"},
		{"Goto","goto"},
		{"Bring","bring"},
		{"Return","return"},
		{"Mute","mute","Minutes (0 for permament)","Reason"},
		{"Unmute","unmute"},
		{"Gag","gag","Minutes (0 for permament)","Reason"},
		{"Ungag","ungag"},
		{"jail","jail","Minutes (0 for permament)","Reason"},
		{"Unjail","unjail"},
		{"Kick","kick","Reason"},
		{"Ban","ban","Minutes (0 for permament)","Reason"},
		{"Freeze","freeze","Minutes (0 for permament)","Reason"},
		{"Unfreeze","unfreeze"},
		{"Slay","slay","Reason"},
		{"Admin Mode","adminmode"},
		{"Set RP Name","setrpname","RP Name"},
		{"Set Speed","setspeed","Speed"},
		{"Set Money","setmoney","Money"},
		{"Set Health","sethealth","Health"},
		{"Set Armour","setarmour","Armour"},
		{"God","god"},
		{"Noclip","noclip"},
		{"Strip Weapons","strip"},
		{"Reset speed","resetspeed"},
		{"Ragdoll","ragdoll"},
	}

	for k, v in ipairs(cmdsNoArg) do
		if filter != "" and !string.find(string.lower(v[1]),string.lower(filter),_,true) then continue end

		if #v == 2 then
			self:AddCmdsButton(ply, panel, v[1], function()
				if !IsValid(ply) then return end
				RunConsoleCommand("xadmin", v[2], ply:SteamID())
			end)
		elseif #v == 3 then
			self:AddCmdsButton(ply, panel, v[1], function()
				self:EntryPanel(ply, self:PopUp(k, 3), {v[3]}, function(tbl)
					if !IsValid(ply) then return end
					RunConsoleCommand("xadmin", v[2], ply:SteamID(), tbl[1]:GetValue())
				end)
			end)			
		elseif #v == 4 then
			self:AddCmdsButton(ply, panel, v[1], function()
				self:EntryPanel(ply, self:PopUp(k, 3), {v[3], v[4]}, function(tbl)
					if !IsValid(ply) then return end
					RunConsoleCommand("xadmin", v[2], ply:SteamID(), tbl[1]:GetValue(), tbl[2]:GetValue())
				end)
			end)
		end
	end
end

function PANEL:AddsAdminCmds(panel,ply,filter)
	local cmdsNoArg = {
		{"Teleport","teleport"},
		{"Goto","goto"},
	}

	for k, v in ipairs(cmdsNoArg) do
		if filter != "" and !string.find(string.lower(v[1]),string.lower(filter),_,true) then continue end

		self:AddCmdsButton(ply, panel, v[1], function()
			if !IsValid(ply) then return end
			RunConsoleCommand("sa", v[2], ply:SteamID())
		end)
	end
end

function PANEL:AddFAdminCmds(panel,ply,filter)
	if !IsValid(ply) then return end

	for k, v in ipairs(FAdmin.ScoreBoard.Player.ActionButtons) do
		if not (isfunction(v.Visible) and v.Visible(ply)) then continue end

		local name = isfunction(v.Name) and v.Name(ply) or v.Name
		if filter != "" and !string.find(string.lower(name),string.lower(filter),_,true) then continue end

		self:AddCmdsButton(ply, panel, name, function()
			if !IsValid(ply) then return end
			v.Action(ply, self)
		end)
	end
end

function PANEL:AddULXCmds(panel,ply,filter)
	if !IsValid(ply) then return end
	
	for k, v in pairs(ULib.cmds.translatedCmds) do

	if filter != "" and !string.find(string.lower(k),string.lower(filter),_,true) then continue end

	if not LocalPlayer():query(v.cmd) then continue end
	if not (v.args[2] and (v.args[2].type == ULib.cmds.PlayersArg or v.args[2].type == ULib.cmds.PlayerArg)) then continue end

	local name, argName, argName2 = string.gsub(k, "ulx ", ""), "Arg", "Arg2"

	if (v.args[3] and (v.args[3].type == ULib.cmds.NumArg or v.args[3].type == ULib.cmds.StringArg)) then
		if (v.args[3].hint != nil) then argName = v.args[3].hint end

		if (v.args[4] and (v.args[4].type == ULib.cmds.NumArg or v.args[4].type == ULib.cmds.StringArg)) then
			if(v.args[4].hint != nil) then argName2 = v.args[4].hint end 

			self:AddCmdsButton(ply, panel, name, function()
				self:EntryPanel(ply, self:PopUp(k, 3), {argName, argName2}, function(tbl)
					if !IsValid(ply) then return end
					ULib.cmds.execute({}, LocalPlayer(),"ulx",{name, ply:Nick(), tbl[1]:GetValue(),tbl[2]:GetValue()})	
				end)
			end)
		continue else
			self:AddCmdsButton(ply, panel, name, function()
				self:EntryPanel(ply, self:PopUp(k, 3), {argName}, function(tbl)
					if !IsValid(ply) then return end
					ULib.cmds.execute({}, LocalPlayer(),"ulx",{name, ply:Nick(), tbl[1]:GetValue()})
				end)
			end)
		end
	continue end
		self:AddCmdsButton(ply, panel, name, function()
			if !IsValid(ply) then return end
			ULib.cmds.execute({}, LocalPlayer(),"ulx",{name, ply:Nick()})
		end)
	end
end

function PANEL:SetImage2() end

vgui.Register("sd_scoreboard_profile", PANEL)