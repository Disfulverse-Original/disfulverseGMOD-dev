--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]


include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	if  Realistic_Properties.Activate3D2DNpc then 
		local pos = self:GetPos()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 0)
		ang:RotateAroundAxis(ang:Forward(), 85)	
		if LocalPlayer():GetPos():Distance(self:GetPos()) < 500 then
			cam.Start3D2D(pos + ang:Up()*0, Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.025)
			if (self:GetDTInt(1) == 0) then
				draw.SimpleTextOutlined(Realistic_Properties.NameNpc, "rps_font_9", 0, -3050, Realistic_Properties.Colors["white"] , TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Realistic_Properties.Colors["white"] );		
			end
			cam.End3D2D()
		end 
	end 
end 