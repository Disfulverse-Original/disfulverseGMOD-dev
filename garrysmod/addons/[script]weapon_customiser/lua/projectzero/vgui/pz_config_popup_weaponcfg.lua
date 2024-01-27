--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetPopupWide( ScrW()*0.65 )
    self:SetExtraHeight( ScrH()*0.55 )
    self:SetHeader( "WEAPON SETUP" )
end

function PANEL:AddHeader( text, color, parent )
    surface.SetFont( "MontserratBold19" )

    local headerPnl = vgui.Create( "DPanel", parent )
    headerPnl:Dock( TOP )
    headerPnl:SetTall( select( 2, surface.GetTextSize( text ) )  )
    headerPnl:DockMargin( PROJECT0.UI.Margin25, 0, 0, PROJECT0.UI.Margin5 )
    headerPnl:SetText( "" )
    headerPnl.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, h/2 )

        PROJECT0.FUNC.BeginShadow( "menu_admin_" .. text )
        draw.SimpleText( text, "MontserratBold19", x, y, color or PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_CENTER )
        PROJECT0.FUNC.EndShadow( "menu_admin_" .. text, x, y, 1, 1, 1, 100, 0, 0, false )
    end

    return headerPnl
end

function PANEL:AddCollapsibleHeader( text, color, parent )
    surface.SetFont( "MontserratBold19" )
    local headerTall = select( 2, surface.GetTextSize( text ) ) 

    local headerPnl = vgui.Create( "Panel", parent )
    headerPnl:Dock( TOP )
    headerPnl:DockMargin( PROJECT0.UI.Margin25, 0, 0, PROJECT0.UI.Margin5 )
    headerPnl:SetTall( headerTall )
    headerPnl.SetExtraHeight = function( self2, h )
        self2.extraHeight = h

        if( self2.expanded ) then
            self2:SetTall( headerTall+h )
        end
    end
    headerPnl.GetExtraHeight = function( self2 )
        return self2.extraHeight
    end
    headerPnl:SetExtraHeight( 0 )
    headerPnl.expanded = true
    headerPnl.SetExpanded = function( self2, expanded )
        self2.expanded = expanded

        if( expanded ) then
            self2:SizeTo( self2.actualW or 100, headerTall+self2.extraHeight, 0.2 )
        else
            self2:SizeTo( self2.actualW or 100, headerTall, 0.2 )
        end

        self2:DoRotationAnim( expanded )
    end
    headerPnl.textureRotation = 0
    headerPnl.DoRotationAnim = function( self2, expanding )
        local anim = self2:NewAnimation( 0.2, 0, -1 )
    
        anim.Think = function( anim, pnl, fraction )
            if( expanding ) then
                self2.textureRotation = (1-fraction)*-90
            else
                self2.textureRotation = fraction*-90
            end
        end
    end
    headerPnl.Paint = function( self2, w, h )
        if( (self2.actualW or 0) == w ) then return end
        self2.actualW = w
    end
    
    local headerTxtPnl = vgui.Create( "DButton", headerPnl )
    headerTxtPnl:Dock( TOP )
    headerTxtPnl:SetTall( headerTall )
    headerTxtPnl:SetText( "" )
    local arrow16Mat = Material( "project0/icons/down_16.png", "noclamp smooth" )
    headerTxtPnl.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, h/2 )

        PROJECT0.FUNC.BeginShadow( "menu_admin_" .. text )
        draw.SimpleText( text, "MontserratBold19", x, y, color or PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_CENTER )
        PROJECT0.FUNC.EndShadow( "menu_admin_" .. text, x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( color or PROJECT0.FUNC.GetTheme( 4 ) )
        surface.SetMaterial( arrow16Mat )
        local iconSize = PROJECT0.FUNC.ScreenScale( 12 )
        surface.DrawTexturedRectRotated( w-((h-iconSize)/2)-(iconSize/2)-PROJECT0.UI.Margin25, h/2, iconSize, iconSize, math.Clamp( (headerPnl.textureRotation or 0), -90, 0 ) )

        self2:CreateFadeAlpha( 0.2, 50 )

        local old = DisableClipping( true )

        local border = 3
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, self2.alpha ) )
        surface.DrawRect( -border, -border, w-PROJECT0.UI.Margin25+(2*border), h+(2*border) )

        DisableClipping( old )
    end
    headerTxtPnl.DoClick = function()
        headerPnl:SetExpanded( not headerPnl.expanded )
    end

    return headerPnl
