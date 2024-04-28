function Slawer.Jobs:InitData()
    local sMap = game.GetMap()

    if not file.IsDir("slawer", "DATA") then file.CreateDir("slawer") end
    if not file.IsDir("slawer/jobs", "DATA") then file.CreateDir("slawer/jobs") end
    if not file.IsDir("slawer/jobs/" .. sMap, "DATA") then file.CreateDir("slawer/jobs/" .. sMap) end
    
    if not file.Exists("slawer/jobs/" .. sMap .. "/entities.txt", "DATA") then
        file.Write("slawer/jobs/" .. sMap .. "/entities.txt", '[]')
    end

    if not file.Exists("slawer/jobs/darkrpjobs.txt", "DATA") then
        file.Write("slawer/jobs/darkrpjobs.txt", '[]')
    end
end

function Slawer.Jobs:FetchEntities()
    local sMap = game.GetMap()

    local tEntities = util.JSONToTable(file.Read("slawer/jobs/" .. sMap .. "/entities.txt", "DATA") or "[]")

    return tEntities
end

function Slawer.Jobs:SpawnEntities()
    local tEntities = self:FetchEntities()

    for k, v in pairs(tEntities) do
        local eNPC = ents.Create("slawer_jobs_npc")
        eNPC:SetModel(v.sModel)
        eNPC:SetPos(v.vPos)
        eNPC:SetAngles(v.aAng)
        eNPC.sName = v.sName
        eNPC:SetNPCName(v.sName)
        eNPC.tJobs = v.tJobs
        eNPC.iID = k
        eNPC:Spawn()
    end
end

function Slawer.Jobs:SaveNPCJobs(eNPC)
    local sMap = game.GetMap()
    
    local tNPC = {
        sModel = eNPC:GetModel(),
        vPos = eNPC:GetPos(),
        aAng = eNPC:GetAngles(),
        sName = eNPC.sName,
        tJobs = eNPC.tJobs,
    }

    local tEntities = self:FetchEntities()

    if eNPC.iID then
        tEntities[eNPC.iID] = tNPC
    else
        table.insert(tEntities, tNPC)
        eNPC.iID = #tEntities
    end

    file.Write("slawer/jobs/" .. sMap .. "/entities.txt", util.TableToJSON(tEntities))
end

function Slawer.Jobs:CreateNPCJobs(vPos, aAng)
    local eNPC = ents.Create("slawer_jobs_npc")
    eNPC:SetPos(vPos)
    eNPC:SetAngles(aAng)
    eNPC:SetModel("models/Barney.mdl")
    eNPC.sName = "NPC"
    eNPC:SetNPCName("NPC")
    eNPC.tJobs = {}
    eNPC:Spawn()

    Slawer.Jobs:SaveNPCJobs(eNPC)
end

function Slawer.Jobs:DeleteEntity(eNPC)
    local sMap = game.GetMap()

    local tEntities = self:FetchEntities()

    tEntities[eNPC.iID or 0] = nil

    file.Write("slawer/jobs/" .. sMap .. "/entities.txt", util.TableToJSON(tEntities))

    eNPC:Remove()
end

function Slawer.Jobs:SaveDarkRPJob(sTeam, tJob)
    Slawer.Jobs.List = Slawer.Jobs.List or util.JSONToTable(file.Read("slawer/jobs/darkrpjobs.txt", "DATA"))

    Slawer.Jobs.List[sTeam] = tJob

    Slawer.Jobs:CreateOrEditDarkRPJob(sTeam, tJob)

    Slawer.Jobs:NetStart("DarkRPJobEditedOrCreated", {sTeam = sTeam, tJob = tJob}, player.GetAll())

    file.Write("slawer/jobs/darkrpjobs.txt", util.TableToJSON(Slawer.Jobs.List))
end

function Slawer.Jobs:UnSaveDarkRPJob(sTeam, tJob)
    Slawer.Jobs.List = Slawer.Jobs.List or util.JSONToTable(file.Read("slawer/jobs/darkrpjobs.txt", "DATA"))

    Slawer.Jobs.List[sTeam] = nil

    Slawer.Jobs:DeleteDarkRPJob(sTeam)

    Slawer.Jobs:NetStart("DarkRPJobDelete", {sTeam = sTeam}, player.GetAll())

    file.Write("slawer/jobs/darkrpjobs.txt", util.TableToJSON(Slawer.Jobs.List))
end