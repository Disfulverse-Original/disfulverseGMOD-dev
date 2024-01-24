include("shared.lua");

surface.CreateFont("methFont", {
	font = "Roboto",
	size = 30,
	weight = 600,
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
	local sulfurColor = Color(243, 213, 19, 255);
	
	local potTime = "Варка: "..self:GetNWInt("time").."сек.";
	
	if (self:GetNWInt("status") == "inprogress") then
		potTime = "Варка: "..self:GetNWInt("time").."сек.";
	elseif (self:GetNWInt("status") == "ready") then	
		potTime = "Готово! Е, чтобы вытащить!";
	end;
	ang:RotateAroundAxis(ang:Up(), 90);
	ang:RotateAroundAxis(ang:Forward(), 90);	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.10)
			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-64, -38, 128, 96);		
		cam.End3D2D();
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.055)
			draw.SimpleText("Красный фосфор", "methFont", 0, -56, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			draw.SimpleText("______________", "methFont", 0, -54, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-104, -32, 204, 24);			
			surface.SetDrawColor(Color(255, 255, 255, 100));
			surface.DrawRect(-101.5, -30, math.Round((self:GetNWInt("time")*198)/self:GetNWInt("maxTime")), 20);		
			
			draw.SimpleText("Ингредиенты", "methFont", -101, 8, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("______________", "methFont", 0, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			if (self:GetNWInt("macid")==0) then
				macidColor = Color(255, 255, 255, 255);
			else
				macidColor = Color(160, 221, 99, 255);
			end;
			
			if (self:GetNWInt("sulfur")==0) then
				sulfurColor = Color(255, 255, 255, 255);
			else
				sulfurColor = Color(243, 213, 19, 255);
			end;			
			draw.SimpleText("Соляная кислота ("..self:GetNWInt("macid")..")", "methFont", -101, 38, macidColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("Жидкая сера ("..self:GetNWInt("sulfur")..")", "methFont", -101, 68, sulfurColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);				
		cam.End3D2D();	
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.035)		
			draw.SimpleText(potTime, "methFont", -152, -32, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);		
		cam.End3D2D();					
	end;
end;

