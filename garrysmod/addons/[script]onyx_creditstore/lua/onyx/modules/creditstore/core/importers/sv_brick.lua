--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/05/2023

--]]

local creditstore = onyx.creditstore
local translators = {}

creditstore:Print('Initialized Brick\'s Credit Store importer file.')

local function registerTranslator(packageName, func)
    translators[packageName] = func
end

local function check()
    if (not BRICKSCREDITSTORE) then
        return false, 'The Brick\'s Creditstore must be installed on your server!'
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
        creditstore:Print('Called synchronization.')
        creditstore:SyncItems()
        creditstore:SyncCategories()
    end)
end

do
    registerTranslator('Currency', function(typeInfo)
        local currencyType = typeInfo[1]
        local amount = tonumber(typeInfo[2])
        if (currencyType == 'DarkRP Money') then
            return 'darkrp_money', {amount = amount}
        end
    end)

    registerTranslator('Armor', function(typeInfo)
        local amount = tonumber(typeInfo[1])
        local class = 'armor'
        local data = {action = 0, amount = amount}
        return class, data
    end)

    registerTranslator('Health', function(typeInfo)
        local amount = tonumber(typeInfo[1])
        local class = 'health'
        local data = {action = 0, amount = amount}
        return class, data
    end)

    registerTranslator('SWEP', function(typeInfo)
        local class = 'weapon'
        local data = {wpnclass = typeInfo[1]}
        return class, data
    end)

    registerTranslator('PERM_SWEP', function(typeInfo)
        local class = 'permweapon'
        local data = {wpnclass = typeInfo[1]}
        return class, data
    end)

    registerTranslator('PERM_MODEL', function(typeInfo)
        local class = 'permmodel'
        local data = {model = typeInfo[1]}
        return class, data
    end)

    -- Missing: TempRank

    registerTranslator('Rank', function(typeInfo)
        local class = 'permrank'
        local data = {rank = typeInfo[1]}
        return class, data
    end)

    do
        local types = {
            ['Health'] = 0,
            ['Armor'] = 1,
            ['Speed'] = 2,
            ['Jumping'] = 4,
            ['Damage'] = 3,
        }
        registerTranslator('Booster', function(typeInfo)
            local boosterTypeString = typeInfo[1]
            local boosterPercent = tonumber(typeInfo[2]) -- check
            local boosterEnum = types[boosterTypeString]
            if (boosterEnum) then
                local class = 'permbooster'
                local data = {action = boosterEnum, percents = boosterPercent}
                return class, data
            end
        end)
    end

    registerTranslator('Trail', function(typeInfo)
        local class = 'trail'
        local data = {texture = typeInfo[1]}
        return class, data
    end)

    registerTranslator('Tool', function(typeInfo)
        local class = 'tool'
        local data = {tool = typeInfo[1]}
        return class, data
    end)

    registerTranslator('Tool', function(typeInfo)
        local class = 'tool'
        local data = {tool = typeInfo[1]}
        return class, data
    end)

    registerTranslator('Job', function(typeInfo)
        local class = 'darkrp_job'
        local data = {jobcommand = typeInfo[1]}
        return class, data
    end)

    do
        registerTranslator('Suit', function(typeInfo)
            local class = 'permsuit'
            local data = {
                health = tonumber(typeInfo[1]),
                armor = tonumber(typeInfo[2]),
                speed = tonumber(typeInfo[3]),
                jumppower = tonumber(typeInfo[4]),
                model = typeInfo[5],
            }
            return class, data
        end)
    end

    registerTranslator('Vehicle', function(typeInfo)
        local class = 'vehicle'
        local data = {vehiclescript = typeInfo[1]}
        return class, data
    end)

    registerTranslator('Entity', function(typeInfo)
        local class = 'entity'
        local data = {entclass = typeInfo[1]}
        return class, data
    end)

    registerTranslator('Experience', function(typeInfo)
        local class = 'xp'
        local data = {amount = tonumber(typeInfo[1])}
        return class, data
    end)
