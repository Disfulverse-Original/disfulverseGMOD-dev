
local meta = FindMetaTable( "Player" )

CreateConVar( "revival_enabled", 1, FCVAR_ARCHIVE ) --Is it enabled?
CreateConVar( "revival_ammopercent", 50, FCVAR_ARCHIVE ) --How much ammo should the player keep after death in whole number percentage?
CreateConVar( "revival_revivemintime", 5, FCVAR_ARCHIVE ) --What's the shortest time in seconds between revivals?
CreateConVar( "revival_revivemaxtime", 45, FCVAR_ARCHIVE ) --What's the longest time in seconds between revivals?


--Revives the player if there isn't anything in the way
function meta:revive()
	if ( self:Alive() or not IsValid( self.RevivalRagdoll ) or self.CannotBeRevived ) then return end
	
	if ( self.LastReviveTime and ( CurTime() - self.LastDeathTime ) > GetConVar( "revival_revivemaxtime" ):GetInt() ) then
		return false 
	end
	
	--Do a trace to check if the player should be able to spawn
	local tr = util.TraceHull( {
		start = self.RevivalRagdoll:GetPos(),
		endpos = self.RevivalRagdoll:GetPos(),
		filter = self.RevivalRagdoll,
		mins = Vector( 0, 0, 0 ),
		maxs = self:OBBMaxs(),
		mask = MASK_SHOT
	} )
	
	--If they should be able to spawn where their body is,
	if not tr.Hit then
		
		--Revive them
		self.BeingRevived = true
		self:Spawn()
		pos = self.RevivalRagdoll:GetPos()
		self:SetPos( pos + Vector( 0, 0, 1 ) )
		self:SetEyeAngles( self.ReviveAng )
		self:SetVelocity( self.RevivalRagdoll:GetPhysicsObject():GetVelocity() )
		
		--This is used elsewhere to not let them be revived if they were revived recently
		self.LastReviveTime = CurTime()
		return true
		
	else
	
		return false
		
	end
end

--Removes the player's ragdoll when they spawn
hook.Add( "PlayerSpawn", "RevivalPlayerSpawn", function( ply )
	if IsValid( ply.RevivalRagdoll ) then
	
		--Remove the player's ragdoll
		ply.RevivalRagdoll:Remove()
		
		--And set them to be revivable
		ply.CannotBeRevived = nil
		
	end
end)


hook.Add("DoPlayerDeath", "RevivalDeathInfo", function(ply, attacker, dmginfo)
    if not GetConVar("revival_enabled"):GetBool() then return end

	ply.LastDeathTime = CurTime()
	
	--The weapon the player is holding when they die
	if IsValid( ply:GetActiveWeapon() ) then
		ply.ReviveActiveWeapon = ply:GetActiveWeapon():GetClass()
	end
	
	--The weapons the player has when they die
	ply.ReviveWeapons = {}
	for k, v in pairs( ply:GetWeapons() ) do
		table.insert( ply.ReviveWeapons, v:GetClass() )
	end
	
	--The player's position when they die
	ply.RevivePos = ply:GetPos()
	
	--The player's eye angles when they die
	ply.ReviveAng = ply:EyeAngles()
	
	--The player's ammo before they die adjusted to make death a loss
	ply.RevivalPreviousAmmo = {}
	for k, v in pairs( ply:GetWeapons() ) do
		--Get primary and secondary ammo types
		local primary = v:GetPrimaryAmmoType()
		local secondary = v:GetSecondaryAmmoType()
		
		--Get the adjusted ammo amounts based on the ammotypes
		local newPrimary = math.floor( ply:GetAmmoCount( primary ) * ( GetConVar( "revival_ammopercent" ):GetInt() / 100 ) )
		local newSecondary = math.floor( ply:GetAmmoCount( secondary ) * ( GetConVar( "revival_ammopercent" ):GetInt() / 100 ) )
		
		--Save the new ammocounts
		ply.RevivalPreviousAmmo[primary] = newPrimary
		ply.RevivalPreviousAmmo[secondary] = newSecondary
	end
	

    -- Create custom serverside ragdoll
    local rag = ents.Create("prop_ragdoll")
    rag:SetPos(ply:GetPos())
    rag:SetModel(ply:GetModel())
    rag:SetAngles(ply:GetAngles())
    rag:SetColor(ply:GetColor())
    rag.BodyOf = ply
    rag:Spawn()
    rag:Activate()
    rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

    -- Position the bones
    local num = rag:GetPhysicsObjectCount() - 1
    local v = ply:GetVelocity()

    for I = 0, num do
        local bone = rag:GetPhysicsObjectNum(I)
        if IsValid(bone) then
            local bp, ba = ply:GetBonePosition(rag:TranslatePhysBoneToBone(I))
            if bp and ba then
                bone:SetPos(bp)
                bone:SetAngles(ba)
            end

            -- Not sure if this will work:
            bone:SetVelocity(v)
        end
    end

	ply.RevivalRagdoll = rag

	ply:Spectate( OBS_MODE_IN_EYE )
	ply:SpectateEntity( ply.RevivalRagdoll )


	
	if ( ply.LastReviveTime and ( ( CurTime() - ply.LastReviveTime ) <= GetConVar( "revival_revivemintime" ):GetInt() ) ) then
		ply.CannotBeRevived = true
	end


end)

--Handles giving players health, ammo, and weapons when they are revived
hook.Add( "PlayerLoadout", "RevivalLoadout", function( ply )
	if ( not ply.BeingRevived or not IsValid( ply ) ) then return end
	
	ply.BeingRevived = nil
	ply:StripAmmo()
	ply:SetHealth( 10 )
	
	--Give the player back their weapons
	for k, v in pairs( ply.ReviveWeapons ) do
		ply:Give( v )
	end
	
	--Select the weapon they had out
	--ply:SelectWeapon( ply.ReviveActiveWeapon )
	
	--Give the player back their ammo
	for k, v in pairs( ply.RevivalPreviousAmmo ) do
		ply:GiveAmmo( v, k, true )
	end
	
	return true
end)


if CLIENT then

	--Handles hiding the clientside corpse.  It's gross, but here we are.
	hook.Add( "OnEntityCreated", "RevivalClientRagdollRemove", function( ent )
		if not GetConVar( "revival_enabled" ):GetBool() then return end
		
		if ent:GetClass() == "class C_HL2MPRagdoll" then
			ent:SetNoDraw( true )
		end
	end)

end
