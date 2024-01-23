--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

function Realistic_Properties:Notify(Player, id) 
    net.Start("RealisticProperties:Notify")
    net.WriteString(Realistic_Properties.Lang[id][Realistic_Properties.Language])
    net.Send(Player)
end 

function Realistic_Properties:IsBought(RealisticPropertiesInt, Player) -- If the properties is buy by the player 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    if not isnumber(RealisticPropertiesInt) then return end 

    local RealisticPropertiesIsBought = false 
    if RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwner"] == Player:SteamID64() then 
        RealisticPropertiesIsBought = true  
    end 
    return RealisticPropertiesIsBought 
end 

function Realistic_Properties:IsCoOwner(RealisticPropertiesInt, Player) -- Check if the player is Coowner 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    if not isnumber(RealisticPropertiesInt) then return end 
    
    local PlayerDoorsCoOwned = false 
    for k, coowner in pairs(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"]) do 
        if coowner == Player:SteamID64() then 
            PlayerDoorsCoOwned = true  
        end 
    end 
    return PlayerDoorsCoOwned 
end

function Realistic_Properties:TableOwner(Player) -- table of Owners
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 

    Player.BuyProperties = {}
    for k,v in pairs(RealisticPropertiesTab) do 
        if RealisticPropertiesTab[k]["RealisticPropertiesOwner"] == Player:SteamID64() then 
            if not Player.BuyProperties[k] then 
                Player.BuyProperties[#Player.BuyProperties + 1] = k 
            end 
        end 
    end 
    return Player.BuyProperties 
end 

function Realistic_Properties:TableCoOwner(Player) -- table of CoOwners
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 

    Player.CoOwnerProperties = {}
    for k,v in pairs(RealisticPropertiesTab) do  
        if Realistic_Properties:IsCoOwner(k, Player) then 
            if not Player.CoOwnerProperties[k] then 
                Player.CoOwnerProperties[#Player.CoOwnerProperties + 1] = k 
            end 
        end 
    end 
    return Player.CoOwnerProperties 
end 

function Realistic_Properties:BuyProperties(Player, RealisticPropertiesInt, RealisticPropertiesIntRent, Bool) -- Set data when the player Buy/Rent 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not isnumber(RealisticPropertiesInt) or not isbool(Bool) then return end 
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    if #Realistic_Properties:TableOwner(Player) > Realistic_Properties.MaxProperties then return end 

    if istable(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCantBuyJob"]) then 
        if table.HasValue(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCantBuyJob"], team.GetName(Player:Team())) then Realistic_Properties:Notify(Player, 71) return end 
    end 
    
    if RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] == false then 
        for _, door in pairs(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesDoorId"]) do 
            if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
                if Realistic_Properties.DoorsLock then  
                    ents.GetByIndex(door):Fire("Lock")
                    ents.GetByIndex(door):Fire("Close")
                end 
                ents.GetByIndex(door):keysOwn(Player)
            end 
        end 
        if Bool == true then 
            if Player:getDarkRPVar("money") >= RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesPrice"] then 
                if RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] == false then 
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] = true 
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwner"] = Player:SteamID64()
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwnerName"] = Player:Name()
                    Player:addMoney(-RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesPrice"])
                    Realistic_Properties:Notify(Player, 27)
                else 
                    Realistic_Properties:Notify(Player, 43)
                end 
            else 
                Realistic_Properties:Notify(Player, 50) 
            end 
        elseif Bool == false then 
            if Player:getDarkRPVar("money") >= RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesPrice"] * ( 1 + (RealisticPropertiesIntRent /10)) then  
                if RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] == false then 
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] = true 
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwner"] = Player:SteamID64()
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwnerName"] = Player:Name()
                    RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesLocation"] = os.time() + ((86400 * RealisticPropertiesIntRent) * Realistic_Properties.DayEqual) 
                    Player:addMoney(-RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesPrice"] * ( 1 + (RealisticPropertiesIntRent / 10)))
                    Realistic_Properties:Notify(Player, 28) 
                else 
                    Realistic_Properties:Notify(Player, 43)
                end 
            else 
                Realistic_Properties:Notify(Player, 50) 
            end 
        end 
        file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))

        local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
        local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

        local CompressTable = util.Compress(RealisticPropertiesFil)
        net.Start("RealisticProperties:SendTable")
            net.WriteInt(CompressTable:len(), 32)
		    net.WriteData( CompressTable, CompressTable:len() )
        net.Broadcast()
    end 
end 

function Realistic_Properties:SellProperties(RealisticPropertiesInt, Player) -- Reset value of the data when the player sell property 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    
    if Realistic_Properties:IsBought(RealisticPropertiesInt, Player)  then 
        if not isnumber(RealisticPropertiesInt) then return end 
        if not IsValid(Player) or not Player:IsPlayer() then return end

        for _, door in pairs(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesDoorId"]) do 
            if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
                if Realistic_Properties.DoorsLock then  
                    ents.GetByIndex(door):Fire("Lock")
                    ents.GetByIndex(door):Fire("Close")
                end 
                ents.GetByIndex(door):keysUnOwn(Player)
            end 
        end 
        RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] = false 
        RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwner"] = ""
        RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesOwnerName"] = ""
        RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesLocation"] = 0.0
        RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"] = {}
        RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesEnts"] = {}
        Player:addMoney((RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesPrice"] * Realistic_Properties.Sell)/100)
        file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))
    end 
end 

function Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, amountent, String) 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    ply.RealisticPropertiesBoxCount = 0 
    if not Realistic_Properties.DeliverySystem then return end 
    if not Realistic_Properties.BuyEntitiesWithoutProperties[team.GetName(ply:Team())] then 
        if not Realistic_Properties.PropertiesDelivery then 
            if istable(enttbl) then
                if #Realistic_Properties:TableOwner(ply) == 0 && #Realistic_Properties:TableCoOwner(ply) == 0 then 
                    ply:addMoney(price)
                    ent:Remove()
                    Realistic_Properties:Notify(ply, 38)  
                end 
            end  
        end 
        if #Realistic_Properties:TableOwner(ply) <= 0 && #Realistic_Properties:TableCoOwner(ply) <= 0 then return end 

        for k,v in pairs(ents.FindByClass("realistic_properties_box")) do 
            if v.Owner == ply then 
                ply.RealisticPropertiesBoxCount =  ply.RealisticPropertiesBoxCount + 1 
            end 
        end 

        if not istable(ply.RealisticPropertiesTable) then 
            ply.RealisticPropertiesTable = {}
        end 
        
        if ply.RealisticPropertiesBoxCount >= Realistic_Properties.Package then 
            if IsValid(ent) then 
                Realistic_Properties:Notify(ply, 39)
                ent:Remove()
                ply:addMoney(price)
            end
            return 
        end 

        local ent = ""
        if isstring(enttbl["ent"]) then 
            ent = enttbl["ent"]
        else 
            ent = enttbl["entity"]
        end 

        local EntModel = enttbl["model"] 
        if String == "shipment" then 
            EntModel = "models/Items/item_item_crate.mdl"
        end 

        table.insert(ply.RealisticPropertiesTable,{ 
            RealisticPropertiesEnt = ent,
            RealisticPropertiesEntModel = EntModel,
            RealisticPropertiesEntMax = enttbl["max"],
            RealisticPropertiesEntPrice = enttbl["price"],
            RealisticPropertiesEntAmount = amountent,  
            RealisticPropertiesEntString =  String, 
        })

        local RealisticPropertiesOwnerCoOwner = Realistic_Properties:TableCoOwner(ply)
        for k,v in pairs(Realistic_Properties:TableOwner(ply)) do 
            table.insert(RealisticPropertiesOwnerCoOwner, v)
        end 

        local CompressTable = util.Compress(RealisticPropertiesFil)
        net.Start("RealisticProperties:DeliveryMenu")
            net.WriteInt(CompressTable:len(), 32)
            net.WriteData( CompressTable, CompressTable:len() )
            net.WriteTable(ply.RealisticPropertiesTable)
            net.WriteTable(RealisticPropertiesOwnerCoOwner)
        net.Send(ply)
    end
