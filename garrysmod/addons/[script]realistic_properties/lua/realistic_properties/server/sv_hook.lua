--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

hook.Add( "InitPostEntity", "Realistic_Properties:InitPostEntity", function()
    timer.Simple(20, function() -- Initialize property 
        Realistic_Properties:RemoveAllPropertiesOwner()
        Realistic_Properties:DebugDoors() 
        local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
        local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
        for k,v in pairs(RealisticPropertiesTab) do 
            Realistic_Properties:RefreshProperties(k)
        end 
    end )
    timer.Create("Realistic_Properties:Timer", 60, 0, function() -- Check if the rent is finish 
        local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
        local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

        for k,v in pairs(RealisticPropertiesTab) do 
            if RealisticPropertiesTab[k]["RealisticPropertiesLocation"] <= os.time() && RealisticPropertiesTab[k]["RealisticPropertiesLocation"] != 0.0 then 
                for _, door in pairs(RealisticPropertiesTab[k]["RealisticPropertiesDoorId"]) do 
                    if IsValid(ents.GetByIndex(door)) && IsEntity(ents.GetByIndex(door)) then 
                        if Realistic_Properties.DoorsLock then  
                            ents.GetByIndex(door):Fire("Lock")
                            ents.GetByIndex(door):Fire("Close")
                        end 
                        if IsValid( ents.GetByIndex(door):getDoorOwner()) then 
                            ents.GetByIndex(door):keysUnOwn(ents.GetByIndex(door):getDoorOwner())
                        end 
                    end 
                end 
                v.RealisticPropertiesBuy = false 
                v.RealisticPropertiesOwner = ""
                v.RealisticPropertiesOwnerName = ""
                v.RealisticPropertiesLocation = 0.0
                v.RealisticPropertiesCoOwner = {}
                v.RealisticPropertiesEnts = {}
                file.Write("realistic_properties/"..game.GetMap().."/properties.txt", util.TableToJSON(RealisticPropertiesTab, true))
                Realistic_Properties:RefreshProperties(k)
            end  
        end 
    end )
end)

hook.Add("PlayerInitialSpawn","Realistic_Properties:PlayerInitialSpawn", function(ply) -- Reload CoOwner and Owner when the player spawn 
    timer.Simple(10, function()
        Realistic_Properties:ReloadOwnerCoOwner(ply) 
        local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
        local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
        
        if Realistic_Properties.SaveProps then 
            for k,v in pairs(RealisticPropertiesTab) do
                if Realistic_Properties:IsBought(k, ply) or Realistic_Properties:IsCoOwner(k, ply) then 
                    if RealisticPropertiesTab[k]["RealisticPropertiesBuy"] == true && RealisticPropertiesTab[k]["RealisticPropertiesLocationId"] == 1.0 then 
                        Realistic_Properties:LoadEnts(ply, k) 
                    end
                end 
            end
        end 
    end ) 
end)

hook.Add("PlayerDisconnected","Realistic_Properties:PlayerDisconnected", function(ply) -- Delete Props , Sell if the property is not rented and refresh all properties 
	local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
    
    for k,v in pairs(RealisticPropertiesTab) do 
        if Realistic_Properties.SaveProps then 
            if Realistic_Properties:IsBought(k, ply) or Realistic_Properties:IsCoOwner(k, ply) then 
                if RealisticPropertiesTab[k]["RealisticPropertiesBuy"] == true && RealisticPropertiesTab[k]["RealisticPropertiesLocationId"] == 1.0 then 
                    Realistic_Properties:SaveEnts(ply, k)
                end 
            end 
        end 
        if Realistic_Properties:IsBought(k, ply) && RealisticPropertiesTab[k]["RealisticPropertiesLocation"] == 0 then 
            Realistic_Properties:SellProperties(k, ply)
            Realistic_Properties:RefreshProperties(k) 
        end       
    end  
end)

