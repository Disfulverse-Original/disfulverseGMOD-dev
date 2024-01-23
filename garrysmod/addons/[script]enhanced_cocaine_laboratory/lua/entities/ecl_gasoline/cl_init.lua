--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	surface.SetFont("HUDNumber5")
	local text = ECL.Language.Entities.Gasoline
	local text2 = ECL.Language.Entities.CookedDirtyDrug..": "..self:GetNWInt("cooked")
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(text2)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang
	local pAng = EyeAngles()

	local time;
	local color;

	if (self:GetNWInt('timer') < CurTime()) then
		time = 0
	else 
		time = (self:GetNWInt('timer')-CurTime())
	end

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		local y = ScrH()/2
		local x = ScrW()/2
		local vec = Pos + Ang:Right()*-8 
		local screen = vec:ToScreen()
		local dis = math.Round(math.sqrt((x-screen.x)^2 + (y-screen.y)^2))
		local dis2 = math.Round(LocalPlayer():GetPos():Distance(Pos))
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

		if (self:GetNWInt("cooked") == 0) then
			color = Color(255,0,0,alpha-100)
		elseif (self:GetNWInt("cooked") == self:GetNWInt("max_amount")) then
			color = Color(0,255,0,alpha-100)
		else 
			color = Color(255,165,0,alpha-100)
		end

		cam.Start3D2D(Pos+Ang:Right()*-25, Angle(Ang.p, pAng.y-90, Ang.r), 0.1)
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-21.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.07)
			draw.RoundedBox( 0, -TextWidth2*0.5, -3, TextWidth2+20, 40, Color(0,0,0,alpha-200) )
			draw.RoundedBox( 0, -TextWidth2*0.5, 35, TextWidth2+20, 2, color )
			draw.SimpleTextOutlined( text2, "HUDNumber5", -TextWidth2*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
		cam.End3D2D()

		if self:GetNWInt("max_amount") == self:GetNWInt("cooked") then
			local clr = Color(255, 0, 0, alpha)
			if self:GetNWInt("timer") < CurTime() then
				text4 = ECL.Language.Entities.ReadyToUse
				TextWidth4 = surface.GetTextSize(text4)
				clr = Color(0,255,0,alpha)
			else
				local time = math.Round(self:GetNWInt("timer")-CurTime())
				text4 = ECL.Language.Entities.WaitAbout.." "..time..""..ECL.Language.Entities.Sec
				TextWidth4 = surface.GetTextSize(text4)
				clr = Color(255,165,0,alpha)
			end
			cam.Start3D2D(Pos+Ang:Right()*-18.5, Angle(Ang.p, pAng.y-90, Ang.r), 0.085)
				draw.RoundedBox( 0, -TextWidth4*0.5, -3, TextWidth4+20, 40, Color(0,0,0,alpha-200) )
				draw.RoundedBox( 0, -TextWidth4*0.5, 35, TextWidth4+20, 2, clr )
				draw.SimpleTextOutlined( text4, "HUDNumber5", -TextWidth4*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
			cam.End3D2D()

			if self:GetNWInt("timer") > CurTime() then
				self:DrawParticles(10);
			end
		end
	end
end

function ENT:DrawParticles(alpha)
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local Pos = self:GetPos()+Ang:Right()*-8+Ang:Up()*6.75+Ang:Forward()*math.random(-0.75, 0.75)+Ang:Up()*math.random(-0.75, 0.75)
	local emitter = ParticleEmitter( Pos, false )
	local particle = emitter:Add( "particle/smokesprites_0016", Pos )
		if particle then
			particle:SetAngles( Ang )
			particle:SetVelocity( Vector( math.random(-3,3), math.random(-3,3), 10) )
			particle:SetColor( 255, 255, 255, alpha)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.5 )
			particle:SetStartAlpha( alpha )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 2 )
			particle:SetStartLength( 5 )
			particle:SetEndSize( 3.6 )
			particle:SetEndLength( 5 )
		end
	emitter:Finish()
end;