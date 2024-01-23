/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

util.AddNetworkString("AAS:Main")
util.AddNetworkString("AAS:BodyGroups")
util.AddNetworkString("AAS:Inventory")
util.AddNetworkString("AAS:Models")

AAS.Table = AAS.Table or {
    ["items"] = {},
    ["customOffset"] = {},
    ["players"] = {}
}

-- [[ Mysql database connection system ]] --
local mysqlDB
if AAS.Mysql then
    require("mysqloo")
    if not mysqloo then
        return print("[AAS] Cannot require mysqloo module :\n"..requireError)
    end

    mysqlDB = mysqloo.connect(AAS.MysqlInformations["host"], AAS.MysqlInformations["username"], AAS.MysqlInformations["password"], AAS.MysqlInformations["database"], {["port"] = AAS.MysqlInformations["port"]})
    function mysqlDB:onConnected()  
        print("[AAS] Succesfuly connected to the mysql database !")
    end
    
    function mysqlDB:onConnectionFailed(connectionError)
        print("[AAS] Cannot etablish database connection :\n"..connectionError)
    end
    mysqlDB:connect()
end

--[[ SQL Query function ]] --
function AAS.Query(query, callback)
    if not isstring(query) then return end

    local result = {}
    local isInsertQuery = string.StartWith(query, "INSERT")
    if AAS.Mysql then
        query = mysqlDB:query(query)

        function query:onError(q, err, sql)
            print("[AAS] "..err)
        end

        function query:onSuccess(tbl, data)
            if isfunction(callback) then
                callback(isInsertQuery and { lastInsertId = query:lastInsert() } or tbl)
            end
        end
        query:start()
    else

        result = sql.Query(query) or {}
        result = isInsertQuery and { lastInsertId = sql.Query("SELECT last_insert_rowid()")[1]["last_insert_rowid()"] } or result

        if isfunction(callback) then
            callback(result)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

            return
        end
    end

    return (result or {})
end

-- [[ Escape the string ]] --
function AAS.Escape(str)
    return AAS.Mysql and ("'%s'"):format(mysqlDB:escape(tostring(str))) or SQLStr(str)    
end

-- [[ Cache all items in the AAS.Table["items"] table ]] --
function AAS.CacheItems(callback)

    AAS.Query("SELECT * FROM aas_item", function(AASTbl)
        AAS.Table["items"] = {}
        
        for k, item in ipairs(AASTbl) do
            item = AAS.FormatItemTable(item)

            AAS.Table["items"][item.uniqueId] = item
        end
        
        if isfunction(callback) then
            
            callback(AAS.Table["items"])
        end
    end)
end 

--[[ Convert a string to a vector or an angle ]]
local function toVectorOrAngle(toConvert, typeToSet)
    if (typeToSet == Angle and type(toConvert) == "Angle") or (typeToSet == Vector and type(toConvert) == "Vector") then return toConvert end
    if not isstring(toConvert) or (typeToSet != Vector and typeToSet != Angle) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return ((typeToSet == Vector) and Vector(x, y, z) or Angle(x, y, z))
end

--[[ Make sure that all information are correct ]]
function AAS.FormatItemTable(informations, save)
    informations = informations or {}

    informations["name"] = isstring(informations["name"]) and informations["name"] or "Name"
    informations["description"] = isstring(informations["description"]) and informations["description"] or "Description"
    informations["model"] = isstring(informations["model"]) and informations["model"] or "models/props_junk/TrafficCone001a.mdl"

    informations["category"] = (isstring(informations["category"]) and AAS.CheckCategory(informations["category"])) and informations["category"] or "AllItems"
    informations["price"] = isnumber(tonumber(informations["price"])) and tonumber(informations["price"]) or 0
    informations["uniqueId"] = isnumber(tonumber(informations["uniqueId"])) and tonumber(informations["uniqueId"]) or 0

    informations["pos"] = (isvector(informations["pos"]) and save and tostring(informations["pos"])) or (save and "0, 0, 0" or toVectorOrAngle(informations["pos"], Vector))
    informations["scale"] = (isvector(informations["scale"]) and save and tostring(informations["scale"])) or (save and "0, 0, 0" or toVectorOrAngle(informations["scale"], Vector))
    informations["ang"] = (isangle(informations["ang"]) and save and tostring(informations["ang"])) or (save and "0, 0, 0" or toVectorOrAngle(informations["ang"], Angle))

    informations["job"] = istable(informations["job"]) and (save and util.TableToJSON(informations["job"])) or (not save and isstring(informations["job"]) and util.JSONToTable(informations["job"])) or (save and "{}" or {})
    informations["options"] = istable(informations["options"]) and (save and util.TableToJSON(informations["options"])) or (not save and isstring(informations["options"]) and util.JSONToTable(informations["options"])) or (save and "{}" or {})
    
    return informations
end

--[[ Check if the workshop is already loaded ]]
function AAS.WorkshopIsLoaded(workshopId, callback)
    local AASTbl = AAS.Query("SELECT * FROM aas_loaded_workshop WHERE workshopId = '"..workshopId.."'", function(AASTbl)
        callback(istable(AASTbl[1]) and tobool(AASTbl[1]["activate"]) or false)
    end)
end