hook.Add("playerBoughtShipment", "Realistic_Properties:Delivery", function(ply, enttbl, ent, price) -- Delivery System when the player buy ent 
    if Realistic_Properties.DeliverySystem then 
        if not Realistic_Properties.BuyEntitiesWithoutProperties[team.GetName(ply:Team())] then 
            if Realistic_Properties.PropertiesDelivery then 
                if #Realistic_Properties:TableOwner(ply) != 0 or #Realistic_Properties:TableCoOwner(ply) != 0 then 
                    Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, enttbl["amount"], "shipment")
                    if IsValid(ent) then ent:Remove() end 
                end 
             else 
                Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, 1, "pistol")
                if IsValid(ent) then ent:Remove() end 
            end 
        end 
    end 
end)

hook.Add("playerBoughtCustomEntity", "Realistic_Properties:Delivery", function(ply, enttbl, ent, price) -- Delivery System when the player buy ent 
    if Realistic_Properties.DeliverySystem then 
        if not Realistic_Properties.BuyEntitiesWithoutProperties[team.GetName(ply:Team())] then 
            if ent:GetClass() != "zpc_pyrostage" && ent:GetClass() != "zpc_pyroworkbench" then 
                if Realistic_Properties.PropertiesDelivery then 
                    if #Realistic_Properties:TableOwner(ply) != 0 or #Realistic_Properties:TableCoOwner(ply) != 0 then 
                        Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, 1, "ent")
                        if IsValid(ent) then ent:Remove() end 
                    end 
                else 
                    Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, 1, "pistol")
                    if IsValid(ent) then ent:Remove() end 
                end 
            end 
        end 
    end 
end)

hook.Add("playerBoughtPistol", "Realistic_Properties:Delivery", function(ply, enttbl, ent, price) -- Delivery System when the player buy ent  
    if Realistic_Properties.DeliverySystem then 
        if not Realistic_Properties.BuyEntitiesWithoutProperties[team.GetName(ply:Team())] then 
            if Realistic_Properties.PropertiesDelivery then 
                if #Realistic_Properties:TableOwner(ply) != 0 or #Realistic_Properties:TableCoOwner(ply) != 0 then 
                    Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, 1, "pistol")
                    if IsValid(ent) then ent:Remove() end 
                end 
            else 
                Realistic_Properties:HookBuyDarkRP(ply, enttbl, ent, price, 1, "pistol")
                if IsValid(ent) then ent:Remove() end 
            end 
        end 
    end 
end)

hook.Add( "PlayerSay", "Realistic_Properties:PlayerSay", function( ply, text, team ) -- Admin Menu for create and modify properties 
    if not Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
    local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
    local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}

	if IsValid(ply) and ply:IsPlayer() then 
        if string.lower( text ) == Realistic_Properties.CommandModification then
            if #RealisticPropertiesTab == 0 then Realistic_Properties:Notify(ply, 47) return end 
            local CompressTable = util.Compress(RealisticPropertiesFil)
            net.Start("RealisticProperties:PropertiesAdd")
                net.WriteTable({})
                net.WriteInt(CompressTable:len(), 32)
                net.WriteData( CompressTable, CompressTable:len() )
            net.Send(ply)
        end
	end 
end )

hook.Add("PostCleanupMap", "Realistic_Properties:CleanUp", function() -- Refresh information after cleanup 
    Realistic_Properties:DebugDoors()
    timer.Simple(1, function()
        local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
        local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
        for k,v in pairs(RealisticPropertiesTab) do 
            Realistic_Properties:RefreshProperties(k)
        end 
        for k,v in pairs(player.GetAll()) do 
            if not IsValid(v) or not v:IsPlayer() then return end 
            Realistic_Properties:ReloadOwnerCoOwner(v)
        end 
    end ) 
end ) 

