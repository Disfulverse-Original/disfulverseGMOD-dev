net.Receive( "DarkRP_Advert", function( len, pl )
	local text = net.ReadString()
	local ply = net.ReadEntity()
	if ( IsValid( ply ) and ply:IsPlayer() ) then
		surface.PlaySound( "buttons/lightswitch2.wav" )
		chat.AddText( team.GetColor( ply:Team() ), "[Реклама] ", team.GetColor( ply:Team() ), ply:Nick(), Color( 255, 255, 255 ), ":", Color( 255,255,0 ), text )
	end
end )