--[[ Add workshop into the sql database ]]
function AAS.AddWorkshopId(workshopId, activate)
    AAS.Query("SELECT * FROM aas_loaded_workshop WHERE workshopId = '"..workshopId.."'", function(AASTbl)
    
        if not istable(AASTbl) or #AASTbl == 0 then
            AAS.Query(("INSERT INTO aas_loaded_workshop (workshopId, activate) VALUES(%s, %s)"):format(AAS.Escape(workshopId), AAS.Escape(activate)))
        else 
            AAS.Query("UPDATE aas_loaded_workshop SET activate = "..AAS.Escape(activate).." WHERE workshopId = '"..workshopId.."'")
        end
    end)
end

--[[ Check if the item exist into the database ]]
function AAS.ItemExist(model, skin, uniqueId)
    if model then
        itemSkin = tonumber(itemSkin)
        
        for k,v in pairs(AAS.Table["items"]) do
            if v.model == model and (itemSkin == nil and true or tonumber(v.options.skin) == itemSkin) then
                return true, v.uniqueId
            end
        end

        return result, id
    elseif isnumber(tonumber(uniqueId)) then
        return istable(AAS.Table["items"][tonumber(uniqueId)]) 
    end
end

--[[ Save basics items saved into the sh_advanced_config.lua ]]
function AAS.SaveBasicsItems(checkWorkshop)
    for workshopId, bool in pairs(AAS.LoadWorkshop) do
        if not istable(AAS.BaseItems[workshopId]) then continue end
        if not bool then continue end

        AAS.WorkshopIsLoaded(workshopId, function(isLoaded)
            if not checkWorkshop and isLoaded then return end

            for k,v in pairs(AAS.BaseItems[workshopId]) do
                if AAS.ItemExist(v.model, v.options.skin) then continue end
                local tbl = table.Copy(v)
                
                AAS.AddItem(tbl, nil, true, true, true)
            end
    
            AAS.AddWorkshopId(workshopId, true)
        end)
    end

    AAS.SendItemInformations()
end

--[[ Format all information in the item table ]]
function AAS.FormatTable(uniqueId)
    uniqueId = tonumber(uniqueId)

    return isnumber(uniqueId) and (AAS.Table["items"][uniqueId] or {}) or AAS.Table["items"]
end

--[[ Add an item and broadcast or send information to the player ]]
function AAS.AddItem(informations, ply, noSendItem, checkIfExist, baseItem, callback)
    if istable(informations) and istable(informations.options) then
        informations.options.date = os.time()
    end

    local AASTbl = AAS.FormatItemTable(informations, true)
    local options = util.JSONToTable((AASTbl["options"] or "")) or {}

    if checkIfExist then 
        if AAS.ItemExist(AASTbl["model"], options["skin"]) then return end 
    end

    if baseItem then
        options.baseItem = true 
    end

    options = util.TableToJSON(options)

    AAS.Query(("INSERT INTO aas_item (name, description, model, price, pos, ang, scale, job, category, options) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"):format(AAS.Escape(AASTbl["name"]), AAS.Escape(AASTbl["description"]), AAS.Escape(AASTbl["model"]), AAS.Escape(AASTbl["price"]), AAS.Escape(AASTbl["pos"]), AAS.Escape(AASTbl["ang"]), AAS.Escape(AASTbl["scale"]), AAS.Escape(AASTbl["job"]), AAS.Escape(AASTbl["category"]), AAS.Escape(options)), function(queryResult)
    
        queryResult.lastInsertId = tonumber(queryResult.lastInsertId)
        AASTbl.uniqueId = queryResult.lastInsertId
        AAS.Table["items"][queryResult.lastInsertId] = AAS.FormatItemTable(AASTbl)

        if IsValid(ply) then
            ply:AASNotify(5, AAS.GetSentence("addItem").." "..AASTbl["name"])
        end
    
        util.PrecacheModel(AASTbl["model"])
    
        if not noSendItem then
            timer.Simple(0, function()
        
                AAS.SendItemInformations(nil, queryResult.lastInsertId)
            end)
        end
    
        hook.Run("AAS:OnItemAdded", AAS.Table["items"][queryResult.lastInsertId])

        if isfunction(callback) then
            callback(AAS.Table["items"][queryResult.lastInsertId])
        end
    end)
end

--[[ Edit an item and broadcast or send information to the player ]]
function AAS.UpdateItem(informations, ply, callback, noOffset)
    local AASTbl = AAS.FormatItemTable(informations, true)
    if not isnumber(AASTbl["uniqueId"]) or AASTbl["uniqueId"] == nil then return end 

    local customModelOffset = AASTbl["customModel"]
    if customModelOffset != "Configure position for all models" then
        noOffset = true

        AAS.CreateCustomOffsetModel(AASTbl["uniqueId"], customModelOffset, AASTbl["pos"], AASTbl["ang"], AASTbl["scale"])
    end
    AASTbl["customModel"] = nil

    local firstQuery = true
    local query = "UPDATE aas_item SET "

    for k,v in pairs(AASTbl) do
        if noOffset then
            if k == "pos" or k == "ang" or k == "scale" then continue end
        end

        query = query..(firstQuery and "" or ", ")..k.." = "..AAS.Escape(v) 
        firstQuery = false
    end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1

    query = query.." WHERE uniqueId = "..AASTbl["uniqueId"]

    AAS.Query(query, function()
        if noOffset then
            AAS.Table["items"][AASTbl["uniqueId"]] = AAS.Table["items"][AASTbl["uniqueId"]] or {}
            
            AASTbl["pos"] = AAS.Table["items"][AASTbl["uniqueId"]]["pos"] or Vector(0,0,0)
            AASTbl["ang"] = AAS.Table["items"][AASTbl["uniqueId"]]["ang"] or Angle(0,0,0)
            AASTbl["scale"] = AAS.Table["items"][AASTbl["uniqueId"]]["scale"] or Vector(0,0,0)
        end
        
        AAS.Table["items"][AASTbl["uniqueId"]] = AAS.FormatItemTable(AASTbl)
    
        timer.Simple(0, function()
            AAS.SendItemInformations(nil, AASTbl["uniqueId"])
        end)
    
        if IsValid(ply) then
            ply:AASNotify(5, AAS.GetSentence("updateItem").." "..AASTbl["name"])
        end
    
        hook.Run("AAS:OnItemModified", AAS.Table["items"][AASTbl["uniqueId"]])

        if isfunction(callback) then
            callback(AAS.Table["items"][AASTbl["uniqueId"]])
        end
    end)
