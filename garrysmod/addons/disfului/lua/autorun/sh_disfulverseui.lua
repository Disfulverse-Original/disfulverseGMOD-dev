
if SERVER then
	resource.AddSingleFile("materials/vgui/armoricon64x.png")
	resource.AddSingleFile("materials/vgui/hearticon64x.png")
	resource.AddSingleFile("materials/vgui/mat1.png")
	resource.AddFile( "materials/overlays/vignette02.vmt" )
	-- override to remove voice icons
	RunConsoleCommand("mp_show_voice_icons", 0)
end

DISFULVERSE = DISFULVERSE or {}

DISFULVERSE.Config = DISFULVERSE.Config or {}

function DISFULVERSE.OpenTextBox(text1, text2, cmd, ent)


	local bg = vgui.Create("DFrame")
	bg:SetSize(400, 130)
	bg:ShowCloseButton(false)
	bg:MakePopup()
	bg:Center()
	bg:SetTitle(text1)
	bg.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200)) end
	
	local label = vgui.Create("DLabel", bg)
	label:Dock(TOP)
	label:DockMargin(0,5,0,0)
	label:SetWrap(true)
	label:SetText(text2)
	label:SetTextColor(Color(255,255,255))
	
	local exit = vgui.Create("DButton", bg)
	exit:SetSize(20, 20)
	exit:SetPos(bg:GetWide() - 22,2)
	exit:SetText("r")
	exit:SetFont("marlett")
	exit:SetTextColor(Color(200,30,30))
	exit.Paint = function() end
	exit.DoClick = function() bg:Close() end

	local myText = vgui.Create("DTextEntry", bg)
	myText:Dock(TOP)
	myText:SetTall(30)
	myText:DockMargin(0,5,0,0)
	myText:SetText("")

	local ybut = vgui.Create( "DButton", bg )
	ybut:Dock(TOP)
	ybut:DockMargin(0,5,0,0)
	ybut:SetTall(30)
	ybut:SetText("Принять")
	ybut:SetTextColor(Color(255,255,255))
	ybut.Paint = function(self, w, h) draw.RoundedBox(0,0,0,w,h,Color(50,50,50)) end

	ybut.DoClick = function()
		local amt = myText:GetValue()
		local str = cmd.." "..amt
		if amt and !ent then
			RunConsoleCommand( "say", str )
			print(str)
		elseif amt and ent then
			local entname = ent:GetName()
			local str = cmd.." "..amt.. " ".. entname
			RunConsoleCommand( "say", str )
		end
		bg:Close()
		textOpen = false
	end
end

function DISFULVERSE.OpenPlyBox( text1, text2, cmd )

	local bg = vgui.Create("DFrame")
	bg:SetSize(400, 130)
	bg:ShowCloseButton(false)
	bg:MakePopup()
	bg:Center()
	bg:SetTitle(text1)
	bg.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200)) end
	
	local label = vgui.Create("DLabel", bg)
	label:Dock(TOP)
	label:DockMargin(0,5,0,0)
	label:SetWrap(true)
	label:SetText(text2)
	label:SetTextColor(Color(255,255,255))
	
	local exit = vgui.Create("DButton", bg)
	exit:SetSize(20, 20)
	exit:SetPos(bg:GetWide() - 22,2)
	exit:SetText("r")
	exit:SetFont("marlett")
	exit:SetTextColor(Color(200,30,30))
	exit.Paint = function() end
	exit.DoClick = function() bg:Close() end

	local hl = vgui.Create( "DComboBox", bg)
	hl:Dock(TOP)
	hl:DockMargin(0,5,0,0)
	hl:SetTall(30)
	for k,v in pairs(player.GetAll()) do hl:AddChoice(v:Name()) end

	hl.OnSelect = function(_,_,value) target = string.Explode(" ", value)[1] end

	local ybut = vgui.Create( "DButton", bg )
	ybut:Dock(TOP)
	ybut:DockMargin(0,5,0,0)
	ybut:SetTall(30)
	ybut:SetText("Принять")
	ybut:SetTextColor(Color(255,255,255))
	ybut.Paint = function(self, w, h) draw.RoundedBox(0,0,0,w,h,Color(50,50,50)) end
	ybut.DoClick = function()
		local str = cmd.." "..target
		if target then
			RunConsoleCommand( "say", str )
		end
		bg:Close()
		textOpen = false
	end
end

