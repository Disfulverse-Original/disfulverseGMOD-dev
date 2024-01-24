--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/05/2023

--]]

local creditstore = onyx.creditstore

creditstore:RegisterOption('salary_enabled', {
    title = 'Enabled',
    desc = 'Enable salary module',
    category = 'Salary',
    cami = 'onyx_creditstore_edit',
    type = 'bool',
    default = false
})

creditstore:RegisterOption('salary_rate', {
    title = 'Interval',
    desc = 'The interval in minutes between salaries',
    category = 'Salary',
    cami = 'onyx_creditstore_edit',
    type = 'int',
    default = 30,
    min = 1,
    max = 180
})

creditstore:RegisterOption('salary_amount', {
    title = 'Amount',
    desc = 'The amount of credits to give',
    category = 'Salary',
    cami = 'onyx_creditstore_edit',
    type = 'int',
    default = 5,
    min = 1,
    max = 300
})