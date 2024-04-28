--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

function ACC2.GetCompatibilityImported(name, callback)
    ACC2.Query(([[ SELECT imported FROM acc2_compatibilities_import WHERE name = %s ]]):format(ACC2.Escape(name)), function(data)
        if isfunction(callback) then
            local imported = false

            if data && data[1] && data[1]["imported"] then
                imported = tobool(data[1]["imported"])
            end

            callback(imported)
        end
    end)
end

--[[ Transfert of https://www.gmodstore.com/market/view/character-creator-the-best-character-creation-script ]]
function ACC2.TransfertCharacterCreator(ply)
    if not CharacterCreator then return end

    ACC2.GetCompatibilityImported("characterCreator", function(imported)
        if imported then
            ply:ACC2Notification(5, ACC2.GetSentence("alreadyImported"))
            return 
        end
        
        local files, directories = file.Find("charactercreator/*", "DATA")
        if not istable(directories) then return end

        for fileId, fileName in ipairs(directories) do
            if not file.Exists("charactercreator/"..fileName, "DATA") then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

            local filesCharacters, directoriesCharacters = file.Find("charactercreator/"..fileName.."/*", "DATA")
            if not istable(filesCharacters) then continue end

            for characterId, characterFile in ipairs(filesCharacters) do
                local readTable = file.Read("charactercreator/"..fileName.."/"..characterFile, "DATA")
                if not isstring(readTable) then continue end
                
                local tbl = util.JSONToTable(readTable)
                local globalName = tbl["CharacterCreatorName"] or "Invalid Name"
                local globalNameExploded = string.Explode(" ", globalName)

                local name = globalNameExploded[1] or "Invalid"
                local lastName = globalNameExploded[2] or "Invalid"

                local weaponsSave = {}
                if istable(tbl["CharacterCreatorWeapons"]) then
                    for k, v in pairs(tbl["CharacterCreatorWeapons"]) do
                        weaponsSave[#weaponsSave + 1] = {
                            ["class"] = v,
                        }
                    end
                end

                local minAge, maxAge = (ACC2.GetSetting("minimumAge", "number") or 18), (ACC2.GetSetting("maximumAge", "number") or 80)

                local characterTableToSave = {
                    ["health"] = tonumber(tbl["CharacterCreatorSaveHealth"]) or 100,
                    ["armor"] = tonumber(tbl["CharacterCreatorSaveArmor"]) or 0,
                    ["money"] = tonumber(tbl["CharacterCreatorSaveMoney"]) or 0,
                    ["food"] = 100,
                    ["position"] = tbl["CharacterCreatorPosition"],
                    ["job"] = (tbl["CharacterCreatorSaveJob"] or team.GetName(1)),
                    ["model"] = (tbl["CharacterCreatorModel"] or ""),
                    ["name"] = (name or "Invalid"),
                    ["lastName"] = (lastName or "Invalid"),
                    ["weapons"] = weaponsSave,
                    ["age"] = math.random(minAge, maxAge),
                    ["size"] = 1,
                    ["bodygroups"] = {},
                    ["ownerId64"] = fileName,
                }

                ACC2.CreateCharacter(fileName, player.GetBySteamID64(fileName), characterTableToSave, true)
            end
        end

        ACC2.Query(([[ INSERT INTO acc2_compatibilities_import (name, imported) VALUES (%s, %s) ]]):format(ACC2.Escape("characterCreator"), "1"))

        if IsValid(ply) then
            ply:ACC2Notification(5, ACC2.GetSentence("importationOf"):format("Character Creator"))
        end
    end)
end

concommand.Add("acc2_import_charactercreator", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end
    
    ACC2.TransfertCharacterCreator(ply)
end)

local function getJobByCommand(command)
    local jobs = table.Copy(RPExtraTeams) or {}

    for k, v in pairs(jobs) do
        if v.command == command then
            return v.name
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980

    return false
end

--[[ Transfert function of https://www.gmodstore.com/market/view/aden-character-system ]]
function ACC2.TransfertAdenCharacter(ply)
    if not Aden_DC then return end

    ACC2.GetCompatibilityImported("adenCharacter", function(imported)
        if imported then
            ply:ACC2Notification(5, ACC2.GetSentence("alreadyImported"))
            return 
        end

        Aden_DC:SQLRequest([[SELECT * FROM `arrayCharacter`]], function(data)
            if not istable(data) then return end

            for k, v in pairs(data) do
                if not isstring(v.steamid64) then continue end

                local position
                local posX, posY, posZ = tonumber(v.posX), tonumber(v.posY), tonumber(v.posZ)
                if isnumber(posX) && isnumber(posY) && isnumber(posZ) then
                    position = Vector(posX, posY, posZ)
                end

                local weaponsSave = {}
                if isstring(v.cWeapons) then
                    local weaponsToLoop = util.JSONToTable(v.cWeapons)
                    if istable(weaponsToLoop) then
                        for k, v in pairs(weaponsToLoop) do
                            weaponsSave[#weaponsSave + 1] = {
                                ["class"] = v,
                            }
                        end
                    end
                end

                local bodygroups = {}
                if isstring(v.bodyGroups) then
                    bodygroups = util.JSONToTable(v.bodyGroups)
                end

                local years = tonumber(v.years)

                local age = 0
                if isnumber(years) then
                    age = tonumber(os.date("%Y", os.time())) - years 
                end

                local jobId = tonumber(v.cJob)

                local jobName = team.GetName(1)
                if isnumber(jobId) then
                    jobName = team.GetName(jobId)
                end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

                local characterTableToSave = {
                    ["health"] = tonumber(v.cHealth) or 100,
                    ["armor"] = tonumber(v.cArmor) or 0,
                    ["money"] = tonumber(v.cMoney) or 0,
                    ["food"] = tonumber(v.cFood) or 100,
                    ["position"] = position,
                    ["job"] = jobName,
                    ["model"] = v.cModel or "",
                    ["name"] = v.firstName or "Invalid",
                    ["lastName"] = v.lastName or "Invalid",
                    ["weaponsSave"] = weaponsSave,
                    ["age"] = age,
                    ["size"] = tonumber(v.mScale) or 1,
                    ["bodygroups"] = bodygroups,
                    ["oldCharacterId"] = tonumber(v.index),
                    ["ownerId64"] = v.steamid64,
                }
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

                ACC2.CreateCharacter(v.steamid64, player.GetBySteamID64(v.steamid64), characterTableToSave, true, function(characterId)
                    local whitelist = v.withlist or ""
                    whitelist = util.JSONToTable(whitelist) or {}

                    if istable(whitelist) then
                        for jobId, bool in pairs(whitelist) do
                            if not bool then continue end

                            local jobIdConverted = tonumber(jobId)
                            local jobName = team.GetName(jobIdConverted)
                            
                            if not isstring(jobName) then continue end
                            
                            ACC2.ChangePlayersWhitelistSettings(v.steamid64, characterId, jobName, true, nil, player.GetBySteamID64(v.steamid64))
                        end
                    end
                end)
            end

            ACC2.Query(([[ INSERT INTO acc2_compatibilities_import (name, imported) VALUES (%s, %s) ]]):format(ACC2.Escape("adenCharacter"), "1"))

            if IsValid(ply) then
                ply:ACC2Notification(5, ACC2.GetSentence("importationOf"):format("Aden Character"))
            end
        end)
    end)
end

concommand.Add("acc2_import_adencharacter", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end

    ACC2.TransfertAdenCharacter(ply)
end)

--[[ Transfert function of https://www.gmodstore.com/market/view/voidchar-character-system-1 ]]
function ACC2.TransfertVoidCharacter(ply)
    if not VoidChar then return end

    ACC2.GetCompatibilityImported("voidCharacter", function(imported)
        if imported then
            ply:ACC2Notification(5, ACC2.GetSentence("alreadyImported"))
            return 
        end
        
        ACC2.Query([[ SELECT * FROM `VoidChar_characters` ]], function(data)
            if not istable(data) then return end

            for k, v in pairs(data) do
                if not isstring(v.sid) then continue end

                local globalName = v.name or "Invalid Name"
                local globalNameExploded = string.Explode(" ", globalName)

                local name = globalNameExploded[1] or "Invalid"
                local lastName = globalNameExploded[2] or "Invalid"

                local minAge, maxAge = (ACC2.GetSetting("minimumAge", "number") or 18), (ACC2.GetSetting("maximumAge", "number") or 80)

                local bodygroups = {}
                if isstring(v.bodygroups) then
                    bodygroups = util.JSONToTable(v.bodygroups)
                end

                local characterTableToSave = {
                    ["health"] = 100,
                    ["armor"] = 0,
                    ["money"] = tonumber(v.wallet) or 0,
                    ["food"] = 100,
                    ["job"] = team.GetName(1),
                    ["model"] = v.model or "",
                    ["name"] = name or "Invalid",
                    ["lastName"] = lastName or "Invalid",
                    ["weaponsSave"] = {},
                    ["age"] = math.random(minAge, maxAge),
                    ["size"] = 1,
                    ["bodygroups"] = bodygroups,
                    ["oldCharacterId"] = tonumber(v.id),
                    ["ownerId64"] = v.sid,
                }

                ACC2.CreateCharacter(v.sid, player.GetBySteamID64(v.sid), characterTableToSave, true, function(characterId)
                    ACC2.Query([[ SELECT * FROM `VoidChar_whitelist` ]], function(data)
                        if not istable(data) then return end
                
                        for k, v in pairs(data) do
                            local jobs = util.JSONToTable(v.jobs) or {}
                            if not istable(jobs) then continue end
                
                            for jobCommand, jobWhitelist in pairs(jobs) do
                                local jobName = getJobByCommand(jobCommand)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

                                if jobName == false then 
                                    jobName = team.GetName(1) 
                                end

                                ACC2.ChangePlayersWhitelistSettings(v.sid, characterId, jobName, jobWhitelist, nil, player.GetBySteamID64(v.sid))
                            end
                        end
                    end)
                end)
            end

            ACC2.Query(([[ INSERT INTO acc2_compatibilities_import (name, imported) VALUES (%s, %s) ]]):format(ACC2.Escape("voidCharacter"), "1"))

            if IsValid(ply) then
                ply:ACC2Notification(5, ACC2.GetSentence("importationOf"):format("Void Character"))
            end
        end)
    end)
end

concommand.Add("acc2_import_voidcharacter", function(ply, cmd, args)
    if ply != NULL then 
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
    end

    ACC2.TransfertVoidCharacter(ply)
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
