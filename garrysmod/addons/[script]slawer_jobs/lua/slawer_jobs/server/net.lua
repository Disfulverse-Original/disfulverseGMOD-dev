Slawer.Jobs:NetReceive("SaveNPCJobs", function(pPlayer, tInfo)
    if not pPlayer:IsSuperAdmin() then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("noAccess"))
    end

    if not tInfo or not tInfo.tJobs or not tInfo.sName or not tInfo.sModel or not istable(tInfo.tJobs) or not isstring(tInfo.sName) or not isstring(tInfo.sModel) then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    if string.len(tInfo.sName) < 3 or string.len(tInfo.sName) > 30 then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end 

    local eTarget = pPlayer:GetEyeTrace().Entity

    if not IsValid(eTarget) or eTarget:GetClass() ~= "slawer_jobs_npc" then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    if eTarget:GetModel() ~= tInfo.sModel then
        eTarget:SetModel(tInfo.sModel)
    end
    
    eTarget.tJobs = tInfo.tJobs
    eTarget.sName = tInfo.sName
    eTarget:SetNPCName(tInfo.sName)

    Slawer.Jobs:SaveNPCJobs(eTarget)

    DarkRP.notify(pPlayer, 0, 5, "The NPC has successfully been updated")
end)

Slawer.Jobs:NetReceive("DeleteNPCJobs", function(pPlayer, tInfo)
    if not pPlayer:IsSuperAdmin() then
        return DarkRP.notify(pPlayer, 1, 5, "You don't have access to that")
    end

    local eTarget = pPlayer:GetEyeTrace().Entity

    if not IsValid(eTarget) or eTarget:GetClass() ~= "slawer_jobs_npc" then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    Slawer.Jobs:DeleteEntity(eTarget)

    DarkRP.notify(pPlayer, 0, 5, Slawer.Jobs:L("npcDeleted"))
end)

Slawer.Jobs:NetReceive("ChangeJob", function(pPlayer, tInfo)
    local eTarget = pPlayer:GetEyeTrace().Entity

    if not IsValid(eTarget) or eTarget:GetClass() ~= "slawer_jobs_npc" then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    if pPlayer:GetPos():DistToSqr(eTarget:GetPos()) > 90000 then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    local sCmd = tInfo.sCmd or ""
    local iJob = -1

    for k, v in pairs(RPExtraTeams) do
        if v.command == sCmd then
            iJob = k
            break
        end
    end

    if not sCmd or iJob == -1 then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("unknownJob"))
    end
    
    local tJob = RPExtraTeams[iJob]

    if not eTarget.tJobs[tJob.command] or not eTarget.tJobs[tJob.command] then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    pPlayer.bAllowedJobChange = true

    pPlayer:ConCommand("darkrp " .. (tJob.vote and "vote" or "") .. tJob.command)

    timer.Simple(2, function()
        if IsValid(pPlayer) and pPlayer.bAllowedJobChange then pPlayer.bAllowedJobChange = nil end
    end)
end)

local function isValidString(sText, pPlayer, sMessage)
    if sText == nil or string.Trim(sText) == "" then
        return DarkRP.notify(pPlayer, 1, 5, sMessage)
    end

    return true
end

Slawer.Jobs:NetReceive("SaveDarkRPJob", function(pPlayer, tInfo)
    if not pPlayer:IsSuperAdmin() then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("noAccess"))
    end

    local tJob = tInfo.tJob
    local sTeam = tInfo.sTeam

    tJob.admin = math.floor(tonumber(tJob.admin) or -1)
    tJob.salary = math.floor(tonumber(tJob.salary) or -1)
    tJob.max = tonumber(tJob.max) or -1

    if not isValidString(tJob.name, pPlayer, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("name")) then return end
    if not isValidString(sTeam, pPlayer, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("teamID")) then return end
    if not isValidString(tJob.command, pPlayer, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("command")) then return end
    if not tJob.admin or tJob.admin < 0 or tJob.admin > 2 then return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("adminRank")) end
    if not tJob.salary or tJob.salary < 0 then return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("salary")) end
    if not tJob.max or tJob.max < 0 then return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("max")) end
    if not isValidString(tJob.description, pPlayer, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("description")) then return end
    if not tJob.color then return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("color")) end
    if not tJob.model or table.IsEmpty(tJob.model) then return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("model")) end
    if not tJob.weapons then return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("weapons")) end
    
    if tJob.customCheck == "" then tJob.customCheck = nil end
    if tJob.CustomCheckFailMsg == "" then tJob.CustomCheckFailMsg = nil end
    if tJob.icon == "" then tJob.icon = nil end
    if tJob.utime then tJob.utime = tonumber(tJob.utime) end
    if tJob.level then tJob.level = tonumber(tJob.level) end

    local bOkay = true

    for k, v in pairs(RPExtraTeams) do
        if v.command == tJob.command and _G[sTeam] ~= k then bOkay = false break end
    end

    if not bOkay then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("commandAlreadyTaken"))
    end

    if RPExtraTeams[sTeam] and not (Slawer.Jobs.List or {})[sTeam] then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("invalidValue") .. Slawer.Jobs:L("teamAlreadyTaken"))
    end

    Slawer.Jobs:SaveDarkRPJob(sTeam, tJob)

    DarkRP.notify(pPlayer, 0, 5, Slawer.Jobs:L("jobCreated"))
end)

Slawer.Jobs:NetReceive("AskForDeleteDarkRPJob", function(pPlayer, tJob)
    if not pPlayer:IsSuperAdmin() then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("noAccess"))
    end

    local sTeam = tJob.sTeam

    if not _G[sTeam] or not Slawer.Jobs.List[sTeam] then
        return DarkRP.notify(pPlayer, 1, 5, Slawer.Jobs:L("errorOccured"))
    end

    Slawer.Jobs:UnSaveDarkRPJob(sTeam, tJob)
    Slawer.Jobs.List[sTeam] = nil
    
    DarkRP.notify(pPlayer, 0, 5, Slawer.Jobs:L("jobDeleted"))
end)