end

function AAS.CreateCustomOffsetModel(uniqueId, playerModel, pos, ang, scale)
    playerModel = string.lower(playerModel)
    local query = ("SELECT * FROM aas_specific_model WHERE uniqueId = %s AND playerModel = %s"):format(AAS.Escape(uniqueId), AAS.Escape(playerModel))

    AAS.Query(query, function(tbl)
        if tbl && #tbl != 0 then
            AAS.Query(("UPDATE aas_specific_model SET pos = %s, ang = %s, scale = %s WHERE uniqueId = %s AND playerModel = %s"):format(AAS.Escape(pos), AAS.Escape(ang), AAS.Escape(scale), AAS.Escape(uniqueId), AAS.Escape(playerModel)))
        else
            AAS.Query(("INSERT INTO aas_specific_model (uniqueId, playerModel, pos, ang, scale) VALUES(%s, %s, %s, %s, %s)"):format(AAS.Escape(uniqueId), AAS.Escape(playerModel), AAS.Escape(pos), AAS.Escape(ang), AAS.Escape(scale)))
        end

        AAS.LoadCustomOffsetModel()
    end)
end

function AAS.LoadCustomOffsetModel()
    local query = "SELECT * FROM aas_specific_model"

    AAS.Table["customOffset"] = {}

    AAS.Query(query, function(tbl)
        for k,v in ipairs(tbl) do
            local uniqueId = v.uniqueId

            v.pos = toVectorOrAngle(v.pos, Vector)
            v.ang = toVectorOrAngle(v.ang, Angle)
            v.scale = toVectorOrAngle(v.scale, Vector)

            AAS.Table["customOffset"][uniqueId] = AAS.Table["customOffset"][uniqueId] or {}
            AAS.Table["customOffset"][uniqueId][v.playerModel] = {
                ["pos"] = v.pos,
                ["ang"] = v.ang,
                ["scale"] = v.scale,
            }
        end

        AAS.Table["customOffsetCompressed"] = AAS.CompressTable(AAS.Table["customOffset"])
        AAS.SendCustomOffsetModel()
    end)
end

