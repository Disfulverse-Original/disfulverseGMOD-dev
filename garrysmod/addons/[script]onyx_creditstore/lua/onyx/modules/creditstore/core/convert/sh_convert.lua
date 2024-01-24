--[[

Author: tochnonement
Email: tochnonement@gmail.com


02/05/2023

--]]

local creditstore = onyx.creditstore

creditstore:RegisterOption('converter_enabled', {
    title = 'Enabled',
    desc = '(DarkRP) Enable converter module',
    category = 'Converter',
    cami = 'onyx_creditstore_edit',
    type = 'bool',
    default = false
})

creditstore:RegisterOption('converter_rate', {
    title = 'Rate',
    desc = 'The price of 1 credit',
    category = 'Converter',
    cami = 'onyx_creditstore_edit',
    type = 'int',
    default = 100,
    min = 1
})

creditstore:RegisterOption('converter_mode', {
    title = 'Mode',
    desc = 'The mode.',
    category = 'Converter',
    cami = 'onyx_creditstore_edit',
    type = 'int',
    default = 3,
    min = 1,
    max = 3,
    combo = {
        {'Credits → Money', 1},
        {'Money → Credits', 2},
        {'Both', 3}
    }
})

function creditstore:CalculateConvertResult(bToCredits, amount)
    local rate = self:GetOptionValue('converter_rate')
    local result = bToCredits and math.floor(amount / rate) or math.floor(amount * rate)

    return result
end