function BRICKS_SERVER.Func.HasResources( inventory, resources )
	local hasResources = true
	
	local resourceCount = {}
	for k, v in pairs( inventory ) do
		if( v[2] and v[2][1] and v[2][1] == "bricks_server_resource" and resources[v[2][3]] ) then
			resourceCount[v[2][3]] = (resourceCount[v[2][3]] or 0)+v[1]
		end
	end

	for k, v in pairs( resources ) do
		if( not resourceCount[k] or resourceCount[k] < v ) then
			hasResources = false
			break
		end
	end

	return hasResources
end

function BRICKS_SERVER.Func.HasTools(inventory, tools)
    local hasTools = true
    --PrintTable(inventory)
    --PrintTable(tools)
    -- Track the count of each tool found in the inventory
    local toolsFound = {}

    for _, item in pairs(inventory) do
        if item[2][1] == "bricks_server_crafttool" and tools[item[2][3]] then
            local toolName = item[2][3]

            toolsFound[toolName] = true
            --PrintTable(toolsFound)
           -- print("true")
        else
        	--print("false")
        end
    end

    -- Check if all required tools are present and in sufficient quantity
    for k, v in pairs(tools) do
        -- Check if the required tool is found in toolsFound and is true
        if not toolsFound[k] then
        	--print(tools)
            hasTools = false
            break
        end
    end

    return hasTools
end

function BRICKS_SERVER.Func.HasBlueprint(inventory, blueprint)
    local hasBlueprint = true
    --PrintTable(inventory)
    --PrintTable(blueprint)
    -- Track the count of each tool found in the inventory
    local blueprintFound = {}

    for _, item in pairs(inventory) do

        if item[2][1] == "bricks_server_blueprint" and blueprint[item[2][4]] then
            local blueprintName = item[2][4]
            local blueprintUseAmount = item[2][6]

            --print(blueprint[blueprintName])

            blueprintFound[blueprintName] = true

            --print("true")
        else
        	--print("false")
        end
    end

    -- Check if all required tools are present and in sufficient quantity
    for k, v in pairs(blueprint) do
        -- Check if the required tool is found in toolsFound and is true
        if not blueprintFound[k] then
        	--print(tools)
            hasBlueprint = false
            break
        end
    end

    return hasBlueprint
end

function canyoureallycraft(inv, itemTable)
        -- Check if itemTable has required resources
    if itemTable["Resources"] and not BRICKS_SERVER.Func.HasResources(inv, itemTable["Resources"]) then
            --print("no-resources")
        return false
    end

        -- Check if itemTable has required tools (if specified)
    if itemTable["CraftTools"] and not BRICKS_SERVER.Func.HasTools(inv, itemTable["CraftTools"]) then
            --print("no-CraftTools")
        return false
    end

        -- Check if itemTable has required blueprints (if specified)
    if itemTable["Blueprints"] and not BRICKS_SERVER.Func.HasBlueprint(inv, itemTable["Blueprints"]) then
            --print("no-Blueprints")
        return false
    end

        -- All requirements are met
    return true
end

function BRICKS_SERVER.LoadEntities()
	for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Resources ) do
		local ENT = {}
		ENT.Type = "anim"
		ENT.Base = "bricks_server_resource"
		
		ENT.PrintName = k
		ENT.Category		= "DISFULVERSE / Resources"
		ENT.Author			= "snvlpkinq"
		
		ENT.Spawnable = true
		ENT.AdminSpawnable = true
		
		ENT.ResourceType = k
		--print(ENT.ResourceType)

		scripted_ents.Register( ENT, "bricks_server_resource_" .. string.Replace( string.lower( k ), " ", "" ) )
	end
end

function BRICKS_SERVER.LoadCraftTools()
	for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.CraftTools ) do

		local ENT = {}
		ENT.Type = "anim"
		ENT.Base = "bricks_server_crafttool"
		
		ENT.PrintName = k
		ENT.Category		= "DISFULVERSE / Tools"
		ENT.Author			= "snvlpkinq"
		
		ENT.Spawnable = true
		ENT.AdminSpawnable = true

		scripted_ents.Register( ENT, "bricks_server_crafttool_" .. string.Replace( string.lower( k ), " ", "" ) )
	end
end
BRICKS_SERVER.LoadCraftTools()
--PrintTable(BRICKS_SERVER.CONFIG.CRAFTING.CraftTools)

function BRICKS_SERVER.LoadBlueprints()
	for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Blueprints ) do

		local ENT = {}
		ENT.Type = "anim"
		ENT.Base = "bricks_server_blueprint"
		
		ENT.PrintName = v[4]
		ENT.Category		= "DISFULVERSE / Blueprints"
		ENT.Author			= "snvlpkinq"
		
		ENT.Spawnable = true
		ENT.AdminSpawnable = true
		ENT.BlueprintKey = k
		ENT.MaxAmount = v[2]
		ENT.UseAmount = v[3]
		--PrintTable(ENT)

		scripted_ents.Register( ENT, "bricks_server_blueprint_" .. string.Replace( string.lower( k ), " ", "" ) )
	end
end
BRICKS_SERVER.LoadBlueprints()

if( BRICKS_SERVER.CONFIG_LOADED ) then
	BRICKS_SERVER.LoadEntities()
	BRICKS_SERVER.LoadCraftTools()
	BRICKS_SERVER.LoadBlueprints()
else
	hook.Add( "BRS.Hooks.ConfigLoad", "BRS.BRS_ConfigLoad.LoadCraftingEntities", BRICKS_SERVER.LoadEntities )
	hook.Add( "BRS.Hooks.ConfigLoad", "BRS.BRS_ConfigLoad.LoadCraftTools",BRICKS_SERVER.LoadCraftTools )
	hook.Add( "BRS.Hooks.ConfigLoad", "BRS.BRS_ConfigLoad.LoadBlueprints",BRICKS_SERVER.LoadBlueprints )
end