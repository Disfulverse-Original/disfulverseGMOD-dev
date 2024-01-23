local listName = {
	"Julien",
	"Jules",
	"Christor",
	"Mickael",
	"Dan",
	"Matt",
	"Tim",
	"Lucas",
	"Yohan",
	"Billal",
	"Esteban",
	"Laurent",
	"Alain",
	"Olivier",
	"Tony",
	"Jean",
}

local listSurname = {
	"Smith",
	"White",
	"Miller",
	"Jackson",
	"Lewis",
	"Walker",
	"Scott",
	"Johnson",
	"Thomas",
	"Rodriger",
	"Perez",
	"Murphy",
	"Cooper",
	"Sanders",
	"Young",
	"Harris",
}

local errInfos = ""

local randomname = table.Random(listName)
local randomsurname = table.Random(listSurname)

local defMaleInfos = {
	model = "models/kerry/player/citizen/male_01.mdl",
	name = randomname,
	surname = randomsurname,
	sex = 1,
	playerColor = Vector(1,1,1),
	bodygroups = {
		top = "polo",
		pant = "pant",
	},
	skin = 0,
	eyestexture = {
		basetexture = {
			["r"] = "eyes/eyes/amber_r",
			["l"] = "eyes/eyes/amber_l",
		},
	},
	hasCostume = false, -- disable tee and pant and shoes texture
	teetexture = {
		basetexture = "models/citizen/body/citizen_sheet", -- name of the tee Choosen in the first part of the menu
		hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
	},
	panttexture = {
		basetexture = "models/citizen/body/citizen_sheet",
	},
}

local infos = defMaleInfos
local soundisplayed = true

local defFemaleInfos = {
	model = "models/kerry/player/citizen/female_01.mdl",
	name = randomname,
	surname = randomsurname,
	sex = 0,
	playerColor = Vector(1,1,1),
	bodygroups = {
		top = "polo",
		pant = "pant",
	},
	skin = 0,
	eyestexture = {
		basetexture = {
			["r"] = "eyes/eyes/amber_r",
			["l"] = "eyes/eyes/amber_l",
		},
	},
	hasCostume = false, -- disable tee and pant and shoes texture
	teetexture = {
		basetexture = "models/humans/modern/female/sheet_01", -- name of the tee Choosen in the first part of the menu
		hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
	},
	panttexture = {
		basetexture = "models/humans/modern/female/sheet_01",
	},
}

