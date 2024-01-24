include('shared.lua')

surface.CreateFont( "coolfont", {
 font = "TargetID",
 size = 22,
 weight = 575,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

function DrawText()
	for k, ent in pairs (ents.FindByClass("namechange")) do
		local Ang = ent:GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), -90)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*85, Ang, 0.35)
			draw.SimpleTextOutlined( 'Name Changer', "coolfont", 0, 0, NC.Color.NPCName, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, .5, Color(0, 0, 0, 255))
		cam.End3D2D()
			
		Ang:RotateAroundAxis( Ang:Right(), -180)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*85, Ang, 0.35)
			draw.SimpleTextOutlined( 'Name Changer', "coolfont", 0, 0, NC.Color.NPCName, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, .5, Color(0, 0, 0, 255))
		cam.End3D2D()
	end
end
hook.Add("PostDrawOpaqueRenderables", "TextAboveNameChanger", DrawText)
 