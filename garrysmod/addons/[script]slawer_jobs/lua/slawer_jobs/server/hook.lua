hook.Add("playerCanChangeTeam", "Slawer.Jobs:playerCanChangeTeam", function(pPlayer, iTeam, bForce)
    if bForce then
        pPlayer.bAllowedJobChange = nil
        return
    end

    if (not pPlayer.bAllowedJobChange and not Slawer.Jobs.CFG.AccessWithoutNPC[team.GetName(iTeam)]) then
        return false, Slawer.Jobs:L("needUseNPC")
    end

    pPlayer.bAllowedJobChange = nil
    
    local tJob = RPExtraTeams[iTeam]

    if Utime and tJob.utime then
        if tJob.utime > tonumber(pPlayer:GetUTime()) then
            DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("needTime"):format(os.date(Slawer.Jobs.CFG["TimeFormat"], tJob.utime)))
            return false
        end
    end
end)

hook.Add("PlayerSay", "Slawer.Jobs:PlayerSay", function(pPlayer, sText)
    if sText == "/sjobs" then
        if not pPlayer:IsSuperAdmin() then
            return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("noAccess"))
        end

        Slawer.Jobs:NetStart("OpenDarkRPJobsConfig", pPlayer)

        return ""
    end
end)

hook.Add("DarkRPFinishedLoading", "Slawer.Jobs:DarkRPFinishedLoading", function()
    Slawer.Jobs:InitData()

    Slawer.Jobs.List = util.JSONToTable(file.Read("slawer/jobs/darkrpjobs.txt", "DATA") or "[]")

    for k, v in pairs(Slawer.Jobs.List) do
        Slawer.Jobs:CreateOrEditDarkRPJob(k, v)
    end

    hook.Run("Slawer.Jobs:OnJobsCreated")
end)

hook.Add("InitPostEntity", "Slawer.Jobs:InitPostEntity", function()
    Slawer.Jobs:InitData()
    Slawer.Jobs:SpawnEntities()
end)

hook.Add("PostCleanupMap", "Slawer.Jobs:PostCleanupMap", function()
    Slawer.Jobs:InitData()
    Slawer.Jobs:SpawnEntities()
end)

hook.Add("getVoteResults", "Slawer.Jobs:getVoteResults", function(tVote, iY, iN)
    if tVote.votetype != "job" then return end

    local bWin = iY > iN and 1 or iN > iY and -1 or 0

    local pTarget = tVote.target

    if bWin and IsValid(pTarget) then
        pTarget.bAllowedJobChange = true
        
        timer.Simple(2, function()
            if IsValid(pTarget) and pTarget.bAllowedJobChange then pTarget.bAllowedJobChange = nil end
        end)
    end
end)

// gmod dirty hack from wiki...
hook.Add( "PlayerInitialSpawn", "Slawer.Jobs:PlayerInitialSpawn", function( pPlayer )
    hook.Add( "SetupMove", pPlayer, function(self, pPlayer, _, cmd )
        if self == pPlayer and not cmd:IsForced() then hook.Run( "PlayerFullLoad", self ) hook.Remove( "SetupMove", self ) end
    end )
end )

hook.Add("PlayerFullLoad", "Slawer.Jobs:PlayerFullLoad", function(pPlayer)
    Slawer.Jobs:NetStart("ReceiveDarkRPJobs", Slawer.Jobs.List or {}, pPlayer)
end)