end 

function Realistic_Properties:CreateEntityDelivery(RealisticPropertiesInt, Player, Bool, RealisticPropertiesEntity) -- Create the Ents Box for the delivery system 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    if Realistic_Properties:IsBought(RealisticPropertiesInt, Player) == false && Realistic_Properties:IsCoOwner(RealisticPropertiesInt, Player) == false then return end 
    local RealisticPropertiesEntityCrate = RealisticPropertiesEntity
    if IsValid(RealisticPropertiesEntity) then RealisticPropertiesEntity:Remove() end 
    local StringInfo = ""
    if Bool == true then 
        RPSent = "realistic_properties_box"
        RPSmodel = "models/Items/item_item_crate.mdl"
        RPSpos = RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesDelivery"] + Vector(0,0,80) 
        StringInfo = Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEntString"]
    else 
        RPSent = RealisticPropertiesEntityCrate.Table["RealisticPropertiesEnt"]
        RPSmodel = RealisticPropertiesEntityCrate.Table["RealisticPropertiesEntModel"]
        RPSpos = Player:GetEyeTrace().HitPos + Vector(0,0,10) 
        StringInfo = RealisticPropertiesEntityCrate.Table["RealisticPropertiesEntString"]
    end

    if Bool then  
        RealisticPropertiesEnt = ents.Create( RPSent ) -- Spawn the box 
        RealisticPropertiesEnt:SetModel( RPSmodel )
        RealisticPropertiesEnt:SetPos( RPSpos ) 
        RealisticPropertiesEnt:CPPISetOwner(Player)
        RealisticPropertiesEnt:Spawn() 
        local RealisticPropertiesPhys = RealisticPropertiesEnt:GetPhysicsObject()
        RealisticPropertiesPhys:EnableMotion(true)
        RealisticPropertiesPhys:EnableGravity(true)
        RealisticPropertiesPhys:Wake()
        RealisticPropertiesEnt.Owner = Player
        RealisticPropertiesEnt.Table = {
            RealisticPropertiesEntModel = Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEntModel"],
            RealisticPropertiesEnt = Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEnt"],
            RealisticPropertiesEntMax = Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEntMax"],
            RealisticPropertiesEntPrice = Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEntPrice"],
            RealisticPropertiesEntAmount = Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEntAmount"], 
            RealisticPropertiesEntString = StringInfo, 
        }
        
        Player.RealisticPropertiesBoxCount = 0 
        for k,v in pairs(ents.FindByClass("realistic_properties_box")) do  
            if v.Owner == Player then 
                Player.RealisticPropertiesBoxCount =  Player.RealisticPropertiesBoxCount + 1 
            end 
        end 
        if Player.RealisticPropertiesBoxCount > Realistic_Properties.Package then 
            if IsValid(RealisticPropertiesEnt) then 
                Realistic_Properties:Notify(Player, 39)
                RealisticPropertiesEnt:Remove()
                Player:addMoney(Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]["RealisticPropertiesEntPrice"])
            end
        else 
            Realistic_Properties:Notify(Player, 37)
        end
        table.RemoveByValue(Player.RealisticPropertiesTable, Player.RealisticPropertiesTable[table.GetFirstKey(Player.RealisticPropertiesTable)]) 
    else 
        if StringInfo == "pistol" or StringInfo == "ent" then 
            if RPSent == "zmlab_frezzer" or RPSent == "zmlab_filter" then 
                RealisticPropertiesEntityCrate = ents.Create( RPSent )
                RealisticPropertiesEntityCrate:SpawnFunction(Player, Player:GetEyeTrace())
            else 
                RealisticPropertiesEntityCrate = ents.Create( RPSent ) -- Spawn Ent 
                RealisticPropertiesEntityCrate:SetModel( RPSmodel )
                RealisticPropertiesEntityCrate:SetPos( RPSpos ) 
                RealisticPropertiesEntityCrate:Spawn()
                if IsValid(RealisticPropertiesEntityCrate:CPPIGetOwner()) then 
                    RealisticPropertiesEntityCrate:CPPISetOwner( RealisticPropertiesEntityCrate:CPPIGetOwner() )
                end 
                if Realistic_Properties.EntityCompatibility[RPSent] then 
                    RealisticPropertiesEntityCrate:Setowning_ent(Player)
                end 
                local RealisticPropertiesPhys = RealisticPropertiesEntityCrate:GetPhysicsObject()
                RealisticPropertiesPhys:EnableMotion(true)
                RealisticPropertiesPhys:EnableGravity(true)
                RealisticPropertiesPhys:Wake()
                if RPSent == "oneprint" then 
                    RealisticPropertiesEntityCrate:SetOwnerObject(Player)
                end 
                if RPSent == "prop_physics" then 
                    RealisticPropertiesEntityCrate.RPTProps = true 
                    undo.Create("prop")
                        undo.AddEntity(RealisticPropertiesEntityCrate)
                        undo.SetPlayer(Player)
                    undo.Finish()
                end 
            end 
        elseif StringInfo == "shipment" then 
            local shipID
            for k, v in pairs(CustomShipments) do
                if v.entity == RPSent then
                    shipID = k
                    break
                end
            end
            RealisticPropertiesCrate = ents.Create(CustomShipments[shipID].shipmentClass or "spawned_shipment") -- Spawn Shipment 
            RealisticPropertiesCrate.SID = Player.SID
            RealisticPropertiesCrate:SetPos( RPSpos )
            RealisticPropertiesCrate.nodupe = true
            RealisticPropertiesCrate:SetContents(shipID, RealisticPropertiesEntityCrate.Table["RealisticPropertiesEntAmount"])
            RealisticPropertiesCrate:Spawn()
            RealisticPropertiesCrate:SetPlayer(Player)
        end  
    end 
