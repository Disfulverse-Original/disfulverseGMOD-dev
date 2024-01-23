surface.CreateFont( "Bariol1001", {
	font = "Cambria", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 25,
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

include("shared.lua")

local nsize = 150

surface.CreateFont( "FontNPCName", { font = "Cambria", extended  = true, antialias = true, italic = true, blursize = 0, weight = 700, size = 118})

function ENT:Draw()
    if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end
    self:DrawModel()
    local ShopName = self:GetNWString("EmployerName")
    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 50000 then
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, AAS.LocalPlayer:EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(16, -500, -3100, 1000, 170, AAS.Colors["background"], true, true, false, false)
        draw.RoundedBox(0, -500, -2950, 1000, 20, AAS.Colors["white"])
        draw.DrawText("Изменение имени", "FontNPCName", 0, -3085, AAS.Colors["white"], TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end




local blur = Material("pp/blurscreen")

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

function ENT:OpenNameMenu( ent )
	
	local errInfos = ""
	local infos = LocalPlayer():CM_GetInfos()
	local ent = ent or NULL
	
	local sizex = 430
	local sizey = 250
	
	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos( (ScrW()-sizex)/2, (ScrH()-sizey)/2 )
	DermaPanel:SetSize( sizex, sizey )
	DermaPanel:SetTitle( "" )
	DermaPanel:SetDraggable( false )
	DermaPanel:ShowCloseButton( false )
	DermaPanel:MakePopup()
	DermaPanel.Paint = function( pnl, w, h )
		DrawBlur( pnl, 3, 4 )
		draw.RoundedBox(0,0,0, w, h, Color(0, 0, 0,150))
		draw.RoundedBox(0,0,0, 2, h, Color(0, 0, 0))
		draw.RoundedBox(0,0,0, w, 2, Color(0, 0, 0))
		draw.RoundedBox(0,0,h-2, w, 2, Color(0, 0, 0))
		draw.RoundedBox(0,w-2,0, 2, h, Color(0, 0, 0))
		
		if errInfos and errInfos ~= "" then
			draw.SimpleText( errInfos, "Bariol1001",w/2,70+40+40+35,Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
		end
		
	end
	
	local Panel = vgui.Create( "DPanel", DermaPanel )
	Panel:SetPos( 2, 2 )
	Panel:SetSize( sizex-4, 40 )
	Panel.Paint = function( pnl, w, h )
		draw.RoundedBox(0,0,0, w, h, Color(0, 0, 0,150))
		draw.SimpleText( CLOTHESMOD.Config.Sentences[63][CLOTHESMOD.Config.Lang], "Bariol1001", 10,7.5, Color(255,255,255) )
	end
	
	local DermaButtonClose = vgui.Create( "DButton", DermaPanel )
	DermaButtonClose:SetText( "" )
	DermaButtonClose:SetPos( sizex-42, 2 )
	DermaButtonClose:SetSize( 40, 40 )
	DermaButtonClose.DoClick = function()
		DermaPanel:Close()
	end	
	DermaButtonClose.Paint = function( pnl, w , h )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,120 ) )
		draw.SimpleText( "X", "Bariol1001", w/2, h/2, Color(255,255,255),1,1 )
		
	end
	
	local DLabel = vgui.Create( "DLabel", DermaPanel )
	DLabel:SetPos( 20, 40+10 )
	DLabel:SetSize( sizex-40, 50 )
	DLabel:SetFont( "Bariol1001" )
	DLabel:SetWrap( true )
	DLabel:SetText(CLOTHESMOD.Config.Sentences[64][CLOTHESMOD.Config.Lang].." "..CLOTHESMOD.Config.Sentences[56][CLOTHESMOD.Config.Lang].." "..CLOTHESMOD.Config.PriceChangingName..""..CLOTHESMOD.Config.MoneyUnit..".")

	local TextEntry = vgui.Create( "DTextEntry", DermaPanel ) -- create the form as a child of frame
	TextEntry:SetPos( sizex/2-100, 70 + 40 )
	TextEntry:SetSize( 200, 30 )
	TextEntry:SetText( infos.name )
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
		-- infos.name = TextEntry:GetValue()
	end
	
	local TextEntry2 = vgui.Create( "DTextEntry", DermaPanel ) -- create the form as a child of frame
	TextEntry2:SetPos( sizex/2-100, 70 + 40 * 2 )
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
		-- infos.surname = TextEntry2:GetValue()
	end
	
	local ButtonAccept = vgui.Create( "DButton", DermaPanel )
	ButtonAccept:SetText( "" )
	ButtonAccept:SetPos( 0, sizey-40 )
	ButtonAccept:SetSize( sizex, 40 )
	ButtonAccept.DoClick = function()
		if string.len( TextEntry:GetValue() ) < 3 or string.len( TextEntry2:GetValue() ) < 3 then
			errInfos = CLOTHESMOD.Config.Sentences[68][CLOTHESMOD.Config.Lang]
		else
			DermaPanel:Close()
			net.Start("ClothesMod:ChangeName")
				net.WriteString(TextEntry:GetValue())
				net.WriteString(TextEntry2:GetValue())
				net.WriteEntity(self)
			net.SendToServer()
		end
	end	
	ButtonAccept.Paint = function( pnl, w , h )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,120 ) )
		draw.SimpleText( CLOTHESMOD.Config.Sentences[65][CLOTHESMOD.Config.Lang], "Bariol1001", w/2, h/2, Color(255,255,255),1,1 )
		
	end
	
end