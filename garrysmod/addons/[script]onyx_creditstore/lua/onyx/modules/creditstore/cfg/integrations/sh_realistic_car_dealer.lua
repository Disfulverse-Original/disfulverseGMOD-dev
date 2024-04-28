--[[

Author: tochnonement
Email: tochnonement@gmail.com

15/05/2023

--]]

local INTEGRATION = {}

INTEGRATION.Name = 'Realistic Car Dealer'
INTEGRATION.Color = Color(63, 146, 184)
INTEGRATION.Desc = 'https://www.gmodstore.com/market/view/realistic-car-dealer-the-best-car-dealer-system'

function INTEGRATION:Check()
    return (RCD ~= nil)
end

function INTEGRATION:Load()
    onyx.creditstore:RegisterType('rcd_vehicle', {
        name = 'Vehicle',
        fullName = '[RCD] Vehicle',
        color = Color(156, 0, 247),
        noDuplicates = true,
        customCheck = function(ply, item)
            local uniqueID = item.data.vehicleid

            if (CLIENT) then
                local inventory = RCD.ClientTable.vehiclesBought or {}
                for _, data in pairs(inventory) do
                    if (data.vehicleId == uniqueID) then
                        return false, onyx.lang:Get('owned_u')
                    end
                end
            else
                return (not ply:RCDGetVehicleBought(uniqueID)), 'You already have it!'
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
                    local uniqueID = data.vehicleid
                    local vehicleTable
        
                    for _, data in ipairs(AAS.Table.items) do
                        if (data.uniqueId == uniqueID) then
                            vehicleTable = data
                            break
                        end
                    end
    
                    if (not vehicleTable) then
                        return false
                    end
    
                    RCD.GiveVehicle(ply, uniqueID)
                end
            }
        },
        settings = {
            {
                key = 'vehicleid',
                name = 'VEHICLE',
                desc = 'The vehicle.',
                icon = 'https://i.imgur.com/zgt3zea.png',
                type = 'combo',
                getOptions = function()
                    local options = {}

                    for _, data in pairs(RCD.AdvancedConfiguration["vehiclesList"] or {}) do
                        table.insert(options, {
                            text = data.name,
                            data = data.id
                        })
                    end
            
                    table.sort(options, function(a, b)
                        return a.text < b.text
                    end)
            
                    return options
                end,
                onChoose = function(index, text, data, fields)
                    local vehicle

                    for _, data2 in pairs(RCD.AdvancedConfiguration["vehiclesList"] or {}) do
                        if (data2.id == data) then
                            vehicle = data2
                            break
                        end
                    end

                    if (vehicle) then
            
                        fields.name.entry:SetValue(vehicle.name)
                        fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)

                        local vehData = list.Get('Vehicles')[vehicle.class]
                        if (vehData) then
                            local model = vehData.Model or 'models/error.mdl'
    
                            fields.icon.picker:ChooseOptionID(2)
                
                            fields.icon.entry:SetValue(model)
                            fields.icon.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
                        end
                    end
                end,
                validateOption = function(data)
                    -- do not be lazy to do this function, it is also used on the server side to validate value
                    if (not data) then return false, 'You must choose a vehicle!' end

                    if (SERVER) then
                        local items = RCD.GetVehicles() or {}
                        local found = false

                        for _, vehicle in pairs(items) do
                            if (vehicle.id == data) then
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

onyx.creditstore:RegisterIntegration('rcd', INTEGRATION)