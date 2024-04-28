--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:SlownlsATM", function()
    local compatibilityName = "ACC2:SlownlsATM"

    ACC2.RegisterCompatibility(compatibilityName, {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)            
            local compatibiltiyTable = {}

            if not transfered[compatibilityName] then
                ply.SlownLS_ATM_Account = ply.SlownLS_ATM_Account or {}
                compatibiltiyTable["slownls_account"] = (ply.SlownLS_ATM_Account.balance or 0)
            else
                compatibiltiyTable["slownls_account"] = (characterArguments["slownls_account"] or SlownLS.ATM.Config.DefaultBalance)
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823
            
            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            --[[ This is used to avoid duplication don't forget it ]]
            ACC2.Query(([[ INSERT INTO acc2_compatibilities_transfert (compatibilityName, value, ownerId64) VALUES (%s, %s, %s) ]]):format(
                ACC2.Escape(compatibilityName),
                "1",
                ACC2.Escape(ply:SteamID64())
            ))

            return compatibiltiyTable
        end,
        ["ACC2:Character:Save"] = function(ply, characterId, characterArguments)
            local compatibiltiyTable = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            compatibiltiyTable["slownls_account"] = ply.SlownLS_ATM_Account.balance
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

            return compatibiltiyTable
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            local bankAccount = (charactersData["slownls_account"] or 0)

            ply.SlownLS_ATM_Account = ply.SlownLS_ATM_Account or {}
            ply.SlownLS_ATM_Account.balance = bankAccount or 0
            
            SlownLS.ATM.Net:Start("sync", {
                account = ply.SlownLS_ATM_Account,
                isGroup = false,
            }, ply)      
        end,
    }, (SlownLS && SlownLS.ATM))
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
