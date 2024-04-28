local CATEGORY_NAME = 'Onyx Store'

function ulx.giveonyxcredits(caller, target, num)
    if (target:onyx_GetNetVar('store_busy')) then
        ULib.tsayError(caller, target:Name() .. ' is handling operation, try again later!')
        return
    end

    onyx.creditstore:AddCredits(target, num)

    ulx.fancyLogAdmin(caller, true, '#A gave #T #s credits', target, num, name )
end

function ulx.setonyxcredits(caller, target, num)
    if (target:onyx_GetNetVar('store_busy')) then
        ULib.tsayError(caller, target:Name() .. ' is handling operation, try again later!')
        return
    end

    onyx.creditstore:SetCredits(target, num)

    ulx.fancyLogAdmin(caller, true, '#A set #T credits to #s', target, num)
end

function ulx.takeonyxcredits(caller, target, num)
    if (target:onyx_GetNetVar('store_busy')) then
        ULib.tsayError(caller, target:Name() .. ' is handling operation, try again later!')
        return
    end

    onyx.creditstore:TakeCredits(target, num)

    ulx.fancyLogAdmin(caller, '#A removed #s credits from #T', num, target )
end

--[[------------------------------
Declare
--------------------------------]]

local cmdGive = ulx.command(CATEGORY_NAME, 'ulx givecredits', ulx.giveonyxcredits, '!givecredits')
cmdGive:addParam{ type = ULib.cmds.PlayerArg }
cmdGive:addParam{ type = ULib.cmds.NumArg, hint = 'credits', min = 1 }
cmdGive:defaultAccess( ULib.ACCESS_SUPERADMIN  )
cmdGive:help('Give credits to a player.')

local cmdRemove = ulx.command(CATEGORY_NAME, 'ulx takecredits', ulx.takeonyxcredits, '!takecredits')
cmdRemove:addParam{ type = ULib.cmds.PlayerArg }
cmdRemove:addParam{ type = ULib.cmds.NumArg, hint = 'credits', min = 1 }
cmdRemove:defaultAccess( ULib.ACCESS_SUPERADMIN  )
cmdRemove:help('Take credits from a player.')

local cmdSet = ulx.command(CATEGORY_NAME, 'ulx setcredits', ulx.setonyxcredits, '!setcredits')
cmdSet:addParam{ type = ULib.cmds.PlayerArg }
cmdSet:addParam{ type = ULib.cmds.NumArg, hint = 'credits', min = 0 }
cmdSet:defaultAccess( ULib.ACCESS_SUPERADMIN  )
cmdSet:help('Set credits to a player')
