
if SERVER then

resource.AddFile( "sound/dead/death1.wav" )
resource.AddFile( "sound/dead/death2.wav" )
resource.AddFile( "sound/dead/death3.wav" )
resource.AddFile( "sound/dead/death4.wav" )
resource.AddFile( "sound/dead/death5.wav" )
resource.AddFile( "sound/dead/death6.wav" )
resource.AddFile( "sound/dead/death7.wav" )
resource.AddFile( "sound/dead/death8.wav" )
resource.AddFile( "sound/dead/death9.wav" )
resource.AddFile( "sound/dead/death10.wav" )
resource.AddFile( "sound/dead/death11.wav" )
resource.AddFile( "sound/dead/death12.wav" )
resource.AddFile( "sound/dead/death13.wav" )


end

local function playerDies(ply)
	local pitch = 100 * GetConVarNumber("host_timescale")
	ply:EmitSound(Sound("dead/death"..math.random(1,13)..".wav"),500,pitch)
end

hook.Add( "PlayerDeath", "playerDeathTest", playerDies )
hook.Add("PlayerDeathSound", "DeFlatline", function() return true end)
hook.Add("PlayerDeath", "NewSound", function(vic,unused1,unused2) end)
