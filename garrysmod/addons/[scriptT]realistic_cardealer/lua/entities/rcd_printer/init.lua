AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/dimitri/kobralost/printer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSequence("idle")

	local rcdPhys = self:GetPhysicsObject()
	if not IsValid(rcdPhys) then return end

	rcdPhys:EnableMotion(false)
	rcdPhys:Wake()
end

function ENT:Use(activator)
	local curTime = CurTime()

	self.RCDSpam = self.RCDSpam or 0
	if self.RCDSpam > curTime then return end
	self.RCDSpam = curTime + 3
	
	activator.RCD = activator.RCD or {}
	activator.RCD["printerUsed"] = self

	local vehiclesTable = util.Compress(util.TableToJSON((activator.RCD["jobVehicles"] or {})))

	net.Start("RCD:Main:Job")
		net.WriteUInt(1, 4)
        net.WriteUInt(#vehiclesTable, 32)
        net.WriteData(vehiclesTable, #vehiclesTable)
	net.Send(activator)
end


