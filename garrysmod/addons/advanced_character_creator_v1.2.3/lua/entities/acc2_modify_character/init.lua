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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

function ENT:Initialize()
	self:SetModel(ACC2.GetSetting("npcModificationModel", "string"))
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

	local characterId = ACC2.GetNWVariables("characterId", activator)
	if characterId == nil then
		activator:ACC2Notification(5, ACC2.GetSentence("errorWithCharacter"))
		return 
	end

	activator.ACC2["canInteractWithMenu"] = true

	activator:ACC2OpenCharacterModificationMenu()
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
