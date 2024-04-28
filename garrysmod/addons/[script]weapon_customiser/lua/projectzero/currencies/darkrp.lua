--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local CURRENCY = PROJECT0.FUNC.CreateCurrency( "darkrp" )
CURRENCY:SetTitle( "DarkRP" )

CURRENCY:SetInstalledFunction( function()
    return tobool( DarkRP )
end )

CURRENCY:SetAddCurrency( function( ply, amount )
    ply:addMoney( amount )
end )

CURRENCY:SetTakeCurrency( function( ply, amount )
    ply:addMoney( -amount )
end )

CURRENCY:SetGetCurrency( function( ply )
    return ply:getDarkRPVar( "money" )
end )

CURRENCY:SetFormatCurrency( function( amount )
    return DarkRP.formatMoney( amount )
end )

CURRENCY:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
