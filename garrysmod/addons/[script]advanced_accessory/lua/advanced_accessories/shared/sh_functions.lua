/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

-- [[ Compress table ]] --
function AAS.CompressTable(tbl)
    if not istable(tbl) then return end

    return (util.Compress(util.TableToJSON(tbl)) or "")
end

-- [[ Uncompress table ]] --
function AAS.UnCompressTable(compressedString)
    if not isstring(compressedString) then return end

    return (util.JSONToTable(util.Decompress(compressedString)) or {})
end

--[[ Check if the category exist on the sh_advanced_configuration.lua ]]
function AAS.CheckCategory(category)
    for k,v in pairs(AAS.Category["mainMenu"]) do 
        if v.uniqueName == category then return true end 
    end
    return false 
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */

--[[ Convert a number to a format number ]]
function AAS.formatMoney(money)
    if not isnumber(money) then return 0 end

    money = string.Comma(money)

    return isfunction(AAS.Currencies[AAS.CurrentCurrency]) and AAS.Currencies[AAS.CurrentCurrency](money) or money
end

--[[ Serverside get the invetory table with a steamId64 and Clientside get your inventory ]]
function AAS.GetInventory(steamId64, callback)
    if SERVER then
        AAS.Query("SELECT * FROM aas_inventory WHERE steam_id = '"..steamId64.."'", function(inventoryQuery)
            local returnTable = {}
    
            for k,v in ipairs(inventoryQuery) do
                if not AAS.GetTableById(v.uniqueId) then continue end
    
                returnTable[#returnTable + 1] = v
            end
            
            callback(returnTable)
        end)
    else
        return AAS.ClientTable["ItemsInventory"]
    end
end

--[[ Make sure sentence exist and also langage exist]]
function AAS.GetSentence(string)
    local result = "Lang Problem"
    local sentence = istable(AAS.Language[AAS.Lang]) and AAS.Language[AAS.Lang][string] or "Lang Problem"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

    if istable(AAS.Language[AAS.Lang]) and isstring(sentence) then
        result = sentence
    elseif istable(AAS.Language["en"]) and isstring(AAS.Language["en"][sentence]) then
        result = AAS.Language["en"][sentence]
    end

    return result
end

local PLAYER = FindMetaTable("Player")

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:AASGetMoney()
    if DarkRP && isfunction(self.getDarkRPVar) then
        return self:getDarkRPVar("money")
    elseif ix && isfunction(self.GetCharacter) then
        return (self:GetCharacter() != nil and self:GetCharacter():GetMoney() or 0)
    elseif nut && isfunction(self.getChar) then
        return (self:getChar() != nil and self:getChar():getMoney() or 0)
    elseif self.PS2_Wallet then
        return self.PS2_Wallet.points
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

    return 0
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1 */

--[[ Get if the model is equipped on the player ]]
function PLAYER:AASModelEquiped(model)
    if SERVER then
        local exists, itemId = AAS.ItemExist(model)
        if not exists then return false end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

        for k,v in pairs(self.AASAccessories) do
            if tonumber(v) != iteamId then continue end

            return true
        end

        return false
    else
        local Equiped = false
        local itemsEquiped = AAS.ClientTable["ItemsEquiped"][self:SteamID64()] or {}
        
        for k,v in pairs(itemsEquiped) do
            if v.model == model then Equiped = true break end
        end

        return Equiped
    end
end
