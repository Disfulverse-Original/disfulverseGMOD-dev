include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    if not Slawer.Jobs.CFG.EnableNPCTitle then return end

    if ( LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 90000 ) then return end

    local vecPos = self:LocalToWorld(Vector(4, -1, 77))
    local angPos = self:LocalToWorldAngles(Angle(0, LocalPlayer():EyeAngles().y - self:GetAngles().y - 90, 90))

    cam.Start3D2D(vecPos, angPos, 0.05)
        draw.SimpleTextOutlined(self:GetNPCName(), "Slawer.Jobs:95", 0, -5, color_white, 1, 0, 3, color_black)
    cam.End3D2D()
end