surface.CreateFont( "Bariol40", {
	font = "Bariol Regular", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 40,
	weight = 1200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Bariol25", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )
surface.CreateFont( "ClothesModTitle1", {
	font = "Walking in the Street", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local blur = Material("pp/blurscreen")

local DermaPanel

local function DrawBlur( p, a, d )


	local x, y = p:LocalToScreen(0, 0)
	
	surface.SetDrawColor( 255, 255, 255 )
	
	surface.SetMaterial( blur )
	
	for i = 1, d do
	
	
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		
		
	end
	
	
end

local param = Material("materials/clothesmod/003-note.png")
local head = Material("materials/clothesmod/002-people-1.png")
local eyes = Material("materials/clothesmod/007-medical.png")
local top = Material("materials/clothesmod/006-game.png")
local pant = Material("materials/clothesmod/001-fashion.png")
local male = Material("materials/clothesmod/male.png")
local female = Material("materials/clothesmod/female.png")
local speakeron = Material("materials/clothesmod/speakeron.png")
local speakeroff = Material("materials/clothesmod/speakeroff.png")
local modelPanel

local OpenIntro
local OpenCharacterPage
local OpenConfirmPage

function OpenConfirmPage( Frame, sizex, sizey )
	local DPanel = vgui.Create( "DPanel",Frame )
	DPanel:SetPos( 0,50 )
	DPanel:SetSize( sizex, sizey )
	local removeTime = -1
	local startTime = CurTime()
	DPanel:SetAlpha( 0 )
	DPanel:MoveTo( 0,0,1,0,-1, function() end )
	
	local sizeym = sizey * 1
	local sizexm = sizeym * 0.7
	
	DPanel.Paint = function(pnl, w, h)
		local perc = 1
	
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		else
			
			perc = ( math.Clamp(CurTime() - startTime, 0, 1) )
			
		end
	
		DPanel:SetAlpha(255 * perc)	

		surface.SetFont( "ClothesModTitle1" )
		surface.SetTextColor( 255, 255, 255, 255 )
		
		local sizetx, sizety = surface.GetTextSize(CLOTHESMOD.Config.Sentences[28][CLOTHESMOD.Config.Lang]..", "..infos.name.." "..infos.surname)
	
		surface.SetTextPos( (sizex-sizetx)/2, 0 )
		surface.DrawText( CLOTHESMOD.Config.Sentences[28][CLOTHESMOD.Config.Lang]..", "..infos.name.." "..infos.surname )		
	end
	
	if CLOTHESMOD.Config.HasSound then
	
		local URLsound = CLOTHESMOD.Config.IntroSoundURL
		local DButtonSound = vgui.Create( "DButton", DPanel)
		DButtonSound:SetSize( 40,40 )
		DButtonSound:SetPos(sizex-40,0 )
		DButtonSound:SetText( "" )	
		DButtonSound.Paint = function(pnl, w, h )		
			surface.SetDrawColor( 255, 255, 255, 255 )
			if soundisplayed then
				surface.SetMaterial( speakeron )
			else
				surface.SetMaterial( speakeroff )
			end
			surface.DrawTexturedRect( 0,0,w,h )
		end
	
		DButtonSound.DoClick = function( pnl )
			if soundisplayed then
				soundisplayed = false
				RunConsoleCommand( "stopsound" )
			else
				soundisplayed = true
				sound.PlayURL( URLsound, "", 
				function( station )
					if IsValid( station ) then
						station:Play() 
					end 
				end )
			end
		end
		
	end

	local DButton = vgui.Create( "DButton", DPanel)
	DButton:SetSize( 150,30 )
	DButton:SetPos( sizex-170, sizey - 50 )
	DButton:SetText( "" )	
	DButton.Paint = function(pnl, w, h )
		
		local perc = 1
		
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[29][CLOTHESMOD.Config.Lang], "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

	DButton.DoClick = function( pnl )
		removeTime = CurTime()
		net.Start("ClothesMod:ReceiveCharacterCreated")
			net.WriteTable(infos)
		net.SendToServer()
		DermaPanel:Close()
	end

	local DButton2 = vgui.Create( "DButton", DPanel)
	DButton2:SetSize( 150,30 )
	DButton2:SetPos( 20, sizey - 50 )
	DButton2:SetText( "" )	
	DButton2.Paint = function(pnl, w, h )
		
		local perc = 1
		
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		
		end
	
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[30][CLOTHESMOD.Config.Lang], "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton2.DoClick = function( pnl )
		removeTime = CurTime()
		DPanel:MoveTo( 0, -100, 1, 0, -1, function()
			DPanel:Remove()
			OpenCharacterPage( Frame, sizex, sizey )
		end )
	end
	
	local DmodelPanel = vgui.Create( "DModelPanel", DPanel )
	
	DmodelPanel:SetSize( sizexm, sizeym )
	DmodelPanel:SetPos( sizex/2-sizexm/2, sizey-sizeym )
	
	function DmodelPanel:LayoutEntity( Entity ) return end
	DmodelPanel:SetModel( infos.model )
	local startpos = DmodelPanel.Entity:GetBonePosition( DmodelPanel.Entity:LookupBone( "ValveBiped.Bip01_Spine1" ) or 0 )
	DmodelPanel:SetLookAt( startpos )
	DmodelPanel:SetCamPos( startpos - Vector( -55,-0,0) )
	DmodelPanel.Entity:SetEyeTarget( startpos - Vector( -55,-0,0) )
	
	DmodelPanel.Actualize = function()
	
		local datas 
		if infos.sex == 1 then
			datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
		else
			datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
		end
		DmodelPanel:SetModel( infos.model )
		
		local tindex = datas.bodygroupstop[infos.bodygroups.top].tee
		local pindex = datas.bodygroupsbottom[infos.bodygroups.pant].pant
		local eindex = datas.eyes
		local bodygroups = {
			datas.bodygroupstop[infos.bodygroups.top].group,
			datas.bodygroupsbottom[infos.bodygroups.pant].group
		}
		local skin = infos.skin
		local ent = DmodelPanel.Entity
		local pcolor = infos.playerColor
		local tops = infos.teetexture.basetexture
		local pants = infos.panttexture.basetexture
		ent:SetSkin( skin )
		for k, v in pairs( bodygroups ) do
			ent:SetBodygroup( v[1], v[2] )
		end
		for k, v in pairs( tindex ) do
			ent:SetSubMaterial( v, tops )
		end
		for k, v in pairs( pindex ) do
			ent:SetSubMaterial( v, pants )
		end

		ent.GetPlayerColor = function() return pcolor end
			
		for k, v in pairs( infos.eyestexture ) do
			
			local matr = v["r"]
			local matl = v["l"]
			local indexr = eindex["r"]
			local indexl = eindex["l"]
			ent:SetSubMaterial( indexr, matr )
			ent:SetSubMaterial( indexl, matl )
		
		end
				
	end
	DmodelPanel:Actualize()
	
end

local function DrawBlurRect(x, y, w, h, amount, heavyness)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, heavyness do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(x, y, x + w, y + h, true)
			surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(), ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
	
end

local OpenPantPage = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[14][CLOTHESMOD.Config.Lang], "Bariol25",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	local DPanel2 = vgui.Create( "DScrollPanel", Panel )

	DPanel2:SetSize( w-40, h-100 )
	DPanel2:SetPos( 25,80 )
	DPanel2.Paint = function()
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,100))
	end
	
	local sbar = DPanel2:GetVBar()

	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255, 255, 255,0) )
	end

	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0,150) )
	end
	
	local list = {}
	
	if infos.sex == 1 then
		list = CLOTHESMOD.Male.ListBottoms
	else
		list = CLOTHESMOD.Female.ListBottoms
	end

	local nb = 0	
	local line = -1
	
	for pant, tables in pairs ( list ) do
		
		if not tables.default then continue end
		
		local nbl = math.fmod( nb, 6 )

		if nbl == 0 then
			line = line + 1
			nb = 0
		end
		
		local DPanel3 = vgui.Create( "DButton", DPanel2 )
		DPanel3:SetSize( 40+45, 40+45 )
		DPanel3:SetPos( 5 + 90*nb, 5+95* line )
		DPanel3:SetText("")
		DPanel3.Paint = function(p, w, h)
		end
		
		local DmodelPanel = vgui.Create( "DModelPanel", DPanel3 )
		DmodelPanel:SetSize( 85, 85 )
		DmodelPanel:SetPos( 0, 0 )
		function DmodelPanel:LayoutEntity( Entity ) return end
		DmodelPanel:SetModel( infos.model )
		
		local startpos = DmodelPanel.Entity:GetBonePosition( DmodelPanel.Entity:LookupBone( "ValveBiped.Bip01_R_Calf" ) or 0) + Vector( 0,5,0 )
		DmodelPanel:SetLookAt( startpos )
		DmodelPanel:SetCamPos( startpos - Vector( -30,-0,0) )
		DmodelPanel.Entity:SetEyeTarget( startpos - Vector( -30,-0,0) )
	
		--
		local datas 
		if infos.sex == 1 then
			datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
		else
			datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
		end
			
		local tindex = datas.bodygroupsbottom[tables.bodygroup].pant 
		local bodygroups = {
			datas.bodygroupsbottom[tables.bodygroup].group,
		}
		
		local ent = DmodelPanel.Entity
		
		for k, v in pairs( bodygroups ) do
			ent:SetBodygroup( v[1], v[2] )
		end
		
		local pants = tables.texture
		
		for k, v in pairs( tindex ) do
			ent:SetSubMaterial( v, pants )
		end

		local DButton3 = vgui.Create( "DButton", DPanel3 )
		DButton3:SetSize( 40+45, 40+45 )
		DButton3:SetPos( 0,0 )
		DButton3:SetText("")
		DButton3.Paint = function(p, w, h)
			draw.RoundedBox(0,0,0,w,h, Color(0,0,0,150))
			local m = 0
			if infos.panttexture.basetexture == pants then
				m = 1
			end
			
			draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255 * m))
			draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255 * m))
			draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255  * m))
			draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255 * m))
		end
		DButton3.DoClick = function( pnl )

			infos.bodygroups.pant = tables.bodygroup
	
			infos.panttexture.basetexture = pants
			
			modelPanel.Actualize()
			
		end
		
		nb = nb + 1
		
	end
