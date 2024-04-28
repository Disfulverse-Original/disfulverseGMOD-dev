--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:BaseCompatibility:OnCompatibilitiesLoaded", function()
    --[[ Example of a compatibility, you need to add your compatibility when this hook is called : ACC2:OnCompatibilitiesLoaded

        // Put a unique name on the first argument
        ACC2.RegisterCompatibility("ACC2:Example", {
            // This is the table to save informations about the character
            // Here you can put any hook that you want to get informations and store them on my table

            ["PlayerDeath"] = function(ply) // All arguments are parsed on the function
                
                // You can get any variables of the hook, I invite you to put them on a table
                // Be careful you need to add on your table the characterId and the steamId of the player
                // If you don't have it you can get it with the function ACC2.GetNWVariables("characterId", ply)
                // This value is only available when the player has selected the character so you will not be able to have it on PlayerInitialSpawn for example

                local characterTable = { 
                    ["characterId"] = ACC2.GetNWVariables("characterId", ply),
                    ["ownerId64"] = ply:SteamID64(),
                    ["name"] = ply:Name(),
                    ["armor"] = ply:Armor(),
                }

                // To save all your values you just have to return your table
                // if you cannot return because you use a query for example you can use this function : ACC2.SaveCompatibilityData(returnTable, uniqueName) and you don't have to return the table
                return characterTable
            end,
        }, {
            // This is the table to restore all your variables
            // Here you can put any hook that you want to restore your values
            // We will restore values stored below
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

            ["PlayerSpawn"] = function(ply)
                // To get values you have two differents way the first with arguments of my hooks
                // Like "ACC2:Character:Created" return ply, characterId, characterArguments
                // Like "ACC2:Character:Update" return ply, characterArguments
                // Like "ACC2:Load:Character" return ply, characterId, oldCharacterId, charactersData
                // The second way is to get values manually with this function

                // Put your compatibility unique name and the unique characterId
                
                ACC2.GetCompatibilityValue("ACC2:Example", characterId, function(data)
                    local name = data["name"]
                    local armor = data["armor"]

                    print(characterId, name, armor)
                end)

                return true -- You can also return arguments on hooks
            end,
        }, ACC2, true) // Third argument is the table to check if the addon is on the server and the last just to not create a settings to allow admin to disable it.

        // If you change basic information like name, model, money, job... Don't forget to resync informations
        // ACC2.SendCharacter(ply, ply:SteamID64(), {[characterId] = true}, {["name"] = true, ["lastName"] = true, ["money"] = true, ["job"] = true, ["age"] = true, ["size"] = true, ["model"] = true})
    ]]

    --[[ This is the default compatibility to save all basic info of the player DON'T DELETE IT ]]
    ACC2.RegisterCompatibility("ACC2:Characters", {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)
            if not istable(characterArguments) or not isnumber(characterId) then return end
        
            --[[ Always need this line to define on the table the characterId ]]
            characterArguments["characterId"] = characterId
            characterArguments["globalName"] = ACC2.GetFormatedName(characterArguments["name"], characterArguments["lastName"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */
            
            if IsValid(ply) then
                characterArguments["ownerId64"] = ply:SteamID64()
                
                ply.ACC2 = ply.ACC2 or {}
                ply.ACC2["characters"] = ply.ACC2["characters"] or {}
                ply.ACC2["characters"][characterId] = {}

                if not isstring(characterArguments["job"]) then
                    local defaultJob = ACC2.GetSetting("defaultJob", "string")

                    if isstring(defaultJob) then
                        characterArguments["job"] = defaultJob
                    end
                end
                
                if not isnumber(characterArguments["money"]) then
                    characterArguments["money"] = (ACC2.GetSetting("moneyWhenCreating", "number") or 5000)
                end

                local factionId = tonumber(characterArguments["factionId"])
                if isnumber(factionId) then
                    ACC2.Factions = ACC2.Factions or {}

                    local faction = ACC2.Factions[factionId] or {}
                    local jobAccess = faction["jobsAccess"] or {}

                    if isstring(faction["defaultJob"]) then
                        characterArguments["job"] = faction["defaultJob"]
                    end

                    for k, v in pairs(jobAccess) do
                        if k == "*" then continue end
                        if not v then continue end

                        ACC2.ChangePlayersWhitelistSettings(ply:SteamID64(), characterId, k, true, nil, ply)
                    end
                end

                local prefixTable = ACC2.GetSetting("prefixTable", "table")
                local jobId = ACC2.GetJobIdByName(characterArguments["job"])

                if isnumber(jobId) then
                    local jobName = team.GetName(jobId)
                    local jobPrefix = prefixTable[jobName]

                    if isstring(jobPrefix) then
                        characterArguments["prefix"] = characterArguments["prefix"] or {}
                        characterArguments["prefix"][jobName] = ACC2.PrefixedName(jobPrefix, (characterArguments["name"] or ""), (characterArguments["lastName"] or ""))
                    end
                end
    
                timer.Simple(0.1, function()
                    if not IsValid(ply) then return end
    
                    ACC2.SendCharacter(ply, ply:SteamID64(), {[characterId] = true}, {
                        ["name"] = true, 
                        ["lastName"] = true,
                        ["prefix"] = true,
                        ["money"] = true, 
                        ["job"] = true, 
                        ["age"] = true, 
                        ["size"] = true, 
                        ["model"] = true,
                        ["factionId"] = true,
                        ["bodygroups"] = true,
                        ["characterId"] = true,
                        ["description"] = true,
                        ["sexSelected"] = true,
                        ["deletedAt"] = true
                    })
                end)
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */
            
            return characterArguments
        end,
        ["ACC2:Character:Save"] = function(ply, characterId, characterArguments, dontSend)                  
            local compatibiltiyTable = {}

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            local map = string.lower(game.GetMap())

            compatibiltiyTable["armor"] = ply:Armor()
            compatibiltiyTable["health"] = ply:Health()
            compatibiltiyTable["position:"..map] = ply:GetPos()
            compatibiltiyTable["shootPos"] = ply:GetEyeTrace().HitPos

            local dontLoadJob = ACC2.GetSetting("dontLoadJob", "table")
            local jobName =  team.GetName(ply:Team())

            if not dontLoadJob[jobName] then
                compatibiltiyTable["job"] = jobName
            end

            local dontOverrideModel = ACC2.GetSetting("dontOverrideModel", "table")

            if not dontOverrideModel[jobName] then
                compatibiltiyTable["model"] = ply:GetModel()
            end

            compatibiltiyTable["bodygroups"] = {}

            for k, v in pairs(ply:GetBodyGroups()) do
                compatibiltiyTable["bodygroups"][v["id"]] = ply:GetBodygroup(v["id"])
            end

            local wep = ply:GetActiveWeapon()
            if IsValid(wep) then
                compatibiltiyTable["activeWeapon"] = wep:GetClass()
            end

            compatibiltiyTable["globalName"] = ACC2.GetFormatedName(characterArguments["name"], characterArguments["lastName"])
            compatibiltiyTable["money"] = ply:ACC2GetMoney()
            
            local weps = ply:ACC2GetWeapons()
            compatibiltiyTable["weapons"] = weps

            if not dontSend then
                timer.Simple(0.1, function()
                    if not IsValid(ply) then return end

                    ACC2.SendCharacter(ply, ply:SteamID64(), {[characterId] = true}, {
                        ["name"] = true, 
                        ["lastName"] = true,
                        ["prefix"] = true,
                        ["money"] = true, 
                        ["job"] = true, 
                        ["age"] = true, 
                        ["size"] = true, 
                        ["model"] = true,
                        ["factionId"] = true,
                        ["bodygroups"] = true,
                        ["characterId"] = true,
                        ["description"] = true,
                        ["sexSelected"] = true,
                        ["deletedAt"] = true
                    })
                end)
            end

            return compatibiltiyTable
        end,
        ["ACC2:Character:Update"] = function(ply, characterArguments, fade)
            local characterId = ACC2.GetNWVariables("characterId", ply)
            if not isnumber(characterId) then return end

            characterArguments["characterId"] = characterId
            characterArguments["ownerId64"] = ply:SteamID64()

            ply:ACC2LoadCharacter({["name"] = true, ["model"] = true, ["size"] = true}, characterArguments, true)

            timer.Simple(0.2, function()
                ACC2.SendCharacter(ply, ply:SteamID64(), {[characterId] = true}, {
                    ["name"] = true, 
                    ["lastName"] = true,
                    ["prefix"] = true,
                    ["money"] = true, 
                    ["job"] = true, 
                    ["age"] = true, 
                    ["size"] = true, 
                    ["model"] = true,
                    ["factionId"] = true,
                    ["bodygroups"] = true,
                    ["characterId"] = true,
                    ["description"] = true,
                    ["sexSelected"] = true,
                    ["deletedAt"] = true
                })
            end)

            net.Start("ACC2:Character")
                net.WriteUInt(6, 4)
                net.WriteBool(fade)
            net.Send(ply)

            return characterArguments
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            if not IsValid(ply) then return end

            --[[ Make sure that the character is a character of the player ]]
            if not ply:ACC2CheckCharacter(characterId) then return end

            ACC2.SetNWVariable("characterId", characterId, ply, true, nil, true)

            --[[ 
                Get all value that you saved before on your module with the characterId.
                if you don't have it you can use the function to get the current characterId of the player.

                ACC2.GetNWVariables("characterId", ply)
            ]]
            if istable(charactersData) then
                ply:ACC2LoadCharacter({["*"] = true}, charactersData)

                net.Start("ACC2:Character")
                    net.WriteUInt(1, 4)
                net.Send(ply)
            else
                ACC2.GetCompatibilityValue("ACC2:Characters", characterId, function(data)
                    ply:ACC2LoadCharacter({["*"] = true}, data)

                    net.Start("ACC2:Character")
                        net.WriteUInt(1, 4)
                    net.Send(ply)
                end)
            end
        end,
    }, ACC2, true)
end)

--[[ When we want to save the character we only have to call those hook ]]

hook.Add("PlayerDisconnected", "ACC2:SaveCharacter:PlayerDisconnected", function(ply)
    ply:ACC2SaveCharacter()
end)

local PLAYER = FindMetaTable("Player")

function PLAYER:ACC2SaveCharacterTimer()
    timer.Create("acc2_save_character_"..self:SteamID64(), 60, 0, function()
        if not IsValid(self) then return end

        local characterId = ACC2.GetNWVariables("characterId", self)

        if isnumber(characterId) then 
            self:ACC2SaveCharacter()
            if ACC2.GetSetting("enableCharacterSaveNotification", "boolean") then
                self:ACC2Notification(5, ACC2.GetSentence("characterSaved"))
            end
        end
    end)
end

--[[ Compatibilities function to add support of other gamemode if needed ]]

function PLAYER:ACC2SetName(name)
    if DarkRP then
        self:setRPName(name)
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

function PLAYER:ACC2SetJob(teamId)
    if DarkRP then
        self:changeTeam(teamId, true)
    end
end

function PLAYER:ACC2AddMoney(amount)
    if DarkRP then
        self:addMoney(amount)
    end
end

function PLAYER:ACC2SetMoney(amount)
    if DarkRP then
        self:addMoney(-self:getDarkRPVar("money") + amount)
    end
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
