--[[

Author: tochnonement
Email: tochnonement@gmail.com


02/03/2023

--]]

netchunk.Register('onyx.creditstore:SyncItems')
netchunk.Register('onyx.creditstore:SyncCategories')

local creditstore = onyx.creditstore

creditstore.types = creditstore.types or {}

function creditstore:RegisterType(id, data)
    data.id = id
    self.types[id] = data
end
