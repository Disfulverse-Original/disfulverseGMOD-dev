--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

local findMethod, giveXP do
    local methods = {
        ['LevelSystemConfiguration'] = function(ply, amount) -- vrondakis
            ply:addXP(amount, true)
        end,
        ['Sublime'] = function(ply, amount)
            ply:SL_AddExperience(amount, 'Purchase', true)
        end,
        ['DARKRP_ESSENTIALS'] = function(ply, amount)
            ply:AddExperience(amount, 'Purchase')
        end,
        ['GlorifiedLeveling'] = function(ply, amount)
            GlorifiedLeveling.AddPlayerXP(ply, amount)
        end,
    }
    
    methods['DarkRPFoundation'] = methods['DARKRP_ESSENTIALS']
    methods['UUI'] = methods['DARKRP_ESSENTIALS']

    function findMethod(ply)
        -- look through addons
        for name, fn in pairs(methods) do
            if (_G[name]) then
                return fn
            end
        end

        -- player methods
        if (ply.addXP) then
            return function(ply, amount)
                ply:addXP(amount)
            end
        elseif (ply.AddXP) then
            return function(ply, amount)
                ply:AddXP(amount)
            end
        end
    end
    
    function giveXP(ply, amount)
        local func = findMethod(ply)
        if (func) then
            func(ply, amount)
        else
            onyx.creditstore:PrintError('No method found to give XP!')
        end
    end
end

onyx.creditstore:RegisterType('xp', {
    name = 'Experience',
    color = Color(233, 208, 69),
    stacking = true,
    defaultIcon = 'https://i.imgur.com/DiiOnis.png',
    options = {
        ['use'] = {
            removeItem = true,
            check = function(ply, data)
                if (SERVER and findMethod(ply) == nil) then
                    return false, 'no method'
                end
                return true
            end,
            func = function(ply, data)
                local amount = tonumber(data.amount)

                giveXP(ply, amount)
            end
        }
    },
    settings = {
        {
            key = 'amount',
            name = 'AMOUNT',
            desc = 'The amount of XP to give.',
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