--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

local setRank
if (SERVER) then
    function setRank(ply, group)
        assert(IsEntity(ply), Format('bad argument #1 to `setRank` (expected player, got %s)', type(ply)))
        assert(isstring(group), Format('bad argument #2 to `setRank` (expected string, got %s)', type(group)))

        local oldGroup = ply:GetUserGroup()

        onyx.creditstore:PrintDebug('Attempting to set a new group # to # (old: #)', group, ply, oldGroup)
    
        if (sam) then
            ply:SetUserGroup(group)
            ply:sam_setrank(group)
            return true
        elseif (ulx) then
            ply:SetUserGroup(group)
            return true
        elseif (sAdmin) then
            sAdmin.setRank(ply, group)
            return true
        end
    end

    local function applyStoreRank(ply)
        local inventory = onyx.creditstore:GetPlayerInventory(ply)
        for _, it in ipairs(inventory) do
            local item = onyx.creditstore.items[it.id]
            if (item and item.type == 'permrank' and it.data and it.data.equipped) then
                setRank(ply, item.data.rank)
                break
            end
        end
    end

    hook.Add('onyx.creditstore.PlayerLoaded', 'onyx.creditstore.rank', function(ply)
        timer.Simple(10, function() -- timer to evade override from admin mode
            if (IsValid(ply)) then
                ply.onyx_InitRank = ply:GetUserGroup()
                applyStoreRank(ply)
            end
        end)
    end)

    hook.Add('CAMI.PlayerUsergroupChanged', 'onyx.creditstore.rank', function(ply, old, new)
        ply.onyx_InitRank = new
        applyStoreRank(ply)
    end)
end

do
    local ITEMTYPE = {}
    ITEMTYPE.name = 'Permanent Rank'
    ITEMTYPE.color = Color(0, 102, 255)
    ITEMTYPE.noDuplicates = true

    ITEMTYPE.equip = true
    ITEMTYPE.uniqueEquip = true
    ITEMTYPE.onEquip = function(ply, itemTableData)
        setRank(ply, itemTableData.rank)
    end
    ITEMTYPE.onUnequip = function(ply, itemTableData)
        if (ply.onyx_InitRank) then
            setRank(ply, ply.onyx_InitRank)
        end
        -- ply.onyx_OldRank = nil
    end

    ITEMTYPE.settings = {
        {
            key = 'rank',
            name = 'RANK',
            desc = 'The rank identifier.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'string',
            validateOption = function(value)
                if (value == '') then
                    return false, 'You must enter the rank id!'
                end
        
                return true
            end
        }
    }

    onyx.creditstore:RegisterType('permrank', ITEMTYPE)
end