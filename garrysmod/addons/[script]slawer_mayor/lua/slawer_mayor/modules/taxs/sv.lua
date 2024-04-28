hook.Add("PostGamemodeLoaded", "Slawer.Mayor:Taxs:PostGamemodeLoaded", function()
	for intID, tbl in pairs(RPExtraTeams) do
		if Slawer.Mayor.CFG.TaxesBlacklist[intID] then continue end
		Slawer.Mayor.JobTaxs[intID] = 0
	end
end)

function Slawer.Mayor:SyncTaxs(pPlayer, tbl)
	if pPlayer then
		Slawer.Mayor:NetStart("SyncTaxs", tbl, pPlayer)
	else
		Slawer.Mayor:NetStart("SyncTaxs", tbl)
	end
end

hook.Add("PlayerSpawn", "Slawer.Mayor:Taxs:PlayerSpawn", function(pPlayer)
	Slawer.Mayor:SyncTaxs(pPlayer, Slawer.Mayor.JobTaxs)
end)

hook.Add("playerGetSalary", "Slawer.Mayor:Taxs:playerGetSalary", function(pPlayer, intSalary)

	local intPercentage = Slawer.Mayor.JobTaxs[pPlayer:Team()] or 0
   	disfulversedbonus = 1

   	if pPlayer:GetUserGroup() == "disfulversed" then
   		disfulversedbonus = 1.75
   	end

	if (not Sublime.Settings.Get("other", "skills_enabled", "boolean")) then
        return;
    end
        
    local points = pPlayer:SL_GetInteger(SKILLPROMOTION.Identifier, 0);

    if (points > 0) then
        sublimeexpmodifier = 1 + ((points * SKILLPROMOTION.AmountPerPoint) / 100); 
            
            --amount = math.Round(amount * sublimeexpmodifier); 500
            --ply:addMoney(amount)
            --return false, DarkRP.getPhrase("payday_message", DarkRP.formatMoney(amount)), amount;
    end

	local intTaken = math.floor(intSalary * intPercentage / 100) --45 * 0.25 = 125
	local intGiven = math.floor( (intSalary * sublimeexpmodifier) * disfulversedbonus  - intTaken ) --45 * 1.2 - 0  = 54
	
	for intID, tbl in pairs(Slawer.Mayor.CFG.Upgrades) do
		if tbl.Condition && not tbl.Condition(pPlayer) then continue end

		local intLevel = Slawer.Mayor:GetUpgradeLevel(intID)

		if tbl.Levels[intLevel].SalaryBonus then
			intGiven = intGiven + tbl.Levels[intLevel].SalaryBonus
		end
	end

	--pPlayer:addMoney(-intTaken) -- = 45
	pPlayer:addMoney(intGiven) -- = 54 (salary*modifier)
	--pPlayer:ChatPrint( sublimeexpmodifier )
	--pPlayer:ChatPrint( intGiven  )

	Slawer.Mayor:AddFunds(intTaken) -- = 0

	DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("SalaryReceived"):format(DarkRP.formatMoney(intGiven), intPercentage))

	return ""
end)

local lastTaxsUpdate = 0

Slawer.Mayor:NetReceive("UpdateTaxs", function(pPlayer, tbl)
	if lastTaxsUpdate > CurTime() then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("TaxsRecentlyUpdated"):format(lastTaxsUpdate - CurTime()))
		return
	end
	
	if not Slawer.Mayor:HasAccess(pPlayer) then
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("NoAccess"))
		return
	end

	local bOkay = true

	for intID, intTax in pairs(tbl) do
		if not tonumber(intID) || not tonumber(intTax) || RPExtraTeams[intID] == nil || tonumber(intTax) < 0 || tonumber(intTax) > Slawer.Mayor.CFG.MaxTax || math.Round(tonumber(intTax)) != tonumber(intTax) then
			continue
		end
		
		if Slawer.Mayor.CFG.TaxesBlacklist[team.GetName(intID)] then
			tbl[intID] = 0
			continue
		end
		
		Slawer.Mayor.JobTaxs[intID] = intTax
	end

	if bOkay then
		Slawer.Mayor:SyncTaxs(nil, Slawer.Mayor.JobTaxs)
		
		lastTaxsUpdate = CurTime() + 10
		
		DarkRP.notify(pPlayer, 0, 5, Slawer.Mayor:L("TaxSuccessfullyUpdated"))
	else
		DarkRP.notify(pPlayer, 1, 5, Slawer.Mayor:L("AnErrorHasOccured"))
	end
end)