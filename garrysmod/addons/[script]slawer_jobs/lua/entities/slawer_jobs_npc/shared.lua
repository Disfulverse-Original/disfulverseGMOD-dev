ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.Spawnable = false

ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "NPCName")
end