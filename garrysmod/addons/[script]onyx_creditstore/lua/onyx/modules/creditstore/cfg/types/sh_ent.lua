--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

onyx.creditstore:RegisterType('entity', {
    name = 'Entity',
    color = Color(66, 116, 53),
    stacking = true,
    options = {
        ['spawn'] = {
            removeItem = true,
            check = function(ply, data)
                if (not ply:Alive()) then
                    return false, onyx.lang:Get('youMustBeAlive')
                end

                return true
            end,
            func = function(ply, data)
                local entClass = data.entclass
                local entData = list.Get('SpawnableEntities')[entClass]
                if (not entData) then
                    return false
                end

                local pos = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 100, ply).HitPos
                local ang = ply:GetAngles()

                ang:RotateAroundAxis(ply:GetUp(), -90)

                local ent = ents.Create(entClass)
                ent:SetPos(pos)
                ent:SetAngles(ang)
                ent:Spawn()
            end
        }
    },
    settings = {
        {
            key = 'entclass',
            name = 'ENTITY',
            desc = 'The entity linked to the item.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'combo',
            getOptions = function()
                local options = {}
        
                for id, data in pairs(list.Get('SpawnableEntities')) do
                    local name = data.PrintName
                    if (name) then
                        local printName = language.GetPhrase(name)
        
                        table.insert(options, {
                            text = printName,
                            data = id
                        })
                    end
                end
        
                table.sort(options, function(a, b)
                    return a.text < b.text
                end)
        
                return options
            end,
            onChoose = function(index, text, data, fields)
                local ent = list.Get('SpawnableEntities')[data]
                if (ent) then
                    fields.name.entry:SetValue(language.GetPhrase(ent.PrintName or 'Unknown'))
                    fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
                end
            end,
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (not data) then return false, 'You must choose an entity!' end
                if (not list.Get('SpawnableEntities')[data]) then return false end
        
                return true
            end
        }
    }
})