--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/03/2023

--]]

util.AddNetworkString('onyx.creditstore:CreateItem')
util.AddNetworkString('onyx.creditstore:CreateCategory')
util.AddNetworkString('onyx.creditstore:EditCategory')
util.AddNetworkString('onyx.creditstore:EditItem')
util.AddNetworkString('onyx.creditstore:DeleteItem')
util.AddNetworkString('onyx.creditstore:DeleteCategory')
util.AddNetworkString('onyx.creditstore:AdminRequestInventory')
util.AddNetworkString('onyx.creditstore:AdminGiveItem')
util.AddNetworkString('onyx.creditstore:AdminTakeItem')

local creditstore = onyx.creditstore

local tIgnoreListWhenEdit = {
    ['id'] = true
}
local function validateItemData(itemData, bEdit)
    --[[------------------------------
    Validate basic data
    --------------------------------]]
    for key, value in pairs(itemData) do
        if (bEdit and tIgnoreListWhenEdit[key]) then goto CONTINUE end
        if (key ~= 'data') then
            if (not creditstore:ValidateFieldValue(key, value)) then
                return false
            end
        end
        ::CONTINUE::
    end

    --[[------------------------------
    Validate type required data (unrequired for categories)
    --------------------------------]]
    if (itemData.type) then
        local itemTypeTable = onyx.creditstore.types[itemData.type] -- cfg table
        local itemTypeData = itemData.data -- data provided from client
    
        for _, option in pairs(itemTypeTable.settings or {}) do
            local key = option.key
            local value = itemTypeData[key]
            if (value == nil or not option.validateOption(value)) then
                return false
            end
        end
    end

    return true
end

local function checkFields(tbl, keys)
    for _, key in pairs(keys) do
        if (not tbl[key]) then
            return false
        end
    end
    return true
end

local function allUnequipItem(itemID, oldType, oldItemTableData)
    local typeData = creditstore.types[oldType]
    if (typeData.equip) then
        
        for _, ply in ipairs(player.GetAll()) do
            local inventory = creditstore:GetPlayerInventory(ply)
            for index, it in ipairs(inventory) do
                if (it.id == itemID and it.data and it.data.equipped) then
                    if (typeData.onUnequip) then
                        typeData.onUnequip(ply, oldItemTableData)
                    end

                    it.data.equipped = nil
                    
                    creditstore:SyncInventoryItemData(ply, index)
                    creditstore:SaveInventory(ply)
                
                    -- print('unequip', ply, itemID)
                end
            end
        end

    end
end

--[[------------------------------
NETWORK
--------------------------------]]
local camiNetReceiveWrapper do
    local delay = {}
    function camiNetReceiveWrapper(netName, camiPrivilegeName, getData, callback)
        assert(isstring(netName), Format('bad argument #1 (string expected, got %s)', type(netName)))
        assert(isstring(camiPrivilegeName), Format('bad argument #2 (string expected, got %s)', type(camiPrivilegeName)))
        assert(camiPrivilegeName ~= '', 'bad argument #2 (string cannot be empty)')
        assert(isfunction(getData), Format('bad argument #3 (function expected, got %s)', type(getData)))
        assert(isfunction(callback), Format('bad argument #4 (function expected, got %s)', type(callback)))
    
        net.Receive(netName, function(len, ply)
            if ((delay[ply] or 0) > CurTime()) then return end

            -- read data from message asap and then pass it to async cami callback
            local data = getData and getData(len, ply) or {}

            CAMI.PlayerHasAccess(ply, camiPrivilegeName, function(hasAccess)
                -- print(netName, 'access', ply, hasAccess)
                if (hasAccess) then
                    callback(ply, data)
                end
            end)

            delay[ply] = CurTime() + 1
        end)
    end
end

