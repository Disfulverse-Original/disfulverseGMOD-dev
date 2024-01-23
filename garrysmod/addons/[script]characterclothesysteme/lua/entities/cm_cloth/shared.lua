ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Clothes"
ENT.Category = "Clothes Mod"
ENT.Author = "Venatuss"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "CName")
    self:NetworkVar("Entity", 0, "PlayerOwner")
	if SERVER then
		self:SetCName("Loading...")
		self:SetPlayerOwner("Loading...")
	end
end
