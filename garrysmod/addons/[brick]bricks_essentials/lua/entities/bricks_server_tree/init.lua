AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetModel( table.Random( table.GetKeys( BRICKS_SERVER.DEVCONFIG.TreeModels ) ) or "" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion( false )
	end

	self.treeType = table.Random( table.GetKeys( BRICKS_SERVER.CONFIG.CRAFTING.TreeTypes ) )

	if( BRICKS_SERVER.CONFIG.CRAFTING.TreeTypes[self.treeType or ""] ) then
		self:SetResource( self.treeType or "" )

		if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[self.treeType] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[self.treeType][2] ) then
			self:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[self.treeType][2] )
		end
	end

	self:SetFarmableHealth( 100 )
end

function ENT:AcceptInput(ply, caller)

end

function ENT:HitTree( damage, attacker )
	if( (damage or 0) <= 0 ) then return end

	self:SetFarmableHealth( self:GetFarmableHealth()-damage )

	BRICKS_SERVER.Func.SendResourceHit( attacker, self:GetPos()+Vector( 0, 0, 50 ), damage )

	if( self:GetFarmableHealth() > 0 ) then return end


	local ChosenResource = ""
	local ResourcePercent = math.Rand(0, 100)
	local CurPercent = 0
	for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.TreeTypes ) do
		if( ResourcePercent > CurPercent and ResourcePercent < CurPercent+v ) then
			ChosenResource = k
			break
		end
		CurPercent = CurPercent+v
	end

	if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[ChosenResource] ) then
		if( not BRICKS_SERVER.CONFIG.CRAFTING["Add Resources Directly To Inventory"] ) then
			local resourceEnt = ents.Create( "bricks_server_resource_" .. string.Replace( string.lower( ChosenResource ), " ", "" ) )
			if( IsValid( resourceEnt ) ) then
				resourceEnt:SetPos( self:GetPos()+Vector( 0, 0, 50 ) )
				resourceEnt:Spawn()
			end
		elseif( IsValid( attacker ) and attacker:IsPlayer() ) then

			local itemData = { "bricks_server_resource", (BRICKS_SERVER.CONFIG.CRAFTING.Resources[ChosenResource][1] or ""), ChosenResource }
            attacker:BRS():AddInventoryItem( itemData, 1 )

			local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( itemData[1], "GetInfo" )( itemData )				
			DarkRP.notify( attacker, 1, 5, "Вы получили x1 " .. itemInfo[1] .. " из этого дерева!" )
		end

		if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) and IsValid( attacker ) and attacker:IsPlayer() ) then
			attacker:AddExperience( (BRICKS_SERVER.CONFIG.LEVELING["EXP Gained - Tree Chopped"] or 0), "Forestry" )
    		attacker:SL_AddExperience( Sublime.Config.BricksRockTreeGarbageEXP, "за выполненную работу.")				
		end
	end

	self:Remove()
end