--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    
end

function PANEL:FillPanel()
    local topPanel = vgui.Create( "Panel", self )
	topPanel:Dock( TOP )
	topPanel:SetTall( PROJECT0.FUNC.ScreenScale( 70 ) )
	topPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.FUNC.ScreenScale( 120 ), PROJECT0.UI.Margin50, 0 )
	topPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_page_storepanel" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_page_storepanel", x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    self.searchBar = vgui.Create( "pz_searchbar", topPanel )
	self.searchBar:Dock( LEFT )
	self.searchBar:SetWide( ScrW()*0.1 )
	self.searchBar:DockMargin( PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, 0, PROJECT0.UI.Margin15 )
	self.searchBar:DisableShadows( true )
	self.searchBar.OnChange = function()
        self:Refresh()
	end

    self.sortType = 1
    self.sortTypes = {
        {
            Name = PROJECT0.L( "default" ),
            SortItems = function( itemsTable ) end
        },
        {
            Name = PROJECT0.L( "rarity" ),
            SortItems = function( itemsTable ) 
                table.sort( itemsTable, function( a, b ) 
                    return PROJECT0.FUNC.GetRarityOrder( a[2][1] ) > PROJECT0.FUNC.GetRarityOrder( b[2][1] )
                end )
            end
        }
    }

    self.sortCombo = vgui.Create( "pz_combo", topPanel )
	self.sortCombo:Dock( RIGHT )
	self.sortCombo:SetWide( ScrW()*0.06 )
	self.sortCombo:DockMargin( 0, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15 )
	self.sortCombo:DisableShadows( true )
	self.sortCombo:SetIcon( Material( "project0/icons/sort.png", "noclamp smooth" ) )

    for k, v in ipairs( self.sortTypes ) do
        self.sortCombo:AddChoice( v.Name, k )
    end

	self.sortCombo.OnSelect = function( self2, index, value, data )
        self.sortType = data
        self:Refresh()
    end

    local cosmeticTypes = {
        {
            Name = PROJECT0.L( "skins" ),
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" )
        },
        {
            Name = PROJECT0.L( "charms" ),
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" )
        },
        {
            Name = PROJECT0.L( "stickers" ),
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" )
        }
    }

    self.unselectedTypes = {}
    for k, v in ipairs( cosmeticTypes ) do
        local checkButton = vgui.Create( "pz_checkbutton", topPanel )
        checkButton:Dock( RIGHT )
        checkButton:DockMargin( 0, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15 )
        checkButton:DisableShadows( true )
        checkButton:SetIcon( v.Icon )
        checkButton:SetLabelText( v.Name )
        checkButton:SetValue( true )
        checkButton.OnChange = function( self2, val )
            self.unselectedTypes[k] = not val
            self:Refresh()
        end
    end

    self.scrollPanel = vgui.Create( "pz_scrollpanel", self )
    self.scrollPanel:Dock( FILL )
    self.scrollPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.UI.Margin25, PROJECT0.UI.Margin50, PROJECT0.UI.Margin50 )
    self.scrollPanel:SetSize( self:GetWide()-(2*PROJECT0.UI.Margin50), self:GetTall()-(PROJECT0.FUNC.ScreenScale( 120 )+PROJECT0.UI.Margin50+topPanel:GetTall()+PROJECT0.UI.Margin25) )
    self.scrollPanel.screenY = 0, 0
    self.scrollPanel.Paint = function( self2, w, h )
        local screenY = select( 2, self2:LocalToScreen( 0, 0 ) )
        if( self2.screenY == screenY ) then return end

        self2.screenY = screenY
        self:Refresh()
    end

    hook.Add( "Project0.Hooks.OwnedSkinsUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.CosmeticInventoryUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.ConfigUpdated", self, function() self:Refresh() end )
end

