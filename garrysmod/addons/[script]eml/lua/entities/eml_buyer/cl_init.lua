include("shared.lua")

function ENT:Draw()
	self:DrawModel();
end;

surface.CreateFont( "METHFONT", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

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
        draw.DrawText("Скупщик мета", "METHFONT", 0, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )
        cam.End3D2D()
    end
end