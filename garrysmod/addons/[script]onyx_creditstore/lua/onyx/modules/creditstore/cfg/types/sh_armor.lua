--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

onyx.creditstore:RegisterType('armor', {
    name = 'Armor',
    color = Color(69, 99, 233),
    stacking = true,
    options = {
        ['use'] = {
            removeItem = true,
            check = function(ply, data)
                if (not ply:Alive()) then
                    return false, onyx.lang:Get('youMustBeAlive')
                end

                if (data.action == 1) then
                    if (ply:Armor() >= data.amount) then
                        return false, onyx.lang:Get('armorIsFull')
                    end
                else
                    if (ply:Armor() >= ply:GetMaxArmor()) then
                        return false, onyx.lang:Get('armorIsFull')
                    end
                end

                return true
            end,
            func = function(ply, data)
                local amount = tonumber(data.amount)
                local shouldSet = data.action == 1
                if (amount and amount > 0) then
                    if (shouldSet) then
                        ply:SetArmor(amount)
                    else
                        ply:SetArmor(math.min(ply:GetMaxArmor(), ply:Armor() + amount))
                    end
                    return true
                end
            end
        }
    },
    settings = {
        {
            key = 'action',
            name = 'ACTION',
            desc = 'What to do',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'combo',
            options = {
                {text = 'Give Armor', data = 0},
                {text = 'Set Armor', data = 1},
            },
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (data == nil) then return false, 'You must choose an action type!' end
                if (not isnumber(data)) then return false end
                if (data < 0 or data > 1) then return false end
        
                return true
            end
        },
        {
            key = 'amount',
            name = 'AMOUNT',
            desc = 'The amount of AP to give.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'number',
            placeholder = '100',
            validateOption = function(value)
                if (not isnumber(value)) then
                    return false, 'The amount must be a number!'
                end
                if (value < 1) then
                    return false, 'The amount must be higher than 0!'
                end
                return true
            end
        }
    }
})