camiNetReceiveWrapper('onyx.creditstore:CreateCategory', 'onyx_creditstore_edit', function()
    return {[1] = onyx.net.ReadTable()}
end, function(ply, data)
    local catData = data[1]

    --[[------------------------------
    Check fields
    --------------------------------]]
    if (not checkFields(catData, {'id', 'name', 'icon', 'order'})) then
        return
    end

    --[[------------------------------
    Validate data
    --------------------------------]]
    if (not validateItemData(catData)) then
        return
    end

    --[[------------------------------
    Create a category in DB
    --------------------------------]]
    local uniqueID = catData.id
    local name = catData.name
    local icon = catData.icon
    local order = tonumber(catData.order)

    creditstore:CreateCategory(uniqueID, name, icon, order, function()
        if (IsValid(ply)) then
            ply:ChatPrint('Created a new category!')
        end
    end)

    hook.Run('onyx.creditstore.PlayerCreatedCategory', ply, uniqueID, name)
end)

camiNetReceiveWrapper('onyx.creditstore:EditCategory', 'onyx_creditstore_edit', function(len, ply)
    local catID = net.ReadString()
    local catData = onyx.net.ReadTable()
    return {[1] = catID, [2] = catData}
end, function(ply, data)
    local catID = data[1]
    local catData = data[2]

    --[[------------------------------
    Check if item exists
    --------------------------------]]
    local catCurrentData = onyx.creditstore.categories[catID]
    if (not catCurrentData or catCurrentData.nocategory) then
        return
    end

    --[[------------------------------
    Validate data
    --------------------------------]]
    if (not validateItemData(catData, true)) then
        return
    end

    catData.id = catID
    catData.order = tonumber(catData.order)

    --[[------------------------------
    Check fields
    --------------------------------]]
    if (not checkFields(catData, {'id', 'name', 'icon', 'order'})) then
        return
    end

    local name = catData.name
    local icon = catData.icon
    local order = catData.order

    local query = onyx.creditstore.db:Update('onyx_creditstore_categories')
        query:Update('name', name)
        query:Update('icon', icon)
        query:Update('order', order)

        query:Where('id', catID)
        query:Limit(1)
        query:Callback(function()
            creditstore.categories[catID] = catData
            creditstore:SyncCategories()

            creditstore:Print('Updated the category: #', catID)
    
            if (IsValid(ply)) then
                ply:ChatPrint('You have updated the category!')
            end
        end)

    query:Execute()

    hook.Run('onyx.creditstore.PlayerEditedCategory', ply, catID)
end)

camiNetReceiveWrapper('onyx.creditstore:CreateItem', 'onyx_creditstore_edit', function(len, ply)
    return {[1] = onyx.net.ReadTable()}
end, function(ply, data)
    local itemData = data[1]

    --[[------------------------------
    Check fields
    --------------------------------]]
    if (not checkFields(itemData, {'id', 'name', 'price', 'type', 'data', 'category'})) then
        print('not enough fields')
        return
    end

    if (not itemData.icon and not itemData.model) then
        return
    end

    --[[------------------------------
    Validate data
    --------------------------------]]
    if (not validateItemData(itemData)) then
        print('failed validation')
        return
    end

    --[[------------------------------
    Actually register a new item
    --------------------------------]]
    local uniqueID = itemData.id
    local name = itemData.name
    local price = tonumber(itemData.price)
    local type = itemData.type
    local icon = itemData.icon
    local model = itemData.model
    local data = itemData.data
    local category = itemData.category

    creditstore:CreateItem(uniqueID, name, price, type, category, icon, model, data, function()
        if (IsValid(ply)) then
            ply:ChatPrint('Created a new item!')
        end
    end)

    hook.Run('onyx.creditstore.PlayerCreatedItem', ply, uniqueID, type, name)
end)