function DISFULVERSE.OpenPlyReasonBox( text1, text2, text3, cmd )

	local bg = vgui.Create("DFrame")
	bg:SetSize(400, 190)
	bg:ShowCloseButton(false)
	bg:MakePopup()
	bg:Center()
	bg:SetTitle(text1)
	bg.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200)) end
	
	local label = vgui.Create("DLabel", bg)
	label:Dock(TOP)
	label:DockMargin(0,5,0,0)
	label:SetWrap(true)
	label:SetText(text2)
	label:SetTextColor(Color(255,255,255))
	
	local exit = vgui.Create("DButton", bg)
	exit:SetSize(20, 20)
	exit:SetPos(bg:GetWide() - 22,2)
	exit:SetText("r")
	exit:SetFont("marlett")
	exit:SetTextColor(Color(200,30,30))
	exit.Paint = function() end
	exit.DoClick = function() bg:Close() end
	
	local target

	local hl = vgui.Create( "DComboBox", bg)
	hl:Dock(TOP)
	hl:DockMargin(0,5,0,0)
	hl:SetTall(30)
	for k,v in pairs(player.GetAll()) do hl:AddChoice(v:Name()) end

	hl.OnSelect = function(_,_,value) target = string.Explode(" ", value)[1] end

	local label2 = vgui.Create("DLabel", bg)
	label2:Dock(TOP)
	label2:DockMargin(0,5,0,0)
	label2:SetWrap(true)
	label2:SetText(text3)
	label2:SetTextColor(Color(255,255,255))

	local myText = vgui.Create("DTextEntry", bg)
	myText:Dock(TOP)
	myText:SetTall(30)
	myText:DockMargin(0,5,0,0)
	myText:SetText("")

	local ybut = vgui.Create( "DButton", bg )
	ybut:Dock(TOP)
	ybut:DockMargin(0,5,0,0)
	ybut:SetTall(30)
	ybut:SetText("Принять")
	ybut:SetTextColor(Color(255,255,255))
	ybut.Paint = function(self, w, h) draw.RoundedBox(0,0,0,w,h,Color(50,50,50)) end
	ybut.DoClick = function()
		local amt = myText:GetValue()
		local str = cmd.." "..target.." "..amt
		if amt and target then
			RunConsoleCommand( "say", str )
		end
		bg:Close()
		textOpen = false
	end
end

