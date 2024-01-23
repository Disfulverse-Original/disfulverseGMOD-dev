--[[Enhanced Cocaine Laboratory 1.2]]
--[[Leaked by High Leaker          ]]
--[[Enjoy !                        ]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if (ECL.CustomModels.Cocaine) then
		self:SetModel("models/srcocainelab/cocainebrick.mdl")
	else
		self:SetModel("models/props_debris/concrete_chunk04a.mdl");
		self:SetColor(Color(255,255,255,255));
		self:SetMaterial("models/debug/debugwhite");
	end;
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	local phys = self:GetPhysicsObject();
	phys:Wake();
	self.damage = 100;
	if !self.reward then 
		local reward = ECL.Cocaine.Reward;
		if type(reward) == "number" then
			self.reward = reward;
			self:SetNWInt("price", reward);
		elseif type(reward) == "table" then
			local random = math.random(reward[1], reward[2]);
			self.reward = random;
			self:SetNWInt("price", random);
		end
	else
		self:SetNWInt("price", self.reward);
	end
	self:SetNWInt("distance", ECL.Draw.Distance);
	self:SetNWBool("aiming", ECL.Draw.AimingOnEntity);
	self:SetNWBool("fadein", ECL.Draw.FadeInOnComingCloser);
	self:SetNWBool("using", ECL.Cocaine.HideInPocketOnUse);
end

function ENT:Use(ply)
	if self:GetNWInt("using") then
		if ply.ECL then
			if ply.ECL.CocaineAmount < ECL.Cocaine.MaxAmountInPocket then
				local amount = ply.ECL.CocaineAmount;
				local price = ply.ECL.CocainePrice;

				ply.ECL.CocainePrice = price + self:GetNWInt("price");
				ply.ECL.CocaineAmount = amount + 1;
				self:Effect();
			end;
		else
			ply.ECL = {}
			ply.ECL.CocainePrice = self:GetNWInt("price");
			ply.ECL.CocaineAmount = 1;
			self:Effect()
		end;
	end;
end;

function ENT:Effect()
	local effectData = EffectData();
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:EmitSound("items/battery_pickup.wav", 75, 100, 0.25);
	self:Remove();
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
