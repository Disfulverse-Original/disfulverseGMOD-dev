if SAM_LOADED then return end

sam.command.set_category('Onyx Store')

sam.command.new('givecredits')
:SetPermission('givecredits', 'superadmin')
:Help('Give credits to a player.')
:AddArg('player', {
    single_target = true,
    allow_higher_target = true
})
:AddArg('number', {
    hint = 'credits',
    round = true
})
:OnExecute(function(caller, targets, number)
    local target = targets[1]

    if (target:onyx_GetNetVar('store_busy')) then
        caller:sam_send_message('({S Red}) {T} is handling operation, try again later!', {S = 'Error', T = targets})
        return
    end

    onyx.creditstore:AddCredits(target, number)

    sam.player.send_message(nil, '{A} gave {T} {V} credits.', {
        A = caller,
        T = targets,
        V = number
    })
end):End()

sam.command.new('takecredits')
:SetPermission('takecredits', 'superadmin')
:Help('Take credits from a player.')
:AddArg('player', {
    single_target = true,
    allow_higher_target = true
})
:AddArg('number', {
    hint = 'credits',
    round = true
})
:OnExecute(function(caller, targets, number)
    local target = targets[1]

    if (target:onyx_GetNetVar('store_busy')) then
        caller:sam_send_message('({S Red}) {T} is handling operation, try again later!', {S = 'Error', T = targets})
        return
    end

    onyx.creditstore:TakeCredits(target, number)

    sam.player.send_message(nil, '{A} removed {V} credits from {T}.', {
        A = caller,
        T = targets,
        V = number
    })
end):End()

sam.command.new('setcredits')
:SetPermission('setcredits', 'superadmin')
:Help('Set credits to a player')
:AddArg('player', {
    single_target = true,
    allow_higher_target = true
})
:AddArg('number', {
    hint = 'credits',
    round = true
})
:OnExecute(function(caller, targets, number)
    local target = targets[1]

    if (target:onyx_GetNetVar('store_busy')) then
        caller:sam_send_message('({S Red}) {T} is handling operation, try again later!', {S = 'Error', T = targets})
        return
    end

    onyx.creditstore:SetCredits(target, number)

    sam.player.send_message(nil, '{A} set {T} credits to {V}.', {
        A = caller,
        T = targets,
        V = number
    })
end):End()