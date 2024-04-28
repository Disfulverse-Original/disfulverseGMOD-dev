-- DATA FUNCTIONS --
hook.Add( "Botched.Hooks.PlayerLoadData", "Botched.Botched.Hooks.PlayerLoadData.TimeRewards", function( ply, userID )
    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_rewards WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        ply:Botched():SetPreviousTimePlayed( tonumber( data.timePlayed or 0 ) or 0 )
        ply:Botched():SetLoginRewardInfo( tonumber( data.daysClaimed or 0 ) or 0, tonumber( data.claimTime or 0 ) or 0 )
    end, true )

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_claimed_timerewards WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        local claimedRewards = {}
        for k, v in ipairs( data ) do
            if( not v.rewardKey ) then continue end

            claimedRewards[v.rewardKey] = tonumber( v.claimTime or "" ) or 0
        end

        ply:Botched():SetClaimedTimeRewards( claimedRewards )
        ply:Botched():SendClaimedTimeRewards( unpack( table.GetKeys( claimedRewards ) ) )
    end )

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_referrals WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        local referredPlayers = {}
        for k, v in ipairs( data ) do
            referredPlayers[v.referredSteamID64] = { tobool( v.accepted ), tonumber( v.timeSent or "" ) or 0 }
        end

        ply:Botched():SetReferredPlayers( referredPlayers )
        ply:Botched():SendReferredPlayers( unpack( table.GetKeys( referredPlayers ) ) )
    end )

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_referrals WHERE referredSteamID64 = '" .. ply:SteamID64() .. "';", function( data )
        if( not data ) then return end

        local currentNum = 0
        local receivedReferrals = {}
        local function GetNextPlayer()
            currentNum =  currentNum+1

            local currentInfo = data[currentNum]
            if( not currentInfo ) then
                ply:Botched():SetReceivedReferrals( receivedReferrals )
                ply:Botched():SendReceivedReferrals( unpack( table.GetKeys( receivedReferrals ) ) )
                return
            end

            BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_players WHERE userID = " .. currentInfo.userID .. ";", function( senderData )
                receivedReferrals[tonumber( currentInfo.userID )] = { senderData.steamID64, tobool( currentInfo.accepted ), tonumber( currentInfo.timeSent or "" ) or 0 }
                GetNextPlayer()
            end, true )
        end

        GetNextPlayer()
    end )

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_claimed_referralrewards WHERE userID = " .. userID .. ";", function( data )
        if( not data ) then return end

        local claimedRewards = {}
        for k, v in ipairs( data ) do
            local rewardKey = tonumber( v.rewardKey or "" )
            if( not rewardKey ) then continue end

            claimedRewards[rewardKey] = tonumber( v.claimTime or "" ) or 0
        end

        ply:Botched():SetClaimedReferralRewards( claimedRewards )
        ply:Botched():SendClaimedReferralRewards( unpack( table.GetKeys( claimedRewards ) ) )
    end )
end )

hook.Add( "PlayerDisconnected", "Botched.PlayerDisconnected.TimePlayed", function( ply )
    local botchedMeta = ply:Botched()
    if( not botchedMeta ) then return end

    BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_rewards WHERE userID = '" .. botchedMeta:GetUserID() .. "';", function( data )
        if( data ) then
            BOTCHED.FUNC.SQLQuery( "UPDATE botched_rewards SET timePlayed = " .. botchedMeta:GetTimePlayed() .. " WHERE userID = '" .. botchedMeta:GetUserID() .. "';" )
        else
            BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_rewards( userID, timePlayed ) VALUES(" .. botchedMeta:GetUserID() .. ", " .. botchedMeta:GetTimePlayed() .. ");" )
        end
    end, true )
end )

hook.Add( "Think", "Botched.Think.TimePlayed", function()
    if( CurTime() < (BOTCHED.TEMP.LastTimeSave or 0)+300 ) then return end
    BOTCHED.TEMP.LastTimeSave = CurTime()

    for k, v in ipairs( player.GetAll() ) do
        local botchedMeta = v:Botched()
        if( not botchedMeta ) then continue end

        BOTCHED.FUNC.SQLQuery( "SELECT * FROM botched_rewards WHERE userID = '" .. botchedMeta:GetUserID() .. "';", function( data )
            if( data ) then
                BOTCHED.FUNC.SQLQuery( "UPDATE botched_rewards SET timePlayed = " .. botchedMeta:GetTimePlayed() .. " WHERE userID = '" .. botchedMeta:GetUserID() .. "';" )
            else
                BOTCHED.FUNC.SQLQuery( "INSERT INTO botched_rewards( userID, timePlayed ) VALUES(" .. botchedMeta:GetUserID() .. ", " .. botchedMeta:GetTimePlayed() .. ");" )
            end
        end, true )
    end
end )

