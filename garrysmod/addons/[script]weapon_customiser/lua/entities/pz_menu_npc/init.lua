--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/gman_high.mdl" )

	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )

	self:SetUseType( SIMPLE_USE )
end

util.AddNetworkString( "Project0.SendOpenCustomiserMenu" )
function ENT:Use( ply )
	if( (ply.PROJECT0_NPC_COOLDOWN or 0) > CurTime() ) then return end
	ply.PROJECT0_NPC_COOLDOWN = CurTime()+1

	net.Start( "Project0.SendOpenCustomiserMenu" )
	net.Send( ply )
end

function ENT:OnTakeDamage( dmgInfo )
	return 0
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
