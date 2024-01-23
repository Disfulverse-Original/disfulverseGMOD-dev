local meta = FindMetaTable( "Player" )

util.AddNetworkString("ClothesMod:NotifyPlayer")

function meta:CM_Notif( msg, time )
	
	local ply = self
	
	if not IsValid( ply ) or not ply:IsPlayer() then return end
	
	msg = msg or ""
	time = time or 5
	
	net.Start("ClothesMod:NotifyPlayer")
		net.WriteString( msg )
		net.WriteInt( time, 32 )
	net.Send( ply )
end