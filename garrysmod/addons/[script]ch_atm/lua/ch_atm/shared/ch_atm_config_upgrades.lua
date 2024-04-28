--[[
	Bank Account Levels Config
	InterestRate = How much percentage of the players bank account to give in interest rates.
	MaxInterestToEarn = How much can a player maximum earn in interest per interval? Set to 0 to disable the max
	MaxMoney = How much money can the players bank account maximum hold? 0 for unlimited.
	UpgradePrice = How much does it cost the player to upgrade to this level?
	
	NOTE: The first one [ 1 ] is the default level.
--]]
CH_ATM.Config.AccountLevels = {
	[ 1 ] = {
		InterestRate = 0.003,
		MaxInterestToEarn = 1000,
		MaxMoney = 1000000,
		UpgradePrice = 0,
	},
	[ 2 ] = {
		InterestRate = 0.003,
		MaxInterestToEarn = 1000,
		MaxMoney = 5000000,
		UpgradePrice = 950000,
	},
}