--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

include("shared.lua")

--[[function ENT:Draw()
    if not IsValid(ACC2.LocalPlayer) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

    self:DrawModel()
	
    local pos = self:GetPos()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
    
    if ACC2.LocalPlayer:GetPos():DistToSqr(pos) < 800000 then
		local name = ACC2.GetSetting("npcModificationName", "string") or ""

		cam.Start3D2D(pos + ACC2.Constants["vectorNPC"], Angle(0, ACC2.LocalPlayer:EyeAngles().y-90, 90), 0.025)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

			surface.SetFont("ACC2:Font:20")
			local size = surface.GetTextSize(name)*1.15

			draw.RoundedBox(0, -size/2, -2150, size, 250, ACC2.Colors["blackpurple"])
			draw.RoundedBox(0, -size/2, -1930, size, 30, ACC2.Colors["purple"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

			draw.DrawText(name, "ACC2:Font:20", 5, -2120, ACC2.Colors["white"], TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end 
end]]

surface.CreateFont( "NAMEEDIT1", {
 font = "Roboto",
 size = 100,
 weight = 700,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 extended = true
} )

local iconMat1 = Material( "project0/icons/edit.png", "noclamp smooth" )
function ENT:Draw()
    if not IsValid(self) or not IsValid(LocalPlayer()) then return end

    self:DrawModel()

    local name = ACC2.GetSetting("npcModificationName", "string") or ""

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
        draw.SimpleText(name, "NAMEEDIT1", 40, YPos - ((height + (2 * Padding)) / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, 1 )

        local iconSize = 64
        surface.SetMaterial(iconMat1)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-iconSize / 0.130, YPos + (height / 400) - (iconSize / 0.72), iconSize, iconSize)

        cam.End3D2D()
    end
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
