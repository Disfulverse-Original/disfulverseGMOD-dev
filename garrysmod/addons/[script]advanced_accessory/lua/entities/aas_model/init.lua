/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.AutomaticFrameAdvance = true 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

function ENT:Initialize()
	self:SetModel(AAS.ModelChanger)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local AASPhys = self:GetPhysicsObject()
	if not IsValid(AASPhys) then return end 
	AASPhys:EnableMotion(false)
	AASPhys:Wake()
end

function ENT:Use(activator)
	if AAS.BlackListBodyGroup[team.GetName(activator:Team())] then activator:AASNotify(5, AAS.GetSentence("jobProblem")) return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

	activator.AASSpam = activator.AASSpam or CurTime()
    if activator.AASSpam > CurTime() then return end 
    activator.AASSpam = CurTime() + 1

	net.Start("AAS:Main")
		net.WriteUInt(5, 5)
	net.Send(activator)
end
