--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- DATA FUNCTIONS --
net.Receive( "Project0.SendFirstSpawn", function()
    hook.Run( "Project0.Hooks.FirstSpawn" )
end )

-- GENERAL FUNCTIONS --
net.Receive( "Project0.SendUserID", function()
    PROJECT0.LOCALPLYMETA.UserID = net.ReadUInt( 16 )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
