-- TIME PLAYED FUNCTIONS --
net.Receive( "Botched.SendPreviousTimePlayed", function()
    BOTCHED.LOCALPLYMETA.PreviousTime = net.ReadUInt( 32 ) or 0
end )

net.Receive( "Botched.SendJoinTime", function()
    BOTCHED.LOCALPLYMETA.JoinTime = net.ReadUInt( 22 ) or 0
end )

net.Receive( "Botched.SendClaimedTimeRewards", function()
    local claimedRewards = BOTCHED.LOCALPLYMETA.ClaimedTimeRewards or {}
    for i = 1, net.ReadUInt( 6 ) do
        claimedRewards[net.ReadString()] = net.ReadUInt( 32 )
    end

    BOTCHED.LOCALPLYMETA.ClaimedTimeRewards = claimedRewards

    hook.Run( "Botched.Hooks.ClaimedTimeRewardsUpdated" )
end )

-- LOGIN REWARD FUNCTIONS --
net.Receive( "Botched.SendLoginRewardInfo", function()
    BOTCHED.LOCALPLYMETA.LoginDaysClaimed = net.ReadUInt( 5 ) or 0
    BOTCHED.LOCALPLYMETA.LoginClaimTime = net.ReadUInt( 32 ) or 0

    hook.Run( "Botched.Hooks.LoginRewardsUpdated" )
end )

-- REFERRAL FUNCTIONS --
net.Receive( "Botched.SendReferredPlayers", function()
    local referredPlayers = BOTCHED.LOCALPLYMETA.ReferredPlayers or {}
    for i = 1, net.ReadUInt( 6 ) do
        local steamID64 = net.ReadString()
        if( not net.ReadBool() ) then
            referredPlayers[steamID64] = nil
            continue
        end

        referredPlayers[steamID64] = { net.ReadBool(), net.ReadUInt( 32 ) }
    end

    BOTCHED.LOCALPLYMETA.ReferredPlayers = referredPlayers

    hook.Run( "Botched.Hooks.ReferredPlayersUpdated" )
end )

net.Receive( "Botched.SendReceivedReferrals", function()
    local receivedReferrals = BOTCHED.LOCALPLYMETA.ReceivedReferrals or {}
    for i = 1, net.ReadUInt( 6 ) do
        local userID = net.ReadUInt( 16 )
        if( not net.ReadBool() ) then
            receivedReferrals[userID] = nil
            continue
        end

        receivedReferrals[userID] = { net.ReadString(), net.ReadBool(), net.ReadUInt( 32 ) }
    end

    BOTCHED.LOCALPLYMETA.ReceivedReferrals = receivedReferrals

    hook.Run( "Botched.Hooks.ReceivedReferralsUpdated" )
end )

net.Receive( "Botched.SendClaimedReferralRewards", function()
    local claimedRewards = BOTCHED.LOCALPLYMETA.ClaimedReferralRewards or {}
    for i = 1, net.ReadUInt( 6 ) do
        claimedRewards[net.ReadUInt( 6 )] = net.ReadUInt( 32 )
    end

    BOTCHED.LOCALPLYMETA.ClaimedReferralRewards = claimedRewards

    hook.Run( "Botched.Hooks.ClaimedReferralRewardsUpdated" )
end )