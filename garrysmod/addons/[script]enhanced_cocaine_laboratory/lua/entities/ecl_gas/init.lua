--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if (ECL.CustomModels.Gascan) then
		self:SetModel("models/srcocainelab/gascan.mdl");
	else
		self:SetModel("models/props_junk/propane_tank001a.mdl");
	end;
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	local phys = self:GetPhysicsObject();
	phys:Wake();
	self.damage = 100;
	self.nextTouch = 0;
	self:SetNWInt("gas", ECL.Gas.Amount);
	self:SetNWInt("max_gas", ECL.Gas.Amount);
	self:SetNWInt("distance", ECL.Draw.Distance);
	self:SetNWBool("aiming", ECL.Draw.AimingOnEntity);
	self:SetNWBool("fadein", ECL.Draw.FadeInOnComingCloser);
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

function ENT:Effect()
	local effectData = EffectData();
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
	self:Remove();
end

function ENT:Touch(hitEnt)
	local class = hitEnt:GetClass()

	if class == "ecl_stove" and self.nextTouch < CurTime() then
		if (ECL.CustomModels.Stove) then 
			if hitEnt:GetBodygroup(1) == 1 and hitEnt:GetNWInt("gas") <= 0 then 
				self:Remove();
				hitEnt:SetNWInt("gas", self:GetNWInt("gas"))
				hitEnt:SetBodygroup(2, 0);
			end;
		else
			local entGas = hitEnt:GetNWInt("gas");

			if entGas < ECL.Stove.MaxAmountOfGas then
				local localGas = self:GetNWInt("gas")
				local give = ECL.Stove.MaxAmountOfGas - entGas

				if localGas <= give then
					hitEnt:SetNWInt("gas", entGas+localGas)
					self:SetNWInt("gas", 0)
					self:Effect();
				else
					hitEnt:SetNWInt("gas", entGas + give)
					self:SetNWInt("gas", localGas - give)
				end
				self.nextTouch = self.nextTouch + 1;
			end;
		end;
	end;
end;

function ENT:OnRemove()
	if not IsValid(self) then return end
end
