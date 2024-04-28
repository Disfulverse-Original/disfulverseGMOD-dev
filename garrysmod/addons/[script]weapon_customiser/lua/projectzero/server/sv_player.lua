--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- DATA FUNCTIONS --
util.AddNetworkString( "Project0.SendFirstSpawn" )
hook.Add( "PlayerInitialSpawn", "Project0.PlayerInitialSpawn.LoadData", function( ply )
	PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_players WHERE steamID64 = '" .. ply:SteamID64() .. "';", function( data )
        if( data ) then
            local userID = tonumber( data.userID or "" ) or 1 
            ply:Project0():SetUserID( userID )

			hook.Run( "Project0.Hooks.PlayerLoadData", ply, userID )
        else
            PROJECT0.FUNC.SQLQuery( "INSERT INTO projectzero_players( steamID64 ) VALUES(" .. ply:SteamID64() .. ");", function()
                PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_players WHERE steamID64 = '" .. ply:SteamID64() .. "';", function( data )
                    if( data ) then
                        local userID = tonumber( data.userID or "" ) or 1 
                        ply:Project0():SetUserID( userID )
                    else
                        ply:Kick( "ERROR: Could not create unique UserID, try rejoining!\n\nPlease contact support for Project0 on gmodstore." )
                    end
                end, true )
            end )
        end
    end, true )

    PROJECT0.FUNC.SendConfig( ply )

    net.Start( "Project0.SendFirstSpawn" )
    net.Send( ply )
end )

-- GENERAL FUNCTIONS --
util.AddNetworkString( "Project0.SendUserID" )
function PROJECT0.PLAYERMETA:SetUserID( userID )
    self.UserID = userID

    net.Start( "Project0.SendUserID" )
        net.WriteUInt( userID, 16 )
    net.Send( self.Player )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
