function SUPPLY_CRATE_RespawnEntsCleanup()
   print( "[Supply Crate Robbery] - Map cleaned up. Respawning supply create..." )

   timer.Simple( 1, function()
	  SUPPLY_CRATE_InitCrateEnt()
   end )
end
hook.Add( "PostCleanupMap", "SUPPLY_CRATE_RespawnEntsCleanup", SUPPLY_CRATE_RespawnEntsCleanup )

-- Robbery failure check on PlayerDeath
function CRATE_PlayerDeath( ply, inflictor, attacker )
	if ply.IsRobbingCrate then
		DarkRP.notify( ply, 1, 5, CH_SupplyCrate.Config.Lang["You have failed to rob the loot from the supply crate!"][CH_SupplyCrate.Config.Language] )

		if IsValid( attacker ) then
			if (ply != attacker) then
				DarkRP.notify( attacker, 1, 5, "+".. DarkRP.formatMoney( CH_SupplyCrate.Config.KillReward ) .." "..CH_SupplyCrate.Config.Lang["rewarded for killing the robber."][CH_SupplyCrate.Config.Language] )
				attacker:addMoney( CH_SupplyCrate.Config.KillReward )
				
				-- XP System Support
				-- Give experience support for Vronkadis DarkRP Level System
				--[[
				if CH_SupplyCrate.Config.DarkRPLevelSystemEnabled then
					attacker:addXP( CH_SupplyCrate.Config.XPStoppingRobber, true )
				end
				--]]
				-- Give experience support for Sublime Levels
				if CH_SupplyCrate.Config.SublimeLevelSystemEnabled then
					attacker:SL_AddExperience( CH_SupplyCrate.Config.XPStoppingRobber, "за успешную нейтрализацию грабителя.")
				end


				if CH_SupplyCrate.Config.BricksLevelSystemEnabled then
					attacker:AddExperience(BRICKS_SERVER.CONFIG.LEVELING["EXP Gained - ROBBERY KILL"], "Robber killed")
				end

			end
		end
		
		CRATE_RobberyFinished( false )

		ply.IsRobbingCrate = false
		
		-- bLogs support
		hook.Run( "SUPPLY_CRATE_RobberyFailed", ply )
	end
end
hook.Add( "PlayerDeath", "CRATE_PlayerDeath", CRATE_PlayerDeath )

-- Robbery failure check on PlayerDisconnected
function CRATE_RobberyDisconnect( ply )
	if ply.IsRobbingCrate then			
		CRATE_RobberyFinished( false )

		ply.IsRobbingCrate = false
	end
end
hook.Add( "PlayerDisconnected", "CRATE_RobberyDisconnect", CRATE_RobberyDisconnect )