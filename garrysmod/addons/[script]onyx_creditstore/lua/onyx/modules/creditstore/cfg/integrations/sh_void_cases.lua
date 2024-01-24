--[[

Author: tochnonement
Email: tochnonement@gmail.com

23/05/2023

--]]
local INTEGRATION = {}

INTEGRATION.Name = 'VoidCases'
INTEGRATION.Color = Color(63, 184, 63)
INTEGRATION.Desc = 'https://www.gmodstore.com/market/view/voidcases-unboxing-system'

function INTEGRATION:Check()
    return (VoidCases ~= nil)
end

local TYPE_CASE = 2
local TYPE_KEY = 3
local voidFunction = function() end

local function registerItemType(index, key, name)
    onyx.creditstore:RegisterType('voidcases_' .. key, {
        name = name,
        fullName = '[VoidCases] ' .. name,
        color = Color(202, 233, 64),
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
                    local uniqueID = data.itemid
                    local item
        
                    for _, data in ipairs(VoidCases.Config.Items) do
                        if (data.id == uniqueID) then
                            item = data
                            break
                        end
                    end
    
                    if (not item) then
                        return false
                    end
    
                    VoidCases.AddItem(ply:SteamID64(), uniqueID, 1)
                    VoidCases.NetworkItem(ply, uniqueID, 1)
                    -- RCD.GiveVehicle(ply, uniqueID)
                end
            }
        },
        setupModelPanel = function(dmodel, item)
            local data = item.data.itemid
            local item

            for _, data2 in ipairs(VoidCases.Config.Items or {}) do
                if (data2.id == data) then
                    item = data2
                    break
                end
            end

            local ent = dmodel.Entity
            if (item) then
                local info = item.info

                local mn, mx = ent:GetRenderBounds()
                local size = 0
                size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
                size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
                size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
    
                dmodel:SetFOV( item.info.zoom or 55 )
                dmodel:SetCamPos( Vector( size, size, size ) )
                dmodel:SetLookAt( ( mn + mx ) * 0.5 )

                if (item.type == TYPE_CASE) then
                    local colorTable = info.caseColor
                    local colorVector = Vector(colorTable.r / 255, colorTable.g / 255, colorTable.b / 255)

                    if (not VoidCases.CachedMaterials[info.caseIcon]) then
                        VoidCases.FetchImage(info.caseIcon, voidFunction)
                    end

                    ent:SetNWVector('CrateColor', colorVector)
                    ent:SetNWString('CrateLogo', info.caseIcon)
                end

                dmodel.LayoutEntity = voidFunction
            end
        end,
        settings = {
            {
                key = 'itemid',
                name = 'ITEM',
                desc = 'The item.',
                icon = 'https://i.imgur.com/zgt3zea.png',
                type = 'combo',
                getOptions = function()
                    local options = {}

                    for _, data in pairs(VoidCases.Config.Items or {}) do
                        if (data.type == index) then
                            table.insert(options, {
                                text = data.name,
                                data = data.id
                            })
                        end
                    end
            
                    table.sort(options, function(a, b)
                        return a.text < b.text
                    end)
            
                    return options
                end,
                onChoose = function(index, text, data, fields)
                    local item

                    for _, data2 in pairs(VoidCases.Config.Items or {}) do
                        if (data2.id == data) then
                            item = data2
                            break
                        end
                    end

                    if (item) then
                        fields.name.entry:SetValue(item.name)
                        fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)

                        local icon = item.info and item.info.icon

                        if (VoidCases.IsModel(icon)) then
                            fields.icon.picker:ChooseOptionID(2)
                        else
                            fields.icon.picker:ChooseOptionID(1)
                        end

                        fields.icon.entry:SetValue(icon)
                        fields.icon.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
                    end
                end,
                validateOption = function(data)
                    -- do not be lazy to do this function, it is also used on the server side to validate value
                    if (not data) then return false, 'You must choose a case!' end

                    if (SERVER) then
                        local items = VoidCases.Config.Items or {}
                        local found = false

                        for _, item in pairs(items) do
                            if (item.id == data) then
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

function INTEGRATION:Load()
    VoidCases.AddCurrency('Onyx Credits', function(ply)
        local credits = onyx.creditstore:GetCredits(ply)

        if (ply:onyx_GetNetVar('store_busy')) then
            return 0
        end

        return credits
    end, function(ply, amount)
        if (amount > 0) then
            onyx.creditstore:AddCredits(ply, amount)
        else
            onyx.creditstore:TakeCredits(ply, math.abs(amount))
        end
    end)

    VoidCases.CreateAction('Onyx Credits', function (ply, value)
        onyx.creditstore:AddCredits(ply, tonumber(value))
    end, {
        varType = 'number',
        title = 'Credits'
    })

    registerItemType(TYPE_CASE, 'case', 'Case')
    registerItemType(TYPE_KEY, 'key', 'Key')
end

onyx.creditstore:RegisterIntegration('voidcases', INTEGRATION)