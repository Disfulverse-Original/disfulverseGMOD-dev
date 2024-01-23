AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	
		phys:Wake()
		
	end
		
end

function ENT:Use( a, c )

	if c:CM_HasForbiddenJob() then
		c:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
		return 
	end

	net.Start("ClothesMod:ClothesArmory")
		net.WriteEntity(self)
	net.Send(c)
end

function ENT:Touch( ent )

	if self.LastTouch and self.LastTouch + 1 > CurTime() then return end
	self.LastTouch = CurTime()

	if ent:GetClass() == "cm_cloth" then
		
		local ply = ent:GetPlayerOwner()
		local plyInfos = ply:CM_GetInfos()

		if ent.Type == 1.1 then

			local infos =  CM_GetTextureInfos( ent.id )
			ply:CM_AddTop( infos, true )
			
		elseif ent.Type == 1.2 then
			
			local data
			if plyInfos.sex == 1 then
				data = CLOTHESMOD.Male
			else
				data = CLOTHESMOD.Female
			end

			local infos = data.ListTops[ent:GetCName()]
			ply:CM_AddTop( infos, false )
			
		elseif ent.Type == 2 then

			local data
			if plyInfos.sex == 1 then
				data = CLOTHESMOD.Male
			else
				data = CLOTHESMOD.Female
			end

			local infos = data.ListBottoms[ent:GetCName()]
			ply:CM_AddBottom( infos )
			
		else
			return	
		end

		ply:CM_SavePlayerInfos()
		ply:CM_NetworkTableInfos()

		ent:Remove()

	end

end