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
    self.activePage = { 0, 0 }

    -- Main Panel --
    self.mainPanel = vgui.Create( "DPanel", self )
    self.mainPanel:SetSize( ScrW()*0.6, ScrH()*0.6 )
    self.mainPanel:Center()
    self.mainPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_admin" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_admin", x, y, 1, 1, 1, 255, 0, 0, false )
    end

    -- Side Panel --
    self.sidePanel = vgui.Create( "DPanel", self.mainPanel )
    self.sidePanel:Dock( LEFT )
    self.sidePanel:SetWide( ScrW()*0.1 )
    self.sidePanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_admin_side" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_admin_side", x, y, 1, 1, 1, 255, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, h-5, w, 5 )
    end

    local iconMat = Material( "project0/icons/admin.png", "noclamp smooth" )

    local titlePanel = vgui.Create( "DPanel", self.sidePanel )
    titlePanel:Dock( TOP )
    titlePanel:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
    titlePanel:SetTall( PROJECT0.FUNC.ScreenScale( 65 ) )
    titlePanel.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )
        local iconSize = PROJECT0.FUNC.ScreenScale( 44 )

        PROJECT0.FUNC.BeginShadow( "menu_admin_titles" )
        draw.SimpleText( "PROJECT0", "MontserratBold19", x, y, PROJECT0.FUNC.GetTheme( 4 ) )
        draw.SimpleText( "ADMIN", "MontserratBold30", x+iconSize+PROJECT0.UI.Margin5, y+h-(iconSize/2)+PROJECT0.UI.Margin5, PROJECT0.FUNC.GetTheme( 3 ), 0, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( "DASHBOARD", "MontserratBold30", x+iconSize+PROJECT0.UI.Margin5, y+h-(iconSize/2)-PROJECT0.UI.Margin5, PROJECT0.FUNC.GetTheme( 3 ), 0, 0 )
        PROJECT0.FUNC.EndShadow( "menu_admin_titles", x, y, 3, 1, 1, 100, 0, 0, false )
        
        surface.SetMaterial( iconMat )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3 ) )
        surface.DrawTexturedRect( 0, h-iconSize, iconSize, iconSize )
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

        PROJECT0.FUNC.BeginShadow( "menu_admin_btn_close" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_admin_btn_close", x, y, 1, 1, 1, 255, 0, 0, false )

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
        if( not self:AttemptClose() ) then return end

        self:AlphaTo( 0, 0.2, 0, function()
            self:Remove()
        end )
    end

    self.searchBar = vgui.Create( "pz_combo_description_search", self.sidePanel )
    self.searchBar:Dock( TOP )
    self.searchBar:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    self.searchBar:DockMargin( PROJECT0.UI.Margin25, 0, PROJECT0.UI.Margin25, PROJECT0.UI.Margin25 )

    local keyData = {}
    for k, v in pairs( PROJECT0.CONFIGMETA ) do
        for key, val in pairs( v.Variables ) do
            self.searchBar:AddChoice( k .. key, val.Name, val.Description )
            keyData[k .. key] = { k, key }
        end
    end

    self.searchBar.OnSelect = function( self2, index )
        local keyInfo = keyData[index]
        if( not keyInfo ) then return end

        self:GotoVariableOnPage( keyInfo[1], keyInfo[2] )
    end

    self.contents = vgui.Create( "DPanel", self.mainPanel )
    self.contents:Dock( FILL )
    self.contents:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
    self.contents:SetSize( self.mainPanel:GetWide()-self.sidePanel:GetWide()-(2*PROJECT0.UI.Margin25), self.mainPanel:GetTall()-(2*PROJECT0.UI.Margin25)    )
    self.contents.Paint = function() end

    local sortedConfig = {}
    for k, v in pairs( PROJECT0.CONFIGMETA ) do
        table.insert( sortedConfig, { v.SortOrder, k } )
    end

    table.SortByMember( sortedConfig, 1, false )

    self.pages = {}
    self.categoryButtons = {}
    self.activePage = 0
    for k, v in pairs( sortedConfig ) do
        local configMetaKey = v[2]
        local configMeta = PROJECT0.CONFIGMETA[configMetaKey]

        local pageCategory = self:CreateCategory( configMetaKey, configMeta )

        local createVariablesPage = false
        for key, val in ipairs( configMeta:GetSortedVariables() ) do
            if( val.Type == PROJECT0.TYPE.Table ) then continue end

            createVariablesPage = true
            break
        end

        if( createVariablesPage ) then
            local page = vgui.Create( "Panel", self.contents )
            page:Dock( FILL )

            local scrollPanel = vgui.Create( "pz_scrollpanel", page )
            scrollPanel:Dock( FILL )

            page.scrollPanel = scrollPanel

            local pageKey = pageCategory:AddPage( page, "", "Variables" )

            page.Refresh = function( self2 )
                scrollPanel:Clear()
                self.pages[pageKey].VariablePanels = {}

                for key, val in ipairs( configMeta:GetSortedVariables() ) do
                    local headerH = PROJECT0.FUNC.ScreenScale( 75 )
                    local customElement = val.Type == PROJECT0.TYPE.Table and val.VguiElement

                    if( val.Type == PROJECT0.TYPE.Table ) then continue end

                    local variablePanel = vgui.Create( "DPanel", scrollPanel )
                    variablePanel:Dock( TOP )
                    variablePanel:SetTall( headerH )
                    variablePanel:DockMargin( 0, 0, PROJECT0.UI.Margin10, PROJECT0.UI.Margin10 )
                    variablePanel.Paint = function( self2, w, h )
                        self2:CreateFadeAlpha( false, 0, 0.5, false, self2.highlight, 100, 0.5 )

                        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
                        surface.DrawRect( 0, 0, w, h )

                        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                        surface.DrawRect( 0, 0, 5, h )

                        draw.SimpleText( val.Name, "MontserratBold22", PROJECT0.UI.Margin25, headerH/2+1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
                        draw.SimpleText( val.Description, "MontserratMedium21", PROJECT0.UI.Margin25, headerH/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
                    end

                    self.pages[pageKey].VariablePanels[val.Key] = variablePanel

                    local targetH = PROJECT0.FUNC.ScreenScale( 40 )
                    local margin = (variablePanel:GetTall()-targetH)/2

                    if( val.GetOptions ) then
                        local options = val.GetOptions()

                        local comboSelect = vgui.Create( "pz_combo", variablePanel )
                        comboSelect:Dock( RIGHT )
                        comboSelect:DockMargin( 0, margin, PROJECT0.UI.Margin25, margin )
                        comboSelect:SetWide( PROJECT0.FUNC.ScreenScale( 200 ) )
                        comboSelect:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
                        comboSelect:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
                        comboSelect:SetValue( "Select Option" )

                        local currentValue = configMeta:GetConfigValue( val.Key )
                        for k, v in pairs( options ) do
                            comboSelect:AddChoice( v, k, currentValue == k )
                        end

                        comboSelect.OnSelect = function( self2, index, value, data )
                            PROJECT0.FUNC.RequestConfigChange( configMetaKey, val.Key, data )
                        end
                    elseif( val.Type == PROJECT0.TYPE.Int ) then 
                        local numberWang = vgui.Create( "pz_numberwang", variablePanel )
                        numberWang:Dock( RIGHT )
                        numberWang:DockMargin( 0, margin, PROJECT0.UI.Margin25, margin )
                        numberWang:SetWide( PROJECT0.FUNC.ScreenScale( 200 ) )
                        numberWang:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
                        numberWang:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
                        numberWang:SetValue( configMeta:GetConfigValue( val.Key ) )
                        numberWang.OnChange = function( self2 )
                            PROJECT0.FUNC.RequestConfigChange( configMetaKey, val.Key, numberWang:GetValue() )
                        end
                    elseif( val.Type == PROJECT0.TYPE.String ) then
                        local textEntry = vgui.Create( "pz_textentry", variablePanel )
                        textEntry:Dock( RIGHT )
                        textEntry:DockMargin( 0, margin, PROJECT0.UI.Margin25, margin )
                        textEntry:SetWide( PROJECT0.FUNC.ScreenScale( 200 ) )
                        textEntry:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
                        textEntry:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
                        textEntry:SetValue( configMeta:GetConfigValue( val.Key ) )
                        textEntry.OnChange = function( self2 )
                            PROJECT0.FUNC.RequestConfigChange( configMetaKey, val.Key, textEntry:GetValue() )
                        end
                    end
                end
            end
        end

        for key, val in ipairs( configMeta:GetSortedVariables() ) do
            if( val.Type != PROJECT0.TYPE.Table ) then continue end

            local page = vgui.Create( "Panel", self.contents )
            page:Dock( FILL )
            page:SetVisible( false )
            page:SetAlpha( 0 )
        
            local customElement  = vgui.Create( val.VguiElement, page )
            customElement:Dock( FILL )
            customElement:SetSize( self.contents:GetSize() )
            if( customElement.FillPanel ) then customElement:FillPanel() end
            if( customElement.Refresh ) then 
                page.Refresh = function()
                    customElement:Refresh()
                end
            end

            pageCategory:AddPage( page, val.Key, val.Name )
        end
    end

    hook.Add( "Project0.Hooks.ConfigUpdated", "Project0.Hooks.ConfigUpdated.ConfigPage", function() self:Refresh() end )

    self:Refresh()
    self:SetActivePage( 1 )
    --self:SetActivePage( 5 )
end

function PANEL:Refresh()
    for k, v in pairs( self.pages ) do
        if( not v.Panel.Refresh ) then continue end
        v.Panel:Refresh()
    end
end

function PANEL:CreateCategory( id, configMeta )
    local buttonPanel = vgui.Create( "Panel", self.sidePanel )
    buttonPanel:Dock( TOP )
    buttonPanel:SetTall( PROJECT0.FUNC.ScreenScale( 50 ) )
    buttonPanel.expanded = true
    buttonPanel.textureRotation = 0
    buttonPanel.SetExpanded = function( self2, expanded, instant )
        if( self2.expanded == expanded ) then return end
        self2.expanded = expanded

        local newH = expanded and self2.button:GetTall()+(self2.expandedH or 0) or self2.button:GetTall()
        if( not instant ) then
            self2:SizeTo( self.sidePanel:GetWide(), newH, 0.2 )
        else
            self2:SetTall( newH )
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

    local categoryKey = #self.categoryButtons+1
    self.categoryButtons[categoryKey] = buttonPanel

    local arrowMat = Material( "project0/icons/down.png", "noclamp smooth" )
    local iconSize = PROJECT0.FUNC.ScreenScale( 20 )

    buttonPanel.button = vgui.Create( "DButton", buttonPanel )
    buttonPanel.button:Dock( TOP )
    buttonPanel.button:SetTall( PROJECT0.FUNC.ScreenScale( 50 ) )
    buttonPanel.button:SetText( "" )
    local iconMat = Material( configMeta.Icon )
    buttonPanel.button.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 50, false, false, buttonPanel.expanded, 155, 0.2 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
        surface.DrawRect( 0, 0, w, h )

        local borderW = PROJECT0.FUNC.ScreenScale( 5 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, 100+self2.alpha ) )
        surface.DrawRect( 0, 0, borderW, h )

        local textAlpha = 100+self2.alpha

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, textAlpha ) )
        surface.SetMaterial( iconMat )
        local iconSize = PROJECT0.FUNC.ScreenScale( 24 )
        surface.DrawTexturedRect( borderW+(h/2)-(iconSize/2), (h/2)-(iconSize/2), iconSize, iconSize )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
        surface.SetMaterial( arrowMat )
        surface.DrawTexturedRectRotated( w-h/2, h/2, iconSize, iconSize, math.Clamp( (buttonPanel.textureRotation or -90), -90, 0 ) )

        draw.SimpleText( string.upper( configMeta.Title ), "MontserratBold25", borderW+(h/2)-(iconSize/2)+iconSize+PROJECT0.UI.Margin15, h/2, PROJECT0.FUNC.GetTheme( 4, textAlpha ), 0, TEXT_ALIGN_CENTER )
    end
    buttonPanel.button.DoClick = function()
        buttonPanel:SetExpanded( not buttonPanel.expanded )
    end

    buttonPanel.button.AddPage = function( self2, panel, variableKey, title )
        panel:SetVisible( false )
        panel:SetAlpha( 0 )

        local key = #self.pages+1
        self.pages[key] = {
            Category = categoryKey,
            Panel = panel,
            ConfigID = id,
            VariableKey = variableKey
        }

        local pageButton = vgui.Create( "DButton", buttonPanel )
        pageButton:Dock( TOP )
        pageButton:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
        pageButton:SetText( "" )
        pageButton.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 50, false, false, self.activePage == key, 155, 0.2 )
    
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, self2.alpha ) )
            surface.DrawRect( 0, 0, w, h )
    
            draw.SimpleText( title, "MontserratMedium20", PROJECT0.UI.Margin10, h/2, PROJECT0.FUNC.GetTheme( 3, 100+self2.alpha ), 0, TEXT_ALIGN_CENTER )
        end
        pageButton.DoClick = function()
            self:SetActivePage( key )
        end

        buttonPanel.expandedH = (buttonPanel.expandedH or 0)+pageButton:GetTall()

        if( buttonPanel.expanded ) then
            buttonPanel:SetTall( buttonPanel.button:GetTall()+buttonPanel.expandedH )
        end

        return key
    end

    return buttonPanel.button
