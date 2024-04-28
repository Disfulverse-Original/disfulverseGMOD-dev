--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

onyx.creditstore:RegisterType('trail', {
    name = 'Trail',
    color = Color(85, 69, 233),
    noDuplicates = true,
    equip = true,
    uniqueEquip = true,
    defaultIcon = 'https://i.imgur.com/LNjxkeD.png',
    onEquip = function(ply, itemTableData)
        if (IsValid(ply.onyx_TrailEnt)) then
            ply.onyx_TrailEnt:Remove()
        end

        ply.onyx_TrailEnt = util.SpriteTrail(ply, 0, Color( 255, 255, 255 ), false, 15, 1, 4, 1 / 16 * 0.5, itemTableData.texture)
    end,
    onUnequip = function(ply, itemTableData)
        if (IsValid(ply.onyx_TrailEnt)) then
            ply.onyx_TrailEnt:Remove()
        end
    end,
    onLoadout = function(ply, itemTableData)
        ply.onyx_TrailEnt = ply:GetModel()
    end,
    settings = {
        {
            key = 'texture',
            name = 'TEXTURE',
            desc = 'The texture/material path.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'combo',
            getOptions = function()
                local options = {}
        
                for name, texture in pairs(list.Get('trail_materials')) do
                    local printName = language.GetPhrase(name)
    
                    table.insert(options, {
                        text = printName,
                        data = texture
                    })
                end
        
                table.sort(options, function(a, b)
                    return a.text < b.text
                end)
        
                return options
            end,
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (not data) then return false, 'You must choose a trail!' end
        
                return true
            end
        }
    }
})