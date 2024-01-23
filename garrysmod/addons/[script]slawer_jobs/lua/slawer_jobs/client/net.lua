Slawer.Jobs:NetReceive("OpenNPC", function(tInfo)
    local dMenu = vgui.Create("Slawer.Jobs:NPCMenu")
    dMenu:SetUp(tInfo)
end)

Slawer.Jobs:NetReceive("OpenNPCEdit", function(tInfo)
    local dMenu = vgui.Create("Slawer.Jobs:NPCConfigMenu")
    dMenu:SetJobs(tInfo)
end)

Slawer.Jobs:NetReceive("OpenDarkRPJobsConfig", function()
    local dMenu = vgui.Create("Slawer.Jobs:DarkRPJobs")
end)

Slawer.Jobs:NetReceive("ReceiveDarkRPJobs", function(tJobs)
    Slawer.Jobs.List = tJobs

    for k, v in pairs(tJobs) do
        Slawer.Jobs:CreateOrEditDarkRPJob(k, v)
    end

    hook.Run("Slawer.Jobs:OnJobsCreated")
end)

Slawer.Jobs:NetReceive("DarkRPJobEditedOrCreated", function(tJob)
    Slawer.Jobs.List[tJob.sTeam] = tJob.tJob

    Slawer.Jobs:CreateOrEditDarkRPJob(tJob.sTeam, tJob.tJob)
end)

Slawer.Jobs:NetReceive("DarkRPJobDelete", function(tJob)
    Slawer.Jobs.List[tJob.sTeam] = nil

    Slawer.Jobs:DeleteDarkRPJob(tJob.sTeam)
end)