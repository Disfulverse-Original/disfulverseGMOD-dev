include('shared.lua')

--[[function ENT:Draw()
	self:DrawModel()

	local ShopName = ((BRICKS_SERVER.CONFIG.NPCS or {})[(self:GetNPCKeyVar() or 0)] or {}).Name or self.PrintName

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)

	local YPos = -(self:OBBMaxs().z*20)-5

	local Distance = LocalPlayer():GetPos():DistToSqr( self:GetPos() )

	if( Distance < BRICKS_SERVER.CONFIG.GENERAL["3D2D Display Distance"] ) then
		cam.Start3D2D(Pos + Ang:Up() * 0.5, Ang, 0.05)
		
			surface.SetFont("BRICKS_SERVER_Font45")
		
			local width, height = surface.GetTextSize( ShopName )
			width, height = width+20, height+15

			draw.RoundedBox( 5, -(width/2)-Padding, YPos-(height+(2*Padding)), width+(2*Padding), height+(2*Padding), BRICKS_SERVER.Func.GetTheme( 1 ) )		
			draw.RoundedBox( 5, -(width/2)-Padding, YPos-(height+(2*Padding)), 20, height+(2*Padding), BRICKS_SERVER.Func.GetTheme( 5 ) )	

			surface.SetDrawColor( BRICKS_SERVER.Func.GetTheme( 1 ) )
			surface.DrawRect( -(width/2)-Padding+5, YPos-(height+(2*Padding)), 15, height+(2*Padding) )

			draw.SimpleText( ShopName, "BRICKS_SERVER_Font45", 0, YPos-((height+(2*Padding))/2), BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 1 )
			
		cam.End3D2D()
	end
end]]

surface.CreateFont( "BRICKNPCFONT", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

local iconMat1 = Material( "project0/icons/store.png", "noclamp smooth" )
function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    local ShopName = ((BRICKS_SERVER.CONFIG.NPCS or {})[(self:GetNPCKeyVar() or 0)] or {}).Name or self.PrintName

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local Padding = 10
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        local height = 100
        local YPos = -2965
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(20, -500, -3100, 1000, 170, Color(48, 47, 49, 245), true, true, false, false)
        draw.RoundedBox(0, -500, -2950, 1000, 20, Color(255, 255, 255, 255))
        draw.SimpleText(ShopName, "BRICKNPCFONT", 0, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )

        local iconSize = 64
        surface.SetMaterial(iconMat1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-iconSize / 0.15, YPos + (height / 100) - (iconSize / 0.72), iconSize, iconSize)

        cam.End3D2D()
    end
end