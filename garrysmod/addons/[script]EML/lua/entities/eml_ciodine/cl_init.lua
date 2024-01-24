include("shared.lua");

surface.CreateFont("methFont", {
	font = "Roboto",
	size = 30,
	weight = 600,
	extended = true,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});

function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()

	
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.1)
				draw.SimpleText("Йод кристаллический ("..self:GetNWInt("amount").." кг)", "methFont", 32, -96, Color(255, 255, 255, 75), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);			
		cam.End3D2D()	
	end;
end;

-- maxAmount = 60
-- amount = x

