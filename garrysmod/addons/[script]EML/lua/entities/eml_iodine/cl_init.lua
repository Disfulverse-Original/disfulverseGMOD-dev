include("shared.lua");

function ENT:Initialize()	

end;

function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(16, -500, -470, 1000, 170, Color(21, 41, 56, 255), true, true, false, false)
        draw.RoundedBox(0, -500, -320, 1000, 20, Color(210, 105, 30, 255))
        draw.DrawText("Жидкий йод ("..self:GetNWInt("amount").." л)", "methFont", 0, -425, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        cam.End3D2D()
    end;
end;

-- maxAmount = 60
-- amount = x

