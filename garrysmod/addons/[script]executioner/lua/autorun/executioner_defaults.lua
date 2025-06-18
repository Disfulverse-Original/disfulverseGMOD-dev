    --[[
        Disables the Default DarkRP Hit system.
        Do not touch this file unless you know what you're doing.
        For support, please check the addon documentation or contact the developer.
    --]]

    if CLIENT then
        local hooksToRemove = {
            { hook = 'HUDPaint', string = 'DrawHitOption' },
            { hook = 'KeyPress', string = 'openHitMenu' },
            { hook = 'PostPlayerDraw', string = 'drawHitInfo' },
            { hook = 'InitPostEntity', string = 'HitmanMenu' }
        }

        hook.Add( 'Initialize', 'rHit.Disable.Default', function()
            for k, v in pairs( hooksToRemove ) do 
                hook.Remove( v.hook, v.string ) 
            end
        end )
    else
        local commandsToRemove = { 'requesthit', 'hitprice' }
        hook.Add( 'Initialize', 'rHit.Disable.Commands', function()
            for k, v in pairs( commandsToRemove ) do 
                if DarkRP and DarkRP.removeChatCommand then
                    DarkRP.removeChatCommand( v )
                else
                    print("[EXECUTIONER] ERROR: DarkRP not found or removeChatCommand not available")
                end
            end
        end )
    end
