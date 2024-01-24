--[[

Author: tochnonement
Email: tochnonement@gmail.com

15/05/2023

--]]

local INTEGRATION = {}

INTEGRATION.Name = 'Advanced Accessory'
INTEGRATION.Color = Color(63, 146, 184)
INTEGRATION.Desc = 'https://www.gmodstore.com/market/view/advanced-accessory-the-most-advanced-accessory-system'

function INTEGRATION:Check()
    return (AAS ~= nil)
end

function INTEGRATION:Load()
    onyx.creditstore:RegisterType('aas_accessory', {
        name = 'Accessory',
        color = Color(156, 0, 247),
        noDuplicates = true,
        setupModelPanel = function(dmodel, item)
            local data = item.data.accessory
            local accessory

            for _, data2 in ipairs(AAS.ClientTable["ItemsTable"]) do
                if (data2.uniqueId == data) then
                    accessory = data2
                    break
                end
            end

            local ent = dmodel.Entity
            if (accessory) then
                local min, max = ent:GetRenderBounds()
                local options = accessory.options
                local size = 0

                for _, key in ipairs({'x', 'y', 'z'}) do
                    size = math.max(size, math.abs(min[key]) + math.abs(max[key]))
                end
        
                dmodel:SetCamPos(Vector(size, size, size))
    
                if istable(options) then
                    local iconFov = options["iconFov"]
                    local iconPos = options["iconPos"]
                
                    if isnumber(iconFov) then
                        dmodel:SetFOV(50 + iconFov)
                    end
    
                    if isvector(iconPos) then
                        dmodel:SetLookAt((min + max) * .5 + iconPos)
                    end
                end

                dmodel.LayoutEntity = function() end
            end
        end,
        customCheck = function(ply, item)
            local uniqueID = item.data.accessory

            if (CLIENT) then
                local inventory = AAS.ClientTable.ItemsInventory
                for _, data in pairs(inventory) do
                    if (data.uniqueId == uniqueID) then
                        return false, onyx.lang:Get('owned_u')
                    end
                end
            else
                return (not ply:AASIsBought(uniqueID)), 'You already have it!'
            end
        end,
        options = {
            ['use'] = {
                removeItem = true,
                check = function(ply, data)
                    if (not ply:Alive()) then
                        return false, onyx.lang:Get('youMustBeAlive')
                    end
    
                    return true
                end,
                func = function(ply, data)
                    local uniqueID = data.accessory
                    local accessory
        
                    for _, data in ipairs(AAS.Table.items) do
                        if (data.uniqueId == uniqueID) then
                            accessory = data
                            break
                        end
                    end
    
                    if (not accessory) then
                        return false
                    end
    
                    AAS.GiveItem(ply:SteamID64(), uniqueID, 0)
                end
            }
        },
        settings = {
            {
                key = 'accessory',
                name = 'ACCESSORY',
                desc = 'The accessory.',
                icon = 'https://i.imgur.com/zgt3zea.png',
                type = 'combo',
                getOptions = function()
                    local options = {}

                    for _, data in ipairs(AAS.ClientTable["ItemsTable"]) do
                        table.insert(options, {
                            text = (data.category or 'Unknown') .. ' | ' .. data.name,
                            data = data.uniqueId
                        })
                    end
            
                    table.sort(options, function(a, b)
                        return a.text < b.text
                    end)
            
                    return options
                end,
                onChoose = function(index, text, data, fields)
                    local accessory

                    for _, data2 in ipairs(AAS.ClientTable["ItemsTable"]) do
                        if (data2.uniqueId == data) then
                            accessory = data2
                            break
                        end
                    end

                    if (accessory) then
                        local model = accessory.model or 'models/error.mdl'

                        fields.icon.picker:ChooseOptionID(2)
            
                        fields.icon.entry:SetValue(model)
                        fields.icon.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
            
                        fields.name.entry:SetValue(accessory.name)
                        fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
                    end
                end,
                validateOption = function(data)
                    -- do not be lazy to do this function, it is also used on the server side to validate value
                    if (not data) then return false, 'You must choose an accessory!' end

                    if (SERVER) then
                        local items = AAS.Table.items
                        local found = false

                        for _, accessory in ipairs(items) do
                            if (accessory.uniqueId == data) then
                                found = true
                                break
                            end
                        end

                        if (not found) then
                            return false, 'invalid item'
                        end
                    end
            
                    return true
                end
            }
        }
    })
end

onyx.creditstore:RegisterIntegration('aas', INTEGRATION)