--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

hook.Add("ACC2:OnCompatibilitiesLoaded", "ACC2:Compatibilities:RCD", function()
    local compatibilityName = "ACC2:RealisticCardealer"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

    ACC2.RegisterCompatibility(compatibilityName, {
        ["ACC2:Character:Created"] = function(ply, characterId, characterArguments, dontLoad, transfered)            
            local compatibiltiyTable = {}

            ply.RCD = ply.RCD or {}
            if not transfered["ACC2:RealisticCardealer"] then
                compatibiltiyTable["RCDVehicleBought"] = (ply.RCD.vehicleBought or {})
            else
                compatibiltiyTable["RCDVehicleBought"] = (characterArguments["RCDVehicleBought"] or {})
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

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

            ply.RCD = ply.RCD or {}
            compatibiltiyTable["RCDVehicleBought"] = (ply.RCD.vehicleBought or {})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

            compatibiltiyTable["characterId"] = characterId
            compatibiltiyTable["ownerId64"] = ply:SteamID64()

            return compatibiltiyTable
        end,
    }, {
        ["ACC2:Load:Character"] = function(ply, characterId, oldCharacterId, charactersData)
            ply.RCD = ply.RCD or {}
            ply.RCD.vehicleBought = (charactersData["RCDVehicleBought"] or {})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

            local boughVehiclesCompressed = util.Compress(util.TableToJSON(ply.RCD.vehicleBought))
    
            net.Start("RCD:Main:Client")
                net.WriteUInt(10, 4)
                net.WriteUInt(#boughVehiclesCompressed, 32)
                net.WriteData(boughVehiclesCompressed, #boughVehiclesCompressed)
            net.Send(ply)
        end,
    }, RCD)
end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
