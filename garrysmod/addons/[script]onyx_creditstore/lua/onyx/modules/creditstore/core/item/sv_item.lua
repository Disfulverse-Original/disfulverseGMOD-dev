--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

local creditstore = onyx.creditstore

creditstore.items = creditstore.items or {}
creditstore.categories = creditstore.categories or {}

do
    local query = onyx.creditstore.db:Create('onyx_creditstore_items')
        query:Create('id', 'VARCHAR(255) NOT NULL')
        query:Create('name', 'VARCHAR(255) NOT NULL')
        query:Create('price', 'INT UNSIGNED NOT NULL')
        query:Create('type', 'VARCHAR(255) NOT NULL')
        query:Create('category', 'VARCHAR(255) NOT NULL')
        query:Create('icon', 'VARCHAR(255)') -- could be null
        query:Create('model', 'VARCHAR(255)') -- could be null
        query:Create('data', 'TEXT NOT NULL')
        query:PrimaryKey('id')
        query:Callback(function()
            creditstore:Print('Initialized items table.')
        end)
    query:Execute()

    local query = onyx.creditstore.db:Create('onyx_creditstore_categories')
        query:Create('id', 'VARCHAR(255) NOT NULL')
        query:Create('name', 'VARCHAR(255) NOT NULL')
        query:Create('icon', 'VARCHAR(255) NOT NULL')
        query:Create('order', 'INT NOT NULL')
        query:PrimaryKey('id')
        query:Callback(function()
            creditstore:Print('Initialized categories table.')
        end)
    query:Execute()
end

function creditstore:RegisterItem(uniqueID, data)
    creditstore:PrintDebug('Registered new item: `#`', uniqueID)
    data.id = uniqueID
    self.items[uniqueID] = data
end

function creditstore:RegisterCategory(uniqueID, data)
    creditstore:PrintDebug('Registered new category: `#`', uniqueID)
    data.id = uniqueID
    self.categories[uniqueID] = data
end

function creditstore:SyncItems(ply)
    netchunk.Send(ply, 'onyx.creditstore:SyncItems', self.items)
end

function creditstore:SyncCategories(ply)
    netchunk.Send(ply, 'onyx.creditstore:SyncCategories', self.categories)
end

function creditstore:CreateItem(uniqueID, name, price, type, category, icon, model, data, callback)
    assert(uniqueID)
    assert(name)
    assert(price)
    assert(type)
    assert(category)
    assert(icon or model)
    assert(data)

    local query = onyx.creditstore.db:Insert('onyx_creditstore_items')
        query:Insert('id', uniqueID)
        query:Insert('name', name)
        query:Insert('price', price)
        query:Insert('type', type)
        query:Insert('category', category)

        if (icon) then
            query:Insert('icon', icon)
        else
            query:Insert('model', model)
        end

        if (data) then
            query:Insert('data', pon.encode(data))
        end

        query:Callback(function()
            creditstore:RegisterItem(uniqueID, {
                name = name,
                price = price,
                type = type,
                icon = icon,
                model = model,
                category = category,
                data = data
            })

            if (not creditstore.DisableAutoSync) then
                creditstore:SyncItems()
            end

            creditstore:PrintDebug('Created a new item: #', uniqueID)

            if (callback) then
                callback()
            end
        end)
    query:Execute(true)
end

function creditstore:CreateCategory(uniqueID, name, icon, order, callback)
    assert(uniqueID)
    assert(name)
    assert(icon)
    assert(order)

    local query = onyx.creditstore.db:Insert('onyx_creditstore_categories')
        query:Insert('id', uniqueID)
        query:Insert('name', name)
        query:Insert('icon', icon)
        query:Insert('order', order)
        query:Callback(function()
            creditstore:RegisterCategory(uniqueID, {
                name = name,
                icon = icon,
                order = order
            })

            if (not creditstore.DisableAutoSync) then
                creditstore:SyncCategories()
            end

            creditstore:PrintDebug('Created a new category: #', uniqueID)

            if (callback) then
                callback()
            end
        end)
    query:Execute(true)
end

function creditstore:DeleteCategory(uniqueID, callback)
    local query = onyx.creditstore.db:Delete('onyx_creditstore_categories')
        query:Where('id', uniqueID)
        query:Limit(1)
        query:Callback(function()
            
            self.categories[uniqueID] = nil
            self:SyncCategories()

            creditstore:Print('Deleted the category (#)', uniqueID)

            if (callback) then
                callback()
            end
        end)
    query:Execute()
end

function creditstore:DeleteItem(uniqueID, callback)
    local query = onyx.creditstore.db:Delete('onyx_creditstore_items')
        query:Where('id', uniqueID)
        query:Limit(1)
        query:Callback(function()
            
            self.items[uniqueID] = nil
            self:SyncItems()

            creditstore:Print('Deleted the item (#)', uniqueID)

            if (callback) then
                callback()
            end
        end)
    query:Execute()
end

function creditstore:LoadItems()
    self.items = {}

    hook.Run('onyx.creditstore.OnItemLoadingStarted')
    
    local query = onyx.creditstore.db:Select('onyx_creditstore_items')
        query:Callback(function(result)
            if (result and #result > 0) then
                for _, row in ipairs(result) do
                    if (row.icon == 'NULL' or row.icon == 'nil') then
                        row.icon = nil
                    end
    
                    if (row.model == 'NULL' or row.model == 'nil') then
                        row.model = nil
                    end
    
                    row.data = pon.decode(row.data)
                    row.price = tonumber(row.price)
    
                    local uniqueID = row.id
                    
                    creditstore:RegisterItem(uniqueID, row)
                end
            end

            creditstore:SyncItems()
            self.itemsLoaded = true
        end)
    query:Execute()
end

function creditstore:LoadCategories()
    self.categories = {}

    self:RegisterCategory('nocategory', {
        name = 'No Category',
        icon = 'https://i.imgur.com/9W2hH9R.png',
        order = -1,
        internal = true,
        nocategory = true
    })

    hook.Run('onyx.creditstore.OnCategoryLoadingStarted')
    
    local query = onyx.creditstore.db:Select('onyx_creditstore_categories')
        query:Callback(function(result)
            if (result and #result > 0) then
                for _, row in ipairs(result) do
                    row.order = tonumber(row.order)
    
                    local uniqueID = row.id
                    
                    self:RegisterCategory(uniqueID, row)
                end
            end

            self:SyncCategories()
            self.categoriesLoaded = true
        end)
    query:Execute()
end

hook.Add('onyx.PlayerNetworkReady', 'onyx.creditstore.items', function(ply)
    creditstore:SyncCategories(ply)
    creditstore:SyncItems(ply)
end)

hook.Add('InitPostEntity', 'onyx.creditstore.items', function()
    creditstore:LoadCategories()
    creditstore:LoadItems()
end)