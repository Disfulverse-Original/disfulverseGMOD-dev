--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]
util.AddNetworkString("RealisticProperties:Halos")
util.AddNetworkString("RealisticProperties:SendTableTool")
util.AddNetworkString("RealisticProperties:SendTable")
util.AddNetworkString("RealisticProperties:TableDoors")
util.AddNetworkString("RealisticProperties:PropertiesAdd")
util.AddNetworkString("RealisticProperties:PropertiesRemove")
util.AddNetworkString("RealisticProperties:BuySellProperties")
util.AddNetworkString("RealisticProperties:DeliveryMenu")
util.AddNetworkString("RealisticProperties:DeliveryEnt")
util.AddNetworkString("RealisticProperties:Notify")
util.AddNetworkString("RealisticProperties:ModificationNpc")

net.Receive("RealisticProperties:ModificationNpc", function(len,ply) -- Modify the Npc/Computer list 
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {} 
    local RealisticPropertiesTable = net.ReadTable() or {} 
    local RealisticPropertiesEntTableEnt = {}
    local RealisticPropertiesEnt = net.ReadEntity() 

    for k,v in pairs(RealisticPropertiesTab) do 
        if table.HasValue(RealisticPropertiesTable, v.RealisticPropertiesName) then 
            RealisticPropertiesEntTableEnt[#RealisticPropertiesEntTableEnt + 1] = RealisticPropertiesTab[k]["RealisticPropertiesName"] 
        end 
    end 
    RealisticPropertiesEnt.TableEnt = RealisticPropertiesEntTableEnt 
    Realistic_Properties.SaveEntity()
end ) 

net.Receive("RealisticProperties:PropertiesAdd", function(len, ply) -- Add properties in the data 
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 

    local RealisticPropertiesTable = net.ReadTable() or {}
    local RealisticPropertiesTableBlacklist = net.ReadTable() or {}
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

    if not file.Exists("realistic_properties", "DATA") then
		file.CreateDir("realistic_properties")
	end
    if not file.Exists("realistic_properties/"..game.GetMap(), "DATA") then
		file.CreateDir("realistic_properties/"..game.GetMap())
	end

    if not isstring(RealisticPropertiesTable["RealisticPropertiesName"]) or not isnumber(RealisticPropertiesTable["RealisticPropertiesPrice"]) then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 
    if not isnumber(RealisticPropertiesTable["RealisticPropertiesPrice"]) then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 
    if not isstring(RealisticPropertiesTable["RealisticPropertiesType"]) then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 
    if RealisticPropertiesTable["RealisticPropertiesPrice"] <= 0 or RealisticPropertiesTable["RealisticPropertiesPrice"] >= 999999999 then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 
    if string.len(string.Trim(RealisticPropertiesTable["RealisticPropertiesName"])) < 3 then 
        if string.len(string.Trim(RealisticPropertiesTable["RealisticPropertiesName"])) > 20 then
            Realistic_Properties:Notify(ply, 64) 
            return 
        end 
    end  
    if not isvector(RealisticPropertiesTable["RealisticPropertiesboxMax"]) or not isvector(RealisticPropertiesTable["RealisticPropertiesboxMins"]) or not isvector(RealisticPropertiesTable["RealisticPropertiesDelivery"]) then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 
    if not istable(RealisticPropertiesTable["RealisticPropertiesCam"]) then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 
    if not istable(RealisticPropertiesTable["RealisticPropertiesDoorId"]) then 
        Realistic_Properties:Notify(ply, 64) 
        return 
    end 

    RealisticPropertiesTable["RealisticPropertiesDoorId"] = {}
    for k,v in pairs(ents.FindInBox(RealisticPropertiesTable["RealisticPropertiesboxMins"], RealisticPropertiesTable["RealisticPropertiesboxMax"])) do 
        if v:GetClass() == "func_door_rotating" or v:GetClass() == "prop_door_rotating" or v:GetClass() == "func_door" then 
            table.insert(RealisticPropertiesTable["RealisticPropertiesDoorId"], v:EntIndex()) 
        end  
    end  

    table.insert(RealisticPropertiesTab, RealisticPropertiesTable)

    for _, door in pairs(RealisticPropertiesTable["RealisticPropertiesDoorId"]) do 
        if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
            if Realistic_Properties.DoorsLock then 
                ents.GetByIndex(door):Fire("Close") 
                ents.GetByIndex(door):Fire("Lock")
            end 
            ents.GetByIndex(door):keysUnOwn(ply)
        end 
    end 

    file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    Realistic_Properties:Notify(ply, 48) 
    
    local CompressTable = util.Compress(RealisticPropertiesFil)
    for k,v in pairs(player.GetAll()) do 
        if Realistic_Properties.AdminRank[v:GetUserGroup()] then
            net.Start("RealisticProperties:SendTableTool")
                net.WriteInt(CompressTable:len(), 32)
		        net.WriteData( CompressTable, CompressTable:len() )
            net.Send(v)
        end 
    end 

    timer.Simple(1,function()
        local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
        local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
        for k,v in pairs(RealisticPropertiesTab) do 
            Realistic_Properties:RefreshProperties(k)
        end 
    end ) 
end )

net.Receive("RealisticProperties:PropertiesRemove", function(len, ply) -- Remove property from data
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
    local RealisticPropertiesId = net.ReadUInt(32)
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
 
    for _, door in pairs(RealisticPropertiesTab[RealisticPropertiesId]["RealisticPropertiesDoorId"]) do 
        if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
            if Realistic_Properties.DoorsLock then 
                ents.GetByIndex(door):Fire("Close")
                ents.GetByIndex(door):Fire("Lock")
            end 
            ents.GetByIndex(door):keysUnOwn(ply)
            ents.GetByIndex(door):SetNWBool("PropertiesBuy", nil)
            ents.GetByIndex(door):SetNWString( "PropertiesName", "")
        end 
    end

    Realistic_Properties:DeleteEntProps(RealisticPropertiesId, ply)
    table.RemoveByValue(RealisticPropertiesTab, RealisticPropertiesTab[RealisticPropertiesId])
    
    table.sort(RealisticPropertiesTab, function(a, b) return string.lower(b["RealisticPropertiesName"]) > string.lower(a["RealisticPropertiesName"]) end)
    file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab))

    Realistic_Properties:Notify(ply, 49) 

    local CompressTable = util.Compress(RealisticPropertiesFil)
    for k,v in pairs(player.GetAll()) do 
        if Realistic_Properties.AdminRank[v:GetUserGroup()] then
            net.Start("RealisticProperties:SendTableTool")
                net.WriteInt(CompressTable:len(), 32)
		        net.WriteData( CompressTable, CompressTable:len() )
            net.Send(v)
        end 
    end 