end

function PANEL:GetPagePanel( key )
    if( not self.pages[key] ) then return end

    return self.pages[key].Panel
end

function PANEL:SetActivePage( key, instant )
    if( key == self.activePage ) then return end

    local currentPanel = self:GetPagePanel( self.activePage )
    if( IsValid( currentPanel ) ) then
        currentPanel:SetVisible( false )
        currentPanel:SetAlpha( 0 )
    end

    local pageInfo = self.pages[key]
    pageInfo.Panel:SetVisible( true )
    pageInfo.Panel:AlphaTo( 255, 0.2 )

    self.categoryButtons[pageInfo.Category]:SetExpanded( true, instant )

    self.activePage = key
end

function PANEL:OpenPageByID( id, variableKey )
    for k, v in ipairs( self.pages ) do
        if( v.ConfigID != id or (variableKey and v.VariableKey != variableKey) ) then continue end

        self:SetActivePage( k )
        return v
    end
end

function PANEL:GotoVariableOnPage( id, key )
    if( PROJECT0.CONFIGMETA[id].Variables[key].Type == PROJECT0.TYPE.Table ) then
        self:OpenPageByID( id, key )
        return
    end

    local page = self:OpenPageByID( id )
    if( not page ) then return end

    local variablePanel = page.VariablePanels[key]
    if( not IsValid( variablePanel ) ) then return end

    timer.Simple( 0, function() 
        page.Panel.scrollPanel:ScrollToChild( variablePanel ) 
    end )

    timer.Simple( 0.5, function()
        if( IsValid( variablePanel.button ) ) then
            variablePanel.button:SetExpanded( true )
        end
    end )

    variablePanel.highlight = true

    timer.Simple( 1, function()
        if( not IsValid( variablePanel ) ) then return end
        variablePanel.highlight = false
    end )
