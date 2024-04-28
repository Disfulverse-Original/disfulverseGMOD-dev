--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

local BOOSTER_HEALTH = 0
local BOOSTER_ARMOR = 1
local BOOSTER_SPEED = 2
local BOOSTER_DAMAGE = 3
local BOOSTER_JUMP = 4

onyx.creditstore:RegisterType('permbooster', {
    name = 'Permanent Booster',
    color = Color(233, 94, 69),
    noDuplicates = true,
    equip = true,
    settings = {
        {
            key = 'action',
            name = 'VARIABLE',
            desc = 'What variable to edit',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'combo',
            options = {
                {text = 'Health', data = BOOSTER_HEALTH},
                {text = 'Armor', data = BOOSTER_ARMOR},
                {text = 'Speed', data = BOOSTER_SPEED},
                {text = 'Damage', data = BOOSTER_DAMAGE},
                {text = 'Jump', data = BOOSTER_JUMP}
            },
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (data == nil) then return false, 'You must choose a variable type!' end
                if (not isnumber(data)) then return false end
                if (data < 0 or data > 4) then return false end
        
                return true
            end
        },
        {
            key = 'percents',
            name = 'PERCENTAGE',
            desc = 'The percentage.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'number',
            placeholder = '20',
            validateOption = function(value)
                if (not isnumber(value)) then
                    return false, 'The amount must be a number!'
                end
                if (value < 1) then
                    return false, 'The amount must be higher than 1!'
                end
                if (value > 100) then
                    return false, 'The amount must be lower than 100!'
                end
                return true
            end
        }
    }
})

if (CLIENT) then
    return
end

local functions = {
    [BOOSTER_HEALTH] = function(ply, fraction)
        local maxHealth = ply:GetMaxHealth()
        local curHealth = ply:Health()
        local addHealth = math.floor(maxHealth * fraction)

        ply:SetHealth(curHealth + addHealth)
        ply:SetMaxHealth(maxHealth + addHealth)
    end,
    [BOOSTER_ARMOR] = function(ply, fraction)
        local maxArmor = ply:GetMaxArmor()
        local curArmor = ply:Armor()
        local addArmor = math.floor(maxArmor * fraction)

        ply:SetArmor(curArmor + addArmor)
    end,
    [BOOSTER_SPEED] = function(ply, fraction)
        ply:SetWalkSpeed(math.floor(ply:GetWalkSpeed() * (1 + fraction)))
        ply:SetRunSpeed(math.floor(ply:GetRunSpeed() * (1 + fraction)))
    end,
    [BOOSTER_DAMAGE] = function(ply, fraction)
        ply.onyx_DamageScale = (1 + fraction)
    end,
    [BOOSTER_JUMP] = function(ply, fraction)
        ply:SetJumpPower(math.floor(ply:GetJumpPower() * (1 + fraction)))
    end
}

hook.Add('PlayerLoadout', 'onyx.creditstore.booster', function(ply)
    local inv = onyx.creditstore:GetPlayerInventory(ply)
    for _, it in ipairs(inv) do
        local id = it.id
        local item = onyx.creditstore.items[id]
        if (item and item.type == 'permbooster') then
            local data = item.data
            local action = data.action
            local percents = data.percents
            local func = functions[action]
            if (func and it.data and it.data.equipped) then
                func(ply, (percents / 100))
            end
        end
    end
end)

hook.Add('EntityTakeDamage', 'onyx.creditstore.booster', function(ent, dmg)
    local attacker = dmg:GetAttacker()
    if (IsValid(attacker) and attacker.onyx_DamageScale) then
        dmg:ScaleDamage(attacker.onyx_DamageScale)
    end
end)