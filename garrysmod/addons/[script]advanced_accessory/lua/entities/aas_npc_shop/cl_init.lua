/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */

--[[function ENT:Draw()
	if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end

	self:DrawModel()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 0)
	ang:RotateAroundAxis(ang:Forward(), 85)	
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796
	
	if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 40000 then
		cam.Start3D2D(pos + ang:Up()*0, Angle(0, AAS.LocalPlayer:EyeAngles().y-90, 90), 0.025)

			draw.RoundedBoxEx(16, -500, -3100, 1000, 170, AAS.Colors["background"], true, true, false, false)
			draw.RoundedBox(0, -500, -2950, 1000, 20, AAS.Colors["black150"])

			draw.SimpleText(AAS.ItemNpcName, "AAS:Font:08", 0, -3085, AAS.Colors["white"], TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end 
end]]

surface.CreateFont( "AASNPCACC", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

local iconMat1 = Material( "project0/icons/charm.png", "noclamp smooth" )
function ENT:Draw()
    if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end

    self:DrawModel()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        local height = 100
        local YPos = -2964
        local Padding = 10
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(20, -500, -3100, 1000, 170, Color(48, 47, 49, 245), true, true, false, false)
        draw.RoundedBox(0, -500, -2950, 1000, 20, Color(255, 255, 255, 255))
        draw.SimpleText(AAS.ItemNpcName, "AASNPCACC", 0, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )

        local iconSize = 64
        surface.SetMaterial(iconMat1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-iconSize / 0.15, YPos + (height / 100) - (iconSize / 0.70), iconSize, iconSize)

        cam.End3D2D()
    end
end