end )

local RealisticPropertiesTable = { -- Table Buy , Sell , Rent , AddOwner , RemoveOwner 
    ["BuyProperties"] = function(ply)
        local RealisticPropertiesInt = net.ReadUInt(32) 
        Realistic_Properties:BuyProperties(ply, RealisticPropertiesInt, nil, true)  
        Realistic_Properties:RefreshProperties(RealisticPropertiesInt)
    end,
    ["RentProperties"] = function(ply)
        local RealisticPropertiesInt = net.ReadUInt(32) 
        local RealisticPropertiesIntRent = net.ReadUInt(32)
        Realistic_Properties:BuyProperties(ply, RealisticPropertiesInt, RealisticPropertiesIntRent, false)
        Realistic_Properties:RefreshProperties(RealisticPropertiesInt)
    end,
    ["SellProperties"] = function(ply)
        local RealisticPropertiesInt = net.ReadUInt(32) 
        if Realistic_Properties:IsBought(RealisticPropertiesInt, ply)  then 
            Realistic_Properties:Notify(ply, 40)
            Realistic_Properties:DeleteEntProps(RealisticPropertiesInt, ply)
            Realistic_Properties:SellProperties(RealisticPropertiesInt, ply)
            Realistic_Properties:RefreshProperties(RealisticPropertiesInt)
        end
    end,
    ["AddOwner"] = function(ply)
        local RealisticPropertiesNameOwner = net.ReadEntity()
        local RealisticPropertiesInt = net.ReadUInt(32)
        if not isentity(RealisticPropertiesNameOwner) then return end 
        if not isnumber(RealisticPropertiesInt) then return end 
        Realistic_Properties:Notify(ply, 69)
        if RealisticPropertiesNameOwner != ply then 
            if Realistic_Properties:IsBought(RealisticPropertiesInt, ply) then 
                Realistic_Properties:AddRemoveCoOwner(true, RealisticPropertiesNameOwner, RealisticPropertiesInt) 
            end 
        end 
    end,
    ["RemoveOwner"] = function(ply)
        local RealisticPropertiesNameOwner = net.ReadEntity()
        local RealisticPropertiesInt = net.ReadUInt(32)
        if not isentity(RealisticPropertiesNameOwner) then return end 
        if not isnumber(RealisticPropertiesInt) then return end 
        Realistic_Properties:Notify(ply, 70)
        if RealisticPropertiesNameOwner != ply then
            if Realistic_Properties:IsBought(RealisticPropertiesInt, ply) then 
                Realistic_Properties:AddRemoveCoOwner(false, RealisticPropertiesNameOwner, RealisticPropertiesInt)
            end 
        end 
    end
}

