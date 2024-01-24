--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/05/2023

--]]

local creditstore = onyx.creditstore
local translators = {}

creditstore:Print('Initialized Pulsar importer file.')

local function registerTranslator(packageName, func)
    translators[packageName] = func
end

local function check()
    if (not Lyth_Pulsar) then
        return false, 'The Pulsar must be installed on your server!'
    end

    return true
end

local function wipeData()
    creditstore.db:RawQuery([[DELETE FROM onyx_creditstore_items;]], function()
        creditstore:PrintSuccess('Wiped items.')
    end)

    creditstore.db:RawQuery([[DELETE FROM onyx_creditstore_categories;]], function()
        creditstore:PrintSuccess('Wiped categories.')
    end)

    creditstore.items = {}
    creditstore.categories = {}

    creditstore:RegisterCategory('nocategory', {
        name = 'No Category',
        icon = 'https://i.imgur.com/9W2hH9R.png',
        order = -1,
        internal = true,
        nocategory = true
    })
    creditstore:SyncItems()
    creditstore:SyncCategories()
end

local function queueSync()
    timer.Create('onyx.creditstore.DelayedSync', 3, 1, function()
        creditstore.DisableAutoSync = nil
        creditstore:Print('Called synchronization.')
        creditstore:SyncItems()
        creditstore:SyncCategories()
    end)
end

do
    registerTranslator('Weapon', function(perma, args)
        local class = perma and 'permweapon' or 'weapon'
        local data = {
            wpnclass = args
        }

        return class, data
    end)

    registerTranslator('trail', function(perma, args)
        local class = 'trail'
        local data = {['texture'] = args}

        return class, data
    end)

    registerTranslator('voidcasesitem', function(perma, args)
        local class = 'voidcases_key' -- it can handle any item type
        local data = {['itemid'] = tonumber(args)}

        return class, data
    end)

    registerTranslator('rank', function(perma, args)
        local class = 'permrank'
        local data = {['rank'] = args}

        return class, data
    end)

    registerTranslator('armor', function(perma, args)
        if (perma) then return end
    
        local class = 'armor'
        local data = {['amount'] = tonumber(args), action = 1}

        return class, data
    end)

    registerTranslator('health', function(perma, args)
        if (perma) then return end
    
        local class = 'health'
        local data = {['amount'] = tonumber(args), action = 1}

        return class, data
    end)

    registerTranslator('entity', function(perma, args)
        if (perma) then return end
    
        local class = 'entity'
        local data = {['entclass'] = args}
    
        return class, data
    end)

    registerTranslator('concommand', function(perma, args)
        if (perma) then return end
    
        local class = 'runconsolecommand'
        local data = {['command'] = args}

        return class, data
    end)

    registerTranslator('model', function(perma, args)
        if (not perma) then return end
        
        local class = 'permmodel'
        local data = {['model'] = args}

        return class, data
    end)

    registerTranslator('money', function(perma, args)
        local class = 'darkrp_money'
        local data = {['amount'] = tonumber(args)}

        return class, data
    end)

    registerTranslator('rank', function(perma, args)
        local class = 'permrank'
        local data = {['rank'] = args}

        return class, data
    end)

    registerTranslator('xp', function(perma, args)
        local class = 'xp'
        local data = {['amount'] = tonumber(args)}

        return class, data
    end)

    -- Boosters

    registerTranslator('speed', function(perma, args)
        if (not perma) then return end

        local estDefaultRunSpeed = 280
        local runSpeedMultiplier = tonumber(args) / estDefaultRunSpeed

        local class = 'permbooster'
        local data = {['action'] = 2, ['percents'] = (runSpeedMultiplier - 1) * 100}

        return class, data
    end)

    registerTranslator('damage', function(perma, args)
        if (not perma) then return end

        local class = 'permbooster'
        local data = {['action'] = 3, ['percents'] = (tonumber(args) - 1) * 100}

        return class, data
    end)

    registerTranslator('jump', function(perma, args)
        if (not perma) then return end

        local class = 'permbooster'
        local data = {['action'] = 4, ['percents'] = (tonumber(args) - 1) * 100}

        return class, data
    end)
end

