--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/05/2023

--]]
local INTEGRATION = {}

INTEGRATION.Name = 'bLogs'
INTEGRATION.Color = Color(63, 75, 184)
INTEGRATION.Desc = 'https://www.gmodstore.com/market/view/billys-logs'

function INTEGRATION:Check()
    return (GAS ~= nil and GAS.Logging ~= nil)
end

function INTEGRATION:Load()
    if (SERVER) then
        self:LoadPurchaseLogs()
        self:LoadActionLogs()
        self:LoadRefundLogs()
        self:LoadConversionLogs()
        self:LoadConfigLogs()
        self:LoadAdminLogs()
    end
end

function INTEGRATION:LoadPurchaseLogs()
    local MODULE = GAS.Logging:MODULE()
    MODULE.Category = "Onyx Store"
    MODULE.Name = "Purchases"
    MODULE.Colour = Color(123, 255, 90)

    MODULE:Setup(function()
        MODULE:Hook("onyx.creditstore.PlayerPurchasedItem", "onyx.credistore.logs", function(ply, uniqueID, price)
            local itemTable = onyx.creditstore.items[uniqueID]
            local itemName = itemTable and itemTable.name or '_UNKNOWN_'
        
            MODULE:Log('{1} purchased the item \'{2}\' (id: {3}) for {4}', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(itemName), GAS.Logging:Highlight(uniqueID), GAS.Logging:Highlight(string.Comma(price) .. ' credits'))
        end)
    end)

    GAS.Logging:AddModule(MODULE)
end

function INTEGRATION:LoadConversionLogs()
    local MODULE = GAS.Logging:MODULE()
    MODULE.Category = "Onyx Store"
    MODULE.Name = "Conversions"
    MODULE.Colour = Color(123, 255, 90)

    MODULE:Setup(function()
        MODULE:Hook("onyx.creditstore.PlayerConvertedMoney", "onyx.credistore.logs", function(ply, giveAmount, receiveAmount)
            MODULE:Log('{1} converted {2} to {3}', GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatMoney(giveAmount), GAS.Logging:Highlight(string.Comma(receiveAmount) .. ' credits'))
        end)
        MODULE:Hook("onyx.creditstore.PlayerConvertedCredits", "onyx.credistore.logs", function(ply, giveAmount, receiveAmount)
            MODULE:Log('{1} converted {2} to {3}', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(string.Comma(giveAmount) .. ' credits'), GAS.Logging:FormatMoney(receiveAmount))
        end)
    end)

    GAS.Logging:AddModule(MODULE)
end

function INTEGRATION:LoadActionLogs()
    local MODULE = GAS.Logging:MODULE()
    MODULE.Category = "Onyx Store"
    MODULE.Name = "Actions"
    MODULE.Colour = Color(123, 255, 90)

    MODULE:Setup(function()
        MODULE:Hook("onyx.creditstore.PlayerUsedOption", "onyx.credistore.logs", function(ply, uniqueID, optionID)
            local itemTable = onyx.creditstore.items[uniqueID]
            local itemName = itemTable and itemTable.name or '_UNKNOWN_'
        
            MODULE:Log('{1} used {2} option on the inventory item \'{3}\' (id: {4})', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(optionID), GAS.Logging:Highlight(itemName), GAS.Logging:Highlight(uniqueID))
        end)
    end)

    GAS.Logging:AddModule(MODULE)
end

function INTEGRATION:LoadRefundLogs()
    local MODULE = GAS.Logging:MODULE()
    MODULE.Category = "Onyx Store"
    MODULE.Name = "Refunds"
    MODULE.Colour = Color(123, 255, 90)

    MODULE:Setup(function()
        MODULE:Hook("onyx.creditstore.PlayerRefundedItem", "onyx.credistore.logs", function(ply, uniqueID, price)
            local itemTable = onyx.creditstore.items[uniqueID]
            local itemName = itemTable and itemTable.name or '_UNKNOWN_'
        
            MODULE:Log('{1} refunded the inventory item \'{2}\' (id: {3}) for {4}', 
                GAS.Logging:FormatPlayer(ply),
                GAS.Logging:Highlight(itemName),
                GAS.Logging:Highlight(uniqueID),
                GAS.Logging:Highlight(string.Comma(price) .. ' credits')
            )
        end)
    end)

    GAS.Logging:AddModule(MODULE)
end

