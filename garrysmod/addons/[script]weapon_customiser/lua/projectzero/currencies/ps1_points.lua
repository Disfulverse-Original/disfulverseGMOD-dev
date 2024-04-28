--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local CURRENCY = PROJECT0.FUNC.CreateCurrency( "ps1_points" )
CURRENCY:SetTitle( "PS1 Points" )

CURRENCY:SetInstalledFunction( function()
    return tobool( Pointshop2 )
end )

CURRENCY:SetAddCurrency( function( ply, amount )
    ply:PS_GivePoints( amount )
end )

CURRENCY:SetTakeCurrency( function( ply, amount )
    ply:PS_GivePoints( -amount )
end )

CURRENCY:SetGetCurrency( function( ply )
    return ply:PS_GetPoints() or 0
end )

CURRENCY:SetFormatCurrency( function( amount )
    return string.Comma( amount ) .. " Points"
end )

CURRENCY:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
