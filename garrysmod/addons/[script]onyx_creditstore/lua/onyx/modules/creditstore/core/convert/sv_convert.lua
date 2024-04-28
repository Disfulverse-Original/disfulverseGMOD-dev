--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/05/2023

--]]

local creditstore = onyx.creditstore

util.AddNetworkString('onyx.creditstore:Convert')

net.Receive('onyx.creditstore:Convert', function(len, ply)
    local giveAmount = net.ReadUInt(32)
    local bToCredits = net.ReadBool()

    if (ply:GetVar('onyx_CreditStoreNetDelay', 0) > CurTime()) then
        return
    end

    ply:SetVar('onyx_CreditStoreNetDelay', CurTime() + .66)

    -- print(giveAmount, ply, bToCredits)
    if (giveAmount <= 0) then return end
    
    if (DarkRP == nil) then return end
    if (not creditstore:GetOptionValue('converter_enabled')) then
        return
    end

    if (ply:onyx_GetNetVar('store_busy')) then
        return
    end

    local mode = creditstore:GetOptionValue('converter_mode')
    if (mode == 1 and bToCredits) then
        return
    elseif (mode == 2 and not bToCredits) then
        return
    end

    local receiveAmount = creditstore:CalculateConvertResult(bToCredits, giveAmount)
    if (receiveAmount <= 0) then return end
    -- print(receiveAmount)

    if (bToCredits) then
        local rate = creditstore:GetOptionValue('converter_rate')
        
        giveAmount = math.floor(receiveAmount * rate)

        if (ply:canAfford(giveAmount)) then
            ply:addMoney(-giveAmount)
            creditstore:AddCredits(ply, receiveAmount)

            onyx.NotifyLocalized(ply, 'youConverted', {
                A = DarkRP.formatMoney(giveAmount),
                B = (creditstore.FormatMoney(receiveAmount) .. ' credits')
            })

            hook.Run('onyx.creditstore.PlayerConvertedMoney', ply, giveAmount, receiveAmount)
        else
            onyx.NotifyLocalized(ply, 'cantAfford', {}, 1, 5)
        end
    else
        local credits = creditstore:GetCredits(ply)
        if (credits >= giveAmount) then
            creditstore:TakeCredits(ply, giveAmount, function()
                if (IsValid(ply)) then
                    ply:addMoney(receiveAmount)

                    onyx.NotifyLocalized(ply, 'youConverted', {
                        A = (creditstore.FormatMoney(receiveAmount) .. ' credits'),
                        B = DarkRP.formatMoney(giveAmount)
                    })
                end
            end)
            
            hook.Run('onyx.creditstore.PlayerConvertedCredits', ply, giveAmount, receiveAmount)
        else
            onyx.NotifyLocalized(ply, 'cantAfford', {}, 1, 5)
        end
    end

end)