function PANEL:Refresh()
    self.scrollPanel:Clear()

    local categoryPanels = {}

    local spacing = PROJECT0.UI.Margin10
    local gridWide = self:GetWide()-(2*PROJECT0.UI.Margin50)-self.scrollPanel:GetVBar():GetWide()-spacing
    local slotsWide = math.floor( gridWide/PROJECT0.FUNC.ScreenScale( 150 ) )
    self.slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    local arrowMat = Material( "project0/icons/down.png", "noclamp smooth" )
    local iconSize = PROJECT0.FUNC.ScreenScale( 20 )
    local headerTall = PROJECT0.FUNC.ScreenScale( 40 )

    local sortedCategories = {}
    for k, v in pairs( PROJECT0.CONFIG.CUSTOMISER.StoreCategories ) do
        table.insert( sortedCategories, { k, v.Order })
    end

    table.SortByMember( sortedCategories, 2, true )

    for k, v in pairs( sortedCategories ) do
        local categoryConfig = PROJECT0.CONFIG.CUSTOMISER.StoreCategories[v[1]]

        local categoryPanel = vgui.Create( "Panel", self.scrollPanel )
        categoryPanel:Dock( TOP )
        categoryPanel:SetTall( headerTall )
        categoryPanel:DockMargin( 0, 0, PROJECT0.UI.Margin10, PROJECT0.UI.Margin10 )
        categoryPanel.SetExtraHeight = function( self2, h )
            self2.extraHeight = h
    
            if( self2.expanded ) then
                self2:SetTall( headerTall+h )
            end
        end
        categoryPanel.GetExtraHeight = function( self2 )
            return self2.extraHeight
        end
        categoryPanel:SetExtraHeight( 0 )
        categoryPanel.expanded = true
        categoryPanel.textureRotation = 0
        categoryPanel.SetExpanded = function( self2, expanded )
            self2.expanded = expanded
    
            if( expanded ) then
                self2:SizeTo( self2.actualW or 100, headerTall+self2.extraHeight, 0.2 )
            else
                self2:SizeTo( self2.actualW or 100, headerTall, 0.2 )
            end
    
            self2:DoRotationAnim( expanded )
        end
        categoryPanel.DoRotationAnim = function( self2, expanding )
            local anim = self2:NewAnimation( 0.2, 0, -1 )
        
            anim.Think = function( anim, pnl, fraction )
                if( expanding ) then
                    self2.textureRotation = (1-fraction)*-90
                else
                    self2.textureRotation = fraction*-90
                end
            end
        end
        categoryPanel.Paint = function( self2, w, h )
            if( (self2.actualW or 0) == w ) then return end
            self2.actualW = w
        end

        local startX, startY, endX, endY = 0, self.scrollPanel.screenY, ScrW(), self.scrollPanel.screenY+self.scrollPanel:GetTall()

        local headerPanel = vgui.Create( "Panel", categoryPanel )
        headerPanel:Dock( TOP )
        headerPanel:SetTall( headerTall )
        local iconMat = Material( categoryConfig.Icon, "noclamp smooth" )
        headerPanel.Paint = function( self2, w, h )
            if( not IsValid( self2.button ) ) then return end
            self2.button:CreateFadeAlpha( 0.2, 100 )

            PROJECT0.FUNC.BeginShadow( "menu_page_storecategory_" .. k, startX, startY, endX, endY )
            local x, y = self2:LocalToScreen( 0, 0 )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
            surface.DrawRect( x, y, w, h )
            PROJECT0.FUNC.EndShadow( "menu_page_storecategory_" .. k, x, y, 1, 1, 1, 100, 0, 0, false )
    
            PROJECT0.FUNC.DrawClickPolygon( self2.button, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75+self2.button.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.SetMaterial( arrowMat )
            surface.DrawTexturedRectRotated(w-h/2, h/2, iconSize, iconSize, math.Clamp( (categoryPanel.textureRotation or -90), -90, 0 ) )

            -- Fancy Stuff
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3 ) )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )

            draw.SimpleText( string.upper( categoryConfig.Name ), "MontserratBold20", h, h/2-1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_CENTER )

            if( not IsValid( self2.gradientAnim ) ) then return end
            local borderL, borderR = h*0.5, 2

            render.ClearStencil()
            render.SetStencilEnable( true )
        
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
        
            render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
            render.SetStencilPassOperation( STENCILOPERATION_ZERO )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
            render.SetStencilReferenceValue( 1 )
        
            draw.NoTexture()
            surface.SetDrawColor( 255, 255, 255 )
            surface.DrawRect( 0, 0, borderL, borderR )
            surface.DrawRect( 0, 0, borderR, borderL )
            surface.DrawRect( w-borderL, h-borderR, borderL, borderR )
            surface.DrawRect( w-borderR, h-borderL, borderR, borderL )
        
            render.SetStencilFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
            render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
            render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
            render.SetStencilReferenceValue( 1 )
        
            self2.gradientAnim:PaintManual()
        
            render.SetStencilEnable( false )
            render.ClearStencil()
        end

        headerPanel.button = vgui.Create( "DButton", headerPanel )
        headerPanel.button:Dock( FILL )
        headerPanel.button:SetText( "" )
        headerPanel.button.Paint = function() end
        headerPanel.button.DoClick = function()
            categoryPanel:SetExpanded( not categoryPanel.expanded )
        end
    
        categoryPanel.grid = vgui.Create( "DIconLayout", categoryPanel )
        categoryPanel.grid:Dock( TOP )
        categoryPanel.grid:DockMargin( 0, spacing, 0, 0 )
        categoryPanel.grid:SetSpaceY( spacing )
        categoryPanel.grid:SetSpaceX( spacing )

        categoryPanels[v[1]] = categoryPanel
    end

    local cosmeticTypes = {
        {
            Name = PROJECT0.L( "charms" ),
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" ),
            GetItemInfo = function( itemKey )
                local configTable = PROJECT0.CONFIG.CUSTOMISER.Charms[itemKey]
                if( not configTable ) then return end

                return { configTable.Rarity, configTable.Name }
            end,
            OnCreatePnl = function( pnl, data )
                local modelPanel = vgui.Create( "pz_modelpanel", pnl )
                modelPanel:Dock( FILL )
                modelPanel:SetFOV( 30 )
                modelPanel:ChangeModel( PROJECT0.CONFIG.CUSTOMISER.Charms[data[1]].Model )
            end,
            GetCosmeticInfo = function( data )
                return {}
            end
        },
        {
            Name = PROJECT0.L( "stickers" ),
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" ),
            GetItemInfo = function( itemKey )
                local configTable = PROJECT0.CONFIG.CUSTOMISER.Stickers[itemKey]
                if( not configTable ) then return end

                return { configTable.Rarity, configTable.Name }
            end,
            OnCreatePnl = function( pnl, data )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                local margin = PROJECT0.UI.Margin10
                local heightMargin = ((pnl:GetWide()*1.2)-pnl:GetWide())/2+margin
                skinTexture:DockMargin( margin, heightMargin, margin, heightMargin )
                skinTexture:SetImagePath( PROJECT0.CONFIG.CUSTOMISER.Stickers[data[1]].Icon )
            end,
            GetCosmeticInfo = function( data )
                return {}
            end
        },
        {
            Name = PROJECT0.L( "skins" ),
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" ),
            GetItemInfo = function( itemKey )
                local devConfig = PROJECT0.DEVCONFIG.WeaponSkins[itemKey]
                if( not devConfig ) then return end

                return { PROJECT0.FUNC.GetSkinRarity( itemKey ), devConfig.Name }
            end,
            OnCreatePnl = function( pnl, data )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                skinTexture:SetImagePath( PROJECT0.DEVCONFIG.WeaponSkins[data[1]].Icon )
            end,
            GetCosmeticInfo = function( storeItemConfig )
                local weaponString = ""

                for k, v in pairs( storeItemConfig.Weapons ) do
                    if( v == "*" ) then
                        weaponString = PROJECT0.L( "all" )
                        break
                    end

                    weaponString = weaponString .. ((weaponString != "" and ", ") or "") .. PROJECT0.FUNC.GetWeaponName( v )
                end

                return {
                    { PROJECT0.L( "weapons" ), Material( "project0/icons/weapon.png", "noclamp smooth" ), weaponString }
                }
            end
        }
    }

    local disabledMat = Material( "project0/icons/close.png", "noclamp smooth" )
    for k, v in pairs( PROJECT0.CONFIG.CUSTOMISER.Store ) do
        local categoryPanel = categoryPanels[v.Category]
        if( not IsValid( categoryPanel ) ) then
            print( "[PROJECT0] Error, shop category does not exist for item ID: " .. k )
            continue
        end

        local itemInfo = cosmeticTypes[v.Type].GetItemInfo( v.ItemID )
        if( not itemInfo ) then
            print( "[PROJECT0] Error, shop item info does not exist for item ID: " .. k )
            continue
        end

        local ownsCosmetic = LocalPlayer():Project0():GetOwnsCosmeticType( v.Type, v.ItemID, v.Weapons )

        local info = {}

        if( ownsCosmetic ) then
            table.insert( info, { PROJECT0.L( "error" ), Material( "project0/icons/warning.png", "noclamp smooth" ), PROJECT0.L( "already_owned" ) } )
        end

        table.insert( info, { PROJECT0.L( "price" ), Material( "project0/icons/price.png", "noclamp smooth" ), PROJECT0.FUNC.FormatStoreCurrency( v.Price ) } )

        for k, v in ipairs( cosmeticTypes[v.Type].GetCosmeticInfo( v ) ) do
            table.insert( info, v )
        end

        local infoPanel = vgui.Create( "pz_cosmetic_item", categoryPanel.grid )
        infoPanel:SetSize( self.slotSize, self.slotSize*1.2 )
        infoPanel:SetRarity( itemInfo[1] )
        infoPanel:SetPopup( v.Type, itemInfo[2], info )
        infoPanel:SetShadowBounds( 0, self.scrollPanel.screenY, ScrW(), self.scrollPanel.screenY+self.scrollPanel:GetTall() )
        infoPanel.DoClick = function()
            if( ownsCosmetic ) then
                PROJECT0.FUNC.CreateNotification( PROJECT0.L( "purchase_error" ), PROJECT0.L( "already_own_cosmetic" ), "error" )
                return
            end

            net.Start( "Project0.RequestCosmeticPurchase" )
                net.WriteUInt( k, 10 )
            net.SendToServer()
        end

        cosmeticTypes[v.Type].OnCreatePnl( infoPanel, { v.ItemID } )

        if( ownsCosmetic ) then
            local disabledIcon = vgui.Create( "Panel", infoPanel )
            disabledIcon:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 26 ), 2 ) )
            disabledIcon:SetPos( infoPanel:GetWide()-PROJECT0.UI.Margin5-disabledIcon:GetWide(), PROJECT0.UI.Margin5 )
            disabledIcon.Paint = function( self2, w, h )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                surface.DrawRect( 0, 0, w, h )

                local borderL, borderR = w*0.4, 2
                surface.SetDrawColor( PROJECT0.DEVCONFIG.Colours.Red )
                surface.DrawRect( 0, 0, borderL, borderR )
                surface.DrawRect( 0, 0, borderR, borderL )
                surface.DrawRect( w-borderL, h-borderR, borderL, borderR )
                surface.DrawRect( w-borderR, h-borderL, borderR, borderL )

                surface.SetMaterial( disabledMat )
                local iconSize = PROJECT0.FUNC.ScreenScale( 14 )
                surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
            end
        end

        categoryPanel.slotCount = (categoryPanel.slotCount or 0)+1
        categoryPanel:SetExtraHeight( math.ceil(categoryPanel.slotCount/slotsWide)*((self.slotSize*1.2)+spacing) )
    end
end

function PANEL:Paint( w, h )
    local x, y = self:LocalToScreen( 0, 0 )

    PROJECT0.FUNC.BeginShadow( "menu_store_title" )
    draw.SimpleText( PROJECT0.L( "cosmetic_store" ), "MontserratBold35", x+PROJECT0.UI.Margin50, y+PROJECT0.UI.Margin50, PROJECT0.FUNC.GetTheme( 3 ) )
    PROJECT0.FUNC.EndShadow( "menu_store_title", x, y, 1, 1, 1, 100, 0, 0, false )

    PROJECT0.FUNC.BeginShadow( "menu_store_description" )
    draw.SimpleText( PROJECT0.L( "purchase_cosmetics" ), "MontserratBold19", x+PROJECT0.UI.Margin50, y+PROJECT0.FUNC.ScreenScale( 80 ), PROJECT0.FUNC.GetTheme( 4 ) )
    PROJECT0.FUNC.EndShadow( "menu_store_description", x, y, 1, 1, 1, 100, 0, 0, false )
end

vgui.Register( "pz_weaponcustomiser_page_store", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
