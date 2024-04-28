--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]


include("shared.lua")

surface.CreateFont( "HOMEFONT", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

local iconMat1 = Material( "project0/icons/search.png", "noclamp smooth" )
function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local Padding = 10
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        local height = 100
        local YPos = -2965
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(20, -530, -3100, 1100, 170, Color(48, 47, 49, 245), true, true, false, false)
        draw.RoundedBox(0, -530, -2950, 1100, 20, Color(255, 255, 255, 255))
        draw.SimpleText("Риелтор", "HOMEFONT", 10, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )

        local iconSize = 64
        surface.SetMaterial(iconMat1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-iconSize / 0.155, YPos + (height / 400) - (iconSize / 0.72), iconSize, iconSize)

        cam.End3D2D()
    end
end