camiNetReceiveWrapper('onyx.creditstore:EditItem', 'onyx_creditstore_edit', function(len, ply)
    local itemID = net.ReadString()
    local itemData = onyx.net.ReadTable()
    return {itemID, itemData}
end, function(ply, data)
    local itemID = data[1]
    local itemData = data[2]

    --[[------------------------------
    Check if item exists
    --------------------------------]]
    local itemCurrentData = onyx.creditstore.items[itemID]
    if (not itemCurrentData) then
        return
    end

    itemData.id = itemID
    -- itemData.type = itemCurrentData.type
    itemData.price = tonumber(itemData.price)

    --[[------------------------------
    Validate data
    --------------------------------]]
    if (not validateItemData(itemData, true)) then
        return
    end

    --[[------------------------------
    Check fields
    --------------------------------]]
    if (not checkFields(itemData, {'id', 'name', 'price', 'type', 'data', 'type'})) then
        return
    end

    local name = itemData.name
    local price = itemData.price
    local icon = itemData.icon
    local model = itemData.model
    local data = itemData.data
    local category = itemData.category
    local typeName = itemData.type

    local oldTypeName = itemCurrentData.type
    local oldItemData = table.Copy(itemCurrentData.data or {})
    local typeChanged = typeName ~= oldTypeName

    local query = onyx.creditstore.db:Update('onyx_creditstore_items')
        query:Update('name', name)
        query:Update('price', price)
        query:Update('category', category)
        query:Update('type', typeName)

        if (icon) then
            query:Update('icon', icon)
            query:Update('model', 'NULL')
        else
            query:Update('icon', 'NULL')
            query:Update('model', model)
        end

        if (data) then
            query:Update('data', pon.encode(data))
        end

        query:Where('id', itemID)
        query:Limit(1)
        query:Callback(function()
            if (typeChanged) then
                local success, errorStr = pcall(allUnequipItem, itemID, oldTypeName, oldItemData)
                if (not success) then
                    print(errorStr)
                end
            end

            creditstore.items[itemID] = itemData
            creditstore:SyncItems()

            creditstore:Print('Updated the item: #', itemID)
    
            if (IsValid(ply)) then
                ply:ChatPrint('You have updated the item!')
            end
        end)

    query:Execute()

    hook.Run('onyx.creditstore.PlayerEditedItem', ply, itemID)
end)

camiNetReceiveWrapper('onyx.creditstore:DeleteItem', 'onyx_creditstore_edit', function(len, ply)
    return {[1] = net.ReadString()}
end, function(ply, data)
    local itemID = data[1]

    if (creditstore.items[itemID]) then
        creditstore:DeleteItem(itemID, function()
            if (IsValid(ply)) then
                ply:ChatPrint('Deleted the item.')
            end
        end)

        hook.Run('onyx.creditstore.PlayerDeletedItem', ply, itemID)
    end
end)

camiNetReceiveWrapper('onyx.creditstore:DeleteCategory', 'onyx_creditstore_edit', function(len, ply)
    return {[1] = net.ReadString()}
end, function(ply, data)
    local catID = data[1]

    if (creditstore.categories[catID]) then
        creditstore:DeleteCategory(catID, function()
            if (IsValid(ply)) then
                ply:ChatPrint('Deleted the category.')
            end
        end)

        hook.Run('onyx.creditstore.PlayerDeletedCategory', ply, catID)
    end
end)

--[[------------------------------
INVENTORY ADMIN
--------------------------------]]

camiNetReceiveWrapper('onyx.creditstore:AdminRequestInventory', 'onyx_creditstore_see_inventory', function(len, ply)
    return {[1] = net.ReadString()}
end, function(ply, data)
    local steamid64 = data[1]

    creditstore:FetchInventory(steamid64, function(inventory, balance)
        if (IsValid(ply)) then
            net.Start('onyx.creditstore:AdminRequestInventory')
                net.WriteUInt(balance, 32)
                onyx.net.WriteTable(inventory)
            net.Send(ply)
    
            hook.Run('onyx.creditstore.AdminCheckedInventory', ply, steamid64)
        end
    end)
end)