local import do
    local function importUser(steamid64, balance, index, total)
        local tableItemsName = Lyth_Pulsar.DB.TableNames.Items
        local tableInventoryName = Lyth_Pulsar.DB.TableNames.Purchases
    
        local query = Lyth_Pulsar.MySQL:Select(tableInventoryName)
            query:Where('userid', steamid64)
            query:Callback(function(result)
                local db = onyx.creditstore.db
                local inventory = {}

                for _, row in pairs(result or {}) do
                    if (row.itemName) then
                        local parsedItemID = 'pulsar_' .. string.lower(row.itemName):gsub(' ', '_'):gsub('%p', '')
                        table.insert(inventory, {
                            id = parsedItemID,
                            data = {}
                        })
                    end
                end

                db:Queue(Format('REPLACE INTO `onyx_creditstore_players` VALUES (\'%s\', %i, \'%s\')', db:Escape(steamid64), tonumber(balance), db:Escape(pon.encode(inventory))), function()

                    creditstore:PrintSuccess('Imported user \'#\' (#/#)', steamid64, index, total)

                    local plyObject = player.GetBySteamID64(steamid64)
                    if (IsValid(plyObject)) then
                        creditstore:LoadInventory(plyObject)
                    end

                end)

            end)
        query:Execute()
    end

    local function importUsers()
        local tableBalanceName = Lyth_Pulsar.DB.TableNames.Users

        creditstore:Print('Importing users...')

        local query = Lyth_Pulsar.MySQL:Select(tableBalanceName)
            query:Callback(function(result)
                if (result and #result > 0) then
                    local amt = #result
                    for i, row in ipairs(result) do
                        local steamid64 = row.userid
                        local credits = tonumber(row.credits)
    
                        importUser(steamid64, credits, i, amt)
                    end
                end
            end)
        query:Execute()
    end

    local function importCategories()
        local tableName = Lyth_Pulsar.DB.TableNames.Categorys

        creditstore:Print('Importing categories...')

        local query = Lyth_Pulsar.MySQL:Select(tableName)
            query:Callback(function(result)
                for _, row in ipairs(result or {}) do
                    local catID = row.id
                    local imgurID = row.logo
                    local name = row.name
                    local order = tonumber(row.number)
                    local icon = 'https://i.imgur.com/' .. imgurID .. '.png'
                    local parsedCatID = 'pulsar_' .. string.lower(catID:gsub('Lyth_Pulsar.Pages.', ''))

                    creditstore.DisableAutoSync = true
                    creditstore:CreateCategory(parsedCatID, name, icon, order, function()
                        -- creditstore.DisableAutoSync = nil
                        creditstore:PrintSuccess('Imported category \'#\'', name)
                        queueSync()
                    end)
                end
            end)
        query:Execute(true)
    end

    local function importItems()
        local tableName = Lyth_Pulsar.DB.TableNames.Items

        creditstore:Print('Importing items...')

        local query = Lyth_Pulsar.MySQL:Select(tableName)
            query:Callback(function(result)
                for _, row in ipairs(result or {}) do
                    local id = row.id
                    local name = row.name
                    local price = tonumber(row.price)
                    local isPermanent = util.StringToType(row.perma, 'bool')
                    local iconType = row.type
                    local iconData = row.logo
                    local catID = row.category
                    local packageClass = row.package
                    local packageArgs = row.packageargs
                
                    local parsedCatID = 'pulsar_' .. string.lower(catID:gsub('Lyth_Pulsar.Pages.', ''))
                    local parsedItemID = 'pulsar_' .. string.lower(name):gsub(' ', '_'):gsub('%p', '')
                    local icon = iconType == 'imgur' and 'https://i.imgur.com/' .. iconData .. '.png'
                    local model = iconType == 'model' and iconData

                    local translator = translators[packageClass]
                    if (translator) then
                        local typeName, typeData = translator(isPermanent, packageArgs)

                        if (not typeName or not typeData) then
                            creditstore:PrintError('Skipped item \'#\' with unsupported package class (#): \'#\'', name, packageClass, (isPermanent and 'Permanent' or 'Single-use'))
                            continue
                        end
                        -- assert(typeName, Format('failed to translate item: %s, %s', packageClass, tostring(isPermanent)))
                        -- assert(typeData)

                        local packageClassFull = (isPermanent and 'Permanent ' or '') .. packageClass

                        creditstore.DisableAutoSync = true
                        creditstore:CreateItem(parsedItemID, name, price, typeName, parsedCatID, icon, model, typeData, function()
                            -- creditstore.DisableAutoSync = nil
                            creditstore:PrintSuccess('Imported item \'#\' (# → #)', name, packageClassFull, typeName)
                            queueSync()
                        end)
                    else
                        -- creditstore:PrintWarning('Imported item \'#\' with unsupported package class: \'#\'', name, packageClass)
                        creditstore:PrintError('Skipped item \'#\' with unsupported package class: \'#\'', name, packageClass)
                    end
                end
            end)
        query:Execute(true)
    end
    
    function import()
        creditstore:Print('Started importing process.')

        RunConsoleCommand('sv_hibernate_think', 1)

        wipeData()
        importCategories()
        importItems()
        importUsers()
    end
end


local function chatPrint(ply, text)
    if (IsValid(ply)) then
        ply:ChatPrint(text)
    else
        print(text)
    end
end

local lastCall = 0
concommand.Add('onyx_import_pulsar', function(ply)
    local isConsole = ply == NULL

    if (not isConsole and not ply:IsSuperAdmin()) then
        return
    end

    local status, reason = check()
    if (not status) then
        chatPrint(ply, status)
        return
    end

    if ((CurTime() - lastCall) > 10) then
        chatPrint(ply, 'WARNING!')
        chatPrint(ply, 'Are you sure you want to import data from Pulsar?')
        chatPrint(ply, 'All existing data related to ONYX store items, categories, inventories and balances will be erased!')
        chatPrint(ply, 'If you are sure, write this command again.')

        lastCall = CurTime()

        return
    end

    import()
end)