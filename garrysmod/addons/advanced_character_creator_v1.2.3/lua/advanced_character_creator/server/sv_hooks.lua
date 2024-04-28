--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

--[[ Initialize all table and all information of ACC2 ]]
hook.Add("Initialize", "ACC2:Initialize:Table", function()
    print("[ACC2] Initialize ACC2")

    timer.Simple(5, function()
        ACC2.InitializeTables()
        ACC2.InitializeCategories()
        ACC2.InitializeFactions()
        ACC2.InitializeWhitelistSettings()
        ACC2.InizializeWhitelistUserGroups()

        ACC2.InitializeSettings(function()            
            if ACC2.GetSetting("precacheModels", "boolean") then
                ACC2.ModelsToPrecache = ACC2.ModelsToPrecache or {}
        
                local models1 = ACC2.GetSetting("defaultModelGroup1", "table") or {}
                for k, v in pairs(models1) do
                    util.PrecacheModel(k)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */
        
                    ACC2.ModelsToPrecache[#ACC2.ModelsToPrecache + 1] = k
                end
        
                local models2 = ACC2.GetSetting("defaultModelGroup2", "table") or {}
                for k, v in pairs(models2) do
                    util.PrecacheModel(k)
        
                    ACC2.ModelsToPrecache[#ACC2.ModelsToPrecache + 1] = k
                end
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101
            
            ACC2.LoadNPC()
        end)
    end)
end)

--[[ Initialize all information of the player ]]
hook.Add("PlayerInitialSpawn", "ACC2:PlayerInitialSpawn:Initialize", function(ply)
    timer.Simple(5, function()
        if not IsValid(ply) or not ply:IsPlayer() then return end

        ply.ACC2 = ply.ACC2 or {}
        ply.ACC2["canInteractWithMenu"] = true

        ACC2.SendSettings(ply)
        ACC2.SendFaction(nil, ply)
        ACC2.SendCategory(nil, ply)
        ACC2.SendWhitelistSettings(ply)
        ACC2.SendCompatibilities(ply)
        
        ply:ACC2IntitAllCharacters()
        ACC2.SendCharacter(ply, ply:SteamID64(), nil, {
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
        }, nil, true)
        ply:ACC2SaveCharacterTimer()
        ply:ACC2SyncAllVariables()
        ply:ACC2InitializeWhitelist()

        if ACC2.GetSetting("precacheModels", "boolean") then
            ply:ACC2PrecacheModels()
        end
    end)
end)

--[[ All command of the addon ]]
hook.Add("PlayerSay", "ACC2:PlayerSay:Command", function(ply, text)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    
    if string.lower(text) == string.lower(ACC2.GetSetting("adminCommand", "string")) then
        if not ACC2.AdminRank[ply:GetUserGroup()] then 
            ply:ACC2Notification(5, ACC2.GetSentence("noPermission"))
            return ""
        end
        
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(2, 5)
        net.Send(ply)
        return ""
    elseif string.lower(text) == string.lower(ACC2.GetSetting("whitelistCommand", "string")) then
        if ACC2.AdminRank[ply:GetUserGroup()] then
            ply:ACC2OpenWhitelistMenu()
            return ""
        elseif ply:ACC2CanOpenWhitelist() then
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(8, 5)
            net.Send(ply)
            return ""
        else
            ply:ACC2Notification(5, ACC2.GetSentence("noPermission"))
            return ""
        end
        return ""
    end
end)

hook.Add("PlayerChangedTeam", "ACC2:Reload:PlayerChangedTeam", function(ply, oldTeam, newTeam)
    timer.Simple(1, function()
        if not IsValid(ply) then return end

        ply.ACC2 = ply.ACC2 or {}
        ply.ACC2["characters"] = ply.ACC2["characters"] or {}
    
        local characterId = ACC2.GetNWVariables("characterId", ply)
    
        if isnumber(characterId) then
            ply.ACC2["characters"][characterId] = ply.ACC2["characters"][characterId] or {}
            
            ply:ACC2LoadCharacter({["model"] = true}, ply.ACC2["characters"][characterId], true)
        end
    end)
end)

hook.Add("OnPlayerChangedTeam", "ACC2:Reload:OnPlayerChangedTeam", function(ply, oldTeam, newTeam)
    timer.Simple(1, function()
        if not IsValid(ply) then return end

        ply.ACC2 = ply.ACC2 or {}
        ply.ACC2["characters"] = ply.ACC2["characters"] or {}

        local characterId = ACC2.GetNWVariables("characterId", ply)

        if isnumber(characterId) then
            ply.ACC2["characters"][characterId] = ply.ACC2["characters"][characterId] or {}

            ply:ACC2LoadCharacter({["model"] = true, ["name"] = true}, ply.ACC2["characters"][characterId], true)
        end
    end)
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

hook.Add("PlayerDeath", "ACC2:Death:PlayerDeath", function(victim, inflictor, attacker)
    if not IsValid(victim) then return end

    victim.ACC2 = victim.ACC2 or {}
    victim.ACC2["isDeath"] = true

    if ACC2.GetSetting("deleteCharacterWhenDie", "boolean") then
        local characterId = ACC2.GetNWVariables("characterId", victim)
        characterId = tonumber(characterId)
        
        if isnumber(characterId) then
            ACC2.RemoveCharacter(characterId, victim:SteamID64(), nil, true)
            ACC2.SetNWVariable("characterId", "nil", victim, true, nil, true)
        end
    end
end)

hook.Add("PlayerSpawn", "ACC2:Menu:PlayerSpawn", function(ply)
    if not IsValid(ply) then return end
    
    ply.ACC2 = ply.ACC2 or {}
    
    if ply.ACC2["isDeath"] && ACC2.GetSetting("enableMenuOnDeath", "boolean") then
        ply:ACC2SaveCharacter()
        ply:ACC2OpenCharacterMenu()

        ACC2.SetNWVariable("characterId", "nil", ply, true, nil, true)

        ply.ACC2["canInteractWithMenu"] = true

        return
    else
      	timer.Simple(1, function()
          	if not IsValid(ply) then return end
          	
            local characterId = ACC2.GetNWVariables("characterId", ply)
            if not isnumber(characterId) then return end

            ply.ACC2 = ply.ACC2 or {}
            ply.ACC2["characters"] = ply.ACC2["characters"] or {}
            ply.ACC2["characters"][characterId] = ply.ACC2["characters"][characterId] or {}

            ply:ACC2LoadCharacter({["model"] = true, ["name"] = true}, ply.ACC2["characters"][characterId], true)
        end)
    end

    timer.Simple(1, function()
        if not IsValid(ply) then return end

        ply.ACC2["isDeath"] = nil
    end)
end)

--[[ Load all NPC on the map ]]
hook.Add("PostCleanupMap", "ACC2:Reload:PostCleanupMap", function() 
    ACC2.LoadNPC()
end)

--[[ Whitelist system ]]
hook.Add("playerCanChangeTeam", "ACC2:playerCanChangeTeam:Whitelist", function(ply, job)
    return ACC2.WhitelistCheck(ply, job)
end)

hook.Add("PostGamemodeLoaded", "DisableRPChatCommands", function()
        DarkRP.removeChatCommand("rpname")
        DarkRP.removeChatCommand("name")
        DarkRP.removeChatCommand("nick")
end)

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
