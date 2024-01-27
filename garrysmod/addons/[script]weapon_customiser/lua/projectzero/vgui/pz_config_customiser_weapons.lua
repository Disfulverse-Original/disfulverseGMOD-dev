--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:FillPanel()
    self:CreateScrollPanel()
end

function PANEL:CreateCategoryPanel( uniqueID, title, categoryDisabled, headerDoClick )
    local tickMat = Material( "project0/icons/tick.png", "noclamp smooth" )
    local arrowMat = Material( "project0/icons/down.png", "noclamp smooth" )
    local iconSize = PROJECT0.FUNC.ScreenScale( 20 )
    local headerTall = PROJECT0.FUNC.ScreenScale( 40 )

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

        local anim = self2:NewAnimation( 0.2, 0, -1 )
    
        anim.Think = function( anim, pnl, fraction )
            if( expanded ) then
                self2.textureRotation = (1-fraction)*-90
            else
                self2.textureRotation = fraction*-90
            end
        end
    end
    categoryPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "config_weapons_category_" .. uniqueID, 0, self.scrollPanelY, ScrW(), self.scrollPanelY+self.scrollPanel:GetTall() )
        PROJECT0.FUNC.SetShadowSize( "config_weapons_category_" .. uniqueID, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "config_weapons_category_" .. uniqueID, x, y, 1, 1, 1, 100, 0, 0, false )
        
        if( (self2.actualW or 0) == w ) then return end
        self2.actualW = w
    end

    local headerPanel = vgui.Create( "Panel", categoryPanel )
    headerPanel:Dock( TOP )
    headerPanel:SetTall( headerTall )
    headerPanel.Paint = function( self2, w, h )
        if( not IsValid( self2.button ) ) then return end
        self2.button:CreateFadeAlpha( 0.2, 100 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( 0, 0, w, h )

        PROJECT0.FUNC.DrawClickPolygon( self2.button, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75+self2.button.alpha ) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.SetMaterial( arrowMat )
        surface.DrawTexturedRectRotated(w-h/2, h/2, iconSize, iconSize, math.Clamp( (categoryPanel.textureRotation or -90), -90, 0 ) )

        -- Fancy Stuff
        local boxH = h*0.7
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 155 ) )
        surface.DrawRect( h/2-boxH/2, h/2-boxH/2, boxH, boxH )

        if( not categoryDisabled ) then
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.SetMaterial( tickMat )
            surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
        end

        draw.SimpleText( string.upper( title ), "MontserratBold20", h+PROJECT0.UI.Margin5, h/2-1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_CENTER )
    end

    headerPanel.button = vgui.Create( "DButton", headerPanel )
    headerPanel.button:Dock( FILL )
    headerPanel.button:SetText( "" )
    headerPanel.button.Paint = function() end
    headerPanel.button.DoClick = function( self2 )
        if( headerDoClick ) then
            headerDoClick( categoryPanel )
            return
        end

        categoryPanel:SetExpanded( not categoryPanel.expanded )
    end

    return categoryPanel
end

function PANEL:CreateWeaponPanel( parent, name, class, model )
    name = string.upper( name )

    local weaponEntry = vgui.Create( "Panel", parent )
    weaponEntry:Dock( TOP )
    weaponEntry:SetTall( PROJECT0.FUNC.ScreenScale( 75 ) )
    weaponEntry:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
    local modelBackH = weaponEntry:GetTall()-(2*PROJECT0.UI.Margin10)
    weaponEntry.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 25 ) )
        surface.DrawRect( 0, 0, w, h )

        -- Fancy Stuff
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 155 ) )
        surface.DrawRect( h/2-modelBackH/2, h/2-modelBackH/2, modelBackH, modelBackH )

        draw.SimpleText( name, "MontserratBold22", h+PROJECT0.UI.Margin5, h/2+2, PROJECT0.FUNC.GetTheme( 3, 100 ), 0, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( class, "MontserratBold20", h+PROJECT0.UI.Margin5, h/2-2, PROJECT0.FUNC.GetTheme( 4 ), 0, 0 )
    end
    local topMargin = (weaponEntry:GetTall()-PROJECT0.FUNC.ScreenScale( 30 ))/2
    weaponEntry.AddButton = function( self2, iconMat, doClick )
        local entryButton = vgui.Create( "DButton", self2 )
        entryButton:Dock( RIGHT )
        entryButton:DockMargin( 0, topMargin, topMargin, topMargin )
        entryButton:SetWide( PROJECT0.FUNC.ScreenScale( 30 ) )
        entryButton:SetText( "" )
        entryButton.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 100 )

            -- Background
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
            surface.DrawRect( 0, 0, w, h )

            -- Border and hover effects
            local borderR = 2
            local borderL = PROJECT0.FUNC.ScreenScale( 10 )

            local hoverPercent = self2.alpha/100
            local borderW = borderL+((w-borderL)*hoverPercent)
            local borderH = borderL+((h-borderL)*hoverPercent)

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, hoverPercent*100 ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.DrawRect( 0, 0, borderW, borderR )
            surface.DrawRect( 0, 0, borderR, borderH )
            surface.DrawRect( w-borderW, h-borderR, borderW, borderR )
            surface.DrawRect( w-borderR, h-borderH, borderR, borderH )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.SetMaterial( iconMat )
            local iconSize = PROJECT0.FUNC.ScreenScale( 18 )
            surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize)
        end
        entryButton.DoClick = doClick
    end

    local modelPanel = vgui.Create( "pz_modelpanel", weaponEntry )
    modelPanel:Dock( LEFT )
    modelPanel:SetWide( modelBackH )
    modelPanel:DockMargin( PROJECT0.FUNC.Repeat( (weaponEntry:GetTall()-modelBackH)/2, 4 ) )
    modelPanel:SetCursor( "pointer" )
    modelPanel:SetFOV( 35 )
    modelPanel:ChangeModel( model or "" )

    return weaponEntry
