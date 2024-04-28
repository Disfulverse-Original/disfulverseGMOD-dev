-- Client side codes
if CLIENT then

    -- client settings
    local cl_acdr_dly = 300
    local cl_acdr_txt = "Автоматически удалены все декали на сервере"

    -- client auto clear decals function
    local function cl_acdr_func()

	    RunConsoleCommand( "r_cleardecals" ) -- remove decals
	    game.RemoveRagdolls() -- remove ragdolls

	    notification.AddLegacy( cl_acdr_txt, NOTIFY_GENERIC, 5 ) -- notify auto clear decals
	    surface.PlaySound( "buttons/button14.wav" ) -- play sounds

	end
	timer.Create( "cl_acdr", cl_acdr_dly, 0, cl_acdr_func )

end

-- Server side codes
if SERVER then

    -- server settings
    local sv_acdr_dly = 300
    local sv_acdr_txt = "auto clear decals operated\n"

    -- server auto clear decals function
    local function sv_acdr_func()

        game.RemoveRagdolls() -- remove ragdolls
        --MsgC( Color(255,255,255), sv_acdr_txt ) -- notify auto clear decals

    end
    timer.Create( "sv_acdr", sv_acdr_dly, 0, sv_acdr_func )

end

