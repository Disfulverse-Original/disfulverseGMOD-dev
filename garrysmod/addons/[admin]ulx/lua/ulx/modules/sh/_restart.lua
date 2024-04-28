function ulx.restart()
    game.ConsoleCommand("_restart\n")
end
local restart = ulx.command("Rcon", "ulx restart", ulx.restart,"!restart")
restart:defaultAccess( ULib.ACCESS_ADMIN )
restart:help( "Restarts server" )