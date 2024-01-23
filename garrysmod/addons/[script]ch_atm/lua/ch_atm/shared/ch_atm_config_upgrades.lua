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
		InterestRate = 0.01,
		MaxInterestToEarn = 1000,
		MaxMoney = 1000000,
		UpgradePrice = 0,
	},
	[ 2 ] = {
		InterestRate = 0.02,
		MaxInterestToEarn = 2000,
		MaxMoney = 2000000,
		UpgradePrice = 20000,
	},
	[ 3 ] = {
		InterestRate = 0.03,
		MaxInterestToEarn = 3000,
		MaxMoney = 3000000,
		UpgradePrice = 30000,
	},
	[ 4 ] = {
		InterestRate = 0.04,
		MaxInterestToEarn = 4000,
		MaxMoney = 4000000,
		UpgradePrice = 40000,
	},
	[ 5 ] = {
		InterestRate = 0.05,
		MaxInterestToEarn = 5000,
		MaxMoney = 5000000,
		UpgradePrice = 50000,
	},
	[ 6 ] = {
		InterestRate = 0.06,
		MaxInterestToEarn = 6000,
		MaxMoney = 6000000,
		UpgradePrice = 60000,
	},
	[ 7 ] = {
		InterestRate = 0.07,
		MaxInterestToEarn = 7000,
		MaxMoney = 7000000,
		UpgradePrice = 70000,
	},
	[ 8 ] = {
		InterestRate = 0.08,
		MaxInterestToEarn = 8000,
		MaxMoney = 8000000,
		UpgradePrice = 80000,
	},
	[ 9 ] = {
		InterestRate = 0.09,
		MaxInterestToEarn = 9000,
		MaxMoney = 9000000,
		UpgradePrice = 90000,
	},
	[ 10 ] = {
		InterestRate = 0.10,
		MaxInterestToEarn = 10000,
		MaxMoney = 0,
		UpgradePrice = 100000,
	},
}