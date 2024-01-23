include("shared.lua")

local nsize = 0
local ent

surface.CreateFont( "FontNPCName1", { font = "Cambria", extended  = true, antialias = true, shadow = false, italic = true, blursize = 0, weight = 700, size = 118})

function ENT:Draw()
    if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end
    self:DrawModel()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 50000 then
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, AAS.LocalPlayer:EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(16, -500, -3100, 1000, 170, AAS.Colors["background"], true, true, false, false)
        draw.RoundedBox(0, -500, -2950, 1000, 20, AAS.Colors["white"])
        draw.DrawText("Изменение пола", "FontNPCName1", 0, -3085, AAS.Colors["white"], TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end


local infos 

local defMaleInfos = {
	model = "models/kerry/player/citizen/male_01.mdl",
	name = "Julien",
	surname = "Smith",
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
		basetexture = "models/citizen/body/citizen_sheet", -- name of the tee chosen in the first part of the menu
		hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
	},
	panttexture = {
		basetexture = "models/citizen/body/citizen_sheet",
	},
}

local defFemaleInfos = {
	model = "models/kerry/player/citizen/female_01.mdl",
	name = "Julien",
	surname = "Smith",
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
		basetexture = "models/humans/modern/female/sheet_01", -- name of the tee chosen in the first part of the menu
		hasCustomThings = false, -- if has custom things or not, if true then basetexture should be an id
	},
	panttexture = {
		basetexture = "models/humans/modern/female/sheet_01",
	},
}