hook.Add("PlayerSpawnProp","Realistic_Properties:PlayerSpawnProp",function(ply, ent) -- Check if the player can spawn props outside his property
    if not Realistic_Properties.SpawnProps then 
        if not Realistic_Properties.JobCanSpawnProps[team.GetName(ply:Team())] then 
            if not Realistic_Properties:PlayerIsOnTheProperty(ply) then 
                if Realistic_Properties.AdminCanSpawnProps then 
                    if Realistic_Properties.AdminRank[ply:GetUserGroup()] then return end 
                end 
                Realistic_Properties:Notify(ply, 44) 
                return false
            end
        end
    end 
end)

hook.Add( "ShutDown", "Realistic_Properties:SaveShutDown", function() -- Reset property when the server restart 
	Realistic_Properties:RemoveAllPropertiesOwner()
end ) 

local function CheckifdoorHasBool(ent)
    local HaveBool = false 
    if string.len(ent:GetNWString("PropertiesName")) == 0 then 
        HaveBool = false 
    else 
        HaveBool = true 
    end 
    return HaveBool 
end 

hook.Add("playerBuyDoor","Realistic_Properties:playerBuyDoor",function(ply, ent) -- Desactivate Buy Door
    if Realistic_Properties.CanBuyPropertyWithF2 then 
        if isstring(ent:GetNWString("PropertiesName")) && #ent:GetNWString("PropertiesName") > 0 then 
            local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
            local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
            for k,v in pairs(RealisticPropertiesTab) do 
                if v.RealisticPropertiesName == ent:GetNWString("PropertiesName") then 
                    Realistic_Properties:BuyProperties(ply, k, 0, true)
                    Realistic_Properties:RefreshProperties(k)
                    break 
                end 
            end 
        end 
    end 
    if Realistic_Properties.OverridingF2 then 
        if not ent:IsVehicle() && CheckifdoorHasBool(ent) then 
            return false
        end 
    end 
end)

hook.Add("playerSellDoor","Realistic_Properties:playerSellDoor",function(ply, ent) -- Desactivate Sell Door 
    if Realistic_Properties.CanBuyPropertyWithF2 then 
        if isstring(ent:GetNWString("PropertiesName")) && #ent:GetNWString("PropertiesName") > 0 then 
            local RealisticPropertiesFil = file.Read("realistic_properties/"..game.GetMap().."/properties.txt", "DATA") or ""
            local RealisticPropertiesTab = util.JSONToTable(RealisticPropertiesFil) or {}
            for k,v in pairs(RealisticPropertiesTab) do 
                if v.RealisticPropertiesName == ent:GetNWString("PropertiesName") then 
                    Realistic_Properties:SellProperties(k, ply)
                    Realistic_Properties:RefreshProperties(k)
                    break
                end 
            end 
        end 
    end 
    if Realistic_Properties.OverridingF2 then 
        if not ent:IsVehicle() && CheckifdoorHasBool(ent) then 
            return false
        end 
    end 
end)

hook.Add("OnEntityCreated", "Realistic_Properties:OnEntityCreated", function(ent)
	if ( ent:GetClass() == "prop_physics" ) then
        timer.Simple(0, function()
            if Realistic_Properties.PropsDelivery && not ent.RPTProps then 
                if IsValid(ent:CPPIGetOwner()) then 
                    if not Realistic_Properties.JobCanSpawnProps[team.GetName(ent:CPPIGetOwner():Team())] then 
                        local enttbl = {
                            ["ent"] = "prop_physics", 
                            ["max"] = GetConVar("sbox_maxprops"):GetInt(), 
                            ["price"] = Realistic_Properties.PriceProps, 
                            ["model"] = ent:GetModel(), 
                        }
                        Realistic_Properties:HookBuyDarkRP(ent:CPPIGetOwner(), enttbl, ent, Realistic_Properties.PriceProps, GetConVar("sbox_maxprops"):GetInt(), "ent") 
                        ent:CPPIGetOwner():addMoney(-Realistic_Properties.PriceProps)
                        ent:Remove()
                    end 
                end
            end 
        end ) 
	end
end )   