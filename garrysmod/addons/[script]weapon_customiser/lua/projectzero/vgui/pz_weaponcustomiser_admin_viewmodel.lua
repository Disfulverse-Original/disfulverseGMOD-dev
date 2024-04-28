--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetSize( ScrW(), ScrH() )
    self:Center()
    self:MakePopup()
    self:SetAlpha( 0 )
    self:AlphaTo( 255, 0.2 )
    self.pages = {}
    self.activePage = 0

    net.Start( "Project0.RequestViewmodelMode" )
        net.WriteBool( true )
    net.SendToServer()

    -- Side Panel --
    self.sidePanel = vgui.Create( "DPanel", self )
    self.sidePanel:SetSize( ScrW()*0.15, ScrH()-ScrW()*0.2 )
    self.sidePanel:SetPos( ScrW()*0.1, (ScrH()/2)-(self.sidePanel:GetTall()/2) )
    self.sidePanel.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( 0, 0, w, h )

        PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_sidepanel_viewmodel" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_sidepanel_viewmodel", x, y, 1, 1, 1, 255, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, h-5, w, 5 )
    end

    local iconMat = Material( "project0/icons/admin.png", "noclamp smooth" )

    surface.SetFont( "MontserratBold19" )
    local titleContentW, titleContentH = surface.GetTextSize( "ADMIN VIEWMODEL EDITOR" )
    surface.SetFont( "MontserratBold30" )
    titleContentW, titleContentH = titleContentW+surface.GetTextSize( "WEAPON" ), titleContentH+select( 2, surface.GetTextSize( "WEAPON" ) )-PROJECT0.UI.Margin5

    local titlePanel = vgui.Create( "DPanel", self.sidePanel )
    titlePanel:Dock( TOP )
    titlePanel:SetTall( PROJECT0.FUNC.ScreenScale( 80 ) )
    titlePanel.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )
        
        local adminConfig = PROJECT0.TEMP.AdminConfig.Viewmodels[self.currentWeapon or ""]
        if( not adminConfig ) then return end

        local x, y = self2:LocalToScreen( 0, 0 )

        local iconSize = PROJECT0.FUNC.ScreenScale( 44 )
        local iconMargin = h/2-iconSize/2
        local textX = iconMargin+iconSize+PROJECT0.UI.Margin15

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3 ) )
        surface.SetMaterial( iconMat )
        surface.DrawTexturedRect( iconMargin, iconMargin, iconSize, iconSize )

        PROJECT0.FUNC.BeginShadow( "menu_viewmodel_titles" )
        PROJECT0.FUNC.SetShadowSize( "menu_viewmodel_titles", titleContentW, titleContentH )
        draw.SimpleText( "ADMIN VIEWMODEL EDITOR", "MontserratBold19", x+textX, y+h/2-titleContentH/2, PROJECT0.FUNC.GetTheme( 4 ) )
        draw.SimpleText( adminConfig.Name, "MontserratBold30", x+textX, y+h/2+titleContentH/2, PROJECT0.FUNC.GetTheme( 3 ), 0, TEXT_ALIGN_BOTTOM )
        PROJECT0.FUNC.EndShadow( "menu_viewmodel_titles", x, y, 3, 1, 1, 100, 0, 0, false )
    end

    local closeButton = vgui.Create( "DButton", self.sidePanel )
    closeButton:Dock( BOTTOM )
    closeButton:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
    closeButton:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    closeButton:SetText( "" )
    closeButton.Paint = function( self2, w, h )
        if( self2:IsHovered() ) then
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)+5, 0, 100 )
        else
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)-5, 0, 100 )
        end

        PROJECT0.FUNC.BeginShadow( "menu_viewmodel_close" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_viewmodel_close", x, y, 1, 1, 1, 255, 0, 0, false )

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

        draw.SimpleText( "CLOSE", "MontserratBold19", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 200+(55*hoverPercent) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    closeButton.DoClick = function()
        net.Start( "Project0.RequestViewmodelMode" )
            net.WriteBool( false )
        net.SendToServer()

        self:Remove()

        PROJECT0.TEMP.AdminMenu:SetVisible( true )
        PROJECT0.TEMP.WeaponCfgEditPopup:SetVisible( true )

        if( self.valueChanged ) then
            PROJECT0.TEMP.WeaponCfgEditPopup.valueChanged = true
        end
    end

    local navigationPanel = vgui.Create( "Panel", self.sidePanel )
    navigationPanel:Dock( LEFT )
    navigationPanel:SetWide( PROJECT0.FUNC.ScreenScale( 50 ) )
    navigationPanel:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, 0 )
    navigationPanel.pages = {}
    navigationPanel.activePage = 0
    navigationPanel.SetActivePage = function( self2, pageKey )
        if( self2.pages[self2.activePage] ) then
            self2.pages[self2.activePage]:SetVisible( false )
        end

        self2.activePage = pageKey
        self2.pages[pageKey]:SetVisible( true )
    end
    navigationPanel.AddPage = function( self2, panel, iconMat )
        panel:SetVisible( false )

        local pageKey = table.insert( self2.pages, panel )
        if( self2.activePage == 0 ) then
            self2:SetActivePage( pageKey )
        end

        local pageButton = vgui.Create( "DButton", self2 )
        pageButton:Dock( TOP )
        pageButton:SetTall( self2:GetWide() )
        pageButton:SetText( "" )
        local iconSize = PROJECT0.FUNC.ScreenScale( 26 )
        pageButton.Paint = function( self3, w, h )
            self3:CreateFadeAlpha( 0.2, 100, false, false, self2.activePage == pageKey, 255 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, self2.activePage == pageKey and 100 or 25+self3.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, self3.alpha ) )
            surface.DrawRect( 0, 0, 3, h )
    
            PROJECT0.FUNC.DrawClickFade( self3, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )
    
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50+self3.alpha ) )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
        end
        pageButton.DoClick = function()
            self2:SetActivePage( pageKey )
        end
    end

    self.navigation = navigationPanel

    self.navigationContent = vgui.Create( "Panel", self.sidePanel )
    self.navigationContent:Dock( FILL )
    self.navigationContent:DockMargin( 0, PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0 )
    self.navigationContent:DockPadding( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin15, 4 ) )
    self.navigationContent.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    self:SetCurrentWeapon( PROJECT0.TEMP.ViewmodelWeapon )

    hook.Add( "Project0.Hooks.AdminViewmodelChange", self, function()
        self:SetCurrentWeapon( PROJECT0.TEMP.ViewmodelWeapon )
    end )

    net.Start( "Project0.RequestViewmodelWeapon" )
        net.WriteString( "m9k_m416" )
    net.SendToServer()
