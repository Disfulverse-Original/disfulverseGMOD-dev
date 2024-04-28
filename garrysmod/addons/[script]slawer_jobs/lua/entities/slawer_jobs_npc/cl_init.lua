include("shared.lua")

surface.CreateFont( "NPCFONT1", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true,
 shadow = false,
} )


local iconMat1 = Material( "project0/icons/name_24.png", "noclamp smooth" )
function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    if not Slawer.Jobs.CFG.EnableNPCTitle then return end

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
        draw.DrawText(self:GetNPCName(), "NPCFONT1", 0, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )

        local iconSize = 64
        surface.SetMaterial(iconMat1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-iconSize / 0.15, YPos + (height / 100) - (iconSize / 1.4), iconSize, iconSize)

        cam.End3D2D()
    end
end