-- TIME PLAYED FUNCTIONS --
util.AddNetworkString( "Botched.SendPreviousTimePlayed" )
function BOTCHED.PLAYERMETA:SetPreviousTimePlayed( previousTime )
    self.PreviousTime = previousTime

    net.Start( "Botched.SendPreviousTimePlayed" )
        net.WriteUInt( previousTime, 32 )
    net.Send( self.Player )
end

util.AddNetworkString( "Botched.SendJoinTime" )
function BOTCHED.PLAYERMETA:SetJoinTime( joinTime )
    self.JoinTime = joinTime

    net.Start( "Botched.SendJoinTime" )
        net.WriteUInt( joinTime, 22 )
    net.Send( self.Player )
end

function BOTCHED.PLAYERMETA:SetClaimedTimeRewards( claimedRewards )
    self.ClaimedTimeRewards = claimedRewards
end

util.AddNetworkString( "Botched.SendClaimedTimeRewards" )
function BOTCHED.PLAYERMETA:SendClaimedTimeRewards( ... )
    local rewardKeys = { ... }

    net.Start( "Botched.SendClaimedTimeRewards" )
        net.WriteUInt( #rewardKeys, 6 )
        for k, v in ipairs( rewardKeys ) do
            net.WriteString( v )
            net.WriteUInt( self.ClaimedTimeRewards[v] or 0, 32 )
        end
    net.Send( self.Player )
end

-- LOGIN REWARD FUNCTIONS --
util.AddNetworkString( "Botched.SendLoginRewardInfo" )
function BOTCHED.PLAYERMETA:SetLoginRewardInfo( daysClaimed, claimTime )
    self.LoginDaysClaimed = daysClaimed
    self.LoginClaimTime = claimTime

    net.Start( "Botched.SendLoginRewardInfo" )
        net.WriteUInt( daysClaimed, 5 )
        net.WriteUInt( claimTime, 32 )
    net.Send( self.Player )
end

-- REFERRAL FUNCTIONS --
function BOTCHED.PLAYERMETA:SetReferredPlayers( referredPlayers )
    self.ReferredPlayers = referredPlayers
end

util.AddNetworkString( "Botched.SendReferredPlayers" )
function BOTCHED.PLAYERMETA:SendReferredPlayers( ... )
    local playerKeys = { ... }

    net.Start( "Botched.SendReferredPlayers" )
        net.WriteUInt( #playerKeys, 6 )
        for k, v in ipairs( playerKeys ) do
            net.WriteString( v )

            local referredInfo = self.ReferredPlayers[v]
            net.WriteBool( referredInfo != nil )

            if( not referredInfo ) then continue end

            net.WriteBool( referredInfo[1] )
            net.WriteUInt( referredInfo[2], 32 )
        end
    net.Send( self.Player )
end

function BOTCHED.PLAYERMETA:SetReceivedReferrals( receivedReferrals )
    self.ReceivedReferrals = receivedReferrals
end

util.AddNetworkString( "Botched.SendReceivedReferrals" )
function BOTCHED.PLAYERMETA:SendReceivedReferrals( ... )
    local userIDs = { ... }

    net.Start( "Botched.SendReceivedReferrals" )
        net.WriteUInt( #userIDs, 6 )
        for k, v in ipairs( userIDs ) do
            net.WriteUInt( v, 16 )

            local referralInfo = self.ReceivedReferrals[v]
            net.WriteBool( referralInfo != nil )

            if( not referralInfo ) then continue end

            net.WriteString( referralInfo[1] or "" )
            net.WriteBool( referralInfo[2] )
            net.WriteUInt( referralInfo[3] or 0, 32 )
        end
    net.Send( self.Player )
end

function BOTCHED.PLAYERMETA:SetClaimedReferralRewards( claimedReferralRewards )
    self.ClaimedReferralRewards = claimedReferralRewards
end

util.AddNetworkString( "Botched.SendClaimedReferralRewards" )
function BOTCHED.PLAYERMETA:SendClaimedReferralRewards( ... )
    local rewardKeys = { ... }

    net.Start( "Botched.SendClaimedReferralRewards" )
        net.WriteUInt( #rewardKeys, 6 )
        for k, v in ipairs( rewardKeys ) do
            net.WriteUInt( v, 6 )
            net.WriteUInt( self.ClaimedReferralRewards[v] or 0, 32 )
        end
    net.Send( self.Player )
end