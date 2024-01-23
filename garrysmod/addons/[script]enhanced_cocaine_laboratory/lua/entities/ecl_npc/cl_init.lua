--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

include("shared.lua")

if CLIENT then
	hook.Add("PostDrawOpaqueRenderables", "ECL_DrawNPC", function()
		for k,v in pairs (ents.FindByClass("ecl_npc")) do
			local Pos = v:GetPos()
			local Ang = v:GetAngles()
			local pAng = EyeAngles()

			Ang:RotateAroundAxis(Ang:Forward(), 90)
			Ang:RotateAroundAxis(Ang:Right(), -90)

			surface.SetFont("HUDNumber5")
			local text = ECL.Language.Entities.CocaineDealer
			local TextWidth = surface.GetTextSize(text)

			if LocalPlayer():GetPos():Distance(v:GetPos()) < v:GetNWInt("distance") then
				local fadein = v:GetNWBool("fadein");
				local distance = v:GetNWInt("distance");
				local alpha = 0;
				if fadein then 
					distance = math.Round(LocalPlayer():GetPos():Distance(Pos)) 
					alpha = math.Round((100-distance)*3.55)
				else
					alpha = 255
				end
				if alpha < 20 then
					alpha = alpha - 20
				end

				cam.Start3D2D(Pos+Ang:Right()*-78, Ang, 0.09)
					draw.RoundedBox( 0, -TextWidth*0.5, -3, TextWidth+20, 40, Color(0,0,0,alpha-200) )
					draw.RoundedBox( 0, -TextWidth*0.5, 35, TextWidth+20, 2, Color(255,165,0,alpha-100) )
					draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 10, 0, Color(255,255,255,alpha), 0, 0, 1, Color(0,0,0, alpha) )
				cam.End3D2D()
			end
		end
	end)
end