AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

-- Cache frequently used values for performance
local ROCK_MODELS = {
	[1] = "models/2rek/brickwall/bwall_rock_1_phys_3.mdl", -- Full health
	[2] = "models/2rek/brickwall/bwall_rock_1_phys_2.mdl", -- Damaged
	[3] = "models/2rek/brickwall/bwall_rock_1_phys_1.mdl"  -- Depleted
}

local ROCK_MAX_HEALTH = 100
local ROCK_STAGE_2_THRESHOLD = 50
local ROCK_STAGE_3_THRESHOLD = 0
local RESOURCE_SPAWN_HEIGHT = 50
local PLAYER_PROXIMITY_CHECK = 50
local PHYSICS_VALIDATION_DISTANCE = 200

function ENT:Initialize()
	-- Set initial model and physics
	self:SetModel(ROCK_MODELS[1])
	self:SetupPhysics()
	
	-- Initialize rock properties
	self:InitializeRockData()
	
	-- Set initial health and stage
	self:SetRHealth(ROCK_MAX_HEALTH)
	self:SetStage(1)
end

-- Optimized physics setup with better error handling
function ENT:SetupPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	else
		ErrorNoHalt("[Brick's Server] ERROR: Failed to initialize physics for rock entity at " .. tostring(self:GetPos()))
	end
end

-- Initialize rock type data with validation
function ENT:InitializeRockData()
	local rockType = self.rockType or ""
	local rockTable = BRICKS_SERVER.CONFIG.CRAFTING.RockTypes[rockType]
	
	if rockTable then
		self:SetRockType(rockType)
	else
		-- Fallback to first available rock type if invalid
		for k, v in pairs(BRICKS_SERVER.CONFIG.CRAFTING.RockTypes or {}) do
			self:SetRockType(k)
			break
		end
	end
end

function ENT:AcceptInput(ply, caller)
	-- Reserved for future functionality
end

-- Optimized rock damage system
function ENT:HitRock(damage, attacker)
	-- Validate input parameters
	if not damage or damage <= 0 then 
		return 
	end
	
	if not IsValid(attacker) then
		return
	end
	
	-- Apply damage
	local newHealth = math.max(self:GetRHealth() - damage, 0)
	self:SetRHealth(newHealth)
	
	-- Handle stage transitions
	self:HandleStageTransition(attacker)
end

-- Cleaner stage transition logic
function ENT:HandleStageTransition(attacker)
	local currentHealth = self:GetRHealth()
	local currentStage = self:GetStage()
	
	-- Stage 1 -> Stage 2 (damaged)
	if currentStage == 1 and currentHealth <= ROCK_STAGE_2_THRESHOLD then
		self:TransitionToStage(2)
		
	-- Stage 2 -> Stage 3 (depleted)
	elseif currentStage == 2 and currentHealth <= ROCK_STAGE_3_THRESHOLD then
		self:TransitionToStage(3)
		self:HandleResourceDrop(attacker)
	end
end

-- Optimized stage transition with physics caching
function ENT:TransitionToStage(newStage)
	if not ROCK_MODELS[newStage] then
		ErrorNoHalt("[Brick's Server] ERROR: Invalid rock stage: " .. tostring(newStage))
		return
	end
	
	self:SetModel(ROCK_MODELS[newStage])
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	
	self:SetStage(newStage)
end

-- Optimized resource selection with better performance
function ENT:SelectRandomResource()
	local rockTypes = BRICKS_SERVER.CONFIG.CRAFTING.RockTypes
	if not rockTypes or table.IsEmpty(rockTypes) then
		return nil
	end
	
	-- Calculate total weight for more efficient selection
	local totalWeight = 0
	local weightedItems = {}
	
	for resourceType, weight in pairs(rockTypes) do
		totalWeight = totalWeight + weight
		table.insert(weightedItems, {
			type = resourceType,
			weight = weight,
			cumulativeWeight = totalWeight
		})
	end
	
	if totalWeight <= 0 then
		return nil
	end
	
	-- Select random resource based on weighted probability
	local randomValue = math.Rand(0, totalWeight)
	
	for _, item in ipairs(weightedItems) do
		if randomValue <= item.cumulativeWeight then
			return item.type
		end
	end
	
	-- Fallback to first item
	return weightedItems[1] and weightedItems[1].type
end

