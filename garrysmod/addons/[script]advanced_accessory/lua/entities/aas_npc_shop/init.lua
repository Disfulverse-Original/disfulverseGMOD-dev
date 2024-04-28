/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773

function ENT:Initialize()
	self:SetModel(AAS.ItemNpcModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

function ENT:Use(activator) 
	activator.AASSpam = activator.AASSpam or CurTime()
    if activator.AASSpam > CurTime() then return end 
    activator.AASSpam = CurTime() + 1

	net.Start("AAS:Main")
		net.WriteUInt(2, 5)
	net.Send(activator)
end
