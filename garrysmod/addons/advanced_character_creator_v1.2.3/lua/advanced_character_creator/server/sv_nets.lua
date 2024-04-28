--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

util.AddNetworkString("ACC2:Admin:Configuration")
util.AddNetworkString("ACC2:Notification")
util.AddNetworkString("ACC2:MainNet")
util.AddNetworkString("ACC2:Character")

net.Receive("ACC2:Admin:Configuration", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    ply.ACC2 = ply.ACC2 or {}

    local curTime = CurTime()

    ply.ACC2["spamConfig"] = ply.ACC2["spamConfig"] or 0
    if ply.ACC2["spamConfig"] > curTime then return end
    ply.ACC2["spamConfig"] = curTime + 0.3
 
    local uInt = net.ReadUInt(4)

    --[[ Save settings ]]
    if uInt == 1 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local settings = {}
        local settingsCount = net.ReadUInt(12)

        for i=1, settingsCount do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))

            settings[key] = value
        end

        ACC2.SetSettings(settings)
        ply:ACC2Notification(5, ACC2.GetSentence("savedSettings"))

    --[[ Create or update a faction ]]
    elseif uInt == 2 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local edit = net.ReadBool()
        local name = net.ReadString()
        local logo = net.ReadString()
        local description = net.ReadString()
        local defaultJob = net.ReadString()
        local groupId = net.ReadUInt(16)

        local models = {}

        local modelCount = net.ReadUInt(16)
        for i=1, modelCount do
            local model = net.ReadString()
            models[model] = true
        end
        
        local ranksAccess = {}
        
        local ranksAccessUint = net.ReadUInt(16)
        for i=1, ranksAccessUint do
            local job = net.ReadString()
            
            ranksAccess[job] = true
        end

        if not istable(ranksAccess) or table.IsEmpty(ranksAccess) then ranksAccess = {["*"] = true} end
        
        local jobsAccess = {}
        
        local jobsAccessUint = net.ReadUInt(16)
        for i=1, jobsAccessUint do
            local job = net.ReadString()
            
            jobsAccess[job] = true
        end

        if not istable(jobsAccess) or table.IsEmpty(jobsAccess) then jobsAccess = {["*"] = true} end
        
        if edit then
            local factionUniqueId = net.ReadUInt(16)
            if not isnumber(factionUniqueId) then return end

            ACC2.UpdateFaction(ply, factionUniqueId, name, logo, description, defaultJob, groupId, models, ranksAccess, jobsAccess)
        else
            ACC2.CreateFaction(ply, name, logo, description, defaultJob, groupId, models, ranksAccess, jobsAccess)
        end
    --[[ Remove a faction ]]
    elseif uInt == 3 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local factionUniqueId = net.ReadUInt(16)
        
        ACC2.RemoveFaction(ply, factionUniqueId)

     --[[ Create or update a category ]]
    elseif uInt == 4 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

        local edit = net.ReadBool()
        local name = net.ReadString()
        local logo = net.ReadString()
        local description = net.ReadString()

        local ranksAccess = {}
        
        local ranksAccessUInt = net.ReadUInt(16)
        for i=1, ranksAccessUInt do
            local job = net.ReadString()
            
            ranksAccess[job] = true
        end

        if not istable(ranksAccess) or table.IsEmpty(ranksAccess) then ranksAccess = {["*"] = true} end
        
        if edit then
            local categoryUniqueId = net.ReadUInt(16)
            if not isnumber(categoryUniqueId) then return end

            ACC2.UpdateCategory(ply, categoryUniqueId, name, logo, description, ranksAccess)
        else
            ACC2.CreateCategory(ply, name, logo, description, ranksAccess)
        end

    --[[ Remove a specific category ]]
    elseif uInt == 5 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local groupUniqueId = net.ReadUInt(16)
        
        ACC2.RemoveCategory(ply, groupUniqueId)

    --[[ Get all characters of a steamID ]]
    elseif uInt == 6 then
        if not ply:ACC2CanOpenWhitelist() then return end

        local steamId64 = net.ReadString()
        steamId64 = string.find("STEAM_", steamId64) and util.SteamIDTo64(steamId64) or steamId64

        ACC2.SendCharacter(ply, steamId64, nil, {
            ["name"] = true, 
            ["lastName"] = true, 
            ["prefix"] = true, 
            ["model"] = true, 
            ["money"] = true, 
            ["job"] = true, 
            ["characterId"] = true, 
            ["whitelist"] = true,
            ["deletedAt"] = true
        }, function(characterCount)
            if characterCount <= 0 then
                ply:ACC2Notification(5, ACC2.GetSentence("dontHaveCharacter"))
                return 
            end

            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(4, 4)
                net.WriteString(steamId64)
            net.Send(ply)
        end, nil, true)

    --[[ Save player information ]]
    elseif uInt == 7 then
        if not ply:ACC2CanOpenWhitelist() then return end

        local whitelistByContext = net.ReadBool()
        local steamId64 = net.ReadString()
        local characterId = net.ReadUInt(22)
        
        local userGroup = ply:GetUserGroup()

        if not ACC2.GetSetting("enableContextToWhitelist", "boolean") && whitelistByContext then
            return
        end

        local name, lastName, model, money
        if ACC2.AdminRank[userGroup] && not whitelistByContext then
            name = net.ReadString()
            lastName = net.ReadString()
            model = net.ReadString()
            money = net.ReadUInt(32)
        end

        local target = player.GetBySteamID64(steamId64)
        local plyTeam = team.GetName(ply:Team())

        local jobCount = net.ReadUInt(16)
        for i=1, jobCount do
            local jobName = net.ReadString()
            local whitelisted = net.ReadBool()
            local blacklisted = net.ReadBool()
                
            local permissions = ACC2.WhitelistSettings[jobName] or {}
            local permission = permissions["permissions"] or {}
            
            local jobPermission = permission[plyTeam] or {}
            local userGroupPermission = permission[userGroup] or {}

            local canManageWhitelist = jobPermission["canManageWhitelist"] or userGroupPermission["canManageWhitelist"]
            local canManageBlacklist = jobPermission["canManageBlacklist"] or userGroupPermission["canManageBlacklist"]
            
            if not canManageWhitelist && not ACC2.AdminRank[userGroup] then
                whitelisted = nil
            end

            if not canManageBlacklist && not ACC2.AdminRank[userGroup] then
                blacklisted = nil
            end

            if blacklisted == nil && whitelisted == nil then
                ply:ACC2Notification(5, ACC2.GetSentence("noPermission"))
                return
            end

            if not ACC2.AdminRank[userGroup] or whitelistByContext then
                if IsValid(target) then
                    ply:ACC2Notification(5, ACC2.GetSentence("updatedWhitelistCharacter"))
                    target:ACC2Notification(5, ACC2.GetSentence("updatedWhitelistCharacterBy"):format(target:Name()))
                end
            end

            ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, whitelisted, blacklisted, target, ply, function()
                
                local toSend =  {["whitelist"] = true, ["name"] = true, ["lastName"] = true, ["model"] = true, ["job"] = true, ["characterId"] = true, ["deletedAt"] = true}
                if ACC2.AdminRank[ply:GetUserGroup()] then
                    toSend["money"] = true
                end

                ACC2.SendCharacter(ply, steamId64, nil, toSend, function()
                    if not whitelistByContext then
                        net.Start("ACC2:Admin:Configuration")
                            net.WriteUInt(4, 4)
                            net.WriteString(steamId64)
                            net.WriteUInt(characterId, 22)
                        net.Send(ply)
                    end
                end)
            end)
        end

        if ACC2.AdminRank[userGroup] && not whitelistByContext then 
            local globalName = ACC2.GetFormatedName(name, lastName)
    
            ACC2.Query(([[
                UPDATE acc2_characters_compatibilities SET value = %s WHERE keyName = 'name' AND compatibilityName = 'ACC2:Characters' AND characterId = %s;
                UPDATE acc2_characters_compatibilities SET value = %s WHERE keyName = 'lastName' AND compatibilityName = 'ACC2:Characters' AND characterId = %s;
                UPDATE acc2_characters_compatibilities SET value = %s WHERE keyName = 'globalName' AND compatibilityName = 'ACC2:Characters' AND characterId = %s;
                UPDATE acc2_characters_compatibilities SET value = %s WHERE keyName = 'model' AND compatibilityName = 'ACC2:Characters' AND characterId = %s;
                UPDATE acc2_characters_compatibilities SET value = %s WHERE keyName = 'money' AND compatibilityName = 'ACC2:Characters' AND characterId = %s;
            ]]):format(ACC2.Escape(name), ACC2.Escape(characterId),  ACC2.Escape(lastName), ACC2.Escape(characterId), ACC2.Escape(globalName), ACC2.Escape(characterId), ACC2.Escape(model), ACC2.Escape(characterId), ACC2.Escape(money), ACC2.Escape(characterId)), function(data)

                ACC2.SendCharacter(ply, steamId64, nil, {
                    ["name"] = true, 
                    ["lastName"] = true, 
                    ["prefix"] = true, 
                    ["model"] = true, 
                    ["money"] = true, 
                    ["job"] = true, 
                    ["characterId"] = true, 
                    ["whitelist"] = true,
                    ["deletedAt"] = true
                }, function()
                    if not whitelistByContext then
                        net.Start("ACC2:Admin:Configuration")
                            net.WriteUInt(4, 4)
                            net.WriteString(steamId64)
                            net.WriteUInt(characterId, 22)
                        net.Send(ply)
                    end
                end, nil, true)
    
                ply:ACC2Notification(5, ACC2.GetSentence("updatedCharacterOf"):format(globalName))
                                
                if IsValid(target) then
                    if ACC2.GetNWVariables("characterId", target) == characterId then
                        if isstring(name) && isstring(lastName) then
                            target:ACC2SetName(ACC2.GetFormatedName(name, lastName))
                        end
                        
                        if isstring(model) then
                            target:SetModel(model)
                        end
                        
                        if isnumber(money) then
                            target:ACC2SetMoney(money)
                        end
                    end
                    
                    target:ACC2Notification(5, ACC2.GetSentence("updatedYourCharacter"):format(ply:Name(), ACC2.GetFormatedName(name, lastName)))
                    
                    ACC2.SendCharacter(target, steamId64, {[characterId] = true}, {
                        ["name"] = true, 
                        ["lastName"] = true, 
                        ["prefix"] = true, 
                        ["model"] = true, 
                        ["money"] = true, 
                        ["job"] = true, 
                        ["characterId"] = true,
                        ["deletedAt"] = true
                    })
                end
            end)
        end
    elseif uInt == 8 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local steamId64 = net.ReadString()
        local characterId = net.ReadUInt(22)

        ACC2.RemoveCharacter(characterId, steamId64, ply)
    elseif uInt == 9 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local jobName = net.ReadString()
        local whitelistEnable = net.ReadBool()
        local blacklistEnable = net.ReadBool()
        local defaultWhitelist = net.ReadBool()
        local defaultBlacklist = net.ReadBool()

        local permissionsTbl = {}

        local countTable = net.ReadUInt(16)
        for i=1, countTable do
            local keyName = net.ReadString()
            local canManageWhitelist = net.ReadBool()
            local canManageBlacklist = net.ReadBool()

            permissionsTbl[keyName] = {
                ["canManageWhitelist"] = canManageWhitelist,
                ["canManageBlacklist"] = canManageBlacklist,
            }
        end

        ply:ACC2Notification(5, ACC2.GetSentence("updatedSettingsOf"):format(jobName))

        ACC2.ChangeWhitelistSettings(jobName, whitelistEnable, blacklistEnable, defaultWhitelist, defaultBlacklist, permissionsTbl)
    elseif uInt == 10 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local page = net.ReadUInt(12)
        local whitelistType = net.ReadString()
        local jobName = net.ReadString()

        ACC2.SelectWhitelistPage(whitelistType, page, ply, jobName)
    elseif uInt == 11 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end

        local steamId64 = net.ReadString()
        local characterIdSended = net.ReadBool()
        
        local target = player.GetBySteamID64(steamId64)
        local validTarget = IsValid(target)

        if characterIdSended then
            characterId = net.ReadUInt(22)
        elseif IsValid(target) then
            characterId = ACC2.GetNWVariables("characterId", target) 
        end

        if not isnumber(characterId) then
            ply:ACC2Notification(5, ACC2.GetSentence("noPlayerLoaded"))
            return 
        end
            
        local page = net.ReadUInt(12)
        local jobName = net.ReadString()
        local whitelistType = net.ReadString()
        local value = net.ReadBool()
        local name = (validTarget and target:Name() or steamId64)

        if whitelistType == "whitelisted" then
            ply:ACC2Notification(5, ACC2.GetSentence((value and "addedToTheWhitelist" or "removedToTheWhitelist")):format(name))

            if validTarget then
                target:ACC2Notification(5, ACC2.GetSentence((value and "addedToTheWhitelistBy" or "removedToTheWhitelistBy")):format(ply:Name(), jobName))
            end

            ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, value, nil, target, ply, function()
                ACC2.SelectWhitelistPage(whitelistType, page, ply, jobName)
            end)
        elseif whitelistType == "blacklisted" then
            ply:ACC2Notification(5, ACC2.GetSentence((value and "addedToTheBlacklist" or "removedToTheBlacklist")):format(name))

            if validTarget then
                target:ACC2Notification(5, ACC2.GetSentence((value and "addedToTheBlacklistBy" or "removedToTheBlacklistBy")):format(ply:Name(), jobName))
            end

            ACC2.ChangePlayersWhitelistSettings(steamId64, characterId, jobName, nil, value, target, ply, function()
                ACC2.SelectWhitelistPage(whitelistType, page, ply, jobName)
            end)
        end

    elseif uInt == 12 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
        
        local userGroup = net.ReadString()
        local jobName = net.ReadString()

        local page = net.ReadUInt(12)
        local whitelistType = net.ReadString()
        local value = net.ReadBool()
        
        if whitelistType == "whitelisted" then
            ply:ACC2Notification(5, ACC2.GetSentence((value and "addedUsergroupToTheWhitelist" or "removedUsergroupToTheWhitelist")):format(userGroup, jobName))

            ACC2.ChangeUserGroupsWhitelistSettings(userGroup, jobName, value, nil)
        elseif whitelistType == "blacklisted" then
            ply:ACC2Notification(5, ACC2.GetSentence((value and "addedUsergroupToTheBlacklist" or "removedUsergroupToTheBlacklist")):format(userGroup, jobName))

            ACC2.ChangeUserGroupsWhitelistSettings(userGroup, jobName, nil, value)
        end

        ACC2.SelectWhitelistPage(whitelistType, page, ply, jobName)
    elseif uInt == 13 then
        if not ACC2.AdminRank[ply:GetUserGroup()] then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

        local ownerId64 = net.ReadString()
        local characterId = net.ReadUInt(22)

        ACC2.ReEnableCharacter(characterId, ownerId64, ply)
    end
