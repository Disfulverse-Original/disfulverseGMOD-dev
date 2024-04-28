--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    
end

function PANEL:FillPanel()
    self.contentsPanel = vgui.Create( "Panel", self )
    self.contentsPanel:Dock( FILL )
    self.contentsPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.FUNC.ScreenScale( 120 ), PROJECT0.UI.Margin50, PROJECT0.UI.Margin50 )
    self.contentsPanel:SetSize( self:GetWide()-(2*PROJECT0.UI.Margin50), self:GetTall()-(PROJECT0.FUNC.ScreenScale( 120 )+PROJECT0.UI.Margin50) )

    self.weaponsPage = vgui.Create( "Panel", self.contentsPanel )
    self.weaponsPage:Dock( FILL )
    self.weaponsPage:SetVisible( true )

    self:CreateWeaponsPage()

    self.weaponViewPage = vgui.Create( "Panel", self.contentsPanel )
    self.weaponViewPage:Dock( FILL )
    self.weaponViewPage:SetVisible( false )

    hook.Add( "Project0.Hooks.OwnedSkinsUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.CosmeticInventoryUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.CustomisedWeaponsUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.ConfigUpdated", self, function() self:Refresh() end )
    
    --self:OpenWeaponPage( "m9k_m416" )
end

function PANEL:OpenWeaponsPage()
    self.weaponViewPage:SetVisible( false )
    self.weaponsPage:SetVisible( true )
end

function PANEL:CreateWeaponsPage()
    self.scrollPanel = vgui.Create( "pz_scrollpanel", self.weaponsPage )
    self.scrollPanel:Dock( FILL )
    self.scrollPanel:SetTall( self.contentsPanel:GetTall() )
    self.scrollPanel.screenY = 0
    self.scrollPanel.Paint = function( self2, w, h )
        self.scrollPanel.screenY = select( 2, self2:LocalToScreen( 0, 0 ) )
    end

    local spacing = PROJECT0.UI.Margin25
    local gridWide = self:GetWide()-(2*PROJECT0.UI.Margin50)-10-spacing
    local slotsWide = math.floor( gridWide/PROJECT0.FUNC.ScreenScale( 250 ) )
    self.slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    self.grid = vgui.Create( "DIconLayout", self.scrollPanel )
    self.grid:Dock( TOP )
    self.grid:SetSpaceY( spacing )
    self.grid:SetSpaceX( spacing )

    self:Refresh()
end