function INTEGRATION:LoadConfigLogs()
    local MODULE = GAS.Logging:MODULE()
    MODULE.Category = "Onyx Store"
    MODULE.Name = "Configuration"
    MODULE.Colour = Color(123, 255, 90)

    MODULE:Setup(function()
        MODULE:Hook("onyx.creditstore.PlayerCreatedCategory", "onyx.credistore.logs", function(ply, uniqueID, name)
            MODULE:Log('{1} created a new category \'{2}\' (id: {3})', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(name), GAS.Logging:Highlight(uniqueID))
        end)

        MODULE:Hook("onyx.creditstore.PlayerEditedCategory", "onyx.credistore.logs", function(ply, uniqueID)
            MODULE:Log('{1} edited the category with id: {2}', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(uniqueID))
        end)

        MODULE:Hook("onyx.creditstore.PlayerDeletedCategory", "onyx.credistore.logs", function(ply, uniqueID)
            MODULE:Log('{1} deleted the category with id: {2}', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(uniqueID))
        end)

        -------------------------------------------------------------------------------------------------------------------------
    
        MODULE:Hook("onyx.creditstore.PlayerCreatedItem", "onyx.credistore.logs", function(ply, uniqueID, typeID, name)
            local typeData = onyx.creditstore.types[typeID]
            local typeName = typeData and typeData.name or typeID

            MODULE:Log('{1} created a new item \'{2}\' (id: {3}, type: {4})', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(name), GAS.Logging:Highlight(uniqueID), GAS.Logging:Highlight(typeName))
        end)

        MODULE:Hook("onyx.creditstore.PlayerEditedItem", "onyx.credistore.logs", function(ply, uniqueID)
            MODULE:Log('{1} edited the item with id: {2}', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(uniqueID))
        end)

        MODULE:Hook("onyx.creditstore.PlayerDeletedItem", "onyx.credistore.logs", function(ply, uniqueID)
            MODULE:Log('{1} deleted the item with id: {2}', GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(uniqueID))
        end)
    end)

    GAS.Logging:AddModule(MODULE)
end

function INTEGRATION:LoadAdminLogs()
    local MODULE = GAS.Logging:MODULE()
    MODULE.Category = "Onyx Store"
    MODULE.Name = "Admin"
    MODULE.Colour = Color(123, 255, 90)

    MODULE:Setup(function()
        MODULE:Hook("onyx.creditstore.AdminCheckedInventory", "onyx.credistore.logs", function(ply, steamid64)
            MODULE:Log('{1} requsted {2}\'s inventory', GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(steamid64))
        end)

        MODULE:Hook("onyx.creditstore.AdminItemGiven", "onyx.credistore.logs", function(ply, target, itemID)
            local itemTable = onyx.creditstore.items[itemID]
            local itemName = itemTable.name
            
            MODULE:Log('{1} gave {2} (id: {3}) to {4}', 
                GAS.Logging:FormatPlayer(ply),
                GAS.Logging:Highlight(itemName),
                GAS.Logging:Highlight(itemID),
                GAS.Logging:FormatPlayer(target)
            )
        end)

        MODULE:Hook("onyx.creditstore.AdminTakeItem", "onyx.credistore.logs", function(ply, target, it)
            local itemID = it.id
            local itemTable = onyx.creditstore.items[itemID]
            local itemName = itemTable and itemTable.name or '_UNKNOWN_'
            
            MODULE:Log('{1} deleted single {2} (id: {3}) from {4}', 
                GAS.Logging:FormatPlayer(ply),
                GAS.Logging:Highlight(itemName),
                GAS.Logging:Highlight(itemID),
                GAS.Logging:FormatPlayer(target)
            )
        end)

        MODULE:Hook("onyx.creditstore.AdminTakeItemMultiple", "onyx.credistore.logs", function(ply, target, itemID, amount)
            local itemTable = onyx.creditstore.items[itemID]
            local itemName = itemTable and itemTable.name or '_UNKNOWN_'
            
            MODULE:Log('{1} deleted {2} copies of {3} (id: {4}) from {5}', 
                GAS.Logging:FormatPlayer(ply),
                GAS.Logging:Highlight(string.Comma(amount)),
                GAS.Logging:Highlight(itemName),
                GAS.Logging:Highlight(itemID),
                GAS.Logging:FormatPlayer(target)
            )
        end)
    end)

    GAS.Logging:AddModule(MODULE)
end

onyx.creditstore:RegisterIntegration('blogs', INTEGRATION)