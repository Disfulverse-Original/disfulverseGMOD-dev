--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

util.AddNetworkString('onyx.creditstore:OpenStore')
hook.Add('PlayerSay', 'onyx.creditstore.OpenStore', function(ply, text)
    local command = onyx.creditstore:GetOptionValue('command'):match('%w+')
    if (text == ('!' .. command) or text == ('/' .. command)) then
        net.Start('onyx.creditstore:OpenStore')
        net.Send(ply)
        return ''
    end
end)