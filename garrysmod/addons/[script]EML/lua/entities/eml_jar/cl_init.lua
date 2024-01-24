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
	local macidColor = Color(160, 221, 99, 255);
	local iodineColor = Color(137, 69, 54, 255);
	local waterColor = Color(133, 202, 219, 255);
	
	local potTime = "Прогресс: "..self:GetNWInt("progress").."% (Тряси!)";
	
	if (self:GetNWInt("status") == "inprogress") then
		potTime = "Прогресс: "..self:GetNWInt("progress").."% (Тряси!)";
	elseif (self:GetNWInt("status") == "ready") then	
		potTime = "Готово! Е, чтобы вытащить!";
	end;
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up()*5, ang, 0.05	)
			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-64, -38, 128, 96);		
		cam.End3D2D();
		cam.Start3D2D(pos + ang:Up()*5, ang, 0.055)
			draw.SimpleText("Йод кристаллический", "methFont", 0, -56, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText("______________", "methFont", 0, -54, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-104, -32, 204, 24);			
			surface.SetDrawColor(Color(255, 255, 255, 255));
			surface.DrawRect(-101.5, -30, math.Round((self:GetNWInt("progress")*198)/100), 20);		
			
			draw.SimpleText("Ингредиенты", "methFont", -101, 8, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("______________", "methFont", 0, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			if (self:GetNWInt("macid")==0) then
				macidColor = Color(100, 100, 100, 255);
			else
				macidColor = Color(255, 255, 255, 255);
			end;
			
			if (self:GetNWInt("iodine")==0) then
				iodineColor = Color(100, 100, 100, 255);
			else
				iodineColor = Color(255, 255, 255, 255);
			end;

			if (self:GetNWInt("water")==0) then
				waterColor = Color(100, 100, 100, 255);
			else
				waterColor = Color(255, 255, 255, 255);
			end;											
		cam.End3D2D();	
		
		cam.Start3D2D(pos + ang:Up()*5, ang, 0.045)		
			draw.SimpleText("Соляная кислота ("..self:GetNWInt("macid")..")", "methFont", -121, 44, macidColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("Жидкий йод ("..self:GetNWInt("iodine")..")", "methFont", -121, 74, iodineColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);	
			draw.SimpleText("Вода ("..self:GetNWInt("water")..")", "methFont", -121, 104, waterColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);			
		cam.End3D2D();			
		cam.Start3D2D(pos + ang:Up()*5, ang, 0.035)		
			draw.SimpleTextOutlined(potTime, "methFont", -152, -32, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));		
		cam.End3D2D();		
		
	end;
end;