end 

function Realistic_Properties:AddRemoveCoOwner(bool, Player, RealisticPropertiesInt) -- Add / Remove CoOwner
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    if not isbool(bool) or not isnumber(RealisticPropertiesInt) then return end 

    if bool == true then  
        local RealisticPropertiesCoOwner = {}
        if not table.HasValue(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"], Player:SteamID64()) then 
            local TableCoOwner = RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"]
            TableCoOwner[#TableCoOwner + 1] = Player:SteamID64()
        end 
        for k,v in pairs(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesDoorId"]) do 
            if IsValid(ents.GetByIndex(v)) && IsEntity(ents.GetByIndex(v)) then 
                ents.GetByIndex(v):addKeysDoorOwner(Player)
            end 
        end 
    end 
    if bool == false then 
        if #RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"] > 0 then 
            if table.HasValue(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"], Player:SteamID64()) then 
                table.RemoveByValue(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesCoOwner"], Player:SteamID64())
            end 
        end 
        for k,v in pairs(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesDoorId"]) do 
            if IsValid(ents.GetByIndex(v)) && IsEntity(ents.GetByIndex(v)) then 
                ents.GetByIndex(v):removeKeysDoorOwner(Player)
            end 
        end 
    end 
    file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))
end

function Realistic_Properties:ReloadOwnerCoOwner(Player) -- Reload Owner And CoOwner 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 

    for k,v in pairs(RealisticPropertiesTab) do 
        if Realistic_Properties:IsBought(k, Player) then 
            for _, door in pairs(RealisticPropertiesTab[k]["RealisticPropertiesDoorId"]) do 
                if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
                    ents.GetByIndex(door):keysOwn(Player)
                end 
            end 
        end 
        for _, coowner in pairs(RealisticPropertiesTab[k]["RealisticPropertiesCoOwner"]) do 
            if coowner == Player:SteamID64() then
                for _, door in pairs(RealisticPropertiesTab[k]["RealisticPropertiesDoorId"]) do 
                    if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then  
                        ents.GetByIndex(door):addKeysDoorOwner(Player)
                    end 
                end  
            end 
        end 
    end  
end 

function Realistic_Properties:RemoveAllPropertiesOwner() -- Remove all owner when the server shutdown if rent is false 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

    for k,v in pairs(RealisticPropertiesTab) do 
        if RealisticPropertiesTab[k]["RealisticPropertiesLocation"] == 0 && RealisticPropertiesTab[k]["RealisticPropertiesBuy"] == true then 
            RealisticPropertiesTab[k]["RealisticPropertiesBuy"] = false 
            RealisticPropertiesTab[k]["RealisticPropertiesOwner"] = ""
            RealisticPropertiesTab[k]["RealisticPropertiesOwnerName"] = ""
            RealisticPropertiesTab[k]["RealisticPropertiesCoOwner"] = {}
            file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))
        end 
    end 
end 

function Realistic_Properties:DeleteEntProps(RealisticPropertiesInt, Player) -- Delete Ents When the player disconnect or sell the property
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    if not isnumber(RealisticPropertiesInt) then return end 
    if not Realistic_Properties.EntitiesRemove then return end 

    for _,ent in pairs(ents.FindInBox(RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesboxMins"], RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesboxMax"])) do 
        if ent:GetClass() != "func_door_rotating" && ent:GetClass() != "prop_door_rotating" && ent:GetClass() != "func_door" then 
            if ent:GetOwner() != nil && ent:CPPIGetOwner() != nil then 
                ent:Remove()
            end 
        end 
    end 
end 

function Realistic_Properties:PlayerIsOnTheProperty(Player) -- Check if the player is on his property
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    if not IsValid(Player) or not Player:IsPlayer() then return end 
    local PlayerIsOnHisProperty = false 
    for k,v in pairs(RealisticPropertiesTab) do 
        local min = v.RealisticPropertiesboxMins - Vector( 0, 0, 90)
        local max = v.RealisticPropertiesboxMax
        if min.z > max.z then
            valeur = max
            valeur2 = min
        else 
            valeur = min
            valeur2 = max
        end 
        if Player:GetEyeTrace().HitPos:WithinAABox( valeur, valeur2 ) then 
            if Realistic_Properties:IsBought(k, Player) or Realistic_Properties:IsCoOwner(k, Player) then 
                PlayerIsOnHisProperty = true 
                break 
            end  
        end 
    end  
    return PlayerIsOnHisProperty 
end  

function Realistic_Properties:RefreshProperties(RpsID) -- Refresh properties information for the DoorHUD
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {} 
    
    if istable(RealisticPropertiesTab[RpsID]["RealisticPropertiesDoorId"]) then 
        for _, door in pairs(RealisticPropertiesTab[RpsID]["RealisticPropertiesDoorId"]) do 
            if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
                if not istable(RealisticPropertiesTab[RpsID]["RealisticPropertiesBlacklist"]) then 
                    RealisticPropertiesTab[RpsID]["RealisticPropertiesBlacklist"] = {}
                end 
                if not table.HasValue(RealisticPropertiesTab[RpsID]["RealisticPropertiesBlacklist"], tostring(ents.GetByIndex(door):MapCreationID()) ) then 
                    ents.GetByIndex(door):SetNWString( "PropertiesName",  RealisticPropertiesTab[RpsID]["RealisticPropertiesName"])
                    if RealisticPropertiesTab[RpsID]["RealisticPropertiesBuy"] == true then 
                        ents.GetByIndex(door):SetNWBool("PropertiesBuy", true)
                        ents.GetByIndex(door):SetNWString("PropertiesOwner",  RealisticPropertiesTab[RpsID]["RealisticPropertiesOwnerName"])
                    else
                        ents.GetByIndex(door):SetNWBool("PropertiesBuy", false)
                        ents.GetByIndex(door):SetNWString("PropertiesOwner",  "")
                    end  
                else 
                    ents.GetByIndex(door):SetNWString( "PropertiesName",  "disable")
                end 
            end  
        end 
    end 
end 

function Realistic_Properties:DebugDoors()
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    
    for k,v in pairs(RealisticPropertiesTab) do 
        RealisticPropertiesTab[k]["RealisticPropertiesDoorId"] = {}
        for _, door in pairs(ents.FindInBox(RealisticPropertiesTab[k]["RealisticPropertiesboxMax"], RealisticPropertiesTab[k]["RealisticPropertiesboxMins"])) do 
            if door:GetClass() == "func_door_rotating" or door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door" then 
                if not table.HasValue(RealisticPropertiesTab[k]["RealisticPropertiesDoorId"], door:EntIndex()) then 
                    RealisticPropertiesTab[k]["RealisticPropertiesDoorId"][#RealisticPropertiesTab[k]["RealisticPropertiesDoorId"] + 1] = door:EntIndex()
                end 
                if Realistic_Properties.DoorsLock then  
                    door:Fire("Lock")
                    door:Fire("Close")
                end 
            end 
        end 
    end
    file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))