do
	print 'upd'

	properties.Add( "holstweap", {
		MenuLabel = "Убрать оружие в инвентарь",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 2,
		PrependSpacer = true,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player )
		end,

		Action = function(self, ent) -- ( Clientside )
			RunConsoleCommand("holster")
		end
	} )

	properties.Add( "dropweap", {
		MenuLabel = "Выбросить оружие",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 3,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player )
		end,

		Action = function(self, ent) -- ( Clientside )
			RunConsoleCommand("say","/drop")
		end
	} )

	properties.Add( "dropmon", {
		MenuLabel = "Выбросить деньги",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 4,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player )
		end,

		Action = function(self, ent) -- ( Clientside )
			DISFULVERSE.OpenTextBox("Бросить деньги на пол","Сколько денег вы собираетесь бросить на пол?","/dropmoney")
		end
	} )

	properties.Add( "givemon", {
		MenuLabel = "Передать деньги",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 4,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end
			if ( !ent:IsPlayer() ) then return false end
			if ( ent == player ) then return false end

			return true
		end,

		Action = function(self, ent) -- ( Clientside )
			DISFULVERSE.OpenTextBox("Передача денег","Сколько денег вы хотите дать этому игроку?", "/give", ent )
		end
	} )

	properties.Add( "givelicense", {
		MenuLabel = "Выдать лицензию",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 4,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end
			if ( ent == player ) then return false end
			if ( !ent:IsPlayer() ) then return false end
			if ( ent:getDarkRPVar("HasGunlicense") ) then return false end

			return player:isMayor()
		end,

		Action = function(self, ent) -- ( Clientside )
			RunConsoleCommand( "say", "/givelicense " .. tostring(ent:Nick()) )
		end
	} )

	properties.Add( "polmenu", {
		MenuLabel = "Полиция",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 5,
		PrependSpacer = true,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player ) && player:isCP()
		end,

		MenuOpen = function(self, option, ent, tr)

	        local options = option:AddSubMenu()

	        if ent:isMayor() then
		        options:AddOption("Создать закон", function() DISFULVERSE.OpenTextBox("Законы","Создать закон","/addlaw") end ):SetIcon("icon16/page_white_edit.png")
				options:AddOption("Удалить закон", function() DISFULVERSE.OpenTextBox("Удалить законы","Выберите закон который хотите удалить в цифровом порядке","/removelaw") end ):SetIcon("icon16/page_white_edit.png")
			end

	        if ent:isMayor() && !GetGlobalBool("DarkRP_LockDown") then
		        options:AddOption("Начать ком. час", function() RunConsoleCommand("say", "/lockdown") end ):SetIcon("icon16/page_white_edit.png")
			elseif ent:isMayor() && GetGlobalBool("DarkRP_LockDown") then
				options:AddOption("Закончить ком. час", function() RunConsoleCommand("say", "/unlockdown") end ):SetIcon("icon16/page_white_edit.png")
			end

			options:AddSpacer()

			options:AddOption("Подать в розыск", function() DISFULVERSE.OpenPlyReasonBox("Обьявить в розыск","Кого обьявить в розыск?","По какой причине?","/wanted") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("Запросить ордер", function() DISFULVERSE.OpenPlyReasonBox("Запрос ордера","На кого вы хотите запросить ордер?","Объясните свой выбор.","/warrant") end ):SetIcon("icon16/note_edit.png")

		end,

		Action = function() -- ( Clientside )
		end
	} )

	properties.Add( "hitmanmenu", {
		MenuLabel = "Наёмничество",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 6,
		PrependSpacer = true,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player ) && Executioner.Config.Hitman_Teams[ team.GetName( player:Team() ) ]
		end,

		Action = function(self, ent) -- ( Clientside )

			self:MsgStart()
				net.WriteEntity( ent )
			self:MsgEnd()

		end,

		Receive = function(self, len, ply)

			local ent = net.ReadEntity()
			Executioner.OrderPhoneList( ent, Executioner.PhoneTracker )

		end

	} )

	properties.Add( "miscstuffmenu", {
		MenuLabel = "Остальное",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 7,
		PrependSpacer = true,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player )
		end,

		MenuOpen = function(self, option, ent, tr)

	        local options = option:AddSubMenu()

	        options:AddOption("Третье лицо", function() RunConsoleCommand("thirdperson_toggle") end ):SetIcon("icon16/page_white_edit.png")
			options:AddOption("Способности", function() RunConsoleCommand("say", "!slevels") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("Ежедневные награды", function() RunConsoleCommand("say", "!rewards") end ):SetIcon("icon16/note_edit.png")

			options:AddSpacer()

			options:AddOption("Тикет", function() RunConsoleCommand("say", "!ticket") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("Поддержать проект", function() RunConsoleCommand("say", "!store") end ):SetIcon("icon16/tux.png")

		end,

		Action = function() -- ( Clientside )
		end
	} )

	properties.Add( "superadminmain", {
		MenuLabel = "Super Admin",
		MenuIcon = "icon16/wrench_orange.png",
		Order = 90002,
		PrependSpacer = true,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player ) && player:IsSuperAdmin()
		end,

		MenuOpen = function(self, option, ent, tr)

	        local options = option:AddSubMenu()

	        options:AddOption("GmodAdminSuite — Меню", function() RunConsoleCommand("gmodadminsuite") end ):SetIcon("icon16/page_white_edit.png")

			options:AddOption("ACC2:Whitelist — Меню", function()
				net.Start("ACC2:Admin:Configuration")
	                net.WriteUInt(6, 4)
	                net.WriteString(ent:SteamID64())
	            net.SendToServer()
			end ):SetIcon("icon16/page_white_edit.png")

			options:AddSpacer()

			options:AddOption("Weapon.Customise", function() RunConsoleCommand("say", "!project0") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("Zone.Creator", function() RunConsoleCommand("brs_zone_editor") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("ATM.Admin", function() RunConsoleCommand("say", "!adminatm") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("Name.Editor", function() RunConsoleCommand("say", "/acc2") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("House.Editor", function() RunConsoleCommand("say", "/rpsconfig") end ):SetIcon("icon16/note_edit.png")
			options:AddOption("Accessory.Editor", function() RunConsoleCommand("say", "/aasconfig") end ):SetIcon("icon16/note_edit.png")

			options:AddSpacer()

			options:AddOption("SPECTATOR — Режим", function() RunConsoleCommand("say", "!spectate") end ):SetIcon("icon16/tux.png")

		end,

		Action = function() -- ( Clientside )
		end
	} )

	properties.Add( "adminmain", {
		MenuLabel = "Admin",
		MenuIcon = "icon16/wrench.png",
		Order = 90003,

		Filter = function( self, ent, player )

			if ( !IsValid( ent ) ) then return false end
			if ( !IsValid( player ) ) then return false end

			return ( ent == player ) && player:IsAdmin()
		end,

		MenuOpen = function(self, option, ent, tr)

	        local options = option:AddSubMenu()

			options:AddOption("Админ — Меню", function() WasiedAdminSystem:OpenAdminMenu() end ):SetIcon("icon16/page_white_edit.png")
			options:AddOption("Админ — Режим", function() 
				net.Start("AdminSystem:Utils:ModifyVar")
				net.SendToServer() 
			end ):SetIcon("icon16/tux.png")

		end,

		Action = function() -- ( Clientside )
		end
	} )

end

