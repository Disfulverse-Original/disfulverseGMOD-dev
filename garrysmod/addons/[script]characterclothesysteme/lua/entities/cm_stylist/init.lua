AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self:SetModel( "models/humans/group01/male_05.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	-- self:DropToFloor()
	self.nextClick = CurTime() + 1
	self:SetMaxYawSpeed( 90 )
	
end

function ENT:AcceptInput( event, a, p )

	if( event == "Use" && p:IsPlayer() && self.nextClick < CurTime() )  then
	
		self.nextClick = CurTime() + 2
	
		if p:CM_HasForbiddenJob() then
			p:CM_Notif(CLOTHESMOD.Config.Sentences[36][CLOTHESMOD.Config.Lang])
		return end
		
		net.Start("ClothesMod:ClothesCreation")
			net.WriteEntity( self )
		net.Send( p )
		
	end
	
end