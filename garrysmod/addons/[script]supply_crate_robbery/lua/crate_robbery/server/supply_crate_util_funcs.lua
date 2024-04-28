local PMETA = FindMetaTable( "Player" )

function PMETA:CRATE_RankCanRob()
	local can_rob = false

	for k, v in pairs( CH_SupplyCrate.Config.RankRestrictions ) do
		if serverguard then
			if v.UserGroup == serverguard.player:GetRank( self ) then
				return v.CanRob
			end
		elseif sam then
			if v.UserGroup == sam.player.get_rank( self:SteamID() ) then
				return v.CanRob
			end
		else
			if v.UserGroup == self:GetUserGroup() then
				return v.CanRob
			end
		end
	end

	return can_rob
end