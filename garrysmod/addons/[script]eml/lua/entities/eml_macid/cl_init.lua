include("shared.lua");

function ENT:Initialize()	

end;

surface.CreateFont("methFont", {
	font = "Roboto",
	size = 75,
	weight = 600,
	extended = true,
	antialias = true,
});

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()

	local macidColor = EML_MuriaticAcid_Color;
	
	if (self:GetNWInt("amount")>0) then
		macidColor = Color(255, 255, 255, 255);
	else
		macidColor = Color(100, 100, 100, 255);
	end;

    local pos = self:GetPos()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 0)
    ang:RotateAroundAxis(ang:Forward(), 85)
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) < 50000 then
        cam.Start3D2D(pos + ang:Up() * 0, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.025)
        draw.RoundedBoxEx(16, -500, -620, 1000, 170, Color(21, 41, 56, 255), true, true, false, false)
        draw.RoundedBox(0, -500, -460, 1000, 20, Color(127, 255, 0, 255))
        draw.DrawText("Соляная кислота ("..self:GetNWInt("amount").." л)", "methFont", 0, -575, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        cam.End3D2D()
    end;
end;