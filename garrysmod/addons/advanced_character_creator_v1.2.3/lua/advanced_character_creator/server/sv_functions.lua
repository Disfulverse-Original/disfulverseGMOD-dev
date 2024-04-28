--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

local PLAYER = FindMetaTable("Player")

-- [[ Mysql database connection system ]] --
local mysqlDB
ACC2.MysqlConnected = false

if ACC2.Mysql then
    local succ, err = pcall(function() require("mysqloo") end)
    if not succ then return print("[ACC2] Error with MYSQLOO") end
    
    if not mysqloo then
        return print("[ACC2] Cannot require mysqloo module :\n"..requireError)
    end

    mysqlDB = mysqloo.connect(ACC2.MysqlInformations["host"], ACC2.MysqlInformations["username"], ACC2.MysqlInformations["password"], ACC2.MysqlInformations["database"], {["port"] = ACC2.MysqlInformations["port"]})

    function mysqlDB:onConnected()  
        print("[ACC2] Succesfuly connected to the mysql database !")
        ACC2.MysqlConnected = true
    end
    
    function mysqlDB:onConnectionFailed(connectionError)
        print("[ACC2] Cannot etablish database connection :\n"..connectionError)
    end
    mysqlDB:connect()
end

--[[ SQL Query function ]] --
function ACC2.Query(query, callback)
    if not isstring(query) then return end

    local result = {}
    local isInsertQuery = string.StartWith(query, "INSERT")
    if ACC2.Mysql then
        query = mysqlDB:query(query)

        if callback == "wait" then
            query:start()
            query:wait()

            local err = query:error()
            if err == "" then
                return isInsertQuery and { lastInsertId = query:lastInsert() } or query:getData()
            else
                print("[ACC2] "..err)
            end
        else
            function query:onError(err, sql)
                print("[ACC2] "..err)
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

function PLAYER:ACC2PrecacheModels()
    if not ACC2.GetSetting("precacheModels", "boolean") then return end

    net.Start("ACC2:Character")
        net.WriteUInt(8, 4)
        net.WriteUInt(#ACC2.ModelsToPrecache, 32)
        for k, v in ipairs(ACC2.ModelsToPrecache) do
            net.WriteString(v)
        end
    net.Send(self)
end

-- [[ Escape the string ]] --  
function ACC2.Escape(str)
    return ACC2.MysqlConnected and ("'%s'"):format(mysqlDB:escape(tostring(str))) or SQLStr(str)    
end

--[[ Convert a string to a vector or an angle ]]
function ACC2.ToVectorOrAngle(toConvert, typeToSet)
    if not isstring(toConvert) or (typeToSet != Vector and typeToSet != Angle) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return typeToSet == Vector and Vector(x, y, z) or Angle(x, y, z)
end

--[[ Convert a string to a color ]]
function ACC2.ToColor(toConvert)
    if not isstring(toConvert) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return Color(x, y, z)
end

-- [[ Function to add a compatibility with autoincrement ]]
function ACC2.AutoIncrement()
    return (ACC2.Mysql and "AUTO_INCREMENT" or "AUTOINCREMENT")
end

--[[ Initialize all mysql/sql table ]]
function ACC2.InitializeTables()
    local autoIncrement = ACC2.AutoIncrement()
    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_settings(
            id INTEGER NOT NULL PRIMARY KEY %s,
            typeValue VARCHAR(64),
            keyName VARCHAR(100),
            value LONGTEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_compatibilities_import(
            name VARCHAR(64),
            imported BOOLEAN,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_faction_categories(
            id INTEGER NOT NULL PRIMARY KEY %s,
            name VARCHAR(100),
            logo VARCHAR(100),
            description VARCHAR(100),
            ranksAccess LONGTEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_factions(
            id INTEGER NOT NULL PRIMARY KEY %s,
            name VARCHAR(100),
            logo VARCHAR(100),
            description VARCHAR(100),
            groupId INT,
            models LONGTEXT,
            ranksAccess LONGTEXT,
            defaultJob VARCHAR(100),
            jobsAccess LONGTEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_whitelist(
            id INTEGER NOT NULL PRIMARY KEY %s,
            jobName VARCHAR(100),
            permissions LONGTEXT,
            whitelistEnable BOOLEAN,
            blacklistEnable BOOLEAN,
            defaultWhitelist BOOLEAN,
            defaultBlacklist BOOLEAN,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_whitelist_values(
            id INTEGER NOT NULL PRIMARY KEY %s,
            characterId INT,
            jobName VARCHAR(100),
            userGroup VARCHAR(100),
            whitelisted BOOLEAN,
            blacklisted BOOLEAN,
            ownerId64 VARCHAR(32),
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(characterId) REFERENCES acc2_characters(id) ON DELETE CASCADE
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_characters(
            id INTEGER NOT NULL PRIMARY KEY %s,
            ownerId64 VARCHAR(32),
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            deletedAt TIMESTAMP NULL
        );
    ]]):format(autoIncrement))

    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_characters_compatibilities(
            id INTEGER NOT NULL PRIMARY KEY %s,
            characterId INT NOT NULL,
            compatibilityName VARCHAR(64),
            typeValue VARCHAR(64),
            keyName VARCHAR(64),
            value LONGTEXT,
            ownerId64 VARCHAR(32),
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(characterId) REFERENCES acc2_characters(id) ON DELETE CASCADE
        );
    ]]):format(autoIncrement))
    
    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_compatibilities_transfert(
            id INTEGER NOT NULL PRIMARY KEY %s,
            compatibilityName VARCHAR(64),
            value BOOLEAN,
            ownerId64 VARCHAR(32),
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))
    
    ACC2.Query(([[
        CREATE TABLE IF NOT EXISTS acc2_npc(
            id INTEGER NOT NULL PRIMARY KEY %s,
            pos VARCHAR(150),
            ang VARCHAR(150),
            class VARCHAR(100),
            map VARCHAR(100),
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    ]]):format(autoIncrement))

    -- [[ Here you can find all query needed to update the addon of older version to newest version ]]

    timer.Simple(1, function()
        ACC2.CreateColumntIfNotExist("acc2_factions", "defaultJob", "VARCHAR(100)")

        ACC2.CreateColumntIfNotExist("acc2_settings", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_compatibilities_import", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_faction_categories", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_factions", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_whitelist", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_whitelist_values", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_characters", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_characters_compatibilities", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")
        ACC2.CreateColumntIfNotExist("acc2_compatibilities_transfert", "createdAt", "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP")

        ACC2.CreateColumntIfNotExist("acc2_characters", "deletedAt", "TIMESTAMP NULL")
    end)
end

// [[ Create a column if not exist ]]
function ACC2.CreateColumntIfNotExist(tblName, columnName, columnType)
    if not isstring(tblName) or not isstring(columnName) or not isstring(columnType) then return end

    if ACC2.Mysql then
        ACC2.Query(([[
            SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = '%s' AND COLUMN_NAME = '%s'
        ]]):format(tblName, columnName), function(tbl)
            if not istable(tbl) or #tbl == 0 then
                ACC2.Query(([[
                    ALTER TABLE %s ADD %s %s
                ]]):format(tblName, columnName, columnType))
            end
        end)
    else
        ACC2.Query(([[
            SELECT sql FROM sqlite_master WHERE tbl_name = "%s" AND sql LIKE '%%%s%%'
        ]]):format(tblName, columnName), function(tbl)
            if not istable(tbl) or #tbl == 0 then
                ACC2.Query(([[
                    ALTER TABLE %s ADD %s %s
                ]]):format(tblName, columnName, columnType))
            end
        end)
    end
end

--[[ Convert all value to be saved or to be reload ]]
function ACC2.ConvertValueWithType(typeValue, value)
    if typeValue == "boolean" then
        return tobool(value)
    elseif typeValue == "number" then
        return tonumber(value)
    elseif typeValue == "table" then
        return (istable(value) and util.TableToJSON(value) or util.JSONToTable(value))
    elseif typeValue == "string" then
        return tostring(value)
    elseif typeValue == "Vector" then
        return (isvector(value) and tostring(value) or ACC2.ToVectorOrAngle(value, Vector))
    elseif typeValue == "Angle" then
        return (isangle(value) and tostring(value) or ACC2.ToVectorOrAngle(value, Angle))
    elseif typeValue == "Color" then
        return (IsColor(value) and tostring(value) or ACC2.ToColor(value))
    end
    
    return false
end

--[[ Change whitelist settings ]]
function ACC2.ChangeWhitelistSettings(jobName, whitelistEnable, blacklistEnable, defaultWhitelist, defaultBlacklist, permissions)
    if not isstring(jobName) then return end
    ACC2.WhitelistSettings = ACC2.WhitelistSettings or {}

    permissions = permissions or {}
    local jsonPermissions = util.TableToJSON(permissions) or ""

    ACC2.Query(("SELECT * FROM acc2_whitelist WHERE jobName = %s"):format(ACC2.Escape(jobName)), function(settings)
        if not settings or #settings == 0 then
            ACC2.Query(("INSERT INTO acc2_whitelist (jobName, whitelistEnable, blacklistEnable, defaultWhitelist, defaultBlacklist, permissions) VALUES (%s, %s, %s, %s, %s, %s)"):format(
                ACC2.Escape(jobName), 
                (whitelistEnable and "1" or "0"), 
                (blacklistEnable and "1" or "0"),
                (defaultWhitelist and "1" or "0"),
                (defaultBlacklist and "1" or "0"),
                ACC2.Escape(jsonPermissions)
            ))
        else
            ACC2.Query(("UPDATE acc2_whitelist SET whitelistEnable = %s, blacklistEnable = %s, defaultWhitelist = %s, defaultBlacklist = %s, permissions = %s WHERE jobName = %s"):format(
                (whitelistEnable and "1" or "0"), 
                (blacklistEnable and "1" or "0"),
                (defaultWhitelist and "1" or "0"),
                (defaultBlacklist and "1" or "0"),
                ACC2.Escape(jsonPermissions),
                ACC2.Escape(jobName)
            ))
        end

        ACC2.WhitelistSettings[jobName] = {
            ["jobName"] = jobName,
            ["whitelistEnable"] = whitelistEnable,
            ["blacklistEnable"] = blacklistEnable,
            ["defaultWhitelist"] = defaultWhitelist,
            ["defaultBlacklist"] = defaultBlacklist,
            ["permissions"] = permissions,
        }

        ACC2.ValuesPermissions = ACC2.ValuesPermissions or {}
        for k, v in pairs(permissions) do
            if not v.canManageWhitelist && not v.canManageBlacklist then continue end

            ACC2.ValuesPermissions[k] = ACC2.ValuesPermissions[k] or {}
            ACC2.ValuesPermissions[k][jobName] = v
        end
        
        ACC2.SendWhitelistSettings()
    end)
end

--[[ Send all whitelist settings ]]
function ACC2.SendWhitelistSettings(ply)
    ACC2.WhitelistSettings = ACC2.WhitelistSettings or {}

    net.Start("ACC2:Admin:Configuration")
        net.WriteUInt(5, 4)
        net.WriteUInt(table.Count(ACC2.WhitelistSettings), 16)
        for k, v in pairs(ACC2.WhitelistSettings) do
            net.WriteString(v.jobName)
            net.WriteBool(v.whitelistEnable)
            net.WriteBool(v.blacklistEnable)
            net.WriteBool(v.defaultWhitelist)
            net.WriteBool(v.defaultBlacklist)

            net.WriteUInt(table.Count(v.permissions), 16)
            for k, v in pairs(v.permissions) do
                net.WriteString(k)
                net.WriteBool(v.canManageWhitelist)
                net.WriteBool(v.canManageBlacklist)
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Change whitelist players settings ]]
function ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, whitelisted, blacklisted, ply, manager, callback)
    characterId = tonumber(characterId)
    if not isstring(jobName) or not isnumber(characterId) then return end

    local queryParameters = ""
    if whitelisted != nil then
        queryParameters = ("whitelisted = %s"..((blacklisted != nil) and "," or "")):format(whitelisted and "1" or "0")
    end

    if blacklisted != nil then
        queryParameters = (queryParameters.."blacklisted = %s"):format(blacklisted and "1" or "0")
    end

    ACC2.Query(("SELECT * FROM acc2_whitelist_values WHERE jobName = %s AND characterId = %s AND ownerId64 = %s"):format(ACC2.Escape(jobName), ACC2.Escape(characterId), ACC2.Escape(steamId64)), function(settings)
        if not settings or #settings == 0 then
            ACC2.Query(("INSERT INTO acc2_whitelist_values (characterId, jobName, whitelisted, blacklisted, ownerId64) VALUES (%s, %s, %s, %s, %s)"):format(
                ACC2.Escape(characterId),
                ACC2.Escape(jobName), 
                whitelisted and "1" or "0",
                blacklisted and "1" or "0",
                ACC2.Escape(steamId64)
            ), function()
                if isfunction(callback) then callback() end
            end)
        else
            ACC2.Query(("UPDATE acc2_whitelist_values SET %s WHERE jobName = %s AND characterId = %s AND ownerId64 = %s"):format(
                queryParameters,
                ACC2.Escape(jobName),
                ACC2.Escape(characterId),
                ACC2.Escape(steamId64)
            ), function()
                if isfunction(callback) then callback() end
            end)
        end

        if IsValid(ply) then
            ply.ACC2 = ply.ACC2 or {}
            ply.ACC2["whitelistPlayers"] = ply.ACC2["whitelistPlayers"] or {}
            ply.ACC2["whitelistPlayers"][characterId] = ply.ACC2["whitelistPlayers"][characterId] or {}

            ply.ACC2["whitelistPlayers"][characterId][jobName] = ply.ACC2["whitelistPlayers"][characterId][jobName] or {}

            if whitelisted != nil then
                ply.ACC2["whitelistPlayers"][characterId][jobName]["whitelisted"] = whitelisted
            end

            if blacklisted != nil then
                ply.ACC2["whitelistPlayers"][characterId][jobName]["blacklisted"] = blacklisted
            end
        end

        hook.Run("ACC2:ChangePlayerWhitelistSettings", steamId64, characterId, jobName, whitelisted, blacklisted, ply, manager)
    end)
