--[[

Author: tochnonement
Email: tochnonement@gmail.com

01/05/2023

--]]

local blocked = {
    ['bot'] = true,
    ['lua_run'] = true,
    ['lua_run_sv'] = true,
    ['rcon'] = true,
    ['sv_password'] = true,
}

onyx.creditstore:RegisterType('runconsolecommand', {
    name = 'Console Command',
    color = Color(119, 119, 119),
    options = {
        ['use'] = {
            removeItem = true,
            func = function(ply, data)
                local command = data.command:gsub('{steamid64}', ply:SteamID64())
                local args = string.Explode(' ', command)
                
                RunConsoleCommand(unpack(args))
            end
        }
    },
    settings = {
        {
            key = 'command',
            name = 'COMMAND',
            desc = 'The command to execute to the console.',
            icon = 'https://i.imgur.com/zgt3zea.png',
            type = 'string',
            validateOption = function(data)
                -- do not be lazy to do this function, it is also used on the server side to validate value
                if (not isstring(data) or data == '') then return false, 'You must fill the command field!' end

                local args = string.Explode(' ', data)
                local cmd = args[1]

                if (blocked[cmd]) then
                    return false, 'This command is blocked: \"' .. cmd .. '\"'
                end

                return true
            end
        }
    }
})