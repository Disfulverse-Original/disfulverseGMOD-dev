--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Advanced Character Creator"
MODULE.Name = "Created Characters"
MODULE.Colour = Color(133, 48, 202)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

MODULE:Hook("ACC2:Character:Created", "ACC2:Character:Created:Log", function(ply, characterId, characterArguments, dontLoad, transfered)
    if IsValid(ply) then
        MODULE:Log(GAS.Logging:FormatPlayer(ply).." created the character "..GAS.Logging:Highlight("#"..characterId))
    else
        MODULE:Log("The character "..GAS.Logging:Highlight("#"..characterId).." was created by an unknown source")
    end
end)

GAS.Logging:AddModule(MODULE)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Advanced Character Creator"
MODULE.Name = "Removed Characters"
MODULE.Colour = Color(133, 48, 202)

MODULE:Hook("ACC2:RemoveCharacter", "ACC2:Character:RemoveCharacter:Log", function(characterId, target, ownerId64, remover)
    if IsValid(remover) then
        MODULE:Log(GAS.Logging:FormatPlayer(remover).." removed the character "..GAS.Logging:Highlight("#"..characterId))
    else
        MODULE:Log("The character "..GAS.Logging:Highlight("#"..characterId).." was removed by an unknown source")
    end
end)

GAS.Logging:AddModule(MODULE)

local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Advanced Character Creator"
MODULE.Name = "Whitelist & Blacklist"
MODULE.Colour = Color(133, 48, 202)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

MODULE:Hook("ACC2:ChangePlayerWhitelistSettings", "ACC2:Character:ChangePlayerWhitelistSettings:Log", function(steamId64, characterId, jobName, whitelisted, blacklisted, ply, manager)
    if whitelisted then
        if IsValid(manager) then
            MODULE:Log((IsValid(ply) and GAS.Logging:FormatPlayer(ply) or GAS.Logging:Highlight(steamId64)).." was whitelisted in "..GAS.Logging:Highlight(jobName).." by "..GAS.Logging:FormatPlayer(manager).." for the character "..GAS.Logging:Highlight("#"..characterId))
        else
            MODULE:Log(GAS.Logging:Highlight(steamId64).." was whitelisted in "..GAS.Logging:Highlight(jobName).." by an unknown source for the character "..GAS.Logging:Highlight("#"..characterId))
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

    if blacklisted then
        if IsValid(manager) then
            MODULE:Log((IsValid(ply) and GAS.Logging:FormatPlayer(ply) or GAS.Logging:Highlight(steamId64)).." was blacklisted in "..GAS.Logging:Highlight(jobName).." by "..GAS.Logging:FormatPlayer(manager).." for the character "..GAS.Logging:Highlight("#"..characterId))
        else
            MODULE:Log(GAS.Logging:Highlight(steamId64).." was blacklisted in "..GAS.Logging:Highlight(jobName).." by an unknown source for the character "..GAS.Logging:Highlight("#"..characterId))
        end
    end
end)

GAS.Logging:AddModule(MODULE)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
