AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString("NC_OpenNCMenu")
function ENT:Initialize()
	self:SetModel(NC.NPCModel)
	self:SetMoveType(MOVETYPE_NONE)
    self:SetHullType( HULL_HUMAN ) 
	self:SetHullSizeNormal()
	self:SetNPCState( 0	)
	self:SetSolid( SOLID_BBOX ) 
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )
end

function ENT:AcceptInput(name, activator, caller, data)
	if caller:IsPlayer() and caller:IsValid() then
		net.Start("NC_OpenNCMenu")
			net.WriteEntity(caller)
		net.Send(caller)
	end
end

function ENT:OnTakeDamage()
	return
end 

hook.Add( "PostGamemodeLoaded", "WriteNameChangeFiles", function()
	if !file.IsDir( "namenpc", "DATA" ) then
		file.CreateDir( "namenpc", "DATA" )
		MsgN( "[NC] Created namenpc!" )
	end
	if !file.IsDir( "namenpc/"..string.lower(game.GetMap()).."", "DATA" ) then
		file.CreateDir( "namenpc/"..string.lower(game.GetMap()).."", "DATA" )
		MsgN( "[NC] Created namenpc/"..string.lower(game.GetMap()).."!" )
	end
	if !file.Exists( "namenpc/"..string.lower(game.GetMap()).."/npc.txt", "DATA" ) then
		file.Write( "namenpc/"..string.lower(game.GetMap()).."/npc.txt", "", "DATA")
		MsgN( "[NC] Created npc.txt!" )
	end
	
end)

hook.Add( "InitPostEntity", "Spawn NameChange NPCs", function()
	if file.Exists( "namenpc/"..string.lower(game.GetMap()).."/npc.txt", "DATA" ) then
		local FILE = file.Read("namenpc/"..string.lower(game.GetMap()).."/npc.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE) or {}
		for k, v in pairs( TABLE ) do 
			local pos = v.pos
			local ang = v.ang
			local spawn_npc = ents.Create( "namechange" )
			spawn_npc:SetPos( pos )
			spawn_npc:SetAngles( ang )
			spawn_npc:SetMoveType( MOVETYPE_NONE )
			spawn_npc:Spawn()
		end
		MsgN( "[NC] Read Files and Spawned NPC's!" )
	end
end)

concommand.Add( "save_namenpc", function( ply )
	if file.Exists( "namenpc/"..string.lower(game.GetMap()).."/npc.txt", "DATA" ) then
		RunConsoleCommand( "remove_namenpc" )
	end
	timer.Simple( 2, function()
		local NPCLocation = {}
		for k, v in pairs( ents.FindByClass( "namechange" ) ) do
			if IsValid( v ) then
				table.insert( NPCLocation, {pos = v:GetPos(), ang = v:GetAngles() } )
			end
		end
		file.Write( "namenpc/"..string.lower(game.GetMap()).."/npc.txt", util.TableToJSON(NPCLocation))
		ply:ChatPrint( "[NC] Name Change NPC Positions Set!" )
	end)
end)

concommand.Add( "remove_namenpc", function( ply )
	if file.Exists( "namenpc/"..string.lower(game.GetMap()).."/npc.txt", "DATA" ) then
		file.Delete( "namenpc/"..string.lower(game.GetMap()).."/npc.txt" )
	end
end)








 