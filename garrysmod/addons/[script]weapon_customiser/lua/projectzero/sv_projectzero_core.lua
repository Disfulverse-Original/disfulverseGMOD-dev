--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

resource.AddWorkshop( 3148691503 )
resource.AddFile( "resource/fonts/montserrat-bold.ttf" )
resource.AddFile( "resource/fonts/montserrat-medium.ttf" )

include( "projectzero/sv_database.lua" )

-- CLIENT LOAD --
for k, v in ipairs( file.Find( "projectzero/client/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/client/" .. v )
end

-- SERVER LOAD --
for k, v in ipairs( file.Find( "projectzero/server/*.lua", "LUA" ) ) do
	include( "projectzero/server/" .. v )
	print( "[PROJECT0] Server file loaded: " .. v )
end

-- VGUI LOAD --
for k, v in ipairs( file.Find( "projectzero/vgui/*.lua", "LUA" ) ) do
	AddCSLuaFile( "projectzero/vgui/" .. v )
end

-- CORE --
util.AddNetworkString( "Project0.SendNotification" )
function PROJECT0.FUNC.SendNotification( ply, title, message, icon )
	net.Start( "Project0.SendNotification" )
		net.WriteString( title )
		net.WriteString( message )
		net.WriteString( icon or "notification" )
	net.Send( ply )
end

util.AddNetworkString( "Project0.SendChatNotification" )
function PROJECT0.FUNC.SendChatNotification( ply, tag, text )
	net.Start( "Project0.SendChatNotification" )
		net.WriteString( tag )
		net.WriteString( text )
	net.Send( ply )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
