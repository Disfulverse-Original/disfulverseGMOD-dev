include("shared.lua");

surface.CreateFont("methFont35", {
	font = "Roboto",
	size = 26,
	weight = 550,
	extended = false,
	antialias = true,
});


function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local redpColor = Color(175, 0, 0, 255);
	local ciodineColor = Color(220, 134, 159, 255);
	
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
			draw.SimpleText("Голубое небо", "methFont35", 0, -56, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

			surface.SetDrawColor(Color(0, 0, 0, 200));
			surface.DrawRect(-104, -32, 204, 24);			
			surface.SetDrawColor(Color(255, 255, 255, 75));
			surface.DrawRect(-101.5, -30, math.Round((self:GetNWInt("time")*198)/self:GetNWInt("maxTime")), 20);		
			
			draw.SimpleText("Ингредиенты", "methFont35", -101, 8, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

			if (self:GetNWInt("redp")==0) then
				redpColor = Color(255, 255, 255, 255);
			else
				redpColor = Color(175, 0, 0, 255);
			end;
			
			if (self:GetNWInt("ciodine")==0) then
				ciodineColor = Color(255, 255, 255, 255);
			else
				ciodineColor = Color(220, 134, 159, 255);
			end;							
		cam.End3D2D();	
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.040)		
			draw.SimpleText("Красный фосфор ("..self:GetNWInt("redp")..")", "methFont35", -138, 50, redpColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
			draw.SimpleText("Кристаллический йод ("..self:GetNWInt("ciodine")..")", "methFont35", -138, 80, ciodineColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);		
		cam.End3D2D();			
		cam.Start3D2D(pos + ang:Up()*8, ang, 0.035)		
			draw.SimpleText(potTime, "methFont35", -152, -32, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);		
		cam.End3D2D();		
		
	end;
end;

