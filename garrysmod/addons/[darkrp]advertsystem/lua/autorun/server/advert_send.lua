util.AddNetworkString( "DarkRP_Advert" )
timer.Simple( 5, function()
	hook.Add( "PlayerSay", "DarkRP_SendAdvert", function( ply, text, team )
		if ( string.sub( text, 1, 7 ) == "/advert" ) then
			local String = string.sub( text, 8 )
			if String != "" then
				net.Start( "DarkRP_Advert" )
					net.WriteString( String )
					net.WriteEntity( ply )
				net.Broadcast()
			end
			return ""
		end
	end )
end ) 
