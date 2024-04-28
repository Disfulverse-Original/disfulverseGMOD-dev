-- TIME PLAYED FUNCTIONS --
function BOTCHED.PLAYERMETA:GetTimePlayed()
	return (self.PreviousTime or 0)+(CurTime()-(self.JoinTime or 0))
end

function BOTCHED.PLAYERMETA:GetClaimedTimeRewards()
	return self.ClaimedTimeRewards or {}
end

-- LOGIN REWARD FUNCTIONS --
function BOTCHED.PLAYERMETA:GetLoginRewardInfo()
	local daysClaimed, claimTime = self.LoginDaysClaimed or 0, self.LoginClaimTime or 0

	return daysClaimed, claimTime
end

function BOTCHED.PLAYERMETA:CanClaimLoginReward()
	local claimTime = select( 2, self:GetLoginRewardInfo() )

	if( claimTime < BOTCHED.FUNC.GetNextLoginRewardTime()-86400 ) then return true end

	return false
end

function BOTCHED.PLAYERMETA:GetLoginRewardStreak()
	local daysClaimed, claimTime = self:GetLoginRewardInfo()

	if( daysClaimed > 0 and (claimTime < BOTCHED.FUNC.GetNextLoginRewardTime()-(2*86400) or daysClaimed >= 30) ) then return 0 end

	return daysClaimed
end

-- LOGIN REWARD FUNCTIONS --
function BOTCHED.PLAYERMETA:GetLoginRewardInfo()
	local daysClaimed, claimTime = self.LoginDaysClaimed or 0, self.LoginClaimTime or 0

	return daysClaimed, claimTime
end

-- REFERRAL FUNCTIONS --
function BOTCHED.PLAYERMETA:GetReferredPlayers()
	return self.ReferredPlayers or {}
end

function BOTCHED.PLAYERMETA:GetReferralCount()
	local count = 0
	for k, v in pairs( self:GetReferredPlayers() ) do
		if( not v[1] ) then continue end
		count = count+1
	end

	return count
end

function BOTCHED.PLAYERMETA:GetReceivedReferrals()
	return self.ReceivedReferrals or {}
end

function BOTCHED.PLAYERMETA:GetClaimedReferralRewards()
	return self.ClaimedReferralRewards or {}
end

function BOTCHED.PLAYERMETA:GetUnClaimedReferralRewards()
	local claimedRewards = self:GetClaimedReferralRewards()
	local referralCount = self:GetReferralCount()

	local rewardKeys = {}
	for k, v in pairs( BOTCHED.CONFIG.REWARDS.ReferralRewards ) do
		if( claimedRewards[k] or referralCount < k ) then continue end
		rewardKeys[k] = true
	end

	return rewardKeys
end