camiNetReceiveWrapper('onyx.creditstore:AdminGiveItem', 'onyx_creditstore_give_items', function(len, ply)
    local steamid64 = net.ReadString()
    local itemID = net.ReadString()
    return {[1] = steamid64, [2] = itemID}
end, function(ply, data)
    local steamid64 = data[1]
    local itemID = data[2]

    local itemTable = creditstore.items[itemID]
    if (not itemTable) then return end

    local itemTypeData = creditstore.types[itemTable.type]
    if (not itemTypeData) then return end

    local target = player.GetBySteamID64(steamid64)
    if (IsValid(target)) then
        if (itemTypeData.noDuplicates and creditstore:GetPlayerItemAmount(ply, itemID) > 0) then
            ply:ChatPrint('Player already have this item!')
            return
        end

        creditstore:AddPlayerItem(target, itemID, {}, function(target)
            if (IsValid(ply)) then
                ply:ChatPrint('success.')

                local balance = creditstore:GetCredits(target)
                local inv = creditstore:GetPlayerInventory(target)
                
                net.Start('onyx.creditstore:AdminRequestInventory')
                    net.WriteUInt(balance, 32)
                    onyx.net.WriteTable(inv)
                net.Send(ply)
            end
        end)
    
        hook.Run('onyx.creditstore.AdminItemGiven', ply, target, itemID)
    end
end)

camiNetReceiveWrapper('onyx.creditstore:AdminTakeItem', 'onyx_creditstore_take_items', function(len, ply)
    local steamid64 = net.ReadString()
    local multiple = net.ReadBool()
    local itemIndex, itemID, amount

    if (multiple) then
        amount = net.ReadUInt(8)
        itemID = net.ReadString()

        if (amount < 1) then
            return
        end
    else
        itemIndex = net.ReadUInt(16)
    end
    
    return {
        steamid64 = steamid64,
        multiple = multiple,
        itemIndex = itemIndex,
        amount = amount,
        itemID = itemID
    }
end, function(ply, data)
    local steamid64 = data.steamid64
    local multiple = data.multiple
    local itemIndex = data.itemIndex
    local amount = data.amount
    local itemID = data.itemID

    local target = player.GetBySteamID64(steamid64)
    if (IsValid(target)) then
        local inventory = creditstore:GetPlayerInventory(target)

        if (itemIndex) then
            local it = inventory[itemIndex]
            if (it) then
                creditstore:RemovePlayerItem(target, itemIndex, function(target)
                    if (IsValid(ply)) then
                        ply:ChatPrint('success.')
        
                        local balance = creditstore:GetCredits(target)
                        local inv = creditstore:GetPlayerInventory(target)
                        
                        net.Start('onyx.creditstore:AdminRequestInventory')
                            net.WriteUInt(balance, 32)
                            onyx.net.WriteTable(inv)
                        net.Send(ply)
                    end
                end)

                hook.Run('onyx.creditstore.AdminTakeItem', ply, target, it)
            end
        else
            local itemTable = creditstore.items[itemID]
            if (not itemTable) then return end

            local itemTypeData = creditstore.types[itemTable.type]
            if (not itemTypeData) then return end
            if (not itemTypeData.stacking) then return end -- security reasons

            for i = 1, amount do
                for index, it in ipairs(inventory) do
                    if (it.id == itemID) then
                        table.remove(inventory, index)
                        break
                    end
                end
            end

            creditstore:SaveInventory(target, function()
                if (IsValid(target)) then
                    creditstore:SyncInventory(target)

                    if (IsValid(ply)) then
                        ply:ChatPrint('success.')
        
                        local balance = creditstore:GetCredits(target)
                        local inv = creditstore:GetPlayerInventory(target)
                        
                        net.Start('onyx.creditstore:AdminRequestInventory')
                            net.WriteUInt(balance, 32)
                            onyx.net.WriteTable(inv)
                        net.Send(ply)
                    end
                end
            end)
            
            hook.Run('onyx.creditstore.AdminTakeItemMultiple', ply, target, itemID, amount)
        end
    end
end)