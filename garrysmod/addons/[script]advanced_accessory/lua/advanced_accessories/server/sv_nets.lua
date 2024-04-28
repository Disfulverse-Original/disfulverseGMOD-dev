/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

net.Receive("AAS:Main", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    if not AAS.AdminRank[ply:GetUserGroup()] then return end 
    
    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1

    local UInt = net.ReadUInt(5)

    if UInt == 1 then 
        local tableToSave = net.ReadTable()
        AAS.AddItem(tableToSave, ply)

    elseif UInt == 2 then 
        local uniqueId = net.ReadUInt(32)
        AAS.DeleteItem(uniqueId, ply)
    
    elseif UInt == 3 then 
        local tableToUpdate = net.ReadTable()
        AAS.UpdateItem(tableToUpdate, ply)

    elseif UInt == 4 then
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        
        local tbl = AAS.UnCompressTable(data) or {}

        local donesItemsI, itemsToDo = 0, table.Count(tbl)
        for k,v in pairs(tbl) do
            AAS.AddItem(v, nil, true, nil, nil, function()
                donesItemsI = donesItemsI + 1

                if donesItemsI == itemsToDo then
                    AAS.SendItemInformations()
                end
            end)
        end
    end
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a

net.Receive("AAS:BodyGroups", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1
    
    local checkDistance = ply:AASCheckDistEnt("aas_bodygroup", 150)

    if AAS.BlackListBodyGroup[team.GetName(ply:Team())] then ply:AASNotify(5, AAS.GetSentence("jobProblem")) return end
    if not AAS.OpenBodyGroupWithKey then
        if not checkDistance then ply:AASNotify(5, AAS.GetSentence("exploitArmory")) return end
    end

    if not checkDistance && table.Count(AAS.WhitelistJobToChangeBodyGroup) != 0 && not AAS.WhitelistJobToChangeBodyGroup[team.GetName(ply:Team())] then return end

    local bodyGroupString = net.ReadString()
    local bodyGroupTable = string.Explode(";", bodyGroupString) or {}
    local skinString = net.ReadString()

    local tableToSave = {}
    for k,v in ipairs(bodyGroupTable) do
        local bodyGroupSet = string.Explode(":", v) or {}
        
        local bodygroup, value = (tonumber(bodyGroupSet[1]) or 0), (tonumber(bodyGroupSet[2]) or 0)
        if not isnumber(bodygroup) or not isnumber(value) then continue end

        tableToSave[bodygroup] = value

        ply:SetBodygroup(bodygroup, value)
    end

    ply:SetSkin((skinString or 0))

    ply:AASNotify(5, AAS.GetSentence("saveBodygroup"))
    ply:AASSaveBodygroups(tableToSave)
end)

net.Receive("AAS:Inventory", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */

    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1
    
    local UInt = net.ReadUInt(5)
 
    local checkNpc = (ply:AASCheckDistEnt("aas_npc_shop", 150) or AAS.OpenShopWithKey or AAS.OpenItemMenuCommand)
    
    if AAS.BlackListItemsMenu[team.GetName(ply:Team())] then ply:AASNotify(5, AAS.GetSentence("jobProblem")) return end
    if not AAS.OpenShopWithKey and not AAS.OpenItemMenuCommand and not ply:HasWeapon("aas_item_menu") and not checkNpc then ply:AASNotify(5, AAS.GetSentence("exploitNpc")) return end
    
    if not checkNpc && table.Count(AAS.WhitelistJobToOpenShop) != 0 && not AAS.WhitelistJobToOpenShop[team.GetName(ply:Team())] then return end

    if UInt == 4 then
        local category = net.ReadString()
        ply:AASUnEquipAccessory(category)
    else
        local uniqueId = net.ReadUInt(32)
        if not ply:AASCheckJob(uniqueId) then ply:AASNotify(5, AAS.GetSentence("jobProblem")) return end

        if UInt == 1 then

            if AAS.WeightActivate then
                local max = (not isnumber(AAS.WeightInventory[ply:GetUserGroup()]) and AAS.WeightInventory["all"] or AAS.WeightInventory[ply:GetUserGroup()])
                if table.Count(ply:AASGetInventory()) >= max then ply:AASNotify(5, AAS.GetSentence("toomany")) return end
            end

            ply:AASBuyItem(uniqueId)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
            
        elseif UInt == 2 then
            ply:AASSellItem(uniqueId)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8
            
        elseif UInt == 3 then
            ply.AASWaitItem = ply.AASWaitItem or 0
            if ply.AASWaitItem > CurTime() then ply:AASNotify(5, AAS.GetSentence("waitItem")) return end

            if not checkNpc then
                if ply:HasWeapon("aas_item_menu") then
                    ply.AASWaitItem = CurTime() + AAS.WearTimeAccessory

                    ply:AASNotify(AAS.WearTimeAccessory, AAS.GetSentence("waitEquip"))
                    timer.Create("aas_equip_item", AAS.WearTimeAccessory, 1, function()
                        if not IsValid(ply) or not ply:IsPlayer() then return end

                        ply:AASEquipAccessory(uniqueId)
                    end)
                end
            else
                ply:AASEquipAccessory(uniqueId)
            end
        elseif UInt == 5 then
            if not AAS.ModifyOffset then return end
            
            if not ply:AASIsBought(uniqueId) then ply:AASNotify(5, AAS.GetSentence("notOwned")) return end
            
            local pos = net.ReadVector()
            local ang = net.ReadAngle()
            local scale = net.ReadVector()
            
            ply:AASSaveOffsets(uniqueId, pos, ang, scale, function()
                net.Start("AAS:Inventory")
                    net.WriteUInt(7, 5)
                net.Send(ply)
            end)
        end
    end
end)

local function checkModel(tbl, model)
    for k,v in pairs(tbl) do
        if v == model then 
            return true 
        end
    end
    return false
end

net.Receive("AAS:Models", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1

    local checkDistance = ply:AASCheckDistEnt("aas_model", 150)

    if AAS.BlackListModelsMenu[team.GetName(ply:Team())] then ply:AASNotify(5, AAS.GetSentence("jobProblem")) return end
    if not AAS.OpenModelChangerWithKey and not checkDistance then ply:AASNotify(5, AAS.GetSentence("exploitArmory")) return end

    if not checkDistance && table.Count(AAS.WhitelistJobToChangeModel) != 0 && not AAS.WhitelistJobToChangeModel[team.GetName(ply:Team())] then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

    local model = net.ReadString()

    local checkTable = (AAS.UseDarkRPModel and DarkRP) and RPExtraTeams[ply:Team()].model or AAS.CustomModelTable[team.GetName(ply:Team())]
    if not checkModel(checkTable, model) then return end

    ply:SetModel(model)
    ply:AASLoadBodyGroup()

    ply:AASNotify(5, AAS.GetSentence("equipModel"))
end)
