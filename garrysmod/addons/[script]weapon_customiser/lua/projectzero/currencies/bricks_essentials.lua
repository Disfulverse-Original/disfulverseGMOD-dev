--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local function loadCurrencies()
    if( not BRICKS_SERVER ) then return end

	for k, v in pairs( BRICKS_SERVER.CONFIG.CURRENCIES or {} ) do
        local CURRENCY = PROJECT0.FUNC.CreateCurrency( "bricks_essentials_" .. k )
        CURRENCY:SetTitle( v.Name )

        CURRENCY:SetInstalledFunction( function()
            return true
        end )

        CURRENCY:SetAddCurrency( function( ply, amount )
            ply:AddCurrency( k, amount )
        end )

        CURRENCY:SetTakeCurrency( function( ply, amount )
            ply:AddCurrency( k, -amount )
        end )

        CURRENCY:SetGetCurrency( function( ply )
            return ply:GetCurrency( k )
        end )

        CURRENCY:SetFormatCurrency( function( amount )
            if( v.Prefix ) then
                return v.Prefix .. string.Comma( amount or 0 )
            elseif( v.Suffix ) then
                return string.Comma( amount or 0 ) .. " " .. v.Suffix
            else
                return string.Comma( amount or 0 )
            end
        end )

        CURRENCY:Register()
	end
end
loadCurrencies()

hook.Add( "BRS.Hooks.ConfigUpdated", "Project0.BRS.Hooks.ConfigUpdated.Currencies", function( keysChanged )	
	if( not table.HasValue( (keysChanged or {}), "CURRENCIES" ) ) then return end
	loadCurrencies()
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
