AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	--self:SetModel("models/props_c17/SuitCase001a.mdl")

    if self.PrintName and self.PrintName[1] then
    	self:SetModel(BRICKS_SERVER.CONFIG.CRAFTING.CraftTools[self.PrintName][1])
    end

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetAmount( 1 )

	timer.Create( "BRS_TIMER_CRAFTTOOL_" .. tostring( self ), (BRICKS_SERVER.BASECONFIG.CRAFTING["Resource Despawn Time"] or 300), 1, function()
		if( IsValid( self ) ) then
			self:Remove()
		end
	end )
end

function ENT:Use( ply )

end

function ENT:OnRemove()
	if( timer.Exists( "BRS_TIMER_CRAFTTOOL_" .. tostring( self ) ) ) then
		timer.Remove( "BRS_TIMER_CRAFTTOOL_" .. tostring( self ) )
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()

	return ent
end