function PANEL:Refresh()
    self.grid:Clear()

    local weaponNum = 0
    for k, v in pairs( PROJECT0.FUNC.GetConfiguredWeapons() ) do
        weaponNum = weaponNum+1
        local currentWeaponNum = weaponNum

        local itemPanel = self.grid:Add( "DPanel" )
        itemPanel:SetSize( self.slotSize, self.slotSize*1.2 )
        itemPanel.Paint = function( self2, w, h )
            if( not IsValid( self2.itemButton ) ) then return end
            self2.itemButton:CreateFadeAlpha( 0.1, 50 )

            PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_armoryitem_" .. currentWeaponNum, 0, self.scrollPanel.screenY, ScrW(), self.scrollPanel.screenY+self.scrollPanel:GetTall() )
            local x, y = self2:LocalToScreen( 0, 0 )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
            surface.DrawRect( x, y, w, h )
            PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_armoryitem_" .. currentWeaponNum, x, y, 1, 1, 1, 255, 0, 0, false )

            --PROJECT0.FUNC.DrawClickPolygon( self2.itemButton, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.itemButton.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.DrawRect( 0, h-5, w, 5 )

            draw.SimpleText( v.Name, "MontserratBold25", w/2, h*0.85+2, PROJECT0.FUNC.GetTheme( 3, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( v.Class, "MontserratBold18", w/2, h*0.85-2, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, 0 )
        end

        local modelPanel = vgui.Create( "pz_modelpanel", itemPanel )
        modelPanel:Dock( TOP )
        modelPanel:SetTall( itemPanel:GetTall()*0.75 )
        modelPanel:SetCursor( "pointer" )
        modelPanel:SetFOV( 50 )
        modelPanel:ChangeModel( v.Model )

        local equippedSkin = LocalPlayer():Project0():GetEquippedCosmetic( "Skin", k )
        local skinPath = (PROJECT0.DEVCONFIG.WeaponSkins[equippedSkin] or {}).Material
        if( skinPath ) then
            for k, v in ipairs( v.Skin.WorldModelMats ) do
                modelPanel.Entity:SetSubMaterial( v, skinPath )
            end
        end

        local infoRow = vgui.Create( "Panel", itemPanel )
        infoRow:SetSize( itemPanel:GetWide()-(2*PROJECT0.UI.Margin10), PROJECT0.FUNC.ScreenScale( 30 ) )
        infoRow:SetPos( PROJECT0.UI.Margin10, PROJECT0.UI.Margin10 )
        infoRow.AddInfo = function( self2, rarity )
            local count = #self2:GetChildren()+1

            local infoPanel = vgui.Create( "Panel", self2 )
            infoPanel:Dock( RIGHT )
            infoPanel:SetWide( self2:GetTall() )
            infoPanel:DockMargin( PROJECT0.UI.Margin10, 0, 0, 0 )
            infoPanel.Paint = function( self2, w, h )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
                surface.DrawRect( 0, 0, w, h )

                for k, v in pairs( self2.childrenToDraw ) do
                    v:PaintManual()
                end

                local borderW, borderH = math.floor( w*0.4 ), 2
                local x, y = self2:LocalToScreen( 0, 0 )
                PROJECT0.FUNC.BeginShadow( "menu_infopanel_border_" .. currentWeaponNum .. "_" .. count )
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
                surface.DrawRect( x, y, borderW, borderH )
                surface.DrawRect( x, y+borderH, borderH, borderW-borderH )
                surface.DrawRect( x+w-borderW, y+h-borderH, borderW, borderH )
                surface.DrawRect( x+w-borderH, y+h-borderW, borderH, borderW-borderH )
                PROJECT0.FUNC.EndShadow( "menu_infopanel_border_" .. currentWeaponNum .. "_" .. count, x, y, 1, 1, 1, 255, 0, 0, false )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
                surface.DrawRect( 0, 0, borderW, borderH )
                surface.DrawRect( 0, borderH, borderH, borderW-borderH )
                surface.DrawRect( w-borderW, h-borderH, borderW, borderH )
                surface.DrawRect( w-borderH, h-borderW, borderH, borderW-borderH )

                if( not IsValid( self2.gradientAnim ) ) then return end

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
                surface.DrawRect( 0, 0, borderW, borderH )
                surface.DrawRect( 0, 0, borderH, borderW )
                surface.DrawRect( w-borderW, h-borderH, borderW, borderH )
                surface.DrawRect( w-borderH, h-borderW, borderH, borderW )
            
                render.SetStencilFailOperation( STENCILOPERATION_ZERO )
                render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
                render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
                render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
                render.SetStencilReferenceValue( 1 )
            
                self2.gradientAnim:PaintManual()
            
                render.SetStencilEnable( false )
                render.ClearStencil()
            end

            if( rarity and PROJECT0.CONFIG.GENERAL.Rarities[rarity] ) then
                local rarityConfig = PROJECT0.CONFIG.GENERAL.Rarities[rarity]

                local gradientAnim = vgui.Create( "pz_gradientanim", infoPanel )
                gradientAnim:SetSize( PROJECT0.FUNC.Repeat( infoPanel:GetWide(), 2 ) )
                gradientAnim:SetAnimSize( infoPanel:GetWide()*6 )
                gradientAnim:SetColors( unpack( rarityConfig.Colors ) )
                gradientAnim:StartAnim()
                gradientAnim:SetPaintedManually( true )

                infoPanel.gradientAnim = gradientAnim
            end

            infoPanel.childrenToDraw = {}
            infoPanel.OnChildAdded = function( self2, pnl )
                pnl:SetPaintedManually( true )
                table.insert( self2.childrenToDraw, pnl )
            end

            return infoPanel
        end

        -- Skin Info
        local equippedSkin = LocalPlayer():Project0():GetEquippedCosmetic( "Skin", k )
        local devConfig = PROJECT0.DEVCONFIG.WeaponSkins[equippedSkin]

        local skinInfo = infoRow:AddInfo( PROJECT0.FUNC.GetSkinRarity( equippedSkin ) )
        if( devConfig ) then
            local skinTexture = vgui.Create( "DImage", skinInfo )
            skinTexture:Dock( FILL )
            skinTexture:SetMaterial( devConfig.Icon )
        end

        -- Charm Info
        local equippedCharm = LocalPlayer():Project0():GetEquippedCosmetic( "Charm", k )
        local charmConfig = PROJECT0.CONFIG.CUSTOMISER.Charms[equippedCharm]

        local charmInfo = infoRow:AddInfo( (charmConfig or {}).Rarity )
        if( charmConfig ) then
            local modelPanel = vgui.Create( "pz_modelpanel", charmInfo )
            modelPanel:Dock( FILL )
            modelPanel:SetFOV( 30 )
            modelPanel:ChangeModel( charmConfig.Model )
        end

        -- Sticker Info
        local equippedSticker = LocalPlayer():Project0():GetEquippedCosmetic( "Sticker", k )
        local stickerConfig = PROJECT0.CONFIG.CUSTOMISER.Stickers[equippedSticker]

        local stickerInfo = infoRow:AddInfo( (stickerConfig or {}).Rarity )
        if( stickerConfig ) then
            local skinTexture = vgui.Create( "pz_imagepanel", stickerInfo )
            skinTexture:Dock( FILL )
            skinTexture:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin5, 4 ) )
            skinTexture:SetImagePath( stickerConfig.Icon )
        end

        local itemButton = vgui.Create( "DButton", itemPanel )
        itemButton:SetSize( itemPanel:GetSize() )
        itemButton:SetText( "" )
        itemButton.Paint = function() end
        itemButton.DoClick = function( self2 )
            self:OpenWeaponPage( k )
        end

        itemPanel.itemButton = itemButton
    end
end

function PANEL:OpenWeaponPage( weaponClass )
    self.weaponViewPage:Clear()

    self.weaponsPage:SetVisible( false )
    self.weaponViewPage:SetVisible( true )

    local weaponViewPanel = vgui.Create( "pz_weaponcustomiser_page_armory_view", self.weaponViewPage )
    weaponViewPanel:Dock( FILL )
    weaponViewPanel:SetWeaponClass( weaponClass )

    local iconMat = Material( "project0/icons/back.png" )

    local backButton = vgui.Create( "DButton", self.weaponViewPage )
    backButton:SetPos( 0, 0 )
    backButton:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 40 ), 2 ) )
    backButton:SetText( "" )
    backButton.Paint = function( self2, w, h )
        if( self2:IsHovered() ) then
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)+5, 0, 100 )
        else
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)-5, 0, 100 )
        end

        PROJECT0.FUNC.BeginShadow( "menu_btn_back" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_btn_back", x, y, 1, 1, 1, 255, 0, 0, false )

        local hoverPercent = self2.hoverPercent/100
        local offset = PROJECT0.FUNC.ScreenScale( 15 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.NoTexture()
        surface.DrawPoly( {
            { x = 0, y = 0 },
            { x = hoverPercent*((w/2)+(offset/2)), y = 0 },
            { x = hoverPercent*(w/2)-(offset/2), y = h },
            { x = 0, y = h }
        } )
        surface.DrawPoly( {
            { x = w-hoverPercent*(w/2)+(offset/2), y = 0 },
            { x = w, y = 0 },
            { x = w, y = h },
            { x = w-hoverPercent*((w/2)+(offset/2)), y = h },
        } )

        local iconSize = PROJECT0.FUNC.ScreenScale( 24 )
        
        surface.SetMaterial( iconMat )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 200+(55*hoverPercent) ) )
        surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
    end
    backButton.DoClick = function()
        self:OpenWeaponsPage()
    end

    self.openingWeaponPage = false
end

function PANEL:Paint( w, h )
    local x, y = self:LocalToScreen( 0, 0 )

    PROJECT0.FUNC.BeginShadow( "menu_armory_title" )
    draw.SimpleText( PROJECT0.L( "weapon_armory" ), "MontserratBold35", x+PROJECT0.UI.Margin50, y+PROJECT0.UI.Margin50, PROJECT0.FUNC.GetTheme( 3 ) )
    PROJECT0.FUNC.EndShadow( "menu_armory_title", x, y, 1, 1, 1, 100, 0, 0, false )

    PROJECT0.FUNC.BeginShadow( "menu_armory_description" )
    draw.SimpleText( PROJECT0.L( "select_weapon" ), "MontserratBold19", x+PROJECT0.UI.Margin50, y+PROJECT0.FUNC.ScreenScale( 80 ), PROJECT0.FUNC.GetTheme( 4 ) )
    PROJECT0.FUNC.EndShadow( "menu_armory_description", x, y, 1, 1, 1, 100, 0, 0, false )
end

vgui.Register( "pz_weaponcustomiser_page_armory", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
