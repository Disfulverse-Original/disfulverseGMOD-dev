--[[

Author: tochnonement
Email: tochnonement@gmail.com

23/04/2023

--]]

local creditstore = onyx.creditstore

util.AddNetworkString('onyx.creditstore:PurchaseItem')
util.AddNetworkString('onyx.creditstore:SyncInventoryItemData')
util.AddNetworkString('onyx.creditstore:UseOption')

do
    local q = onyx.creditstore.db:Create('onyx_creditstore_players')
        q:Create('steamid64', 'VARCHAR(255) NOT NULL')
        q:Create('balance', 'INT NOT NULL')
        q:Create('inventory', 'TEXT NOT NULL')
        q:PrimaryKey('steamid64')
    q:Execute()
end

function creditstore:AddPlayerItem(ply, itemID, itemData, callback)
    local inventory = self:GetPlayerInventory(ply)

    table.insert(inventory, {
        id = itemID,
        data = (itemData or {})
    })

    self:SaveInventory(ply, function()
        if (IsValid(ply)) then
            creditstore:SyncInventory(ply)
            if (callback) then
                callback(ply)
            end
        end
    end)
end

function creditstore:RemovePlayerItem(ply, itemIndex, callback)
    local inventory = self:GetPlayerInventory(ply)
    local it = inventory[itemIndex]
    assert(it, 'trying to delete unexistant item (' .. itemIndex .. ') from player ' .. ply:Name() .. ' (' .. ply:SteamID() .. ')')

    table.remove(inventory, itemIndex)

    self:SaveInventory(ply, function()
        if (IsValid(ply)) then
            creditstore:SyncInventory(ply)
            if (callback) then
                callback(ply)
            end
        end
    end)
end

-- creditstore:AddPlayerItem(Entity(1), 'deagle')

function creditstore:SyncInventory(ply)
    if (not IsValid(ply)) then return end

    netchunk.Send(ply, 'onyx.creditstore:SyncInventory', self:GetPlayerInventory(ply))
end

function creditstore:SaveInventory(ply, callback)
    if (not IsValid(ply)) then return end

    local inventory = self:GetPlayerInventory(ply)
    local q = self.db:Update('onyx_creditstore_players')
        q:Update('inventory', pon.encode(inventory))
        q:Where('steamid64', ply:SteamID64())
        q:Limit(1)
        q:Callback(function()
            if (callback) then
                callback()
            end
        end)
    q:Execute()
end

function creditstore:LoadInventory(ply)
    local steamid64 = ply:SteamID64()

    self:FetchInventory(steamid64, function(inventory, balance, bNotFound)
        if (bNotFound) then
            local q = onyx.creditstore.db:Insert('onyx_creditstore_players')
                q:Insert('steamid64', steamid64)
                q:Insert('balance', 0)
                q:Insert('inventory', pon.encode({}))
            q:Execute()
        end
    
        if (IsValid(ply)) then
            ply:onyx_SetNetVar('store_loaded', true)
            ply:onyx_SetNetVar('credits', balance)
            ply:SetVar('onyx_CreditstoreInventory', inventory)

            creditstore:SyncInventory(ply)

            hook.Run('onyx.creditstore.PlayerLoaded', ply)
        end
    end)
end