end

function PANEL:SwitchToWeapon( weaponClass )
    net.Start( "Project0.RequestViewmodelWeapon" )
        net.WriteString( weaponClass )
    net.SendToServer()
end

function PANEL:AddCollapsibleHeader( text, parent )
    surface.SetFont( "MontserratBold19" )
    local headerTall = select( 2, surface.GetTextSize( text ) ) 

    local headerPnl = vgui.Create( "Panel", parent )
    headerPnl:Dock( TOP )
    headerPnl:SetTall( headerTall )
    headerPnl:DockMargin( 0, 0, 0, PROJECT0.UI.Margin5 )
    headerPnl:DockPadding( 0, headerTall, 0, 0 )
    headerPnl.SetExtraHeight = function( self2, h )
        self2.extraHeight = h
        self2:SetTall( headerTall+h )
    end
    headerPnl.GetExtraHeight = function( self2 )
        return self2.extraHeight
    end
    headerPnl:SetExtraHeight( 0 )
    headerPnl.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )

        PROJECT0.FUNC.BeginShadow( "menu_admin_" .. text )
        draw.SimpleText( text, "MontserratBold19", x, y, PROJECT0.FUNC.GetTheme( 4 ) )
        PROJECT0.FUNC.EndShadow( "menu_admin_" .. text, x, y, 1, 1, 1, 100, 0, 0, false )
    end

    return headerPnl
