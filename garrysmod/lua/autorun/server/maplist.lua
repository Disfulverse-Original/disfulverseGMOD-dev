local mapIDs = mapIDs or {}
local curMap = game.GetMap()
 
mapIDs["rp_southside"] = 2010286798
 
if not mapIDs[curMap] == nil then
 resource.AddWorkshop(mapIDs[map])
end
 
