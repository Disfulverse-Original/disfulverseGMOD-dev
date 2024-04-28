--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:WosMedals", function()
    local compatibilityName = "ACC2:WosMedals"
    
    ACC2.RegisterCompatibility(compatibilityName, {}, {
        ["ACC2:Character:Save"] = function(ply, characterId, characterArguments)
            local compatibiltiyTable = {}

            if not transfered[compatibilityName] then
                compatibiltiyTable["wos_medals"] = ply.SelectedMedals
                compatibiltiyTable["wos_accolade"] = ply.AccoladeList
            else
                compatibiltiyTable["wos_medals"] = (characterArguments["wos_medals"] or {})
                compatibiltiyTable["wos_accolade"] = (characterArguments["wos_accolade"] or {})
            end

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()
        end,
        ["ACC2:Character:Save"] = function(ply, characterId, characterArguments)
            local compatibiltiyTable = {}

            compatibiltiyTable["wos_medals"] = ply.SelectedMedals
            compatibiltiyTable["wos_accolade"] = ply.AccoladeList

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            return compatibiltiyTable
        end,
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            ply.SelectedMedals = (charactersData["wos_medals"] or {})
            ply.AccoladeList = (charactersData["wos_accolade"] or {})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

            net.Start("wOS.Medals.Badges.RequestBadgePos")
                net.WriteEntity(ply)
                net.WriteTable(ply.SelectedMedals)
            net.Broadcast()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

            wOS.Medals:SendPlayerMedals(ply)
        end,
    }, (wOS && wOS.Medals))
end)

                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
