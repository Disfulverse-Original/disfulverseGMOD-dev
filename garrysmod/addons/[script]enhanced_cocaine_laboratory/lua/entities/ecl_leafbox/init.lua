--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box004a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = 100
	self.CanUse = false
	self:SetNWInt("leafs", 0)
	self:SetNWInt("max_amount", ECL.Box.MaxAmount)
	self:SetNWInt("distance", ECL.Draw.Distance);
	self:SetNWBool("aiming", ECL.Draw.AimingOnEntity);
	self:SetNWBool("fadein", ECL.Draw.FadeInOnComingCloser);
	if self:Getowning_ent() then
		self:CPPISetOwner(self:Getowning_ent())
	end
end

function ENT:PlaySound()
	self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
end;

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self:Remove()
	end
end