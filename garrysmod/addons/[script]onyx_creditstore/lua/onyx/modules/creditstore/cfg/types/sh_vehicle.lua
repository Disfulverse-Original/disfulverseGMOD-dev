--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

onyx.creditstore:RegisterType('vehicle', {
    name = 'Vehicle',
    color = Color(31, 158, 126),
    noDuplicates = true,
    options = {
        ['spawn'] = {
            check = function(ply, data)
                if (not ply:Alive()) then
                    return false, onyx.lang:Get('youMustBeAlive')
                end

                if (IsValid(ply:GetVar('onyx_CreditstoreVehicle'))) then
                    return false, 'You already have spawned car'
                end

                return true
            end,
            func = function(ply, data)
                local vehicleID = data.vehiclescript
                local vehicleData = list.Get('Vehicles')[vehicleID]
                if (not vehicleData) then
                    return false
                end

                local pos = ply:GetPos() + Vector(0, 0, 100)
                local ang = ply:GetAngles()

                ang:RotateAroundAxis(ply:GetUp(), -90)

                local ent = ents.Create(vehicleData.Class)
                ent:SetModel(vehicleData.Model)
                ent:SetKeyValue('vehiclescript', vehicleData.KeyValues.vehiclescript)
                ent:SetPos(pos)
                ent:SetAngles(ang)
                ent:SetOwner(ply)
                ent:Spawn()

                if (IsValid(ent)) then
                    if (ent.CPPISetOwner) then
                        ent:CPPISetOwner(ply)
                    end

                    if (ent.keysOwn) then
                        ent:keysOwn(ply)
                    end

                    local eyeang = ply:EyeAngles()

                    eyeang:RotateAroundAxis(ply:GetUp(), -90)

                    ply:EnterVehicle(ent)
                    ply:SetVar('onyx_CreditstoreVehicle', ent)
                    ply:SetEyeAngles(eyeang)
                end
            end
        }
    },
    settings = {
        {
            key = 'vehiclescript',
            name = 'VEHICLE',
            desc = 'The vehicle linked to the item.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'combo',
            getOptions = function()
                local options = {}
        
                for id, data in pairs(list.Get('Vehicles')) do
                    local name = data.Name
                    local class = data.Class
                    if (class and class ~= 'prop_vehicle_prisoner_pod' and name) then
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
                local veh = list.Get('Vehicles')[data]
                if (veh) then
                    local model = veh.Model and (veh.Model ~= '' and veh.Model or 'models/error.mdl') or 'models/error.mdl'
                    fields.icon.picker:ChooseOptionID(2)
        
                    fields.icon.entry:SetValue(model)
                    fields.icon.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
        
                    fields.name.entry:SetValue(veh.Name)
                    fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
                end
            end,
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (not data) then return false, 'You must choose a vehicle!' end
                if (not list.Get('Vehicles')[data]) then return false end
        
                return true
            end
        }
    }
})