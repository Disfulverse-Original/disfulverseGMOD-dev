--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

concommand.Add( "pz_save_ents", function( ply, cmd, args )
	if( not PROJECT0.FUNC.HasAdminAccess( ply ) ) then 
		PROJECT0.FUNC.SendNotification( ply, "ACCESS ERROR", "You don't have admin access!", "error" )
		return 
	end

	local entities = {}
	for k, v in pairs( PROJECT0.DEVCONFIG.EntityTypes ) do
		for key, ent in pairs( ents.FindByClass( k ) ) do
			local pos = string.Explode(" ", tostring(ent:GetPos()))
			local angles = string.Explode(" ", tostring(ent:GetAngles()))
			
			local entTable = {
				Class = k,
				TranformData = pos[1] .. ";" .. pos[2] .. ";" .. pos[3] .. ";" .. angles[1] .. ";" .. angles[2] .. ";" .. angles[3]
			}
			
			table.insert( entities, entTable )
		end
	end
	
	file.Write( "projectzero/saved_ents/".. string.lower( game.GetMap() ) ..".txt", util.TableToJSON( entities ), "DATA" )
	--PROJECT0.FUNC.SendNotification( ply, "ENTITY SAVING", "Entity postions successfully saved!", "admin" )
end )

concommand.Add( "pz_clear_ents", function( ply, cmd, args )
	if( not PROJECT0.FUNC.HasAdminAccess( ply ) ) then 
		PROJECT0.FUNC.SendNotification( ply, "ACCESS ERROR", "You don't have admin access!", "error" )
		return 
	end

	for k, v in pairs( ents.GetAll() ) do
		if( not PROJECT0.DEVCONFIG.EntityTypes[v:GetClass()] ) then continue end
		v:Remove()
	end

	if( file.Exists( "projectzero/saved_ents/".. string.lower( game.GetMap() ) ..".txt", "DATA" ) ) then
		file.Delete( "projectzero/saved_ents/".. string.lower( game.GetMap() ) ..".txt" )
	end
end )

local function SpawnSavedEntities()	
	if( not file.IsDir( "projectzero/saved_ents", "DATA" ) ) then
		file.CreateDir( "projectzero/saved_ents", "DATA" )
	end
	
	local entities = {}
	if( file.Exists( "projectzero/saved_ents/".. string.lower( game.GetMap() ) ..".txt", "DATA" ) ) then
		entities = util.JSONToTable( file.Read( "projectzero/saved_ents/".. string.lower( game.GetMap() ) ..".txt", "DATA" ) )
	end
	
	if( table.Count( entities ) > 0 ) then
		for k, v in pairs( entities ) do
			local devConfig = PROJECT0.DEVCONFIG.EntityTypes[v.Class]
			if( not devConfig ) then
				entities[k] = nil
				continue
			end

			local transformData = string.Explode( ";", v.TranformData )
			
			local ent = ents.Create( v.Class )
			ent:SetPos( Vector( transformData[1], transformData[2], transformData[3] ) )
			ent:SetAngles( Angle( transformData[4], transformData[5], transformData[6] ) )
			ent:Spawn()
		end
	end

	print( "[PROJECT0] " .. table.Count( entities ) .. " Entitie(s) Spawned" )
end

local function InitPostEnt()
	if( PROJECT0.CONFIG_LOADED ) then
		SpawnSavedEntities()
	else
		hook.Add( "Project0.Hooks.ConfigLoaded", "Project0.Hooks.ConfigLoaded.LoadEntities", SpawnSavedEntities )
	end
end

if( PROJECT0.INITPOSTENTITY_LOADED ) then
	InitPostEnt()
else
	hook.Add( "InitPostEntity", "Project0.InitPostEntity.LoadEntities", InitPostEnt )
end

hook.Add( "PostCleanupMap", "Project0.PostCleanupMap.LoadEntities", SpawnSavedEntities )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
