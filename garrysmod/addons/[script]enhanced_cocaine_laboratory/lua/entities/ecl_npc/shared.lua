--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.Category = "Enh. Cocaine Laboratory"
ENT.PrintName = "Cocaine Dealer"
ENT.Author = "James"
ENT.Spawnable = ECL.SpawnableEntities
ENT.AutomaticFrameAdvance = true
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end