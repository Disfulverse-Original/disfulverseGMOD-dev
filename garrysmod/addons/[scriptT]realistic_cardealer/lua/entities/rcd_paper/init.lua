AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	self:SetModel("models/dimitri/kobralost/paper.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local rcdPhys = self:GetPhysicsObject()
	if not IsValid(rcdPhys) then return end
	
	rcdPhys:EnableMotion(false)
	rcdPhys:Wake()
end

function ENT:Use(activator)
	net.Start("RCD:Main:Job")
		net.WriteUInt(4, 4)
		net.WriteEntity(self)
		net.WriteUInt(self.RCDInfo["vehicleId"], 32)
		net.WriteUInt(self.RCDInfo["vehicleParams"]["vehicleCommission"], 32)
		net.WriteEntity(self.RCDInfo["seller"])
		net.WriteColor(self.RCDInfo["vehicleParams"]["vehicleColor"])
		net.WriteColor(self.RCDInfo["vehicleParams"]["vehicleUnderglow"])
		net.WriteUInt(self.RCDInfo["vehicleParams"]["vehicleSkin"], 8)
		net.WriteString(self.RCDInfo["vehicleParams"]["carDealer"])
	net.Send(activator)
end