end

function ACC2.ChangeUserGroupsWhitelistSettings(userGroup, jobName, whitelisted, blacklisted)
    if not isstring(jobName) or not isstring(userGroup) then return end

    local queryParameters = ""
    if whitelisted != nil then
        queryParameters = "whitelisted = "..(whitelisted and "1" or "0")..(blacklisted and "," or "")
    end

    if blacklisted != nil then
        queryParameters = "blacklisted = "..(blacklisted and "1" or "0")
    end

    ACC2.UserGroupsWhitelistSettings = ACC2.UserGroupsWhitelistSettings or {}
    ACC2.UserGroupsWhitelistSettings["jobName"] = ACC2.UserGroupsWhitelistSettings["jobName"] or {}
    ACC2.UserGroupsWhitelistSettings["jobName"][userGroup] = ACC2.UserGroupsWhitelistSettings["jobName"][userGroup] or {}

    ACC2.Query(("SELECT * FROM acc2_whitelist_values WHERE jobName = %s AND userGroup = %s"):format(ACC2.Escape(jobName), ACC2.Escape(userGroup)), function(settings)
        if not settings or #settings == 0 then
            ACC2.Query(("INSERT INTO acc2_whitelist_values (jobName, userGroup, whitelisted, blacklisted) VALUES (%s, %s, %s, %s)"):format(
                ACC2.Escape(jobName), 
                ACC2.Escape(userGroup),
                whitelisted and "1" or "0", 
                blacklisted and "1" or "0"
            ))
        else
            ACC2.Query(("UPDATE acc2_whitelist_values SET %s WHERE jobName = %s AND userGroup = %s"):format(
                queryParameters,
                ACC2.Escape(jobName),
                ACC2.Escape(userGroup)
            ))
        end

        if whitelisted != nil then
            ACC2.UserGroupsWhitelistSettings["jobName"][userGroup]["whitelisted"] = (whitelisted == 1 and true or false)
        end

        if blacklisted != nil then
            ACC2.UserGroupsWhitelistSettings["jobName"][userGroup]["blacklisted"] = (blacklisted == 1 and true or false)
        end
    end)
end

--[[ Init all whitelist settings ]]
function ACC2.InitializeWhitelistSettings()
    ACC2.WhitelistSettings = {}
    ACC2.ValuesPermissions = {}

    ACC2.Query("SELECT * FROM acc2_whitelist", function(settings)
        if not istable(settings) then return end
        
        for k, v in pairs(settings) do
            local jobName = v.jobName
            local permissions = (util.JSONToTable(v.permissions) or {})
            
            ACC2.WhitelistSettings[jobName] = {
                ["jobName"] = jobName,
                ["whitelistEnable"] = tobool(v.whitelistEnable),
                ["blacklistEnable"] = tobool(v.blacklistEnable),
                ["defaultWhitelist"] = tobool(v.defaultWhitelist),
                ["defaultBlacklist"] = tobool(v.defaultBlacklist),
                ["permissions"] = permissions,
            }

            for k, v in pairs(permissions) do
                if not v.canManageWhitelist && not v.canManageBlacklist then continue end

                ACC2.ValuesPermissions[k] = ACC2.ValuesPermissions[k] or {}
                ACC2.ValuesPermissions[k][jobName] = v
            end
        end
        
        ACC2.SendWhitelistSettings()
    end)
end

--[[ Intiialize Whitelist of usergroups ]]
function ACC2.InizializeWhitelistUserGroups()
    ACC2.UserGroupsWhitelistSettings = {}

    ACC2.Query("SELECT * FROM acc2_whitelist_values WHERE userGroup != 'NULL'", function(settings)
        if not istable(settings) then return end
            
        for k, v in pairs(settings) do
            ACC2.UserGroupsWhitelistSettings[v.jobName] = ACC2.UserGroupsWhitelistSettings[v.jobName] or {}
            ACC2.UserGroupsWhitelistSettings[v.jobName][v.userGroup] = {
                ["whitelisted"] = v.whitelisted == 1 and true or false,
                ["blacklisted"] = v.blacklisted == 1 and true or false,
            }
        end
    end)
end

--[[ Initialize whitelist/blacklist of the player ]]
function PLAYER:ACC2InitializeWhitelist()
    self.ACC2 = self.ACC2 or {}
    self.ACC2["whitelistPlayers"] = self.ACC2["whitelistPlayers"] or {}
    
    ACC2.Query("SELECT * FROM acc2_whitelist_values WHERE characterId != 'NULL'", function(whitelist)
        if not istable(whitelist) then return end
        
        for k, v in pairs(whitelist) do
            local characterId = tonumber(v.characterId)
            if not isnumber(characterId) then continue end
 
            self.ACC2["whitelistPlayers"][characterId] = self.ACC2["whitelistPlayers"][characterId] or {}

            self.ACC2["whitelistPlayers"][characterId][v.jobName] = {
                ["whitelisted"] = v.whitelisted,
                ["blacklisted"] = v.blacklisted,
            }
        end
    end)
end

--[[ Check if the player is whitelisted ]]
function ACC2.IsWhitelisted(characterId, jobName, callback)
    characterId = tonumber(characterId)
    if not isnumber(characterId) then return end

    ACC2.Query(("SELECT * FROM acc2_whitelist_values WHERE characterId = %s AND jobName = %s AND whitelisted = 1"):format(ACC2.Escape(characterId), ACC2.Escape(jobName)), function(whitelist)
        if isfunction(callback) then 
            callback(istable(whitelist))
        end
    end)
end

--[[ Check if the player is blacklisted ]]
function ACC2.IsBlacklisted(characterId, jobName, callback)
    characterId = tonumber(characterId)
    if not isnumber(characterId) then return end

    ACC2.Query(("SELECT * FROM acc2_whitelist_values WHERE characterId = %s AND jobName = %s AND blacklisted = 1"):format(ACC2.Escape(characterId), ACC2.Escape(jobName)), function(whitelist)
        if isfunction(callback) then 
            callback(istable(whitelist))
        end
    end)
end

function PLAYER:ACC2OpenWhitelistMenu()
    local canOpen = hook.Run("ACC2:CanOpenWhitelistMenu")
    if canOpen == false then return end

    net.Start("ACC2:Admin:Configuration")
        net.WriteUInt(6, 4)
    net.Send(self)
end