function AAS.SendCustomOffsetModel(ply)
    AAS.Table["customOffsetCompressed"] = AAS.Table["customOffsetCompressed"] or {}

    net.Start("AAS:Main")
        net.WriteUInt(8, 5)
        net.WriteUInt(#AAS.Table["customOffsetCompressed"], 32)
        net.WriteData(AAS.Table["customOffsetCompressed"], #AAS.Table["customOffsetCompressed"])
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end 
end

--[[ Delete an item and brodcast or send information to the player ]]
function AAS.DeleteItem(uniqueId, ply, callback)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    local AASTbl = AAS.FormatTable(uniqueId)
    if not istable(AASTbl) then return end

    AAS.Query(("DELETE FROM aas_item WHERE uniqueId = %s"):format(AAS.Escape(uniqueId)), function()
        
        if IsValid(ply) then
            ply:AASNotify(5, AAS.GetSentence("deleteItem").." "..AASTbl["name"])
        end
        
        hook.Run("AAS:OnItemDeleted", AASTbl)
        
        if isfunction(callback) then
            callback(AASTbl)
            AAS.Table["items"][uniqueId] = nil
        else
            AAS.Table["items"][uniqueId] = nil

            timer.Simple(0, function()
                AAS.SendItemInformations()
            end)
        end
    end)
end

--[[ Send informaton about the item ]]
function AAS.SendItemInformations(ply, uniqueId)
    local AASTbl = AAS.FormatTable()
    local CompressTbl = AAS.CompressTable(AASTbl)

    net.Start("AAS:Main")
        net.WriteUInt(1, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
        net.WriteBool(false)
        if isnumber(uniqueId) then
            net.WriteUInt(uniqueId, 32)
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end 

    hook.Run("AAS:InformationSended", AASTbl)
end

local PLAYER = FindMetaTable("Player")

--[[ Send a notification to the player ]]
function PLAYER:AASNotify(time, msg)
    net.Start("AAS:Main")
        net.WriteUInt(3, 5)
        net.WriteUInt(time, 5)
        net.WriteString(msg)
    net.Send(self)
end

-- [[ Cache player inventory ]] --
function PLAYER:AASCachePlayer(callback)
    local id64 = self:SteamID64() 

    AAS.Table["players"][id64] = AAS.Table["players"][id64] or {}
    AAS.Table["players"][id64]["inventory"] = AAS.Table["players"][id64]["inventory"] or {}
    AAS.Table["players"][id64]["bodygroups"] = AAS.Table["players"][id64]["bodygroups"] or {}
    AAS.Table["players"][id64]["offsets"] = AAS.Table["players"][id64]["offsets"] or {}

    local doneActions, actionsToDone = 0, 3
    AAS.Query("SELECT * FROM aas_inventory WHERE steam_id = '"..id64.."'", function(AASTbl)
        for k,v in ipairs(AASTbl) do
            AAS.Table["players"][id64]["inventory"][tonumber(v["uniqueId"])] = {
                price = tonumber(v["price"]),
                uniqueId = tonumber(v["uniqueId"])
            }
        end

        doneActions = doneActions + 1
        if doneActions == actionsToDone and isfunction(callback) then
            callback()
        end
    end)
    
    AAS.Query("SELECT * FROM aas_bodygroups WHERE steam_id = '"..id64.."'", function(AASTbl)
        for k,v in ipairs(AASTbl) do
            v["bodygroups_list"] = util.JSONToTable(v["bodygroups_list"])

            AAS.Table["players"][id64]["bodygroups"][v["model"]] = AAS.Table["players"][id64]["bodygroups"][v["model"]] or {}

            v["skin"] = tonumber(v["skin"])
            AAS.Table["players"][id64]["bodygroups"][v["model"]] = {
                ["skin"] = v["skin"],
                ["bodygroups"] = v["bodygroups_list"]
            }
        end

        doneActions = doneActions + 1
        if doneActions == actionsToDone and isfunction(callback) then
            callback()
        end
    end)

    AAS.Query("SELECT * FROM aas_offsets WHERE steam_id = '"..id64.."'", function(AASTbl)
        for k,v in ipairs(AASTbl) do
            v.uniqueId = tonumber(v.uniqueId)

            v.pos = toVectorOrAngle(v.pos, Vector)
            v.ang = toVectorOrAngle(v.ang, Angle)
            v.scale = toVectorOrAngle(v.scale, Vector)

            AAS.Table["players"][id64]["offsets"][v.uniqueId] = {
                ["pos"] = v.pos,
                ["ang"] = v.ang,
                ["scale"] = v.scale
            }
        end

        doneActions = doneActions + 1
        if doneActions == actionsToDone and isfunction(callback) then
            callback()
        end
    end)
end 

-- [[ Uncache player inventory ]] --
function PLAYER:AASUncachePlayer()
    AAS.Table["players"][self:SteamID64()] = nil
end

-- [[ Get player inventory ]] --
function PLAYER:AASGetInventory()
    local id64 = self:SteamID64()

    return AAS.Table["players"][id64] and (AAS.Table["players"][id64]["inventory"] or {}) or {}
end

-- [[ Get player bodygroups for model ]] --
function PLAYER:AASGetSavedBodygroups(model)
    local id64 = self:SteamID64()

    return AAS.Table["players"][id64] and AAS.Table["players"][id64]["bodygroups"][model] or nil
end

--[[ Send to the player his inventory ]]
function PLAYER:AASSendInventory()
    local inventoryTable = self:AASGetInventory()

    local CompressTbl = AAS.CompressTable(inventoryTable)
    net.Start("AAS:Inventory")
        net.WriteUInt(1, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
    net.Send(self)
end

--[[ Load selected bodygroup linked to the model of the player ]]
function PLAYER:AASLoadBodyGroup()
    if AAS.BlackListBodyGroup[team.GetName(self:Team())] then self:AASNotify(5, AAS.GetSentence("jobProblem")) return end

    local AASTbl = self:AASGetSavedBodygroups(self:GetModel())
    if not istable(AASTbl) then return end
    
    for k,v in ipairs(AASTbl["bodygroups"]) do
        self:SetBodygroup(k, 0)
        self:SetBodygroup((k or 0), (v or 0))
    end

    local skin = AASTbl["skin"] or 0

    self:SetSkin(0)
    self:SetSkin(skin)

    hook.Run("AAS:BodyGroupLoaded", self, AASTbl["bodygroups"])
end

--[[ Save selected bodygroup linked to the model of the player ]]
function PLAYER:AASSaveBodygroups(bodyGroupTable)
    
    local bodyGroups = util.TableToJSON((bodyGroupTable or {}))
    local skin = self:GetSkin()
    
    AAS.Query("SELECT * FROM aas_bodygroups WHERE steam_id = '"..self:SteamID64().."'".." AND model = '"..self:GetModel().."'", function(AASTbl)
        
        if istable(AASTbl) and #AASTbl != 0 then
            AAS.Query("UPDATE aas_bodygroups SET bodygroups_list = "..AAS.Escape(bodyGroups)..", skin = "..AAS.Escape(skin).." WHERE steam_id = '"..self:SteamID64().."'".." AND model = '"..self:GetModel().."'")
        else 
            AAS.Query(("INSERT INTO aas_bodygroups (steam_id, model, bodygroups_list, skin) VALUES(%s, %s, %s, %s)"):format(AAS.Escape(self:SteamID64()), AAS.Escape(self:GetModel()), AAS.Escape(bodyGroups), AAS.Escape(skin)))
        end

        AAS.Table["players"][self:SteamID64()] = AAS.Table["players"][self:SteamID64()] or {}
        AAS.Table["players"][self:SteamID64()]["bodygroups"] = AAS.Table["players"][self:SteamID64()]["bodygroups"] or {}
        AAS.Table["players"][self:SteamID64()]["bodygroups"][self:GetModel()] = {
            ["skin"] = skin,
            ["bodygroups"] = bodyGroupTable
        }

        hook.Run("AAS:BodyGroupSaved", self, bodyGroups)
    end)
end

--[[ Save last model and all item equiped by the player ]]
function PLAYER:AASSaveModelItem()
    local model = self:GetModel()
    local items = self.AASAccessories or {}
    local tableToSave = util.TableToJSON(items)

    AAS.Query("UPDATE aas_player_saved SET last_model = "..AAS.Escape(model)..", item_saved = "..AAS.Escape(tableToSave).." WHERE steam_id = '"..self:SteamID64().."'")
end

--[[ Reload last model and all item equiped by the player ]]
function PLAYER:AASReloadModelItem()
    AAS.Query("SELECT * FROM aas_player_saved WHERE steam_id = '"..self:SteamID64().."'", function(AASTbl)
        if not istable(AASTbl[1]) then return end
    
        local itemJson = AASTbl[1]["item_saved"] or ""
        local itemTable = util.JSONToTable(itemJson) or {}
    
        if AAS.LoadItemsSaved then
            for k,v in pairs(itemTable) do
                self:AASEquipAccessory(v)
            end
        end
        
        local model = AASTbl[1]["last_model"]
        if AAS.LoadModelSaved and isstring(model) then
            self:SetModel(model)
            self:AASLoadBodyGroup()
        end
    
        hook.Run("AAS:ItemModelReloaded", self, itemTable, model)
    end)
end

--[[ Check if a certain entity class is near the player ]]
function PLAYER:AASCheckDistEnt(class, radius)
    radius = radius^2

    for k,v in ipairs(ents.FindByClass(class)) do
        if not IsValid(v) then continue end

        if v:GetPos():DistToSqr(self:GetPos()) < radius then 
            return true
        end 
    end 
    return false
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1

--[[ Buy the item and store it into the inventory of the player ]]
function PLAYER:AASBuyItem(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    local AASTbl = AAS.FormatTable(uniqueId)
    if not istable(AASTbl) or table.Count(AASTbl) == 0 then return end

    local price = (AASTbl["price"] or 0)

    if self:AASIsBought(uniqueId) then self:AASNotify(5, AAS.GetSentence("ownedItem")) return end
    if self:AASGetMoney() < price then self:AASNotify(5, AAS.GetSentence("notEnoughtMoney")) return end
    
    if AASTbl["options"]["usergroups"] and (AASTbl["options"]["usergroups"][self:GetUserGroup()] or false) then self:AASNotify(5, AAS.GetSentence("notRank")) return end
    if not AASTbl["options"]["activate"] then self:AASNotify(5, AAS.GetSentence("itemDesactivate")) return end

    self:AASAddMoney(-price)
    AAS.GiveItem(self:SteamID64(), uniqueId, price, function()
        self:AASNotify(5, AAS.GetSentence("buyItem").." "..AASTbl["name"].." "..AAS.GetSentence("for").." "..AAS.formatMoney(price))
    
        hook.Run("AAS:BoughtItem", self, AASTbl)
    end)
end

--[[ Check if the item is bought by the player ]]
function PLAYER:AASIsBought(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end
    
    local id64 = self:SteamID64()

    return AAS.Table["players"][id64] and AAS.Table["players"][id64]["inventory"] and istable(AAS.Table["players"][id64]["inventory"][uniqueId])
end

--[[ Give an item with the steamId64 ]]
function AAS.GiveItem(steamId64, uniqueId, price, callback)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    if not isnumber(price) then price = 0 end

    AAS.Query(("INSERT INTO aas_inventory (steam_id, uniqueId, price) VALUES(%s, %s, %s)"):format(AAS.Escape(steamId64), AAS.Escape(uniqueId), AAS.Escape(price)), function()
        if istable(AAS.Table["players"][steamId64]) then
            AAS.Table["players"][steamId64]["inventory"] = AAS.Table["players"][steamId64]["inventory"] or {}
            AAS.Table["players"][steamId64]["inventory"][uniqueId] = {
                ["price"] = price,
                ["uniqueId"] = uniqueId
            }
        end
    
        local player = player.GetBySteamID64(steamId64)
    
        if IsValid(player) then
            player:AASSendInventory()
        end

        if isfunction(callback) then
            callback()
        end
    end)
end

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:AASAddMoney(price)
    if DarkRP && isfunction(self.addMoney) then
        self:addMoney(price)
    elseif ix && isfunction(self.GetCharacter) then
        if self:GetCharacter() != nil then
            local money = self:AASGetMoney()
            self:GetCharacter():SetMoney(money + price)
        end
    elseif nut && isfunction(self.getChar) then
        if self:getChar() != nil then
            local money = self:AASGetMoney()
            self:getChar():setMoney(money + price)
        end
    elseif self.PS2_Wallet then
        self:PS2_AddStandardPoints(price)
    end
end

--[[ Sell the item and remove it into the inventory of the player ]]
function PLAYER:AASSellItem(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    if not self:AASIsBought(uniqueId) then return end

    local id64 = self:SteamID64()
    
    local price = (AAS.Table["players"][id64]["inventory"][uniqueId]["price"]*AAS.SellValue/100 or 0)
    self:AASAddMoney(price)
    self:AASNotify(5, AAS.GetSentence("sellItem").." "..AAS.formatMoney(price))
    
    AAS.Query(("DELETE FROM aas_inventory WHERE uniqueId = %s AND steam_id = %s"):format(AAS.Escape(uniqueId), AAS.Escape(self:SteamID64())), function()
    
        AAS.Table["players"][self:SteamID64()]["inventory"][uniqueId] = nil
        AAS.Table["players"][self:SteamID64()]["offsets"][uniqueId] = nil
        
        hook.Run("AAS:SoldItem", self, uniqueId, AAS.Table["players"][id64]["inventory"][uniqueId])

        self:AASSendInventory()
        self:AASUnEquipAccessoryById(uniqueId)
    end)
end

--[[ Equip an accessory with his uniqueId ]]
function PLAYER:AASEquipAccessory(uniqueId, noNotify)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    if not istable(self.AASAccessories) then self.AASAccessories = {} end

    local ItemsEquiped = AAS.FormatTable(uniqueId)
    if not istable(ItemsEquiped) then return end

    local uniqueId = ItemsEquiped.uniqueId
    local category = ItemsEquiped.category
    
    if not isnumber(uniqueId) or not isstring(category) then return end
    if not self:AASIsBought(uniqueId) then self:AASNotify(5, AAS.GetSentence("cantEquip")) return end
    
    if ItemsEquiped.options["usergroups"] and (ItemsEquiped.options["usergroups"][self:GetUserGroup()] or false) then self:AASNotify(5, AAS.GetSentence("itemVip")) return end
    
    self.AASAccessories[category] = uniqueId

    if not noNotify then
        self:AASNotify(5, AAS.GetSentence("equipItem"))
    end

    local offsetTable = self:AASGetOffsets(uniqueId)
    if not istable(offsetTable) then offsetTable = {} end
    
    net.Start("AAS:Inventory")
        net.WriteUInt(2, 5)
        net.WriteUInt(uniqueId, 32)
        net.WriteString(self:SteamID64())
        net.WriteTable(offsetTable)
        net.WriteString(category)
    net.Broadcast()

    hook.Run("AAS:AccessoryEquiped", self, ItemsEquiped)
end

--[[ UnEquip an accessory with his uniqueId ]]
function PLAYER:AASUnEquipAccessoryById(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8

    if not istable(self.AASAccessories) then self.AASAccessories = {} end
    
    for k,v in pairs(self.AASAccessories) do
        if v != uniqueId then continue end

        self:AASUnEquipAccessory(k)

        hook.Run("AAS:AccessoryUnEquiped", self)
        break
    end
end

--[[ UnEquip an accessory with his category ]]
function PLAYER:AASUnEquipAccessory(category)
    if not istable(self.AASAccessories) then self.AASAccessories = {} end
    if not isnumber(self.AASAccessories[category]) then return end

    self.AASAccessories[category] = nil

    net.Start("AAS:Inventory")
        net.WriteUInt(3, 5)
        net.WriteString(category)
        net.WriteString(self:SteamID64())
    net.Broadcast()

    self:AASNotify(5, AAS.GetSentence("deequipedItem"))

    hook.Run("AAS:AccessoryUnEquiped", self)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

--[[ Reset all accessory of the player and broadcast information ]]
function PLAYER:AASUnEquipAllAccessory()
    net.Start("AAS:Inventory")
        net.WriteUInt(4, 5)
        net.WriteString(self:SteamID64())
    net.Broadcast()

    hook.Run("AAS:RemoveAllAccessory", self)
end

--[[ Send all accessory of all player ]]
function PLAYER:AASSendAllAccessory()
    local tableToSend = {}
    for k,v in ipairs(player.GetAll()) do
        if not istable(v.AASAccessories) then v.AASAccessories = {} end
        
        tableToSend[v:SteamID()] = v.AASAccessories
        
        if not istable(tableToSend[v:SteamID()]["offsets"]) then tableToSend[v:SteamID()]["offsets"] = {} end

        for cat, uniqueId in pairs(v.AASAccessories) do
            if not isnumber(uniqueId) then continue end
            
            local offsetTable = v:AASGetOffsets(uniqueId)
            if istable(offsetTable) then
                tableToSend[v:SteamID()]["offsets"][uniqueId] = offsetTable
            end
        end
    end    
    
    local CompressTbl = AAS.CompressTable(tableToSend)
    net.Start("AAS:Inventory")
        net.WriteUInt(5, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
    net.Send(self)
end

--[[ Make sure that the offset is not upper than the max ]]
local function checkOffsetsNumber(toCheck, typeArg)
    if not isvector(toCheck) and not isangle(toCheck) then return end

    local max = (typeArg == Vector) and AAS.MaxVectorOffset or AAS.MaxAngleOffset

    for i=1, 3 do
        if toCheck[i] > max then
            toCheck[i] = max
        elseif toCheck[i] < -max then
            toCheck[i] = -max
        end
    end

    return toCheck
end

--[[ Save offset on a specific uniqueId ]]
function PLAYER:AASSaveOffsets(uniqueId, pos, ang, scale, callback)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end
    
    if not isvector(pos) then pos = Vector(0,0,0) end
    if not isangle(ang) then ang = Angle(0,0,0) end
    if not isvector(scale) then scale = Vector(0,0,0) end
    
    pos = checkOffsetsNumber(pos, Vector)
    ang = checkOffsetsNumber(ang, Angle)
    scale = checkOffsetsNumber(scale, Vector)
    
    AAS.Query("SELECT * FROM aas_offsets WHERE steam_id = '"..self:SteamID64().."' AND uniqueId = '"..uniqueId.."'", function(AASTbl)
    
        if istable(AASTbl) and #AASTbl != 0 then
            AAS.Query("UPDATE aas_offsets SET pos = "..AAS.Escape(pos)..", ang = "..AAS.Escape(ang)..", scale = "..AAS.Escape(scale).." WHERE uniqueId = '"..uniqueId.."'".." AND steam_id = '"..self:SteamID64().."'")
        else 
            AAS.Query(("INSERT INTO aas_offsets (steam_id, uniqueId, pos, ang, scale) VALUES(%s, %s, %s, %s, %s)"):format(AAS.Escape(self:SteamID64()), AAS.Escape(uniqueId), AAS.Escape(pos), AAS.Escape(ang), AAS.Escape(scale)))
        end

        uniqueId = tonumber(uniqueId)
        AAS.Table["players"][self:SteamID64()]["offsets"][uniqueId] = {
            ["pos"] = pos,
            ["ang"] = ang,
            ["scale"] = scale
        }
    
        self:AASEquipAccessory(uniqueId, true)
        self:AASSendAllOfsets()

        if isfunction(callback) then
            callback()
        end
    end)
end

--[[ Get offset on a specific uniqueId ]]
function PLAYER:AASGetOffsets(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    return AAS.Table["players"][self:SteamID64()] and AAS.Table["players"][self:SteamID64()]["offsets"] and AAS.Table["players"][self:SteamID64()]["offsets"][uniqueId] or nil
end

--[[ Send all ofsets configuration ]]
function PLAYER:AASSendAllOfsets()

    net.Start("AAS:Inventory")
        net.WriteUInt(6, 5)
        net.WriteTable(AAS.Table["players"][self:SteamID64()] and AAS.Table["players"][self:SteamID64()]["offsets"] or {})
    net.Send(self)
end

--[[ Check if the player is on the correct job for equip/buyitem/sellitem ]]
function PLAYER:AASCheckJob(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

    local AASTbl = AAS.FormatTable(uniqueId)
    if not istable(AASTbl) or table.Count(AASTbl) == 0 then return false end
    
    if not istable(AASTbl[1]) or not istable(AASTbl[1]["job"]) or #AASTbl[1]["job"] == 0 then return true end
    if not AASTbl[1]["job"][team.GetName(self:Team())] then return false end

    return true
end

function AAS.SHInventoryToAAS()
    SH_ACC:Query("SELECT * FROM :db", {}, function(result)
        for i=1, #result do
            local explodeTable = string.Explode("|", result[i].inventory)
            local steamId64 = util.SteamIDTo64("STEAM_"..(result[i].id):Replace("_", ":"))

            AAS.Query("SELECT * FROM aas_player_saved WHERE steam_id = '"..steamId64.."'", function(AASInventory)
                if #AASInventory == 0 then 
                    AAS.Query("INSERT INTO aas_player_saved ( steam_id ) VALUES ('"..steamId64.."')")
                end
            end)

            for i=1, #explodeTable do
                local itemTable = SH_ACC.List[explodeTable[i]]

                if not istable(itemTable) then continue end
                local exist, uniqueId = AAS.ItemExist(itemTable.mdl, itemTable.skin)

                AAS.GiveItem(steamId64, uniqueId, 0)
            end
        end
    end)
end

--[[ Check if the unique Id Exist ]]
function AAS.GetTableById(uniqueId)
    uniqueId = tonumber(uniqueId)
    if not isnumber(uniqueId) then return end

	return istable(AAS.Table["items"][uniqueId])
end

--[[ Save all entity on the server ]]
local AASMap = string.lower(game.GetMap())
function AAS.SaveEntity()
    AAS.Entity = AAS.Entity or {}

    local EntityTable = {}

    for k,v in ipairs(AAS.Entity) do
        if not IsValid(v) then continue end

        EntityTable[#EntityTable + 1] = {
            ["class"] = v:GetClass(),
            ["pos"] = tostring(v:GetPos()),
            ["ang"] = tostring(v:GetAngles()),
            ["model"] = v:GetModel(),
        }
    end

    local tableToSave = util.TableToJSON(EntityTable)
    AAS.Query("SELECT * FROM aas_entity_saved WHERE map = '"..AASMap.."'", function(AASTbl)
        if istable(AASTbl) and #AASTbl != 0 then
            AAS.Query("UPDATE aas_entity_saved SET entities_table = "..AAS.Escape(tableToSave).." WHERE map = '"..AASMap.."'")
        else 
            AAS.Query(("INSERT INTO aas_entity_saved (map, entities_table) VALUES(%s, %s)"):format(AAS.Escape(AASMap), AAS.Escape(tableToSave)))
        end
    end)
end

--[[ Reload all entity on the server ]]
function AAS.ReloadEntity()
    AAS.RemoveEntity()

    AAS.Query("SELECT * FROM aas_entity_saved WHERE map = '"..AASMap.."'", function(jsonTable)
        if not istable(jsonTable) or not istable(jsonTable[1]) then return end
        
        local AASTable = util.JSONToTable(jsonTable[1].entities_table) or {}
    
        for k,v in ipairs(AASTable) do
            local AASEnt = ents.Create(v.class)
            if not IsValid(AASEnt) then return end
            AASEnt:SetModel(v.model)
            AASEnt:SetPos(toVectorOrAngle(v.pos, Vector))
            AASEnt:SetAngles(toVectorOrAngle(v.ang, Angle))
            AASEnt:Spawn()
            AASEnt:Activate()
        end
    end)
end

--[[ Remove all entity on the server ]]
function AAS.RemoveEntity()
    AAS.Entity = AAS.Entity or {}

    for k,v in ipairs(AAS.Entity) do
        if not IsValid(v) then continue end

        v:Remove()
    end
end
 
--[[ Get into the base items table the description and the name translated ]]
local function getDescNameItem(model, skin)
    for workshopId, bool in pairs(AAS.LoadWorkshop) do
        if not istable(AAS.BaseItems[workshopId]) then continue end

        for k,v in pairs(AAS.BaseItems[workshopId]) do
            if v.model != model or v.options.skin != skin then continue end

            return v.name, v.description
        end
    end
end

--[[ Change item description / name when the langage change ]]
function AAS.ChangeLangage()
    AAS.Query("SELECT * FROM aas_loaded_options", function(AASTbl)
    
        local lang = istable(AASTbl[1]) and AASTbl[1]["language"] or ""
        if lang != AAS.Lang then
            AAS.BaseItemTable()
            
            local function callback()
                AAS.CacheItems(function()
                    AAS.SendItemInformations()
            
                    --[[ Resize fonts when language change ]]
                    net.Start("AAS:Main")
                        net.WriteUInt(7, 5)
                    net.Broadcast()
                end)
            end

            if istable(AASTbl) and #AASTbl != 0 then
                AAS.Query("UPDATE aas_loaded_options SET language = "..AAS.Escape(AAS.Lang))
            else 
                AAS.Query(("INSERT INTO aas_loaded_options (language) VALUES(%s)"):format(AAS.Escape(AAS.Lang)))
            end
        
            local doneActions, actionsToDone = 0, 0
            for k,v in pairs(AAS.Table["items"]) do
    
                if tobool(v.options.baseItem) then
                    local name, description = getDescNameItem(v.model, v.options.skin)
                    if not isstring(name) then name = v.name end
                    if not isstring(description) then description = v.description end

                    actionsToDone = actionsToDone + 1
                    AAS.Query("UPDATE aas_item SET name = "..AAS.Escape(name)..", description = "..AAS.Escape(description).." WHERE uniqueId = '"..v.uniqueId.."'", function()
                        
                        doneActions = doneActions + 1
                        if doneActions == actionsToDone then
                            callback()
                        end
                    end)
                end
            end
        end
    end)
end

--[[ Remove all entity saved ]]
function AAS.RemoveEntitySql()
    AAS.Query(("DELETE FROM aas_entity_saved WHERE map = %s"):format(AAS.Escape(AASMap)), function()
    
        AAS.RemoveEntity()
    end)
end

--[[ Convert your Sql to a Table ]]
function AAS.ConvertSqlToDataTable()
    local spaceSize = "    "
    local currentTab = ""

    local function tableToString(tbl)
        if not istable(tbl) then return "{}" end

        currentTab = currentTab..spaceSize
        local content = "{"
        for k,v in pairs(tbl) do
            local value

            if isvector(v) then
                
                value = ("Vector(%s, %s, %s)"):format(v.x, v.y, v.z)
                
            elseif isangle(v) then

                value = ("Angle(%s, %s, %s)"):format(v.p, v.y, v.r)
            
            elseif isstring(v) then

                value = ("\"%s\""):format(v)

            elseif istable(v) then
                if isnumber(v.r) and isnumber(v.g) and isnumber(v.b) and isnumber(v.a) then

                    value = ("Color(%s, %s, %s, %s)"):format(v.r, v.g, v.b, v.a)
                else
                    
                    value = tableToString(v)
                end
            
            else
                value = v
            end

            content = content.."\n"..currentTab..("[\"%s\"] = %s,"):format(k, value)
        end

        currentTab = table.concat(string.Explode("", currentTab), "", 1, #currentTab - #spaceSize)
        return content ~= "{" and content.."\n"..currentTab.."}" or "{}"
    end

    local function generateConfigFile()
        local content = "return {"

        local items = AAS.FormatTable()
        currentTab = spaceSize
        for k,v in ipairs(items) do

            content = content.."\n"..currentTab..tableToString(v)..","
        end
        
        return content.."\n}"
    end

    print("[AAS] Data Saved")

    file.Write("aas_item_table.txt", generateConfigFile())
end

local function CheckConsole(ply)
    local canAccess = false

    if ply == NULL then 
        canAccess = true
    elseif IsValid(ply) then
        if AAS.AdminRank[ply:GetUserGroup()] then
            canAccess = true
        end
    end

    return canAccess
end

concommand.Add("aas_save_entity", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.SaveEntity()
end)

concommand.Add("aas_reload_entity", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.ReloadEntity()
end)

concommand.Add("aas_remove_entity", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.RemoveEntity()
end)

concommand.Add("aas_remove_entitysql", function(ply, cmd, args)
    if ply != NULL && not AAS.AdminRank[ply:GetUserGroup()] then return end
    AAS.RemoveEntitySql()
end)

concommand.Add("aas_reload_basicitem", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.SaveBasicsItems(true)
end)

concommand.Add("aas_give_items_steamid64", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.GiveItem(args[1], tonumber(args[2]), 0)
end)

concommand.Add("aas_save_item_data", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.ConvertSqlToDataTable()
end)

concommand.Add("aas_sh_inventory_to_aas", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.SHInventoryToAAS()
end)

AAS.CacheItems(function(itemsTbl)
        
    for k,v in pairs(itemsTbl) do
        util.PrecacheModel(v.model)
    end 
    
    for k,v in pairs(AAS.LoadWorkshop) do
        if not v then continue end
        
        resource.AddWorkshop(k)
    end
    
    AAS.SaveBasicsItems()
    AAS.ReloadEntity()
    AAS.ChangeLangage()
    AAS.LoadCustomOffsetModel()
end)
