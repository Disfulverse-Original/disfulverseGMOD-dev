--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

local creditstore = onyx.creditstore

creditstore.items = creditstore.items or {}
creditstore.categories = creditstore.categories or {}

netchunk.Callback('onyx.creditstore:SyncItems', function(data, length, chunkAmount)
    creditstore.items = data

    hook.Run('onyx.credistore.ItemsSynced')

    creditstore:Print('Synchronized items (length: #, chunks: #)', length, chunkAmount)
end)

netchunk.Callback('onyx.creditstore:SyncCategories', function(data, length, chunkAmount)
    creditstore.categories = data

    hook.Run('onyx.credistore.CategoriesSynced')

    creditstore:Print('Synchronized categories (length: #, chunks: #)', length, chunkAmount)
end)