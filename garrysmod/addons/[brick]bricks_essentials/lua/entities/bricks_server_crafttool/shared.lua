ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Craft Tool Base"
ENT.Category		= "DISFULVERSE / Tools"
ENT.Author			= "snvlpkinq"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable		= true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Amount" )
end