end

local OpenInfosPage = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h/2 )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[31][CLOTHESMOD.Config.Lang], "Bariol25",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		if errInfos and errInfos ~= "" then
			draw.SimpleText( errInfos, "Bariol18",w/2,30+30+40*2+5,Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
		end
	end
	
	DPanel.OnRemove = function()
		errInfos = ""
	end

	local TextEntry = vgui.Create( "DTextEntry", DPanel ) -- create the form as a child of frame
	TextEntry:SetPos( w/2-100, 30 + 40 )
	TextEntry:SetSize( 200, 30 )
	TextEntry:SetText(  infos.name )
	TextEntry.OnTextChanged = function( self )
		txt = self:GetValue()
		local amt = string.len(txt)
		if amt > 8 then
			self.OldText = self.OldText or infos.name
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
		else
			self.OldText = txt
		end
		infos.name = TextEntry:GetValue()
	end
	if VoidChar then
		TextEntry:SetText( LocalPlayer():getDarkRPVar( "rpname" ) )
		TextEntry:SetCursor( "no" )
		TextEntry.AllowInput = function( self, stringValue )
			return true
		end
	end

	local TextEntry2 
	if not VoidChar then

		TextEntry2 = vgui.Create( "DTextEntry", DPanel ) -- create the form as a child of frame
		TextEntry2:SetPos( w/2-100, 30 + 40 * 2 )
		TextEntry2:SetSize( 200, 30 )
		TextEntry2:SetText(  infos.surname )
		TextEntry2.OnTextChanged = function( self )
			txt = self:GetValue()
			local amt = string.len(txt)
			if amt > 8 then
				self.OldText = self.OldText or infos.surname
				self:SetText(self.OldText)
				self:SetValue(self.OldText)
			else
				self.OldText = txt
			end
			infos.surname = TextEntry2:GetValue()
		end

	end

	local DPanel2 = vgui.Create( "DPanel", Panel )
	DPanel2:SetSize( w, h/2 )
	DPanel2:SetPos( 0, h/2 )
	DPanel2.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[32][CLOTHESMOD.Config.Lang], "Bariol25",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	local DButton1 = vgui.Create( "DButton", DPanel2)
	DButton1:SetSize( 80,80 )
	DButton1:SetPos( w/2-80/2 -100,h/4-80/2+20  )
	DButton1:SetText( "" )	
	DButton1.Paint = function(pnl, w, h )
		
		local m = 1
		if infos.sex ~= 1 then
			m = 0
		end
		
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255 * m))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255 * m))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255  * m))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255 * m))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( male )
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
			
	end	
	DButton1.DoClick = function( pnl )
		
		local oldName = infos.name
		local oldSurname = infos.surname
		
		infos = defMaleInfos
		
		infos.name = oldName
		infos.surname = oldSurname
		
		modelPanel.Actualize()
	end
	local DButton2 = vgui.Create( "DButton", DPanel2)
	DButton2:SetSize( 80,80 )
	DButton2:SetPos( w/2-80/2 + 100,h/4-80/2 +20 )
	DButton2:SetText( "" )	
	DButton2.Paint = function(pnl, w, h )
		
		local m = 1
		if infos.sex ~= 0 then
			m = 0
		end
		
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255 * m))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255 * m))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255  * m))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255 * m))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( female	)
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
			
	end
	DButton2.DoClick = function( pnl )
		local oldName = infos.name
		local oldSurname = infos.surname
		
		infos = defFemaleInfos
		
		infos.name = oldName
		infos.surname = oldSurname
		
		modelPanel.Actualize()
	end
