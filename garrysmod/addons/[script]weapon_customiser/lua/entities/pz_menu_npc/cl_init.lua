--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

include( "shared.lua" )

--[[local function overflowNumber( num, max )
	return num > max and 1 or num
end

local function drawGlitched( x, y, color, glitchMode, drawFunc )
	local offset = 2
	for i = 1, 3 do
		local glitchMode = overflowNumber( glitchMode+(i-1), 3 )
		local txtColor = Color( i == 1 and 255 or 0, i == 3 and 255 or 0, i == 2 and 255 or 0 )
		drawFunc( x+(glitchMode == 1 and offset or 0)+(glitchMode == 3 and -offset or 0), y+(glitchMode == 2 and offset or 0)+(glitchMode == 3 and -offset or 0), txtColor )
	end
		
	drawFunc( x, y, color )
end

local iconMat = Material( "project0/icons/paint_64.png", "noclamp smooth" )
local blackColor = Color( 0, 0, 0 )
local blackColorNone = Color( 0, 0, 0, 0 )
local boxColor1, boxColor2 = PROJECT0.FUNC.GetTheme( 4, 100 ), PROJECT0.FUNC.GetTheme( 1, 0 )
function ENT:Draw()
	self:DrawModel()

    local pos = self:GetPos()
    local ang = self:GetAngles()

    ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	local distance = LocalPlayer():GetPos():DistToSqr( self:GetPos() )
	if( distance > PROJECT0.CONFIG.GENERAL.DisplayDistance3D2D ) then return end

	if( CurTime() >= (self.lastUIAnim or 0)+0.5 ) then
		self.animToggle = not self.animToggle
		self.lastUIAnim = CurTime()
	end

	self.glitchMode = self.glitchMode or 1
	if( CurTime() >= (self.lastUIGlitch or 0)+0.1 ) then
		self.glitchMode = overflowNumber( self.glitchMode+1, 3 )
		self.lastUIGlitch = CurTime()
	end

	surface.SetAlphaMultiplier( 1-distance/PROJECT0.CONFIG.GENERAL.DisplayDistance3D2D )
	cam.Start3D2D( pos + ang:Up() * 0.5, ang, 0.05 )
		surface.SetFont( "3D2D.MontserratBold60" )
	
		local textW, textH = surface.GetTextSize( PROJECT0.L( "weapon_cosmetics" ) )
		local iconSize = 50

		local width, height = math.floor( textW+iconSize+10 ), math.floor( textH+50 )

		local yPos = math.floor( -(self:OBBMaxs().z*21	)-height )
		local xPos = math.floor( -width/2 )

		local boxW = width*1.5
		PROJECT0.FUNC.DrawGradientBox( math.floor( -boxW/2 ), yPos, math.floor( boxW ), height, 2, boxColor2, boxColor1, boxColor2 )

		local dashes = 15
		local dashSpacing = 10
		local dashW = (width-((dashes-1)*dashSpacing))/dashes
		local dashH = 3

		for row = 1, 2 do
			for i = 1, dashes do
				local x, y, w, h = -width/2+(i-1)*(dashW+dashSpacing), row == 1 and yPos or yPos+height-dashH, dashW, dashH

				surface.SetDrawColor( blackColor )
				surface.DrawRect( x+1, y+1, w, h )

				local isFirst = i == 1
				if( isFirst or i == dashes ) then
					PROJECT0.FUNC.DrawGradientBox( x, y, w, h, 2, PROJECT0.FUNC.GetTheme( isFirst and 3 or 4 ), PROJECT0.FUNC.GetTheme( isFirst and 4 or 3 ) )
					continue
				end

				surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
				surface.DrawRect( x, y, w, h )
			end
		end

		drawGlitched( width/2, yPos+height/2, PROJECT0.FUNC.GetTheme( 3 ), self.glitchMode, function( x, y, color )
			draw.SimpleText( PROJECT0.L( "weapon_cosmetics" ), "3D2D.MontserratBold60", x, y, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end )

		drawGlitched( -width/2, yPos+height/2-iconSize/2, PROJECT0.FUNC.GetTheme( 3 ), self.glitchMode, function( x, y, color )
			surface.SetMaterial( iconMat )
			surface.SetDrawColor( color )
			surface.DrawTexturedRect( x, y, iconSize, iconSize )
		end )
	cam.End3D2D()
	surface.SetAlphaMultiplier( 1 )
end]]

surface.CreateFont( "WEAPONCOSMETIC", {
 font = "Roboto",
 size = 95,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

local iconMat1 = Material( "project0/icons/weapon.png", "noclamp smooth" )
function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        local height = 100
        local YPos = -3010
        local Padding = 10
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(20, -500, -3100, 1000, 170, Color(48, 47, 49, 245), true, true, false, false)
        draw.RoundedBox(0, -500, -2950, 1000, 20, Color(255, 255, 255, 255))
        draw.DrawText("Оружейная косметика", "WEAPONCOSMETIC", 20, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )
        
        local iconSize = 64
        surface.SetMaterial(iconMat1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-iconSize / 0.135, YPos + (height / 100) - (iconSize / 1.5), iconSize, iconSize)
        
        cam.End3D2D()
    end
end
