--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:CrapheadAtm", function()
    local compatibilityName = "ACC2:CrapHeadAtm"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

    ACC2.RegisterCompatibility(compatibilityName, {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)            
            local compatibiltiyTable = {}

            if not transfered[compatibilityName] then
                compatibiltiyTable["chatm_bankAccount"] = CH_ATM.GetMoneyBankAccount(ply)
                compatibiltiyTable["chatm_accountLevel"] = CH_ATM.GetAccountLevel(ply)
            else
                compatibiltiyTable["chatm_bankAccount"] = (characterArguments["chatm_bankAccount"] or CH_ATM.Config.AccountStartMoney)
                compatibiltiyTable["chatm_accountLevel"] = (characterArguments["chatm_accountLevel"] or 1)
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a
            
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

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            compatibiltiyTable["chatm_bankAccount"] = CH_ATM.GetMoneyBankAccount(ply)
            compatibiltiyTable["chatm_accountLevel"] = CH_ATM.GetAccountLevel(ply)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

            return compatibiltiyTable
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            local bankAccount = (charactersData["chatm_bankAccount"] or 0)
            local accountLevel = (charactersData["chatm_accountLevel"] or 1)

            ply.CH_ATM_BankAccount, ply.CH_ATM_BankAccountLevel = bankAccount, accountLevel
            
            CH_ATM.NetworkBankAccountToPlayer(ply)
        end,
    }, CH_ATM)
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