function ACC2.SelectWhitelistPage(whitelistType, page, ply, jobName)
    if not IsValid(ply) then return end

    page = page or 0
    page = (page <= 0 and 0 or (page-1))
    
    local offset = page*ACC2.MaxPerPage

    ACC2.GetWhitelistData(function(whitelistData, countValues)
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(7, 4)
            net.WriteUInt(table.Count(whitelistData), 6)
            net.WriteUInt(countValues, 32)
            net.WriteUInt(page, 16)
            net.WriteString(whitelistType)
            net.WriteString(jobName)

            local whitelistedTbl = {}
            for k, v in ipairs(whitelistData) do
                net.WriteString((v.ownerId64 or ""))
                net.WriteString(((v.globalName == "NULL" or not v.globalName) and v.userGroup or v.globalName))
                net.WriteUInt((((v.characterId == "NULL" or not v.characterId) and v.id or v.characterId) or 0), 22)

                if v.userGroup != "NULL" and v.userGroup then
                    if whitelistType == "whitelisted" then
                        if v.whitelisted then
                            whitelistedTbl[#whitelistedTbl + 1] = {
                                ["value"] = v.userGroup,
                            }
                        end
                    elseif whitelistType == "blacklisted" then
                        if v.blacklisted then
                            whitelistedTbl[#whitelistedTbl + 1] = {
                                ["value"] = v.userGroup,
                            }
                        end
                    end
                end
            end
            for k, v in ipairs(player.GetAll()) do
                local characterId = ACC2.GetNWVariables("characterId", v)
                if not isnumber(characterId) then continue end

                v.ACC2 = v.ACC2 or {}
                v.ACC2["whitelistPlayers"] = v.ACC2["whitelistPlayers"] or {}
                v.ACC2["whitelistPlayers"][characterId] = v.ACC2["whitelistPlayers"][characterId] or {}
                v.ACC2["whitelistPlayers"][characterId][jobName] = v.ACC2["whitelistPlayers"][characterId][jobName] or {}
                
                local value = false
                if whitelistType == "whitelisted" then
                    value = v.ACC2["whitelistPlayers"][characterId][jobName]["whitelisted"]
                elseif whitelistType == "blacklisted" then
                    value = v.ACC2["whitelistPlayers"][characterId][jobName]["blacklisted"]
                end
                if not value then continue end
    
                whitelistedTbl[#whitelistedTbl + 1] = {
                    ["value"] = v:SteamID64(),
                }
            end
            net.WriteUInt(#whitelistedTbl, 8)
            for k, v in ipairs(whitelistedTbl) do
                net.WriteString(v.value)
            end
        net.Send(ply)
    end, offset, whitelistType, jobName)
end

function ACC2.GetWhitelistData(callback, offset, whitelistType, jobName)
    local jobNameQuery = (isstring(jobName) and ("AND jobName = %s"):format(ACC2.Escape(jobName)) or "")
    ACC2.Query(([[
        SELECT blacklisted, whitelisted, acc2_whitelist_values.id, acc2_whitelist_values.characterId, userGroup, 
        jobName, acc2_whitelist_values.ownerId64, `value` AS globalName 
        FROM acc2_whitelist_values 
        LEFT JOIN acc2_characters_compatibilities 
            ON acc2_characters_compatibilities.characterId = acc2_whitelist_values.characterId AND acc2_characters_compatibilities.compatibilityName = 'ACC2:Characters' 
            AND acc2_characters_compatibilities.keyName = 'globalName'
        INNER JOIN acc2_characters 
            ON acc2_characters.id = acc2_whitelist_values.characterId
        WHERE acc2_characters.deletedAt IS NULL AND acc2_whitelist_values.%s = 1 %s
        ORDER BY userGroup, acc2_whitelist_values.id
        LIMIT %s OFFSET %s;
        ]]):format(
            whitelistType, 
            jobNameQuery, 
            ACC2.MaxPerPage, 
            offset
        ),
        function(whitelistData)
            ACC2.Query(([[SELECT COUNT(*) AS count FROM acc2_whitelist_values WHERE %s = '1' %s]]):format(whitelistType, jobNameQuery), function(countTable)
                local countValues = countTable and countTable["count"]
        
                if not isnumber(countValues) then
                    if countTable[1] && countTable[1]["count"] then
                        countValues = tonumber(countTable[1]["count"])
                    end
                end
        
                if not isnumber(countValues) then
                    countValues = 0
                end

                callback(whitelistData or {}, countValues)
            end)
        end
    )
end

--[[ Create NPC ]]
function ACC2.CreateNPC(pos, ang, class)
    if not isvector(pos) then return end
    if not isangle(ang) then return end

    local map = string.lower(game.GetMap())

    pos = tostring(pos)
    ang = tostring(ang)

    ACC2.Query(("INSERT INTO acc2_npc (pos, ang, class, map) VALUES (%s, %s, %s, %s)"):format(ACC2.Escape(tostring(pos)), ACC2.Escape(tostring(ang)), ACC2.Escape(class), ACC2.Escape(map)), function(tbl)
        local npcId = tonumber(tbl["lastInsertId"])

        ACC2.CreateNPCEntity(pos, ang, class, npcId)
    end)
end

--[[ Create NPC entity ]]
function ACC2.CreateNPCEntity(pos, ang, class, npcId)
    if not isnumber(npcId) then return end
    if not isstring(class) then return end

    pos = ACC2.ToVectorOrAngle(pos, Vector)
    if not isvector(pos) then return end

    ang = ACC2.ToVectorOrAngle(ang, Angle)
    if not isangle(ang) then return end

    ACC2.Entity = ACC2.Entity or {}
    ACC2.Entity["npc"] = ACC2.Entity["npc"] or {}

    local npc = ents.Create(class)
    if not IsValid(npc) then return end
    
    npc:SetPos(pos)
    npc:SetAngles(ang)
    npc:Spawn()
    npc:Activate()
    npc.ACC2NPCId = npcId

    ACC2.Entity["npc"][#ACC2.Entity["npc"] + 1] = npc
end

--[[ Reload all entity on the server ]]
function ACC2.LoadNPC()
    ACC2.Entity = ACC2.Entity or {}
    ACC2.Entity["npc"] = ACC2.Entity["npc"] or {}

    ACC2.RemoveAllNPC()

    local map = string.lower(game.GetMap())
    ACC2.Query(("SELECT * FROM acc2_npc WHERE map = %s"):format(ACC2.Escape(map)), function(npcTable)
        npcTable = npcTable or {}

        for k, v in ipairs(npcTable) do
            ACC2.CreateNPCEntity(v.pos, v.ang, v.class, tonumber(v.id))
        end 
    end)
end

--[[ Remove a NPC with his id on the server ]]
function ACC2.RemoveNPC(npcId, deleteDb)
    if not isnumber(npcId) then return end

    if deleteDb then    
        ACC2.Query(("DELETE FROM acc2_npc WHERE id = %s"):format(ACC2.Escape(npcId)))
    end

    for k, v in ipairs(ACC2.Entity["npc"]) do
        if not IsValid(v) or v.ACC2NPCId != npcId then continue end

        v:Remove()
    end
end

--[[ Remove all entity on the server ]]
function ACC2.RemoveAllNPC()
    ACC2.Entity = ACC2.Entity or {}
    ACC2.Entity["npc"] = ACC2.Entity["npc"] or {}

    for k,v in ipairs(ACC2.Entity["npc"]) do
        if not IsValid(v) then continue end

        v:Remove()
    end
end

--[[ Intialize settings of the addon ]]
function ACC2.InitializeSettings(callback)
    for k, v in pairs(ACC2.DefaultSettings) do
        local value = ACC2.ConvertValueWithType(type(v), v)

        ACC2.Query(("SELECT * FROM acc2_settings WHERE keyName = %s"):format(ACC2.Escape(k)), function(settings)
            if not settings or #settings == 0 then
                ACC2.Query(("INSERT INTO acc2_settings (typeValue, keyName, value) VALUES (%s, %s, %s)"):format(ACC2.Escape(type(v)), ACC2.Escape(k), ACC2.Escape(value)))
            end
        end)
    end
    
    timer.Simple(3, function()
        ACC2.Query("SELECT * FROM acc2_settings", function(settings)
            for k, v in pairs(settings) do
                ACC2.DefaultSettings[v.keyName] = ACC2.ConvertValueWithType(v.typeValue, v.value)
            end

            if isfunction(callback) then callback() end
        end)
    end)
end

--[[ Set Settings on the table ]]
function ACC2.SetSettings(settings)
    if not istable(settings) then return end
    
    for k, v in pairs(settings) do
        local typeValue = type(v)
        if typeValue != type(ACC2.DefaultSettings[k]) then continue end

        if ACC2.DefaultSettings[k] == nil or ACC2.DefaultSettings[k] != v then
            local valueToSave = ACC2.ConvertValueWithType(typeValue, v)
            
            ACC2.Query(("UPDATE acc2_settings SET typeValue = %s, value = %s WHERE keyName = %s"):format(ACC2.Escape(typeValue), ACC2.Escape(valueToSave), ACC2.Escape(k)))
        end
        
        ACC2.DefaultSettings[k] = v
    end

    ACC2.SendSettings()
end

--[[ Send all settings to the player on the client ]]
function ACC2.SendSettings(ply)
    net.Start("ACC2:Admin:Configuration")
        net.WriteUInt(1, 4)
        net.WriteUInt(table.Count(ACC2.DefaultSettings), 12)
        for k,v in pairs(ACC2.DefaultSettings) do
            local valueType = type(v)

            net.WriteString(valueType)
            net.WriteString(k)
            net["Write"..ACC2.TypeNet[valueType]](v, ((ACC2.TypeNet[valueType] == "Int") and 32))
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ This function permit to create variables on whatever you want networked with all players ]]
function ACC2.SetNWVariable(key, value, ent, send, ply, sync)
    if not IsValid(ent) or not isstring(key) then return end

    ACC2.NWVariables = ACC2.NWVariables or {}

    ent.ACC2NWVariables = ent.ACC2NWVariables or {}
    ent.ACC2NWVariables[key] = value
    
    if sync then
        ACC2.NWVariables["networkEnt"] = ACC2.NWVariables["networkEnt"] or {}
        ACC2.NWVariables["networkEnt"][ent] = ent.ACC2NWVariables

        ent:CallOnRemove("acc2_reset_variables:"..ent:EntIndex(), function(ent) ACC2.NWVariables["networkEnt"][ent] = nil end) 
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

    if send then
        ACC2.SyncNWVariable(key, ent, ply)
    end
end