end

function PANEL:UpdateModel()
    hook.Run( "Project0.Hooks.AdminViewmodelUpdate" )
end

function PANEL:SetCurrentWeapon( weaponClass )
    if( self.currentWeapon == weaponClass ) then return end
    self.currentWeapon = weaponClass

    self.navigation:Clear()
    self.navigationContent:Clear()

    local adminConfig = PROJECT0.TEMP.AdminConfig.Viewmodels[weaponClass or ""]
    if( not weaponClass or not adminConfig ) then
        return
    end

    -- SKIN EDIT
    local skinEditPage = vgui.Create( "Panel", self.navigationContent )
    skinEditPage:Dock( FILL )
    self.navigation:AddPage( skinEditPage, Material( "project0/icons/paint_64.png", "noclamp smooth" ) )

    local skinHeader = self:AddCollapsibleHeader( "SKIN MATERIALS", skinEditPage )
    skinHeader.RefreshMaterials = function( self2 )
        for k, v in ipairs( self2.materialEntries or {} ) do
            v:Remove()
        end

        self2.materialEntries = {}

        local swepTable = weapons.Get( weaponClass )
        if( swepTable ) then
            self2.currentModel = (swepTable.VModel or swepTable.ViewModel) or LocalPlayer():GetViewModel( 0 ):GetModel()
        else
            self2.currentModel = LocalPlayer():GetViewModel( 0 ):GetModel()
        end

        local skinNumbers = PROJECT0.FUNC.GetModelMaterials( self2.currentModel )
        skinNumbers[0] = ""

        if( swepTable and swepTable.Customization ) then
            for k, v in pairs( swepTable.Customization ) do
                skinNumbers[k] = ""
            end
        end

        self2:SetExtraHeight( 0 )
    
        for k, v in pairs( skinNumbers ) do
            local checkBox = vgui.Create( "pz_checkbox", self2 )
            checkBox:Dock( TOP )
            checkBox:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
            checkBox:SetLabelText( "Material " .. k )
            checkBox:SetValue( table.HasValue( adminConfig.Skin.ViewModelMats, k ) )	
            checkBox:DisableShadows( true )
            checkBox.OnChange = function( self2, value )
                if( value ) then
                    if( not table.HasValue( adminConfig.Skin.ViewModelMats, k ) ) then
                        table.insert( adminConfig.Skin.ViewModelMats, k )
                    end
                else
                    table.RemoveByValue( adminConfig.Skin.ViewModelMats, k )
                end
    
                self.valueChanged = true
                self:UpdateModel()
            end

            table.insert( self2.materialEntries, checkBox )
    
            self2:SetExtraHeight( self2:GetExtraHeight()+PROJECT0.UI.Margin5+checkBox:GetTall() )
        end
    end
    skinHeader.Think = function( self2 )
        -- if( self2.currentModel == LocalPlayer():GetViewModel( 0 ):GetModel() ) then return end
        -- self2:RefreshMaterials()
    end
    skinHeader:RefreshMaterials()

    -- TRINKET EDIT
    if( not adminConfig.Charm.Disabled ) then
        local trinketEditPage = vgui.Create( "Panel", self.navigationContent )
        trinketEditPage:Dock( FILL )
        self.navigation:AddPage( trinketEditPage, Material( "project0/icons/charm.png", "noclamp smooth" ) )

        -- Trinket Attachment
        local trinketAttachmentHeader = self:AddCollapsibleHeader( "TRINKET ATTACHMENT", trinketEditPage )

        local attachmentCombo = vgui.Create( "pz_combo", trinketAttachmentHeader )
        attachmentCombo:Dock( TOP )
        attachmentCombo:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
        attachmentCombo:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
        attachmentCombo:DisableShadows( true )
        attachmentCombo.OnSelect = function( self2, index, value, data )
            if( adminConfig.Charm.ViewModelAttachment == data ) then return end

            adminConfig.Charm.ViewModelAttachment = data
            self.valueChanged = true
            self:UpdateModel()
        end

        trinketAttachmentHeader:SetExtraHeight( attachmentCombo:GetTall()+PROJECT0.UI.Margin5 )

        trinketAttachmentHeader.RefreshAttachments = function( self2 )
            self2.currentModel = LocalPlayer():GetViewModel( 0 )

            attachmentCombo:Clear()
            attachmentCombo:SetValue( "Select Option" )

            if( not IsValid( self2.currentModel ) ) then return end

            for k, v in ipairs( self2.currentModel:GetAttachments() ) do
                attachmentCombo:AddChoice( v.id .. ": " .. v.name, v.id, adminConfig.Charm.ViewModelAttachment == v.id )
            end
        end
        trinketAttachmentHeader.Think = function( self2 )
            if( self2.currentModel == LocalPlayer():GetViewModel( 0 ) ) then return end
            self2:RefreshAttachments()
        end
        trinketAttachmentHeader:RefreshAttachments()

        -- Trinket Position
        local trinketHeader = self:AddCollapsibleHeader( "TRINKET POSITION", trinketEditPage )

        for i = 1, 3 do
            local numSlider = vgui.Create( "pz_num_slider", trinketHeader )
            numSlider:Dock( TOP )
            numSlider:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
            numSlider:SetMinMax( -20, 20 )
            numSlider:SetValue( adminConfig.Charm.ViewModelPos[i] )
            numSlider:SetLabel( (i == 1 and "X") or (i == 2 and "Y") or "Z" )
            numSlider:DisableShadows( true )
            numSlider:SetLabelColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
            numSlider.OnChange = function( self2, value )
                if( adminConfig.Charm.ViewModelPos[i] == value ) then return end

                adminConfig.Charm.ViewModelPos[i] = value
                self.valueChanged = true
                self:UpdateModel()
            end

            trinketHeader:SetExtraHeight( trinketHeader:GetExtraHeight()+PROJECT0.UI.Margin5+numSlider:GetTall() )
        end

        -- Trinket Angle
        local trinketHeader = self:AddCollapsibleHeader( "TRINKET ANGLE", trinketEditPage )

        for i = 1, 3 do
            local numSlider = vgui.Create( "pz_num_slider", trinketHeader )
            numSlider:Dock( TOP )
            numSlider:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
            numSlider:SetMinMax( 0, 360 )
            numSlider:SetValue( adminConfig.Charm.ViewModelAngle[i] )
            numSlider:SetLabel( (i == 1 and "Pitch") or (i == 2 and "Yaw") or "Roll" )
            numSlider:DisableShadows( true )
            numSlider:SetLabelColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
            numSlider.OnChange = function( self2, value )
                if( adminConfig.Charm.ViewModelAngle[i] == value ) then return end

                adminConfig.Charm.ViewModelAngle[i] = value
                self.valueChanged = true
                self:UpdateModel()
            end

            trinketHeader:SetExtraHeight( trinketHeader:GetExtraHeight()+PROJECT0.UI.Margin5+numSlider:GetTall() )
        end
    end

    -- STICKER EDIT
    if( not adminConfig.Sticker.Disabled ) then
        local stickerEditPage = vgui.Create( "Panel", self.navigationContent )
        stickerEditPage:Dock( FILL )
        self.navigation:AddPage( stickerEditPage, Material( "project0/icons/sticker.png", "noclamp smooth" ) )

        -- Sticker Attachment
        local stickerAttachmentHeader = self:AddCollapsibleHeader( "STICKER ATTACHMENT", stickerEditPage )

        local attachmentSCombo = vgui.Create( "pz_combo", stickerAttachmentHeader )
        attachmentSCombo:Dock( TOP )
        attachmentSCombo:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
        attachmentSCombo:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
        attachmentSCombo:DisableShadows( true )
        attachmentSCombo.OnSelect = function( self2, index, value, data )
            if( adminConfig.Sticker.ViewModelAttachment == data ) then return end

            adminConfig.Sticker.ViewModelAttachment = data
            self.valueChanged = true
            self:UpdateModel()
        end

        stickerAttachmentHeader:SetExtraHeight( attachmentSCombo:GetTall()+PROJECT0.UI.Margin5 )

        stickerAttachmentHeader.RefreshAttachments = function( self2 )
            self2.currentModel = LocalPlayer():GetViewModel( 0 )

            attachmentSCombo:Clear()
            attachmentSCombo:SetValue( "Select Option" )

            if( not IsValid( self2.currentModel ) ) then return end

            for k, v in ipairs( self2.currentModel:GetAttachments() ) do
                attachmentSCombo:AddChoice( v.id .. ": " .. v.name, v.id, adminConfig.Sticker.ViewModelAttachment == v.id )
            end
        end
        stickerAttachmentHeader.Think = function( self2 )
            if( self2.currentModel == LocalPlayer():GetViewModel( 0 ) ) then return end
            self2:RefreshAttachments()
        end
        stickerAttachmentHeader:RefreshAttachments()

        -- Sticker Position
        local stickerHeader = self:AddCollapsibleHeader( "STICKER POSITION", stickerEditPage )

        for i = 1, 3 do
            local numSlider = vgui.Create( "pz_num_slider", stickerHeader )
            numSlider:Dock( TOP )
            numSlider:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
            numSlider:SetMinMax( -20, 20 )
            numSlider:SetValue( adminConfig.Sticker.ViewModelPos[i] )
            numSlider:SetLabel( (i == 1 and "X") or (i == 2 and "Y") or "Z" )
            numSlider:DisableShadows( true )
            numSlider:SetLabelColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
            numSlider.OnChange = function( self2, value )
                if( adminConfig.Sticker.ViewModelPos[i] == value ) then return end

                adminConfig.Sticker.ViewModelPos[i] = value
                self.valueChanged = true
                self:UpdateModel()
            end

            stickerHeader:SetExtraHeight( stickerHeader:GetExtraHeight()+PROJECT0.UI.Margin5+numSlider:GetTall() )
        end

        -- Sticker Angle
        local stickerHeader = self:AddCollapsibleHeader( "STICKER ANGLE", stickerEditPage )

        for i = 1, 3 do
            local numSlider = vgui.Create( "pz_num_slider", stickerHeader )
            numSlider:Dock( TOP )
            numSlider:DockMargin( 0, PROJECT0.UI.Margin5, 0, 0 )
            numSlider:SetMinMax( 0, 360 )
            numSlider:SetValue( adminConfig.Sticker.ViewModelAngle[i] )
            numSlider:SetLabel( (i == 1 and "Pitch") or (i == 2 and "Yaw") or "Roll" )
            numSlider:DisableShadows( true )
            numSlider:SetLabelColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
            numSlider.OnChange = function( self2, value )
                if( adminConfig.Sticker.ViewModelAngle[i] == value ) then return end

                adminConfig.Sticker.ViewModelAngle[i] = value
                self.valueChanged = true
                self:UpdateModel()
            end

            stickerHeader:SetExtraHeight( stickerHeader:GetExtraHeight()+PROJECT0.UI.Margin5+numSlider:GetTall() )
        end
    end
end

vgui.Register( "pz_weaponcustomiser_admin_viewmodel", PANEL, "EditablePanel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