end)

net.Receive("ACC2:Character", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply.ACC2 = ply.ACC2 or {}

    local curTime = CurTime()

    ply.ACC2["spamConfig"] = ply.ACC2["spamConfig"] or 0
    if ply.ACC2["spamConfig"] > curTime then return end
    ply.ACC2["spamConfig"] = curTime + 0.5
 
    local uInt = net.ReadUInt(4)

    --[[ Create a basic character ]]
    if uInt == 1 then
        local modifyCharacter = net.ReadBool()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7
        
        local npcClass = ""
        if modifyCharacter then
            npcClass = "acc2_modify_character"
        elseif not modifyCharacter then
            npcClass = "acc2_mainmenu"
        end
        
        if not ply:ACC2CanInteractWithMenu(npcClass) then
            ply:ACC2Notification(5, ACC2.GetSentence("cannotInteract"))
            return
        end

        if modifyCharacter then
            ply.ACC2 = ply.ACC2 or {}
            ply.ACC2["cooldownModification"] = ply.ACC2["cooldownModification"] or 0
    
            local curTime = CurTime()
            if ply.ACC2["cooldownModification"] > curTime then
                ply:ACC2Notification(5, ACC2.GetSentence("waitingTimeModification"):format(math.Round(ply.ACC2["cooldownModification"] - curTime)))
                return
            end

            local price = ACC2.GetSetting("priceToModifyCharacter", "number")
            if ply:ACC2GetMoney() < price && price > 0 then
                ply:ACC2Notification(5, ACC2.GetSentence("noteEnoughMoney"))
                return 
            end

            if price > 0 then
                ply:ACC2Notification(5, ACC2.GetSentence("paidForModification"):format(ACC2.formatMoney(price)))
                ply:ACC2AddMoney(-price)
            end
        else
            local maxCharacter = ply:ACC2GetMaxCharacter()
            
            ply.ACC2 = ply.ACC2 or {}
            ply.ACC2["characters"] = ply.ACC2["characters"] or {}
            
            if table.Count(ply.ACC2["characters"]) >= maxCharacter then
                ply:ACC2Notification(5, ACC2.GetSentence("maxCharacterNotify"))
                return 
            end
        end

        local name = net.ReadString()

        local minCharacterName, maxCharacterName = (ACC2.GetSetting("minCharacterName", "number") or 3), (ACC2.GetSetting("maxCharacterName", "number") or 8)
        if #name < minCharacterName or #name > maxCharacterName then return end

        local disableLastName = ACC2.GetSetting("disableLastName", "boolean")

        local lastName = net.ReadString()
        if not disableLastName then
            local minCharacterLastName, maxCharacterLastName = (ACC2.GetSetting("minCharacterLastName", "number") or 3), (ACC2.GetSetting("maxCharacterLastName", "number") or 8)
            
            if #lastName < minCharacterLastName or #lastName > maxCharacterLastName then return end
        end

        if ACC2.CheckNameBlacklisted(name, lastName) then
            ply:ACC2Notification(5, ACC2.GetSentence("blacklistedNameNotify"))
            return 
        end

        local age = net.ReadUInt(16)

        local minAge, maxAge = (ACC2.GetSetting("minimumAge", "number") or 18), (ACC2.GetSetting("maximumAge", "number") or 80)
        age = math.Clamp(age, minAge, maxAge)

        local size = net.ReadFloat()
        local minSize, maxSize = (ACC2.GetSetting("minSizeValue", "number") or 0.9), (ACC2.GetSetting("maxSizeValue", "number") or 1.1)
        size = math.Clamp(size, minSize, maxSize)

        local sexSelected = net.ReadUInt(3)

        local description = net.ReadString()
        local model = net.ReadString()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

        local bodygroups = {}
        local countBodygroups = net.ReadUInt(16)
        for i=1, countBodygroups do
            local id = net.ReadUInt(16)
            local value = net.ReadUInt(16)
            
            bodygroups[id] = value
        end

        local factionId = net.ReadUInt(12)
        if ACC2.Factions && istable(ACC2.Factions[factionId]) then
            local ranksAccess = ACC2.Factions[factionId]["ranksAccess"] or {}
            
            if not ranksAccess[ply:GetUserGroup()] && not ranksAccess["*"] then
                ply:ACC2Notification(5, ACC2.GetSentence("ranksAccessFaction"))

                return 
            end
        end

        if not ACC2.CheckModelOnTable(model, factionId) then
            ply:ACC2Notification(5, ACC2.GetSentence("invalidModel"))
            return 
        end

        local canCreateCharacter, notify = hook.Run("ACC2:CanCreateCharacter", ply, ACC2.GetNWVariables("characterId", ply), name, lastName, age, size, model, bodygroups, factionId)
        if canCreateCharacter == false then
            if isstring(notify) && notify != "" then
                ply:ACC2Notification(5, notify)
            end
            return 
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

        local characterArguments = {
            ["name"] = name,
            ["lastName"] = lastName,
            ["globalName"] = ACC2.GetFormatedName(name, lastName),
            ["age"] = age,
            ["size"] = size,
            ["model"] = model,
            ["bodygroups"] = bodygroups,
            ["factionId"] = factionId,
            ["description"] = description,
            ["sexSelected"] = sexSelected,
        }

        if modifyCharacter then
            ply:ACC2UpdateCharacter(characterArguments, true)
            ply:ACC2Notification(5, ACC2.GetSentence("updatedCharacter"):format(ACC2.GetFormatedName(name, lastName)))

            local cooldown = ACC2.GetSetting("cooldownToModifyCharacter", "number")

            if isnumber(cooldown) then
                ply.ACC2["cooldownModification"] = CurTime() + cooldown
            end
        else
            ACC2.CreateCharacter(ply:SteamID64(), ply, characterArguments)
            ply:ACC2Notification(5, ACC2.GetSentence("createdCharacter"):format(ACC2.GetFormatedName(name, lastName)))
        end
    elseif uInt == 2 then
        if not ply:ACC2CanInteractWithMenu("acc2_mainmenu") then
            ply:ACC2Notification(5, ACC2.GetSentence("cannotInteract"))
            return
        end

        local characterId = net.ReadUInt(22)
        if not ply:ACC2CheckCharacter(characterId) then return end
        
        if not ACC2.GetSetting("canRemoveWhenNotAllowed", "boolean") then
            if not ply:ACC2CanLoadCharacter(characterId, ply.ACC2["characters"]) then return end
        end

        local canDelete, notify = hook.Run("ACC2:CanDeleteCharacter", ply, characterId)
        if canDelete == false then
            if isstring(notify) && notify != "" then
                ply:ACC2Notification(5, notify)
            end
            return 
        end
        
        if characterId == ACC2.GetNWVariables("characterId", ply) then
            ACC2.SetNWVariable("characterId", "nil", ply, true, nil, true)
        end
        
        ACC2.RemoveCharacter(characterId, ply:SteamID64())
    elseif uInt == 3 then
        if not ply:ACC2CanInteractWithMenu("acc2_mainmenu") then
            ply:ACC2Notification(5, ACC2.GetSentence("cannotInteract"))
            return
        end
        
        local characterId = net.ReadUInt(22)
        if not ply:ACC2CheckCharacter(characterId) then return end

        if not ACC2.GetSetting("canSelectWhenNotAllowed", "boolean") then
            if not ply:ACC2CanLoadCharacter(characterId, ply.ACC2["characters"]) then return end
        end
        
        local odlCharacterId = ACC2.GetNWVariables("characterId", ply)
        hook.Run("ACC2:PreLoad:Character", ply, characterId, odlCharacterId, ply.ACC2["characters"][characterId])
        
        hook.Run("ACC2:Load:Character", ply, characterId, odlCharacterId, ply.ACC2["characters"][characterId])
    elseif uInt == 4 then
        if not ply:ACC2CanInteractWithMenu("acc2_rpname") then
            ply:ACC2Notification(5, ACC2.GetSentence("cannotInteract"))
            return
        end

        ply.ACC2 = ply.ACC2 or {}
        ply.ACC2["cooldownRPName"] = ply.ACC2["cooldownRPName"] or 0

        local curTime = CurTime()
        if ply.ACC2["cooldownRPName"] > curTime then
            ply:ACC2Notification(5, ACC2.GetSentence("waitingTimeRPName"):format(math.Round(ply.ACC2["cooldownRPName"] - curTime)))
            return
        end
        
        local price = ACC2.GetSetting("priceToModifyRPName", "number")

        if ply:ACC2GetMoney() < price && price > 0 then
            ply:ACC2Notification(5, ACC2.GetSentence("noteEnoughMoney"))
            return 
        end
        
        if price > 0 then
            ply:ACC2Notification(5, ACC2.GetSentence("paidForRPName"):format(ACC2.formatMoney(price)))
            ply:ACC2AddMoney(-price)
        end
        
        local name = net.ReadString()

        local minCharacterName, maxCharacterName = (ACC2.GetSetting("minCharacterName", "number") or 3), (ACC2.GetSetting("maxCharacterName", "number") or 8)
        if #name < minCharacterName or #name > maxCharacterName then return end

        local lastName = net.ReadString()

        local disableLastName = ACC2.GetSetting("disableLastName", "boolean")

        if not disableLastName then
            local minCharacterLastName, maxCharacterLastName = (ACC2.GetSetting("minCharacterLastName", "number") or 3), (ACC2.GetSetting("maxCharacterLastName", "number") or 8)
            if #lastName < minCharacterLastName or #lastName > maxCharacterLastName then return end
        end

        local canChangeName, notify = hook.Run("ACC2:CanChangeName", ply, name, lastName)
        if canChangeName == false then
            if isstring(notify) && notify != "" then
                ply:ACC2Notification(5, notify)
            end
            return 
        end

        local characterArguments = {
            ["name"] = name,
            ["lastName"] = lastName,
            ["globalName"] = ACC2.GetFormatedName(name, lastName),
        }

        ply:ACC2UpdateCharacter(characterArguments, false)
        ply:ACC2Notification(5, ACC2.GetSentence("changedName"):format(ACC2.GetFormatedName(name, lastName)))

        local cooldown = ACC2.GetSetting("cooldownToModifyRPName", "number")

        if isnumber(cooldown) then
            ply.ACC2["cooldownRPName"] = CurTime() + cooldown
        end
    elseif uInt == 5 then
        ply.ACC2 = ply.ACC2 or {}

        if not ACC2.GetSetting("canOpenMenuWithKey", "boolean") then return end

        local curTime = CurTime()

        local canOpenMenuWithKey, notify = hook.Run("ACC2:CanOpenMenuWithKey", ply)
        if canOpenMenuWithKey == false then
            if isstring(notify) && notify != "" then
                ply:ACC2Notification(5, notify)
            end
            return
        end

        ply.ACC2["cooldownOpenWithKey"] = ply.ACC2["cooldownOpenWithKey"] or 0
        if ply.ACC2["cooldownOpenWithKey"] > curTime then
            return 
        end

        ply.ACC2["cooldownOpenWithKey"] = curTime + ACC2.GetSetting("cooldownToOpen", "number")

        ply.ACC2["canInteractWithMenu"] = true
        ply:ACC2OpenCharacterMenu(true)
    elseif uInt == 6 then
        ply.ACC2 = ply.ACC2 or {}

        if not ACC2.GetSetting("canOpenModificationMenuWithKey", "boolean") then return end

        local curTime = CurTime()

        local canOpenMenuWithKey, notify = hook.Run("ACC2:CanOpenModificationMenuWithKey", ply)
        if canOpenMenuWithKey == false then
            if isstring(notify) && notify != "" then
                ply:ACC2Notification(5, notify)
            end
            return
        end

        ply.ACC2["cooldownOpenModificationWithKey"] = ply.ACC2["cooldownOpenModificationWithKey"] or 0
        if ply.ACC2["cooldownOpenModificationWithKey"] > curTime then
            return 
        end

        ply.ACC2["cooldownOpenModificationWithKey"] = curTime + ACC2.GetSetting("cooldownToOpenModification", "number")

        ply.ACC2["canInteractWithMenu"] = true
        ply:ACC2OpenCharacterModificationMenu()
    end
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
