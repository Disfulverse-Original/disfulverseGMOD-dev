--[[

Author: tochnonement
Email: tochnonement@gmail.com


23/04/2023

--]]

function onyx.creditstore.FormatMoney(number)
    local str = ' '
    local replace = str == nil and "%1,%2" or "%1" .. str .. "%2"

    if ( isnumber( number ) ) then
        number = string.format( "%f", number )
        number = string.match( number, "^(.-)%.?0*$" ) -- Remove trailing zeros
    end

    local index = -1
    while index ~= 0 do number, index = string.gsub( number, "^(-?%d+)(%d%d%d)", replace ) end

    return number
end

onyx.creditstore:RegisterOption('website_url', {
    title = 'Website URL',
    desc = 'URL to deposit credits',
    category = 'General',
    cami = 'onyx_creditstore_edit',
    type = 'string',
    default = 'https://gmodstore.com/'
})

onyx.creditstore:RegisterOption('website_ingame', {
    title = 'Browser',
    desc = 'Use in-game browser to open website URL',
    category = 'General',
    cami = 'onyx_creditstore_edit',
    type = 'bool',
    default = true
})

onyx.creditstore:RegisterOption('command', {
    title = 'Command',
    desc = 'The command to open store',
    category = 'General',
    cami = 'onyx_creditstore_edit',
    type = 'string',
    default = 'store'
})

onyx.creditstore:RegisterOption('npc_model', {
    title = 'NPC Model',
    desc = 'The model path',
    category = 'General',
    cami = 'onyx_creditstore_edit',
    type = 'model',
    default = 'models/gman_high.mdl'
})

onyx.creditstore:RegisterOption('npc_label', {
    title = 'NPC Label',
    desc = 'The label above head',
    category = 'General',
    cami = 'onyx_creditstore_edit',
    type = 'string',
    default = 'CREDIT STORE'
})