end

function PANEL:FinishSetup( weaponConfig, weaponClass )
    self.configTable = weaponConfig
    self.valueChanged = false

    local sidePanel = vgui.Create( "Panel", self )
    sidePanel:Dock( LEFT )
    sidePanel:SetWide( self:GetPopupWide()*0.25 )
    sidePanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.UI.Margin50, 0, PROJECT0.UI.Margin50 )
    sidePanel.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local sideButtonsPanel = vgui.Create( "Panel", sidePanel )
    sideButtonsPanel:Dock( LEFT )
    sideButtonsPanel:SetWide( PROJECT0.FUNC.ScreenScale( 50 ) )
    sideButtonsPanel.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    sidePanel.pages = {}
    sidePanel.activePage = 0
    sidePanel.SetActivePage = function( self2, pageKey )
        if( self2.pages[self2.activePage] ) then
            self2.pages[self2.activePage]:SetVisible( false )
        end

        self2.activePage = pageKey
        self2.pages[pageKey]:SetVisible( true )
    end
    sidePanel.AddPage = function( self2, panel, iconMat )
        panel:SetVisible( false )

        local pageKey = table.insert( self2.pages, panel )
        if( self2.activePage == 0 ) then
            sidePanel:SetActivePage( pageKey )
        end

        local pageButton = vgui.Create( "DButton", sideButtonsPanel )
        pageButton:Dock( TOP )
        pageButton:SetTall( sideButtonsPanel:GetWide() )
        pageButton:SetText( "" )
        local iconSize = PROJECT0.FUNC.ScreenScale( 26 )
        pageButton.Paint = function( self3, w, h )
            self3:CreateFadeAlpha( 0.2, 100, false, false, self2.activePage == pageKey, 255 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, self3.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, self3.alpha ) )
            surface.DrawRect( 0, 0, 3, h )
    
            PROJECT0.FUNC.DrawClickFade( self3, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )
    
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
        end
        pageButton.DoClick = function()
            sidePanel:SetActivePage( pageKey )
        end
    end

    -- GENERAL EDIT
    local generalEditPage = vgui.Create( "pz_scrollpanel", sidePanel )
    generalEditPage:Dock( FILL )
    sidePanel:AddPage( generalEditPage, Material( "project0/icons/edit.png", "noclamp smooth" ) )

    -- Current Weapon
    local header = self:AddHeader( "CURRENT WEAPON", false, generalEditPage )
    header:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    self:AddHeader( weaponClass, PROJECT0.FUNC.GetTheme( 3 ), generalEditPage )

    -- Name
    local valueEntryHeader = self:AddHeader( "DISPLAY NAME", false, generalEditPage )
    valueEntryHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    local valueEntry = vgui.Create( "pz_textentry", generalEditPage )
    valueEntry:Dock( TOP )
    valueEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    valueEntry:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
    valueEntry:SetBackText( "Enter value" )
    valueEntry:SetValue( weaponConfig.Name )
    valueEntry:SetFont( "MontserratBold19" )
    valueEntry:DisableShadows( true )
    valueEntry.OnChange = function( self2, value )
        weaponConfig.Name = value
        self.valueChanged = true
        self:UpdateModel()
    end

    -- Class
    local valueEntryHeader = self:AddHeader( "WEAPON CATEGORY", false, generalEditPage )
    valueEntryHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    local valueEntry = vgui.Create( "pz_textentry", generalEditPage )
    valueEntry:Dock( TOP )
    valueEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    valueEntry:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
    valueEntry:SetBackText( "Enter value" )
    valueEntry:SetValue( weaponConfig.Class )
    valueEntry:SetFont( "MontserratBold19" )
    valueEntry:DisableShadows( true )
    valueEntry.OnChange = function( self2, value )
        weaponConfig.Class = value
        self.valueChanged = true
        self:UpdateModel()
    end

    -- Display Model
    local valueEntryHeader = self:AddHeader( "DISPLAY MODEL", false, generalEditPage )
    valueEntryHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    local valueEntry = vgui.Create( "pz_textentry", generalEditPage )
    valueEntry:Dock( TOP )
    valueEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    valueEntry:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
    valueEntry:SetBackText( "Enter value" )
    valueEntry:SetValue( weaponConfig.Model or "" )
    valueEntry:SetFont( "MontserratBold19" )
    valueEntry:DisableShadows( true )
    valueEntry.OnChange = function( self2, value )
        weaponConfig.Model = value
        self.valueChanged = true
        self:UpdateModel()
    end

    -- SKIN EDIT
    local skinEditPage = vgui.Create( "pz_scrollpanel", sidePanel )
    skinEditPage:Dock( FILL )
    sidePanel:AddPage( skinEditPage, Material( "project0/icons/paint_64.png", "noclamp smooth" ) )

    -- Skin Materials
    local skinHeader = self:AddCollapsibleHeader( "SKIN MATERIALS", false, skinEditPage )
    skinHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    for k, v in pairs( PROJECT0.FUNC.GetModelMaterials( weaponConfig.Model or "" ) ) do
        local checkBox = vgui.Create( "pz_checkbox", skinHeader )
        checkBox:Dock( TOP )
        checkBox:DockMargin( 0, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
        checkBox:SetLabelText( "Material " .. k )
        checkBox:SetValue( table.HasValue( weaponConfig.Skin.WorldModelMats, k ) )	
        checkBox:DisableShadows( true )
        checkBox.OnChange = function( self2, value )
            if( value ) then
                if( not table.HasValue( weaponConfig.Skin.WorldModelMats, k ) ) then
                    table.insert( weaponConfig.Skin.WorldModelMats, k )
                end
            else
                table.RemoveByValue( weaponConfig.Skin.WorldModelMats, k )
            end
            
            self.valueChanged = true

            self:UpdateModel()
        end

        skinHeader:SetExtraHeight( skinHeader:GetExtraHeight()+PROJECT0.UI.Margin5+checkBox:GetTall() )
    end

    -- TRINKET EDIT
    local trinketEditPage = vgui.Create( "pz_scrollpanel", sidePanel )
    trinketEditPage:Dock( FILL )
    sidePanel:AddPage( trinketEditPage, Material( "project0/icons/charm.png", "noclamp smooth" ) )

    -- Trinket Toggle
    local trinketHeader = self:AddCollapsibleHeader( "TRINKET TOGGLE", false, trinketEditPage )
    trinketHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    local trinketEnabled = vgui.Create( "pz_checkbox", trinketHeader )
    trinketEnabled:Dock( TOP )
    trinketEnabled:DockMargin( 0, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
    trinketEnabled:SetLabelText( "Trinkets Enabled" )
    trinketEnabled:SetValue( not weaponConfig.Charm.Disabled )	
    trinketEnabled:DisableShadows( true )
    trinketEnabled.OnChange = function( self2, value )
        if( not value ) then
            weaponConfig.Charm.Disabled = true
        else
            weaponConfig.Charm.Disabled = nil
        end

        self.valueChanged = true
        self:UpdateModel()
    end

    trinketHeader:SetExtraHeight( trinketEnabled:GetTall()+PROJECT0.UI.Margin5 )

    -- Trinket Attachment
    local attachmentHeader = self:AddCollapsibleHeader( "TRINKET ATTACHMENT", false, trinketEditPage )
    attachmentHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin10, 0, 0 )

    local comboEntry = vgui.Create( "pz_combo", attachmentHeader )
	comboEntry:Dock( TOP )
	comboEntry:DockMargin( 0, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
	comboEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
	comboEntry:DisableShadows( true )
    comboEntry.OnSelect = function( self2, index, value, data )
        if( weaponConfig.Charm.WorldAttachment == data ) then return end

        weaponConfig.Charm.WorldAttachment = data
        self.valueChanged = true
        self:UpdateModel()
    end

    attachmentHeader:SetExtraHeight( comboEntry:GetTall()+PROJECT0.UI.Margin5 )

    function self.RefreshTrinketAttachments()
        comboEntry:Clear()
        comboEntry:SetValue( "Select Option" )

        if( not IsValid( self.modelPanel.Entity ) ) then return end

        for k, v in ipairs( self.modelPanel.Entity:GetAttachments() ) do
            comboEntry:AddChoice( v.id .. ": " .. v.name, v.id, weaponConfig.Charm.WorldAttachment == v.id )
        end
    end

    -- Trinket Position
    local trinketHeader = self:AddCollapsibleHeader( "TRINKET POSITION", false, trinketEditPage )
    trinketHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin10, 0, 0 )

    for i = 1, 3 do
        local numSlider = vgui.Create( "pz_num_slider", trinketHeader )
        numSlider:Dock( TOP )
        numSlider:DockMargin( 0, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
        numSlider:SetMinMax( -20, 20 )
        numSlider:SetValue( weaponConfig.Charm.WorldModelPos[i] )
        numSlider:SetLabel( (i == 1 and "X") or (i == 2 and "Y") or "Z" )
        numSlider:DisableShadows( true )
        numSlider.OnChange = function( self2, value )
            if( weaponConfig.Charm.WorldModelPos[i] == value ) then return end

            weaponConfig.Charm.WorldModelPos[i] = value
            self.valueChanged = true
            self:UpdateModel()
        end

        trinketHeader:SetExtraHeight( trinketHeader:GetExtraHeight()+PROJECT0.UI.Margin5+numSlider:GetTall() )
    end

    -- Trinket Angle
    local trinketHeader = self:AddCollapsibleHeader( "TRINKET ANGLE", false, trinketEditPage )
    trinketHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin10, 0, 0 )

    for i = 1, 3 do
        local numSlider = vgui.Create( "pz_num_slider", trinketHeader )
        numSlider:Dock( TOP )
        numSlider:DockMargin( 0, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
        numSlider:SetMinMax( 0, 360 )
        numSlider:SetValue( weaponConfig.Charm.WorldModelAngle[i] )
        numSlider:SetLabel( (i == 1 and "Pitch") or (i == 2 and "Yaw") or "Roll" )
        numSlider:DisableShadows( true )
        numSlider.OnChange = function( self2, value )
            if( weaponConfig.Charm.WorldModelAngle[i] == value ) then return end

            weaponConfig.Charm.WorldModelAngle[i] = value
            self.valueChanged = true
            self:UpdateModel()
        end

        trinketHeader:SetExtraHeight( trinketHeader:GetExtraHeight()+PROJECT0.UI.Margin5+numSlider:GetTall() )
    end

    -- STICKER EDIT
    local stickerEditPage = vgui.Create( "pz_scrollpanel", sidePanel )
    stickerEditPage:Dock( FILL )
    sidePanel:AddPage( stickerEditPage, Material( "project0/icons/sticker.png", "noclamp smooth" ) )

    -- Sticker Toggle
    local stickerHeader = self:AddCollapsibleHeader( "STICKER TOGGLE", false, stickerEditPage )
    stickerHeader:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )

    local stickerEnabled = vgui.Create( "pz_checkbox", stickerHeader )
    stickerEnabled:Dock( TOP )
    stickerEnabled:DockMargin( 0, PROJECT0.UI.Margin5, PROJECT0.UI.Margin25, 0 )
    stickerEnabled:SetLabelText( "Trinkets Enabled" )
    stickerEnabled:SetValue( not weaponConfig.Sticker.Disabled )	
    stickerEnabled:DisableShadows( true )
    stickerEnabled.OnChange = function( self2, value )
        if( not value ) then
            weaponConfig.Sticker.Disabled = true
        else
            weaponConfig.Sticker.Disabled = nil
        end

        self.valueChanged = true
        self:UpdateModel()
    end

    stickerHeader:SetExtraHeight( stickerEnabled:GetTall()+PROJECT0.UI.Margin5 )

    -- Model
    local modelPanel = vgui.Create( "DModelPanel", self )
    modelPanel:Dock( FILL )
    modelPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.UI.Margin100, 0, PROJECT0.UI.Margin100 )
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
        self2.currentZoom = math.Clamp( (self2.currentZoom or -65)+(delta*10), -200, -10 )
        self2:SetCamPos( Vector( self2.currentZoom, 0, 0 ) )
    end
    local oldPaint = modelPanel.Paint
    modelPanel.Paint = function( self2, w, h )
        oldPaint( self2, w, h )

        if( (self2.actualW or 0) != w or (self2.actualH or 0) != h ) then
            self2.actualW, self2.actualH = w, h
        end
    end

    modelPanel:SetCamPos( Vector( -50, 0, 0 ) )
    modelPanel:SetLookAt( Vector( 0, 0, 0 ) )

    self.trinketBaseEnt = ClientsideModel( "models/sterling/smodel_w_tinket.mdl", RENDERGROUP_OTHER )
    self.trinketBaseEnt:SetNoDraw( true )
    self.trinketBaseEnt:SetIK( false )

    local charmConfig = PROJECT0.CONFIG.CUSTOMISER.Charms[1]
    if( charmConfig ) then
        self.trinketEnt = ClientsideModel( charmConfig.Model, RENDERGROUP_OTHER )
        self.trinketEnt:SetParent( self.trinketBaseEnt )
        self.trinketEnt:SetNoDraw( true )
        self.trinketEnt:SetIK( false )
        self.trinketEnt:SetModelScale( 0.5 )
    end

    modelPanel.OnRemove = function( self2 )
        if( IsValid( self.trinketBaseEnt ) ) then
            self.trinketBaseEnt:Remove()
        end

        if( IsValid( self.trinketEnt ) ) then
            self.trinketEnt:Remove()
        end
    end

    self.modelPanel = modelPanel

    self:UpdateModel()

    -- Edit Viewmodel
    local margin50 = PROJECT0.UI.Margin50
    local sidePanelW = sidePanel:GetWide()

    local editViewmodelBtn = vgui.Create( "DButton", self )
    editViewmodelBtn:SetSize( PROJECT0.FUNC.ScreenScale( 200 ), PROJECT0.FUNC.ScreenScale( 40 ) )
    editViewmodelBtn:SetPos( margin50+sidePanelW+(self:GetPopupWide()-sidePanelW-(margin50*2))/2-editViewmodelBtn:GetWide()/2, self:GetPopupTall()-editViewmodelBtn:GetTall()-margin50 )
    editViewmodelBtn:SetText( "" )
    editViewmodelBtn.Paint = function( self2, w, h )
        if( self2:IsHovered() ) then
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)+5, 0, 100 )
        else
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)-5, 0, 100 )
        end

        PROJECT0.FUNC.BeginShadow( "menucfg_editviewmodel" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menucfg_editviewmodel", x, y, 1, 1, 1, 255, 0, 0, false )

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

        draw.SimpleText( "EDIT VIEWMODEL", "MontserratBold19", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 200+(55*hoverPercent) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    editViewmodelBtn.DoClick = function()
        PROJECT0.TEMP.AdminMenu:SetVisible( false )
        PROJECT0.TEMP.WeaponCfgEditPopup:SetVisible( false )
        
        if( IsValid( PROJECT0.TEMP.WeaponCustomiserAdminViewmodel ) ) then
            PROJECT0.TEMP.WeaponCustomiserAdminViewmodel:Remove()
        end

        PROJECT0.TEMP.AdminConfig.Viewmodels[weaponClass] = weaponConfig
    
        PROJECT0.TEMP.WeaponCustomiserAdminViewmodel = vgui.Create( "pz_weaponcustomiser_admin_viewmodel" )
        PROJECT0.TEMP.WeaponCustomiserAdminViewmodel:SwitchToWeapon( weaponClass )
    end

    -- Output JSON
    local outputJsonButton = vgui.Create( "DButton", self )
    outputJsonButton:SetSize( PROJECT0.FUNC.ScreenScale( 40 ), PROJECT0.FUNC.ScreenScale( 40 ) )
    outputJsonButton:SetPos( self:GetPopupWide()-outputJsonButton:GetWide()-margin50, self:GetPopupTall()-outputJsonButton:GetTall()-margin50 )
    outputJsonButton:SetText( "" )
    local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
    local outputMat = Material( "project0/icons/output.png", "noclamp smooth" )
    outputJsonButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 100 )

        PROJECT0.FUNC.BeginShadow( "menucfg_outputjson" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menucfg_outputjson", x, y, 1, 1, 1, 255, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
        surface.DrawRect( 0, 0, w, h )

        PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
        surface.SetMaterial( outputMat )
        surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
    end
    outputJsonButton.DoClick = function()
        local json = util.TableToJSON( weaponConfig )
        print( "[PROJECT0] Weapon JSON: " .. json )
        SetClipboardText( json )
    end
end

function PANEL:UpdateModel()
    local weaponConfig = self.configTable

    if( weaponConfig.Model != self.currentModel ) then
        self.modelPanel:SetModel( weaponConfig.Model or "" )
        if( IsValid( self.modelPanel.Entity ) ) then self.modelPanel.Entity:SetAngles( Angle( 0, 90, 0 ) ) end
    end

    self.currentModel = weaponConfig.Model or ""

    local modelEnt = self.modelPanel.Entity
    if( not IsValid( modelEnt ) ) then return end

    local mn, mx = modelEnt:GetRenderBounds()

    modelEnt:SetSubMaterial( 0 )
    for k, v in ipairs( PROJECT0.FUNC.GetModelMaterials( weaponConfig.Model or "" ) ) do
        modelEnt:SetSubMaterial( k )
    end

    for k, v in ipairs( weaponConfig.Skin.WorldModelMats ) do
        modelEnt:SetSubMaterial( v, PROJECT0.DEVCONFIG.WeaponSkins[1].Material )
    end

    local worldPos = weaponConfig.Charm.WorldModelPos
    local stickerSize = 50
    self.modelPanel.PostDrawModel = function( self2, ent )
        -- Trinkets
        if( IsValid( self.trinketBaseEnt ) ) then 
            self.trinketBaseEnt:DrawModel()

            local trinketBaseAttachment
            if( weaponConfig.Charm.WorldAttachment ) then
                trinketBaseAttachment = ent:GetAttachment( weaponConfig.Charm.WorldAttachment )
                self.trinketBaseEnt:SetPos( trinketBaseAttachment.Pos+(ent:GetForward()*worldPos[1])+(ent:GetRight()*worldPos[2])+(ent:GetUp()*worldPos[3]) )
                self.trinketBaseEnt:SetAngles( trinketBaseAttachment.Ang+weaponConfig.Charm.WorldModelAngle )
            else
                self.trinketBaseEnt:SetPos( ent:GetPos()+(ent:GetForward()*worldPos[1])+(ent:GetRight()*worldPos[2])+(ent:GetUp()*worldPos[3]) )
                self.trinketBaseEnt:SetAngles( ent:GetAngles()+weaponConfig.Charm.WorldModelAngle )
            end

            if( IsValid( self.trinketEnt ) ) then 
                local trinketAttachment = self.trinketBaseEnt:GetAttachment( 2 )
                if( trinketAttachment ) then 
                    self.trinketEnt:DrawModel()
                    self.trinketEnt:SetPos( trinketAttachment.Pos )
                    self.trinketEnt:SetAngles( trinketAttachment.Ang+Angle( -90, 0, 0 ) )
                end
            end
        end

        -- Stickers
        -- local pos = ent:GetPos()
        -- local x, y = self2:LocalToScreen()
        -- pos = Vector( y+pos[1], y+pos[2], pos[3] )

        -- local ang = ent:GetAngles()
        
        -- ang:RotateAroundAxis(ang:Up(), 0)
        -- ang:RotateAroundAxis(ang:Forward(), 90)
        -- ang:RotateAroundAxis(ang:Right(), 180)
        
        -- local old = DisableClipping( true )
        -- cam.Start3D2D( Vector( x, y, 0 ), Angle(180, 0, 0), 1 )
        --     local x, y = 0, 0

        --     surface.SetDrawColor( 255, 0, 0 )
        --     surface.DrawRect( x, y, stickerSize, stickerSize )
        
        --     surface.SetDrawColor( 255, 255, 255 )
        --     surface.DrawOutlinedRect( x, y, stickerSize, stickerSize )
        --     surface.DrawOutlinedRect( x+1, y+1, stickerSize-2, stickerSize-2 )
        
        --     draw.SimpleText( "THIS", "MontserratBold25", x+stickerSize/2, y+stickerSize/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        --     draw.SimpleText( "WAY", "MontserratBold25", x+stickerSize/2, y+stickerSize/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, 0 )
        -- cam.End3D2D()
        -- DisableClipping( old )
    end

    self.RefreshTrinketAttachments()
end

vgui.Register( "pz_config_popup_weaponcfg", PANEL, "pz_popup_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
