hook.Add( "Botched.Hooks.FirstSpawn", "Botched.Botched.Hooks.FirstSpawn.Rewards", function()
    timer.Simple( 1, function()
        local receivedReferrals = BOTCHED.LOCALPLYMETA.ReceivedReferrals or {}

        local dontOpenMenu = table.Count( receivedReferrals ) <= 0
        for k, v in pairs( receivedReferrals ) do
            if( dontOpenMenu ) then break end
            
            if( v[2] == true ) then 
                dontOpenMenu = true 
            end
        end

        if( not dontOpenMenu ) then
            BOTCHED.FUNC.OpenReceivedReferralsMenu()
        end

        if( BOTCHED.DEVCONFIG.DisableOpenLoginRewards ) then return end
        BOTCHED.FUNC.OpenLoginRewardsMenu()
    end )
end )

hook.Add( "OnPlayerChat", "Botched.OnPlayerChat.ReferralRewards", function( ply, text )
	if( string.lower( text ) == "/refer" ) then
		if( ply == LocalPlayer() ) then
            BOTCHED.FUNC.OpenReceivedReferralsMenu()
        end

		return true
	end
end )

function BOTCHED.FUNC.OpenReceivedReferralsMenu()
    if( IsValid( BOTCHED.TEMP.ReceivedReferralsMenu ) ) then return end
    BOTCHED.TEMP.ReceivedReferralsMenu = vgui.Create( "botched_popup_receivedreferrals" )
end

function BOTCHED.FUNC.OpenLoginRewardsMenu()
    if( IsValid( BOTCHED.TEMP.LoginRewardsMenu ) ) then return end
    BOTCHED.TEMP.LoginRewardsMenu = vgui.Create( "botched_popup_loginrewards" )
end

function BOTCHED.FUNC.OpenTimeRewardsMenu()
    if( IsValid( BOTCHED.TEMP.TimeRewardsMenu ) ) then return end
    BOTCHED.TEMP.TimeRewardsMenu = vgui.Create( "botched_popup_timerewards" )
end

function BOTCHED.FUNC.OpenReferralRewardsMenu()
    if( IsValid( BOTCHED.TEMP.ReferralRewardsMenu ) ) then return end
    BOTCHED.TEMP.ReferralRewardsMenu = vgui.Create( "botched_popup_referralrewards" )
end