net.Receive("RealisticProperties:BuySellProperties", function(len, ply)
    ply.countdownName = ply.countdownName or CurTime()
    if ply.countdownName > CurTime() then return end
    ply.countdownName = CurTime() + 1

    local RealisticPropertiesString = net.ReadString() or ""
    if RealisticPropertiesString != "AddOwner" && RealisticPropertiesString != "RemoveOwner" then 
        ply:SetFOV( 0, 0 ) --Reset FOV
    end 
    if isfunction(RealisticPropertiesTable[RealisticPropertiesString](ply)) then 
        RealisticPropertiesTable[RealisticPropertiesString](ply)
    end  
end )

net.Receive("RealisticProperties:DeliveryMenu", function(len,ply) -- Menu and timer for the delivery system 
    ply.countdownName = ply.countdownName or CurTime()
    if ply.countdownName > CurTime() then return end
    ply.countdownName = CurTime() + 0.1
    
    local RealisticPropertiesInt = net.ReadUInt(32)
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

    if RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesBuy"] then  
        Realistic_Properties:Notify(ply, 36)
        timer.Simple(Realistic_Properties.TimeToDelivery, function()
            if IsValid(ply) && ply:IsPlayer() then 
                local RealisticPropertiesPosBox = RealisticPropertiesTab[RealisticPropertiesInt]["RealisticPropertiesDelivery"] + Vector(0,0,50)
                Realistic_Properties:CreateEntityDelivery(RealisticPropertiesInt, ply, true, nil ) 
            end 
        end )  
    end 
end )

net.Receive("RealisticProperties:DeliveryEnt", function(len,ply) -- Create ent 
    ply.countdownName = ply.countdownName or CurTime()
    if ply.countdownName > CurTime() then return end
    ply.countdownName = CurTime() + 0.1
    
    local RealisticPropertiesEntity = ply.SelectedEntRPS
    if not isentity(RealisticPropertiesEntity) then return end 
    if not istable(RealisticPropertiesEntity.Table) then return end 

    ply.EntityKindPly = {}
    for k,v in pairs(ents.FindByClass(RealisticPropertiesEntity.Table["RealisticPropertiesEnt"])) do 
        if v:GetOwner() == ply or v:CPPIGetOwner() == ply then 
            ply.EntityKindPly[#ply.EntityKindPly + 1] = v   
        end     
    end 

    if isnumber(RealisticPropertiesEntity.Table["RealisticPropertiesEntMax"]) then 
        if #ply.EntityKindPly >= RealisticPropertiesEntity.Table["RealisticPropertiesEntMax"] then 
            if IsEntity(RealisticPropertiesEntity) && IsValid(RealisticPropertiesEntity) then 
                ply:addMoney(RealisticPropertiesEntity.Table["RealisticPropertiesEntPrice"])
                Realistic_Properties:Notify(ply, 9)
                if IsValid(RealisticPropertiesEntity) then RealisticPropertiesEntity:Remove() end 
            end 
        else
            if IsEntity(RealisticPropertiesEntity) then 
                Realistic_Properties:CreateEntityDelivery(nil, ply, false, RealisticPropertiesEntity) 
                if IsValid(RealisticPropertiesEntity) then RealisticPropertiesEntity:Remove() end 
            end 
        end 
    else 
        if RealisticPropertiesEntity.Table["RealisticPropertiesEntAmount"] >= 1 then 
            Realistic_Properties:CreateEntityDelivery(nil, ply, false, RealisticPropertiesEntity) 
            if IsValid(RealisticPropertiesEntity) then RealisticPropertiesEntity:Remove() end 
        end 
    end 
    if IsValid(RealisticPropertiesEntity) then RealisticPropertiesEntity:Remove() end 
end )

net.Receive("RealisticProperties:Halos", function(len,ply) 
    local String = net.ReadString() or ""
    local Ent = net.ReadEntity() 
    ply:SetFOV( 0, 0 ) --Reset FOV 

    if String == "closebox" then 
        Ent:ResetSequence("fermeture")
        Ent:SetSequence("fermeture")
        timer.Simple(1.2, function()
            if IsValid(Ent) then 
                Ent:SetBodygroup(1, 0)
            end 
        end ) 
    end 
end )

