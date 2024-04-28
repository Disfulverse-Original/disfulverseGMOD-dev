local PANEL = {}

function PANEL:Init()
    
end

function PANEL:FillPanel( f4Panel, sheetButton )

    local function BlueprintCheckRealName(key)
        local realname = ""

        for k, v in pairs(BRICKS_SERVER.CONFIG.CRAFTING.Blueprints) do
            if( k == key )then
                realname = v[4]
                break
            end
        end

        return realname
    end

    local craftingSearchBarBack = vgui.Create( "DPanel", self )
    craftingSearchBarBack:Dock( TOP )
    craftingSearchBarBack:DockMargin( 10, 10, 10, 5 )
    craftingSearchBarBack:SetTall( 40 )
    local search = Material( "materials/bricks_server/search.png" )
    local Alpha = 0
    local Alpha2 = 20
    local craftingSearchBar
    local color1 = BRICKS_SERVER.Func.GetTheme( 2 )
    craftingSearchBarBack.Paint = function( self2, w, h )
        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

        if( craftingSearchBar:IsEditing() ) then
            Alpha = math.Clamp( Alpha+5, 0, 100 )
            Alpha2 = math.Clamp( Alpha2+20, 20, 255 )
        else
            Alpha = math.Clamp( Alpha-5, 0, 100 )
            Alpha2 = math.Clamp( Alpha2-20, 20, 255 )
        end
        
        draw.RoundedBox( 5, 0, 0, w, h, Color( color1.r, color1.g, color1.b, Alpha ) )
    
        surface.SetDrawColor( 255, 255, 255, Alpha2 )
        surface.SetMaterial(search)
        local size = 24
        surface.DrawTexturedRect( w-size-(h-size)/2, (h-size)/2, size, size )
    end
    craftingSearchBar = vgui.Create( "bricks_server_search", craftingSearchBarBack ) -- панель поиска
    craftingSearchBar:Dock( FILL )


    local craftingPanel = vgui.Create( "bricks_server_dcategorylist", self ) -- список крафта bricks_server_dcategorylist или bricks_server_scrollpanel_bar
    craftingPanel:Dock( FILL )
    craftingPanel:DockMargin( 10, 0, 10, 10 )
    --craftingPanel:SetBarColor(BRICKS_SERVER.Func.GetTheme( 7 ))
    craftingPanel.Paint = function( self, w, h ) end 



    local panelWide, panelTall = ScrW()*0.6-BRICKS_SERVER.DEVCONFIG.MainNavWidth, ScrH()*0.65-40
    local popoutWide, popoutTall = panelWide*0.5, panelTall

    local spacing = 5
    local gridWide = panelWide-30
    local slotsWide = 2
    local slotWide = (gridWide-((slotsWide-1)*spacing))/slotsWide
    local slotTall = 75

    local function CreateItemPopout( itemKey )
        local itemTable = BRICKS_SERVER.CONFIG.CRAFTING.Craftables[itemKey] or {}

        if( IsValid( craftingPanel.itemPopout ) ) then
            craftingPanel.itemPopout:Remove()
        else
            local itemPopoutClose = vgui.Create( "DButton", self )
            itemPopoutClose:SetSize( panelWide, panelTall )
            itemPopoutClose:SetText( "" )
            itemPopoutClose:SetAlpha( 0 )
            itemPopoutClose:AlphaTo( 255, 0.2 )
            itemPopoutClose:SetCursor( "arrow" )
            itemPopoutClose.Paint = function( self2, w, h )
                surface.SetDrawColor( 0, 0, 0, 150 )
                surface.DrawRect( 0, 0, w, h )
                BRICKS_SERVER.Func.DrawBlur( self2, 2, 2 )
            end
            itemPopoutClose.DoClick = function()
                craftingPanel.itemPopout:MoveTo( panelWide, (panelTall/2)-(popoutTall/2), 0.2, 0, -1, function()
                    if( IsValid( craftingPanel.itemPopout ) ) then
                        craftingPanel.itemPopout:Remove()
                    end
                end )

                itemPopoutClose:AlphaTo( 0, 0.2, 0, function()
                    if( IsValid( itemPopoutClose ) ) then
                        itemPopoutClose:Remove()
                    end
                end )
            end

            craftingPanel.itemPopout = vgui.Create( "DPanel", self )
            craftingPanel.itemPopout:SetSize( popoutWide, popoutTall )
            craftingPanel.itemPopout:SetPos( panelWide, (panelTall/2)-(popoutTall/2) )
            craftingPanel.itemPopout:MoveTo( (panelWide)-(popoutWide), (panelTall/2)-(popoutTall/2), 0.2 )
            craftingPanel.itemPopout.Paint = function( self2, w, h )
                surface.SetDrawColor( BRICKS_SERVER.Func.GetTheme( 2 ) )
                surface.DrawRect( 0, 0, w, h )
            end

            local itemAction = vgui.Create( "DButton", craftingPanel.itemPopout )
            itemAction:Dock( BOTTOM )
            itemAction:SetTall( 40 )
            itemAction:SetText( "" )
            itemAction:DockMargin( 25, 25, 25, 25 )
            local changeAlpha = 0
            itemAction.Paint = function( self2, w, h )
                if( self2:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 125 )
                elseif( self2:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 75 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 75 )
                end
                
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 5 ) )
        
                surface.SetAlphaMultiplier( changeAlpha/255 )
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 4 ) )
                surface.SetAlphaMultiplier( 1 )
        
                draw.SimpleText( BRS_CRAFTING_TIMES[itemKey] and "Отменить" or "Скрафтить", "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
            itemAction.DoClick = function()
                if( not BRS_CRAFTING_TIMES or not BRS_CRAFTING_TIMES[itemKey] ) then
                    net.Start( "BRS.Net.CraftItem" )
                        net.WriteUInt( itemKey, 8 )
                    net.SendToServer()
                else
                    net.Start( "BRS.Net.CraftCancel" )
                        net.WriteUInt( itemKey, 8 )
                    net.SendToServer()
                end

                craftingPanel.itemPopout:MoveTo( panelWide, (panelTall/2)-(popoutTall/2), 0.2, 0, -1, function()
                    if( IsValid( craftingPanel.itemPopout ) ) then
                        craftingPanel.itemPopout:Remove()
                    end
                end )

                itemPopoutClose:AlphaTo( 0, 0.2, 0, function()
                    if( IsValid( itemPopoutClose ) ) then
                        itemPopoutClose:Remove()
                    end
                end )
            end

            local topMargin, bottomMargin = popoutTall*0.075, 145
            surface.SetFont( "BRICKS_SERVER_Font20" )
            local textX, textY = surface.GetTextSize( "TEST" )

            local itemIcon = vgui.Create( "DModelPanel" , craftingPanel.itemPopout )
            itemIcon:Dock( FILL )
            itemIcon:DockMargin( 0, topMargin+5+28+textY, 0, 5 )
            itemIcon:SetModel( itemTable.Model )
            if( IsValid( itemIcon.Entity ) ) then
                function itemIcon:LayoutEntity(ent) return end
                local mn, mx = itemIcon.Entity:GetRenderBounds()
                local size = 0
                size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

                itemIcon:SetFOV( 80 )
                itemIcon:SetCamPos( Vector( size, size, size ) )
                itemIcon:SetLookAt( (mn + mx) * 0.5 )
            end

            if( itemTable.Color ) then
                itemIcon:SetColor( itemTable.Color )
            end

            local itemInfoDisplay = vgui.Create( "DPanel", craftingPanel.itemPopout )
            itemInfoDisplay:SetSize( popoutWide, popoutTall-topMargin-bottomMargin )
            itemInfoDisplay:SetPos( popoutWide-itemInfoDisplay:GetWide(), topMargin )
            itemInfoDisplay.Paint = function( self2, w, h ) 
                draw.SimpleText( itemTable.Name, "BRICKS_SERVER_Font25", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            end

            local itemInfoNoticeBack = vgui.Create( "DPanel", itemInfoDisplay )
            itemInfoNoticeBack:SetSize( 0, 35 )
            itemInfoNoticeBack:SetPos( (itemInfoDisplay:GetWide()/2)-(itemInfoNoticeBack:GetWide()/2), 5+28 )
            itemInfoNoticeBack.Paint = function( self2, w, h ) end

            local itemNotices = {}

            if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) and itemTable.Level ) then
                table.insert( itemNotices, { "Level " .. itemTable.Level } )
            end

            if( itemTable.Group ) then
                local groupTable
                for k, v in pairs( BRICKS_SERVER.CONFIG.GENERAL.Groups ) do
                    if( v[1] == itemTable.Group ) then
                        groupTable = v
                    end
                end

                if( groupTable ) then
                    table.insert( itemNotices, { (groupTable[1] or "None"), groupTable[3] } )
                end
            end

            for k, v in pairs( itemNotices ) do
                surface.SetFont( "BRICKS_SERVER_Font20" )
                local textX, textY = surface.GetTextSize( v[1] )
                local boxW, boxH = textX+10, textY

                local itemInfoNotice = vgui.Create( "DPanel", itemInfoNoticeBack )
                itemInfoNotice:Dock( LEFT )
                itemInfoNotice:DockMargin( 0, 0, 5, 0 )
                itemInfoNotice:SetWide( boxW )
                itemInfoNotice.Paint = function( self2, w, h ) 
                    draw.RoundedBox( 5, 0, 0, w, h, (v[2] or BRICKS_SERVER.Func.GetTheme( 5 )) )
                    draw.SimpleText( v[1], "BRICKS_SERVER_Font20", w/2, (h/2)-1, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
                end

                if( itemInfoNoticeBack:GetWide() <= 5 ) then
                    itemInfoNoticeBack:SetSize( itemInfoNoticeBack:GetWide()+boxW, boxH )
                else
                    itemInfoNoticeBack:SetSize( itemInfoNoticeBack:GetWide()+5+boxW, boxH )
                end
                itemInfoNoticeBack:SetPos( (itemInfoDisplay:GetWide()/2)-(itemInfoNoticeBack:GetWide()/2), 5+28 )
            end

            --local resmat = Material( "materials/bricks_server/damage.png" )
            local resourceListBack = vgui.Create( "bricks_server_scrollpanel", itemInfoDisplay )
            resourceListBack:Dock( RIGHT )
            resourceListBack:SetWide( 50 )
            resourceListBack:DockMargin( 0, 75, 25, 0 )
            resourceListBack.Paint = function( self2, w, h )

                --surface.SetDrawColor( 255, 255, 255, 255 )
                --surface.SetMaterial( resmat )
                --local size = 32
                --surface.DrawTexturedRect( 0, 0, size, size )

            end

            for k, v in pairs( itemTable.Resources ) do
                local modelEntryButton = vgui.Create( "DPanel", resourceListBack )
                modelEntryButton:Dock( TOP )
                modelEntryButton:SetTall( resourceListBack:GetWide() )
                modelEntryButton:DockMargin( 0, 0, 0, 5 )
                local changeAlpha = 0
                local modelEntryIcon
                local x, y, w, h = 0, 0, modelEntryButton:GetTall(), modelEntryButton:GetTall()
                modelEntryButton.Paint = function( self2, w, h )
                    local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
                    if( x != toScreenX or y != toScreenY ) then
                        x, y = toScreenX, toScreenY
        
                        modelEntryIcon:SetBRSToolTip( x, y, w, h, "x" .. string.Comma( v ) .. " " .. k )
                    end

                    if( modelEntryIcon:IsDown() ) then
                        changeAlpha = math.Clamp( changeAlpha+10, 0, 125 )
                    elseif( modelEntryIcon:IsHovered() ) then
                        changeAlpha = math.Clamp( changeAlpha+10, 0, 75 )
                    else
                        changeAlpha = math.Clamp( changeAlpha-10, 0, 75 )
                    end
                    
                    draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
            
                    surface.SetAlphaMultiplier( changeAlpha/255 )
                    draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 5 ) )
                    surface.SetAlphaMultiplier( 1 )
                end

                local model = "error.model"
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources and BRICKS_SERVER.CONFIG.CRAFTING.Resources[k] ) then
                    model = BRICKS_SERVER.CONFIG.CRAFTING.Resources[k][1]
                end

                modelEntryIcon = vgui.Create( "DModelPanel" , modelEntryButton )
                modelEntryIcon:Dock( FILL )
                modelEntryIcon:SetModel( model )
                if( modelEntryIcon.Entity and IsValid( modelEntryIcon.Entity ) ) then
                    function modelEntryIcon:LayoutEntity(ent) return end
                    local mn, mx = modelEntryIcon.Entity:GetRenderBounds()
                    local size = 0
                    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
            
                    modelEntryIcon:SetFOV( 50 )
                    modelEntryIcon:SetCamPos( Vector( size, size, size ) )
                    modelEntryIcon:SetLookAt( (mn + mx) * 0.5 )

                    if( BRICKS_SERVER.CONFIG.CRAFTING.Resources and BRICKS_SERVER.CONFIG.CRAFTING.Resources[k] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[k][2] ) then
                        modelEntryIcon:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[k][2] )
                    end
                end
            end

            if itemTable["CraftTools"] then
                local toolsListBack = vgui.Create( "bricks_server_scrollpanel", itemInfoDisplay )
                toolsListBack:Dock( RIGHT )
                toolsListBack:SetWide( 50 )
                toolsListBack:DockMargin( 0, 75, 25, 0 )
                toolsListBack.Paint = function( self2, w, h ) end

                for k, v in pairs( itemTable["CraftTools"] ) do
                    local modelEntryButton = vgui.Create( "DPanel", toolsListBack )
                    modelEntryButton:Dock( TOP )
                    modelEntryButton:SetTall( toolsListBack:GetWide() )
                    modelEntryButton:DockMargin( 0, 0, 0, 5 )
                    local changeAlpha = 0
                    local modelEntryIcon
                    local x, y, w, h = 0, 0, modelEntryButton:GetTall(), modelEntryButton:GetTall()
                    modelEntryButton.Paint = function( self2, w, h )
                        local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
                        if( x != toScreenX or y != toScreenY ) then
                            x, y = toScreenX, toScreenY
            
                            modelEntryIcon:SetBRSToolTip( x, y, w, h, k )
                        end

                        if( modelEntryIcon:IsDown() ) then
                            changeAlpha = math.Clamp( changeAlpha+10, 0, 125 )
                        elseif( modelEntryIcon:IsHovered() ) then
                            changeAlpha = math.Clamp( changeAlpha+10, 0, 75 )
                        else
                            changeAlpha = math.Clamp( changeAlpha-10, 0, 75 )
                        end
                        
                        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
                
                        surface.SetAlphaMultiplier( changeAlpha/255 )
                        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 5 ) )
                        surface.SetAlphaMultiplier( 1 )
                    end

                    local model = "error.model"
                    if( BRICKS_SERVER.CONFIG.CRAFTING.CraftTools and BRICKS_SERVER.CONFIG.CRAFTING.CraftTools[k] ) then
                        model = BRICKS_SERVER.CONFIG.CRAFTING.CraftTools[k][1]
                    end

                    modelEntryIcon = vgui.Create( "DModelPanel" , modelEntryButton )
                    modelEntryIcon:Dock( FILL )
                    modelEntryIcon:SetModel( model )
                    if( modelEntryIcon.Entity and IsValid( modelEntryIcon.Entity ) ) then
                        function modelEntryIcon:LayoutEntity(ent) return end
                        local mn, mx = modelEntryIcon.Entity:GetRenderBounds()
                        local size = 0
                        size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                        size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                        size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
                
                        modelEntryIcon:SetFOV( 50 )
                        modelEntryIcon:SetCamPos( Vector( size, size, size ) )
                        modelEntryIcon:SetLookAt( (mn + mx) * 0.5 )

                        --if( BRICKS_SERVER.CONFIG.CRAFTING.CraftTools and BRICKS_SERVER.CONFIG.CRAFTING.CraftTools[k] and BRICKS_SERVER.CONFIG.CRAFTING.CraftTools[k][2] ) then
                            --modelEntryIcon:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.CraftTools[k][2] )
                        --end
                    end
                end
            end

            if itemTable["Blueprints"] then
                local blueprintsListBack = vgui.Create( "bricks_server_scrollpanel", itemInfoDisplay )
                blueprintsListBack:Dock( RIGHT )
                blueprintsListBack:SetWide( 50 )
                blueprintsListBack:DockMargin( 0, 75, 25, 0 )
                blueprintsListBack.Paint = function( self2, w, h ) end

                for k, v in pairs( itemTable["Blueprints"] ) do
                    local modelEntryButton = vgui.Create( "DPanel", blueprintsListBack )
                    modelEntryButton:Dock( TOP )
                    modelEntryButton:SetTall( blueprintsListBack:GetWide() )
                    modelEntryButton:DockMargin( 0, 0, 0, 5 )
                    local changeAlpha = 0
                    local modelEntryIcon
                    local x, y, w, h = 0, 0, modelEntryButton:GetTall(), modelEntryButton:GetTall()
                    modelEntryButton.Paint = function( self2, w, h )
                        local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
                        if( x != toScreenX or y != toScreenY ) then
                            x, y = toScreenX, toScreenY
            
                            modelEntryIcon:SetBRSToolTip( x, y, w, h, BlueprintCheckRealName(k) )
                        end

                        if( modelEntryIcon:IsDown() ) then
                            changeAlpha = math.Clamp( changeAlpha+10, 0, 125 )
                        elseif( modelEntryIcon:IsHovered() ) then
                            changeAlpha = math.Clamp( changeAlpha+10, 0, 75 )
                        else
                            changeAlpha = math.Clamp( changeAlpha-10, 0, 75 )
                        end
                        
                        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
                
                        surface.SetAlphaMultiplier( changeAlpha/255 )
                        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 5 ) )
                        surface.SetAlphaMultiplier( 1 )
                    end

                    local model = "error.model"
                    if( BRICKS_SERVER.CONFIG.CRAFTING.Blueprints and BRICKS_SERVER.CONFIG.CRAFTING.Blueprints[k] ) then
                        model = BRICKS_SERVER.CONFIG.CRAFTING.Blueprints[k][1]
                    end

                    modelEntryIcon = vgui.Create( "DModelPanel" , modelEntryButton )
                    modelEntryIcon:Dock( FILL )
                    modelEntryIcon:SetModel( model )
                    if( modelEntryIcon.Entity and IsValid( modelEntryIcon.Entity ) ) then
                        function modelEntryIcon:LayoutEntity(ent) return end
                        local mn, mx = modelEntryIcon.Entity:GetRenderBounds()
                        local size = 0
                        size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                        size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                        size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
                
                        modelEntryIcon:SetFOV( 50 )
                        modelEntryIcon:SetCamPos( Vector( size, size, size ) )
                        modelEntryIcon:SetLookAt( (mn + mx) * 0.5 )

                        --if( BRICKS_SERVER.CONFIG.CRAFTING.Blueprints and BRICKS_SERVER.CONFIG.CRAFTING.Blueprints[k] and BRICKS_SERVER.CONFIG.CRAFTING.Blueprints[k][2] ) then
                            --modelEntryIcon:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Blueprints[k][2] )
                        --end
                    end
                end
            end

        end
    end


    local scroll
    function fillCrafting()
        local loadingIcon = Material( "materials/bricks_server/loading.png" )
        local plyinventory = LocalPlayer():BRS():GetInventory()

        --print("filledcraft")
        scroll = craftingPanel.VBar:GetScroll() or 0
        craftingPanel:Clear()

        local sortedCraftingTable = {}
        for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Craftables ) do
            --PrintTable(BRICKS_SERVER.CONFIG.CRAFTING.Craftables)
            if( craftingSearchBar:GetValue() != "" and not string.find( string.lower( v.Name ), string.lower( craftingSearchBar:GetValue() ) ) ) then
                continue
            end

            if v.Type != "Resource" then
                continue
            end

            local newItemTable = v
            newItemTable.key = k

            --PrintTable(newItemTable)
            --print(v.Type)

            table.insert( sortedCraftingTable, { k, "Обработка", newItemTable } )
            --print("Обработка")
            --PrintTable(sortedCraftingTableResource)
        end
        for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Craftables ) do

            if( craftingSearchBar:GetValue() != "" and not string.find( string.lower( v.Name ), string.lower( craftingSearchBar:GetValue() ) ) ) then
                continue
            end

            if v.Type != "Weapon" then
                continue
            end

            local newItemTable = v
            newItemTable.key = k

            --PrintTable(newItemTable)
            --print(v.Type)
            --print(v.ReqInfo[1])
            local pickaxelen = "bricks_server_pickaxe"
            local axelen = "bricks_server_axe"
            if v.ReqInfo[1] and ((string.sub(v.ReqInfo[1], 1, #pickaxelen) == "bricks_server_pickaxe") or (string.sub(v.ReqInfo[1], 1, #axelen) == "bricks_server_axe")) then
                table.insert(sortedCraftingTable, { k, "Экипировка", newItemTable })
                --print(v.Name)
            else
                table.insert( sortedCraftingTable, { k, "Оружие", newItemTable } )
            end
            
            --print("Оружие")
            --PrintTable(sortedCraftingTableWeapon)
        end
        for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Craftables ) do

            if( craftingSearchBar:GetValue() != "" and not string.find( string.lower( v.Name ), string.lower( craftingSearchBar:GetValue() ) ) ) then
                continue
            end

            if v.Type != "Craft Tool" then
                continue
            end

            local newItemTable = v
            newItemTable.key = k

            --PrintTable(newItemTable)
            --print(v.Type)

            table.insert( sortedCraftingTable, { k, "Инструменты", newItemTable } )
            --print("Инструменты")
            --PrintTable(sortedCraftingTableCraftTool)
        end
        for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Craftables ) do

            if( craftingSearchBar:GetValue() != "" and not string.find( string.lower( v.Name ), string.lower( craftingSearchBar:GetValue() ) ) ) then
                continue
            end

            if v.Type != "Blueprint" then
                continue
            end

            local newItemTable = v
            newItemTable.key = k

            --PrintTable(newItemTable)
            --print(v.Type)

            table.insert( sortedCraftingTable, { k, "Схемы", newItemTable } )
            --print("Схемы")
            --PrintTable(sortedCraftingTableBlueprint)
        end
        for k, v in pairs( BRICKS_SERVER.CONFIG.CRAFTING.Craftables ) do

            if( craftingSearchBar:GetValue() != "" and not string.find( string.lower( v.Name ), string.lower( craftingSearchBar:GetValue() ) ) ) then
                continue
            end

            if v.Type != "Entity" then
                continue
            end

            local newItemTable = v
            newItemTable.key = k

            --PrintTable(newItemTable)
            --print(v.Type)
            --print(v.ReqInfo[1])
            if v.ReqInfo[1] and (string.sub(v.ReqInfo[1], 1, 11) == "arccw_ammo_") then
                table.insert(sortedCraftingTable, { k, "Аммуниция", newItemTable })
                --print(v.Name)
            else
                table.insert( sortedCraftingTable, { k, "Разное", newItemTable } )
            end
            --print("Энтити")
            --PrintTable(sortedCraftingTableEntity)
        end

        table.sort( sortedCraftingTable, function(a, b) return ((a or {}).Level or 0) < ((b or {}).Level or 0) end )
        --print("done")
        --PrintTable(sortedCraftingTable)

        local categories = {}
        for k,v in ipairs(sortedCraftingTable) do
            local type = v[2]
            local itemTable
            --local itemGroup = {}
            local itemLevel = 0

            if( type == "Обработка" and v[3]["Type"] == "Resource" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            elseif( type == "Оружие" and v[3]["Type"] == "Weapon" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            elseif( type == "Экипировка" and v[3]["Type"] == "Weapon" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            elseif( type == "Инструменты" and v[3]["Type"] == "Craft Tool" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            elseif( type == "Схемы" and v[3]["Type"] == "Blueprint" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            elseif( type == "Разное" and v[3]["Type"] == "Entity" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            elseif( type == "Аммуниция" and v[3]["Type"] == "Entity" ) then
                itemTable = v[3]
                --itemGroup = BRICKS_SERVER.CONFIG.GENERAL.EntityGroups or {}
                if( BRICKS_SERVER.Func.IsSubModuleEnabled( "essentials", "levelling" ) ) then
                    itemLevel = v[3]["Level"] or 0
                end
            end


            if( not itemTable ) then continue end




            local itemCategory = v[2]


            if( not categories[itemCategory] ) then
                categories[itemCategory] = craftingPanel:Add( itemCategory, color_white , Color(3, 3, 3, 5)  )
                categories[itemCategory]:SetTall( 40 )
                categories[itemCategory].type = type

                categories[itemCategory].grid = vgui.Create( "DIconLayout", categories[itemCategory] )
                categories[itemCategory].grid:Dock( FILL )
                categories[itemCategory].grid:DockMargin( 5, spacing, 0, 0 )
                categories[itemCategory].grid:SetTall( slotTall )
                categories[itemCategory].grid:SetSpaceY( spacing )
                categories[itemCategory].grid:SetSpaceX( spacing )
            end

            categories[itemCategory].slots = (categories[itemCategory].slots or 0)+1
            local slots = categories[itemCategory].slots
            local slotsTall = math.ceil( slots/slotsWide )
            categories[itemCategory]:SetTall( 40+10+(slotsTall*slotTall)+((slotsTall-1)*spacing) )
            categories[itemCategory].grid:SetTall( (slotsTall*slotTall)+((slotsTall-1)*spacing) )

            

            local itemBack = categories[itemCategory].grid:Add( "DPanel" )
            local cancraft = canyoureallycraft(plyinventory, itemTable) 
            itemBack:SetSize( slotWide, slotTall )
            itemBack.Paint = function( self2, w, h )

                if( BRS_CRAFTING_TIMES and BRS_CRAFTING_TIMES[itemTable.key] ) then
                    local finalWidth = w*math.Clamp( (BRS_CRAFTING_TIMES[itemTable.key]-CurTime())/itemTable.CraftTime, 0, 1 )
                    if( finalWidth <= w-5 ) then
                        draw.RoundedBoxEx( 5, 0, 0, finalWidth, h, BRICKS_SERVER.Func.GetTheme( 4 ), true, false, true, false )
                    else
                        draw.RoundedBox( 5, 0, 0, finalWidth, h, BRICKS_SERVER.Func.GetTheme( 4 ) )
                    end
                end

                draw.RoundedBox( 0, 0, 0, w, h, Color(4, 4, 6, 45) )

                if cancraft then
                    surface.SetDrawColor( Color(103, 235, 127, 45) )
                    surface.DrawRect(5, 5, h-10, h-10)              
                end

                --print(cancraft(plyinventory, itemTable))
                draw.SimpleText( itemTable["Name"], "BRICKS_SERVER_Font30", h+10, h/2+2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_BOTTOM )

                if( BRS_CRAFTING_TIMES and BRS_CRAFTING_TIMES[itemTable.key] ) then
                    draw.SimpleText( "Осталось: " .. BRICKS_SERVER.Func.FormatTime( math.max( 0, BRS_CRAFTING_TIMES[itemTable.key]-CurTime() ) ), "BRICKS_SERVER_Font20", h, 32, BRICKS_SERVER.Func.GetTheme( 6 ), 0, 0 )

                    surface.SetDrawColor( 255, 255, 255, 255 )
                    surface.SetMaterial( loadingIcon )
                    local size = 32
                    surface.DrawTexturedRectRotated( w/2, h/2, size, size, -(CurTime() % 360 * 250) )

                    draw.SimpleText( "Создаем...", "BRICKS_SERVER_Font18", w/2, h/1.5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
                end
            end
            --[[
            itemBack.Think = function()
                PrintTable(plyinventory)
                print( canyoureallycraft(plyinventory, itemTable) )
            end
            --]]
            local itemIcon = vgui.Create( "DModelPanel" , itemBack )
            itemIcon:SetPos( 5, 5 )
            itemIcon:SetSize( itemBack:GetTall()-10, itemBack:GetTall()-10 )
            if( istable( itemTable.model ) ) then
                itemIcon:SetModel( itemTable["Model"] )
            else
                itemIcon:SetModel( itemTable["Model"] )
            end
            function itemIcon:LayoutEntity(ent) return end

            if( IsValid( itemIcon.Entity ) ) then
                local mn, mx = itemIcon.Entity:GetRenderBounds()
                local size = 0
                size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )
    
                itemIcon:SetFOV( 60 )
                itemIcon:SetCamPos( Vector( size, size, size ) )
                itemIcon:SetLookAt( (mn + mx) * 0.5 )
            end

            local itemButton = vgui.Create( "DButton", itemBack )
            itemButton:SetPos( 0, 0 )
            itemButton:SetSize( slotWide, itemBack:GetTall() )
            itemButton:SetText( "" )
            local changeAlpha = 0
            itemButton.Paint = function( self2, w, h ) 
                if( self2:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 125 )
                elseif( self2:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end

                surface.SetAlphaMultiplier( changeAlpha/255 )
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
                surface.SetAlphaMultiplier( 1 )
            end
            itemButton.DoClick = function()
                fillCrafting()
                CreateItemPopout(v[1])
            end

        end

        for k, v in pairs( categories ) do
            v:SetExpanded( true )
            v:SetZPos( 0 )
        end

        if( scroll ) then
            craftingPanel.VBar:AnimateTo( scroll, 0 )
        end

    end
    fillCrafting()

    craftingSearchBar.OnChange = function()
        fillCrafting()
    end
    
    hook.Add( "BRS.Hooks.FillCrafting", "BRS.BRS.Hooks.FillCrafting_F4", function()
        if( IsValid( self ) ) then
            fillCrafting()
        end
    end )
        --PrintTable(categories)
        --PrintTable(sortedCraftingTable)
        -- присвоить всем крафтам новый индекс категории, затем от типа энт базы сделать категории и присвоить их соответсвенным крафтам с соотвествующими базами
end

function PANEL:Paint( w, h )
end


vgui.Register( "bricks_server_f4_crafting", PANEL, "DPanel" )