--[[ Initialize all table and all information of RCD ]]
hook.Add("Initialize", "RCD:Initialize:Table", function()
    print("[RCD] Initialize RCD")
    timer.Simple(5, function()
        RCD.InitializeTables()
        RCD.InitializeGroups()
        RCD.InitializeVehicles()
        RCD.InitializeSettings()
        RCD.LoadNPC()
    end)
end)

--[[ Initialize all information of the player ]]
hook.Add("PlayerInitialSpawn", "RCD:PlayerInitialSpawn:Initialize", function(ply)
    timer.Simple(5, function()
        if not IsValid(ply) or not ply:IsPlayer() then return end

        ply.RCD = ply.RCD or {}

        ply:RCDSyncAllVariables()
        ply:RCDSyncVehicleBought()
        ply:RCDSendAllGroups()
        ply:RCDSendAllVehicles()

        RCD.SendSettings(ply)
    end)
end)

--[[ Reset variables of the player ]]
hook.Add("PlayerDisconnected", "RCD:PlayerDisconnected", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    RCD.NWVariables["networkEnt"][ply] = nil

    local vehiclesSpawn = ply:RCDGetAllVehiclesSpawned()
    for k,v in pairs(vehiclesSpawn) do
        if not IsValid(v) then continue end

        v:Remove()
    end
end)

--[[ Set variables on vehicles ]]
hook.Add("OnEntityCreated", "RCD:OnEntityCreated:InitializeVariables", function(ent)
    if not IsValid(ent) or not RCD.IsVehicle(ent) then return end

    timer.Simple(1, function()
        if not IsValid(ent) then return end
    
        RCD.SetNWVariable("RCDEngine", false, ent)
    end)
end)

--[[ Set the engine and belt variables ]]
hook.Add("PlayerButtonDown", "RCD:PlayerButtonDown:Key", function(ply, button)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local beltKey = RCD.GetSetting("beltKey", "number")
    local engineKey = RCD.GetSetting("engineKey", "number")
    local underglowKey = RCD.GetSetting("underglowKey", "number")
    local nitroKey = RCD.GetSetting("nitroKey", "number")
    
    if button != beltKey && button != engineKey && button != underglowKey && button != nitroKey then return end

    local curTime = CurTime()

    ply.RCD["keySpam"] = ply.RCD["keySpam"] or 0
    if ply.RCD["keySpam"] > curTime then return end
    ply.RCD["keySpam"] = curTime + 0.5

    if button == beltKey && RCD.GetSetting("beltActivate", "boolean") then
        ply:RCDSecurityBelt()

    elseif button == engineKey && RCD.GetSetting("engineActivate", "boolean") then
        ply:RCDVehicleEngine()
        
    elseif button == underglowKey then
        local vehc = RCD.GetVehicle(ply:GetVehicle())
        if not IsValid(vehc) or not RCD.IsVehicle(vehc) then return end

        local underGlow = RCD.GetNWVariables("RCDUnderGlowActivate", vehc)
        RCD.ActivateUnderGlow(vehc, !underGlow)
    elseif button == nitroKey then    
        local vehc = RCD.GetVehicle(ply:GetVehicle())
        if not IsValid(vehc) or not RCD.IsVehicle(vehc) then return end

        local vehicleId = vehc.RCDUniqueId
        if not isnumber(vehicleId) then return end

        local vehicleTable = RCD.GetVehicleInfo(vehicleId)
        if not istable(vehicleTable) then return end
    
        local options = vehicleTable["options"] or {}
        if not options["canBuyNitro"] then return end

        RCD.SetBoost(vehc, ply)
    end
end)

--[[ Set engine and belt variables when the player enter into the vehicle ]]
hook.Add("PlayerEnteredVehicle", "RCD:PlayerEnteredVehicle:InitializeVariables", function(ply, vehc)
    if not IsValid(ply) or not ply:IsPlayer() or not IsValid(vehc) then return end
    
    RCD.SyncNWVariable("RCDEngine", vehc, ply)
    RCD.SetNWVariable("RCDSecurityBelt", false, ply, true, ply)
    
    if RCD.GetSetting("engineActivate", "boolean") then
        local engineStatus = RCD.GetNWVariables("RCDEngine", vehc)
        RCD.SetVehicleEngine(vehc, engineStatus)

        timer.Simple(1, function()        
            RCD.SetVehicleEngine(vehc, engineStatus)
        end)
    end
end)

--[[ Stop the beltsound when you leave the vehicle ]]
hook.Add("PlayerLeaveVehicle", "RCD:PlayerLeaveVehicle", function(ply, vehc)
    if not IsValid(ply) or not ply:IsPlayer() or not IsValid(vehc) then return end
    
    if ply:RCDCheckTestVehicle() then
        ply:RCDResetTest()
    end

    if RCD.GetSetting("beltWarningSound", "boolean") then
        ply.RCD["beltSound"] = false
        ply:StopSound("rcd_sounds/beltsound.mp3")

        if RCD.GetSetting("engineActivate", "boolean") then
            local engineStatus = RCD.GetNWVariables("RCDEngine", vehc)

            RCD.SetVehicleEngine(vehc, engineStatus)
        end
    end
end)

