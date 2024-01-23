include("shared.lua")

surface.CreateFont( "FontNPCName3", { font = "Cambria", extended  = true, antialias = true, shadow = true, blursize = 0, weight = 700, size = 118})

function ENT:Draw()
    if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end
    self:DrawModel()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 400000 then
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, AAS.LocalPlayer:EyeAngles().y - 90, 90), 0.016)
        draw.RoundedBoxEx(16, -500, -3100, 1000, 170, AAS.Colors["background"], true, true, false, false)
        draw.RoundedBox(0, -500, -2950, 1000, 20, AAS.Colors["white"])
        draw.DrawText("Гардероб", "FontNPCName3", 0, -3085, AAS.Colors["white"], TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end
