--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:XeninInventory", function()
    local compatibilityName = "ACC2:XeninInventory"

    ACC2.RegisterCompatibility(compatibilityName, {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)            
            local compatibiltiyTable = {}

            if not transfered[compatibilityName] then
                compatibiltiyTable["xenin_inventory"] = ply:XeninInventory():GetInventory()
                compatibiltiyTable["xenin_bank"] = ply:XeninInventory():GetBank()
            else
                compatibiltiyTable["xenin_inventory"] = (characterArguments["xenin_inventory"] or {})
                compatibiltiyTable["xenin_bank"] = (characterArguments["xenin_bank"] or {})
            end
            
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            compatibiltiyTable["xenin_inventory"] = ply:XeninInventory():GetInventory()
            compatibiltiyTable["xenin_bank"] = ply:XeninInventory():GetBank()

            return compatibiltiyTable
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            local inventories = (charactersData["xenin_inventory"] or {})
            local bank = (charactersData["xenin_bank"] or {})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

            ply:XeninInventory():SetInventory(inventories)
            ply:XeninInventory():SetBank(bank)
            ply:XeninInventory():NetworkAll()
        end,
    }, XeninInventory)
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
