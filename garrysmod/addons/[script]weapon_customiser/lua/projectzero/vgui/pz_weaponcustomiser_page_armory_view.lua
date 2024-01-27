--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    local modelPanel = vgui.Create( "DModelPanel", self )
    modelPanel:Dock( FILL )
    modelPanel:DockMargin( PROJECT0.UI.Margin100, PROJECT0.UI.Margin100, 0, 0 )
    modelPanel.LayoutEntity = function() end
    modelPanel.Think = function( self2 )
        if( not input.IsMouseDown( MOUSE_LEFT ) ) then
            self2.isDragging = false
        end

        if( self2.isDragging ) then
            local angles = modelPanel.Entity:GetAngles()
            modelPanel.Entity:SetAngles( Angle( angles[1], self2.startRotation+(gui.MouseX()-self2.mouseStartX)/2, angles[3] ) )
        end
    end
    modelPanel.OnMousePressed = function( self2 )
        self2.mouseStartX = gui.MouseX()
        self2.startRotation = modelPanel.Entity:GetAngles()[2]
        self2.isDragging = true
    end
    modelPanel.OnMouseReleased = function( self2 )
        self2.isDragging = false
    end
    modelPanel.OnMouseWheeled = function( self2, delta )
        self2.currentZoom = math.Clamp( (self2.currentZoom or -75)+(delta*10), -200, -75 )
        self2:SetCamPos( Vector( self2.currentZoom, 0, 0 ) )
    end

    self.trinketBaseEnt = ClientsideModel( "models/sterling/smodel_w_tinket.mdl", RENDERGROUP_OTHER )
    self.trinketBaseEnt:SetNoDraw( true )
    self.trinketBaseEnt:SetIK( false )

    modelPanel.OnRemove = function( self2 )
        if( IsValid( self.trinketBaseEnt ) ) then
            self.trinketBaseEnt:Remove()
        end

        if( IsValid( self.trinketEnt ) ) then
            self.trinketEnt:Remove()
        end
    end

    self.modelPanel = modelPanel
end

