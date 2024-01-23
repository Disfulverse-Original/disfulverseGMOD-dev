AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/dimitri/kobralost/stand.mdl")
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
		net.WriteUInt(2, 4)
		net.WriteEntity(self)
	net.Send(activator)
end