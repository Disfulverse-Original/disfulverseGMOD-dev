--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

PROJECT0.TEMP.CosmeticPurchases = PROJECT0.TEMP.CosmeticPurchases or {}
function PROJECT0.FUNC.FetchCosmeticsPurchased()
    PROJECT0.TEMP.CosmeticPurchases = {}
	PROJECT0.FUNC.SQLQuery( "SELECT * FROM projectzero_purchases;", function( data )
        for k, v in ipairs( data or {} ) do
            table.insert( PROJECT0.TEMP.CosmeticPurchases, { tonumber( v.time ), v.steamID64, tonumber( v.storeKey ) } )
        end
    end )
end
PROJECT0.FUNC.FetchCosmeticsPurchased()

function PROJECT0.FUNC.AddCosmeticPurchase( steamID64, time, storeKey )
    table.insert( PROJECT0.TEMP.CosmeticPurchases, { time, steamID64, storeKey } )

    PROJECT0.FUNC.SQLQuery( "INSERT INTO projectzero_purchases( steamID64, time, storeKey ) VALUES(" .. steamID64 .. ", " .. time .. ", " .. storeKey .. ");" )
end

util.AddNetworkString( "Project0.RequestCosmeticsPurchased" )
util.AddNetworkString( "Project0.SendCosmeticsPurchased" )
net.Receive( "Project0.RequestCosmeticsPurchased", function( len, ply )
    if( CurTime() < (ply:Project0().LastCosmeticsPurchasedRequest or 0)+PROJECT0.CONFIG.CUSTOMISER.StatisticsNetworkDelay-1 ) then return end
    ply:Project0().LastCosmeticsPurchasedRequest = CurTime()

    local currentTime = PROJECT0.FUNC.UTCTime()

    local data = {}
    for k, v in ipairs( PROJECT0.TEMP.CosmeticPurchases ) do
        local day = 7-math.floor( (currentTime-v[1])/86400 )
        if( day > 7 or day < 1 ) then continue end

        data[day] = (data[day] or 0)+1
    end

    net.Start( "Project0.SendCosmeticsPurchased" )
        for i = 1, 7 do
            net.WriteUInt( data[i] or 0, 10 )
        end
    net.Send( ply )
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
