--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

TOOL.Category = "Project0"
TOOL.Name = "Menu NPC Placer"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.Admin = true

function TOOL:LeftClick( trace )
	local ply = self:GetOwner()
	if( not PROJECT0.FUNC.HasAdminAccess( ply ) and CLIENT ) then
		PROJECT0.FUNC.CreateNotification( "ACCESS ERROR", "You don't have permission to use this tool!", "error" )
		return
	end
	
	if( !trace.HitPos or IsValid( trace.Entity ) ) then return false end
	if( CLIENT ) then return true end

	local ent = ents.Create( "pz_menu_npc" )
	ent:SetPos( trace.HitPos )
	ent:SetAngles( Angle( 0, ply:GetAngles().y+180, 0 ) )
	ent:Spawn()
	
	PROJECT0.FUNC.SendNotification( ply, "NPC TOOL", "Menu NPC successfully placed.", "admin" )
	ply:ConCommand( "pz_save_ents" )
end
 
if( SERVER ) then
	util.AddNetworkString( "Project0.RequestRemoveNPC" )
	net.Receive( "Project0.RequestRemoveNPC", function( len, ply )
		if( not PROJECT0.FUNC.HasAdminAccess( ply ) ) then return end
	
		local traceEntity = ply:GetEyeTrace().Entity
		if( not IsValid( traceEntity ) or traceEntity:GetClass() != "pz_menu_npc" ) then return end
	
		traceEntity:Remove()
		PROJECT0.FUNC.SendNotification( ply, "NPC TOOL", "Menu NPC successfully removed.", "admin" )
		ply:ConCommand( "pz_save_ents" )
	end )
end

if( not CLIENT ) then return end

function TOOL:Think()
	if( CurTime() < (self.lastRightClick or 0)+0.5 or not input.IsMouseDown( MOUSE_RIGHT ) ) then return end

	local traceEntity = (LocalPlayer():GetEyeTrace() or {}).Entity
	if( not IsValid( traceEntity ) or traceEntity:GetClass() != "pz_menu_npc" ) then return end

	self.lastRightClick = CurTime()

	net.Start( "Project0.RequestRemoveNPC" )
	net.SendToServer()
end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Header", { Text = "Menu NPC", Description = "Used to place menu NPCs from the Project0 Framework." } )
end

language.Add( "tool.botched_menu_npcs.name", "Menu NPC Placer" )
language.Add( "tool.botched_menu_npcs.desc", "Used to place menu NPCs." )
language.Add( "tool.botched_menu_npcs.0", "Left click to place NPC. Right click to remove NPC." )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
