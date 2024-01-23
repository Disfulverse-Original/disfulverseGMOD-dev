/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8

function ENT:Draw()
	if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

    self:DrawModel()

    local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 0)
	ang:RotateAroundAxis(ang:Forward(), 85)	
	
	if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 40000 then
		cam.Start3D2D(pos + ang:Up()*0, Angle(0, AAS.LocalPlayer:EyeAngles().y-90, 90), 0.025)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773

			draw.RoundedBoxEx(16, -500, -2150, 1000, 170, AAS.Colors["background"], true, true, false, false)
			draw.RoundedBox(0, -500, -2000, 1000, 20, AAS.Colors["black150"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

			draw.SimpleText(AAS.ModelName, "AAS:Font:08", 0, -2135, AAS.Colors["white"], TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end 
end
