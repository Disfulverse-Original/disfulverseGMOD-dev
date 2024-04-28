--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/05/2023

--]]

local creditstore = onyx.creditstore

util.AddNetworkString('onyx.creditstore:Refund')

net.Receive('onyx.creditstore:Refund', function(len, ply)
    local itemIndex = net.ReadUInt(16)

    if (ply:GetVar('onyx_CreditStoreNetDelay', 0) > CurTime()) then
        return
    end

    ply:SetVar('onyx_CreditStoreNetDelay', CurTime() + .66)

    if (not onyx.creditstore:GetOptionValue('refunds_enabled')) then
        return
    end

    local inventory = creditstore:GetPlayerInventory(ply)
    if (not inventory) then
        return
    end

    local it = inventory[itemIndex]
    if (not it) then
        return
    end

    local data = it.data
    if (not data or not data.unix or not data.price) then
        return
    end

    if (os.time() >= creditstore:GetRefundEndTime(data.unix)) then
        onyx.Notify(ply, 'Too late to refund!', 1)
        return
    end

    local itemID = it.id
    local price = creditstore:GetRefundPrice(data.price)
    local item = creditstore.items[itemID]
    local name = item and item.name or 'Item'

    ply:onyx_SetNetVar('store_busy', true)

    creditstore:RemovePlayerItem(ply, itemIndex, function(ply)
        -- ply here is always valid
        creditstore:AddCredits(ply:SteamID64(), price, function()
            -- but here may not be valid
            if (IsValid(ply)) then
                onyx.NotifyLocalized(ply, 'youRefunded', {
                    item = name,
                    price = creditstore.FormatMoney(price)
                })
            
                -- no errors during mysql query callback
                xpcall(hook.Run, function(status, errorString)
                    if (not status) then
                        creditstore:PrintError('During hook \'onyx.creditstore.PlayerRefundedItem\', error text: #', errorString)
                    end
                end, 'onyx.creditstore.PlayerRefundedItem', ply, itemID, price)
            end
        end)
    end)
end)