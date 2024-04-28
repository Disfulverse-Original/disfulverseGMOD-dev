--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:ItemStore", function()
    local compatibilityName = "ACC2:ItemStore"

    ACC2.RegisterCompatibility(compatibilityName, {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)            
            local compatibiltiyTable = {}

            if not transfered[compatibilityName] then
                if ply.Bank then
                    local bank = {}

                    for k, v in pairs(ply.Bank:GetItems()) do
                        bank[k] = {
                            ["Class"] = v.Class, 
                            ["Data"] = v.Data,
                        }
                    end

                    compatibiltiyTable["itemstore_bank"] = bank
                end

                if ply.Inventory then
                    local inventory = {}

                    for k, v in pairs(ply.Inventory:GetItems()) do
                        inventory[k] = {
                            ["Class"] = v.Class, 
                            ["Data"] = v.Data,
                        }
                    end

                    compatibiltiyTable["itemstore_inventory"] = inventory
                end
            else
                compatibiltiyTable["itemstore_inventory"] = (characterArguments["itemstore_inventory"] or {})
                compatibiltiyTable["itemstore_bank"] = (characterArguments["itemstore_bank"] or {})
            end
            
            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

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

            if ply.Bank then
                local bank = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */

                for k, v in pairs(ply.Bank:GetItems()) do
                    bank[k] = {
                        ["Class"] = v.Class, 
                        ["Data"] = v.Data,
                    }
                end

                compatibiltiyTable["itemstore_bank"] = bank
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

            if ply.Inventory then
                local inventory = {}

                for k, v in pairs(ply.Inventory:GetItems()) do
                    inventory[k] = {
                        ["Class"] = v.Class, 
                        ["Data"] = v.Data,
                    }
                end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980

                compatibiltiyTable["itemstore_inventory"] = inventory
            end

            return compatibiltiyTable
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            local inventories = (charactersData["itemstore_inventory"] or {})
            local bank = (charactersData["itemstore_bank"] or {})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a

            if ply.Bank then
                ply.Bank.Items = {}
                
                for k, v in pairs(bank) do
                    ply.Bank:SetItem(k, itemstore.Item(v.Class, v.Data))
                end

                ply.Bank:QueueSync()
            end

            if ply.Inventory then
                ply.Inventory.Items = {}

                for k, v in pairs(inventories) do
                    ply.Inventory:SetItem(k, itemstore.Item(v.Class, v.Data))
                end

                ply.Inventory:QueueSync()
            end
        end,
    }, itemstore)
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