surface.CreateFont( "Bariol400", {
	font = "Cambria", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 20,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
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
local top = Material("materials/clothesmod/pay.png")
local pant = Material("materials/clothesmod/exit.png")
local male = Material("materials/clothesmod/male.png")
local female = Material("materials/clothesmod/female.png")
local modelPanel

local OpenIntro
local OpenCharacterPage

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
local OpenInfosPage = function( Panel )

	local w, h = Panel:GetSize()

	local DPanel2 = vgui.Create( "DPanel", Panel )
	DPanel2:SetSize( w, h )
	DPanel2:SetPos( 0, 0 )
	DPanel2.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[32][CLOTHESMOD.Config.Lang], "Bariol400",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
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
		
		if LocalPlayer():CM_GetInfos().sex == 1 then
			infos = table.Copy(LocalPlayer():CM_GetInfos())
		else
			infos = defMaleInfos
		end
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
		if LocalPlayer():CM_GetInfos().sex == 0 then
			infos = table.Copy(LocalPlayer():CM_GetInfos())
		else
			infos = defFemaleInfos
		end
		modelPanel.Actualize()
	end
	
	local DLabel = vgui.Create( "DLabel", DPanel2 )
	DLabel:SetPos( 20, h/4-80/2 +20+80+30 )
	DLabel:SetSize( w-40, 40 )
	DLabel:SetWrap( true )
	DLabel:SetFont( "Bariol400" )
	DLabel:SetText( CLOTHESMOD.Config.Sentences[53][CLOTHESMOD.Config.Lang] )
	DLabel:SetContentAlignment( 8 )
	
end

local OpenEyesMenu = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[33][CLOTHESMOD.Config.Lang], "Bariol400",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
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

local OpenPayMenu = function( Panel )
	local lastpos = 0
	
	local sizex, sizey = Panel:GetSize()
	
	local err = ""
	
	local DPanel= vgui.Create("DScrollPanel", Panel)
	DPanel:SetPos(2,2)
	DPanel:SetSize(sizex-4,sizey-4)
	
	local price = 0
	
	if infos.sex ~= LocalPlayer():CM_GetInfos().sex then
		price = price + CLOTHESMOD.Config.PriceToChangeSex
	end
	if infos.model ~= LocalPlayer():CM_GetInfos().model or infos.skin ~= LocalPlayer():CM_GetInfos().skin then
		price = price + CLOTHESMOD.Config.PriceToChangeHead
	end
	if infos.eyestexture.basetexture["r"] ~= LocalPlayer():CM_GetInfos().eyestexture.basetexture["r"] then
		price = price + CLOTHESMOD.Config.PriceToChangeEyes
	end
	
	DPanel.Paint = function(pnl,w,h)
		draw.SimpleText( CLOTHESMOD.Config.Sentences[54][CLOTHESMOD.Config.Lang], "Bariol400",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.SimpleText( CLOTHESMOD.Config.Sentences[55][CLOTHESMOD.Config.Lang], "Bariol400",w/2,60,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[56][CLOTHESMOD.Config.Lang].." : "..price..CLOTHESMOD.Config.MoneyUnit, "Bariol400",w/2,80,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		if err ~= "" then
			draw.SimpleText( CLOTHESMOD.Config.Sentences[10][CLOTHESMOD.Config.Lang].." : "..err, "Bariol400",w/2,110+10+30,Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
		end
	end

	
	
	local sbar = DPanel:GetVBar()

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
	
	local button = vgui.Create("DButton", DPanel)
	button:SetPos((sizex-4)/2-100/2,110)
	button:SetSize(100,30)
	button:SetText("")

	function button:DoClick()
		
		if price == 0 then
			err = CLOTHESMOD.Config.Sentences[57][CLOTHESMOD.Config.Lang]
			return
		end
		
		if not LocalPlayer():canAfford( price ) then
			err = CLOTHESMOD.Config.Sentences[41][CLOTHESMOD.Config.Lang]
			return
		end
	
		DermaPanel:Remove()
		net.Start("ClothesMod:Surgery")
			net.WriteEntity( ent )
			net.WriteTable( infos )
		net.SendToServer()
	end
	
	button.Paint = function(pnl,w,h)
		local we = 2
		draw.RoundedBox(0,0,0,w,h, Color(0, 0, 0,150))
		draw.RoundedBox(0,0,0,w,we,Color(255,255,255,255))
		draw.RoundedBox(0,0,h-we,w,we,Color(255,255,255,255))
		draw.RoundedBox(0,0,0,we,h,Color(255,255,255,255))
		draw.RoundedBox(0,w-we,0,we,h,Color(255,255,255,255))
		draw.SimpleText( "> "..CLOTHESMOD.Config.Sentences[58][CLOTHESMOD.Config.Lang], "Bariol400",w/2-5,h/2,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, 1 )
	end	
	
end

local OpenHeadPage = function( Panel )
	local DPanel = vgui.Create( "DPanel", Panel )

	local w, h = Panel:GetSize()
	
	DPanel:SetSize( w, h )
	DPanel:SetPos( 0,0 )
	DPanel.Paint = function()
		draw.SimpleText( CLOTHESMOD.Config.Sentences[34][CLOTHESMOD.Config.Lang], "Bariol400",w/2,30,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
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
		
		-- draw.SimpleText( "CONTINUE", "Bariol400",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
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
		
		-- draw.SimpleText( "CONTINUE", "Bariol400",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
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
		
		-- draw.SimpleText( "CONTINUE", "Bariol400",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton4.DoClick = function( pnl )
		if pnOpen == 4 then return end
		pnOpen = 4
		DPanelMenuC:SizeTo(0, panely, 0.5, 0, -1, function()
			for k, v in pairs( DPanelMenuC:GetChildren() ) do
				v:Remove()
			end
			
			DPanelMenuC:SizeTo(panelx, panely, 0.5, 0, -1, function()
				OpenPayMenu( DPanelMenuC )
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
		
		-- draw.SimpleText( "CONTINUE", "Bariol400",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton5.DoClick = function( pnl )
		DermaPanel:Remove()
	end

end
OpenIntro = function( Frame, sizex, sizey )
	
	local sizeym = sizey * 1
	local sizexm = sizeym * 0.7
	
	local DPanel = vgui.Create( "DPanel",Frame )
	DPanel:SetPos( 0,50 )
	DPanel:SetSize( sizex, sizey)
	local removeTime = -1
	local startTime = CurTime()
	DPanel:SetAlpha( 0 )
	DPanel:MoveTo( 0,0,1,0,-1, function() end )
	
	local sizexRB = 0
	local sizeyRB = 0
	
	local posxRB = 0
	local posyRB = 0
	
	DPanel.Paint = function(pnl, w, h)
		
		local perc = 1
		
		if removeTime ~= -1 then
		
			perc = (1-math.Clamp(CurTime() - removeTime, 0, 1))/2
		else
			
			perc = ( math.Clamp(CurTime() - startTime, 0, 1) )
		
		end
		
		DPanel:SetAlpha(255 * perc)
		
		surface.SetFont( "DermaLarge" )
		surface.SetTextColor( 255, 255, 255, 255 )
		
		draw.RoundedBox( 0, posxRB,posyRB,sizexRB,sizeyRB, Color(0,0,0,150))

		local text = CLOTHESMOD.Config.Sentences[59][CLOTHESMOD.Config.Lang]
		
		local sizetx1, sizety = surface.GetTextSize(text)
	
		surface.SetTextPos( (sizex-sizetx1)/2, (sizey-sizety)/2 )
		surface.DrawText( text )		
			
		local text2 =  CLOTHESMOD.Config.Sentences[60][CLOTHESMOD.Config.Lang]
		
		sizeyRB =( sizey/2 + 75 - (sizey-sizety)/2 ) + 30 + 20
			
		local sizetx2, sizety = surface.GetTextSize(text2)

		surface.SetTextPos( (sizex-sizetx2)/2, (sizey-sizety)/2+sizety )
		surface.DrawText( text2 )
		
		local sizetx
		
		if sizetx1 > sizetx2 then
			sizetx = sizetx1
		else
			sizetx = sizetx2
		end
		
		posxRB = (sizex-sizetx)/2 - 10
		posyRB = (sizey-sizety)/2 - 10
		sizexRB = sizetx + 20
		
		draw.RoundedBox(0,posxRB,posyRB,sizexRB,2, Color(255,255,255,255))
		draw.RoundedBox(0,posxRB,posyRB+sizeyRB-2,sizexRB,2, Color(255,255,255,255))
		draw.RoundedBox(0,posxRB,posyRB,2,sizeyRB, Color(255,255,255,255 ))
		draw.RoundedBox(0,posxRB+sizexRB-2,posyRB,2,sizeyRB, Color(255,255,255,255))
		
	end
	
	local DmodelPanel = vgui.Create( "DModelPanel", DPanel )
	
	DmodelPanel:SetSize( sizexm, sizeym )
	DmodelPanel:SetPos( 0,0 )
	
	function DmodelPanel:LayoutEntity( Entity ) return end
	DmodelPanel:SetModel( "models/player/kleiner.mdl" )
	local startpos = DmodelPanel.Entity:GetBonePosition( DmodelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) or 0)
	DmodelPanel:SetLookAt( startpos )
	DmodelPanel:SetCamPos( startpos - Vector( -22,10,0) )
	DmodelPanel.Entity:SetEyeTarget( startpos - Vector( -22,10,0) )


	local DButton = vgui.Create( "DButton", DPanel)
	DButton:SetSize( 150,30 )
	DButton:SetPos( (sizex)/2-0.5, sizey/2 + 70 )
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
		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[61][CLOTHESMOD.Config.Lang], "Bariol400",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	
	DButton.DoClick = function( pnl )
		removeTime = CurTime()
		DPanel:MoveTo( 0, -100, 1, 0, -1, function()
			DPanel:Remove()
			OpenCharacterPage( Frame, sizex, sizey )
		end )
	end
	local DButton2 = vgui.Create( "DButton", DPanel)
	DButton2:SetSize( 150,30 )
	DButton2:SetPos( (sizex)/2-150+0.5, sizey/2 + 70 )
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
		
		draw.SimpleText( CLOTHESMOD.Config.Sentences[62][CLOTHESMOD.Config.Lang], "Bariol400",150/2,30/2-1,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end
	DButton2.DoClick = function( pnl )
		-- removeTime = CurTime()
		-- DPanel:MoveTo( 0, -100, 1, 0, -1, function()
			-- DPanel:Remove()
			-- OpenCharacterPage( Frame, sizex, sizey )
		-- end )
		DermaPanel:Remove()
	end
end

local function CM_OpenChangeCharacterGUI()
	
	infos = table.Copy(LocalPlayer():CM_GetInfos())
	
	local sizex, sizey = ScrW(),ScrH()

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
	
	local DPanel = vgui.Create( "DPanel",DermaPanel )
	DPanel:SetPos( 0,sizey*0.15 )
	DPanel:SetSize( sizex, sizey*0.7 )
	DPanel.Paint = function() end
	
	OpenIntro( DPanel, sizex, sizey*0.7 )
end



function ENT:OpenGUI()	
	ent = self
	CM_OpenChangeCharacterGUI()
end