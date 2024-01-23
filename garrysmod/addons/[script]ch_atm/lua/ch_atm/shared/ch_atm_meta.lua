local PMETA = FindMetaTable( "Player" )

--[[
	Simple meta function to check if players team is in the PoliceTeams table.
--]]
function PMETA:CH_ATM_IsPoliceJob()
	return CH_ATM.Config.PoliceTeams[ team.GetName( self:Team() ) ]
end

--[[
	Check if players team is allowed to rob an ATM
--]]
function PMETA:CH_ATM_CanRobATM()
	return CH_ATM.Config.CriminalTeams[ team.GetName( self:Team() ) ]
end