end

function PANEL:Refresh()
    self.scrollPanel:Clear()

    local values = PROJECT0.FUNC.GetChangedVariable( "CUSTOMISER", "Weapons" ) or PROJECT0.CONFIGMETA.CUSTOMISER:GetConfigValue( "Weapons" )

    local editMat = Material( "project0/icons/edit.png", "noclamp smooth" )
    local deleteMat = Material( "project0/icons/delete.png", "noclamp smooth" )

    local weaponsList = {}
    for k, weaponPack in pairs( table.Copy( PROJECT0.TEMP.WeaponPacks ) ) do
		for weaponClass, weaponData in pairs( weaponPack.Weapons ) do
			weaponsList[weaponClass] = weaponData
		end

        local function getEnabledWeapons()
            local enabledWeapons = 0
            for k, v in pairs( weaponPack.Weapons ) do
                if( values[k] and values[k].Disabled ) then continue end
                enabledWeapons = enabledWeapons+1
            end

            return enabledWeapons
        end

        local categoryDisabled = getEnabledWeapons() == 0
        local categoryPanel = self:CreateCategoryPanel( k, weaponPack.Title, categoryDisabled, function( self2 )
            if( not categoryDisabled ) then
                self2:SetExpanded( not self2.expanded )
            else
                for weaponClass, weaponData in pairs( weaponPack.Weapons ) do
                    values[weaponClass] = nil
                end
    
                PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Weapons", values )
                self:Refresh()
            end
        end )

        if( categoryDisabled ) then continue end

        for weaponClass, weaponData in pairs( weaponPack.Weapons ) do
            local weaponEntry = self:CreateWeaponPanel( categoryPanel, weaponData.Name, weaponClass, weaponData.Model )

            local topMargin = (weaponEntry:GetTall()-PROJECT0.FUNC.ScreenScale( 30 ))/2
            local checkBox = vgui.Create( "pz_checkbox", weaponEntry )
            checkBox:Dock( RIGHT )
            checkBox:DockMargin( 0, topMargin, topMargin, topMargin )
            checkBox:SetWide( PROJECT0.FUNC.ScreenScale( 30 ) )
            checkBox:SetValue( not (values[weaponClass] or {}).Disabled )	
            checkBox:DisableShadows( true )
            checkBox.OnChange = function( self2, value )
                if( value ) then
                    values[weaponClass] = nil
                else
                    values[weaponClass] = { Disabled = true }
                end

                PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Weapons", values )

                if( getEnabledWeapons() == 0 ) then
                    self:Refresh()
                end
            end
            
            weaponEntry:AddButton( editMat, function()
                local oldWeaponValues = values[weaponClass]
                values[weaponClass] = oldWeaponValues or table.Copy( PROJECT0.FUNC.GetConfiguredWeapon( weaponClass ) )

                local popup = vgui.Create( "pz_config_popup_weaponcfg" )
                popup.OnClose = function( valueChanged )
                    if( not popup.valueChanged ) then 
                        values[weaponClass] = oldWeaponValues
                        return 
                    end

                    PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Weapons", values )
                    self:Refresh()
                end
                popup:FinishSetup( values[weaponClass], weaponClass )

                PROJECT0.TEMP.WeaponCfgEditPopup = popup
            
                self.popup = popup
            end )

            categoryPanel:SetExtraHeight( categoryPanel:GetExtraHeight()+weaponEntry:GetTall()+PROJECT0.UI.Margin5 )
		end
	end

    local customCategoryPanel = self:CreateCategoryPanel( "custom", "Custom" )

    for k, v in pairs( values ) do
        if( weaponsList[k] ) then continue end
        weaponsList[k] = v

        local weaponEntry = self:CreateWeaponPanel( customCategoryPanel, v.Name, k, v.Model )
        weaponEntry:AddButton( deleteMat, function()
            PROJECT0.FUNC.DermaQuery( "Do you want to delete the configuration?", "WEAPON REMOVAL", "Confirm", function() 
                values[k] = nil
                PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Weapons", values )
                self:Refresh()
            end, "Cancel" )
        end )
        weaponEntry:AddButton( editMat, function()
            local popup = vgui.Create( "pz_config_popup_weaponcfg" )
            popup.OnClose = function( valueChanged )
                if( not popup.valueChanged ) then 
                    return
                end

                PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Weapons", values )
                self:Refresh()
            end
            popup:FinishSetup( values[k], k )

            PROJECT0.TEMP.WeaponCfgEditPopup = popup
        
            self.popup = popup
        end )

        customCategoryPanel:SetExtraHeight( customCategoryPanel:GetExtraHeight()+weaponEntry:GetTall()+PROJECT0.UI.Margin5 )
    end

    local addNewButton = customCategoryPanel:Add( "DButton" )
    addNewButton:Dock( TOP )
    addNewButton:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    addNewButton:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
    addNewButton:SetText( "" )
    addNewButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.1, 50 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 25+self2.alpha ) )
        surface.DrawRect( 0, 0, w, h )

        local clickPercent = math.Clamp( (CurTime()-(self2.lastClicked or 0))/0.3, 0, 1 )
        if( self2.lastClicked and self2.lastClicked+0.3 > CurTime() ) then
            local size = (w+PROJECT0.FUNC.ScreenScale( 100 ))*math.Clamp( clickPercent/0.5, 0, 1 )
            local offset = PROJECT0.FUNC.ScreenScale( 200 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 255-(math.Clamp( (clickPercent-0.5)*2, 0, 1 )*255) ) )
            draw.NoTexture()
            surface.DrawPoly( {
                { x = w-size+offset, y = -offset },
                { x = w+offset, y = size-offset },
                { x = size-offset, y = h+offset },
                { x = -offset, y = h-size+offset }
            } )
        end

        draw.SimpleText( "ADD", "MontserratBold22", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 100+(self2.alpha/50)*155 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    addNewButton.DoClick = function( self2 )
        self2.lastClicked = CurTime()
        
        local options = {}
        for k, v in ipairs( weapons.GetList() ) do
            if( weaponsList[v.ClassName] ) then continue end
            options[v.ClassName] = PROJECT0.FUNC.GetWeaponName( v.ClassName )
        end

        PROJECT0.FUNC.DermaComboRequest( "What weapon would you like to add?", "WEAPON EDITOR", options, false, true, false, function( value, data )
            if( not options[data] ) then return end

            values[data] = {
                Name = value,
                Class = "Weapon",
                Model = PROJECT0.FUNC.GetWeaponModel( data ),

                Charm = {
                    ViewModelPos = Vector( 0, 0, 0 ),
                    ViewModelAngle = Angle( 0, 0, 0 ),
                    WorldModelPos = Vector( 0, 0, 0 ),
                    WorldModelAngle = Angle( 0, 0, 0 )
                },
                
                Skin = {
                    ViewModelMats = {},
                    WorldModelMats = {}
                },

                Sticker = {
                    ViewModelPos = Vector( 0, 0, 0 ),
                    ViewModelAngle = Angle( 0, 0, 0 ),
                    WorldModelPos = Vector( 0, 0, 0 ),
                    WorldModelAngle = Angle( 0, 0, 0 )
                }
            }

            PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Weapons", values )
            self:Refresh()
        end )
    end

    customCategoryPanel:SetExtraHeight( customCategoryPanel:GetExtraHeight()+addNewButton:GetTall()+PROJECT0.UI.Margin5 )
end

function PANEL:Paint( w, h )
    if( not IsValid( self.scrollPanel ) ) then return end
    self.scrollPanelY = select( 2, self.scrollPanel:LocalToScreen( 0, 0 ) )
end

vgui.Register( "pz_config_customiser_weapons", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
