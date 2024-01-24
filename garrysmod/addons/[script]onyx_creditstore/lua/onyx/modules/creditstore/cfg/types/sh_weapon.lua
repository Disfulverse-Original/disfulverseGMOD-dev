--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

local tWeaponOption = {
    key = 'wpnclass',
    name = 'WEAPON',
    desc = 'The weapon linked to the item.',
    icon = 'https://i.imgur.com/zgt3zea.png',
    type = 'combo',
    getOptions = function()
        local options = {}

        for _, data in pairs(weapons.GetList()) do
            local class = data.ClassName
            if (class and not class:find('base') and data.PrintName) then
                local category = data.Category or 'Other'
                local printName = language.GetPhrase(data.PrintName)
                local name = category and (category .. ' | ' .. printName) or printName

                table.insert(options, {
                    text = name,
                    data = class
                })
            end
        end

        table.sort(options, function(a, b)
            return a.text < b.text
        end)

        return options
    end,
    onChoose = function(index, text, data, fields)
        local wep = weapons.Get(data)   
        if (wep) then
            local model = wep.WorldModel and (wep.WorldModel ~= '' and wep.WorldModel or 'models/error.mdl') or 'models/error.mdl'
            fields.icon.picker:ChooseOptionID(2)

            fields.icon.entry:SetValue(model)
            fields.icon.entry:Highlight(onyx.GetOppositeAccentColor(), 3)

            fields.name.entry:SetValue(wep.PrintName or 'UNKNOWN')
            fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
        end
    end,
    validateOption = function(data)
        -- do not be lazy to do this function, it is also used on the server side to validate value
        if (not data) then return false, 'You must choose a weapon!' end
        if (not weapons.Get(data)) then return false end

        return true
    end
}

onyx.creditstore:RegisterType('weapon', {
    name = 'Weapon',
    color = Color(252, 97, 97),
    stacking = true,
    options = {
        ['use'] = {
            removeItem = true,
            check = function(ply, data)
                if (not ply:Alive()) then
                    return false, onyx.lang:Get('youMustBeAlive')
                end

                if (ply:HasWeapon(data.wpnclass)) then
                    return false, 'You already have this weapon!'
                end

                return true
            end,
            func = function(ply, data)
                local class = data.wpnclass
                if (class) then
                    ply:Give(class)
                    return true
                end
            end
        }
    },
    settings = {
        tWeaponOption
    }
})

onyx.creditstore:RegisterType('permweapon', {
    name = 'Permanent Weapon',
    color = Color(233, 148, 69),
    noDuplicates = true,
    equip = true,
    onEquip = function(ply, itemTableData)
        ply:Give(itemTableData.wpnclass)
    end,
    onUnequip = function(ply, itemTableData)
        ply:StripWeapon(itemTableData.wpnclass)
    end,
    onLoadout = function(ply, itemTableData)
        ply:Give(itemTableData.wpnclass)
    end,
    options = {},
    generateItemData = function(itemTable)
        return {}
    end,
    settings = {
        tWeaponOption
    }
})