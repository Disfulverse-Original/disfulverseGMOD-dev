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

	local iodineColor = EML_Iodine_Color;
	
	if (self:GetNWInt("amount")>0) then
		iodineColor = Color(255, 255, 255, 150);
	else
		iodineColor = Color(100, 100, 100, 255);
	end;
	
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos+ang:Up()*3.35, ang, 0.06)
			draw.SimpleText("Жидкий", "methFont", 0, -14, iodineColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText("йод", "methFont", 0, 10, iodineColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText(""..self:GetNWInt("amount").."л", "methFont", 0, 34, iodineColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		cam.End3D2D();

	ang:RotateAroundAxis(ang:Up(), 0);
	ang:RotateAroundAxis(ang:Forward(), -90);
	ang:RotateAroundAxis(ang:Right(), 90);		
		cam.Start3D2D(pos+ang:Up()*3.35, ang, 0.1)
			surface.SetDrawColor(0, 0, 0, 200);
			surface.DrawRect(-40, -8, 64, 16);
			
			surface.SetDrawColor(EML_Iodine_Color);
			surface.DrawRect(-38, -6, math.Round((self:GetNWInt("amount")*60)/self:GetNWInt("maxAmount")), 12);				
		cam.End3D2D();
	end;
end;

-- maxAmount = 60
-- amount = x

