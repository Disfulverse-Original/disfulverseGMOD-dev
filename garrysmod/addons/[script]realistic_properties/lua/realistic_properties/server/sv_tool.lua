--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

function Realistic_Properties.SaveEntity()
    if not file.Exists("realistic_properties", "DATA") then
        file.CreateDir("realistic_properties") 
    end
    local data = {} 
    for u, ent in pairs(ents.FindByClass("realistic_properties_computer")) do
        table.insert(data, {
            GetClass = ent:GetClass(),          
            GetPos = ent:GetPos(),      
            GetAngle = ent:GetAngles(),
            TableEnt = ent.TableEnt
        })
        if istable(ent.TableEnt) then 
            file.Write("realistic_properties/" .. game.GetMap() .. "_rps_entities" .. ".txt", util.TableToJSON(data, true))  
        end   
    end
    for u, ent in pairs(ents.FindByClass("realistic_properties_npc")) do
        table.insert(data, {
            GetClass = ent:GetClass(),          
            GetPos = ent:GetPos(),      
            GetAngle = ent:GetAngles(),
            TableEnt = ent.TableEnt  
        })
        if istable(ent.TableEnt) then 
            file.Write("realistic_properties/" .. game.GetMap() .. "_rps_entities" .. ".txt", util.TableToJSON(data, true))    
        end 
    end
end 

function Realistic_Properties.Load()
    local directory = "realistic_properties/" .. game.GetMap() .. "_rps_entities" .. ".txt" 
    if file.Exists(directory, "DATA") then  
        local data = file.Read(directory, "DATA")
        data = util.JSONToTable(data)   
        for _, GetClass in pairs(data) do
            rps_entity = ents.Create(GetClass.GetClass)
            rps_entity:SetPos(GetClass.GetPos)  
            rps_entity:SetAngles(GetClass.GetAngle) 
            rps_entity:Spawn()   
            rps_entity.TableEnt = GetClass.TableEnt       
            Realistic_Properties.LoadTable(rps_entity)
            local rps_entityload = rps_entity:GetPhysicsObject()
            if (rps_entityload:IsValid()) then  
                rps_entityload:Wake()   
                rps_entityload:EnableMotion(false)              
            end
        end
    end
end

function Realistic_Properties.LoadTable(rps_entity)
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {} 
    rps_entity.TableEnt = rps_entity.TableEnt
end 

concommand.Add("rps_saveentities", function(ply, cmd, args) 
    Realistic_Properties.SaveEntity()
end )

concommand.Add("rps_cleaupentities", function(ply, cmd, args) 
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
    for u, ent in pairs(ents.FindByClass("realistic_properties_computer")) do
        ent:Remove() 
    end
    for u, ent in pairs(ents.FindByClass("realistic_properties_npc")) do
        ent:Remove() 
    end
end )

concommand.Add("rps_removedata", function(ply, cmd, args)
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
    if file.Exists("realistic_properties/" .. game.GetMap() .. "_rps_entities" .. ".txt", "DATA") then 
        file.Delete( "realistic_properties/" .. game.GetMap() .. "_rps_entities" .. ".txt" )
        concommand.Run(ply,"rps_cleaupentities")
    end   
end)

concommand.Add("rps_reloadentities", function(ply, cmd, args) 
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
    concommand.Run(ply,"rps_cleaupentities")
    Realistic_Properties.Load()
end )

hook.Add("InitPostEntity", "realistic_propertiesInit", Realistic_Properties.Load)
hook.Add("PostCleanupMap", "realistic_propertiesLoad", Realistic_Properties.Load)
