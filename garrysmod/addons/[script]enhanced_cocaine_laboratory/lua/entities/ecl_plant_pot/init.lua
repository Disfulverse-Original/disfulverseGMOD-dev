--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	local model = "models/props_junk/terracotta01.mdl";
	self:SetModel(model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(true)
	phys:Wake()
	self.damage = 100
	self.collect = true
	self.touchable = true
	self:SetNWBool("seeded", false)
	self:SetNWInt("distance", ECL.Draw.Distance);
	self:SetNWBool("aiming", ECL.Draw.AimingOnEntity);
	self:SetNWBool("fadein", ECL.Draw.FadeInOnComingCloser);
	if self:Getowning_ent() then
		self:CPPISetOwner(self:Getowning_ent())
	end
end

function ENT:Touch(entity)
	local class = entity:GetClass();
	local leafs = self:GetNWInt("leafs");

	if class == "ecl_seed" and self.touchable then
		self.touchable = false;
		entity:Remove()
		self:SetNWBool("seeded", true)
			
		self.time = CurTime() + ECL.Plant.GrowingTimer
		self:SetNWInt("timer", self.time)
	end;


end;

function ENT:Think()
	if self.time and self.time < CurTime() then
		local plant = ents.Create("ecl_plant");
		plant:SetPos(self:GetPos()+Vector(0,0,10))
		plant:Spawn()
		if (ECL.CustomModels.Plant) then
			plant:SetModel("models/srcocainelab/cocaplant.mdl")
		else
			plant:SetModel("models/props/de_inferno/potted_plant"..math.random(1,3)..".mdl")
		end;
		local phys = plant:GetPhysicsObject()
		phys:EnableMotion(true)
		phys:Wake()
		if self:Getowning_ent() then
			plant:Setowning_ent(self:Getowning_ent())
			plant:CPPISetOwner(self:Getowning_ent())
		end
		

		self:Remove()
	end;
end;

function ENT:PlaySound()
	local grass = "player/footsteps/grass"..math.random(1,4)..".wav";
	self:EmitSound(grass, 75, 100, math.Rand(0.65, 1), CHAN_AUTO)
end;

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self:Remove()
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
