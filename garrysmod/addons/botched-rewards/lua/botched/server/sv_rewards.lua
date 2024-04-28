resource.AddWorkshop( "2574164338" )

-- TIME REWARDS --
local function SingleRewardToTable( rewardCfg )
    local rewardTable = {}
    if( rewardCfg.RewardType == "Items" ) then
        rewardTable["Items"] = {
            [rewardCfg.RewardValue[1]] = rewardCfg.RewardValue[2]
        }
    else
        rewardTable[rewardCfg.RewardType] = rewardCfg.RewardValue
    end

    return rewardTable
end

util.AddNetworkString( "Botched.RequestClaimTimeReward" )
net.Receive( "Botched.RequestClaimTimeReward", function( len, ply )
    if( not ply:Botched():CheckNetworkDelay( 0.5, "ClaimTimeReward" ) ) then return end

    local rewardKey = net.ReadString()
    local rewardConfig = BOTCHED.CONFIG.REWARDS.TimeRewards[rewardKey or 0]

    if( not rewardConfig or ply:Botched():GetTimePlayed() < rewardConfig.Time ) then return end

    local claimedRewards = ply:Botched():GetClaimedTimeRewards()
    if( claimedRewards[rewardKey] ) then return end

    ply:Botched():GiveReward( SingleRewardToTable( rewardConfig ) )
    BOTCHED.FUNC.SendNotification( ply, "TIME REWARDS", "Time reward successfully claimed!", "reward" )

    claimedRewards[rewardKey] = BOTCHED.FUNC.UTCTime()
    ply:Botched():SetClaimedTimeRewards( claimedRewards )
    ply:Botched():SendClaimedTimeRewards( rewardKey )

    BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_claimed_timerewards( userID, rewardKey, claimTime ) VALUES(" .. ply:Botched():GetUserID() .. ", '" .. rewardKey .. "', " .. claimedRewards[rewardKey] .. ");" )

    ply:Botched():SendClaimedTimeRewards( rewardKey )
end )

util.AddNetworkString( "Botched.RequestClaimTimeRewards" )
net.Receive( "Botched.RequestClaimTimeRewards", function( len, ply )
    if( not ply:Botched():CheckNetworkDelay( 0.5, "ClaimTimeReward" ) ) then return end

    local claimedRewards = ply:Botched():GetClaimedTimeRewards()

    local rewardKeys = {}
    for k, v in pairs( BOTCHED.CONFIG.REWARDS.TimeRewards ) do
        if( claimedRewards[k] or ply:Botched():GetTimePlayed() < v.Time ) then continue end
        table.insert( rewardKeys, k )
    end

    if( #rewardKeys < 1 ) then return end

    local rewardTables = {}
    for k, v in ipairs( rewardKeys ) do
        claimedRewards[v] = BOTCHED.FUNC.UTCTime()
        BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_claimed_timerewards( userID, rewardKey, claimTime ) VALUES(" .. ply:Botched():GetUserID() .. ", '" .. v .. "', " .. claimedRewards[v] .. ");" )

        table.insert( rewardTables, SingleRewardToTable( BOTCHED.CONFIG.REWARDS.TimeRewards[v] ) )
    end

    ply:Botched():GiveReward( BOTCHED.FUNC.MergeRewardTables( unpack( rewardTables ) ) )
    BOTCHED.FUNC.SendNotification( ply, "TIME REWARDS", "Time rewards successfully claimed!", "reward" )

    ply:Botched().ClaimedTimeRewards = claimedRewards
    ply:Botched():SendClaimedTimeRewards( unpack( rewardKeys ) )
end )

-- LOGIN REWARDS --
util.AddNetworkString( "Botched.RequestClaimLoginReward" )
net.Receive( "Botched.RequestClaimLoginReward", function( len, ply )
    if( not ply:Botched():CheckNetworkDelay( 0.5, "ClaimLoginReward" ) or not ply:Botched():CanClaimLoginReward() ) then return end

    local loginStreak = ply:Botched():GetLoginRewardStreak()
    local daysClaimed, claimTime = loginStreak+1, BOTCHED.FUNC.UTCTime()

    ply:Botched():GiveReward( SingleRewardToTable( BOTCHED.CONFIG.REWARDS.LoginRewards[daysClaimed] ) )
    ply:Botched():SetLoginRewardInfo( daysClaimed, claimTime )

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_rewards WHERE userID = '" .. ply:Botched():GetUserID() .. "';", function( data )
        if( data ) then
            BOTCHED.FUNC.SQLQuery( "UPDATE botched_rewards SET daysClaimed = " .. daysClaimed .. ", claimTime = " .. claimTime .. " WHERE userID = '" .. ply:Botched():GetUserID() .. "';" )
        else
            BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_rewards( userID, daysClaimed, claimTime ) VALUES(" .. ply:Botched():GetUserID() .. ", " .. daysClaimed .. ", " .. claimTime .. ");" )
        end
    end, true )

    BOTCHED.FUNC.SendNotification( ply, "LOGIN REWARDS", "Login rewards successfully claimed!", "reward" )
end )