function PANEL:UpdateModel()
    local weaponConfig = self.configTable
    self.modelPanel:SetModel( weaponConfig.Model )

    local modelEnt = self.modelPanel.Entity
    if( not IsValid( modelEnt ) ) then return end

    local mn, mx = modelEnt:GetRenderBounds()

    self.modelPanel:SetCamPos( Vector( -75, 0, 0 ) )
    self.modelPanel:SetLookAt( Vector( 0, 0, 0 ) )
    modelEnt:SetAngles( Angle( 0, 90, 0 ) )

    local equippedSkin = LocalPlayer():Project0():GetEquippedCosmetic( "Skin", self.weaponClass )
    local skinPath = (PROJECT0.DEVCONFIG.WeaponSkins[equippedSkin] or {}).Material
    if( skinPath ) then
        for k, v in ipairs( weaponConfig.Skin.WorldModelMats ) do
            modelEnt:SetSubMaterial( v, skinPath )
        end
    end

    local equippedSticker = LocalPlayer():Project0():GetEquippedCosmetic( "Sticker", self.weaponClass )

    local stickerMat
    if( equippedSticker and PROJECT0.CONFIG.CUSTOMISER.Stickers[equippedSticker] ) then
        PROJECT0.FUNC.GetImage( PROJECT0.CONFIG.CUSTOMISER.Stickers[equippedSticker].Icon, function( mat )
            stickerMat = mat
        end )
    end

    local worldPos = weaponConfig.Charm.WorldModelPos
    local stickerSize = 50
    self.modelPanel.PostDrawModel = function( self2, ent )
        -- Trinkets
        if( IsValid( self.trinketBaseEnt ) ) then 
            self.trinketBaseEnt:DrawModel()
            self.trinketBaseEnt:SetAngles( ent:GetAngles()+weaponConfig.Charm.WorldModelAngle )
            self.trinketBaseEnt:SetPos( ent:GetPos()+(ent:GetForward()*worldPos[1])+(ent:GetRight()*worldPos[2])+(ent:GetUp()*worldPos[3]) )

            if( IsValid( self.trinketEnt ) ) then 
                local trinketAttachment = self.trinketBaseEnt:GetAttachment( 2 )
                if( trinketAttachment ) then 
                    self.trinketEnt:DrawModel()
                    self.trinketEnt:SetPos( trinketAttachment.Pos )
                    --self.trinketEnt:SetAngles( trinketAttachment.Ang+Angle( -90, 0, 0 ) )
                end
            end
        end

        -- Stickers
        if(true) then return end
        local Pos = ent:GetPos()
        local Ang = ent:GetAngles()

        Ang:RotateAroundAxis(Ang:Up(), 0)
        Ang:RotateAroundAxis(Ang:Forward(), 90)
        Ang:RotateAroundAxis(Ang:Right(), 180)

        -- TODO: 3d2d position is affected by panel size (e.g. changing the screen resolution)
        local old = DisableClipping( true )
        cam.Start3D2D( Pos+(Ang:Forward()*-36.25)+(Ang:Right()*-22)+(Ang:Up()*1.1), Ang, 0.05 )
            if( stickerMat ) then
                surface.SetDrawColor( 255, 255, 255 )
                surface.SetMaterial( stickerMat )
                surface.DrawTexturedRect( 0, 0, stickerSize, stickerSize )
            else
                surface.SetDrawColor( 255, 0, 0 )
                surface.DrawRect( 0, 0, stickerSize, stickerSize )
    
                surface.SetDrawColor( 255, 255, 255 )
                surface.DrawOutlinedRect( 0, 0, stickerSize, stickerSize )
                surface.DrawOutlinedRect( 1, 1, stickerSize-2, stickerSize-2 )
    
                draw.SimpleText( "THIS", "MontserratBold25", stickerSize/2, stickerSize/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
                draw.SimpleText( "WAY", "MontserratBold25", stickerSize/2, stickerSize/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, 0 )
            end
        cam.End3D2D()
        DisableClipping( old )
    end

    if( IsValid( self.trinketEnt ) ) then
        self.trinketEnt:Remove()
    end

    local equippedCharm = LocalPlayer():Project0():GetEquippedCosmetic( "Charm", self.weaponClass )
    local charmConfig = PROJECT0.CONFIG.CUSTOMISER.Charms[equippedCharm]

    if( not charmConfig ) then return end

    self.trinketEnt = ClientsideModel( charmConfig.Model, RENDERGROUP_OTHER )
    self.trinketEnt:SetParent( self.trinketBaseEnt )
    self.trinketEnt:SetNoDraw( true )
    self.trinketEnt:SetIK( false )
    self.trinketEnt:SetModelScale( 0.5 )
end

function PANEL:SetWeaponClass( weaponClass )
    self.weaponClass = weaponClass
    self.configTable = PROJECT0.FUNC.GetConfiguredWeapon( weaponClass )

    if( not self.configTable ) then return end

    local customisePanel = vgui.Create( "Panel", self )
    customisePanel:Dock( BOTTOM )
    customisePanel:SetTall( ScrH()*0.17 )
    customisePanel.Paint = function( self2, w, h )
        if( not IsValid( self2.navigation ) ) then return end

        local x, y = self2:LocalToScreen( 0, 0 )
        local navTall = self2.navigation:GetTall()

        PROJECT0.FUNC.BeginShadow( "menu_armory_bottom" )
        PROJECT0.FUNC.SetShadowSize( "menu_armory_bottom", (self2.navigation.totalButtonW or 0), h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, (self2.navigation.totalButtonW or 0), navTall )
        surface.DrawRect( x, y+navTall, w, h-navTall )
        PROJECT0.FUNC.EndShadow( "menu_armory_bottom", x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 25 ) )
        surface.DrawRect( 0, 0, (self2.navigation.totalButtonW or 0), navTall )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
        surface.DrawRect( 0, navTall, w, h-navTall )
    end

    customisePanel.navigation = vgui.Create( "Panel", customisePanel )
    customisePanel.navigation:Dock( TOP )
    customisePanel.navigation:SetTall( PROJECT0.FUNC.ScreenScale( 45 ) )
    customisePanel.navigation.pages = {}
    customisePanel.navigation.AddPage = function( self2, title, iconMat )
        local iconSize = PROJECT0.FUNC.ScreenScale( 24 )

        surface.SetFont( "MontserratBold25" )
        local textX = surface.GetTextSize( title )

        local contentW = iconSize+PROJECT0.UI.Margin5+textX

        local pageKey = #self2.pages+1

        local pageButton = vgui.Create( "DButton", self2 )
        pageButton:Dock( LEFT )
        pageButton:SetWide( PROJECT0.FUNC.ScreenScale( 170 ) )
        pageButton:SetText( "" )
        pageButton.Paint = function( self3, w, h )
            self3:CreateFadeAlpha( 0.2, 50, false, false, self2.activePage == pageKey, 75 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, self3.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetMaterial( iconMat )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.DrawTexturedRect( w/2-contentW/2, h/2-iconSize/2, iconSize, iconSize )

            draw.SimpleText( title, "MontserratBold25", w/2+contentW/2, h/2, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end
        pageButton.DoClick = function()
            self2:SetPage( pageKey )
        end

        self2.totalButtonW = (self2.totalButtonW or 0)+pageButton:GetWide()

        local panel = vgui.Create( "pz_horizontal_scrollpanel", customisePanel.contents )
        panel:Dock( FILL )
        panel:SetVisible( false )

        table.insert( self2.pages, panel )

        return panel
    end
    customisePanel.navigation.SetPage = function( self2, pageKey )
        if( self2.activePage ) then
            self2.pages[self2.activePage]:SetVisible( false )
        end

        self2.activePage = pageKey
        self2.pages[pageKey]:SetVisible( true )
    end

    customisePanel.contents = vgui.Create( "Panel", customisePanel )
    customisePanel.contents:Dock( FILL )

    local cosmeticPages = {
        {
            Name = PROJECT0.L( "skins" ),
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" ),
            CosmeticKey = "Skin",
            GetOwnedItems = function()
                local items = {}
                for k, v in pairs( LocalPlayer():Project0():GetOwnedSkins() ) do
                    if( not v["*"] and not v[weaponClass] ) then continue end
            
                    local devConfig = PROJECT0.DEVCONFIG.WeaponSkins[k]
                    if( not devConfig ) then continue end

                    table.insert( items, { PROJECT0.FUNC.GetSkinRarity( k ), k } )
                end

                return items
            end,
            OnItemClick = function( data, unselected )
                net.Start( "Project0.RequestEquipSkin" )
                    net.WriteUInt( unselected and 0 or data[2], 8 )
                    net.WriteString( weaponClass )
                net.SendToServer()
            end,
            OnCreatePnl = function( pnl, data )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                skinTexture:SetImagePath( PROJECT0.DEVCONFIG.WeaponSkins[data[2]].Icon )
            end
        },
        {
            Name = PROJECT0.L( "charms" ),
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" ),
            CosmeticKey = "Charm",
            GetOwnedItems = function()
                local items = {}
                for k, v in pairs( LocalPlayer():Project0():GetCosmeticInventory() ) do
                    local type, itemKey = PROJECT0.FUNC.ReverseCosmeticKey( k )
                    if( type != PROJECT0.COSMETIC_TYPES.CHARM ) then continue end
            
                    local configTable = PROJECT0.CONFIG.CUSTOMISER.Charms[itemKey]
                    if( not configTable ) then continue end

                    table.insert( items, { configTable.Rarity, itemKey } )
                end

                return items
            end,
            OnItemClick = function( data, unselected )
                net.Start( "Project0.RequestEquipCharm" )
                    net.WriteUInt( unselected and 0 or data[2], 8 )
                    net.WriteString( weaponClass )
                net.SendToServer()
            end,
            OnCreatePnl = function( pnl, data )
                local modelPanel = vgui.Create( "pz_modelpanel", pnl )
                modelPanel:Dock( FILL )
                modelPanel:SetFOV( 30 )
                modelPanel:ChangeModel( PROJECT0.CONFIG.CUSTOMISER.Charms[data[2]].Model )
            end,
            IsDisabled = self.configTable.Charm.Disabled
        },
        {
            Name = PROJECT0.L( "stickers" ),
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" ),
            CosmeticKey = "Sticker",
            GetOwnedItems = function()
                local items = {}
                for k, v in pairs( LocalPlayer():Project0():GetCosmeticInventory() ) do
                    local type, itemKey = PROJECT0.FUNC.ReverseCosmeticKey( k )
                    if( type != PROJECT0.COSMETIC_TYPES.STICKER ) then continue end
            
                    local configTable = PROJECT0.CONFIG.CUSTOMISER.Stickers[itemKey]
                    if( not configTable ) then continue end
            
                    table.insert( items, { configTable.Rarity, itemKey } )
                end

                return items
            end,
            OnItemClick = function( data, unselected )
                net.Start( "Project0.RequestEquipSticker" )
                    net.WriteUInt( unselected and 0 or data[2], 8 )
                    net.WriteString( weaponClass )
                net.SendToServer()
            end,
            OnCreatePnl = function( pnl, data )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                local margin = PROJECT0.UI.Margin10
                local heightMargin = ((pnl:GetWide()*1.2)-pnl:GetWide())/2+margin
                skinTexture:DockMargin( margin, heightMargin, margin, heightMargin )
                skinTexture:SetImagePath( PROJECT0.CONFIG.CUSTOMISER.Stickers[data[2]].Icon )
            end,
            IsDisabled = self.configTable.Sticker.Disabled
        }
    }

    local createdCosmeticPages = {}
    for k, v in ipairs( cosmeticPages ) do
        createdCosmeticPages[k] = customisePanel.navigation:AddPage( v.Name, v.Icon )
    end

    customisePanel.navigation:SetPage( 1 )

    local itemPanels
    local function RefreshCosmetics()
        itemPanels = {}

        for k, v in ipairs( cosmeticPages ) do
            local page = createdCosmeticPages[k]
            page:Clear()

            page.Paint = function( self2, w, h )
                if( (self2.actualW or 0) == w ) then return end
                self2.actualW = w
    
                local startX = self2:LocalToScreen( 0, 0 )
                for k, v in ipairs( self2.pnlCanvas:GetChildren() ) do
                    if( not v.SetShadowBounds ) then continue end
                    v:SetShadowBounds( startX, 0, startX+w, ScrH() )
                end
            end

            if( v.IsDisabled ) then
                page.Paint = function( self2, w, h )
                    draw.SimpleText( PROJECT0.L( "disabled" ), "MontserratBold25", w/2, h/2+2, PROJECT0.DEVCONFIG.Colours.LightRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
                    draw.SimpleText( PROJECT0.L( "disabled_on_weapon", v.Name ), "MontserratBold21", w/2, h/2-2, PROJECT0.FUNC.GetTheme( 3, 100 ), TEXT_ALIGN_CENTER, 0 )
                end

                continue
            end

            local startX = page:LocalToScreen( 0, 0 )

            local items = v.GetOwnedItems()
            table.sort( items, function(a, b) return PROJECT0.FUNC.GetRarityOrder( a[1] ) > PROJECT0.FUNC.GetRarityOrder( b[1] ) end )

            itemPanels[v.CosmeticKey] = {}

            local equippedCosmetic = LocalPlayer():Project0():GetEquippedCosmetic( v.CosmeticKey, weaponClass )
            for _, val in ipairs( items ) do
                local infoPanel = vgui.Create( "pz_cosmetic_item", page )
                infoPanel:Dock( LEFT )
                infoPanel:SetTall( customisePanel:GetTall()-customisePanel.navigation:GetTall()-(2*PROJECT0.UI.Margin25) )
                infoPanel:SetWide( infoPanel:GetTall()/1.2 )
                infoPanel:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, PROJECT0.UI.Margin25 )
                infoPanel:SetRarity( val[1] )
                infoPanel:SetShadowBounds( startX, 0, startX+(page.actualW or 0), ScrH() )
                infoPanel.DoClick = function()
                    v.OnItemClick( val )
                end

                if( equippedCosmetic == val[2] ) then
                    infoPanel:SetActive( true, true )
                end

                v.OnCreatePnl( infoPanel, val )
                
                table.insert( itemPanels[v.CosmeticKey], { infoPanel, val[2] } )
            end

            local unselectedPanel = vgui.Create( "pz_cosmetic_item", page )
            unselectedPanel:Dock( LEFT )
            unselectedPanel:SetTall( customisePanel:GetTall()-customisePanel.navigation:GetTall()-(2*PROJECT0.UI.Margin25) )
            unselectedPanel:SetWide( unselectedPanel:GetTall()/1.2 )
            unselectedPanel:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, PROJECT0.UI.Margin25 )
            unselectedPanel:SetShadowBounds( startX, 0, startX+(page.actualW or 0), ScrH() )
            unselectedPanel.gradientAnim:SetColors( PROJECT0.FUNC.GetTheme( 3, 100 ) )
            unselectedPanel.gradientAnim:StartAnim()
            unselectedPanel.DoClick = function()
                v.OnItemClick( val, true )
            end

            if( equippedCosmetic == 0 ) then
                unselectedPanel:SetActive( true, true )
            end

            table.insert( itemPanels[v.CosmeticKey], { unselectedPanel, 0 } )
            
            local unselectedIcon = vgui.Create( "Panel", unselectedPanel )
            unselectedIcon:Dock( FILL )
            local iconMat = Material( "project0/icons/blank.png" )
            unselectedIcon.Paint = function( self2, w, h )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 25 ) )
                surface.SetMaterial( iconMat )
                local iconSize = PROJECT0.FUNC.ScreenScale( 64 )
                surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
            end

            local spacingPanel = vgui.Create( "Panel", page )
            spacingPanel:Dock( LEFT )
            spacingPanel:SetWide( PROJECT0.UI.Margin25 )
        end
    end
    RefreshCosmetics()

    hook.Add( "Project0.Hooks.OwnedSkinsUpdated", self, RefreshCosmetics )
    hook.Add( "Project0.Hooks.CosmeticInventoryUpdated", self, RefreshCosmetics )

    hook.Add( "Project0.Hooks.CustomisedWeaponsUpdated", self, function()
        for k, v in pairs( itemPanels ) do
            local equippedKey = LocalPlayer():Project0():GetEquippedCosmetic( k, weaponClass )
            for _, val in ipairs( v ) do
                val[1]:SetActive( equippedKey == val[2] )
            end
        end

        self:UpdateModel()
    end )

    self:UpdateModel()
end

vgui.Register( "pz_weaponcustomiser_page_armory_view", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