end

function PANEL:CreateSavePopout()
    local startY = select( 2, self.mainPanel:GetPos() )

    local popout = vgui.Create( "DPanel", self.mainPanel )
    popout:SetZPos( 1000 )
    popout:SetSize( ScrW()*0.22, PROJECT0.FUNC.ScreenScale( 85 ) )
    popout:SetPos( (self.mainPanel:GetWide()/2)-(popout:GetWide()/2), self.mainPanel:GetTall() )
    popout.finalX, popout.finalY = (self.mainPanel:GetWide()/2)-(popout:GetWide()/2), self.mainPanel:GetTall()-25-popout:GetTall()
    popout:MoveTo( popout.finalX, popout.finalY, 0.2 )
    popout.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_admin_savepopout", 0, startY, ScrW(), startY+self.mainPanel:GetTall() )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_admin_savepopout", x, y, 1, 1, 1, 255, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, 0, 5, h )

        draw.SimpleText( "UNSAVED CHANGES", "MontserratBold25", 25, h/2+2, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( "Please save/reset your changes.", "MontserratMedium21", 25, h/2-2, PROJECT0.FUNC.GetTheme( 3, 100 ), 0, 0 )
    end
    popout.Think = function( self2 )
        if( CurTime() >= (self2.shakeEnd or 0) ) then 
            if( self2:GetX() <= self.savePopout.finalX+5 and self2:GetX() >= self.savePopout.finalX-5 ) then return end
            self.savePopout:SetPos( self.savePopout.finalX, self.savePopout.finalY  )
            return
        end

        if( self2.isMoving ) then return end
        self2:MoveNext()
    end
    popout.MoveNext = function( self2 )
        self2.isMoving = true

        local moveDistance = self2:GetPos() <= self.savePopout.finalX and 10 or -10
        self.savePopout:MoveTo( self.savePopout.finalX+moveDistance, self.savePopout.finalY, 0.05, 0, -1, function()
            self2.isMoving = false
        end )
    end

    local marginTop = PROJECT0.FUNC.ScreenScale( 25 )

    local saveButton = vgui.Create( "DButton", popout )
    saveButton:Dock( RIGHT )
    saveButton:DockMargin( 0, marginTop, PROJECT0.FUNC.ScreenScale( 25 ), marginTop )
    saveButton:SetText( "" )
    saveButton:SetWide( PROJECT0.FUNC.ScreenScale( 100 ) )
    saveButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 100 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
        surface.DrawRect( 0, 0, w, h )

        draw.SimpleText( "SAVE", "MontserratBold25", w/2, h/2-1, PROJECT0.FUNC.GetTheme( 4, 100+self2.alpha ), 1, 1 )
    end
    saveButton.DoClick = function()
        if( not PROJECT0.TEMP.ChangedConfig or table.Count( PROJECT0.TEMP.ChangedConfig ) <= 0 ) then return end

        net.Start( "Project0.RequestSaveConfigChanges" )
            net.WriteUInt( table.Count( PROJECT0.TEMP.ChangedConfig ), 5 )
     
            for k, v in pairs( PROJECT0.TEMP.ChangedConfig ) do
                net.WriteString( k )
                net.WriteUInt( table.Count( v ), 5 )
    
                for key, val in pairs( v ) do
                    net.WriteString( key )
                    PROJECT0.FUNC.WriteTypeValue( PROJECT0.FUNC.GetConfigVariableType( k, key ), val )
                end
            end
        net.SendToServer()
    
        PROJECT0.TEMP.ChangedConfig = nil
        self:Refresh()
    end

    local resetButton = vgui.Create( "DButton", popout )
    resetButton:Dock( RIGHT )
    resetButton:DockMargin( 0, marginTop, PROJECT0.FUNC.ScreenScale( 10 ), marginTop )
    resetButton:SetText( "" )
    resetButton:SetWide( PROJECT0.FUNC.ScreenScale( 100 ) )
    resetButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 180 )
        
        draw.SimpleText( "RESET", "MontserratBold25", w/2, h/2-1, PROJECT0.FUNC.GetTheme( 4, 100+self2.alpha ), 1, 1 )
    end
    resetButton.DoClick = function()
        PROJECT0.TEMP.ChangedConfig = nil
        self:Refresh()
    end

    self.savePopout = popout
end

function PANEL:CloseSavePopout()
    self.savePopout.Closing = true
    self.savePopout:MoveTo( self.savePopout.finalX, self.mainPanel:GetTall(), 0.2, 0, -1, function()
        self.savePopout:Remove()
    end )
end

function PANEL:AttemptClose()
    if( not PROJECT0.TEMP.ChangedConfig or table.Count( PROJECT0.TEMP.ChangedConfig ) <= 0 ) then return true end

    self.savePopout.shakeEnd = CurTime()+0.5
    return false
end

function PANEL:Think()
    if( PROJECT0.TEMP.ChangedConfig and table.Count( PROJECT0.TEMP.ChangedConfig ) > 0 ) then
        if( IsValid( self.savePopout ) ) then return end

        self:CreateSavePopout()
    elseif( IsValid( self.savePopout ) and not self.savePopout.Closing ) then
        self:CloseSavePopout()
    end
end

function PANEL:Paint( w, h )

end

vgui.Register( "pz_config_menu", PANEL, "EditablePanel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
