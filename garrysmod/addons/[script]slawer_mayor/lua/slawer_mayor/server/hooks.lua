hook.Add("canLockpick", "Slawer.Mayor:canLockpick", function(p, e)
	if e:GetClass() != "slawer_mayor_safe" then return end
	if e.IsOpen then return end
	if not Slawer.Mayor:CanLockpick(p) then return end

	return true
end)

hook.Add("lockpickTime", "Slawer.Mayor:lockpickTime", function(p, e)
	if e:GetClass() != "slawer_mayor_safe" then return end

	return Slawer.Mayor.CFG.LockpickTime
end)

hook.Add("onLockpickCompleted", "Slawer.Mayor:onLockpickCompleted", function(p, b, e)
	if not b then return end
	if e:GetClass() != "slawer_mayor_safe" then return end

	e:OnToggle(true, true)
end)

function Slawer.Mayor:CanLockpick(p)
	return table.IsEmpty(Slawer.Mayor.CFG.LockpickWhitelist) || Slawer.Mayor.CFG.LockpickWhitelist[team.GetName(p:Team())]
end

function Slawer.Mayor:AllReset()
	-- funds
	Slawer.Mayor:SetMaxFunds(Slawer.Mayor.CFG.DefaultMaxFunds)
	Slawer.Mayor:SetFunds(Slawer.Mayor.CFG.DefaultFunds)

	-- upgrades
	Slawer.Mayor.Upgrades = {}

	-- taxes
	for intID, tbl in pairs(RPExtraTeams) do
		if Slawer.Mayor.CFG.TaxesBlacklist[intID] then continue end
		Slawer.Mayor.JobTaxs[intID] = 0
	end

	-- laws
	 DarkRP.resetLaws()

	Slawer.Mayor:NetStart("AllReset", {})
end

hook.Add("OnPlayerChangedTeam", "Slawer.Mayor:BigReset:OnPlayerChangedTeam", function(p, b, a)
	if Slawer.Mayor.CFG.AllResetWhenNoMayor then
		local before = RPExtraTeams[b]

		if before && before.mayor && team.NumPlayers(b) == 0 then
			Slawer.Mayor:AllReset()
		end
	end
end)

-- REPLACEMENT FOR /PLACELAWS COMMAND (extracted from darkrp)

hook.Add("PostGamemodeLoaded", "Slawer.Mayor:ReplacePLCMD", function()
	DarkRP.removeChatCommand("placelaws")

	DarkRP.declareChatCommand{
		command = "placelaws",
		description = "Place a laws board.",
		delay = 1.5
	}

	local numlaws = 0
	local function placeLaws(ply, args)
    local canEdit, message = hook.Call("canEditLaws", hookCanEditLaws, ply, "placeLaws", args)

    if not canEdit then
        DarkRP.notify(ply, 1, 4, message ~= nil and message or DarkRP.getPhrase("unable", GAMEMODE.Config.chatCommandPrefix .. "placeLaws", ""))
        return ""
    end

    if numlaws >= GAMEMODE.Config.maxlawboards then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("limit", GAMEMODE.Config.chatCommandPrefix .. "placeLaws"))
        return ""
    end

    local trace = {}
    trace.start = ply:EyePos()
    trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)

    local ent = ents.Create("slawer_mayor_board")
    ent:SetPos(tr.HitPos + Vector(0, 0, 100))

    local ang = ply:GetAngles()
    ang:RotateAroundAxis(ang:Up(), 90)
    ent:SetAngles(ang)

    ent:CPPISetOwner(ply)
    ent.SID = ply.SID

    ent:Spawn()
    ent:Activate()

    if IsValid(ent) then
        numlaws = numlaws + 1
    end

    ply.lawboards = ply.lawboards or {}
    table.insert(ply.lawboards, ent)

    return ""
	end
	DarkRP.defineChatCommand("placeLaws", placeLaws)

end)