-- Cleaner resource drop handling
function ENT:HandleResourceDrop(attacker)
	local chosenResource = self:SelectRandomResource()
	
	if not chosenResource or not BRICKS_SERVER.CONFIG.CRAFTING.Resources[chosenResource] then
		return
	end
	
	-- Create item data once for reuse
	local resourceConfig = BRICKS_SERVER.CONFIG.CRAFTING.Resources[chosenResource]
	local itemData = {
		"bricks_server_resource",
		resourceConfig[1] or "",
		chosenResource
	}
	
	-- Determine if resources should go directly to inventory
	local addDirectly = BRICKS_SERVER.CONFIG.CRAFTING["Add Resources Directly To Inventory"]
	
	if addDirectly then
		self:AddResourceToPlayerInventory(attacker, itemData)
	else
		self:SpawnResourceEntity(attacker, itemData, chosenResource)
	end
	
	-- Award experience if leveling system is enabled
	self:AwardMiningExperience(attacker)
end

-- Optimized resource entity spawning with comprehensive validation
function ENT:SpawnResourceEntity(attacker, itemData, resourceType)
	local spawnPos = self:GetPos() + Vector(0, 0, RESOURCE_SPAWN_HEIGHT)
	
	-- Validate spawn position
	if not isvector(spawnPos) or spawnPos:IsZero() then
		self:AddResourceToPlayerInventory(attacker, itemData, "Invalid spawn position")
		return
	end
	
	-- Check for nearby players
	if self:HasNearbyPlayers(spawnPos, PLAYER_PROXIMITY_CHECK) then
		self:AddResourceToPlayerInventory(attacker, itemData, "Players nearby")
		return
	end
	
	-- Create and spawn resource entity
	local entityClass = "bricks_server_resource_" .. string.Replace(string.lower(resourceType), " ", "")
	local resourceEnt = ents.Create(entityClass)
	
	if not IsValid(resourceEnt) then
		self:AddResourceToPlayerInventory(attacker, itemData, "Failed to create entity")
		return
	end
	
	resourceEnt:SetPos(spawnPos)
	resourceEnt:Spawn()
	
	-- Validate entity after spawn with delay
	timer.Simple(0.1, function()
		self:ValidateSpawnedResource(resourceEnt, spawnPos, attacker, itemData)
	end)
end

-- Helper function to check for nearby players
function ENT:HasNearbyPlayers(position, radius)
	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and ply:GetPos():Distance(position) < radius then
			return true
		end
	end
	return false
end

-- Validate spawned resource entity
function ENT:ValidateSpawnedResource(resourceEnt, originalPos, attacker, itemData)
	if not IsValid(resourceEnt) then
		return
	end
	
	local currentPos = resourceEnt:GetPos()
	
	-- Check if entity ended up in invalid position
	if currentPos:IsZero() or currentPos:Distance(originalPos) > PHYSICS_VALIDATION_DISTANCE then
		resourceEnt:Remove()
		self:AddResourceToPlayerInventory(attacker, itemData, "Entity physics validation failed")
		return
	end
	
	-- Ensure proper physics state
	local phys = resourceEnt:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(Vector(0, 0, 0))
	end
end

-- Centralized function for adding resources to player inventory
function ENT:AddResourceToPlayerInventory(attacker, itemData, reason)
	if not IsValid(attacker) or not attacker:IsPlayer() then
		return
	end
	
	-- Add item to inventory
	attacker:BRS():AddInventoryItem(itemData, 1)
	
	-- Get item info for notification
	local success, itemInfo = pcall(function()
		return BRICKS_SERVER.Func.GetEntTypeField(itemData[1], "GetInfo")(itemData)
	end)
	
	if success and itemInfo and itemInfo[1] then
		local message = "Вы получили x1 " .. itemInfo[1] .. " из этого камня!"
		if reason then
			print("[Brick's Server] Resource added to inventory: " .. reason)
		end
		DarkRP.notify(attacker, 1, 5, message)
	else
		ErrorNoHalt("[Brick's Server] ERROR: Failed to get item info for resource")
	end
end

-- Award mining experience with validation
function ENT:AwardMiningExperience(attacker)
	if not IsValid(attacker) or not attacker:IsPlayer() then
		return
	end
	
	-- Check if leveling module is enabled
	if not BRICKS_SERVER.Func.IsSubModuleEnabled("essentials", "levelling") then
		return
	end
	
	-- Award standard experience
	local expGained = BRICKS_SERVER.CONFIG.LEVELING["EXP Gained - Rock Mined"] or 0
	if expGained > 0 then
		attacker:AddExperience(expGained, "Mining")
	end
	
	-- Award sublime levels experience if available
	if attacker.SL_AddExperience and Sublime and Sublime.Config and Sublime.Config.BricksRockTreeGarbageEXP then
		attacker:SL_AddExperience(Sublime.Config.BricksRockTreeGarbageEXP, "за выполненную работу.")
	end
end