end

local OpenEyesMenu = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[33][CLOTHESMOD.Config.Lang], "Bariol25",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	local DPanel2 = vgui.Create( "DScrollPanel", Panel )

	DPanel2:SetSize( w-40, h-100 )
	DPanel2:SetPos( 25,80 )
	DPanel2.Paint = function()
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,100))
	end
	
	local sbar = DPanel2:GetVBar()

	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255, 255, 255,0) )
	end

	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0,150) )
	end
	
	local list = {}
	
	if infos.sex == 1 then
		list = CLOTHESMOD.Male.ListEyesTextures
	else
		list = CLOTHESMOD.Female.ListEyesTextures
	end

	local nb = 0	
	local line = -1
	
	for color, tables in pairs ( list ) do
					
		local nbl = math.fmod( nb, 6 )

		if nbl == 0 then
			line = line + 1
			nb = 0
		end
		
		local DPanel3 = vgui.Create( "DButton", DPanel2 )
		DPanel3:SetSize( 40+45, 40+45 )
		DPanel3:SetPos( 5 + 90*nb, 5+95* line )
		DPanel3:SetText("")
		DPanel3.Paint = function(p, w, h)
		end
			
		local datas 
		if infos.sex == 1 then
			datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
		else
			datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
		end
			
		local eindex = datas.eyes
		
		local DmodelPanel = vgui.Create( "DModelPanel", DPanel3 )
		DmodelPanel:SetSize( 85, 85 )
		DmodelPanel:SetPos( 0, 0 )
		function DmodelPanel:LayoutEntity( Entity ) return end
		DmodelPanel:SetModel( infos.model )
		
		local ent = DmodelPanel.Entity
			
			
		local matr = tables["r"]
		local matl = tables["l"]
		local indexr = eindex["r"]
		local indexl = eindex["l"]
		ent:SetSubMaterial( indexr, matr )
		ent:SetSubMaterial( indexl, matl )
	
		
		-- local startpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )

		-- modelPanel.LastChangePos = CurTime()
		
		-- modelPanel.npos = startpos
		-- modelPanel.nel = Vector(-15,2,-0)
		
		local startpos = DmodelPanel.Entity:GetBonePosition( DmodelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0)
		DmodelPanel:SetLookAt( startpos )
		DmodelPanel:SetCamPos( startpos - Vector( -15,-0,0) )
		DmodelPanel.Entity:SetEyeTarget( startpos - Vector( -15,-0,0) )
	
		--
		
		local DButton3 = vgui.Create( "DButton", DPanel3 )
		DButton3:SetSize( 40+45, 40+45 )
		DButton3:SetPos( 0,0 )
		DButton3:SetText("")
		DButton3.Paint = function(p, w, h)
			draw.RoundedBox(0,0,0,w,h, Color(0,0,0,150))
			local m = 0
			if infos.eyestexture.basetexture["r"] == matr then
				m = 1
			end
			
			draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255 * m))
			draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255 * m))
			draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255  * m))
			draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255 * m))
		end
		DButton3.DoClick = function( pnl )

			infos.eyestexture = {	
				basetexture = {
					["r"] = matr,
					["l"] = matl,
				},
			},
		
			timer.Simple(0.1, function() modelPanel.Actualize() end)
			
		end
		
		nb = nb + 1
		
	end
end

local OpenTopMenu = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[7][CLOTHESMOD.Config.Lang], "Bariol25",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	local DPanel2 = vgui.Create( "DScrollPanel", Panel )

	DPanel2:SetSize( w-40, h-100 )
	DPanel2:SetPos( 25,80 )
	DPanel2.Paint = function()
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,100))
	end
	
	local sbar = DPanel2:GetVBar()

	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255, 255, 255,0) )
	end

	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0,150) )
	end
	
	local list = {}
	
	if infos.sex == 1 then
		list = CLOTHESMOD.Male.ListTops
	else
		list = CLOTHESMOD.Female.ListTops
	end
	
	local nb = 0	
	local line = -1
		
	for tee, tables in pairs ( list ) do
		
		if not tables.default then continue end
		
		local nbl = math.fmod( nb, 6 )

		if nbl == 0 then
			line = line + 1
			nb = 0
		end
		
		local DPanel3 = vgui.Create( "DButton", DPanel2 )
		DPanel3:SetSize( 40+45, 40+45 )
		DPanel3:SetPos( 5 + 90*nb, 5+95* line )
		DPanel3:SetText("")
		DPanel3.Paint = function(p, w, h)
		end
		
		local DmodelPanel = vgui.Create( "DModelPanel", DPanel3 )
		DmodelPanel:SetSize( 85, 85 )
		DmodelPanel:SetPos( 0, 0 )
		function DmodelPanel:LayoutEntity( Entity ) return end
		DmodelPanel:SetModel( infos.model )

		local startpos = DmodelPanel.Entity:GetBonePosition( DmodelPanel.Entity:LookupBone( "ValveBiped.Bip01_Spine2" ) or 0)
		DmodelPanel:SetLookAt( startpos )
		DmodelPanel:SetCamPos( startpos - Vector( -25,0,0) )
		DmodelPanel.Entity:SetEyeTarget( startpos - Vector( -25,0,0) )
		
		--
		local datas 
		if infos.sex == 1 then
			datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
		else
			datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
		end
		
		local tindex = datas.bodygroupstop[tables.bodygroup].tee 
		local bodygroups = {
			datas.bodygroupstop[tables.bodygroup].group,
		}
		
		local ent = DmodelPanel.Entity
		
		for k, v in pairs( bodygroups ) do
			ent:SetBodygroup( v[1], v[2] )
		end
	
		local tops = tables.texture
		
		for k, v in pairs( tindex ) do
			ent:SetSubMaterial( v, tops )
		end

		local DButton3 = vgui.Create( "DButton", DPanel3 )
		DButton3:SetSize( 40+45, 40+45 )
		DButton3:SetPos( 0,0 )
		DButton3:SetText("")
		DButton3.Paint = function(p, w, h)
			draw.RoundedBox(0,0,0,w,h, Color(0,0,0,150))
			local m = 0
			if infos.teetexture.basetexture == tops then
				m = 1
			end
			
			draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255 * m))
			draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255 * m))
			draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255  * m))
			draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255 * m))
		end
		DButton3.DoClick = function( pnl )

			infos.bodygroups.top = tables.bodygroup
	
			infos.teetexture.basetexture = tops
						
			modelPanel.Actualize()
			
		end
		
		nb = nb + 1
		
	end
