BOTCHED.FUNC.SQLCreateTable( "botched_rewards", [[
	userID INTEGER PRIMARY KEY,
	timePlayed int,
	daysClaimed int,
	claimTime int
]] )

BOTCHED.FUNC.SQLCreateTable( "botched_claimed_timerewards", [[
	userID int NOT NULL,
	rewardKey varchar(30) NOT NULL,
	claimTime int NOT NULL
]] )

BOTCHED.FUNC.SQLCreateTable( "botched_referrals", [[
	userID int NOT NULL,
	referredSteamID64 varchar(20) NOT NULL,
	accepted bool,
	timeSent int
]] )

BOTCHED.FUNC.SQLCreateTable( "botched_claimed_referralrewards", [[
	userID int NOT NULL,
	rewardKey int NOT NULL,
	claimTime int NOT NULL
]] )