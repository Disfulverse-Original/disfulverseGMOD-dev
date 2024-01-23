local PLAYER = FindMetaTable("Player")

-- [[ Mysql database connection system ]] --
local mysqlDB
if RCD.Mysql then
    local succ, err = pcall(function() require("mysqloo") end)
    if not succ then return print("[RCD] Error with MYSQLOO") end
    
    if not mysqloo then
        return print("[RCD] Cannot require mysqloo module :\n"..requireError)
    end

    mysqlDB = mysqloo.connect(RCD.MysqlInformations["host"], RCD.MysqlInformations["username"], RCD.MysqlInformations["password"], RCD.MysqlInformations["database"], {["port"] = RCD.MysqlInformations["port"]})
    function mysqlDB:onConnected()  
        print("[RCD] Succesfuly connected to the mysql database !")
        RCD.MysqlConnected = true
    end
    
    function mysqlDB:onConnectionFailed(connectionError)
        print("[RCD] Cannot etablish database connection :\n"..connectionError)
    end
    mysqlDB:connect()
end

--[[ SQL Query function ]] --
function RCD.Query(query, callback)
    if not isstring(query) then return end

    local result = {}
    local isInsertQuery = string.StartWith(query, "INSERT")
    if RCD.Mysql then
        query = mysqlDB:query(query)

        if callback == "wait" then
            query:start()
            query:wait()

            local err = query:error()
            if err == "" then        
                return isInsertQuery and { lastInsertId = query:lastInsert() } or query:getData()
            else
                print("[RCD] "..err)
            end
        else
            function query:onError(q, err, sql)
                print("[RCD] "..err)
            end

            function query:onSuccess(tbl, data)
                if isfunction(callback) then
                    callback(isInsertQuery and { lastInsertId = query:lastInsert() } or tbl)
                end
            end
            query:start()
        end
    else
        result = sql.Query(query)
        result = isInsertQuery and { lastInsertId = sql.Query("SELECT last_insert_rowid()")[1]["last_insert_rowid()"] } or result

        if callback == "wait" then
            return result
            
        elseif isfunction(callback) then
            callback(result)

            return
        end
    end

    return (result or {})
end

-- [[ Escape the string ]] --  
function RCD.Escape(str)
    return RCD.MysqlConnected and ("'%s'"):format(mysqlDB:escape(tostring(str))) or SQLStr(str)    
end

--[[ Convert a string to a vector or an angle ]]
function RCD.ToVectorOrAngle(toConvert, typeToSet)
    if not isstring(toConvert) or (typeToSet != Vector and typeToSet != Angle) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return typeToSet == Vector and Vector(x, y, z) or Angle(x, y, z)
end

-- [[ Function to add a compatibility with autoincrement ]]
function RCD.AutoIncrement()
    return (RCD.Mysql and "AUTO_INCREMENT" or "AUTOINCREMENT")
end 

--[[ Initialize all mysql/sql table ]]
function RCD.InitializeTables()
    local autoIncrement = RCD.AutoIncrement()
    RCD.Query(([[
        CREATE TABLE IF NOT EXISTS rcd_groups (
            id INTEGER NOT NULL PRIMARY KEY %s, 
            name VARCHAR(100), 
            rankAccess LONGTEXT, 
            jobAccess LONGTEXT
        );

        CREATE TABLE IF NOT EXISTS rcd_vehicles(
            id INTEGER NOT NULL PRIMARY KEY %s,
            name VARCHAR(100),
            class VARCHAR(100),
            groupId INT,
            price INT,
            options LONGTEXT
        );

        CREATE TABLE IF NOT EXISTS rcd_npc(
            id INTEGER NOT NULL PRIMARY KEY %s,
            map VARCHAR(100),
            name VARCHAR(100),
            model VARCHAR(100),
            pos VARCHAR(150),
            ang VARCHAR(150),
            plateforms LONGTEXT,
            groups LONGTEXT
        );

        CREATE TABLE IF NOT EXISTS rcd_bought_vehicles(
            id INTEGER NOT NULL PRIMARY KEY %s,
            playerId VARCHAR(100),
            vehicleId INT,
            groupId INT,
            customization LONGTEXT,
            discount INT DEFAULT 0,
            compatibilitiesOptions LONGTEXT,
            FOREIGN KEY(vehicleId) REFERENCES rcd_vehicles(id) ON DELETE CASCADE
        );

        CREATE TABLE IF NOT EXISTS rcd_settings(
            id INTEGER NOT NULL PRIMARY KEY %s,
            keyName VARCHAR(100),
            value LONGTEXT
        );

        CREATE TABLE IF NOT EXISTS rcd_bough_compatibilities(
            id INTEGER NOT NULL PRIMARY KEY %s,
            playerId VARCHAR(100),
            vehicleId INT,
            groupId INT, customization LONGTEXT,
            FOREIGN KEY(vehicleId) REFERENCES rcd_vehicles(id) ON DELETE CASCADE
        );

        CREATE TABLE IF NOT EXISTS rcd_compatibilities_done(
            id INTEGER NOT NULL PRIMARY KEY %s,
            addonName VARCHAR(100)
        );
    ]]):format(autoIncrement, autoIncrement, autoIncrement, autoIncrement, autoIncrement, autoIncrement, autoIncrement))
