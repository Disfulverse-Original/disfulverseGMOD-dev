--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.AutomaticFrameAdvance = true 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

function ENT:Initialize()
	self:SetModel(ACC2.GetSetting("npcMenuModel", "string"))
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator)
	local curTime = CurTime()

	activator.ACC2 = activator.ACC2 or {}
	
	activator.ACC2["antiSpam"] = activator.ACC2["antiSpam"] or 0
    if activator.ACC2["antiSpam"] > curTime then return end 
    activator.ACC2["antiSpam"] = curTime + 1

	activator.ACC2["canInteractWithMenu"] = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

	activator:ACC2OpenCharacterMenu(true)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
