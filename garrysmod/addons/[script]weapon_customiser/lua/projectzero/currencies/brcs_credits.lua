--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local CURRENCY = PROJECT0.FUNC.CreateCurrency( "brcs_credits" )
CURRENCY:SetTitle( "Brick's Credits" )

CURRENCY:SetInstalledFunction( function()
    return tobool( BRICKSCREDITSTORE )
end )

CURRENCY:SetAddCurrency( function( ply, amount )
    ply:AddBRCS_Credits( amount )
end )

CURRENCY:SetTakeCurrency( function( ply, amount )
    ply:AddBRCS_Credits( -amount )
end )

CURRENCY:SetGetCurrency( function( ply )
    return ply:GetBRCS_Credits()
end )

CURRENCY:SetFormatCurrency( function( amount )
    return BRICKSCREDITSTORE.FormatCredits( amount )
end )

CURRENCY:Register()

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
