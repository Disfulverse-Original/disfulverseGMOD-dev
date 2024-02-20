
local sDir = "materials/slawer/jobs/"
for k, v in pairs(file.Find(sDir .. "*.png", "GAME")) do
    resource.AddFile(sDir .. v)
end