end

local OpenHeadPage = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[34][CLOTHESMOD.Config.Lang], "Bariol25",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	
	local DPanel2 = vgui.Create( "DScrollPanel", Panel )

	DPanel2:SetSize( w-40, h-100 )
	DPanel2:SetPos( 25,80 )
	DPanel2.Paint = function()
		draw.RoundedBox(0,0,0,w,h, Color(0,0,0,100))
	end
	
	local sbar = DPanel2:GetVBar()

	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(255, 255, 255,0) )
	end

	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0) )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0,150) )
	end
	
	local list = {}
	
	if infos.sex == 1 then
		list = CLOTHESMOD.Male.ListDefaultPM
	else
		list = CLOTHESMOD.Female.ListDefaultPM
	end
	
	local nb = 0	
	local line = -1
	
	for head, tables in pairs ( list ) do
		
		for k, ind in pairs ( tables.skins ) do
			
			local nbl = math.fmod( nb, 6 )
	
			if nbl == 0 then
				line = line + 1
				nb = 0
			end
			
			local DPanel3 = vgui.Create( "DButton", DPanel2 )
			DPanel3:SetSize( 40+45, 40+45 )
			DPanel3:SetPos( 5 + 90*nb, 5+95* line )
			DPanel3:SetText("")
			DPanel3.Paint = function(p, w, h)
			end
			
			local DmodelPanel = vgui.Create( "DModelPanel", DPanel3 )
			DmodelPanel:SetSize( 85, 85 )
			DmodelPanel:SetPos( 0, 0 )
			function DmodelPanel:LayoutEntity( Entity ) return end
			DmodelPanel:SetModel( head )

			local startpos = DmodelPanel.Entity:GetBonePosition( DmodelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 )
			DmodelPanel:SetLookAt( startpos )
			DmodelPanel:SetCamPos( startpos - Vector( -15,0,0) )
			DmodelPanel.Entity:SetEyeTarget( startpos - Vector( -15,0,0) )
			
			DmodelPanel.Entity:SetSkin( ind )
	
			local DButton3 = vgui.Create( "DButton", DPanel3 )
			DButton3:SetSize( 40+45, 40+45 )
			DButton3:SetPos( 0,0 )
			DButton3:SetText("")
			DButton3.Paint = function(p, w, h)
				draw.RoundedBox(0,0,0,w,h, Color(0,0,0,150))
				local m = 1
				if infos.model ~= head or infos.skin ~= ind then
					m = 0
				end
				
				draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255 * m))
				draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255 * m))
				draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255  * m))
				draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255 * m))
			end
			DButton3.DoClick = function( pnl )
			
				infos.model = head
				infos.skin = ind
				modelPanel.Actualize()
				
			end
			
			nb = nb + 1
			
		end
		
	end
	
end

