--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

PROJECT0.LOCALPLYMETA = {
    Player = self
}

setmetatable( PROJECT0.LOCALPLYMETA, PROJECT0.PLAYERMETA )

-- CLIENT LOAD --
for k, v in ipairs( file.Find( "projectzero/client/*.lua", "LUA" ) ) do
	include( "projectzero/client/" .. v )
    print( "[PROJECT0] Client file loaded: " .. v )
end

-- VGUI LOAD --
for k, v in ipairs( file.Find( "projectzero/vgui/*.lua", "LUA" ) ) do
	include( "projectzero/vgui/" .. v )
    print( "[PROJECT0] VGUI file loaded: " .. v )
end

concommand.Add( "pz_removeonclose", function()
    PROJECT0.TEMP.RemoveOnClose = not PROJECT0.TEMP.RemoveOnClose
end )

net.Receive( "Project0.SendNotification", function()
	PROJECT0.FUNC.CreateNotification( net.ReadString(), net.ReadString(), net.ReadString() )
end )

net.Receive( "Project0.SendChatNotification", function()
	chat.AddText( PROJECT0.FUNC.GetTheme( 3 ), net.ReadString() .. " ", PROJECT0.FUNC.GetTheme( 4 ), net.ReadString() )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