--[[ Sync variable to the clientside or to everyone ]]
function ACC2.SyncNWVariable(key, ent, ply)
    if not IsValid(ent) or not isstring(key) then return end

    ent.ACC2NWVariables = ent.ACC2NWVariables or {}
    
    local value = ent.ACC2NWVariables[key]
    if value == nil then return end

    local valueType = type(value)

    net.Start("ACC2:MainNet")
        net.WriteUInt(5, 5)
        net.WriteUInt(1, 12)
        net.WriteUInt(ent:EntIndex(), 32)
        net.WriteUInt(1, 4)
        net.WriteString(valueType)
        net.WriteString(key)
        net["Write"..ACC2.TypeNet[valueType]](value, ((ACC2.TypeNet[valueType] == "Int") and 32))
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Sync all variables needed client side ]]
function PLAYER:ACC2SyncAllVariables()
    ACC2.NWVariables = ACC2.NWVariables or {}
    ACC2.NWVariables["networkEnt"] = ACC2.NWVariables["networkEnt"] or {}
    
    net.Start("ACC2:MainNet")
        net.WriteUInt(5, 5)
        
        local keys = table.GetKeys(ACC2.NWVariables["networkEnt"])
        net.WriteUInt(#keys, 12)
        for _, ent in ipairs(keys) do

            net.WriteUInt(ent:EntIndex(), 32)
            local variableKeys = table.GetKeys(ACC2.NWVariables["networkEnt"][ent])
            net.WriteUInt(#variableKeys, 4)
            for _, varName in ipairs(variableKeys) do
    
                local value = ACC2.NWVariables["networkEnt"][ent][varName]
                local valueType = type(value)

                net.WriteString(valueType)
                net.WriteString(varName)
                net["Write"..ACC2.TypeNet[valueType]](value, ((ACC2.TypeNet[valueType] == "Int") and 32))
            end
        end
    net.Send(self)
end

--[[ Send a notification to the player ]]
function PLAYER:ACC2Notification(time, text)
    local curtime = CurTime()

    self.ACC2[text] = self.ACC2[text] or 0
    if self.ACC2[text] > curtime then return end
    self.ACC2[text] = curtime + 0.5

    net.Start("ACC2:Notification")
        net.WriteUInt(time, 3)
        net.WriteString(text)
    net.Send(self)
end

-- [[ Init all factions ]]
function ACC2.InitializeFactions()
    ACC2.Factions = {}

    ACC2.Query("SELECT * FROM acc2_factions", function(factionsTable)
        if not istable(factionsTable) then return end
        
        for k, factionTable in pairs(factionsTable) do
            local factionUniqueId = tonumber(factionTable["id"])
            if not isnumber(factionUniqueId) then continue end

            ACC2.Factions[factionUniqueId] = ACC2.Factions[factionUniqueId] or {}

            local models = util.JSONToTable((factionTable["models"] or {}))

            ACC2.Factions[factionUniqueId] = {
                ["name"] = factionTable["name"],
                ["logo"] = factionTable["logo"],
                ["description"] = factionTable["description"],
                ["defaultJob"] = factionTable["defaultJob"],
                ["groupId"] = tonumber(factionTable["groupId"]),
                ["models"] = util.JSONToTable((factionTable["models"] or {})),
                ["ranksAccess"] = util.JSONToTable((factionTable["ranksAccess"] or {})),
                ["jobsAccess"] = util.JSONToTable((factionTable["jobsAccess"] or {})),
                ["factionUniqueId"] = factionUniqueId,
            }
            
            if ACC2.GetSetting("precacheModels", "boolean") then
                for k, v in ipairs(models) do
                    util.PrecacheModel(k)

                    ACC2.ModelsToPrecache = ACC2.ModelsToPrecache or {}
                    ACC2.ModelsToPrecache[#ACC2.ModelsToPrecache + 1] = k
                end
            end
        end

        ACC2.SendFaction(nil, nil, true)
    end)
end

--[[ Create a new faction ]]
function ACC2.CreateFaction(ply, name, logo, description, defaultJob, groupId, models, ranksAccess, jobsAccess)
    ACC2.Factions = ACC2.Factions or {}
    
    local modelsToSave = util.TableToJSON(models) or ""
    local ranksAccessToSave = util.TableToJSON(ranksAccess) or ""
    local jobsAccessToSave = util.TableToJSON(jobsAccess) or ""
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

    ACC2.Query(("INSERT INTO acc2_factions (name, logo, description, defaultJob, groupId, models, ranksAccess, jobsAccess) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"):format(ACC2.Escape(name), ACC2.Escape(logo), ACC2.Escape(description), ACC2.Escape(defaultJob), ACC2.Escape(groupId), ACC2.Escape(modelsToSave), ACC2.Escape(ranksAccessToSave), ACC2.Escape(jobsAccessToSave)), function(tbl)
        local factionUniqueId = tonumber(tbl["lastInsertId"])

        ACC2.Factions[factionUniqueId] = {
            ["name"] = name,
            ["logo"] = logo,
            ["description"] = description,
            ["defaultJob"] = defaultJob,
            ["groupId"] = tonumber(groupId),
            ["models"] = models,
            ["ranksAccess"] = ranksAccess,
            ["jobsAccess"] = jobsAccess,
            ["factionUniqueId"] = factionUniqueId,
        }

        ACC2.SendFaction(factionUniqueId)

        if IsValid(ply) then
            ply:ACC2Notification(5, ACC2.GetSentence("createFactionNotify"):format(name))

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
            net.Send(ply)
        end
    end)
end

--[[ Update existing faction ]]
function ACC2.UpdateFaction(ply, factionUniqueId, name, logo, description, defaultJob, groupId, models, ranksAccess, jobsAccess)
    if not isnumber(factionUniqueId) then return end
    ACC2.Factions = ACC2.Factions or {}
    
    local modelsToSave = util.TableToJSON(models) or ""
    local ranksAccessToSave = util.TableToJSON(ranksAccess) or ""
    local jobsAccessToSave = util.TableToJSON(jobsAccess) or ""

    ACC2.Query(("UPDATE acc2_factions SET name = %s, logo = %s, description = %s, defaultJob = %s, groupId = %s, models = %s, ranksAccess = %s, jobsAccess = %s WHERE id = %s"):format(ACC2.Escape(name), ACC2.Escape(logo), ACC2.Escape(description), ACC2.Escape(defaultJob), ACC2.Escape(groupId), ACC2.Escape(modelsToSave), ACC2.Escape(ranksAccessToSave), ACC2.Escape(jobsAccessToSave), ACC2.Escape(factionUniqueId)), function()
        ACC2.Factions[factionUniqueId] = {
            ["name"] = name,
            ["logo"] = logo,
            ["description"] = description,
            ["defaultJob"] = defaultJob,
            ["groupId"] = tonumber(groupId),
            ["models"] = models,
            ["ranksAccess"] = ranksAccess,
            ["jobsAccess"] = jobsAccess,
            ["factionUniqueId"] = factionUniqueId,
        }

        ACC2.SendFaction(factionUniqueId)

        if IsValid(ply) then
            ply:ACC2Notification(5, ACC2.GetSentence("updatedFactionNotify"):format(name))

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
            net.Send(ply)
        end
    end)
end

--[[ Send one or all factions for one or all players ]]
function ACC2.SendFaction(factionUniqueId, ply, reset)
    ACC2.Factions = ACC2.Factions or {}

    local sendOneFaction = isnumber(factionUniqueId)
    local factionCount = (sendOneFaction and 1 or table.Count(ACC2.Factions))

    net.Start("ACC2:MainNet")
        net.WriteUInt(1, 5)
        net.WriteBool(reset)
        net.WriteUInt(factionCount, 16)
        
        local tableToLoop = {}
        if sendOneFaction then
            tableToLoop = {
                [factionUniqueId] = (ACC2.Factions[factionUniqueId] or {})
            }
        else
            tableToLoop = ACC2.Factions
        end

        for factionUniqueId, _ in pairs(tableToLoop) do
            net.WriteUInt(table.Count(ACC2.Factions[factionUniqueId]), 16)
            net.WriteUInt(factionUniqueId, 16)

            for k, v in pairs(ACC2.Factions[factionUniqueId]) do
                local valueType = (IsColor(v) and "color" or type(v))
                
                net.WriteString(valueType)
                net.WriteString(k)
    
                net["Write"..ACC2.TypeNet[valueType]](v, ((ACC2.TypeNet[valueType] == "Int") and 32))
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Remove faction ]]
function ACC2.RemoveFaction(ply, factionUniqueId)
    ACC2.Query(("DELETE FROM acc2_factions WHERE id = %s"):format(ACC2.Escape(factionUniqueId)), function()
        ACC2.Factions[factionUniqueId] = nil

        net.Start("ACC2:MainNet")
            net.WriteUInt(2, 5)
            net.WriteUInt(factionUniqueId, 16)
        if IsValid(ply) then
            net.Send(ply) 

            ply:ACC2Notification(5, ACC2.GetSentence("deleteFactionNotify"):format(factionUniqueId))

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
            net.Send(ply)
        else 
            net.Broadcast() 
        end
    end)
end

--[[ Init all factions categories ]]
function ACC2.InitializeCategories()
    ACC2.Categories = {}

    ACC2.Query("SELECT * FROM acc2_faction_categories", function(categoryTable)
        if not istable(categoryTable) then return end

        for k, categoryTable in pairs(categoryTable) do
            local categoryUniqueId = tonumber(categoryTable["id"])
            if not isnumber(categoryUniqueId) then continue end

            ACC2.Categories[categoryUniqueId] = ACC2.Categories[categoryUniqueId] or {}

            ACC2.Categories[categoryUniqueId] = {
                ["name"] = categoryTable["name"],
                ["logo"] = categoryTable["logo"],
                ["description"] = categoryTable["description"],
                ["ranksAccess"] = util.JSONToTable((categoryTable["ranksAccess"] or {})),
                ["categoryUniqueId"] = categoryUniqueId,
            }
        end

        ACC2.SendCategory(nil, nil, true)
    end)
end

--[[ Create a new faction category]]
function ACC2.CreateCategory(ply, name, logo, description, ranksAccess)
    ACC2.Categories = ACC2.Categories or {}
    
    local ranksAccessToSave = util.TableToJSON(ranksAccess) or ""

    ACC2.Query(("INSERT INTO acc2_faction_categories (name, logo, description, ranksAccess) VALUES (%s, %s, %s, %s)"):format(ACC2.Escape(name), ACC2.Escape(logo), ACC2.Escape(description), ACC2.Escape(ranksAccessToSave)), function(tbl)
        categoryUniqueId = tonumber(tbl["lastInsertId"])

        ACC2.Categories[categoryUniqueId] = {
            ["name"] = name,
            ["logo"] = logo,
            ["description"] = description,
            ["ranksAccess"] = ranksAccess,
            ["categoryUniqueId"] = categoryUniqueId,
        }

        ACC2.SendCategory(categoryUniqueId)

        if IsValid(ply) then
            ply:ACC2Notification(5, ACC2.GetSentence("createCategoryNotify"):format(name))

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
            net.Send(ply)
        end
    end)
end

--[[ Update a faction category ]]
function ACC2.UpdateCategory(ply, categoryUniqueId, name, logo, description, ranksAccess)
    if not isnumber(categoryUniqueId) then return end
    ACC2.Categories = ACC2.Categories or {}
    
    local ranksAccessToSave = util.TableToJSON(ranksAccess) or ""

    ACC2.Query(("UPDATE acc2_faction_categories SET name = %s, logo = %s, description = %s, ranksAccess = %s WHERE id = %s"):format(ACC2.Escape(name), ACC2.Escape(logo), ACC2.Escape(description), ACC2.Escape(ranksAccessToSave), ACC2.Escape(categoryUniqueId)), function()
        ACC2.Categories[categoryUniqueId] = {
            ["name"] = name,
            ["logo"] = logo,
            ["description"] = description,
            ["ranksAccess"] = ranksAccess,
            ["categoryUniqueId"] = categoryUniqueId,
        }

        ACC2.SendCategory(categoryUniqueId)

        if IsValid(ply) then
            ply:ACC2Notification(5, ACC2.GetSentence("updateCategoryNotify"):format(name))

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
            net.Send(ply)
        end
    end)
end

--[[ Send one or all factions categories ]]
function ACC2.SendCategory(categoryUniqueId, ply, reset)
    ACC2.Categories = ACC2.Categories or {}

    local sendOneFaction = isnumber(categoryUniqueId)
    local categoryCount = (sendOneFaction and 1 or table.Count(ACC2.Categories))

    net.Start("ACC2:MainNet")
        net.WriteUInt(3, 5)
        net.WriteBool(reset)
        net.WriteUInt(categoryCount, 16)
        
        local tableToLoop = {}
        if sendOneFaction then
            tableToLoop = {
                [categoryUniqueId] = (ACC2.Categories[categoryUniqueId] or {})
            }
        else
            tableToLoop = ACC2.Categories
        end

        for categoryUniqueId, _ in pairs(tableToLoop) do
            net.WriteUInt(table.Count(ACC2.Categories[categoryUniqueId]), 16)
            net.WriteUInt(categoryUniqueId, 16)

            for k, v in pairs(ACC2.Categories[categoryUniqueId]) do
                local valueType = (IsColor(v) and "color" or type(v))
                
                net.WriteString(valueType)
                net.WriteString(k)
    
                net["Write"..ACC2.TypeNet[valueType]](v, ((ACC2.TypeNet[valueType] == "Int") and 32))
            end
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Remove a faction category ]]
function ACC2.RemoveCategory(ply, categoryUniqueId)
    ACC2.Query(("DELETE FROM acc2_faction_categories WHERE id = %s"):format(ACC2.Escape(categoryUniqueId)), function()
        ACC2.Categories[categoryUniqueId] = nil
        
        net.Start("ACC2:MainNet")
            net.WriteUInt(4, 5)
            net.WriteUInt(categoryUniqueId, 16)
        if IsValid(ply) then
            net.Send(ply) 

            ply:ACC2Notification(5, ACC2.GetSentence("deleteCategoryNotify"):format(categoryUniqueId))

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
            net.Send(ply)
        else 
            net.Broadcast()
        end
    end)
