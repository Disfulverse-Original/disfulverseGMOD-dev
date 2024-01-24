--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

onyx:Addon('creditstore', {
    color = Color(245, 245, 245),
    author = 'tochnonement',
    version = '1.2.1',
})

----------------------------------------------------------------

if (CLIENT) then
    --onyx.wimg.Register('creditstore_currency', 'https://i.imgur.com/tqerDQ1.png')
    onyx.wimg.Register('creditstore_truecurrency3', 'https://i.imgur.com/fiZMuge.png')
    --LocalPlayer():ChatPrint(creditstore_truecurrency3)
end

onyx.Include('sv_sql.lua')
onyx.IncludeFolder('onyx/modules/creditstore/languages/')
onyx.IncludeFolder('onyx/modules/creditstore/core/', true)
onyx.IncludeFolder('onyx/modules/creditstore/cfg/', true)
onyx.IncludeFolder('onyx/modules/creditstore/ui/')

onyx.creditstore:Print('Finished loading.')