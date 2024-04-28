function BOTCHED.FUNC.GetNextLoginRewardTime()
	local currentDate = os.date( "!*t" )

	local nextDate = table.Copy( currentDate )
	nextDate.hour = 13
	nextDate.min = 0
	nextDate.sec = 0
	nextDate = os.time( nextDate )

	if( currentDate.hour >= 13 ) then
		nextDate = nextDate+86400
	end

	return nextDate
end