local PLAYER = FindMetaTable("Player")

--[[ This function permit to solve a lot of exploit ]]
function PLAYER:RCDCheckNPCInfo(groupId)
    local npc = self.RCD["ent_used"]
    if not IsValid(npc) then return false end

    local dist = self:GetPos():DistToSqr(npc:GetPos())
    if dist > 30000 then self:RCDNotification(5, RCD.GetSentence("npcTooFar")) return false end

    local npcInfo = RCD.GetNPCInfo(npc)
    local groups = npcInfo["groups"]

    if not groups[groupId] then self:RCDNotification(5, RCD.GetSentence("npcNotOwnedVehicle")) return false end

    return true
end

--[[ Get all vehicles bought of a player connected ]]
function PLAYER:RCDGetVehicleBought(vehicleId)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    self.RCD = self.RCD or {}
    self.RCD["vehicleBought"] = self.RCD["vehicleBought"] or {}

    return self.RCD["vehicleBought"][vehicleId]
end

--[[ Give a vehicle to a steamId or a player ]]
function RCD.GiveVehicle(target, vehicleId, customization, discount)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end
    
    local vehicleTable = RCD.GetVehicleInfo(vehicleId)
    if not istable(vehicleTable) then return end

    customization = istable(customization) and customization or {}

    local options = vehicleTable["options"] or {}
    customization["vehicleSkin"] = customization["vehicleSkin"] or (options["skin"] or 0)

    discount = tonumber(discount) or 0
    if not isnumber(discount) then return end
    
    local validPly = IsValid(target)
    local sendTo = validPly and target or (isstring(target) and player.GetBySteamID64(target) or nil)
    if IsValid(sendTo) then
        --[[ Just add the table that normally give the sql query ]]
        sendTo.RCD = sendTo.RCD or {}
        sendTo.RCD["vehicleBought"] = sendTo.RCD["vehicleBought"] or {}
        sendTo.RCD["vehicleBought"][vehicleId] = {
            ["customization"] = customization,
            ["groupId"] = vehicleTable["groupId"],
            ["discount"] = discount,
            ["vehicleId"] = vehicleId,
            ["playerId"] = sendTo:SteamID64(),
        }

        local hasColor = IsColor(customization["vehicleColor"])
        local hasUnderglow = IsColor(customization["vehicleUnderglow"])

        local vehicleColor = istable(customization["vehicleColor"]) and Color((customization["vehicleColor"].r or 255), (customization["vehicleColor"].g or 255), (customization["vehicleColor"].b or 255)) or RCD.Colors["white"]
        local vehicleUnderglow = istable(customization["vehicleUnderglow"]) and Color((customization["vehicleUnderglow"].r or 255), (customization["vehicleUnderglow"].g or 255), (customization["vehicleUnderglow"].b or 255)) or RCD.Colors["white"]

        net.Start("RCD:Main:Client")
            net.WriteUInt(3, 4)
            net.WriteUInt(vehicleId, 32)
            net.WriteUInt(vehicleTable["groupId"], 32)
            net.WriteUInt(discount, 32)
            net.WriteString(sendTo:SteamID64())
            net.WriteUInt((customization["vehicleSkin"] or 0), 8)
            net.WriteUInt((customization["vehicleNitro"] or 0), 2)
            net.WriteBool(hasColor)
            net.WriteColor(vehicleColor)
            net.WriteBool(hasUnderglow)
            net.WriteColor(vehicleUnderglow)
            local vehicleBodygroups = customization["vehicleBodygroups"] or {}
            net.WriteUInt(table.Count(vehicleBodygroups), 8)
            for k,v in pairs(vehicleBodygroups) do
                net.WriteUInt(k, 8)
                net.WriteUInt(v, 8)
            end 
        net.Send(sendTo)
    end

    RCD.Query(("INSERT INTO rcd_bought_vehicles (playerId, vehicleId, groupId, customization, discount) VALUES (%s, %s, %s, %s, %s)"):format(RCD.Escape(validPly and target:SteamID64() or target), RCD.Escape(vehicleId), RCD.Escape(vehicleTable["groupId"]), RCD.Escape(util.TableToJSON(customization)), RCD.Escape(discount)))
end

