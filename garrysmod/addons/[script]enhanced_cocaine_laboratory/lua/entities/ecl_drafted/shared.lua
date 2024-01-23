--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Enh. Cocaine Laboratory"
ENT.PrintName = "Drafted Leaves"
ENT.Author = "James"
ENT.Spawnable = ECL.SpawnableEntities

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end