end 

function Realistic_Properties:SaveEnts(Player, id)
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

    if not file.Exists("realistic_properties/"..Player:SteamID64(), "DATA")  then 
        file.CreateDir("realistic_properties/"..Player:SteamID64())
    end 

    local RealisticPropertiesFil2 = file.Read("realistic_properties/"..Player:SteamID64().."/props_save.txt", "DATA") or ""
    local RealisticPropertiesTab2 = util.JSONToTable(RealisticPropertiesFil2) or {}

    EntsSave = {}
    if Realistic_Properties:IsBought(id, Player) then 
        if RealisticPropertiesTab[id]["RealisticPropertiesBuy"] == true && RealisticPropertiesTab[id]["RealisticPropertiesLocationId"] == 1.0 then 
            for k,v in pairs(ents.FindInBox(RealisticPropertiesTab[id]["RealisticPropertiesboxMins"], RealisticPropertiesTab[id]["RealisticPropertiesboxMax"])) do 
                if v:GetOwner() == Player or v:CPPIGetOwner() == Player then 
                    if not v:IsPlayer() && not v:IsWeapon() then 
                        if v:GetClass() == "prop_physics" then 
                            if v:GetOwner() == Player or v:CPPIGetOwner() == Player then 
                                EntsSave[#EntsSave+1] = {
                                    ModelEnt = v:GetModel(), 
                                    ClassEnt = v:GetClass(), 
                                    PosEnt = v:GetPos(),
                                    AngleEnt = v:GetAngles(),
                                    OwnerEnt = Player:SteamID64(),
                                    MaterialEnt = v:GetMaterial(), 
                                    ColorEnt = v:GetColor(), 
                                }
                            end 
                        end 
                    end 
                end 
                if IsValid(v) && IsEntity(v) then 
                    if v:GetOwner() == Player or v:CPPIGetOwner() == Player then 
                        v:Remove()
                    end 
                end 
            end 
            RealisticPropertiesTab2[RealisticPropertiesTab[id]["RealisticPropertiesName"]] = EntsSave
            file.Write("realistic_properties/"..Player:SteamID64().."/props_save.txt", util.TableToJSON(RealisticPropertiesTab2))
        end 
    end 
