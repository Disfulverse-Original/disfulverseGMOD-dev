--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

local INTEGRATION = {}

INTEGRATION.Name = 'DarkRP'
INTEGRATION.Color = Color(73, 184, 63)
INTEGRATION.Desc = 'The DarkRP gamemode'

function INTEGRATION:Check()
    return DarkRP ~= nil
end

function INTEGRATION:Load()
    self:CreateMoneyType()
    self:CreateJobType()
end

function INTEGRATION:CreateMoneyType()
    onyx.creditstore:RegisterType('darkrp_money', {
        name = 'Money',
        color = Color(97, 212, 82),
        stacking = true,
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
                    local amount = tonumber(data.amount)
                    if (amount and amount > 0) then
                        ply:addMoney(amount)
                        return true
                    end
                end
            }
        },
        settings = {
            {
                key = 'amount',
                name = 'AMOUNT',
                desc = 'The amount of money to give.',
                icon = 'https://i.imgur.com/zgt3zea.png',
                type = 'number',
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
end

local function findJobByCommand(command)
    for i, job in pairs(RPExtraTeams) do
        if (job.command == command) then
            return job, i
        end
    end
end

function INTEGRATION:CreateJobType()
    local ITEMTYPE = {}
    ITEMTYPE.name = 'Job'
    ITEMTYPE.color = Color(82, 175, 212)
    ITEMTYPE.noDuplicates = true

    ITEMTYPE.equip = true
    ITEMTYPE.onEquip = function(ply, itemTableData)
        
    end
    ITEMTYPE.onUnequip = function(ply, itemTableData)
        
    end

    ITEMTYPE.settings = {
        {
            key = 'jobcommand',
            name = 'JOB',
            desc = 'The job linked to the item.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'combo',
            getOptions = function()
                local options = {}

                for _, job in pairs(RPExtraTeams) do
                    table.insert(options, {
                        text = job.name,
                        data = job.command
                    })
                end

                table.sort(options, function(a, b)
                    return a.text < b.text
                end)

                return options
            end,
            onChoose = function(index, text, data, fields)
                local job = findJobByCommand(data)
                if (job) then
                    local model = istable(job.model) and job.model[1] or job.model
                    fields.icon.picker:ChooseOptionID(2)

                    fields.icon.entry:SetValue(model)
                    fields.icon.entry:Highlight(onyx.GetOppositeAccentColor(), 3)

                    fields.name.entry:SetValue(job.name)
                    fields.name.entry:Highlight(onyx.GetOppositeAccentColor(), 3)
                end
            end,
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (not data) then return false, 'You must choose a job!' end
                if (not findJobByCommand(data)) then return false end

                return true
            end
        }
    }

    onyx.creditstore:RegisterType('darkrp_job', ITEMTYPE)

    if (SERVER) then
        hook.Add('playerCanChangeTeam', 'onyx.creditstore.whitelist', function(ply, teamIndex, force)
            if (force) then return end

            local teamData = RPExtraTeams[teamIndex]

            for id, itemTable in pairs(onyx.creditstore.items) do
                if (itemTable.type == 'darkrp_job' and itemTable.data.jobcommand == teamData.command) then
                    
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
                    local reason
    
                    if (not bCanUse and IsFirstTimePredicted()) then
                        if (hasItem) then
                            reason = 'The job is restricted, activate in !store inventory'
                        else
                            reason = 'The job is restricted, purchase access in !store'
                        end
                    end
    
                    if (not bCanUse) then
                        return bCanUse, reason
                    end

                end
            end
        end)
    end
end

onyx.creditstore:RegisterIntegration('darkrp', INTEGRATION)