ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Blueprint Base"
ENT.Category		= "Bricks Server"
ENT.Author			= "Brick Wall"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable		= true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Amount" )
	self:NetworkVar( "Int", 0, "UseAmount" )
	self:NetworkVar( "Int", 0, "MaxAmount" )
	self:NetworkVar( "String", 0, "BlueprintKey" )
end