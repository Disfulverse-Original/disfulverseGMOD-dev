--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = EyeAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("HUDNumber5")
	local text = ECL.Language.Entities.Cocaine
	local text2 = DarkRP.getPhrase("priceTag", DarkRP.formatMoney(self:GetNWInt("price"), ""))
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(text2)

	Ang:RotateAroundAxis(Ang:Up(),-90)
	Ang:RotateAroundAxis(Ang:Forward(),90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		local y = ScrH()/2
		local x = ScrW()/2
		local vec = Pos 
		local screen = vec:ToScreen()
		local dis = math.Round(math.sqrt((x-screen.x)^2 + (y-screen.y)^2))
		local dis2 = math.Round(LocalPlayer():GetPos():Distance(Pos));
		local fadein = self:GetNWBool("fadein");
		local aiming = self:GetNWBool("aiming");
		local distance = self:GetNWInt("distance");
		local alpha = math.Round((100-distance)*3.55)
		if fadein and aiming then 
			distance = (dis+dis2)/2;
			alpha = math.Round((100-distance)*3.55)
		elseif fadein then
			distance = dis2;
			alpha = math.Round((100-distance)*3.55)
		elseif aiming then
			distance = dis;
			alpha = math.Round((100-distance)*3.55)
		elseif !fadein and !aiming then
			alpha = 255;
		end

		if alpha < 20 then
			alpha = alpha - 20
		end

		cam.Start3D2D(Pos + Ang:Up()*5 + Ang:Right()*-5, Ang, 0.05)
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, -14, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
			draw.SimpleTextOutlined( text2, "HUDNumber5", -TextWidth2*0.5 + 5, 24, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()
	end
end