end

--[[ Check if the model is on a table ]]
function ACC2.CheckModelOnTable(model, factionId)
    if isnumber(factionId) && factionId != 0 then
        local faction = ACC2.Factions[factionId]
        if not istable(faction) then return false end

        local models = faction["models"]
        if not istable(models) then return false end

        for k, v in pairs(models) do
            if (v == true) && (k == model) then return true end 
        end
        
        return false
    else
        local defaultModelGroup1 = ACC2.GetSetting("defaultModelGroup1", "table")
        local defaultModelGroup2 = ACC2.GetSetting("defaultModelGroup2", "table")

        local tableMerge = table.Merge(defaultModelGroup1, defaultModelGroup2)

        for k, v in pairs(tableMerge) do
            if (v == true) && (k == model) then return true end 
        end

        return false
    end
end

ACC2.Compatibilities = ACC2.Compatibilities or {}
ACC2.Compatibilities["data"] = ACC2.Compatibilities["data"] or {}

--[[ Get value of a specific compatibility name ]]
function ACC2.GetCompatibilityValue(compatibilityName, characterId, callback)
    characterId = tonumber(characterId)
    if not isnumber(characterId) then return end

    ACC2.Query(([[SELECT * FROM acc2_characters_compatibilities WHERE compatibilityName = %s AND characterId = %s]]):format(ACC2.Escape(compatibilityName), ACC2.Escape(characterId)), function(result) 
        local data = {}
        result = result or {}

        for k, v in ipairs(result) do
            local value = v.value

            if v.typeValue == "number" then
                value = tonumber(value)
            end

            data[v.keyName] = value
        end

        callback(data)
    end)
end

function ACC2.SendCompatibilities(ply)
    ACC2.CompatibilitiesToSend = ACC2.CompatibilitiesToSend or {}

    net.Start("ACC2:Admin:Configuration")
        net.WriteUInt(9, 4)
        net.WriteUInt(table.Count(ACC2.CompatibilitiesToSend), 8)
        for k, v in pairs(ACC2.CompatibilitiesToSend) do 
            net.WriteString(k)
        end
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end
end

