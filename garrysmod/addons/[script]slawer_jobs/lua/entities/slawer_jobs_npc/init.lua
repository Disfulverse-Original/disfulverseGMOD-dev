AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	
	self:SetMaxYawSpeed(90)
end

function ENT:AcceptInput(strName, _, pPlayer)
	if pPlayer:IsPlayer() and strName == "Use" then
		if pPlayer:GetEyeTrace().Entity ~= self then return end

		Slawer.Jobs:NetStart("OpenNPC", {sName = self.sName, tJobs = self.tJobs}, pPlayer)
	end
end