-- REFERRAL REWARDS --
util.AddNetworkString( "Botched.RequestSendReferral" )
net.Receive( "Botched.RequestSendReferral", function( len, ply )
    if( not ply:Botched():CheckNetworkDelay( 0.5, "ReferralSend" ) ) then return end
    
    local victim = net.ReadEntity()
    if( not IsValid( victim ) or victim == ply ) then return end

    local victimSteamID64 = victim:SteamID64()

    local referredPlayers = ply:Botched():GetReferredPlayers()
    if( referredPlayers[victimSteamID64] ) then return end

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_referrals WHERE referredSteamID64 = '" .. victimSteamID64 .. "' AND accepted = 1;", function( data )
        if( not IsValid( ply ) or not IsValid( victim ) ) then return end

        if( data ) then
            BOTCHED.FUNC.SendNotification( ply, "REFERRAL ERROR", "This player has already been referred!", "error" )
            return
        end

        local timeSent = BOTCHED.FUNC.UTCTime()
        referredPlayers[victimSteamID64] = { false, timeSent }
    
        ply:Botched():SetReferredPlayers( referredPlayers )
        ply:Botched():SendReferredPlayers( victimSteamID64 )
    
        BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_referrals( userID, referredSteamID64, accepted, timeSent ) VALUES(" .. ply:Botched():GetUserID() .. ", " .. victimSteamID64 .. ", false, " .. timeSent .. ");" )
    
        BOTCHED.FUNC.SendNotification( ply, "REFERRAL REWARDS", "Referral request sent.", "reward" )
    
        -- Sends receiver referral info
        local userID = ply:Botched():GetUserID()
        local receivedReferrals = victim:Botched():GetReceivedReferrals()
        receivedReferrals[userID] = { ply:SteamID64(), false, timeSent }
    
        victim:Botched():SetReceivedReferrals( receivedReferrals )
        victim:Botched():SendReceivedReferrals( userID )
    
        BOTCHED.FUNC.SendChatNotification( victim, "[REFERRAL REWARDS]", "You have received a referral request from " .. ply:Nick() .. ". Type /refer to view received referrals." )
    end, true )
end )

util.AddNetworkString( "Botched.RequestAcceptReferral" )
net.Receive( "Botched.RequestAcceptReferral", function( len, ply )
    if( not ply:Botched():CheckNetworkDelay( 0.5, "ReferralAccept" ) ) then return end

    local userID = net.ReadUInt( 16 )
    if( not userID ) then return end

    local receivedReferrals = ply:Botched():GetReceivedReferrals()
    if( not receivedReferrals[userID] or receivedReferrals[userID][2] == true ) then return end

    receivedReferrals[userID][2] = true

    local steamID64 = ply:SteamID64()
    for k, v in pairs( receivedReferrals ) do
        if( k == userID ) then continue end

        local sender = player.GetBySteamID64( v[1] )
        if( IsValid( sender ) ) then
            local referredPlayers = sender:Botched():GetReferredPlayers()
            referredPlayers[steamID64] = nil

            ply:Botched():SetReferredPlayers( referredPlayers )
            ply:Botched():SendReferredPlayers( steamID64 )
        end

        receivedReferrals[k] = nil
    end

    BOTCHED.FUNC.SQLQuery( "DELETE FROM botched_referrals WHERE userID <> " .. userID .. " AND referredSteamID64 = " .. steamID64 .. ";" )
    BOTCHED.FUNC.SQLQuery( "UPDATE botched_referrals SET accepted = 1 WHERE userID = '" .. userID .. "';" )

    ply:Botched():SetReceivedReferrals( receivedReferrals )
    ply:Botched():SendReceivedReferrals( userID )

    BOTCHED.FUNC.SendNotification( ply, "REFERRAL REWARDS", "Referral request accepted.", "reward" )

    local sender = player.GetBySteamID64( receivedReferrals[userID][1] )
    if( IsValid( sender ) ) then
        local referredPlayers = sender:Botched():GetReferredPlayers()
        referredPlayers[steamID64][1] = true

        sender:Botched():SetReferredPlayers( referredPlayers )
        sender:Botched():SendReferredPlayers( steamID64 )

        BOTCHED.FUNC.SendNotification( sender, "REFERRAL REWARDS", "One of your referrals was accepted.", "reward" )
    end
end )

util.AddNetworkString( "Botched.RequestClaimReferralRewards" )
net.Receive( "Botched.RequestClaimReferralRewards", function( len, ply )
    if( not ply:Botched():CheckNetworkDelay( 0.5, "ClaimReferralRewards" ) ) then return end

    local unClaimedRewards = ply:Botched():GetUnClaimedReferralRewards()
    if( #unClaimedRewards <= 0 ) then return end

    local claimTime = BOTCHED.FUNC.UTCTime()

    local claimedReferralRewards = ply:Botched():GetClaimedReferralRewards()
    local rewardTables = {}
    for k, v in pairs( unClaimedRewards ) do
        claimedReferralRewards[k] = claimTime
        BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_claimed_referralrewards( userID, rewardKey, claimTime ) VALUES(" .. ply:Botched():GetUserID() .. ", " .. k .. ", " .. claimTime .. ");" )
        table.insert( rewardTables, BOTCHED.CONFIG.REWARDS.ReferralRewards[k] )
    end

    ply:Botched():SetClaimedReferralRewards( claimedReferralRewards )
    ply:Botched():SendClaimedReferralRewards( unpack( table.GetKeys( unClaimedRewards ) ) )

    ply:Botched():GiveReward( BOTCHED.FUNC.MergeRewardTables( unpack( rewardTables ) ) )

    BOTCHED.FUNC.SendNotification( ply, "REFERRAL REWARDS", "Referral rewards successfully claimed!", "reward" )
end )