end 
 
function Realistic_Properties:LoadEnts(Player, id)
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

    local RealisticPropertiesFil2 = file.Read("realistic_properties/"..Player:SteamID64().."/props_save.txt", "DATA") or ""
    local RealisticPropertiesTab2 = util.JSONToTable(RealisticPropertiesFil2) or {}

    if Realistic_Properties:IsBought(id, Player) then 
        if RealisticPropertiesTab[id]["RealisticPropertiesBuy"] == true && RealisticPropertiesTab[id]["RealisticPropertiesLocationId"] == 1.0 then 
            if not istable(RealisticPropertiesTab2[RealisticPropertiesTab[id]["RealisticPropertiesName"]]) then return end 
            for k, v in pairs(RealisticPropertiesTab2[RealisticPropertiesTab[id]["RealisticPropertiesName"]]) do
                RPSProps = ents.Create("prop_physics")
                RPSProps:SetModel(v.ModelEnt)
                RPSProps:SetPos(Vector(v.PosEnt)) 
                RPSProps:SetAngles(Angle(v.AngleEnt))
                RPSProps:SetSolid(SOLID_VPHYSICS)
                RPSProps:PhysicsInit(SOLID_VPHYSICS)
                RPSProps:SetMaterial(v.MaterialEnt)
                RPSProps:SetColor(v.ColorEnt)
                RPSProps:GetPhysicsObject():EnableMotion(false)
                RPSProps:CPPISetOwner( Player )
                if ( IsValid( Player ) ) then
                    undo.Create( "Prop" )
                        undo.SetPlayer( Player )
                        undo.AddEntity( RPSProps )
                    undo.Finish( "Prop (" .. tostring( v ) .. ")" )
                end
            end 
            if file.Exists("realistic_properties/"..Player:SteamID64().."/props_save.txt", "DATA") then 
                file.Delete("realistic_properties/"..Player:SteamID64().."/props_save.txt")
            end 
        end 
    end 
end 