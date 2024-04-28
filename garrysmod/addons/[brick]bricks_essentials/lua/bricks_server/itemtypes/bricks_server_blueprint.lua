local ITEM = BRICKS_SERVER.Func.CreateItemType( "bricks_server_blueprint*" )

ITEM.GetItemData = function( ent )
    if( not IsValid( ent ) ) then return end
    
    local itemData = { "bricks_server_blueprint", ent:GetModel(), ent.PrintName, ent.BlueprintKey, ent.MaxAmount and ent:GetMaxAmount(), ent.UseAmount and ent:GetUseAmount() }
    
    itemData[5] = ent.MaxAmount
    itemData[6] = ent.UseAmount
    --print("Max ".. itemData[5] .. " Use " .. itemData[6])
    --PrintTable(itemData)
    return itemData, ((ent.GetAmount and ent:GetAmount()) or 1)
    
end

ITEM.CanDropMultiple = false

ITEM.OnSpawn = function( ply, pos, itemData, itemAmount )
    local ent = ents.Create( "bricks_server_blueprint_" .. string.Replace( string.lower( itemData[4] or "" ), " ", "" ) )
    if( not IsValid( ent ) ) then return end
    ent:SetPos( pos )

    ent.UseAmount = itemData[6]
    ent.MaxAmount = itemData[5]

    ent:Spawn()
    ent:SetAmount( itemAmount or 1 )

    

end

ITEM.GetInfo = function( itemData )
    local itemDescription = "Схема для крафта."
    if( BRICKS_SERVER.ESSENTIALS.LUACFG.ItemDescriptions and BRICKS_SERVER.ESSENTIALS.LUACFG.ItemDescriptions["bricks_server_blueprint_" .. string.Replace( string.lower( itemData[4] or "" ), " ", "" )] ) then
        itemDescription = BRICKS_SERVER.ESSENTIALS.LUACFG.ItemDescriptions["bricks_server_blueprint_" .. string.Replace( string.lower( itemData[4] or "" ), " ", "" )]
    end

    local UsageAmount = ""
    if itemData[6] and itemData[5] then
        UsageAmount = "Использований: " .. tostring(itemData[6]) .. " / " .. tostring(itemData[5])
    else
        UsageAmount = "N/A"
    end

    return { (itemData[3] or "Unknown"), itemDescription, (BRICKS_SERVER.CONFIG.INVENTORY.ItemRarities or {})["bricks_server_blueprint_" .. string.Replace( string.lower( itemData[4] or "" ), " ", "" )], UsageAmount }
end

ITEM.GetItemKey = function( itemData )
    return itemData[3] or ""
end

ITEM.GetPotentialItems = function()
    local potentialItems = {}
    for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Blueprints ) do
        potentialItems[k] = {
            Name = k,
            Model = v[1],
            ItemKey = k
        }
    end

    return potentialItems
end

ITEM.ModelDisplay = function( Panel, itemtable )
    if( not Panel.Entity or not IsValid( Panel.Entity ) ) then return end
    
    local mn, mx = Panel.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    Panel:SetFOV( 70 )
    Panel:SetCamPos( Vector( size, size, size ) )
    Panel:SetLookAt( (mn + mx) * 0.5 )
    

    --if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemtable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemtable[3]][2] ) then
       -- Panel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemtable[3]][2] )
    --end
end

ITEM.CanCombine = function( itemData1, itemData2 )
    --if( itemData1[1] == itemData2[1] and itemData1[3] and itemData2[3] and itemData1[3] == itemData2[3] ) then
        --return true
    --end

    return false
end

ITEM:Register()