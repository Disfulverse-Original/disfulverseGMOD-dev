--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:Wos", function()
    local compatibilityName = "ACC2:Wos"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */
    
    local hookWOS = {
        "wOS.ALCS.Dueling.PassiveReset", 
        "wOS.ALCS.ExecSys.RemoveState", 
        "wOS.ALCS.ExecSys.SendExecutions", 
        "wOS.ALCS.ResetBonePos", 
        "wOS.Prestige.ActivatePlayerSpawns", 
        "wOS.SkillTree.ActivatePlayerSpawns",
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */

    ACC2.RegisterCompatibility(compatibilityName, {}, {
        ["wOS.ALCS.GetCharacterID"] = function(ply)
            return ACC2.GetNWVariables("characterId", ply)
        end,
        ["ACC2:Character:Save"] = function(ply, characterId, characterArguments)
            hook.Call("wOS.ALCS.PlayerSaveData", nil, ply)
        end,
        ["ACC2:RemoveCharacter"] = function(characterId, ply, ownerId64)
            if not IsValid(ply) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

            hook.Call("wOS.ALCS.PlayerDeleteData", nil, ply, characterId)
        end,
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            hook.Call("wOS.ALCS.PlayerLoadData", nil, ply)

            timer.Simple(1, function()
                if not IsValid(ply) then return end

                local hookTable = hook.GetTable()

                for hookId, hookName in ipairs(hookWOS) do
                    if hookTable["PlayerSpawn"][hookName] then
                        hookTable["PlayerSpawn"][hookName](ply)
                    end
                end
            end)
        end,
    }, wOS)
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
