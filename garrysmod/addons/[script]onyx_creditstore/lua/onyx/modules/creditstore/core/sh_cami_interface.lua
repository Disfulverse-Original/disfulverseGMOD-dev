--[[

Author: tochnonement
Email: tochnonement@gmail.com

03/05/2023

--]]

CAMI.RegisterPrivilege({
    Name = 'onyx_creditstore_edit',
    MinAccess = 'superadmin',
    Description = 'Allows to EDIT items, categories, settings'
})

CAMI.RegisterPrivilege({
    Name = 'onyx_creditstore_give_items',
    MinAccess = 'superadmin',
    Description = 'Allows to GIVE items from other players\' inventories'
})

CAMI.RegisterPrivilege({
    Name = 'onyx_creditstore_take_items',
    MinAccess = 'superadmin',
    Description = 'Allows to TAKE items from other players\' inventories'
})

CAMI.RegisterPrivilege({
    Name = 'onyx_creditstore_see_inventory',
    MinAccess = 'admin',
    Description = 'Allows to SEE other players\' inventories'
})