end

--[[ Intialize settings of the addon ]]
function RCD.InitializeSettings()
    RCD.Query("SELECT * FROM rcd_settings", function(settings)
        if not settings or not settings[1] then
            for k,v in pairs(RCD.DefaultSettings) do
                RCD.Query(("INSERT INTO rcd_settings (keyName, value) VALUES (%s, %s)"):format(RCD.Escape(k), RCD.Escape(v)))
            end
        else
            for k,v in pairs(settings) do
                if v.value == "true" or v.value == "false" then
                    v.value = tobool(v.value)
                elseif isnumber(tonumber(v.value)) then
                    v.value = tonumber(v.value)
                end
    
                RCD.DefaultSettings[v.keyName] = v.value
            end
        end
    end)
end

--[[ Set Settings on the table ]]
function RCD.SetSettings(settings)
    if not istable(settings) then return end

    for k,v in pairs(settings) do
        if RCD.DefaultSettings[k] == nil or RCD.DefaultSettings[k] != v then 
            RCD.Query(("UPDATE rcd_settings SET value = %s WHERE keyName = %s"):format(RCD.Escape(v), RCD.Escape(k)))
        end

        RCD.DefaultSettings[k] = v
    end

    RCD.SendSettings()
end

--[[ Send all settings to the player on the client ]]
function RCD.SendSettings(ply)
    net.Start("RCD:Admin:Configuration")
        net.WriteUInt(10, 4)
        net.WriteUInt(table.Count(RCD.DefaultSettings), 12)
        for k,v in pairs(RCD.DefaultSettings) do
            local valueType = type(v)

            net.WriteString(valueType)
            net.WriteString(k)
            net["Write"..RCD.TypeNet[valueType]](v, ((RCD.TypeNet[valueType] == "Int") and 32))
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ This function permit to create variables on whatever you want networked with all players ]]
function RCD.SetNWVariable(key, value, ent, send, ply, sync)
    if not IsValid(ent) or not isstring(key) then return end

    RCD.NWVariables = RCD.NWVariables or {}

    ent.RCDNWVariables = ent.RCDNWVariables or {}
    ent.RCDNWVariables[key] = value
    
    if sync then
        RCD.NWVariables["networkEnt"] = RCD.NWVariables["networkEnt"] or {}
        RCD.NWVariables["networkEnt"][ent] = ent.RCDNWVariables

        ent:CallOnRemove("rcd_reset_variables:"..ent:EntIndex(), function(ent) RCD.NWVariables["networkEnt"][ent] = nil end) 
    end

    if send then
        RCD.SyncNWVariable(key, ent, ply)
    end
end

