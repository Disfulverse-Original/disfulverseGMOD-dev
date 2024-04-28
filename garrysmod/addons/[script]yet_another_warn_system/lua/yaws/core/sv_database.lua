-- quick copy and paste for me to wipe database tables - don't mind these
--[[
DROP TABLE yaws_darkrp_config;
DROP TABLE yaws_darkrp_permissions;
DROP TABLE yaws_darkrp_presets;
DROP TABLE yaws_darkrp_punishments;
DROP TABLE yaws_player_information;
DROP TABLE yaws_players;
DROP TABLE yaws_servers;
DROP TABLE yaws_warns;
--]]

if(YAWS.ManualConfig.Database.Enabled) then 
    require("mysqloo")
end 

function YAWS.Database.Initalize() 
    YAWS.Database.ServerSpecificPrefix = YAWS.ManualConfig.Database.TablePrefix .. YAWS.ManualConfig.Database.ServerID .. "_"
    local function tableCreationCallback(isErr, q, data)
        if(!isErr) then return end 
        YAWS.Core.Print("Table creation failed.")
        YAWS.Core.Print("Do NOT run the addon in this state, otherwise")
        YAWS.Core.Print("you can expect a lot of stuff to be, if i may")
        YAWS.Core.Print("speak frankly, fucking shitted up beyond any")
        YAWS.Core.Print("kind of comprehension.")
    end 

    if(YAWS.ManualConfig.Database.Enabled) then 
        YAWS.Database.Connection = mysqloo.connect(YAWS.ManualConfig.Database.Host, YAWS.ManualConfig.Database.Username, YAWS.ManualConfig.Database.Password, YAWS.ManualConfig.Database.Schema, YAWS.ManualConfig.Database.Port)

        YAWS.Database.Connection.onConnected = function(db) 
            YAWS.Core.Print("MySQL connection successful.")
            
            -- Servers Table
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%sservers`(
                    `id` VARCHAR(100) NOT NULL PRIMARY KEY,
                    `name` VARCHAR(100) NOT NULL
                );

                REPLACE INTO `%sservers`(`id`, `name`) VALUES(%s, %s);
            ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(YAWS.ManualConfig.Database.ServerName))

            -- Quickly fill in our cache of "nice names" while we're here
            YAWS.Database.Query(function(err, q, data)
                if(err) then return end 
                if(#data <= 0) then return end 

                for k,v in pairs(data) do 
                    YAWS.NiceServerNames[v.id] = v.name
                end 
            end, [[
                SELECT * FROM `%sservers`;
            ]], YAWS.ManualConfig.Database.TablePrefix)

            -- Server-Specific tables.

            -- Permissions Table
            -- booooo json in a database, suck my fucking ass
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%spermissions`(
                    `usergroup` VARCHAR(50) NOT NULL PRIMARY KEY,
                    `permissions` LONGTEXT NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)

            -- Config Table or "admin settings"
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%sconfig`(
                    `key` VARCHAR(50) NOT NULL PRIMARY KEY,
                    `value` VARCHAR(255) NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)
            
            -- Reason Presets Table 
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%spresets`(
                    `name` VARCHAR(25) PRIMARY KEY,
                    `reason` VARCHAR(500),
                    `points` INT NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)
            
            -- Punishments Table 
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%spunishments`(
                    `threshold` INT PRIMARY KEY,
                    `type` VARCHAR(50) NOT NULL,
                    `parameters` LONGTEXT NOT NULL
                );
            ]], YAWS.Database.ServerSpecificPrefix)


            -- Tables shared between servers

            -- Players table - used for getting basic data about a offline player
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%splayers`(
                    `steamid` VARCHAR(17) NOT NULL,
                    `name` VARCHAR(255) NOT NULL,
                    `usergroup` VARCHAR(50) NOT NULL,
                    `server_id` VARCHAR(100) NOT NULL,

                    PRIMARY KEY(`steamid`, `server_id`)
                );
            ]], YAWS.ManualConfig.Database.TablePrefix)
            -- This is a table for player information that *isn't* based off
            -- servers like above, e.g admin notes and point deductions that
            -- need to be seen between servers
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%splayer_information`(
                    `steamid` VARCHAR(17) PRIMARY KEY,
                    `note` TEXT,
                    `points_deducted` INT
                );
            ]], YAWS.ManualConfig.Database.TablePrefix)
            
            -- Warns Table 
            -- Quick note here: I use UUIDs as primary keys instead of
            -- numberical primary keys. Numberical keys are shitty + are
            -- terrible to work with if for example if a server needs to swap db
            -- tables your fucked. take a look at this for further understanding
            -- of my reasoning for prefering uuids
            -- https://www.mysqltutorial.org/mysql-uuid/
            YAWS.Database.Query(tableCreationCallback, [[
                CREATE TABLE IF NOT EXISTS `%swarns`(
                    `id` BINARY(16) PRIMARY KEY,
                    `player` VARCHAR(17) NOT NULL,
                    `admin` VARCHAR(17) NOT NULL,
                    `reason` VARCHAR(150),
                    `points` INT NOT NULL,
                    `timestamp` INT NOT NULL,
                    `server_id` VARCHAR(100) NOT NULL
                );
            ]], YAWS.ManualConfig.Database.TablePrefix)
            
            YAWS.Core.Print("Database checks complete. Check above for errors.")
            hook.Run("yaws.database.loaded")
        end
        YAWS.Database.Connection.onConnectionFailed = function(db, err) 
            YAWS.Core.Print("----->> FATAL ERROR <<----")
            YAWS.Core.Print("Attempt at MySQL connection failed.")
            YAWS.Core.Print("Error: " .. err)
            YAWS.Core.Print("")
            YAWS.Core.Print("DO NOT LET THE ADDON RUN IN THIS STATE")
            YAWS.Core.Print("EVERYTHING WILL BE FUCKED IF YOU DO")
            YAWS.Core.Print("----->> FATAL ERROR <<----")
        end 
        
        YAWS.Core.Print("Connecting to database.")
        YAWS.Database.Connection:connect()
        
        return
    end
    

    YAWS.Core.Print("Loading with SQLite...")
    
    -- Servers Table
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%sservers`(
            `id` VARCHAR(100) NOT NULL PRIMARY KEY,
            `name` VARCHAR(100) NOT NULL
        );
    
        REPLACE INTO `%sservers`(`id`, `name`) VALUES(%s, %s);
    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID), YAWS.Database.String(YAWS.ManualConfig.Database.ServerName))

    -- Quickly fill in our cache of "nice names" while we're here
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(#data <= 0) then return end 

        for k,v in pairs(data) do 
            YAWS.NiceServerNames[v.id] = v.name
        end 
    end, [[
        SELECT * FROM `%sservers`;
    ]], YAWS.ManualConfig.Database.TablePrefix)


    -- Server-Specific Tables

    -- Permissions Table
    -- booooo json in a database, suck my fucking ass
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%spermissions`(
            `usergroup` VARCHAR(50) NOT NULL PRIMARY KEY,
            `permissions` LONGTEXT NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Config Table or "admin settings"
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%sconfig`(
            `key` VARCHAR(50) NOT NULL PRIMARY KEY,
            `value` VARCHAR(255) NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Reason Presets Table 
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%spresets`(
            `name` VARCHAR(25) PRIMARY KEY,
            `reason` VARCHAR(500),
            `points` INT NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)

    -- Punishments Table 
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%spunishments`(
            `threshold` INT PRIMARY KEY,
            `type` VARCHAR(50) NOT NULL,
            `parameters` LONGTEXT NOT NULL
        );
    ]], YAWS.Database.ServerSpecificPrefix)


    -- Tables shared between servers

    -- Players table - used for getting basic data about a offline player
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%splayers`(
            `steamid` VARCHAR(17) NOT NULL,
            `name` VARCHAR(255) NOT NULL,
            `usergroup` VARCHAR(50) NOT NULL,
            `server_id` VARCHAR(100) NOT NULL,

            PRIMARY KEY(`steamid`, `server_id`)
        );
    ]], YAWS.ManualConfig.Database.TablePrefix)
    -- This is a table for player information that *isn't* based off
    -- servers like above, e.g admin notes and point deductions that
    -- need to be seen between servers
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%splayer_information`(
            `steamid` VARCHAR(17) PRIMARY KEY,
            `note` TEXT,
            `points_deducted` INT
        );
    ]], YAWS.ManualConfig.Database.TablePrefix)

    -- Warns Table 
    -- Quick note here: I use UUIDs as primary keys instead of
    -- numberical primary keys. Numberical keys are shitty + are
    -- terrible to work with if for example if a server needs to swap db
    -- tables your fucked. take a look at this for further understanding
    -- of my reasoning for prefering uuids
    -- https://www.mysqltutorial.org/mysql-uuid/
    -- Because of SQLite not being able to convert UUIDs to binary, I have to
    -- use VarChar here unfortunately and miss out on a lil performance :(
    YAWS.Database.Query(tableCreationCallback, [[
        CREATE TABLE IF NOT EXISTS `%swarns`(
            `id` VARCHAR(36) PRIMARY KEY,
            `player` VARCHAR(17) NOT NULL,
            `admin` VARCHAR(17) NOT NULL,
            `reason` VARCHAR(150),
            `points` INT NOT NULL,
            `timestamp` INT NOT NULL,
            `server_id` VARCHAR(100) NOT NULL
        );
    ]], YAWS.ManualConfig.Database.TablePrefix)
    
    YAWS.Core.Print("Database checks complete. Check above for errors.")
    hook.Run("yaws.database.loaded")
end 
hook.Add("yaws.core.initalize", "yaws.database.initalize", YAWS.Database.Initalize)

-- Queries.
-- callback(isError, query, data)
function YAWS.Database.Query(callback, q, ...)
    q = string.format(q, unpack({...}))
    
    if(YAWS.ManualConfig.Database.Enabled) then 
        local query = YAWS.Database.Connection:query(q)
        query.onSuccess = function(qu, data)
            if(!callback) then return end 
            callback(false, qu, data)
        end 
        query.onError = function(qu, err)
            YAWS.Core.Print("----->> WARNING <<----")
            YAWS.Core.Print("Attempt at MySQL query failed.")
            YAWS.Core.Print("Error: " .. err)
            YAWS.Core.Print("Query: " .. q)
            YAWS.Core.Print("")
            YAWS.Core.Print("The addon might be able to recover from thisin certain circumstances,")
            YAWS.Core.Print("but this also has the potential to break something. Check down in")
            YAWS.Core.Print("your console to see if anything has been fucked up.")
            YAWS.Core.Print("")
            YAWS.Core.Print("Calling callback...")
            
            if(callback == nil) then return end 
            callback(true, q, err)
        end
        
        query:start() 
        
        return
    end 
    
    -- SQLite 
    local query = sql.Query(q)
    if(query == false) then 
        YAWS.Core.Print("----->> WARNING <<----")
        YAWS.Core.Print("Attempt at MySQL query failed.")
        YAWS.Core.Print("Error: " .. sql.LastError())
        YAWS.Core.Print("Query: " .. q)
        YAWS.Core.Print("")
        YAWS.Core.Print("The addon might be able to recover from thisin certain circumstances,")
        YAWS.Core.Print("but this also has the potential to break something. Check down in")
        YAWS.Core.Print("your console to see if anything has been fucked up.")
        YAWS.Core.Print("")
        YAWS.Core.Print("Calling callback...")
            
        if(callback == nil) then return end 
        callback(true, q, sql.LastError())
        return
    end
    
    if(callback == nil) then return end 
    callback(false, q, query or {})
    return
end 

-- Escaping strings.
function YAWS.Database.String(str)
    if(YAWS.ManualConfig.Database.Enabled) then 
        return "'" .. YAWS.Database.Connection:escape(str) .. "'"
    end 
    
    return sql.SQLStr(str)
end 

timer.Create("yaws.database.refresh", YAWS.ManualConfig.Database.RefreshRate, 0, function()
    hook.Run("yaws.database.refresh")
end)
hook.Add("yaws.database.refresh", "yaws.database.nicenamerefresh", function()
    -- Any servers being added during this one
    YAWS.Database.Query(function(err, q, data)
        if(err) then return end 
        if(#data <= 0) then return end 

        for k,v in ipairs(data) do 
            YAWS.NiceServerNames[v.id] = v.name
        end 
    end, [[
        SELECT * FROM `%sservers`;
    ]], YAWS.ManualConfig.Database.TablePrefix)
end)