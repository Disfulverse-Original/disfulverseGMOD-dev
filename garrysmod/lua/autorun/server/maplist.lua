local mapIDs = mapIDs or {}
local curMap = game.GetMap()
 
mapIDs["rp_downtown_triton_disfulverse_v2"] = 3155462760
 
if not mapIDs[curMap] == nil then
 resource.AddWorkshop(mapIDs[map])
end
 
