-- Handles the transfering of data from one warning mod to the other

concommand.Add("yaws_convert", function(ply, cmd, args, argStr)
    if(IsValid(ply)) then return end 

    -- Forcing the type.
    if(#args > 0) then 
        local addon = args[1]

        if(addon == "continue") then 
            if(!YAWS.Convert.Timeout || !YAWS.Convert.Converter) then 
                YAWS.Core.Print("Your conversion timed out. Try again.")
                return
            end 
            if(YAWS.Convert.Timeout <= CurTime()) then 
                YAWS.Core.Print("Your conversion timed out. Try again.")
                YAWS.Convert.Timeout = nil
                YAWS.Convert.Converter = nil
                return
            end 

            YAWS.Core.Print("Converting data from " .. YAWS.Convert.Converter .. " to Yet Another Warning System. Please wait as this may take a few minutes depending on how much data there is.")
            YAWS.Core.Print("Starting in 10 seconds.")

            timer.Simple(10, function()
                YAWS.Convert.Converters[YAWS.Convert.Converter].convert()
                YAWS.Convert.Converter = nil
            end)
            YAWS.Convert.Timeout = nil

            return 
        end 
        if(addon == "list") then 
            YAWS.Core.Print("The following converters are available. Enter one with yaws_convert <converter>")
            for k,v in pairs(YAWS.Convert.Converters) do 
                YAWS.Core.Print("  - " .. k)
            end

            return 
        end 

        if(!YAWS.Convert.Converters[addon]) then 
            YAWS.Core.Print("The converter " .. addon .. " does not exist.")
            YAWS.Core.Print("The following converters are available. Select one with yaws_convert <converter>")
            for k,v in pairs(YAWS.Convert.Converters) do 
                YAWS.Core.Print("  - " .. k)
            end

            return 
        end
    end 

    YAWS.Convert.AutoDetect()
        :next(function(detected)
            if(table.Count(detected) <= 0) then 
                YAWS.Core.Print("Couldn't find any valid data for converters to use. Please ensure YAWS is connected to the same database as the data you wish to convert over.")
                return
            end 
            if(table.Count(detected) > 1) then 
                YAWS.Core.Print("Detected more than one valid converter. Please select from the following: " .. table.concat(detected, ", "))
                YAWS.Core.Print("Type 'yaws_convert <converter>' to select one.")
                return
            end 

            local key = table.GetKeys(detected)[1]
            local converter = YAWS.Convert.Converters[key]
            
            -- YAWS.Core.Print("Converting data from " .. key .. " to Yet Another Warning System. Please wait as this may take a few minutes depending on how much data there is.")
            YAWS.Core.Print("Detected the following converter: " .. key)
            YAWS.Core.Print("Continuing will wipe ALL current Yet Another Warning System warnings and player data, along with any AWarn 3 data.")
            YAWS.Core.Print("IT'S ADVISED YOU BACKUP ANY PRE-EXISTING DATA BEFORE CONTINUING.")
            YAWS.Core.Print("Enter 'yaws_convert continue' in the next 15 seconds to continue.")

            YAWS.Convert.Timeout = CurTime() + 15
            YAWS.Convert.Converter = key
        end)
end)

function YAWS.Convert.AutoDetect()
    -- Auto-detect 
    local d = deferred.new()

    local detected = {}
    local count = 0
    for k,v in pairs(YAWS.Convert.Converters) do
        v.detection()
            :next(function(result)
                detected[k] = ((result == true) && true || nil)
                count = count + 1
                if(count == table.Count(YAWS.Convert.Converters)) then 
                    d:resolve(detected)
                    return d
                end
            end)
            :catch(function()
                count = count + 1
                if(count == table.Count(YAWS.Convert.Converters)) then 
                    d:resolve(detected)
                    return d
                end
            end)
    end 

    return d
end 

YAWS.Convert.Converters = {}

-- Awarn 3
YAWS.Convert.Converters['awarn3'] = {
    detection = function()
        local d = deferred.new()

        if(YAWS.ManualConfig.Database.Enabled) then 
            YAWS.Database.Query(function(err, q, data)
                d:resolve(#data > 0)
            end, [[
                SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='awarn3_warningtable';
            ]])
        else
            d:resolve(sql.TableExists("awarn3_warningtable"))
        end 

        return d
    end,
    convert = function()
        YAWS.Core.Print("Converting from AWarn 3.")
        YAWS.Convert.Start = RealTime()

        YAWS.Core.Print("")
        YAWS.Core.Print("Wiping all tables.")
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.Print("A problem occoured with the query. Stopping!")
                return
            end 
            YAWS.Core.Print("Done.")
            YAWS.Convert.Converters['awarn3'].warningConvert()
        end, [[
            DELETE FROM %swarns;
            DELETE FROM %splayers;
        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.ManualConfig.Database.TablePrefix)
    end,
    warningConvert = function()
        YAWS.Core.Print("-------------------------------------------------------")
        YAWS.Core.Print("Converting warnings.")
        YAWS.Core.Print("")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then 
                YAWS.Core.Print("A problem occoured with the query. Stopping!")
                return
            end 
    
            if(#data > 0) then
                local total = #data
                for k,v in ipairs(data) do 
                    local oldID = v.WarningID
                    local newID = YAWS.Core.GenerateUUID() -- WarningID is discarded as it uses auto increment like a noob
                    local player = v.PlayerID 
                    local admin = v.AdminID
                    local reason = v.WarningReason
                    -- local serverName = v.WarningServer -- Not sure how to handle this guy 
                    local timestamp = v.WarningDate
    
                    if(string.StartWith(player, "Bot")) then 
                        YAWS.Core.Print("[" .. k .. " / " .. total .. "] Discarding warning ID " .. oldID .. " as the warned player is a bot. YAWS does not support warning bots!")
                        continue 
                    end 
    
                    if(YAWS.ManualConfig.Database.Enabled) then 
                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.Print("[" .. k .. " / " .. total .. "] Error occoured with converting warning ID " .. oldID .. ". Skipping!")
                                return
                            end 
    
                            YAWS.Core.Print("[" .. k .. " / " .. total .. "] Transfered warning ID " .. oldID .. " to warning ID " .. newID .. ".")
                        end, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(UUID_TO_BIN(%s), %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), 1, timestamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    else 
                        YAWS.Database.Query(function(err, q, data)
                            if(err) then 
                                YAWS.Core.Print("[" .. k .. " / " .. total .. "] Error occoured with converting warning ID " .. oldID .. ". Skipping!")
                            end 

                            YAWS.Core.Print("[" .. k .. " / " .. total .. "] Transfered warning ID " .. oldID .. " to warning ID " .. newID .. ".")
                        end, [[
                            INSERT INTO `%swarns`(`id`, `player`, `admin`, `reason`, `points`, `timestamp`, `server_id`) VALUES(%s, %s, %s, %s, %s, %s, %s);
                        ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(newID), YAWS.Database.String(player), YAWS.Database.String(admin), YAWS.Database.String(reason), 1, timestamp, YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    end 
                end 
            end
    
            YAWS.Core.Print("")
            YAWS.Core.Print("-------------------------------------------------------")
            YAWS.Core.Print("Done.")
            YAWS.Convert.Converters['awarn3'].playerConvert()
        end, [[
            SELECT * FROM awarn3_warningtable;
        ]])
    end ,
    playerConvert = function()
        YAWS.Core.Print("-------------------------------------------------------")
        YAWS.Core.Print("Converting player data.")
        YAWS.Core.Print("")
        
        YAWS.Database.Query(function(err, q, data)
            if(err) then return end 
    
            if(#data > 0) then
                local total = #data
                for k,v in ipairs(data) do 
                    local steamid = v.PlayerID
                    local name = v.PlayerName
    
                    if(string.StartWith(steamid, "Bot")) then 
                        YAWS.Core.Print("[" .. k .. " / " .. total .. "] Discarding player " .. steamid .. " as the player is a bot. YAWS does not support warning bots!")
                        continue 
                    end 
                    if(steamid == "[CONSOLE]") then 
                        YAWS.Core.Print("[" .. k .. " / " .. total .. "] Discarding player as they are the console. seriously, why does this need to be stored lol")
                        continue 
                    end 
    
                    YAWS.Database.Query(nil, [[
                        INSERT INTO `%splayers`(`steamid`, `name`, `usergroup`, `server_id`) VALUES(%s, %s, 'Unknown', %s);
                    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid), YAWS.Database.String(name), YAWS.Database.String(YAWS.ManualConfig.Database.ServerID))
                    YAWS.Database.Query(nil, [[
                        INSERT INTO `%splayer_information`(`steamid`, `note`, `points_deducted`) VALUES(%s, null, null);
                    ]], YAWS.ManualConfig.Database.TablePrefix, YAWS.Database.String(steamid))
                    YAWS.Core.Print("[" .. k .. " / " .. total .. "] Transfered player " .. steamid .. ".")
                end 
            end
    
            YAWS.Core.Print("")
            YAWS.Core.Print("-------------------------------------------------------")
            YAWS.Core.Print("Done.")
            YAWS.Convert.Converters['awarn3'].cleanup()
        end, [[
            SELECT * FROM awarn3_playertable;
        ]])
    end,
    cleanup = function()
        YAWS.Core.Print("Deleting AWarn 3 tables.")
        YAWS.Core.Print("")
    
        YAWS.Database.Query(function(err, q, data)
            YAWS.Core.Print("Done.")
            YAWS.Core.Print("")

            YAWS.Core.Print("Finished conversion in " .. (RealTime() - YAWS.Convert.Start) .. "s.")
            YAWS.Core.Print("It is HIGHLY RECCOMENDED that you restart your server now, to ensure YAWS loads the fresh data.")
        end, [[
            DROP TABLE awarn3_warningtable;
            DROP TABLE awarn3_playertable;
        ]])
    end 
}







-- function yaws_test() 
--     YAWS.Database.Query(nil, [[
--         CREATE TABLE awarn3_warningtable ( WarningID INTEGER PRIMARY KEY AUTOINCREMENT, PlayerID VARCHAR(20), AdminID VARCHAR(20), WarningReason TEXT, WarningServer VARCHAR(255), WarningDate INTEGER );
--         CREATE TABLE awarn3_playertable ( PlayerID VARCHAR(20) PRIMARY KEY, PlayerName VARCHAR(32), PlayerWarnings SMALLINT, LastWarning INTEGER, LastPlayed INTEGER, LastWarningDecay INTEGER )
--     ]])

--     local steamids = {
--         "76561198121018313"
--     }
--     local names = {}
--     for i=0,90 do 
--         --                         765                                 61198121018313
--         steamids[#steamids + 1] = "765" .. math.random(10000000000000, 99999999999999)
--         names[#names + 1] = "Player " .. i

--         YAWS.Database.Query(nil, [[
--             INSERT INTO awarn3_playertable(PlayerID, PlayerName, PlayerWarnings, LastWarning, LastPlayed, LastWarningDecay) VALUES(%s, %s, 0, 0, 0, 0);
--         ]], YAWS.Database.String(steamids[#steamids]), YAWS.Database.String(names[#names]))
--     end 

--     for i=0,10000 do
--         local steamid = steamids[math.random(1, #steamids)]
--         local reason = "Reason " .. i
--         local admin = steamids[math.random(1, #steamids)]
--         local timestamp = math.random(1, os.time())

--         YAWS.Database.Query(nil, [[
--             INSERT INTO awarn3_warningtable(PlayerID, AdminID, WarningReason, WarningServer, WarningDate) VALUES(%s, %s, %s, 'Server', %s);
--         ]], YAWS.Database.String(steamid), YAWS.Database.String(admin), YAWS.Database.String(reason), YAWS.Database.String(timestamp))
--     end 

--     print("done")
-- end 