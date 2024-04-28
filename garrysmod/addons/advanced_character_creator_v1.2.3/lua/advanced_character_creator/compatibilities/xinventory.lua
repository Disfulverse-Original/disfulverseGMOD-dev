--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:XInventory", function()
    local compatibilityName = "ACC2:XInventory"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

    ACC2.RegisterCompatibility(compatibilityName, {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)            
            local compatibiltiyTable = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

            if not transfered[compatibilityName] then
                compatibiltiyTable["xinventory_inventory"] = ply.xInventoryInventory
            else
                compatibiltiyTable["xinventory_inventory"] = (characterArguments["xinventory_inventory"] or {})
            end
            
            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            --[[ This is used to avoid duplication don't forget it ]]
            ACC2.Query(([[ INSERT INTO acc2_compatibilities_transfert (compatibilityName, value, ownerId64) VALUES (%s, %s, %s) ]]):format(
                ACC2.Escape(compatibilityName),
                "1",
                ACC2.Escape(ply:SteamID64())
            ))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

            return compatibiltiyTable
        end,
        ["ACC2:Character:Save"] = function(ply, characterId, characterArguments)
            local compatibiltiyTable = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            compatibiltiyTable["xinventory_inventory"] = ply.xInventoryInventory

            return compatibiltiyTable
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            local inventories = (charactersData["xinventory_inventory"] or {})

            ply.xInventoryInventory = inventories
            xInventory.SendInventory(ply)
        end,
    }, xInventory)
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