OpenCharacterPage = function( Frame, sizex, sizey )

	local DPanel = vgui.Create( "DPanel",Frame )
	DPanel:SetPos( 0,50 )
	DPanel:SetSize( sizex, sizey )
	local removeTime = -1
	local startTime = CurTime()
	DPanel:SetAlpha( 0 )
	DPanel:MoveTo( 0,0,1,0,-1, function() end )
	
	local sizeym = sizey * 0.9
	local sizexm = sizeym * 0.7
	
	DPanel.Paint = function(pnl, w, h)
		local perc = 1
	
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		else
			
			perc = ( math.Clamp(CurTime() - startTime, 0, 1) )
			
		end
		
		DPanel:SetAlpha(255 * perc)			
	end
	
	if CLOTHESMOD.Config.HasSound then

		local URLsound = CLOTHESMOD.Config.IntroSoundURL
		local DButtonSound = vgui.Create( "DButton", DPanel)
		DButtonSound:SetSize( 40,40 )
		DButtonSound:SetPos(sizex-40,0 )
		DButtonSound:SetText( "" )	
		DButtonSound.Paint = function(pnl, w, h )		
			surface.SetDrawColor( 255, 255, 255, 255 )
			if soundisplayed then
				surface.SetMaterial( speakeron )
			else
				surface.SetMaterial( speakeroff )
			end
			surface.DrawTexturedRect( 0,0,w,h )
		end
		
		DButtonSound.DoClick = function( pnl )
			if soundisplayed then
				soundisplayed = false
				RunConsoleCommand( "stopsound" )
			else
				soundisplayed = true
				sound.PlayURL( URLsound, "", 
				function( station )
					if IsValid( station ) then
						station:Play() 
					end 
				end )
			end
		end
		
	end
	
	local DButton = vgui.Create( "DButton", DPanel)
	DButton:SetSize( 150,30 )
	DButton:SetPos( sizex-170, sizey - 50 )
	DButton:SetText( "" )	
	DButton.Paint = function(pnl, w, h )
		
		local perc = 1
		
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		
		end
	
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[35][CLOTHESMOD.Config.Lang], "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton.DoClick = function( pnl )
			
		if string.len( infos.name ) < 3 or string.len( infos.surname ) < 3 then
			if not pnOpen == 1 then
				pnOpen = 1
				DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
					for k, v in pairs( DPanelMenuC:GetChildren() ) do
						v:Remove()
					end
					OpenInfosPage( DPanelMenuC )
					DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
						OpenInfosPage( DPanelMenuC )
					end)
				end)
			end
			
			errInfos = CLOTHESMOD.Config.Sentences[68][CLOTHESMOD.Config.Lang]
			
		else
		
			removeTime = CurTime()
			DPanel:MoveTo( 0, -100, 1, 0, -1, function()
				DPanel:Remove()
				OpenConfirmPage( Frame, sizex, sizey )
			end )
			
		end
	end
	
	modelPanel = vgui.Create( "DModelPanel", DPanel )
	
	modelPanel:SetSize( sizexm, sizeym )
	modelPanel:SetPos( 50, sizey-sizeym )
	
	function modelPanel:LayoutEntity( Entity ) return end
	modelPanel:SetModel( infos.model )
	local startpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Spine4" ) or 0 )

	modelPanel.LastChangePos = CurTime()
	
	modelPanel.pos = startpos
	modelPanel.el = Vector(-22,5,-0)
	modelPanel.isChanged = false

	modelPanel.oldPos = modelPanel.pos
	modelPanel.oldel = modelPanel.el
	
	modelPanel.Actualize = function()
	
		local datas 
		if infos.sex == 1 then
			datas = CLOTHESMOD.Male.ListDefaultPM[infos.model]
		else
			datas = CLOTHESMOD.Female.ListDefaultPM[infos.model]
		end
		modelPanel:SetModel( infos.model )
		
		local tindex = datas.bodygroupstop[infos.bodygroups.top].tee
		local pindex = datas.bodygroupsbottom[infos.bodygroups.pant].pant
		local eindex = datas.eyes
		local bodygroups = {
			datas.bodygroupstop[infos.bodygroups.top].group,
			datas.bodygroupsbottom[infos.bodygroups.pant].group
		}
		local skin = infos.skin
		local ent = modelPanel.Entity
		local pcolor = infos.playerColor
		local tops = infos.teetexture.basetexture
		local pants = infos.panttexture.basetexture
		ent:SetSkin( skin )
		for k, v in pairs( bodygroups ) do
			ent:SetBodygroup( v[1], v[2] )
		end
		for k, v in pairs( tindex ) do
			ent:SetSubMaterial( v, tops )
		end
		for k, v in pairs( pindex ) do
			ent:SetSubMaterial( v, pants )
		end

		ent.GetPlayerColor = function() return pcolor end
			
		for k, v in pairs( infos.eyestexture ) do
			
			local matr = v["r"]
			local matl = v["l"]
			local indexr = eindex["r"]
			local indexl = eindex["l"]
			ent:SetSubMaterial( indexr, matr )
			ent:SetSubMaterial( indexl, matl )
		
		end
		
		-- print(modelPanel.pos-modelPanel.el)
		modelPanel.Entity:SetEyeTarget( modelPanel.pos-modelPanel.el )
		
	end

	modelPanel:Actualize()
	
	modelPanel.Think = function( pnl )
		
		if CurTime() - modelPanel.LastChangePos > 1 then return end
		
		if modelPanel.isChanged then
			modelPanel.oldPos = modelPanel.pos
			modelPanel.oldel = modelPanel.el
			modelPanel.pos = modelPanel.npos
			modelPanel.el = modelPanel.nel
			modelPanel.isChanged = false
		end
	
		local frac = CurTime() - modelPanel.LastChangePos
		
		modelPanel:SetLookAt( LerpVector( frac, modelPanel.oldPos, modelPanel.pos ) )

		modelPanel:SetCamPos( LerpVector( frac, modelPanel.oldPos-modelPanel.oldel, modelPanel.pos-modelPanel.el) )
		
		modelPanel.Entity:SetEyeTarget( LerpVector( frac, modelPanel.oldPos-modelPanel.oldel, modelPanel.pos-modelPanel.el ) )
		
	end
	
	local panelx, panely = 600,392
	local pnOpen = 1
	
	local DPanelMenu = vgui.Create( "DPanel",DPanel )
	DPanelMenu:SetPos( 50+(sizex-panelx)/2, (sizey-panely)/2 )
	DPanelMenu:SetSize( 80, panely )
	
	DPanelMenu.Paint = function(pnl, w, h)
		
		local we = 2
		draw.RoundedBox(0,0,0,w,h, Color(0, 0, 0,200))
		draw.RoundedBox(0,0,0,w,we,Color(255,255,255,255))
		draw.RoundedBox(0,0,h-we,w,we,Color(255,255,255,255))
		draw.RoundedBox(0,0,0,we,h,Color(255,255,255,255))
		draw.RoundedBox(0,w-we,0,we,h,Color(255,255,255,255))
	
	end
	
	local DPanelMenuC = vgui.Create( "DPanel",DPanel )
	DPanelMenuC:SetPos( 78+50+(sizex-panelx)/2, (sizey-panely)/2 )
	DPanelMenuC:SetSize( panelx - 80, panely )
	
	DPanelMenuC.Paint = function(pnl, w, h)
		
		local we = 2
		draw.RoundedBox(0,0,0,w,h, Color(0, 0, 0,200))
		draw.RoundedBox(0,0,0,w,we,Color(255,255,255,255))
		draw.RoundedBox(0,0,h-we,w,we,Color(255,255,255,255))
		draw.RoundedBox(0,0,0,we,h,Color(255,255,255,255))
		draw.RoundedBox(0,w-we,0,we,h,Color(255,255,255,255))
		
	end
	OpenInfosPage( DPanelMenuC )
	
	local DButton1 = vgui.Create( "DButton", DPanelMenu)
	DButton1:SetSize( 80,80 )
	DButton1:SetPos(0,0 )
	DButton1:SetText( "" )	
	DButton1.Paint = function(pnl, w, h )
	
		local m = 1
		if pnOpen == 1 then
			m = 2
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100 * m))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( param	)
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
			
	end
	
	DButton1.DoClick = function( pnl )
		if pnOpen == 1 then return end
		pnOpen = 1
		DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
			for k, v in pairs( DPanelMenuC:GetChildren() ) do
				v:Remove()
			end
			OpenInfosPage( DPanelMenuC )
			DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
				OpenInfosPage( DPanelMenuC )
			end)
		end)
	end
	local DButton2 = vgui.Create( "DButton", DPanelMenu)
	DButton2:SetSize( 80,80 )
	DButton2:SetPos(0,80-2 )
	DButton2:SetText( "" )	
	DButton2.Paint = function(pnl, w, h )
		
		local m = 1
		if pnOpen == 2 then
			m = 2
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100 * m))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( head	)
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
		
		-- draw.SimpleText( "CONTINUE", "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton2.DoClick = function( pnl )
		if pnOpen == 2 then return end
		pnOpen = 2
		DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
			for k, v in pairs( DPanelMenuC:GetChildren() ) do
				v:Remove()
			end
			
			DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
				OpenHeadPage( DPanelMenuC )
			end)
		end)
		local startpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0 )

		modelPanel.LastChangePos = CurTime()
		
		modelPanel.npos = startpos
		modelPanel.nel = Vector(-15,2,-0)
		modelPanel.isChanged = true
	end
	
	local DButton3 = vgui.Create( "DButton", DPanelMenu)
	DButton3:SetSize( 80,80 )
	DButton3:SetPos(0,(80-2)*2 )
	DButton3:SetText( "" )	
	DButton3.Paint = function(pnl, w, h )
		
		local m = 1
		if pnOpen == 3 then
			m = 2
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100 * m))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( eyes	)
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
		
		-- draw.SimpleText( "CONTINUE", "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton3.DoClick = function( pnl )
		if pnOpen == 3 then return end
		pnOpen = 3
		DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
			for k, v in pairs( DPanelMenuC:GetChildren() ) do
				v:Remove()
			end
			
			DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
				OpenEyesMenu( DPanelMenuC )
			end)
		end)
		local startpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0)

		modelPanel.LastChangePos = CurTime()
		
		modelPanel.npos = startpos
		modelPanel.nel = Vector(-13,0,-0)
		modelPanel.isChanged = true
	end
	
	local DButton4 = vgui.Create( "DButton", DPanelMenu)
	DButton4:SetSize( 80,80 )
	DButton4:SetPos(0,(80-2)*3 )
	DButton4:SetText( "" )	
	DButton4.Paint = function(pnl, w, h )
		
		local m = 1
		if pnOpen == 4 then
			m = 2
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100 * m))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( top	)
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
		
		-- draw.SimpleText( "CONTINUE", "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton4.DoClick = function( pnl )
		if pnOpen == 4 then return end
		pnOpen = 4
		DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
			for k, v in pairs( DPanelMenuC:GetChildren() ) do
				v:Remove()
			end
			
			DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
				OpenTopMenu( DPanelMenuC )
			end)
		end)
		local startpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Spine2" ) or 0 )

		modelPanel.LastChangePos = CurTime()
		
		modelPanel.npos = startpos
		modelPanel.nel = Vector(-30,2,-0)
		modelPanel.isChanged = true
	end
	
	local DButton5 = vgui.Create( "DButton", DPanelMenu)
	DButton5:SetSize( 80,80 )
	DButton5:SetPos(0,(80-2)*4 )
	DButton5:SetText( "" )	
	DButton5.Paint = function(pnl, w, h )
		
		local m = 1
		if pnOpen == 5 then
			m = 2
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100 * m))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( pant )
		surface.DrawTexturedRect( 2 + (w-4)/2 - 64/2, 2 + (h-4)/2 - 64/2, 64,64 )
		
		-- draw.SimpleText( "CONTINUE", "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton5.DoClick = function( pnl )
		if pnOpen == 5 then return end
		pnOpen = 5
		DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
			for k, v in pairs( DPanelMenuC:GetChildren() ) do
				v:Remove()
			end
			
			DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
				OpenPantPage( DPanelMenuC )
			end)
		end)
		local startpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_R_Calf" ) or 0 )

		modelPanel.LastChangePos = CurTime()
		
		modelPanel.npos = startpos
		modelPanel.nel = Vector(-30,2,-0)
		modelPanel.isChanged = true
	end

