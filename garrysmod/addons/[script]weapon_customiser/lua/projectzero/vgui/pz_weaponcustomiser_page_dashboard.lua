--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    
end

function PANEL:FillPanel()
    local pageTitleMargin = PROJECT0.FUNC.ScreenScale( 120 )

    local cosmeticTypes = {
        {
            Name = PROJECT0.L( "charms" ),
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" ),
            GetValues = function()
                local count = 0
                for k, v in pairs( LocalPlayer():Project0():GetCosmeticInventory() ) do
                    if( PROJECT0.FUNC.ReverseCosmeticKey( k ) != 1 ) then continue end
                    count = count+1
                end

                return count, table.Count( PROJECT0.CONFIG.CUSTOMISER.Charms )
            end,
            GetItemInfo = function( itemKey )
                local configTable = PROJECT0.CONFIG.CUSTOMISER.Charms[itemKey]
                if( not configTable ) then return end

                return { configTable.Rarity, configTable.Name }
            end,
            OnCreatePnl = function( pnl, itemID )
                local modelPanel = vgui.Create( "pz_modelpanel", pnl )
                modelPanel:Dock( FILL )
                modelPanel:SetFOV( 30 )
                modelPanel:ChangeModel( PROJECT0.CONFIG.CUSTOMISER.Charms[itemID].Model )
            end
        },
        {
            Name = PROJECT0.L( "stickers" ),
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" ),
            GetValues = function()
                local count = 0
                for k, v in pairs( LocalPlayer():Project0():GetCosmeticInventory() ) do
                    if( PROJECT0.FUNC.ReverseCosmeticKey( k ) != 2 ) then continue end
                    count = count+1
                end

                return count, table.Count( PROJECT0.CONFIG.CUSTOMISER.Stickers )
            end,
            GetItemInfo = function( itemKey )
                local configTable = PROJECT0.CONFIG.CUSTOMISER.Stickers[itemKey]
                if( not configTable ) then return end

                return { configTable.Rarity, configTable.Name }
            end,
            OnCreatePnl = function( pnl, itemID )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                local margin = PROJECT0.UI.Margin10
                local heightMargin = ((pnl:GetWide()*1.2)-pnl:GetWide())/2+margin
                skinTexture:DockMargin( margin, heightMargin, margin, heightMargin )
                skinTexture:SetImagePath( PROJECT0.CONFIG.CUSTOMISER.Stickers[itemID].Icon )
            end
        },
        {
            Name = PROJECT0.L( "skins" ),
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" ),
            GetValues = function()
                return table.Count( LocalPlayer():Project0():GetOwnedSkins() ), #PROJECT0.DEVCONFIG.WeaponSkins
            end,
            GetItemInfo = function( itemKey )
                local devConfig = PROJECT0.DEVCONFIG.WeaponSkins[itemKey]
                if( not devConfig ) then return end

                return { PROJECT0.FUNC.GetSkinRarity( itemKey ), devConfig.Name }
            end,
            OnCreatePnl = function( pnl, itemID )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                skinTexture:SetImagePath( PROJECT0.DEVCONFIG.WeaponSkins[itemID].Icon )
            end
        }
    }

    -- RIGHT PANEL
    local rightTopH = PROJECT0.FUNC.ScreenScale( 60 )
    local rightPanel = vgui.Create( "Panel", self )
	rightPanel:Dock( RIGHT )
	rightPanel:SetSize( self:GetWide()*0.2, self:GetTall()-pageTitleMargin-PROJECT0.UI.Margin50 )
	rightPanel:DockMargin( 0, pageTitleMargin, PROJECT0.UI.Margin50,  PROJECT0.UI.Margin50 )
	rightPanel:DockPadding( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25+rightTopH, PROJECT0.UI.Margin25, PROJECT0.UI.Margin25 )
	rightPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_page_dash_right" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_page_dash_right", x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75 ) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, rightTopH )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( 0, rightTopH-5, w, 5 )

        draw.SimpleText( PROJECT0.L( "featured_items" ), "MontserratBold25", w/2, rightTopH/2, PROJECT0.FUNC.GetTheme( 3, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    rightPanel.RefreshStore = function( self2 )
        local totalH = 0
        local itemPanelH = PROJECT0.FUNC.ScreenScale( 100 )
        for k, v in ipairs( PROJECT0.CONFIG.CUSTOMISER.Store ) do
            if( not v.Featured ) then continue end

            totalH = totalH+itemPanelH+PROJECT0.UI.Margin25
            if( totalH > self2:GetTall()-rightTopH-(2*PROJECT0.UI.Margin25) ) then break end

            local itemInfo = cosmeticTypes[v.Type].GetItemInfo( v.ItemID )
            if( not itemInfo ) then continue end

            local borderH = PROJECT0.FUNC.ScreenScale( 5 )

            local priceText = PROJECT0.FUNC.FormatStoreCurrency( v.Price )
            surface.SetFont( "MontserratBold19" )
            local textW, textH = surface.GetTextSize( priceText )
            textW = textW+PROJECT0.FUNC.ScreenScale( 10 )
            textH = textH+PROJECT0.FUNC.ScreenScale( 5 )

            local itemPanel = vgui.Create( "Panel", self2 )
            itemPanel:Dock( TOP )
            itemPanel:SetTall( itemPanelH )
            itemPanel:DockMargin( 0, 0, 0, PROJECT0.UI.Margin25 )
            itemPanel.Paint = function( self2, w, h )
                if( not IsValid( self2.itemButton ) ) then return end
                self2.itemButton:CreateFadeAlpha( 0.1, 50 )

                PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_featured_" .. k )
                local x, y = self2:LocalToScreen( 0, 0 )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
                surface.DrawRect( x, y, w, h )
                PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_featured_" .. k, x, y, 1, 1, 1, 155, 0, 0, false )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 150+self2.itemButton.alpha ) )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                surface.DrawRect( 0, h-borderH, w, borderH )

                draw.SimpleText( itemInfo[2], "MontserratBold25", h, h/2, PROJECT0.FUNC.GetTheme( 3, 200 ), 0, TEXT_ALIGN_BOTTOM )
                draw.SimpleText( PROJECT0.FUNC.GetRarityName( itemInfo[1] ), "MontserratBold19", h, h/2, PROJECT0.FUNC.GetSolidColor( PROJECT0.FUNC.GetRarityColor( itemInfo[1] ) ), 0, 0 )
            
                -- Price
                PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_featured_price_" .. k )
                local x, y = self2:LocalToScreen( w-PROJECT0.UI.Margin5-textW, PROJECT0.UI.Margin5 )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                surface.DrawRect( x, y, textW, textH )
                PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_featured_price_" .. k, x, y, 1, 1, 1, 155, 0, 0, false )

                draw.SimpleText( priceText, "MontserratBold19", w-PROJECT0.UI.Margin5-(textW/2), PROJECT0.UI.Margin5+(textH/2), PROJECT0.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            local displayPanel = vgui.Create( "Panel", itemPanel )
            displayPanel:Dock( LEFT )
            displayPanel:SetWide( itemPanel:GetTall()-(2*PROJECT0.UI.Margin15)-borderH )
            displayPanel:DockMargin( PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, 0, PROJECT0.UI.Margin15+borderH )
            displayPanel.Paint = function( self2, w, h )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, 125 ) )
                surface.DrawRect( 0, 0, w, h )
            end

            cosmeticTypes[v.Type].OnCreatePnl( displayPanel, v.ItemID )

            local itemButton = vgui.Create( "DButton", itemPanel )
            itemButton:SetSize( self2:GetWide()-(2*PROJECT0.UI.Margin25), itemPanelH )
            itemButton:SetText( "" )
            itemButton.Paint = function() end
            itemButton.DoClick = function( self2 )
                self:GetParent():SetActivePage( 4 )
            end

            itemPanel.itemButton = itemButton
        end
    end
    rightPanel:RefreshStore()

    hook.Add( "Project0.Hooks.ConfigUpdated", rightPanel, function() rightPanel:RefreshStore() end )

    local leftPanel = vgui.Create( "DPanel", self )
	leftPanel:Dock( FILL )
	leftPanel:SetWide( self:GetWide()-rightPanel:GetWide()-(3*PROJECT0.UI.Margin50) )
	leftPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.FUNC.ScreenScale( 120 ), PROJECT0.UI.Margin50,  PROJECT0.UI.Margin50 )
	leftPanel.Paint = function( self2, w, h ) end

    -- BOTTOM PANEL
    local bottomPanel = vgui.Create( "Panel", leftPanel )
	bottomPanel:Dock( BOTTOM )
	bottomPanel:SetTall( PROJECT0.FUNC.ScreenScale( 150 ) )
	bottomPanel:DockPadding( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
	bottomPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_page_dash_bottom" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_page_dash_bottom", x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local progressWide = (leftPanel:GetWide()-((#cosmeticTypes+1)*PROJECT0.UI.Margin25))/#cosmeticTypes
    for k, v in ipairs( cosmeticTypes ) do
        local lerpValue = 0

        local progressPanel = vgui.Create( "Panel", bottomPanel )
        progressPanel:Dock( LEFT )
        progressPanel:SetWide( progressWide )
        progressPanel:DockMargin( 0, 0, PROJECT0.UI.Margin25, 0 )
        progressPanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.SetMaterial( v.Icon )
            local iconSize = h*0.6
            local iconMargin = h/2-iconSize/2
            surface.DrawTexturedRect( iconMargin, iconMargin, iconSize, iconSize )

            draw.SimpleText( v.Name, "MontserratBold35", h, iconMargin-PROJECT0.FUNC.ScreenScale( 10 ), PROJECT0.FUNC.GetTheme( 3, 100 ) )

            local barW, barH = w-h-iconMargin, PROJECT0.FUNC.ScreenScale( 10 )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
            surface.DrawRect( h, h-iconMargin-barH, barW, barH )

            local current, max = v.GetValues()

            lerpValue = Lerp( RealFrameTime()*5, lerpValue, current/max )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            draw.NoTexture()
            local x, y = h, h-iconMargin-barH
            surface.DrawPoly( {
                { x = x, y = y },
                { x = x+math.Clamp( (barW+PROJECT0.FUNC.ScreenScale( 10 ))*lerpValue, 0, barW ), y = y },
                { x = x+(barW*lerpValue), y = y+barH },
                { x = x, y = y+barH }
            } )

            draw.SimpleText( PROJECT0.L( "progress", current, max ), "MontserratBold20", h, h-iconMargin-barH-1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
        end
    end

    -- TOP PANEL
    local topPanel = vgui.Create( "Panel", leftPanel )
	topPanel:Dock( FILL )
	topPanel:DockMargin( 0, 0, 0,  PROJECT0.UI.Margin50 )
	topPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_page_dash_top" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_page_dash_top", x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75 ) )
        surface.DrawRect( 0, 0, w, h )
    end
    topPanel.SetActivePage = function( self2, pageKey )
        if( self2.activePage and self2.pagePanels[self2.activePage] ) then
            self2.pagePanels[self2.activePage]:SetVisible( false )
        end

        self2.activePage = pageKey
        self2.pagePanels[pageKey]:SetVisible( true )
    end
    topPanel.pagePanels = {}
    topPanel.AddPage = function( self2, title, panel )
        local pageKey = #self2.pagePanels+1

        panel:SetVisible( false )
        table.insert( self2.pagePanels, panel )

        local navButton = vgui.Create( "DButton", self2.navBar )
        navButton:Dock( LEFT )
        navButton:SetText( "" )
        navButton.Paint = function( self3, w, h )
            self3:CreateFadeAlpha( 0.2, 100 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self3.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            PROJECT0.FUNC.DrawClickPolygon( self3, w, h )

            if( self2.activePage == pageKey ) then
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                surface.DrawRect( 0, h-2, w, 2 )
            end
    
            draw.SimpleText( title, "MontserratBold20", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        navButton.DoClick = function()
            self2:SetActivePage( pageKey )
        end

        self2.navButtons = self2.navButtons or {}
        table.insert( self2.navButtons, navButton )

        for k, v in ipairs( self2.navButtons ) do
            v:SetWide( leftPanel:GetWide()/#self2.navButtons )
        end
    end

    topPanel.navBar = vgui.Create( "Panel", topPanel )
	topPanel.navBar:Dock( BOTTOM )
	topPanel.navBar:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )

    -- Statistics
    local statsPanel = vgui.Create( "Panel", topPanel )
    statsPanel:Dock( FILL )

    local statistics = {
        ["cosmetics_purchased"] = {
            Title = PROJECT0.L( "cosmetics_purchased" ),
            YAxis = PROJECT0.L( "purchased" ),
            XAxis = PROJECT0.L( "weekday" ),
            GetData = function()
                local currentTime = PROJECT0.FUNC.UTCTime()

                local data = {}
                for i = 1, 7 do
                    data[i] = { 
                        i == 7 and PROJECT0.L( "today_day", os.date( "%a", currentTime ) ) or os.date( "%a", currentTime-((7-i)*86400) ), 
                        (PROJECT0.TEMP.CosmeticsPurchased or {})[i] or 0 
                    }
                end

                return data
            end
        }
    }

    statsPanel.RefreshStats = function( self2, type )
        local typeInfo = statistics[type]
        local data = typeInfo.GetData()

        self2:Clear()

        local outerBarW = 3
        local innerBarW = 2
        local barCount = 0
        for k, v in ipairs( data ) do
            barCount = math.max( barCount, v[2] )
        end

        local graphPanel = vgui.Create( "Panel", self2 )
        graphPanel:Dock( FILL )
        graphPanel.Paint = function( self2, w, h )
            draw.SimpleText( typeInfo.Title, "MontserratBold25", w/2, PROJECT0.UI.Margin25, PROJECT0.FUNC.GetTheme( 3, 100 ), TEXT_ALIGN_CENTER, 0 )
        end

        local bottomHeight = PROJECT0.FUNC.ScreenScale( 25 )

        local graphBottom = vgui.Create( "Panel", graphPanel )
        graphBottom:Dock( BOTTOM )
        graphBottom:SetTall( bottomHeight )
        graphBottom:DockMargin( PROJECT0.UI.Margin50, 0, PROJECT0.UI.Margin50, PROJECT0.UI.Margin50 )
        graphBottom.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )

            local xSectionW = w/#data
            for i = 1, #data do
                local sectionX = (i-1)*xSectionW

                surface.DrawRect( sectionX, 0, 2, PROJECT0.FUNC.ScreenScale( 10 ) )

                if( i == #data ) then
                    surface.DrawRect( sectionX+xSectionW-2, 0, 2, PROJECT0.FUNC.ScreenScale( 10 ) )
                end

                draw.SimpleText( data[i][1], "MontserratBold20", sectionX+xSectionW/2, h, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end
        end

        local graphTop = vgui.Create( "Panel", graphPanel )
        graphTop:Dock( FILL )
        graphTop:DockMargin( PROJECT0.UI.Margin50, PROJECT0.UI.Margin50, PROJECT0.UI.Margin50, 0 )

        local graphContent = vgui.Create( "Panel", graphTop )
        graphContent:Dock( FILL )
        graphContent.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
            surface.DrawRect( 0, 0, outerBarW, h )
            surface.DrawRect( 0, h-outerBarW, w, outerBarW )

            for i = 1, barCount-1 do
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
                surface.DrawRect( 0, i*(h/barCount)-(innerBarW/2), w, innerBarW )
            end

            local old = DisableClipping( true )
            for i = 0, barCount do
                local barNum = barCount-i

                local barY = (i*(h/barCount))-(innerBarW/2)
                if( i == 0 or i == barCount ) then
                    barY = i == 0 and 0 or h-innerBarW
                end

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
                surface.DrawRect( -5, barY, 5, innerBarW )

                draw.SimpleText( barNum, "MontserratBold20", -PROJECT0.UI.Margin15, barY, PROJECT0.FUNC.GetTheme( 3, 100 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
            end
            DisableClipping( old )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )

            local xSectionW = w/#data
            local columnW = xSectionW*0.6
            for i = 1, #data do
                local columnH = (data[i][2]/barCount)*h
                surface.DrawRect( ((i-1)*xSectionW)+xSectionW/2-columnW/2, h-columnH, columnW, columnH-outerBarW )
            end
        end
    end

    local statisticType = "cosmetics_purchased"
    statsPanel:RefreshStats( statisticType )

    hook.Add( "Project0.Hooks.CosmeticsPurchasedUpdated", statsPanel, function() statsPanel:RefreshStats( statisticType ) end )
    hook.Add( "Project0.Hooks.CustomiserMenuOpen", statsPanel, function() PROJECT0.FUNC.RequestCosmeticsPurchased() end )

    topPanel:AddPage( PROJECT0.L( "statistics" ), statsPanel )

    -- Weapons
    local weaponsPanel = vgui.Create( "Panel", topPanel )
    weaponsPanel:Dock( FILL )

    weaponsPanel.scroll = vgui.Create( "pz_horizontal_scrollpanel", weaponsPanel )
    weaponsPanel.scroll:Dock( FILL )
    --weaponsPanel.scroll:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
    weaponsPanel.scroll:SetBarBackColor( PROJECT0.FUNC.GetTheme( 1, 150 ) )
    weaponsPanel.scroll:SetBarColor( PROJECT0.FUNC.GetTheme( 3, 25 ) )
    weaponsPanel.scroll.screenX = 0
    weaponsPanel.scroll.Paint = function( self2, w, h )
        self2.screenX = self2:LocalToScreen( 0, 0 )
    end

    weaponsPanel.Refresh = function( self2 )
        self2.scroll:Clear()

        local weaponNum = 0
        for k, v in pairs( PROJECT0.FUNC.GetConfiguredWeapons() ) do
            weaponNum = weaponNum+1
            local currentWeaponNum = weaponNum

            local weaponEntry = vgui.Create( "Panel", self2.scroll )
            weaponEntry:Dock( LEFT )
            weaponEntry:SetWide( PROJECT0.FUNC.ScreenScale( 250 ) )
            weaponEntry:DockMargin( currentWeaponNum == 1 and PROJECT0.UI.Margin50 or PROJECT0.UI.Margin25, PROJECT0.UI.Margin50, 0, PROJECT0.UI.Margin50 )
            weaponEntry.Paint = function( self3, w, h )
                if( not IsValid( self3.coverButton ) ) then return end
                self3.coverButton:CreateFadeAlpha( 0.1, 50 )

                PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_dashwep_" .. currentWeaponNum, self2.scroll.screenX, 0, self2.scroll.screenX+self2.scroll:GetWide(), ScrH() )
                local x, y = self3:LocalToScreen( 0, 0 )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
                surface.DrawRect( x, y, w, h )
                PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_dashwep_" .. currentWeaponNum, x, y, 1, 1, 1, 100, 0, 0, false )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self3.coverButton.alpha ) )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                surface.DrawRect( 0, h-5, w, 5 )
    
                draw.SimpleText( v.Name, "MontserratBold20", w/2, h*0.75, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            local weaponButton = vgui.Create( "DButton", weaponEntry )
            weaponButton:Dock( FILL )
            weaponButton:SetText( "" )
            weaponButton.Paint = function() end
            weaponButton.DoClick = function( self2 )
                self:GetParent():SetActivePage( 2 ):OpenWeaponPage( k )
            end

            weaponEntry.coverButton = weaponButton
        end

        local spacer = vgui.Create( "Panel", self2.scroll )
        spacer:Dock( LEFT )
        spacer:SetWide( PROJECT0.UI.Margin50 )
    end
    weaponsPanel:Refresh()

    topPanel:AddPage( string.upper( PROJECT0.L( "weapons" ) ), weaponsPanel )

    -- Purchases
    local purchasesPanel = vgui.Create( "Panel", topPanel )
    purchasesPanel:Dock( FILL )
    purchasesPanel.Paint = function( self2, w, h )
        draw.SimpleText( PROJECT0.L( "recent_purchases" ), "MontserratBold35", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    topPanel:AddPage( PROJECT0.L( "purchases" ), purchasesPanel )

    topPanel:SetActivePage( 2 )
end

function PANEL:Paint( w, h )
    local x, y = self:LocalToScreen( 0, 0 )

    PROJECT0.FUNC.BeginShadow( "menu_dashboard_title" )
    draw.SimpleText( PROJECT0.L( "cosmetic_dashboard" ), "MontserratBold35", x+PROJECT0.UI.Margin50, y+PROJECT0.UI.Margin50, PROJECT0.FUNC.GetTheme( 3 ) )
    PROJECT0.FUNC.EndShadow( "menu_dashboard_title", x, y, 1, 1, 1, 100, 0, 0, false )

    PROJECT0.FUNC.BeginShadow( "menu_dashboard_description" )
    draw.SimpleText( PROJECT0.L( "statistics_information" ), "MontserratBold19", x+PROJECT0.UI.Margin50, y+PROJECT0.FUNC.ScreenScale( 80 ), PROJECT0.FUNC.GetTheme( 4 ) )
    PROJECT0.FUNC.EndShadow( "menu_dashboard_description", x, y, 1, 1, 1, 100, 0, 0, false )
end

vgui.Register( "pz_weaponcustomiser_page_dashboard", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
