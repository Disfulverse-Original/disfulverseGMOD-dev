--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(ECL.Seed.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = 100
	self:SetNWInt("distance", ECL.Draw.Distance);
	self:SetNWBool("aiming", ECL.Draw.AimingOnEntity);
	self:SetNWBool("fadein", ECL.Draw.FadeInOnComingCloser);
	self.time = CurTime() + ECL.Seed.RemovingTime;
	if self:Getowning_ent() then
		self:CPPISetOwner(self:Getowning_ent())
	end
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self:Remove()
	end
end


function ENT:OnRemove()
	if not IsValid(self) then return end
end

function ENT:Think()
	if self.time < CurTime() then
		self:Remove()
	end
end