end
OpenIntro = function( Frame, sizex, sizey )
	
	local DPanel = vgui.Create( "DPanel",Frame )
	DPanel:SetPos( 0,50 )
	DPanel:SetSize( sizex, sizey)
	local removeTime = -1
	local startTime = CurTime()
	DPanel:SetAlpha( 0 )
	DPanel:MoveTo( 0,0,1,0,-1, function() end )

	DPanel.Paint = function(pnl, w, h)
		
		local perc = 1
		
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		else
			
			perc = ( math.Clamp(CurTime() - startTime, 0, 1) )
		
		end
		
		DPanel:SetAlpha(255 * perc)
		
		surface.SetFont( "ClothesModTitle1" )
		surface.SetTextColor( 255, 255, 255, 255 )
		
		local sizetx, sizety = surface.GetTextSize(CLOTHESMOD.Config.CommunityName)
	
		surface.SetTextPos( (sizex-sizetx)/2, (sizey-sizety)/2 )
		surface.DrawText( CLOTHESMOD.Config.CommunityName )
			
	end
	
	if CLOTHESMOD.Config.HasSound then

		local URLsound = CLOTHESMOD.Config.IntroSoundURL
		local DButtonSound = vgui.Create( "DButton", DPanel)
		DButtonSound:SetSize( 40,40 )
		DButtonSound:SetPos(sizex-40,0 )
		DButtonSound:SetText( "" )	
		DButtonSound.Paint = function(pnl, w, h )		
			surface.SetDrawColor( 255, 255, 255, 255 )
			if soundisplayed then
				surface.SetMaterial( speakeron )
			else
				surface.SetMaterial( speakeroff )
			end
			surface.DrawTexturedRect( 0,0,w,h )
		end
		
		DButtonSound.DoClick = function( pnl )
			if soundisplayed then
				soundisplayed = false
				RunConsoleCommand( "stopsound" )
			else
				soundisplayed = true
				sound.PlayURL( URLsound, "", 
				function( station )
					if IsValid( station ) then
						station:Play() 
					end 
				end )
			end
		end
	
	end
	
	local DButton = vgui.Create( "DButton", DPanel)
	DButton:SetSize( 150,30 )
	DButton:SetPos( (sizex-150)/2, sizey/2 + 100 )
	DButton:SetText( "" )	
	DButton.Paint = function(pnl, w, h )
		
		local perc = 1
		
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		
		end
		
		draw.RoundedBox( 0, 0,0,w,h, Color(0,0,0,100))
		draw.RoundedBox(0,0,0,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,h-2,w,2, Color(255,255,255,255))
		draw.RoundedBox(0,0,0,2,h, Color(255,255,255,255 ))
		draw.RoundedBox(0,w-2,0,2,h, Color(255,255,255,255))
		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[35][CLOTHESMOD.Config.Lang], "Bariol25",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton.DoClick = function( pnl )
		removeTime = CurTime()
		DPanel:MoveTo( 0, -100, 1, 0, -1, function()
			DPanel:Remove()
			OpenCharacterPage( Frame, sizex, sizey )
		end )
	end
