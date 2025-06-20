TOOL.AddToMenu = false
TOOL.Category = "Construction"
TOOL.Name = "#tool.dynamite.name"

TOOL.ClientConVar[ "group" ] = 52
TOOL.ClientConVar[ "damage" ] = 200
TOOL.ClientConVar[ "delay" ] = 0
TOOL.ClientConVar[ "model" ] = "models/dav0r/tnt/tnt.mdl"
TOOL.ClientConVar[ "remove" ] = 0

TOOL.Information = { { name = "left" } }

cleanup.Register( "dynamite" )

local function IsValidDynamiteModel( model )
	for mdl, _ in pairs( list.Get( "DynamiteModels" ) ) do
		if ( mdl:lower() == model:lower() ) then return true end
	end
	return false
end

function TOOL:LeftClick( trace )

	if ( !trace.HitPos || IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end

	local ply = self:GetOwner()

	-- Get client's CVars
	local group = self:GetClientNumber( "group" )
	local delay = self:GetClientNumber( "delay" )
	local damage = self:GetClientNumber( "damage" )
	local model = self:GetClientInfo( "model" )
	local remove = self:GetClientNumber( "remove" ) == 1

	-- If we shot a dynamite, change it's settings
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_dynamite" && trace.Entity:GetPlayer() == ply ) then

		trace.Entity:SetDamage( damage )
		trace.Entity:SetShouldRemove( remove )
		trace.Entity:SetDelay( delay )

		numpad.Remove( trace.Entity.NumDown )
		trace.Entity.key = group
		trace.Entity.NumDown = numpad.OnDown( ply, group, "DynamiteBlow", trace.Entity )

		return true
	end

	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) || !IsValidDynamiteModel( model ) ) then return false end
	if ( !self:GetSWEP():CheckLimit( "dynamite" ) ) then return false end

	local dynamite = MakeDynamite( ply, trace.HitPos, angle_zero, group, damage, model, remove, delay )
	if ( !IsValid( dynamite ) ) then return false end

	local CurPos = dynamite:GetPos()
	local Offset = CurPos - dynamite:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )

	dynamite:SetPos( trace.HitPos + Offset )

	undo.Create( "Dynamite" )
		undo.AddEntity( dynamite )
		undo.SetPlayer( ply )
	undo.Finish()

	return true

end

if ( SERVER ) then

	function MakeDynamite( ply, pos, ang, key, damage, model, remove, delay, Data )

		if ( IsValid( ply ) && !ply:CheckLimit( "dynamite" ) ) then return nil end
		if ( !IsValidDynamiteModel( model ) ) then return nil end

		local dynamite = ents.Create( "gmod_dynamite" )

		duplicator.DoGeneric( dynamite, Data )
		dynamite:SetPos( pos ) -- Backwards compatible for addons directly calling this function
		dynamite:SetAngles( ang )
		dynamite:SetModel( model )

		dynamite:SetShouldRemove( remove )
		dynamite:SetDamage( damage )
		dynamite:SetDelay( delay )
		dynamite:Spawn()

		DoPropSpawnedEffect( dynamite )
		duplicator.DoGenericPhysics( dynamite, ply, Data )

		if ( IsValid( ply ) ) then
			dynamite:SetPlayer( ply )
		end

		table.Merge( dynamite:GetTable(), {
			key = key,
			pl = ply,
			Damage = damage,
			model = model,
			remove = remove,
			delay = delay
		} )

		dynamite.NumDown = numpad.OnDown( ply, key, "DynamiteBlow", dynamite )

		if ( IsValid( ply ) ) then
			ply:AddCount( "dynamite", dynamite )
			ply:AddCleanup( "dynamite", dynamite )
		end

		return dynamite

	end
	duplicator.RegisterEntityClass( "gmod_dynamite", MakeDynamite, "Pos", "Ang", "key", "Damage", "model", "remove", "delay", "Data" )

	numpad.Register( "DynamiteBlow", function( ply, dynamite )

		if ( !IsValid( dynamite ) ) then return end

		dynamite:Explode( nil, ply )

	end )

end

function TOOL:UpdateGhostDynamite( ent, ply )

	if ( !IsValid( ent ) ) then return end

	local trace = ply:GetEyeTrace()
	if ( !trace.Hit || IsValid( trace.Entity ) && ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_dynamite" ) ) then
		ent:SetNoDraw( true )
		return
	end

	ent:SetAngles( angle_zero )

	local CurPos = ent:GetPos()
	local Offset = CurPos - ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )

	ent:SetPos( trace.HitPos + Offset )

	ent:SetNoDraw( false )

end

function TOOL:Think()

	local mdl = self:GetClientInfo( "model" )
	if ( !IsValidDynamiteModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != mdl ) then
		self:MakeGhostEntity( mdl, vector_origin, angle_zero )
	end

	self:UpdateGhostDynamite( self.GhostEntity, self:GetOwner() )

end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.dynamite.help" } )

	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "dynamite", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.dynamite.explode", Command = "dynamite_group" } )
	CPanel:AddControl( "Slider", { Label = "#tool.dynamite.damage", Command = "dynamite_damage", Type = "Float", Min = 0, Max = 500, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.dynamite.delay", Command = "dynamite_delay", Type = "Float", Min = 0, Max = 10, Help = true } )
	CPanel:AddControl( "CheckBox", { Label = "#tool.dynamite.remove", Command = "dynamite_remove" } )

	CPanel:AddControl( "PropSelect", { Label = "#tool.dynamite.model", ConVar = "dynamite_model", Height = 0, Models = list.Get( "DynamiteModels" ) } )

end

list.Set( "DynamiteModels", "models/dav0r/tnt/tnt.mdl", {} )
list.Set( "DynamiteModels", "models/dav0r/tnt/tnttimed.mdl", {} )
list.Set( "DynamiteModels", "models/dynamite/dynamite.mdl", {} )