--[[ Register restore and save compatibility]]
function ACC2.RegisterCompatibility(uniqueName, saveFunc, restoreFunc, check, cannotDisable)
    if not check then
        print(uniqueName.." compatibility doesn't work on your server")
        return
    end
    
    --[[ When we register a compatibility add it to all hooks that it use for save func ]]
    for hookName, func in pairs(saveFunc) do
        ACC2.Compatibilities["data"][hookName.."_save"] = ACC2.Compatibilities["data"][hookName.."_save"] or {}
        ACC2.Compatibilities["data"][hookName.."_save"][uniqueName] = {
            ["func"] = func,
            ["type"] = "save",
            ["cannotDisable"] = cannotDisable,
        }
    end

    --[[ When we register a compatibility add it to all hooks that it use for restore func ]]
    for hookName, func in pairs(restoreFunc) do
        ACC2.Compatibilities["data"][hookName.."_restore"] = ACC2.Compatibilities["data"][hookName.."_restore"] or {}
        ACC2.Compatibilities["data"][hookName.."_restore"][uniqueName] = {
            ["func"] = func,
            ["type"] = "restore",
            ["cannotDisable"] = cannotDisable,
        }
    end

    if not cannotDisable then
        ACC2.CompatibilitiesToSend = ACC2.CompatibilitiesToSend or {}
        ACC2.CompatibilitiesToSend[uniqueName] = true

        ACC2.DefaultSettings[uniqueName] = ACC2.DefaultSettings[uniqueName] or false
    end

    ACC2.SendCompatibilities()
    
    --[[ Create all hooks ]]
    for hookName, functions in pairs(ACC2.Compatibilities["data"]) do

        --[[ Get the real name of the hook I need to do that to avoid a problem when we have the same hook on restore and save ]]
        local realHookName = string.EndsWith(hookName, "_save") and hookName:sub(1, (#hookName-5)) or hookName:sub(1, (#hookName-8))

        --[[ Init the hook with a custom name]]
        hook.Add(realHookName, "ACC2:Compatibility:"..hookName, function(...)
            
            --[[ Call all functions of all compatibilities ]]
            for uniqueName, compatibilityTable in pairs(functions) do
                if not isfunction(compatibilityTable.func) then continue end
                if not ACC2.GetSetting(uniqueName, "boolean") && not compatibilityTable.cannotDisable then continue end
                
                if compatibilityTable.type == "save" then
                    local returnTable = compatibilityTable.func(...)
                    if not istable(returnTable) then continue end
                    
                    if not isnumber(returnTable["characterId"]) then
                        print(("[ACC2] Compatibility name %s need the character id"):format(uniqueName))
                        continue
                    end

                    if not isstring(returnTable["ownerId64"]) then
                        print(("[ACC2] Compatibility name %s need the steamId"):format(uniqueName))
                        continue
                    end
                    
                    ACC2.SaveCompatibilityData(returnTable, uniqueName)
                elseif compatibilityTable.type == "restore" then
                    local returnValue = compatibilityTable.func(...)

                    if returnValue != nil then
                        return returnValue
                    end
                end
            end
        end)
    end
end

--[[ Save compatibility by data ]]
function ACC2.SaveCompatibilityData(returnTable, uniqueName)
    if not isstring(uniqueName) then return end

    if not isnumber(returnTable["characterId"]) then
        print(("[ACC2] Compatibility name %s need the character id"):format(uniqueName))
        return 
    end

    if not isstring(returnTable["ownerId64"]) then
        print(("[ACC2] Compatibility name %s need the steamId"):format(uniqueName))
        return
    end

    local ply = player.GetBySteamID64(returnTable["ownerId64"])

    for key, value in pairs(returnTable) do
        local typeValue = type(value)

        if typeValue == "table" then
            value = util.TableToJSON(value)
        end

        ACC2.SaveCompatibility(returnTable["characterId"], returnTable["ownerId64"], uniqueName, typeValue, value, key, ply)
    end
end

--[[ Save compatibility value linked to a character id ]]
function ACC2.SaveCompatibility(characterId, ownerId64, compatibilityName, typeValue, value, keyName, ply)
    if keyName == "ownerId64" or keyName == "characterId" then return end
    
    if IsValid(ply) then
        ply.ACC2 = ply.ACC2 or {}
        ply.ACC2["characters"] = ply.ACC2["characters"] or {}
        ply.ACC2["characters"][characterId] = ply.ACC2["characters"][characterId] or {}
        
        ply.ACC2["characters"][characterId][keyName] = ACC2.ConvertValueWithType(typeValue, value)
    end

    ACC2.Query(([[SELECT * FROM acc2_characters_compatibilities WHERE keyName = %s AND compatibilityName = %s AND characterId = %s]]):format(ACC2.Escape(keyName), ACC2.Escape(compatibilityName), ACC2.Escape(characterId)), function(data)
        if istable(data) && istable(data[1]) then
            ACC2.Query(([[UPDATE acc2_characters_compatibilities SET typeValue = %s, value = %s WHERE compatibilityName = %s AND keyName = %s AND characterId = %s]]):format(ACC2.Escape(typeValue), ACC2.Escape(value), ACC2.Escape(compatibilityName), ACC2.Escape(keyName), ACC2.Escape(characterId)))
        else
            ACC2.Query(([[INSERT INTO acc2_characters_compatibilities (characterId, compatibilityName, typeValue, keyName, value, ownerId64) VALUES (%s, %s, %s, %s, %s, %s)]]):format(ACC2.Escape(characterId), ACC2.Escape(compatibilityName), ACC2.Escape(typeValue), ACC2.Escape(keyName), ACC2.Escape(value), ACC2.Escape(ownerId64)))
        end
    end)
end

--[[ Create the base of the character ]]
function ACC2.CreateCharacter(steamId64, ply, characterArguments, dontLoad, callback)
    ACC2.Query(([[INSERT INTO acc2_characters (ownerId64) VALUES (%s)]]):format(ACC2.Escape(steamId64)), function(tbl)
        local characterId = tonumber(tbl["lastInsertId"])

        if isfunction(callback) then
            callback(characterId)
        end

        ACC2.Query(([[SELECT DISTINCT compatibilityName FROM acc2_compatibilities_transfert WHERE ownerId64 = %s AND value = %s]]):format(
            ACC2.Escape(steamId64),
            "1"
        ), function(data)        
            
            --[[ 
                This loop permit to check if this is the first time that we init the compatibility for the player 
                Why? Imagine a player has 100 000$ on his bank account and he create a character. I need to get the value of what he had before so 100 000$.
                But not for the second character to don't have a duplication.
                If you delete compatibility value it will give again what the player have when he connect and create a character.
            ]]

            local transfered = {}

            if istable(data) then
                for k, v in ipairs(data) do
                    transfered[v.compatibilityName] = true
                end
            end
            
            hook.Run("ACC2:Character:Created", ply, characterId, characterArguments, dontLoad, transfered)

            --[[ Load the character next the entire creation ]]
            --[[ Todo need to find a solution to load the character when all sql queries are sended (avoid problems)]]
            timer.Simple(0.3, function()
                if not IsValid(ply) then return end
                
                if not dontLoad then
                    ply.ACC2 = ply.ACC2 or {}
                    ply.ACC2["characters"] = ply.ACC2["characters"] or {}
                    ply.ACC2["characters"][characterId] = ply.ACC2["characters"][characterId] or {}

                    ACC2.SetNWVariable("characterId", characterId, ply, true, nil, true)
                    hook.Run("ACC2:Load:Character", ply, characterId, nil,  ply.ACC2["characters"][characterId])
    
                    ply.ACC2["canInteractWithMenu"] = false
                end
            end)
        end)
    end)
end

--[[ Check if the characterId is to the player ]]
function PLAYER:ACC2CheckCharacter(characterId)
    self.ACC2["characters"] = self.ACC2["characters"] or {}

    if istable(self.ACC2["characters"][characterId]) then 
        return true 
    end

    return false
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

--[[ Get all characters of the steamid64 ]]
function ACC2.GetCharacters(steamId64, callback, withDeleted)
    ACC2.Query(([[

        SELECT * FROM acc2_characters_compatibilities 
        INNER JOIN acc2_characters ON acc2_characters.ownerId64 = %s AND acc2_characters.id = acc2_characters_compatibilities.characterId %s
        
     ]]):format(ACC2.Escape(steamId64), not withDeleted and "AND acc2_characters.deletedAt IS NULL" or ""),
     
    function(data)
        local returnTable = {}
        
        if istable(data) then
            for k, compatibilityData in pairs(data) do
                local characterId = tonumber(compatibilityData.characterId)
                if not isnumber(characterId) then continue end

                returnTable[characterId] = returnTable[characterId] or {}
                returnTable[characterId]["characterId"] = characterId

                if compatibilityData.deletedAt != nil then
                    returnTable[characterId]["deletedAt"] = compatibilityData.deletedAt
                end
                if not isstring(compatibilityData.typeValue) then continue end                

                returnTable[characterId][compatibilityData.keyName] = ACC2.ConvertValueWithType(compatibilityData.typeValue, compatibilityData.value)
            end
        end

        ACC2.Query(([[ SELECT * FROM acc2_whitelist_values WHERE ownerId64 = %s ]]):format(ACC2.Escape(steamId64)), function(whitelistTable)
            if istable(whitelistTable) then
                for k, v in pairs(whitelistTable) do 
                    local characterId = tonumber(v.characterId)
                    if not isnumber(characterId) then continue end

                    if not returnTable[characterId] then continue end
                    returnTable[characterId]["whitelist"] = returnTable[characterId]["whitelist"] or {}

                    returnTable[characterId]["whitelist"][v.jobName] = {
                        ["whitelisted"] = v.whitelisted,
                        ["blacklisted"] = v.blacklisted,
                    }
                end
            end

            if isfunction(callback) then
                callback(returnTable)
            end
        end)
    end)
end

--[[ Check if the player is near the entity ]]
function ACC2.IsNearEnt(ply, class)
    if not IsValid(ply) or not isstring(class) then return false end

    for k, v in pairs(ents.FindInSphere(ply:GetPos(), 100)) do
        if v:GetClass() == class then return true end
    end
end

--[[ Init all characters ]]
function PLAYER:ACC2IntitAllCharacters()
    self.ACC2 = self.ACC2 or {}
    self.ACC2["characters"] = {}
    
    ACC2.OldCharacterIdReference = ACC2.OldCharacterIdReference or {}

    ACC2.GetCharacters(self:SteamID64(), function(data)
        if not istable(data) then return end

        for k, v in pairs(data) do
            local oldId = tonumber(v.oldCharacterId)

            if isnumber(oldId) then
                ACC2.OldCharacterIdReference[v.characterId] = oldId
            end
        end

        self.ACC2["characters"] = data
    end)
end

--[[ Get old character id ]]
function ACC2.GetOldCharacterId(characterId, callback)
    if isnumber(ACC2.OldCharacterIdReference[characterId]) then
        return ACC2.OldCharacterIdReference[characterId]
        
    elseif not isfunction(callback) then
        return false

    elseif isfunction(callback) then
        ACC2.Query(([[ SELECT value FROM acc2_characters_compatibilities WHERE characterId = %s AND keyName = %s ]]):format(characterId, ACC2.Escape("oldCharacterId")), function(data)
            
            local oldCharacterId
            if data && data[1] && data[1]["value"] then
                oldCharacterId = data[1]["value"]
            end
            
            callback(characterId, oldCharacterId)
        end)
    end
end

function PLAYER:ACC2SaveCharacter(dontSend)
    local characterId = ACC2.GetNWVariables("characterId", self)

    if isnumber(characterId) then
        self.ACC2 = self.ACC2 or {}
        self.ACC2["characters"] = self.ACC2["characters"] or {}

        hook.Run("ACC2:Character:Save", self, characterId, (self.ACC2["characters"][characterId] or {}), dontSend)
    end
end

--[[ Open the character menu ]]
function PLAYER:ACC2OpenCharacterMenu(save)
    local canOpenCharacterMenu = hook.Run("ACC2:CanOpenCharacterMenu", self, save)
    if canOpenCharacterMenu == false then return end

    if save then
        self:ACC2SaveCharacter(true)
    end

    timer.Simple(0.1, function()
        ACC2.SendCharacter(self, self:SteamID64(), nil, {
            ["name"] = true, 
            ["lastName"] = true, 
            ["prefix"] = true, 
            ["model"] = true, 
            ["money"] = true, 
            ["job"] = true, 
            ["characterId"] = true, 
            ["description"] = true, 
            ["bodygroups"] = true,
            ["sexSelected"] = true,
            ["deletedAt"] = true
        }, nil, true)
    end)
end

--[[ Open the character modification menu ]]
function PLAYER:ACC2OpenCharacterModificationMenu()
    local canOpenModificationMenu = hook.Run("ACC2:CanOpenModificationMenu", self, save)
    if canOpenModificationMenu == false then return end

    if save then
        self:ACC2SaveCharacter(true)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

    timer.Simple(0.1, function()
        ACC2.SendCharacter(self, self:SteamID64(), nil, {
            ["name"] = true, 
            ["lastName"] = true, 
            ["prefix"] = true, 
            ["model"] = true, 
            ["money"] = true, 
            ["job"] = true, 
            ["characterId"] = true, 
            ["description"] = true, 
            ["bodygroups"] = true,
            ["sexSelected"] = true,
            ["deletedAt"] = true
        }, function()        
            net.Start("ACC2:Character")
                net.WriteUInt(5, 4)
            net.Send(self)
        end)
    end)
end

--[[ Open the character rpname menu ]]
function PLAYER:ACC2RPName()
    net.Start("ACC2:Character")
        net.WriteUInt(7, 4)
    net.Send(self)
end

--[[ Can the player interact with the menu ]]
function PLAYER:ACC2CanInteractWithMenu(npcClass)
    local canInteract = self.ACC2["canInteractWithMenu"]
    if canInteract == true then return true end
    
    if isstring(npcClass) then
        if not ACC2.IsNearEnt(self, npcClass) then
            canInteract = false
        end
    end

    return canInteract
end

-- Function to check if a specific job is full (reached maximum player limit)
local function isJobFull(jobIndex)
    local playerCount = 0

    -- Iterate through all players and count those assigned to the specified job
    for _, ply in pairs(player.GetAll()) do
        if IsValid(ply) and ply:Team() == jobIndex then
            playerCount = playerCount + 1
        end
    end

    -- Retrieve the maximum player limit for the specified job
    local maxPlayers = 0
    if RPExtraTeams[jobIndex].max > 0 then
        maxPlayers = RPExtraTeams[jobIndex].max
    else
        maxPlayers = math.huge
    end

    -- Check if the player count exceeds or meets the maximum player limit
    return playerCount >= maxPlayers
end

--[[ Load all basics values of the character ]]
function PLAYER:ACC2LoadCharacter(loadTable, data, dontSpawn)
    if not istable(data) then return end

    local isDeath = self.ACC2["isDeath"]

    self.ACC2 = self.ACC2 or {}
    self.ACC2["isDeath"] = false

    if not dontSpawn then
        self:Spawn()
    end

    local dontLoadJob = ACC2.GetSetting("dontLoadJob", "table")

    local jobToLoad
    if loadTable["job"] or loadTable["*"] then
        if ACC2.GetSetting("loadJob", "boolean") then
            if isstring(data["job"]) then
                local jobId = ACC2.GetJobIdByName(data["job"])

                if isnumber(jobId) then
                    -- Check if the job is full before loading the player into the job
                    if not isJobFull(jobId) then
                        if jobId != self:Team() then
                            if not dontLoadJob[data["job"]] then
                                self:ACC2SetJob(jobId)
                            end
                        end
                        jobToLoad = jobId
                    else
                        -- Notify the player that the job is full
                        self:ChatPrint("Профессия '" .. team.GetName(jobId) .. "' на данный момент занята.")
                    end
                end
            end
        end
    end


    if loadTable["name"] or loadTable["*"] then
        if ACC2.GetSetting("loadName", "boolean") then
            local name, lastName = data["name"], data["lastName"]
            local prefix = data["prefix"] or {}
            
            if isstring(name) && isstring(lastName) then
                local name = ACC2.GetFormatedName(name, lastName)

                local jobName = team.GetName(self:Team())
                
                if isstring(prefix[jobName]) then
                    name = ACC2.PrefixedName(prefix[jobName], name, lastName)
                else
                    local prefixTable = ACC2.GetSetting("prefixTable", "table")
                    local jobPrefix = prefixTable[jobName]

                    if isstring(jobPrefix) then
                        local characterId = ACC2.GetNWVariables("characterId", self)

                        name = ACC2.PrefixedName(jobPrefix, name, lastName)
                        prefix[jobName] = name

                        ACC2.SaveCompatibility(characterId, self:SteamID64(), "ACC2:Characters", "table", util.TableToJSON(prefix), "prefix", self)
                    end
                end
                
                if self:Name() != name then
                    self:ACC2SetName(name)
                end
            end
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

    if loadTable["health"] or loadTable["*"] then
        if ACC2.GetSetting("loadHealth", "boolean") then
            local health = tonumber(data["health"]) or 100

            if isnumber(health) then
                health = math.Clamp(health, 1, self:GetMaxHealth())

                self:SetHealth(health)
            end
        end
    end

    if loadTable["armor"] or loadTable["*"] then
        if ACC2.GetSetting("loadArmor", "boolean") then
            local armor = tonumber(data["armor"])
            if isnumber(armor) then
                armor = math.Clamp(armor, 0, self:GetMaxArmor())

                self:SetArmor(armor)
            end
        end
    end

    if loadTable["money"] or loadTable["*"] then
        if ACC2.GetSetting("loadMoney", "boolean") then
            self:ACC2SetMoney(0)

            local money = tonumber(data["money"])
            if isnumber(money) then
                self:ACC2SetMoney(money)
            end
        end
    end

    if loadTable["pos"] or loadTable["*"] then
        if ACC2.GetSetting("loadPos", "boolean") then
            local map = string.lower(game.GetMap())
            local pos = data["position:"..map]

            if isvector(pos) then
                self:SetPos(pos)
            else
                local position = ACC2.ToVectorOrAngle(pos, Vector)
                if isvector(position) then
                    self:SetPos(position)
                end
            end

            if isvector(data["shootPos"]) then
                local vec1 = data["shootPos"]
                local vec2 = self:GetShootPos()

                self:SetEyeAngles((vec1 - vec2):Angle())
            else
                local shootPos = ACC2.ToVectorOrAngle(data["shootPos"], Vector)

                if isvector(shootPos) then
                    local vec2 = self:GetShootPos()

                    self:SetEyeAngles((shootPos - vec2):Angle())
                end
            end
        end
    end
    
    local dontOverrideModel = ACC2.GetSetting("dontOverrideModel", "table")

    if loadTable["model"] or loadTable["*"] then
        if ACC2.GetSetting("loadModel", "boolean") then
            local model = data["model"]
            if isstring(model) then
                
                local jobName = (isstring(data["job"]) and data["job"] or "")
                if not dontOverrideModel[team.GetName(self:Team())] && not dontOverrideModel[team.GetName(jobName)] then
                    self:SetModel(model)
                    
                    local bodygroups = (istable(data["bodygroups"]) and data["bodygroups"] or util.JSONToTable((data["bodygroups"] or ""))) or {}
                    if istable(bodygroups) then
                        for k, v in pairs(bodygroups) do
                            self:SetBodygroup(k, v)
                        end
                    end

                    hook.Run("ACC2:ModelLoaded", self, model, bodygroups)
                end
            end
        end
    
        if loadTable["size"] or loadTable["*"] then
            if ACC2.GetSetting("loadSize", "boolean") then
                local minSize, maxSize = (ACC2.GetSetting("minSizeValue", "number") or 0.9), (ACC2.GetSetting("maxSizeValue", "number") or 1.1)
    
                local size = tonumber(data["size"])
                if isnumber(size) then
                    size = math.Clamp(size, minSize, maxSize)
                    self:SetModelScale(size)
                    
                    if ACC2.GetSetting("loadSizeView", "boolean") then
                        local bone = self:LookupBone("ValveBiped.Bip01_Head1")
                        if isnumber(bone) then
                            local pos = self:WorldToLocal(self:GetBonePosition(bone))

                            self:SetViewOffset(ACC2.Constants["playerViewBase"]*self:GetModelScale())
                        else
                            self:SetViewOffset(ACC2.Constants["playerViewBase"])
                        end
                    else
                        self:SetViewOffset(ACC2.Constants["playerViewBase"])
                    end

                    ACC2.SetNWVariable("acc2_size", size, self, true, nil, true)
                end
            end
        else
            self:SetViewOffset(ACC2.Constants["playerViewBase"])
        end
    end

    local age = tonumber(data["age"])
    if isnumber(age) then
        ACC2.SetNWVariable("acc2_age", age, self, true, nil, true)
    end

    local sexSelected = tonumber(data["sexSelected"])
    if isnumber(sexSelected) then
        ACC2.SetNWVariable("acc2_sexSelected", sexSelected, self, true, nil, true)
    end

    if isstring(data["description"]) then
        ACC2.SetNWVariable("acc2_description", data["description"], self, true, nil, true)
    end

    local dontLoadJobWeapon = ACC2.GetSetting("dontLoadJobWeapon", "table")

    if loadTable["weapons"] or loadTable["*"] then
        if ACC2.GetSetting("loadWeapons", "boolean") then

            local jobName = (isstring(data["job"]) and data["job"] or "")
            
            if not dontLoadJobWeapon[jobName] then
                local weps = (istable(data["weapons"]) and data["weapons"] or util.JSONToTable((data["weapons"] or "")))
                if not istable(weps) then return end

                if not isDeath then
                    self:StripWeapons()
                end

                if istable(weps) then
                    for k, v in ipairs(weps) do
                        if not isstring(v.class) then continue end

                        local wep
                        if self:HasWeapon(v.class) then
                            wep = self:GetWeapon(v.class)
                        else
                            wep = self:Give(v.class)
                        end

                        if IsValid(wep) then
                            local clip1 = tonumber(v.clip1)
                            if isnumber(clip1) then
                                wep:SetClip1(clip1)
                            end

                            local clip2 = tonumber(v.clip2)
                            if isnumber(clip2) then
                                wep:SetClip2(clip2)
                            end
                        end
                    end
                end
            end

            if isstring(data["activeWeapon"]) then
                self:SelectWeapon(data["activeWeapon"])
            end
        end
    end

    hook.Run("ACC2:FinishedLoadingCharacter", self, data)
    self.ACC2["canInteractWithMenu"] = false
end

--[[ Update the character ]]
function PLAYER:ACC2UpdateCharacter(characterArguments, fade)
    if not istable(characterArguments) then return end
    
    hook.Run("ACC2:Character:Update", self, characterArguments, fade)
end

--[[ Get all weapons of the player ]]
function PLAYER:ACC2GetWeapons()
    local weps = {}
    
    for k, v in ipairs(self:GetWeapons()) do
        weps[#weps + 1] = {
            ["clip1"] = v:Clip1(),
            ["clip2"] = v:Clip2(),
            ["class"] = v:GetClass(),
        }
    end

    return weps
end

--[[ Remove a character with his uniqueId ]]
function ACC2.RemoveCharacter(characterId, ownerId64, remover, dontOpenNow)
    if not isnumber(characterId) then return end
    
    ACC2.Query(([[UPDATE acc2_characters SET deletedAt = CURRENT_TIMESTAMP WHERE ownerId64 = %s and id = %s]]):format(ACC2.Escape(ownerId64), ACC2.Escape(characterId)), function()
        local target = player.GetBySteamID64(ownerId64)

        if IsValid(target) then
            target.ACC2 = target.ACC2 or {}
            target.ACC2["characters"] = target.ACC2["characters"] or {}

            target.ACC2["characters"][characterId] = nil
            
            net.Start("ACC2:Character")
                net.WriteUInt(4, 4)
                net.WriteUInt(characterId, 22)
                net.WriteString(ownerId64)
            net.Send(target)

            --[[ Reopen the character menu if the character id of the target is the same of the delete]]
            if IsValid(target) && not dontOpenNow then
                if ACC2.GetNWVariables("characterId", target) == characterId then
                    ACC2.SetNWVariable("characterId", "nil", target, true, nil, true)

                    target.ACC2["canInteractWithMenu"] = true
                    target:ACC2OpenCharacterMenu()
                end
            end
        end

        hook.Run("ACC2:RemoveCharacter", characterId, target, ownerId64, remover)

        if IsValid(remover) then
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(4, 4)
                net.WriteString(ownerId64)
                net.WriteBool(true)
                net.WriteUInt(characterId, 22)
            net.Send(remover)
        end
    end)
end

--[[ Re enable a character with his uniqueId ]]
function ACC2.ReEnableCharacter(characterId, ownerId64, admin)
    if not isnumber(characterId) then return end
    
    ACC2.Query(([[UPDATE acc2_characters SET deletedAt = NULL WHERE ownerId64 = %s and id = %s]]):format(ACC2.Escape(ownerId64), ACC2.Escape(characterId)), function()
        local target = player.GetBySteamID64(ownerId64)

        hook.Run("ACC2:ReEnableCharacter", characterId, target, ownerId64, admin)

        if IsValid(target) then
            target:ACC2IntitAllCharacters()

            ACC2.SendCharacter(target, ownerId64, nil, {
                ["name"] = true, 
                ["lastName"] = true, 
                ["prefix"] = true, 
                ["model"] = true,
                ["money"] = true, 
                ["job"] = true, 
                ["characterId"] = true, 
                ["description"] = true,
                ["sexSelected"] = true,
                ["deletedAt"] = true
            }, nil, nil, true)
        end

        if IsValid(admin) then
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(4, 4)
                net.WriteString(ownerId64)
                net.WriteBool(false)
                net.WriteUInt(characterId, 22)
            net.Send(admin)
        end
    end)
end

--[[ Send character or characters with values that we want]]
function ACC2.SendCharacter(ply, steamId64, characterIds, characterValues, callback, openMenu, withDeleted)    
    local characters = {}

    ACC2.GetCharacters(steamId64, function(data)
        if istable(data) then        
            for k, v in pairs(data) do
                if (istable(characterIds) && not characterIds[k]) then continue end
                
                local charactersValue = {}
                for keyValue, vValue in pairs(v) do
                    if (istable(characterValues) && not characterValues[keyValue]) then continue end
    
                    charactersValue[keyValue] = vValue
                end
    
                characters[k] = charactersValue
            end
        end

        local characterCount = table.Count(characters)
        
        net.Start("ACC2:Character")
            net.WriteUInt(2, 4)
            net.WriteBool(openMenu)
            net.WriteString(steamId64)
            net.WriteUInt(characterCount, 16)
    
            for characterId, _ in pairs(characters) do
                net.WriteUInt(table.Count(characters[characterId]), 16)
                net.WriteUInt(characterId, 22)
    
                for k, v in pairs(characters[characterId]) do
                    local valueType = type(v)
                    if k == "deletedAt" then 
                        valueType = "boolean"
                        v = v and v != NULL and v != "NULL"
                    end
                    
                    net.WriteString(valueType)
                    net.WriteString(k)
        
                    net["Write"..ACC2.TypeNet[valueType]](v, ((ACC2.TypeNet[valueType] == "Int") and 32))
                end
            end
        if IsValid(ply) then net.Send(ply) else net.Broadcast() end

        if isfunction(callback) then
            callback(characterCount, characters)
        end
    end, withDeleted)
end

--[[ Check whitelist system ]]
function ACC2.WhitelistCheck(ply, job)
    if not IsValid(ply) or not isnumber(job) then return end

    ACC2.WhitelistSettings = ACC2.WhitelistSettings or {}
    
    local jobName = team.GetName(job)
    local jobTable = ACC2.WhitelistSettings[jobName]
    
    local userGroup = ply:GetUserGroup()
    ACC2.UserGroupsWhitelistSettings = ACC2.UserGroupsWhitelistSettings or {}
    ACC2.UserGroupsWhitelistSettings[jobName] = ACC2.UserGroupsWhitelistSettings[jobName] or {}
    ACC2.UserGroupsWhitelistSettings[jobName][userGroup] = ACC2.UserGroupsWhitelistSettings[jobName][userGroup] or {}

    if istable(jobTable) then
        local characterId = tonumber(ACC2.GetNWVariables("characterId", ply))
        if not isnumber(characterId) then
            ply:ACC2Notification(5, ACC2.GetSentence("errorWhithYourCharacter"))

            return false
        end

        ply.ACC2 = ply.ACC2 or {}
        ply.ACC2["whitelistPlayers"] = ply.ACC2["whitelistPlayers"] or {}
        ply.ACC2["whitelistPlayers"][characterId] = ply.ACC2["whitelistPlayers"][characterId] or {}
        ply.ACC2["whitelistPlayers"][characterId][jobName] = ply.ACC2["whitelistPlayers"][characterId][jobName] or {}

        if (jobTable["blacklistEnable"] && (ply.ACC2["whitelistPlayers"][characterId][jobName]["blacklisted"] or ACC2.UserGroupsWhitelistSettings[jobName][userGroup]["blacklisted"])) then
            if ACC2.GetSetting("adminRankBypassBlacklist", "boolean") then
                if ACC2.AdminRank[ply:GetUserGroup()] then return true end
            end

            if jobTable["defaultBlacklist"] && not ply.ACC2["whitelistPlayers"][characterId][jobName]["blacklisted"] then
                ACC2.ChangePlayersWhitelistSettings(ply:SteamID64(), characterId, jobName, nil, true, ply)
                ply:ACC2Notification(5, ACC2.GetSentence("blacklistAutomaticly"))
            else
                ply:ACC2Notification(5, ACC2.GetSentence("youAreBlacklisted"))
            end

            return false
        elseif jobTable["whitelistEnable"] then
            if ACC2.GetSetting("adminRankBypassWhitelist", "boolean") then
                if ACC2.AdminRank[ply:GetUserGroup()] then return true end
            end

            if (ply.ACC2["whitelistPlayers"][characterId][jobName]["whitelisted"] or ACC2.UserGroupsWhitelistSettings[jobName][userGroup]["whitelisted"]) or jobTable["defaultWhitelist"] then 
                if jobTable["defaultWhitelist"] && not ply.ACC2["whitelistPlayers"][characterId][jobName]["whitelisted"] then
                    ACC2.ChangePlayersWhitelistSettings(ply:SteamID64(), characterId, jobName, true, nil, ply)
                    ply:ACC2Notification(5, ACC2.GetSentence("whitelistAutomaticly"))
                end

                return true
            else
                ply:ACC2Notification(5, ACC2.GetSentence("youAreNotWhitelisted"))
                return false
            end
        end
    end
end

function ACC2.CheckPermissionWhitelist(jobName, ply, whitelistType)
    local userGroup = ply:GetUserGroup()
    if ACC2.AdminRank[userGroup] then return true end

    ACC2.WhitelistSettings = ACC2.WhitelistSettings or {}
    ACC2.WhitelistSettings["permissions"] = ACC2.WhitelistSettings["permissions"] or {}

    local returnValue = false
    local permissionTable = ACC2.WhitelistSettings["permissions"][jobName] or {}

    local teamName = team.GetName(ply:Team())

    if permissionTable["canManageWhitelist"][teamName] or permissionTable["canManageWhitelist"][userGroup] then
        returnValue = true
    end

    if permissionTable["canManageBlacklist"][teamName] or permissionTable["canManageBlacklist"][userGroup] then
        returnValue = true
    end

    return returnValue
end

function PLAYER:ACC2CanOpenWhitelist()
    ACC2.ValuesPermissions = ACC2.ValuesPermissions or {}

    local jobPermissions = ACC2.ValuesPermissions[team.GetName(self:Team())] or {}
    local userGroupPermissions = ACC2.ValuesPermissions[self:GetUserGroup()] or {}

    if ACC2.AdminRank[self:GetUserGroup()] then
        return true
    elseif table.Count(jobPermissions) > 0 then
        return true
    elseif table.Count(userGroupPermissions) > 0 then
        return true
    end

    return false
end

concommand.Add("acc2_whitelist_player", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end

    local steamId64 = args[1]
    if not isstring(steamId64) then print(ACC2.GetSentence("invalidSteamId")) return end

    local characterId = tonumber(args[2])
    if not isnumber(characterId) then print(ACC2.GetSentence("invalidCharacterId")) return end

    local jobName = ACC2.GetJobIdByName(args[3])
    if not isstring(jobName) then print(ACC2.GetSentence("invalidJobId")) return end

    print(ACC2.GetSentence("requestSended"):format(steamId64, characterId, jobName))

    ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, true, nil, player.GetBySteamID64(ply:SteamID64()), ply)
end)

concommand.Add("acc2_un_whitelist_player", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end

    local steamId64 = args[1]
    steamId64 = string.find("STEAM_", steamId64) and util.SteamIDTo64(steamId64) or steamId64
    if not isstring(steamId64) then print(ACC2.GetSentence("invalidSteamId")) return end

    local characterId = tonumber(args[2])
    if not isnumber(characterId) then print(ACC2.GetSentence("invalidCharacterId")) return end

    local jobName = ACC2.GetJobIdByName(args[3])
    if not isstring(jobName) then print(ACC2.GetSentence("invalidJobId")) return end

    print(ACC2.GetSentence("requestSended"):format(steamId64, characterId, jobName))

    ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, false, nil, player.GetBySteamID64(ply:SteamID64()), ply)
end)

