--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

--[[ Make sure sentence exist and also langage exist]]
function ACC2.GetSentence(key, forceLang)
    local result = "Lang Problem"
    local lang = ACC2.GetSetting("lang", "string")

    if isstring(forceLang) then
        lang = forceLang
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

    if istable(ACC2.Language) && ACC2.Language[lang] && ACC2.Language[lang][key] then
        result = ACC2.Language[lang][key]
    elseif istable(ACC2.Language) && ACC2.Language["en"] && ACC2.Language["en"][key] then
        result = ACC2.Language["en"][key]
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

    return result
end

function ACC2.GetJobIdByName(name)
    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end
        if v.Name == name then return k end
    end
end

--[[ Convert a number to a format number ]]
function ACC2.formatMoney(money)
    if not isnumber(tonumber(money)) then return 0 end
    money = string.Comma(money)

    return isfunction(ACC2.Currencies[ACC2.GetSetting("currency", "string")]) and ACC2.Currencies[ACC2.GetSetting("currency", "string")](money) or money
end

--[[ Get networked variables ]]
function ACC2.GetNWVariables(key, ent)
    return (IsValid(ent) and (ent.ACC2NWVariables or {}) or (ACC2.NWVariables or {}))[key]
end

--[[ Format a number ]]
function ACC2.FormatNumber(time)
    if not isnumber(time) then return end
    local dateString = "%Ss"

    if time/60 >= 1 then
        dateString = "%Mm %Ss"

        if time/3600 >= 1 then
            dateString = "%Hh %Mm %Ss"

            if time/86400 >= 1 then
                dateString = "%dd %Hh %Mm %Ss"
            end
        end
    end
    return dateString
end

--[[ Get sequence of characters ]]
function ACC2.GetSequencialCharacters(tbl)
    if not istable(tbl) then return end

    local tableToLoop = table.GetKeys(tbl)
    table.sort(tableToLoop, function(a, b) return a < b end)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

    local tableToReturn = {}

    for k, characterId in ipairs(tableToLoop) do
        tableToReturn[k] = characterId
    end

    return tableToReturn
end

local PLAYER = FindMetaTable("Player")

function PLAYER:ACC2CanLoadCharacter(characterId, charactersTbl)
    if not istable(charactersTbl) then return end

    local canLoadCharacter, notify = hook.Run("ACC2:CanLoadCharacter", self, characterId)
    if canLoadCharacter == false then
        if isstring(notify) && notify != "" then
            if CLIENT then
                ACC2.Notification(5, notify)
            else
                self:ACC2Notification(5, notify)
            end
        end 
        return 
    end

    local tableToLoop = ACC2.GetSequencialCharacters(charactersTbl)
    local maxCharacter = self:ACC2GetMaxCharacter()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

    if not isnumber(maxCharacter) then
        maxCharacter = tonumber(maxCharacter) or 1
    end

    local notUniqueId = 0
    
    for k, v in pairs(tableToLoop) do
        notUniqueId = notUniqueId + 1

        if v == characterId then
            if notUniqueId <= maxCharacter then return true end
        end
    end
end

function PLAYER:ACC2GetMaxCharacter()
    local maxCharacter = ACC2.GetSetting("maxPlayerCharacters", "table")
    local userGroup = self:GetUserGroup()

    if istable(maxCharacter) then
        maxCharacter = tonumber(maxCharacter[userGroup]) or 1
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

    local maxCharacterOveride = hook.Run("ACC2:GetMaxCharacter", self, userGroup, maxCharacter)

    if isnumber(maxCharacterOveride) then
        maxCharacter = maxCharacterOveride
    end

    return (maxCharacter or 1)
end

-- [[ Check if the name is blacklisted ]]
function ACC2.CheckNameBlacklisted(name, lastName)
    local nameBlacklist = ACC2.GetSetting("blacklistedSurnameAndName", "table")

    local blacklistCopy = table.Copy(nameBlacklist or {})
    
    for k, v in pairs(blacklistCopy) do
        blacklistCopy[k:lower()] = true
    end

    if blacklistCopy[string.lower(string.Trim(name))] then
        return true
    end

    if blacklistCopy[string.lower(string.Trim(lastName))] then
        return true
    end
end

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:ACC2GetMoney()
    if DarkRP then
        return self:getDarkRPVar("money")
    elseif ix then
        return (self:GetCharacter() != nil and self:GetCharacter():GetMoney() or 0)
    elseif nut then
        return (self:getChar() != nil and self:getChar():getMoney() or 0)
    end

    return 0
end

--[[ Get setting with the keyname ]]
function ACC2.GetSetting(key, settingType)
    if settingType == "number" then
        return tonumber(ACC2.DefaultSettings[key]) or 0
    elseif settingType == "string" then
        return tostring(ACC2.DefaultSettings[key]) or ""
    elseif settingType == "boolean" then
        return tobool(ACC2.DefaultSettings[key]) or false
    elseif settingType == "table" then
        return ACC2.DefaultSettings[key] or {}
    end

    return ACC2.DefaultSettings[key]
end

--[[ Format name and surname ]]
function ACC2.GetFormatedName(name, lastName)
    local lastName = (lastName or ACC2.GetSentence("invalid"))

    return ((name or ACC2.GetSentence("invalid"))..(lastName != "" and " " or "")..lastName)
end

function ACC2.PrefixedName(prefix, name, lastName)
    prefix = string.gsub(prefix, "{L}", function()
        return string.char(math.random(65, 90))
    end)

    prefix = string.gsub(prefix, "{N}", function()
        return tostring(math.random(0, 9))
    end)

    prefix = string.gsub(prefix, "{name}", name)
    prefix = string.gsub(prefix, "{lastName}", lastName)

    return prefix
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