--[[ Remove a vehicle to a steamId or a player ]]
function RCD.RemoveVehicle(target, vehicleId)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    local validPly = IsValid(target)
    RCD.Query(("DELETE FROM rcd_bought_vehicles WHERE playerId = %s AND vehicleId = %s"):format(RCD.Escape(validPly and target:SteamID64() or target), RCD.Escape(vehicleId)), function()
        local sendTo = validPly and target or (isstring(target) and player.GetBySteamID64(target) or nil)
        if IsValid(sendTo) then
            sendTo.RCD = sendTo.RCD or {}
            sendTo.RCD["vehicleBought"] = sendTo.RCD["vehicleBought"] or {}
            sendTo.RCD["vehicleBought"][vehicleId] = nil
    
            net.Start("RCD:Main:Client")
                net.WriteUInt(4, 4)
                net.WriteUInt(vehicleId, 32)
            net.Send(sendTo)
        end
    end)
end

--[[ Sync all vehicle bought of the player ]]
function PLAYER:RCDSyncVehicleBought()
    RCD.Query(("SELECT * FROM rcd_bought_vehicles WHERE playerId = %s"):format(RCD.Escape(self:SteamID64())), function(vehicleTable)
        vehicleTable = vehicleTable or {}
        
        self.RCD = self.RCD or {}
        self.RCD["vehicleBought"] = self.RCD["vehicleBought"] or {}
    
        for k,v in ipairs(vehicleTable) do
            v.vehicleId = tonumber(v.vehicleId)
            v.customization = util.JSONToTable((v.customization or "")) or {}
            v.compatibilitiesOptions = util.JSONToTable((v.compatibilitiesOptions or "")) or {}
    
            self.RCD["vehicleBought"][v.vehicleId] = v
            self.RCD["vehicleBought"][v.vehicleId]["compatibilitiesOptions"] = v.compatibilitiesOptions
        end
    
        local boughVehiclesCompressed = util.Compress(util.TableToJSON(self.RCD["vehicleBought"]))

        net.Start("RCD:Main:Client")
            net.WriteUInt(10, 4)
            net.WriteUInt(#boughVehiclesCompressed, 32)
            net.WriteData(boughVehiclesCompressed, #boughVehiclesCompressed)
        net.Send(self)
    end)
end

--[[ Check if the player has already bought the vehicle ]]
function PLAYER:RCDCheckVehicleBuyed(vehicleId)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    self.RCD = self.RCD or {}
    self.RCD["vehicleBought"] = self.RCD["vehicleBought"] or {}

    return istable(self.RCD["vehicleBought"][vehicleId])
end

--[[ Buy a vehicle ]]
function PLAYER:RCDBuyVehicle(vehicleId)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    local success, vehicleTable = self:RCDCanAccessVehicle(vehicleId)
    if not success then return end

    vehicleTable["price"] = tonumber(vehicleTable["price"])
    if not isnumber(vehicleTable["price"]) then return end

    local canBuy = hook.Run("RCD:CanBuyVehicle", self, vehicleTable)
    if canBuy == false then return false end

    if self:RCDCheckVehicleBuyed(vehicleId) then return false end

    local money = self:RCDGetMoney()
    if (money < vehicleTable["price"]) && not wantBuy then self:RCDNotification(5, RCD.GetSentence("cantAfford")) return false end
    
    self:RCDAddMoney(-vehicleTable["price"])
    self:RCDNotification(5, RCD.GetSentence("buyVehicleText"):format(vehicleTable["name"], RCD.formatMoney(vehicleTable["price"])))
    
    RCD.GiveVehicle(self, vehicleId)

    hook.Run("RCD:BuyVehicle", self, vehicleTable, vehicleId)

    return true, vehicleTable
end

--[[ Sell a vehicle ]]
function PLAYER:RCDSellVehicle(vehicleId)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    local success, vehicleTable = self:RCDCanAccessVehicle(vehicleId)
    if not success then return end

    local canSell = hook.Run("RCD:CanSellVehicle", self, vehicleTable)
    if canSell == false then return false end

    local options = vehicleTable["options"] or {}
    if options["cantSell"] then self:RCDNotification(5, RCD.GetSentence("cantSell")) return end

    if not self:RCDCheckVehicleBuyed(vehicleId) then return false end
    if self:RCDGetVehicleWithId(vehicleId) then self:RCDNotification(5, RCD.GetSentence("cantReturnVehicle1")) return false end
    
    RCD.RemoveVehicle(self, vehicleId)

    local sellPrice = self:RCDCalculateSellPrice(RCD.AdvancedConfiguration["vehiclesList"], vehicleId)
    
    self:RCDAddMoney(sellPrice)
    self:RCDNotification(5, RCD.GetSentence("sellVehicleText"):format(vehicleTable["name"], RCD.formatMoney(sellPrice)))

    hook.Run("RCD:SellVehicle", self, vehicleTable, vehicleId)

    return true, vehicleTable
end

--[[ Save all compatibilities options on the vehicle ]]
function PLAYER:RCDUpdateOptionsCompatibilities(ent, vehicleId)
    if not IsValid(ent) then return end

    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    if not istable(self:RCDGetVehicleBought(vehicleId)) then return end

    local compatibilitiesOptions = {}
    for k, v in pairs(RCD.CompatibilitiesOptions) do
        local value = v["get"](ent)

        compatibilitiesOptions[k] = value
    end
    
    self.RCD["vehicleBought"][vehicleId]["compatibilitiesOptions"] = compatibilitiesOptions

    RCD.Query(("UPDATE rcd_bought_vehicles SET compatibilitiesOptions = %s WHERE vehicleId = %s AND playerId = %s"):format(RCD.Escape(util.TableToJSON(compatibilitiesOptions)), RCD.Escape(vehicleId), RCD.Escape(self:SteamID64())))
end

--[[ Set all compatibilities options on the vehicle ]]
function PLAYER:RCDSetOptionsCompatibilities(ent, vehicleId)
    if not IsValid(ent) then return end

    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    if not istable(self:RCDGetVehicleBought(vehicleId)) then return end

    self.RCD["vehicleBought"][vehicleId]["compatibilitiesOptions"] = self.RCD["vehicleBought"][vehicleId]["compatibilitiesOptions"] or {}

    for k,v in pairs(self.RCD["vehicleBought"][vehicleId]["compatibilitiesOptions"]) do
        if not RCD.CompatibilitiesOptions[k] or not RCD.CompatibilitiesOptions[k]["set"] then continue end

        RCD.CompatibilitiesOptions[k]["set"](ent, v)
    end
end

--[[ Add vehicle on the player table to know if it's spawned ]]
function PLAYER:RCDAddVehicleSpawned(vehc)
    if not IsValid(vehc) then return end
    if not isnumber(vehc.RCDUniqueId) then return end

    self.RCD = self.RCD or {}
    self.RCD["vehicleSpawned"] = self.RCD["vehicleSpawned"] or {}
    self.RCD["vehicleSpawned"][vehc.RCDUniqueId] = vehc

    self.RCD["vehicleCount"] = self.RCD["vehicleCount"] or 0
    self.RCD["vehicleCount"] = self.RCD["vehicleCount"] + 1

    vehc:CallOnRemove("rcd_remove_var:"..vehc:EntIndex(), function(ent)
        if not IsValid(self) or not istable(self.RCD) or not IsValid(ent) then return end
        
        self.RCD["vehicleCount"] = self.RCD["vehicleCount"] - 1
        self.RCD["vehicleSpawned"][ent.RCDUniqueId] = nil

        self:RCDSyncVehiclesSpawned()
        self:RCDUpdateOptionsCompatibilities(vehc, ent.RCDUniqueId)
    end)

    self:RCDSyncVehiclesSpawned()
end

--[[ Send all vehicles spawned of the player ]]
function PLAYER:RCDSyncVehiclesSpawned()
    self.RCD = self.RCD or {}
    self.RCD["vehicleSpawned"] = self.RCD["vehicleSpawned"] or {}

    net.Start("RCD:Main:Client")
        net.WriteUInt(8, 4)
        net.WriteUInt(self.RCD["vehicleCount"], 8)
        for k,v in pairs(self.RCD["vehicleSpawned"]) do
            net.WriteUInt(k, 32)
        end
    net.Send(self)
end

--[[ Get the vehicle spawned by the player with his unique id ]]
function PLAYER:RCDGetVehicleWithId(vehicleId)
    self.RCD = self.RCD or {}
    self.RCD["vehicleSpawned"] = self.RCD["vehicleSpawned"] or {}
    if not IsValid(self.RCD["vehicleSpawned"][vehicleId]) then return end

    return self.RCD["vehicleSpawned"][vehicleId]
end

--[[ Get vehicle count of the player ]]
function PLAYER:RCDGetVehicleCount()
    self.RCD = self.RCD or {}

    return self.RCD["vehicleCount"] or 0
end

--[[ Check if the player test a vehicle ]]
function PLAYER:RCDCheckTestVehicle()
    self.RCD = self.RCD or {}

    return IsValid(self.RCD["rcd_test_vehicle"])
end

--[[ Reset vehicle test ]]
function PLAYER:RCDResetTest()
    self.RCD = self.RCD or {}

    --[[ Remove the test vehicle ]]
    if IsValid(self.RCD["rcd_test_vehicle"]) then 
        self.RCD["rcd_test_vehicle"]:Remove()

        self.RCD["rcd_test_vehicle"] = nil
    end

    --[[ Set the old pos of the player and reset variables ]]
    if isvector(self.RCD["rcd_oldpos_test"]) then
        self:ExitVehicle()
        self:SetPos(self.RCD["rcd_oldpos_test"])

        self.RCD["rcd_oldpos_test"] = nil
    end

    if isangle(self.RCD["rcd_oldang_test"]) then
        self:SetEyeAngles(self.RCD["rcd_oldang_test"])

        self.RCD["rcd_oldang_test"] = nil
    end

    net.Start("RCD:Main:Client")
        net.WriteUInt(11, 4)
    net.Send(self)

    if timer.Exists("rcd_test_vehicle:"..self:SteamID64()) then
        timer.Remove("rcd_test_vehicle:"..self:SteamID64())
    end
end

--[[ Start vehicle test ]]
function PLAYER:RCDStartTest(vehc, addon)
    if not IsValid(vehc) then return end
    if timer.Exists("rcd_test_vehicle:"..self:SteamID64()) then return end

    self.RCD = self.RCD or {}
    self.RCD["rcd_oldpos_test"] = self:GetPos()
    self.RCD["rcd_oldang_test"] = self:GetAngles()
    self.RCD["rcd_test_vehicle"] = vehc
    
    local testTime = RCD.GetSetting("testTime", "number")
    timer.Create("rcd_test_vehicle:"..self:SteamID64(), testTime, 1, function()
        if not IsValid(self) then return end

        self:RCDResetTest()
    end)
    
    net.Start("RCD:Main:Client")
        net.WriteUInt(7, 4)
    net.Send(self)

    self:RCDEnterVehicle(vehc, addon)
    self:RCDNotification(5, RCD.GetSentence("testVehicleText"):format(testTime))
end

function PLAYER:RCDCreateVehicle(class, pos, ang, addon, vehicleId, job)
    local vehcInfos = RCD.VehiclesList[class]
    if not istable(vehcInfos) then return end
    
    local vehc
    if addon == "simfphys" then
        local addSpawn = RCD.VehiclesList[class]["SpawnOffset"] or Vector(0,0,0)
        if not job then
            addSpawn = addSpawn + RCD.Constants["vectorSimfphys"]
        end

        vehc = simfphys.SpawnVehicleSimple(class, (pos + addSpawn), ang)
    else
        vehc = ents.Create(vehcInfos["Class"])
        vehc:SetPos(pos)
    end
    if not IsValid(vehc) then return end

    vehc:SetModel(vehcInfos["Model"])
    
    if vehcInfos["KeyValues"] then
        for k,v in pairs(vehcInfos["KeyValues"]) do
            vehc:SetKeyValue(k, v)
        end
    end

    if addon == "simfphys" then
        local addAng = RCD.VehiclesList[class]["SpawnAngleOffset"] or 0     

        vehc:SetAngles(ang + Angle(0, addAng, 0))
    else
        vehc:SetAngles(ang)
        vehc:SetVehicleClass(class)
        vehc:Spawn()
        vehc:Activate()
    end
    
    RCD.SetNWVariable("RCDVehicleId", vehicleId, vehc, true, nil, true)
    vehc.RCDUniqueId = vehicleId
    vehc.RCDOwner = self
    
    vehc.VehicleName = class
    vehc.VehicleScriptName = class
    vehc.VehicleTable = vehcInfos

    vehc:SetCollisionGroup(COLLISION_GROUP_VEHICLE)

    self:RCDSetkeysOwn(vehc)
    vehc:Fire("Lock")

    if not job then
        self:RCDAddVehicleSpawned(vehc)

        timer.Simple(0.5, function()
            if not IsValid(self) or not IsValid(vehc) then return end

            self:RCDSetVehicleParams(vehc, vehicleId)
        end)
    end

    local phys = vehc:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(true)
    end
    
    gamemode.Call("PlayerSpawnedVehicle", self, vehc)    
    hook.Run("RCD:OnSpawnVehicleBought", self, vehc, vehcInfos)

    return vehc
end

function PLAYER:RCDEnterVehicle(vehc, addon)
    if not IsValid(vehc) then return end

    addon = addon or "default"
    
    if addon == "default" then
        if SVMOD && SVMOD:GetAddonState() then
            vehc:SV_EnterVehicle(self)
        else
            self:EnterVehicle(vehc)
        end
    elseif addon == "simfphys" then
        timer.Simple(0.5, function()
            if not IsValid(self) or not IsValid(vehc) then return end

            if IsValid(vehc.DriverSeat) then
                if SVMOD && SVMOD:GetAddonState() then
                    vehc.DriverSeat:SV_EnterVehicle(self)
                else
                    self:EnterVehicle(vehc.DriverSeat)
                end
            end
        end)
    end
end

-- [[ Spawn a vehicle and call some hooks ]] --
function PLAYER:RCDSpawnVehicle(vehicleId, testVehicle)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    if self:RCDIsVehicleSpawned(vehicleId) then self:RCDNotification(5, RCD.GetSentence("vehicleAlreadyExited")) return end

    if self:RCDGetVehicleCount() >= RCD.GetSetting("maxVehicles", "number") then self:RCDNotification(5, RCD.GetSentence("maxVehicleLimitReached")) return end
    if self:RCDCheckTestVehicle() then self:RCDNotification(5, RCD.GetSentence("cantSpawnVehicle2")) return end

    local success, vehicleTable = self:RCDCanAccessVehicle(vehicleId)
    if not success then return end

    local canSpawnVehicle = hook.Run("RCD:CanSpawnVehicle", self, vehicleTable)
    if canSpawnVehicle == false then return end

    local vehicleBuyed = self:RCDCheckVehicleBuyed(vehicleId)
    if (vehicleBuyed && testVehicle) or (not vehicleBuyed && not testVehicle) then return end

    local pos, ang = RCD.FindEmptyPlateforms(self.RCD["ent_used"])
    if not isvector(pos) or not isangle(ang) then self:RCDNotification(5, RCD.GetSentence("noPlaceAvailable")) return end

    local addon = vehicleTable["options"]["addon"] or "default"
    local veh = self:RCDCreateVehicle(vehicleTable["class"], pos, ang, addon, vehicleId)
    
    if testVehicle then
        self:RCDStartTest(veh, addon)
    else
        net.Start("RCD:Main:Client")
            net.WriteUInt(5, 4)
        net.Send(self)
        
        if RCD.GetSetting("enterVehicle", "boolean") then
            self:RCDEnterVehicle(veh, addon)
        end

        self:RCDNotification(5, RCD.GetSentence("vehicleExitedText2"):format(vehicleTable["name"]))
    end
    
    timer.Simple(1, function()
        if not IsValid(self) or not IsValid(veh) then return end
        
        self:RCDSetOptionsCompatibilities(veh, vehicleId)

        if RCD.GetSetting("engineActivate", "boolean") then
            local engineStatus = RCD.GetNWVariables("RCDEngine", veh)
            RCD.SetVehicleEngine(veh, engineStatus)
        end
    end)
end

--[[ Set all params on the vehicle ]]
function PLAYER:RCDSetVehicleParams(vehc, vehicleId)
    if not IsValid(vehc) then return end

    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    local vehicleTable = RCD.GetVehicleInfo(vehicleId)
    if not istable(vehicleTable) then return end

    local options = vehicleTable["options"] or {}

    local vehicleBought = self:RCDGetVehicleBought(vehicleId)
    if not istable(vehicleBought) then return end

    local customization = vehicleBought["customization"] or {}

    if options["canChangeColor"] && istable(customization["vehicleColor"]) then
        vehc:SetColor(customization["vehicleColor"])
    elseif istable(options["defaultColor"]) then
        vehc:SetColor(options["defaultColor"])
    end

    if options["canChangeSkin"] && isnumber(customization["vehicleSkin"]) then
        vehc:SetSkin(customization["vehicleSkin"])
    elseif isnumber(options["skin"]) then
        vehc:SetSkin(options["skin"])
    end

    if options["canChangeUngerglow"] && istable(customization["vehicleUnderglow"]) then
        RCD.GenerateUnderGlow(vehc, customization["vehicleUnderglow"])
    end

    if options["canChangeBodygroup"] && istable(customization["vehicleBodygroups"]) then
        for k,v in pairs(customization["vehicleBodygroups"]) do
            vehc:SetBodygroup(k, v)
        end
    end

    vehc.RCDNitro = customization["vehicleNitro"] or 0
end

--[[ Return around vehicles ]]
function PLAYER:RCDReturnAroundVehicles()
    self.RCD = self.RCD or {}
    if not IsValid(self.RCD["ent_used"]) then return end

    local vehicleDeleted
    for k,v in ipairs(ents.FindInSphere(self.RCD["ent_used"]:GetPos(), math.sqrt(RCD.GetSetting("distToReturn", "number")))) do
        if not IsValid(v) or not RCD.IsVehicle(v) then continue end
        if v.RCDOwner != self then continue end

        v:Remove()
        vehicleDeleted = true
    end

    self:RCDNotification(5, vehicleDeleted and RCD.GetSentence("returnAroundVehicles") or RCD.GetSentence("noVehiclesAround"))
end

--[[ Return the vehicle ]]
function PLAYER:RCDReturnVehicle(vehicleId)
    vehicleId = tonumber(vehicleId)
    if not isnumber(vehicleId) then return end

    self.RCD = self.RCD or {}

    local canReturn = hook.Run("RCD:CanReturnVehicle", self, vehicleId)
    if canReturn == false then return end

    local vehc = self:RCDGetVehicleWithId(vehicleId)
    if not IsValid(vehc) then return end

    if not IsValid(self.RCD["ent_used"]) then return end
    if vehc:GetPos():DistToSqr(self.RCD["ent_used"]:GetPos()) > RCD.GetSetting("distToReturn", "number") then self:RCDNotification(5, RCD.GetSentence("vehicleTooFarText")) return end

    vehc:Remove()
    self:RCDNotification(5, RCD.GetSentence("vehicleReturned2"))
end

--[[ Open the car dealer menu ]]
function PLAYER:RCDOpenCarDealer(npc)
    if not IsValid(npc) then return end

    self.RCD = self.RCD or {}

    local canOpen = hook.Run("RCD:CanOpenCarDealer", self, npc)
    if canOpen == false then return end

    local settingsTable = npc.SettingsTable or {}
    local groupsList = settingsTable["groups"] or {}

    self.RCD["ent_used"] = npc

    net.Start("RCD:Main:Client")
        net.WriteUInt(2, 4)
        net.WriteUInt(table.Count(groupsList), 12)
        for k,v in pairs(groupsList) do
            net.WriteUInt(k, 32)
        end
    net.Send(self)

    return true
end

--[[ conCommand to give a vehicle to a player ]]
concommand.Add("rcd_give_vehicle", function(ply, cmd, args, argsStr)
    if ply == NULL or (IsValid(ply) && RCD.AdminRank[ply:GetUserGroup()]) then
        local argsTable = string.Explode(" ", argsStr) or {}

        local steamId = argsTable[1]
        if not isstring(steamId) then return end

        steamId = string.find(steamId, "STEAM_") and util.SteamIDTo64(steamId) or steamId
        if #steamId != 17 then return end
    
        local vehicleId = argsTable[2]
        RCD.GiveVehicle(steamId, vehicleId)

        print(("[RCD] Vehicle %s gived to %s"):format(vehicleId, steamId))
    
        if IsValid(ply) then 
            ply:RCDNotification(5, RCD.GetSentence("giveVehicle"):format("#"..vehicleId, steamId))
        end
    end
end)

--[[ conCommand to remove a vehicle to a player ]]
concommand.Add("rcd_remove_vehicle", function(ply, cmd, args, argsStr)
    if ply == NULL or (IsValid(ply) && RCD.AdminRank[ply:GetUserGroup()]) then
        local argsTable = string.Explode(" ", argsStr) or {}

        local steamId = argsTable[1]
        if not isstring(steamId) then return end

        steamId = string.find(steamId, "STEAM_") and util.SteamIDTo64(steamId) or steamId
        if #steamId != 17 then return end
    
        local vehicleId = argsTable[2]
        RCD.RemoveVehicle(steamId, vehicleId)

        print(("[RCD] Vehicle %s removed to %s"):format(vehicleId, steamId))
    
        if IsValid(ply) then 
            ply:RCDNotification(5, RCD.GetSentence("giveVehicle"):format("#"..vehicleId, steamId))
        end
    end
end)

--[[ conCommand to reset compatibilities ]]
concommand.Add("rcd_reset_compatibilities", function(ply, cmd, args)
    if ply == NULL or (IsValid(ply) && RCD.AdminRank[ply:GetUserGroup()]) then         
        RCD.Query("DROP TABLE rcd_compatibilities_done")
        RCD.Query("DROP TABLE rcd_bough_compatibilities")
    end
end)