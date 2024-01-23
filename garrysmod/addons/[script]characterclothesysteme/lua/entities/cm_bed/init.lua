AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/medicmod/hospital_bed/hospital_bed.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	-- self:DropToFloor()
	-- self:SetPos(Vector(0,0,150)+self:GetPos())
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	
		phys:Wake()
		
	end
	
	CLOTHESMOD.Beds = CLOTHESMOD.Beds or {}
	CLOTHESMOD.Beds[self] = true
	self.Free = true
	
end