end

function CM_OpenNewCharacterGUI()
	local sizex, sizey = ScrW(),ScrH()
	
	if CLOTHESMOD.Config.HasSound then
	
		local URLsound = CLOTHESMOD.Config.IntroSoundURL

		sound.PlayURL( URLsound, "", 
		function( station )
			if IsValid( station ) then
				station:Play()
				soundisplayed = true
			end 
		end )
	
	end

	DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()-sizex)/2, (ScrH()-sizey)/2 )
	DermaPanel:SetSize( sizex, sizey )
	DermaPanel:SetTitle( "" )
	DermaPanel:SetDraggable( false )
	DermaPanel:ShowCloseButton( false )
	DermaPanel:MakePopup()
	DermaPanel.Paint = function( pnl, w, h )
		DrawBlurRect(0,0, sizex, sizey*0.15, 6, 10)
		DrawBlurRect(0,ScrH()-sizey*0.15, sizex, sizey*0.15, 6, 10)
		
		DrawBlur( pnl, 8, 16 )
		
		draw.RoundedBox( 0, 0,0,sizex,sizey*0.15, Color(0,0,0,245))
		draw.RoundedBox( 0, 0,ScrH()-sizey*0.15,sizex,sizey*0.15, Color(0,0,0,245))

		DrawBlur( pnl, 8, 16 )
		
		draw.RoundedBox( 0, 0,0,sizex,sizey*0.15, Color(0,0,0,245))
		draw.RoundedBox( 0, 0,ScrH()-sizey*0.15,sizex,sizey*0.15, Color(0,0,0,245))

		
	end	
	DermaPanel.OnClose = function()
		RunConsoleCommand( "stopsound" )
	end
	
	local DPanel = vgui.Create( "DPanel",DermaPanel )
	DPanel:SetPos( 0,sizey*0.15 )
	DPanel:SetSize( sizex, sizey*0.7 )
	DPanel.Paint = function() end
	
	OpenIntro( DPanel, sizex, sizey*0.7 )
end

-- CM_OpenNewCharacterGUI()