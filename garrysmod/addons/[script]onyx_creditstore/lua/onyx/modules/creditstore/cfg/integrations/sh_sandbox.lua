--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

local INTEGRATION = {}

INTEGRATION.Name = 'Sandbox'
INTEGRATION.Color = Color(184, 162, 63)
INTEGRATION.Desc = 'The Sandbox essentials'

function INTEGRATION:Check()
    return true
end

function INTEGRATION:Load()
    onyx.creditstore:RegisterType('sandbox_tool', {
        name = 'Tool',
        color = Color(150, 134, 46),
        equip = true,
        defaultIcon = 'https://files.facepunch.com/rust/item/toolgun_512.png',
        noDuplicates = true,
        settings = {
            {
                key = 'tool',
                name = 'TOOL',
                desc = 'The tool.',
                icon = 'https://i.imgur.com/zgt3zea.png',
                type = 'combo',
                getOptions = function()
                    local options = {}
            
                    local tool = weapons.Get('gmod_tool')
                    if (not tool) then return {} end -- oopsie

                    local tools = tool.Tool

                    for id, data in pairs(tools) do
                        if (data.Name and data.LeftClick and data.AddToMenu ~= false) then
                            local category = data.Category or 'Other'
                            local printName = language.GetPhrase(data.Name)
                            local name = category and (category .. ' | ' .. printName) or printName
                
                            table.insert(options, {
                                text = name,
                                data = id
                            })
                        end
                    end
            
                    table.sort(options, function(a, b)
                        return a.text < b.text
                    end)
            
                    return options
                end,
                validateOption = function(data)
                    -- do not be lazy to do this function, it is also used on the server side to validate value
                    if (not data) then return false, 'You must choose a tool!' end

                    local tool = weapons.Get('gmod_tool')
                    if (not tool) then return end -- oopsie

                    local tools = tool.Tool
                    if (not tools[data]) then return false end
            
                    return true
                end
            }
        }
    })

    hook.Add('CanTool', 'onyx.creditstore', function(ply, tr, toolName)
        for id, itemTable in pairs(onyx.creditstore.items) do
            if (itemTable.type == 'sandbox_tool' and itemTable.data.tool == toolName) then
                
                local inventory = onyx.creditstore:GetPlayerInventory(ply)
                local hasItem = false
                local itemActivated = false

                for _, it in ipairs(inventory) do
                    if (it.id == id) then
                        hasItem = true
                        itemActivated = it.data and it.data.equipped
                        break
                    end
                end

                
                local bCanUse = hasItem and itemActivated or false

                if (CLIENT and not bCanUse and IsFirstTimePredicted()) then
                    if (hasItem) then
                        notification.AddLegacy('The tool is restricted, activate in !store inventory', 1, 5)
                    else
                        notification.AddLegacy('The tool is restricted, purchase access in !store', 1, 5)
                    end
                end

                return bCanUse
            end
        end
    end)
end

onyx.creditstore:RegisterIntegration('sandbox', INTEGRATION)