end

local import do
    local function importUsers_File()
        local cache = {}

        -- Inventories
        do
            local files = file.Find('brickscreditstore/locker_data/*.txt', 'DATA')
            for _, fname in ipairs(files) do
                local content = file.Read('brickscreditstore/locker_data/' .. fname, 'DATA')
                local success, decoded = pcall(util.JSONToTable, content)
                if (success) then
                    if (decoded) then
                        local inventory = {}
    
                        for _, item in ipairs(decoded) do
                            local name = item[3] and item[3][1]
                            if (name) then
                                local onyxItemID = 'brick_' .. string.lower(name):gsub(' ', '_'):gsub('%p', '')
                                local data = {}

                                if (item.Active) then
                                    data.equipped = true
                                end

                                table.insert(inventory, {id = onyxItemID, data = data})
                            end
                        end
    
                        cache[fname] = {inventory = inventory}
                    end
                else
                    creditstore:PrintError('Failed to decode \'#\' inventory', fname)
                end
            end
        end

        -- Balances
        do
            local files = file.Find('brickscreditstore/credit_data/*.txt', 'DATA')
            for _, fname in ipairs(files) do
                local content = file.Read('brickscreditstore/credit_data/' .. fname, 'DATA')
                local balance = tonumber(content)
                if (balance) then
                    cache[fname] = cache[fname] or {}
                    cache[fname].balance = balance
                else
                    creditstore:PrintError('Failed to get \'#\' balance', fname)
                end
            end
        end

        -- Import
        local index = 0
        local total = table.Count(cache)
        for fname, data in pairs(cache) do

            local steamid64 = fname:gsub('.txt', '')
            local balance = data.balance or 0
            local inventory = data.inventory or {}

            local db = onyx.creditstore.db
            db:Queue(Format('REPLACE INTO `onyx_creditstore_players` VALUES (\'%s\', %i, \'%s\')', db:Escape(steamid64), tonumber(balance), db:Escape(pon.encode(inventory))), function()

                index = index + 1
                creditstore:PrintSuccess('Imported user \'#\' (#/#)', steamid64, index, total)

                local plyObject = player.GetBySteamID64(steamid64)
                if (IsValid(plyObject)) then
                    creditstore:LoadInventory(plyObject)
                end

            end)
        end
    end

    local function importUsers_MySQL()
        local query = brickscreditstore_db:query("SELECT * FROM BricksCreditStore;")

        query.onSuccess = function(self, result)

            if (result) then
                local total = #result
                if (total > 0) then
                    for index, row in ipairs(result) do
                        local steamid64 = row.steamid64
                        local balance = tonumber(row.credits) or 0
                        local locker = row.locker or '[]'
                        local inventory = {}

                        local success, decoded = pcall(util.JSONToTable, locker)
                        if (success) then
                            if (decoded) then
    
                                for _, item in ipairs(decoded) do
                                    local name = item[3] and item[3][1]
                                    if (name) then
                                        local onyxItemID = 'brick_' .. string.lower(name):gsub(' ', '_'):gsub('%p', '')
                                        local data = {}
        
                                        if (item.Active) then
                                            data.equipped = true
                                        end
        
                                        table.insert(inventory, {id = onyxItemID, data = data})
                                    end
                                end

                            end
                        else
                            creditstore:PrintError('Failed to decode \'#\' inventory (MySQL)', steamid64)
                        end
            
                        local db = onyx.creditstore.db
                        db:Queue(Format('REPLACE INTO `onyx_creditstore_players` VALUES (\'%s\', %i, \'%s\')', db:Escape(steamid64), tonumber(balance), db:Escape(pon.encode(inventory))), function()
            
                            creditstore:PrintSuccess('Imported user \'#\' (#/#)', steamid64, index, total)
            
                            local plyObject = player.GetBySteamID64(steamid64)
                            if (IsValid(plyObject)) then
                                creditstore:LoadInventory(plyObject)
                            end
            
                        end)
                    end
                end
            end
        end

        query.onError = function(self, err)
            creditstore:PrintError('MySQL Error during user import: #', err)
        end
        
        query:start()
    end

    local function importUsers()
        creditstore:Print('Importing users...')

        if (BRICKSCREDITSTORE.LUACONFIG.UseMySQL) then
            importUsers_MySQL()
        else
            importUsers_File()
        end
    end

    local function importCategories(configTable)
        creditstore:Print('Importing categories...')

        for name, iconURL in pairs(configTable.Categories) do
            local parsedCatID = 'brick_' .. string.lower(name)

            creditstore.DisableAutoSync = true
            creditstore:CreateCategory(parsedCatID, name, iconURL, 1, function()
                -- creditstore.DisableAutoSync = nil
                creditstore:PrintSuccess('Imported \'#\'', name)
                queueSync()
            end)
        end
    end

    local function importItems(configTable)
        creditstore:Print('Importing items...')

        for _, npc in pairs(configTable.NPCs) do
            creditstore:Print('Importing NPC: #', _)

            -- PrintTable(npc)
            if (npc.currency ~= 'Credits') then
                continue
            end

            for _, item in pairs(npc.Items) do
                local name = item.Name
                local price = tonumber(item.Price)
                local brickTypeName = item.Type
                local brickTypeInfo = item.TypeInfo
                local icon = item.icon
                local model = item.model

                if (not model and not tostring(icon):find('http')) then
                    icon = 'https://i.imgur.com/laMKv2w.png'
                end

                -- print(item, brickTypeName)
                local translator = translators[brickTypeName]
                if (translator) then
                    local typeName, typeData = translator(brickTypeInfo)
                    local parsedItemID = 'brick_' .. string.lower(name):gsub(' ', '_'):gsub('%p', '')
                    local parsedCatID = item.Category and 'brick_' .. string.lower(item.Category) or 'nocategory'
                
                    -- print(brickTypeName)
                    if (not typeName or not typeData) then
                        creditstore:PrintError('Skipped item \'#\' with unsupported package class: \'#\' (#)', name, brickTypeName, table.concat(brickTypeInfo, '; '))
                        continue
                    end

                    if (creditstore.items[parsedItemID]) then
                        creditstore:PrintError('Skipped item duplicate \'#\'', parsedItemID)
                        continue 
                    end

                    assert(istable(typeData), Format('bad \'typeData\' for %s (expected table, got %s)', typeName, type(typeData)))

                    creditstore.DisableAutoSync = true
                    creditstore:CreateItem(parsedItemID, name, price, typeName, parsedCatID, icon, model, typeData, function()
                        -- creditstore.DisableAutoSync = nil
                        creditstore:PrintSuccess('Imported item \'#\' (# → #)', name, brickTypeName, typeName)
                        queueSync()
                    end)
                else
                    creditstore:PrintError('Skipped item \'#\' with unsupported package class: \'#\'', name, brickTypeName)
                end
            end
        end
    end
    
    function import()
        local configJSON = file.Read("brickscreditstore/config.txt", "DATA")
        local configTable = util.JSONToTable(configJSON)

        creditstore:Print('Started importing process.')

        RunConsoleCommand('sv_hibernate_think', 1)

        wipeData()
        importCategories(configTable)
        importItems(configTable)
        importUsers()
    end
end

local lastCall = 0

local function chatPrint(ply, text)
    if (IsValid(ply)) then
        ply:ChatPrint(text)
    else
        print(text)
    end
end

concommand.Add('onyx_import_brick', function(ply)
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
        chatPrint(ply, 'Are you sure you want to import data from Brick\'s Credit Store?')
        chatPrint(ply, 'All existing data related to ONYX store items, categories, inventories and balances will be erased!')
        chatPrint(ply, 'If you are sure, write this command again.')

        lastCall = CurTime()

        return
    end

    import()
end)