--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	self:SetModel( Realistic_Properties.ModelOfTheBox )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local RealisticPropertiesPhys = self:GetPhysicsObject()
	RealisticPropertiesPhys:EnableMotion(true)
	RealisticPropertiesPhys:EnableGravity(true)
	RealisticPropertiesPhys:Wake()
end

function ENT:Use(activator) 
	activator.countdownEnt = activator.countdownEnt or CurTime()
    if activator.countdownEnt > CurTime() then return end
    activator.countdownEnt = CurTime() + 1.5
	if not istable(self.Table) then return end 

	net.Start("RealisticProperties:DeliveryEnt")
	net.WriteEntity(self)
	net.WriteString(self.Table["RealisticPropertiesEntModel"])
	net.Send(activator) 
	activator.SelectedEntRPS = self 
	Realistic_Properties:Notify(activator, 46) 
	self:SetBodygroup(1, 1)
	timer.Simple(0.1, function()
		if IsValid(self) && isentity(self) then 
			self:ResetSequence("ouverture")
			self:SetSequence("ouverture")
		end 
	end )
end 
