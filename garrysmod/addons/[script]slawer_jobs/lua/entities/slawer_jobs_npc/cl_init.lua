include("shared.lua")

surface.CreateFont( "NPCFONT1", {
 font = "Roboto",
 size = 49,
 weight = 1000,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    if not Slawer.Jobs.CFG.EnableNPCTitle then return end

    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        local vecPos = self:LocalToWorld(Vector(4, -1, 77))
        local angPos = self:LocalToWorldAngles(Angle(0, LocalPlayer():EyeAngles().y - self:GetAngles().y - 90, 90))

        cam.Start3D2D(vecPos, angPos, 0.050)
        draw.RoundedBoxEx(10, -250, -25, 500, 85, Color(21, 40, 56, 255), true, true, false, false)
        draw.RoundedBox(0, -250, 50, 500, 10, Color(255, 255, 255, 255))
        draw.DrawText(self:GetNPCName(), "NPCFONT1", 0, -11, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end