--[[ Emit the belt sound when the vehicle move ]]
hook.Add("VehicleMove", "RCD:VehicleMove", function(ply, vehc, mv)
    if not IsValid(ply) or not ply:IsPlayer() or not IsValid(vehc) then return end

    if RCD.GetSetting("beltWarningSound", "boolean") && RCD.GetSpeedVehicle(vehc, RCD.UnitChoose) > 15 then
        local securityBelt = RCD.GetNWVariables("RCDSecurityBelt", ply) && not RCD.GetVehicleParams(vehc.RCDUniqueId, "disableBeltVehicle")
        if securityBelt then return end

        if ply.RCD["beltSound"] then return end
        ply.RCD["beltSound"] = true
        
        ply:EmitSound("rcd_sounds/beltsound.mp3", 75, 100, 0.5)
    end
end)

local damageTypeTable = {
    [DMG_VEHICLE] = true,
    [DMG_CRUSH] = true,
}

--[[ Know when the player take damage when he his on a vehicle ]]
hook.Add("EntityTakeDamage", "RCD:EntityTakeDamage", function(ent, dmg)
    if not IsValid(ent) or not ent:IsPlayer() then return end
    
    local totalDamage = dmg:GetDamage()
	if totalDamage < 0.1 then
		totalDamage = totalDamage * 10000
	end
    
    local damageType = dmg:GetDamageType()
    if not damageTypeTable[damageType] then return end
    
    if RCD.GetSetting("ejectActivate", "boolean") && (totalDamage > RCD.GetSetting("ejectMinDamage", "number")) && not RCD.GetNWVariables("RCDSecurityBelt", ent) then 
        ent:RCDEjectPeople()
    elseif RCD.GetSetting("smallAccidentActivate", "boolean") && (totalDamage > RCD.GetSetting("smallAccidentMinDamage", "number")) then
        local vehc = RCD.GetVehicle(ent)
        if not IsValid(vehc) then return end

        vehc:EmitSound("rcd_sounds/airbag.wav")
        ent:RCDAccident(vehc)
    end
end)

--[[ All command of the addon ]]
hook.Add("PlayerSay", "RCD:PlayerSay:Command", function(ply, text)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not RCD.AdminRank[ply:GetUserGroup()] then return end

    if string.lower(text) == string.lower(RCD.GetSetting("adminCommand", "string")) then
        ply:RCDOpenAdminMenu()
        return ""
    end
end)

--[[ Check if the player can exist his vehicle ]]
hook.Add("CanExitVehicle", "RCD:CanExitVehicle:Check", function(vehc, ply)
    if not IsValid(ply) or not ply:IsPlayer() or not IsValid(vehc) then return end

    if RCD.GetSetting("cantExitModule", "boolean") then
        local speed = RCD.GetSpeedVehicle(vehc, RCD.UnitChoose)

        if speed > RCD.GetSetting("exitKMH", "number") then
            ply:RCDNotification(5, RCD.GetSentence("cantExitVehicle2"))
            return false
        end
    end

    local securityBelt = RCD.GetNWVariables("RCDSecurityBelt", ply) && not RCD.GetVehicleParams(vehc.RCDUniqueId, "disableBeltVehicle")
    if RCD.GetSetting("beltActivate", "boolean") && securityBelt then
        ply:RCDNotification(5, RCD.GetSentence("cantExitVehicle3"))
        return false
    end
end)

--[[ Load all NPC on the map ]]
hook.Add("PostCleanupMap", "RCD:PostCleanupMap", function() 
    RCD.LoadNPC()
end)

--[[ Remove vehicle when the player change team ]]
hook.Add("PlayerChangedTeam", "RCD:PlayerChangedTeam:RemoveVehicles", function(ply, oldTeam, newTeam)
    RCD.AdvancedConfiguration["vehiclesList"] = RCD.AdvancedConfiguration["vehiclesList"] or {}
    
    local vehiclesSpawn = ply:RCDGetAllVehiclesSpawned()
    for k,v in pairs(vehiclesSpawn) do
        if not IsValid(v) then continue end

        RCD.AdvancedConfiguration["vehiclesList"][k] = RCD.AdvancedConfiguration["vehiclesList"][k] or {}

        local groupId = RCD.AdvancedConfiguration["vehiclesList"][k]["groupId"]
        if not isnumber(groupId) then return end

        local groupTable = RCD.AdvancedConfiguration["groupsList"][groupId] or {}
        if not istable(groupTable) then return end

        local jobTable = groupTable["jobAccess"] or {}
        if jobTable["*"] or jobTable[team.GetName(newTeam)] then continue end

        v:Remove()
    end
end)

--[[ Try to lunch the vehicle ]]
hook.Add("KeyPress", "RCD:KeyPress:CheckEngine", function(ply, key)
    local engineActivate = RCD.GetSetting("engineActivate", "boolean")
    if not engineActivate then return end
    
    local plyVehc = ply:GetVehicle()
    if not IsValid(plyVehc) then return end
    
    local vehc = RCD.GetVehicle(plyVehc)
    if not IsValid(vehc) then return end

    if timer.Exists("rcd_check_engine:"..vehc:EntIndex()) then return end
    
    local engineOn = hook.Run("RCD:CanChangeEngine", vehc)
    local engineStatut = RCD.GetNWVariables("RCDEngine", vehc) && (engineOn != false)

    if key == IN_FORWARD && not engineStatut && not RCD.GetVehicleParams(vehc.RCDUniqueId, "disableEngineVehicle") then
        vehc:EmitSound("rcd_sounds/startengine.wav")

        timer.Create("rcd_check_engine:"..vehc:EntIndex(), 0.7, 1, function()
            if not IsValid(vehc) then return end
            
            vehc:StopSound("rcd_sounds/startengine.wav")
        end)
    end
end)