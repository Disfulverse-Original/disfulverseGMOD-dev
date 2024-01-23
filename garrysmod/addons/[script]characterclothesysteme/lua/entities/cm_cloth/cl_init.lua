include("shared.lua")

local nsize
local ysize

function ENT:Draw()

    self:DrawModel()
	
	local dist = LocalPlayer():GetPos():DistToSqr(self:GetPos())
	
	if dist > 250000 then return end
	
	local ang = self:GetAngles()
			
	local position = self:GetPos() + ang:Right() * -3.7
	local name = self:GetCName() or ""
	local nameP = "No owner"
	local owner = self:GetPlayerOwner() or NULL

	if IsValid(owner) then
		nameP = owner:Name()
	end

	if ( not nsize or not ysize ) and name ~= "" and nameP ~= "" then

		surface.SetFont( "Bariol25" )
		nsize, ysize = surface.GetTextSize( name )

		-- if the size of the name of the player is higher than the cloth name, resize the box
		if surface.GetTextSize( nameP ) > nsize then
			
			nsize = surface.GetTextSize( nameP ) 

		end

		nsize = nsize + 20

	end

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(),180)
	ang:RotateAroundAxis(ang:Up(), 0)

	cam.Start3D2D(position, ang, 0.1)
		
		draw.RoundedBox( 0, -nsize/2, 50, nsize, 50*2, Color( 40, 40, 40, 200 ) )

		draw.SimpleTextOutlined( name, "Bariol25" ,0,50+ysize/2, Color(255,255,255,255), 1, 0, 1, Color(0,0,0))
		draw.SimpleTextOutlined( nameP, "Bariol25" ,0,50*2+ysize/2, Color(255,255,255,255), 1, 0, 1, Color(0,0,0))

	cam.End3D2D()

end