--[[ Sync variable to the clientside or to everyone ]]
function RCD.SyncNWVariable(key, ent, ply)
    if not IsValid(ent) or not isstring(key) then return end

    ent.RCDNWVariables = ent.RCDNWVariables or {}
    
    local value = ent.RCDNWVariables[key]
    if value == nil then return end

    local valueType = type(value)

    net.Start("RCD:Main:Client")
        net.WriteUInt(1, 4)
        net.WriteUInt(1, 12)
        net.WriteUInt(ent:EntIndex(), 32)
        net.WriteUInt(1, 4)
        net.WriteString(valueType)
        net.WriteString(key)
        net["Write"..RCD.TypeNet[valueType]](value, ((RCD.TypeNet[valueType] == "Int") and 32))
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Sync all variables needed client side ]]
function PLAYER:RCDSyncAllVariables()
    RCD.NWVariables = RCD.NWVariables or {}
    RCD.NWVariables["networkEnt"] = RCD.NWVariables["networkEnt"] or {}
    
    net.Start("RCD:Main:Client")
        net.WriteUInt(1, 4)
        
        local keys = table.GetKeys(RCD.NWVariables["networkEnt"])
        net.WriteUInt(#keys, 12)
        for _, ent in ipairs(keys) do

            net.WriteUInt(ent:EntIndex(), 32)
            local variableKeys = table.GetKeys(RCD.NWVariables["networkEnt"][ent])
            net.WriteUInt(#variableKeys, 4)
            for _, varName in ipairs(variableKeys) do
    
                local value = RCD.NWVariables["networkEnt"][ent][varName]
                local valueType = type(value)

                net.WriteString(valueType)
                net.WriteString(varName)
                net["Write"..RCD.TypeNet[valueType]](value, ((RCD.TypeNet[valueType] == "Int") and 32))
            end
        end
    net.Send(self)
end

--[[ Send a notification to the player ]]
function PLAYER:RCDNotification(time, text)
    local curtime = CurTime()

    self.RCD[text] = self.RCD[text] or 0
    if self.RCD[text] > curtime then return end
    self.RCD[text] = curtime + 0.5

    net.Start("RCD:Notification")
        net.WriteUInt(time, 3)
        net.WriteString(text)
    net.Send(self)
end

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:RCDAddMoney(price)
    if DarkRP then
        self:addMoney(price)
    elseif ix then
        if self:GetCharacter() != nil then
            local money = self:RCDGetMoney()
            self:GetCharacter():SetMoney(money + price)
        end
    elseif nut then
        if self:getChar() != nil then
            local money = self:RCDGetMoney()
            self:getChar():setMoney(money + price)
        end
    end
end

--[[ Compress vehicles table ]]
function RCD.RefreshCompressedVehicles()
    local vehiclesTable = RCD.GetVehicles() or {}
    RCD.CompressedVehiclesTable = util.Compress(util.TableToJSON(vehiclesTable))

    net.Start("RCD:Admin:Configuration")
        net.WriteUInt(5, 4)
        net.WriteUInt(#RCD.CompressedVehiclesTable, 32)
        net.WriteData(RCD.CompressedVehiclesTable, #RCD.CompressedVehiclesTable)
    net.Broadcast()
end

--[[ Compress groups table ]]
function RCD.RefreshCompressedGroups()
    local groupsTable = RCD.GetAllVehicleGroups() or {}
    RCD.CompressedGroupsTable = util.Compress(util.TableToJSON(groupsTable))

    net.Start("RCD:Admin:Configuration")
        net.WriteUInt(1, 4)
        net.WriteUInt(#RCD.CompressedGroupsTable, 32)
        net.WriteData(RCD.CompressedGroupsTable, #RCD.CompressedGroupsTable)
    net.Broadcast()
end

--[[ Send all vehicle to the player ]]
function PLAYER:RCDSendAllVehicles()
    net.Start("RCD:Admin:Configuration")
        net.WriteUInt(5, 4)
        net.WriteUInt(#RCD.CompressedVehiclesTable, 32)
        net.WriteData(RCD.CompressedVehiclesTable, #RCD.CompressedVehiclesTable)
    net.Send(self)
end

--[[ Send all vehicle groups to the player ]]
function PLAYER:RCDSendAllGroups()
    net.Start("RCD:Admin:Configuration")
        net.WriteUInt(1, 4)
        net.WriteUInt(#RCD.CompressedGroupsTable, 32)
        net.WriteData(RCD.CompressedGroupsTable, #RCD.CompressedGroupsTable)
    net.Send(self)
end

--[[ Set key owner ]]
function PLAYER:RCDSetkeysOwn(vehc)
    if not IsValid(vehc) then return end

    if DarkRP then
        vehc:keysOwn(self)
    elseif ix then
        vehc:SetOwner(self)
    end
end
