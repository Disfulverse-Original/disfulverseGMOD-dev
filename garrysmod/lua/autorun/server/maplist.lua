local mapIDs = mapIDs or {}
local curMap = game.GetMap()
 
mapIDs["rp_downtown_modern"] = 2986120857
 
if not mapIDs[curMap] == nil then
 resource.AddWorkshop(mapIDs[map])
end
 
