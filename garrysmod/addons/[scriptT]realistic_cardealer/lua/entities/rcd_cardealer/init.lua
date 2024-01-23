AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
	local curTime = CurTime()

	activator.RCD["spamNpc"] = activator.RCD["spamNpc"] or 0
    if activator.RCD["spamNpc"] > curTime then return end 
    activator.RCD["spamNpc"] = curTime + 1
	
	activator:RCDOpenCarDealer(self)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end