concommand.Add("acc2_blacklist_player", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end

    local steamId64 = args[1]
    steamId64 = string.find("STEAM_", steamId64) and util.SteamIDTo64(steamId64) or steamId64
    if not isstring(steamId64) then print(ACC2.GetSentence("invalidSteamId")) return end

    local characterId = tonumber(args[2])
    if not isnumber(characterId) then print(ACC2.GetSentence("invalidCharacterId")) return end

    local jobName = ACC2.GetJobIdByName(args[3])
    if not isstring(jobName) then print(ACC2.GetSentence("invalidJobId")) return end

    print(ACC2.GetSentence("requestSended"):format(steamId64, characterId, jobName))

    ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, nil, true, player.GetBySteamID64(ply:SteamID64()), ply)
end)

concommand.Add("acc2_un_blacklist_player", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end

    local steamId64 = args[1]
    steamId64 = string.find("STEAM_", steamId64) and util.SteamIDTo64(steamId64) or steamId64
    if not isstring(steamId64) then print(ACC2.GetSentence("invalidSteamId")) return end

    local characterId = tonumber(args[2])
    if not isnumber(characterId) then print(ACC2.GetSentence("invalidCharacterId")) return end

    local jobName = ACC2.GetJobIdByName(args[3])
    if not isstring(jobName) then print(ACC2.GetSentence("invalidJobId")) return end

    print(ACC2.GetSentence("requestSended"):format(steamId64, characterId, jobName))

    ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, nil, false, player.GetBySteamID64(ply:SteamID64()), ply)
end)

--[[ Init all compatibilities ]]
timer.Simple(1, function()

    hook.Run("ACC2:OnCompatibilitiesLoaded")
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
