concommand.Add( "bricks_server_saveentpositions", function( ply, cmd, args )
	if( BRICKS_SERVER.Func.HasAdminAccess( ply ) ) then
		local Entities = {}
		for k, v in pairs( BRICKS_SERVER.DEVCONFIG.EntityTypes ) do
			for key, ent in pairs( ents.FindByClass( k ) ) do
				local EntVector = string.Explode(" ", tostring(ent:GetPos()))
				local EntAngles = string.Explode(" ", tostring(ent:GetAngles()))
				
				local EntTable = {
					Class = k,
					Position = ""..(EntVector[1])..";"..(EntVector[2])..";"..(EntVector[3])..";"..(EntAngles[1])..";"..(EntAngles[2])..";"..(EntAngles[3])..""
				}

				if( istable( v ) and v.GetDataFunc ) then
					EntTable.Data = v.GetDataFunc( ent )
				end
				
				table.insert( Entities, EntTable )
			end
		end
		
		file.Write("bricks_server/saved_ents/".. string.lower(game.GetMap()) ..".txt", util.TableToJSON( Entities ), "DATA")
		BRICKS_SERVER.Func.SendNotification( ply, 1, 2, BRICKS_SERVER.Func.L( "entityPosUpdated" ) )
	else
		BRICKS_SERVER.Func.SendNotification( ply, 1, 2, BRICKS_SERVER.Func.L( "cmdNoPermission" ) )
	end
end )

concommand.Add( "bricks_server_clearentpositions", function( ply, cmd, args )
	if( BRICKS_SERVER.Func.HasAdminAccess( ply ) ) then
		for k, v in pairs( ents.GetAll() ) do
			if( BRICKS_SERVER.DEVCONFIG.EntityTypes[v:GetClass()] ) then
				v:Remove()
			end
			
			if( file.Exists( "bricks_server/saved_ents/".. string.lower(game.GetMap()) ..".txt", "DATA" ) ) then
				file.Delete( "bricks_server/saved_ents/".. string.lower(game.GetMap()) ..".txt" )
			end
		end
	else
		BRICKS_SERVER.Func.SendNotification( ply, 1, 2, BRICKS_SERVER.Func.L( "cmdNoPermission" ) )
	end
end )

local function SpawnSavedEntities()	
	BRICKS_SERVER.ENTITIES_SPAWNED = true

	if not file.IsDir("bricks_server/saved_ents", "DATA") then
		file.CreateDir("bricks_server/saved_ents", "DATA")
	end
	
	local Entities = {}
	if( file.Exists( "bricks_server/saved_ents/".. string.lower(game.GetMap()) ..".txt", "DATA" ) ) then
		Entities = ( util.JSONToTable( file.Read( "bricks_server/saved_ents/".. string.lower(game.GetMap()) ..".txt", "DATA" ) ) )
	end
	
	if( table.Count( Entities ) > 0 ) then
		for k, v in pairs( Entities ) do
			local devConfig = BRICKS_SERVER.DEVCONFIG.EntityTypes[v.Class]
			if( devConfig ) then
				local ThePosition = string.Explode( ";", v.Position )
				
				local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
				local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
				
				-- BUG FIX: Validate position data before spawning entities
				if not isvector(TheVector) or not isangle(TheAngle) then
					print("[Brick's Server] WARNING: Invalid position data for entity " .. (v.Class or "unknown") .. ", skipping")
					continue
				end
				
				-- BUG FIX: Check if position is at world origin (invalid)
				if TheVector:IsZero() then
					print("[Brick's Server] WARNING: Entity " .. (v.Class or "unknown") .. " has zero position, skipping")
					continue
				end
				
				-- BUG FIX: Check for nearby players before spawning entities
				local nearbyPlayers = {}
				for _, ply in pairs(player.GetAll()) do
					if IsValid(ply) and ply:GetPos():Distance(TheVector) < 150 then
						table.insert(nearbyPlayers, ply)
					end
				end
				
				-- BUG FIX: If players are nearby, delay spawning or move position
				if #nearbyPlayers > 0 then
					-- Try to find a safe position nearby
					local safePos = nil
					for i = 1, 8 do
						local angle = (i - 1) * 45
						local offset = Vector(math.cos(math.rad(angle)) * 200, math.sin(math.rad(angle)) * 200, 0)
						local testPos = TheVector + offset
						
						local nearbyToTest = false
						for _, ply in pairs(player.GetAll()) do
							if IsValid(ply) and ply:GetPos():Distance(testPos) < 100 then
								nearbyToTest = true
								break
							end
						end
						
						if not nearbyToTest then
							safePos = testPos
							break
						end
					end
					
					if safePos then
						TheVector = safePos
						print("[Brick's Server] Entity " .. (v.Class or "unknown") .. " moved to safe position due to nearby players")
					else
						-- Delay spawning by 5-15 seconds if no safe position found
						local delayTime = math.random(5, 15)
						timer.Simple(delayTime, function()
							-- Check again for players after delay
							local stillNearby = false
							for _, ply in pairs(player.GetAll()) do
								if IsValid(ply) and ply:GetPos():Distance(TheVector) < 150 then
									stillNearby = true
									break
								end
							end
							
							if not stillNearby then
								local DelayedEnt = ents.Create( v.Class )
								if IsValid(DelayedEnt) then
									DelayedEnt:SetPos(TheVector)
									DelayedEnt:SetAngles(TheAngle)
									DelayedEnt:Spawn()
									if( istable( devConfig ) and devConfig.SetDataFunc ) then
										devConfig.SetDataFunc( DelayedEnt, v.Data )
									end
									print("[Brick's Server] Delayed entity " .. (v.Class or "unknown") .. " spawned after players moved away")
								end
							else
								print("[Brick's Server] WARNING: Cannot spawn entity " .. (v.Class or "unknown") .. " - players still nearby after delay")
							end
						end)
						continue
					end
				end
				
				local NewEnt = ents.Create( v.Class )
				if IsValid(NewEnt) then
					NewEnt:SetPos(TheVector)
					NewEnt:SetAngles(TheAngle)
					NewEnt:Spawn()
					if( istable( devConfig ) and devConfig.SetDataFunc ) then
						devConfig.SetDataFunc( NewEnt, v.Data )
					end
				else
					print("[Brick's Server] WARNING: Failed to create entity " .. (v.Class or "unknown"))
				end
			else
				Entities[k] = nil
			end
		end
		
		print( "[Brick's Server] " .. BRICKS_SERVER.Func.L( "xEntitiesSpawned", table.Count( Entities ) ) )
	else
		print( "[Brick's Server] " .. BRICKS_SERVER.Func.L( "noEntitiesSpawned" ) )
	end
end

local function initPostEnt()
	if( BRICKS_SERVER.CONFIG_LOADED ) then
		SpawnSavedEntities()
	else
		hook.Add( "BRS.Hooks.ConfigLoad", "BRS.BRS_ConfigLoad.LoadEntities", SpawnSavedEntities )
	end
end

if( BRICKS_SERVER.INITPOSTENTITY_LOADED ) then
	initPostEnt()
else
	hook.Add( "InitPostEntity", "BRS.InitPostEntity.LoadEntities", initPostEnt )
end

hook.Add( "PostCleanupMap", "BRS.PostCleanupMap.LoadEntities", SpawnSavedEntities )

timer.Simple( 30, function()
	if( BRICKS_SERVER.ENTITIES_SPAWNED ) then return end
	SpawnSavedEntities()
end )