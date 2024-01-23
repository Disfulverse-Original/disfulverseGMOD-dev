--[[
	PlayerInitialSpawn hook
--]]
function CH_ATM.PlayerInitialSpawn( ply )
	-- Control if they have a bank account or not and initialize/load accordingly
	CH_ATM.ControlPlayerBankAccount( ply )

	-- Network transaction history to the player
	timer.Simple( 5, function()
		if IsValid( ply ) then
			CH_ATM.NetworkTransactionsSQL( ply )
		end
	end )

	-- Start timer to generate interest
	timer.Create( "CH_ATM_GenerateInterest_".. ply:EntIndex(), CH_ATM.Config.InterestInterval, 0, function()
		CH_ATM.GenerateInterestPlayer( ply )
	end )
end
hook.Add( "PlayerInitialSpawn", "CH_ATM.PlayerInitialSpawn", CH_ATM.PlayerInitialSpawn )

--[[
	Open ATM admin menu via chat command
--]]
function CH_ATM.PlayerSay( ply, text )
	if string.lower( text ) == CH_ATM.Config.AdminATMChatCommand then
		if ply:IsAdmin() then
			net.Start( "CH_ATM_Net_AdminMenu" )
			net.Send( ply )
		end
		
		return ""
	end
end
hook.Add( "PlayerSay", "CH_ATM.PlayerSay", CH_ATM.PlayerSay )

--[[
	Drop players wallet from DarkRP on death
	Percentage based on config
--]]
function CH_ATM.LooseMoneyOnDeath( ply, inflictor, attacker )
	local ply_money_wallet = CH_ATM.GetMoney( ply )
	local percentage_to_drop = CH_ATM.Config.WalletLooseOnDeathPercentage
	
	-- Calculate amt to loose
	local amt_to_loose = math.Round( ( ply_money_wallet / 100 ) * percentage_to_drop )
	
	-- Clamp it if config is over 0
	if CH_ATM.Config.MaximumToLooseOnDeath > 0 then
		amt_to_loose = math.Clamp( amt_to_loose, 0, CH_ATM.Config.MaximumToLooseOnDeath )
	end
	
	-- If amount to loose is over 0 then take money
	if amt_to_loose > 0 then
		-- Take the money from their wallet
		CH_ATM.TakeMoney( ply, amt_to_loose )
		
		-- If enabled then drop the money on the body
		if CH_ATM.Config.DropMoneyOnDeath then
			local pos = ply:GetPos()
			
			DarkRP.createMoneyBag( pos, amt_to_loose )
		end
		
		-- Notify player
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You have died and dropped" ) .." ".. CH_ATM.FormatMoney( amt_to_loose ) )
	end
end
hook.Add( "PlayerDeath", "CH_ATM.LooseMoneyOnDeath", CH_ATM.LooseMoneyOnDeath )