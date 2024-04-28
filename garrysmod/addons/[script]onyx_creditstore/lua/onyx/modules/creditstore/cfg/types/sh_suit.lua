--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

local function createPermanentItemTypeCopy(realID, copyID, color, name)
    local typeData = onyx.creditstore.types[realID]
    if (typeData) then
        assert(typeData.options, Format('invalid item type %s to make it permanent (no options)', realID))
        assert(typeData.options.use, Format('invalid item type %s to make it permanent (no use option)', realID))

        local copy = table.Copy(typeData)
        
        copy.name = name
        copy.color = color
        copy.options.use.removeItem = nil
        copy.noDuplicates = true
        copy.stacking = nil

        onyx.creditstore:RegisterType(copyID, copy)
    end
end

onyx.netvar:Register('store_suit', {
    type = TYPE_BOOL,
    public = false
})

onyx.creditstore:RegisterType('suit', {
    name = 'Suit',
    color = Color(160, 120, 120),
    stacking = true,
    options = {
        ['use'] = {
            removeItem = true,
            check = function(ply, data)
                if (not ply:Alive()) then
                    return false, onyx.lang:Get('youMustBeAlive')
                end

                if (ply:onyx_GetNetVar('store_suit')) then
                    return false, 'You already are wearing a suit!'
                end
            
                return true
            end,
            func = function(ply, data)
                local model = data.model
                local health = ply:GetMaxHealth() * (1 + tonumber(data.health) / 100)
                local armor = math.min(255, ply:GetMaxArmor() * (1 + tonumber(data.armor) / 100))
                local walkingspeed = ply:GetWalkSpeed() * (1 + tonumber(data.speed) / 100)
                local runspeed = ply:GetRunSpeed() * (1 + tonumber(data.speed) / 100)
                local jumppower = ply:GetJumpPower() * (1 + tonumber(data.jumppower) / 100)

                -- no way to unequip suit or equip another one, the only one is death & respawn which will reset vars automatically
                ply.onyx_OldPlayerModel = nil
                ply:onyx_SetNetVar('store_suit', true)
                ply:SetModel(model)
                ply:SetHealth(health)
                ply:SetMaxHealth(health)
                ply:SetArmor(armor)
                -- ply:SetMaxArmor(armor)
                ply:SetWalkSpeed(walkingspeed)
                ply:SetRunSpeed(runspeed)
                ply:SetJumpPower(jumppower)
                ply:SetupHands()
            end
        }
    },
    settings = {
        {
            key = 'model',
            name = 'MODEL',
            desc = 'The model path.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'string',
            validateOption = function(value)
                if (value == '') then
                    return false, 'You must enter the model!'
                end
        
                if (IsUselessModel(value)) then
                    return false, 'You must enter the valid model!'
                end
        
                return true
            end
        },
        {
            key = 'health',
            name = 'HEALTH',
            desc = 'The boost for health in percents',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'number',
            placeholder = '50',
            validateOption = function(value)
                if (not isnumber(value)) then
                    return false, 'The amount must be a number!'
                end
                if (value < 1) then
                    return false, 'The amount must be higher than 1!'
                end
                return true
            end
        },
        {
            key = 'armor',
            name = 'ARMOR',
            desc = 'The boost for armor in percents',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'number',
            placeholder = '50',
            validateOption = function(value)
                if (not isnumber(value)) then
                    return false, 'The amount must be a number!'
                end
                if (value < 0) then
                    return false, 'The amount must be higher than 0!'
                end
                return true
            end
        },
        {
            key = 'speed',
            name = 'SPEED',
            desc = 'The boost for speed in percents.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'number',
            placeholder = '50',
            validateOption = function(value)
                if (not isnumber(value)) then
                    return false, 'The amount must be a number!'
                end
                if (value < 1) then
                    return false, 'The amount must be higher than 1!'
                end
                return true
            end
        },
        {
            key = 'jumppower',
            name = 'JUMP POWER',
            desc = 'The boost for jump power in percents',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'number',
            placeholder = '50',
            validateOption = function(value)
                if (not isnumber(value)) then
                    return false, 'The amount must be a number!'
                end
                if (value < 1) then
                    return false, 'The amount must be higher than 1!'
                end
                return true
            end
        },
    }
})

createPermanentItemTypeCopy('suit', 'permsuit', Color(233, 69, 69), 'Permanent Suit')

if (SERVER) then
    hook.Add('PlayerSpawn', 'onyx.creditstore.suit', function(ply)
        ply:onyx_SetNetVar('store_suit', false)
    end)

    hook.Add('onyx.creditstore.CanPlayerUseOption', 'onyx.creditstore.suit', function(ply, optionID, it, itemTable, itemTypeData)
        if (ply:onyx_GetNetVar('store_suit') and itemTable.type == 'permmodel' and optionID == 'equip') then
            return false
        end
    end)
end