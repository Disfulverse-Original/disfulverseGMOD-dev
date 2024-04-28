--[[
Currency ID: onyx_credits

Examples:
#1: cfg:setCurrency("onyx_credits")
#2: 
cfg:addCard("cod_bo3_survialist", {
	name = "Survialist",
	price = 500,
	src = "aAuAoV0",
    currency = "onyx_credits",
	category = "Call of Duty"
})
--]]

 -- lol xenin is good, it will work fine if the currency is default, otherwise it will return currency table as the first argument
local function fixArgs(...)
    local tbl = {...}

    if (istable(tbl[1])) then
        table.remove(tbl, 1)
    end
    
    return unpack(tbl)
end

XeninDS.Currencies:set("onyx_credits", {
    format = function(...)
        local money = fixArgs(...)
        return (onyx.creditstore.FormatMoney(money) .. ' credits')
    end,
    add = function(...)
        if (CLIENT) then return end

        local ply, amt = fixArgs(...)

        if (amt == 0) then return end
        if (amt < 0) then
            onyx.creditstore:TakeCredits(ply, math.abs(amt))
        else
            onyx.creditstore:AddCredits(ply, amt)
        end
    end,
    get = function(...)
        local ply = fixArgs(...)
        return onyx.creditstore:GetCredits(ply)
    end,
    canAfford = function(...)
        local ply, amount = fixArgs(...)

        local credits = onyx.creditstore:GetCredits(ply)
        local isBusy = ply:onyx_GetNetVar('store_busy')

        if (isBusy) then
            return false
        end
        
        return (credits >= amount)
    end
  })
  