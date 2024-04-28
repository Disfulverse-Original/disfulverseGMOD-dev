--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

AddCSLuaFile()

TOOL.Category = "Advanced Character Creator"
TOOL.Name = "Setup NPC"
TOOL.Author = "Kobralost"

if CLIENT then 
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}

	language.Add("tool.acc2_npc_config.name", ACC2.GetSentence("toolName"))
	language.Add("tool.acc2_npc_config.desc", ACC2.GetSentence("toolDesc"))
end

function TOOL.BuildCPanel(CPanel)
	if CLIENT then
		CPanel:AddControl("Header", {
			Text = "#tool.acc2_npc_config.name",
			Description = ""
		})
	end
end

local entitiesClass = {
	{
		["name"] = "creationNPC",
		["class"] = "acc2_menu",
		["model"] = "npcMenuModel",
	},
	{
		["name"] = "modifyNPC",
		["class"] = "acc2_modify_character",
		["model"] = "npcModificationModel",
	},
	{
		["name"] = "rpNameNPC",
		["class"] = "acc2_rpname",
		["model"] = "npcRPNameModel",
	},
}

function TOOL:LeftClick(trace)
	if SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if not ACC2.AdminRank[ply:GetUserGroup()] then return end

		ply.ACC2 = ply.ACC2 or {}

		local curTime = CurTime()

		ply.ACC2["toolSpam"] = ply.ACC2["toolSpam"] or 0
		if ply.ACC2["toolSpam"] > curTime then return end
		ply.ACC2["toolSpam"] = curTime + 0.5
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

		local trace = util.TraceLine({
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 300,
			filter = function(ent) if ent:GetClass() == "prop_physics" then return true end end
		})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

		local pos = trace.HitPos
		local angSet = Angle(0, ply:GetAimVector():Angle().Yaw - 180, 0)
		
		local toolId = ACC2.GetNWVariables("toolId", ply) or 1

		ACC2.CreateNPC(pos, angSet, entitiesClass[toolId]["class"])
	end
end

function TOOL:RightClick(trace)
	if SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if not ACC2.AdminRank[ply:GetUserGroup()] then return end

		local ent = trace.Entity
		local npcId = ent.ACC2NPCId
		if not isnumber(npcId) then return end

		ACC2.RemoveNPC(npcId, true)
	end
end 

function TOOL:CreateACC2Ent()
	if CLIENT then
		if not IsValid(self.ACC2Ent) then
			local toolId = ACC2.GetNWVariables("toolId", self:GetOwner()) or 1
			local model = ACC2.GetSetting(entitiesClass[toolId]["model"], "string")

 			self.ACC2Ent = ClientsideModel((model or "models/breen.mdl"), RENDERGROUP_OPAQUE)
			self.ACC2Ent:SetModel((model or "models/breen.mdl"))
			self.ACC2Ent:Spawn()
			self.ACC2Ent:Activate()	
			self.ACC2Ent:SetRenderMode(RENDERMODE_TRANSALPHA)
		end
	end 
end

function TOOL:Reload()
	if SERVER then
		local ply = self:GetOwner()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

		local toolId = ACC2.GetNWVariables("toolId", ply) or 1
		local newAmount = (toolId + 1)
		if newAmount >  3 then newAmount = 1 end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

		ACC2.SetNWVariable("toolId", newAmount, ply, true, nil, true)
	end
end

function TOOL:Think()
	if CLIENT then
		local ply = self:GetOwner()

		if not IsValid(ply) and not ply:IsPlayer() then return end
		if not ACC2.AdminRank[ply:GetUserGroup()] then return end

		local trace = util.TraceLine({
			start = LocalPlayer():EyePos(),
			endpos = LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 300,
			filter = function(ent) if ent:GetClass() == "prop_physics" then return true end end
		})

		local ent = LocalPlayer():GetEyeTrace().Entity
		local class = IsValid(ent) and ent:GetClass() or ""
		
		if class != "acc2_menu" && class != "acc2_modify_character" && class != "acc2_rpname" then
			if IsValid(self.ACC2Ent) then
				if not isvector(self.ACC2LerpPos) then self.ACC2LerpPos = ACC2.Constants["vectorOrigin"] end
				self.ACC2LerpPos = Lerp(RealFrameTime()*40, self.ACC2LerpPos, trace.HitPos)

				local angSet = Angle(0, LocalPlayer():GetAimVector():Angle().Yaw - 180, 0)
				
				self.ACC2Ent:SetPos(self.ACC2LerpPos)
				self.ACC2Ent:SetAngles(Angle(angSet, 0, 0))

				local toolId = ACC2.GetNWVariables("toolId", self:GetOwner()) or 1
				local model = ACC2.GetSetting(entitiesClass[toolId]["model"], "string")
	
				self.ACC2Ent:SetModel((model or "models/breen.mdl"))
			else 
				self:CreateACC2Ent() 
			end
		else
			if IsValid(self.ACC2Ent) then 
				self.ACC2Ent:Remove()
			end
		end

		language.Add("tool.acc2_npc_config.left", ACC2.GetSentence("toolLeft"))
		language.Add("tool.acc2_npc_config.right", ACC2.GetSentence("toolRight"))
		language.Add("tool.acc2_npc_config.reload", ACC2.GetSentence("toolReload"))
	end
end 

function TOOL:Holster()
	if CLIENT then
		local ply = self:GetOwner()

		if not IsValid(ply) and not ply:IsPlayer() then return end
		if not ACC2.AdminRank[ply:GetUserGroup()] then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
	
		if IsValid(self.ACC2Ent) then 
			self.ACC2Ent:Remove()
		end
	end
end

function TOOL:DrawToolScreen(w, h)
	draw.RoundedBox(0, 0, 0, w, h, ACC2.Colors["blackpurple255"])
	draw.RoundedBox(0, 0, h*0.95, w, h*0.05, ACC2.Colors["purple100"])
	
	local ply = self:GetOwner()
	local toolId = ACC2.GetNWVariables("toolId", ply) or 1

	draw.DrawText(ACC2.GetSentence("placeNPC"), "ACC2:Font:21", w/2, h*0.33, color_white, TEXT_ALIGN_CENTER)
	draw.DrawText(ACC2.GetSentence(entitiesClass[toolId]["name"]), "ACC2:Font:22", w/2, h*0.45, color_white, TEXT_ALIGN_CENTER)
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