function creditstore:FetchInventory(steamid64, callback)
    assert(steamid64, 'missing `steamid64`')
    assert(callback, 'missing `callback`')

    local q = onyx.creditstore.db:Select('onyx_creditstore_players')
        q:Where('steamid64', steamid64)
        q:Limit(1)
        q:Callback(function(result)
            if (result and #result > 0) then
                local data = result[1]
                local inventory = pon.decode(data.inventory)
                local balance = tonumber(data.balance)

                callback(inventory, balance)
            else
                callback({}, 0, true)
            end
        end)
    q:Execute()
end

function creditstore:AddCredits(steamid64, amount, callback)
    if (IsEntity(steamid64) and steamid64:IsPlayer()) then steamid64 = steamid64:SteamID64() end -- convenience

    assert(isstring(steamid64), string.format('bad argument #1 to \'AddCredits\' (expected string, got %s)', type(steamid64)))
    assert(isnumber(amount), string.format('bad argument #2 to \'AddCredits\' (expected number, got %s)', type(amount)))
    assert(amount > 0, 'bad argument #2 to \'AddCredits\' (number must be positive)')

    local target = player.GetBySteamID64(steamid64)
    local query = Format([[UPDATE `onyx_creditstore_players` SET balance = balance + %i WHERE steamid64 = '%s';]], amount, self.db:Escape(steamid64))

    if (IsValid(target)) then
        target:onyx_SetNetVar('store_busy', true)
    end

    self.db:Queue(query, function()
        if (IsValid(target)) then
            creditstore:FetchInventory(steamid64, function(_, balance)
                if (IsValid(target)) then
                    target:onyx_SetNetVar('credits', balance)
                    target:onyx_SetNetVar('store_busy', false)
                end
            
                if (callback) then
                    callback(target)
                end
            end)
        else
            if (callback) then
                callback()
            end
        end
    end)
end

function creditstore:TakeCredits(steamid64, amount, callback)
    if (IsEntity(steamid64) and steamid64:IsPlayer()) then steamid64 = steamid64:SteamID64() end -- convenience

    assert(isstring(steamid64), string.format('bad argument #1 to \'TakeCredits\' (expected string, got %s)', type(steamid64)))
    assert(isnumber(amount), string.format('bad argument #2 to \'TakeCredits\' (expected number, got %s)', type(amount)))
    assert(amount > 0, 'bad argument #2 to \'TakeCredits\' (number must be positive)')

    local target = player.GetBySteamID64(steamid64)
    local query = Format([[UPDATE `onyx_creditstore_players` SET balance = MAX(0, balance - %i) WHERE steamid64 = '%s';]], amount, self.db:Escape(steamid64))

    if (self.db.module == 'mysqloo') then
        query = query:gsub('MAX', 'GREATEST', 1)
    end

    if (IsValid(target)) then
        target:onyx_SetNetVar('store_busy', true)
    end

    self.db:Queue(query, function()
        if (IsValid(target)) then
            creditstore:FetchInventory(steamid64, function(_, balance)
                if (IsValid(target)) then
                    target:onyx_SetNetVar('credits', balance)
                    target:onyx_SetNetVar('store_busy', false)
                end
            
                if (callback) then
                    callback(target)
                end
            end)
        else
            if (callback) then
                callback()
            end
        end
    end)
end

function creditstore:SetCredits(steamid64, amount, callback)
    if (IsEntity(steamid64) and steamid64:IsPlayer()) then steamid64 = steamid64:SteamID64() end -- convenience

    assert(isstring(steamid64), string.format('bad argument #1 to \'SetCredits\' (expected string, got %s)', type(steamid64)))
    assert(isnumber(amount), string.format('bad argument #2 to \'SetCredits\' (expected number, got %s)', type(amount)))
    assert(amount >= 0, 'bad argument #2 to \'SetCredits\' (number must be positive or zero)')

    local target = player.GetBySteamID64(steamid64)
    local query = Format([[UPDATE `onyx_creditstore_players` SET balance = %i WHERE steamid64 = '%s';]], amount, self.db:Escape(steamid64))

    if (IsValid(target)) then
        target:onyx_SetNetVar('store_busy', true)
    end

    self.db:Queue(query, function()
        if (IsValid(target)) then
            creditstore:FetchInventory(steamid64, function(_, balance)
                if (IsValid(target)) then
                    target:onyx_SetNetVar('credits', balance)
                    target:onyx_SetNetVar('store_busy', false)
                end
            
                if (callback) then
                    callback(target)
                end
            end)
        else
            if (callback) then
                callback()
            end
        end
    end)
end

function creditstore:SyncInventoryItemData(ply, index)
    local inventory = self:GetPlayerInventory(ply)
    local it = inventory[index]
    local data = it.data or {}

    net.Start('onyx.creditstore:SyncInventoryItemData')
        net.WriteUInt(index, 16)
        onyx.net.WriteTable(data)
    net.Send(ply)
end

--[[------------------------------
HOOKS
--------------------------------]]
hook.Add('onyx.PlayerNetworkReady', 'onyx.creditstore.inventory', function(ply)
    creditstore:LoadInventory(ply)
end)

hook.Add('PlayerLoadout', 'onyx.creditstore.inventory', function(ply)
    local inventory = creditstore:GetPlayerInventory(ply)
    for _, it in ipairs(inventory) do
        local itemTable = creditstore.items[it.id]
        if (itemTable) then
            local itemTypeData = creditstore.types[itemTable.type]
            local data = it.data or {}
            if (itemTypeData and itemTypeData.equip and data.equipped and itemTypeData.onLoadout) then
                itemTypeData.onLoadout(ply, itemTable.data)
            end
        end
    end
end)
-- creditstore:LoadInventory(Entity(1))
-- creditstore:LoadInventory(Entity(1))

--[[------------------------------
NETWORK
--------------------------------]]
net.Receive('onyx.creditstore:PurchaseItem', function(len, ply)
    local itemID = net.ReadString()
    local itemTable = creditstore.items[itemID]

    if (ply:GetVar('onyx_CreditStoreNetDelay', 0) > CurTime()) then
        return
    end

    ply:SetVar('onyx_CreditStoreNetDelay', CurTime() + .66)

    if (not itemTable) then
        return
    end

    local itemTypeData = creditstore.types[itemTable.type]
    if (not itemTypeData) then
        return
    end

    if (ply:onyx_GetNetVar('store_busy')) then
        return
    end

    if (not ply:onyx_GetNetVar('store_loaded')) then
        return
    end

    if (itemTypeData.noDuplicates and creditstore:GetPlayerItemAmount(ply, itemID) > 0) then
        return
    end

    local customCheck = itemTypeData.customCheck
    if (customCheck) then
        local allowed, reason = customCheck(ply, itemTable)
        if (allowed == false) then
            onyx.Notify(ply, (reason or 'You cannot purchase that!'), 1, 5)
            return
        end
    end

    local name = itemTable.name
    local price = itemTable.price

    if (creditstore:GetCredits(ply) < price) then
        return
    end

    local steamid64 = ply:SteamID64()
    local data = itemTypeData.generateItemData and itemTypeData.generateItemData(itemTable) or {}

    data.unix = os.time() -- the time when purchase happens, for refunds and etc.
    data.price = price -- so players cannot refund it by different price (discounts, config changes)

    creditstore:TakeCredits(steamid64, price, function(client)
        if (IsValid(client)) then
            creditstore:AddPlayerItem(client, itemID, data)

            onyx.NotifyLocalized(client, 'youPurchased', {item = name})

            -- no errors during mysql query callback
            local success, errString = pcall(hook.Run, 'onyx.creditstore.PlayerPurchasedItem', client, itemID, price)
            if (not success) then
                creditstore:PrintError('During hook \'onyx.creditstore.PlayerPurchasedItem\', error text: #', errString)
            end
        end
    end)
end)

local equipOption = {func = function(ply, itemTableData, it, itemIndex, itemTypeData)
    -- unequip all similar items
    local uniqueEquip = itemTypeData.uniqueEquip
    if (uniqueEquip) then
        local inventory = creditstore:GetPlayerInventory(ply)
        for _, it2 in ipairs(inventory) do
            local item2 = creditstore.items[it2.id]
            if (item2 and item2.type == itemTypeData.id and it2.data and it2.data.equipped) then
                it2.data.equipped = nil
            end
        end
    end

    it.data = it.data or {}
    it.data.equipped = true

    if (itemTypeData.onEquip) then
        itemTypeData.onEquip(ply, itemTableData)
    end

    creditstore:SyncInventoryItemData(ply, itemIndex)
    creditstore:SaveInventory(ply)
    -- creditstore:SaveInventory(ply, function()
    --     if (IsValid(ply)) then
    --         creditstore:SyncInventory(ply)
    --     end
    -- end)
end}

local unequipOption = {func = function(ply, itemTableData, it, itemIndex, itemTypeData)
    it.data = it.data or {}
    it.data.equipped = nil

    if (itemTypeData.onUnequip) then
        itemTypeData.onUnequip(ply, itemTableData)
    end

    creditstore:SyncInventoryItemData(ply, itemIndex)
    creditstore:SaveInventory(ply)
    -- creditstore:SaveInventory(ply, function()
    --     if (IsValid(ply)) then
    --         creditstore:SyncInventory(ply)
    --     end
    -- end)
end}

net.Receive('onyx.creditstore:UseOption', function(len, ply)
    local itemIndex = net.ReadUInt(16)
    local optionID = net.ReadString()

    if (ply:GetVar('onyx_CreditStoreNetDelay', 0) > CurTime()) then
        return
    end

    ply:SetVar('onyx_CreditStoreNetDelay', CurTime() + .66)

    local inventory = creditstore:GetPlayerInventory(ply)
    local it = inventory[itemIndex]
    if (not it) then return end

    local itemID = it.id -- the identifier (class) stored in item instance
    local itemData = it.data -- data stored in item instance
    local itemTable = creditstore.items[itemID] -- item's in-game configuration table
    if (not itemTable) then return end

    local itemTypeData = creditstore.types[itemTable.type] -- type's lua configuration table (lua\onyx\modules\creditstore\cfg\sh_types.lua)
    if (not itemTypeData) then return end

    local options = table.Copy(itemTypeData.options or {})
    if (itemTypeData.equip) then
        options['equip'] = equipOption
        options['unequip'] = unequipOption
    end

    local option = options[optionID]
    if (not option) then return end

    assert(option.func, Format('no function for option \"%s\" in type \"%s\"', optionID, itemTable.type))

    local itemTableData = itemTable.data

    -- check if a player could use the option
    if (option.check and not option.check(ply, itemTableData)) then 
        return 
    end

    local bAllowed = hook.Run('onyx.creditstore.CanPlayerUseOption', ply, optionID, it, itemTable, itemTypeData)
    if (bAllowed == false) then -- the value returned from hook could be nil
        return
    end

    if (option.removeItem) then
        creditstore:RemovePlayerItem(ply, itemIndex, function(ply)
            option.func(ply, itemTableData)
        end)
    else
        option.func(ply, itemTableData, it, itemIndex, itemTypeData)
    end

    hook.Run('onyx.creditstore.PlayerUsedOption', ply, itemID, optionID)
end)

--[[------------------------------
COMMANDS
--------------------------------]]
local function GiveCreditsToSteamID64(steamid64, credits)
    if (not steamid64) then
        print('(onyx_give_credits) You must provide steamid64 as the first argument!')
        return
    end

    if (not credits) then
        print('(onyx_give_credits) You must provide credits as the second argument!')
        return
    end

    if (credits < 1) then
        print('(onyx_give_credits) The credit amount must be positive!')
        return
    end

    creditstore:AddCredits(steamid64, credits)
end

local function TakeCreditsFromSteamID64(steamid64, credits)
    if (not steamid64) then
        print('(onyx_give_credits) You must provide steamid64 as the first argument!')
        return
    end

    if (not credits) then
        print('(onyx_give_credits) You must provide credits as the second argument!')
        return
    end

    if (credits < 1) then
        print('(onyx_give_credits) The credit amount must be positive!')
        return
    end

    creditstore:TakeCredits(steamid64, credits)
end

concommand.Add('onyx_give_credits', function(ply, cmd, args)
    if (ply == NULL) then
        local steamid64 = args[1]
        local credits = tonumber(args[2])

        GiveCreditsToSteamID64(steamid64, credits)
    end
end)

concommand.Add('onyx_take_credits', function(ply, cmd, args)
    if (ply == NULL) then
        local steamid64 = args[1]
        local credits = tonumber(args[2])

        TakeCreditsFromSteamID64(steamid64, credits)
    end
end)

concommand.Add('onyx_give_credits_steamid32', function(ply, cmd, args)
    if (ply == NULL) then
        local steamid32 = args[1]
        local credits = tonumber(args[2])
        local steamid64 = util.SteamIDTo64(steamid32)
        if (steamid64 ~= '0') then
            GiveCreditsToSteamID64(steamid64, credits)
        else
            print('(onyx_give_credits_steamid32) Invalid SteamID32!')
        end
    end
end)

concommand.Add('onyx_take_credits_steamid32', function(ply, cmd, args)
    if (ply == NULL) then
        local steamid32 = args[1]
        local credits = tonumber(args[2])
        local steamid64 = util.SteamIDTo64(steamid32)
        if (steamid64 ~= '0') then
            TakeCreditsFromSteamID64(steamid64, credits)
        else
            print('(onyx_give_credits_steamid32) Invalid SteamID32!')
        end
    end
end)