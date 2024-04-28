--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:FillPanel()
    self:CreateScrollPanel()

    self.clickPercents = {}
end

function PANEL:Refresh()
    self.scrollPanel:Clear()

    local values = PROJECT0.FUNC.GetChangedVariable( "CUSTOMISER", "StoreCategories" ) or PROJECT0.CONFIGMETA.CUSTOMISER:GetConfigValue( "StoreCategories" )

    local function GetCategoryFromOrder( order )
        for k, v in pairs( values ) do
            if( v.Order != order ) then continue end
            return k
        end

        return nil
    end

    local variablePanels = {}
    local addNewButton
    local function RefreshOrder()
        table.sort( variablePanels, function( a, b ) return values[a.CategoryKey].Order < values[b.CategoryKey].Order end )

        for k, v in ipairs( variablePanels ) do
            v:SetParent( self.scrollPanel )
            v:Dock( TOP )
        end

        addNewButton:SetParent( self.scrollPanel )
        addNewButton:Dock( TOP )
    end

    local panelH = PROJECT0.FUNC.ScreenScale( 100 )
    local arrowMat = Material( "project0/icons/down.png", "noclamp smooth" )
    local editMat = Material( "project0/icons/edit.png", "noclamp smooth" )
    for k, v in pairs( values ) do
        local textMargin = 5+PROJECT0.UI.Margin10+PROJECT0.FUNC.ScreenScale( 30 )+panelH

        local variablePanel = vgui.Create( "DPanel", self.scrollPanel )
        variablePanel:Dock( TOP )
        variablePanel:SetTall( panelH )
        variablePanel:DockMargin( 0, 0, PROJECT0.UI.Margin10, PROJECT0.UI.Margin10 )
        variablePanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.DrawRect( 0, 0, 5, h )

            draw.SimpleText( v.Name, "MontserratBold22", textMargin, h/2+1, PROJECT0.FUNC.GetSolidColor( v.Colors ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "Order: " .. v.Order, "MontserratMedium21", textMargin, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end

        variablePanel.CategoryKey = k
        table.insert( variablePanels, variablePanel )

        local orderButtonsPanel = vgui.Create( "Panel", variablePanel )
        orderButtonsPanel:Dock( LEFT )
        orderButtonsPanel:SetWide( PROJECT0.FUNC.ScreenScale( 30 ) )
        orderButtonsPanel:DockMargin( 5+PROJECT0.UI.Margin10, PROJECT0.UI.Margin15, 0, PROJECT0.UI.Margin15 )

        local imageTexture = vgui.Create( "pz_imagepanel", variablePanel )
        imageTexture:Dock( LEFT )
        imageTexture:SetWide( panelH-(2*PROJECT0.UI.Margin25) )
        imageTexture:DockMargin( PROJECT0.UI.Margin25, PROJECT0.UI.Margin25, 0, PROJECT0.UI.Margin25 )
        imageTexture:SetImagePath( v.Icon )

        for i = 1, 2 do
            local orderButton = vgui.Create( "DButton", orderButtonsPanel )
            orderButton:Dock( TOP )
            orderButton:SetTall( (panelH-2*PROJECT0.UI.Margin15)/2 )
            orderButton:SetText( "" )
            orderButton.Paint = function( self2, w, h )
                self2:CreateFadeAlpha( 0.2, 100 )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
                surface.DrawRect( 0, 0, w, h )
        
                local lastClicked = self2.lastClicked or 0
                local clickPercent = math.Clamp( (CurTime()-lastClicked)/0.2, 0, 1 )
        
                if( CurTime() < lastClicked+0.3 ) then
                    local boxH = h*clickPercent
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, 100 ) )
                    surface.DrawRect( 0, i == 1 and h-boxH or 0, w, boxH )
                end
        
                local iconSize = PROJECT0.FUNC.ScreenScale( 16 )*clickPercent

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
                surface.SetMaterial( arrowMat )
                surface.DrawTexturedRectRotated( w/2, h/2, iconSize, iconSize, i == 1 and 180 or 0 )
            end
            orderButton.DoClick = function( self2 )
                self2.lastClicked = CurTime()

                if( i == 1 ) then
                    if( v.Order == 1 ) then return end
                    values[GetCategoryFromOrder( v.Order-1 )].Order = v.Order
                    values[k].Order = v.Order-1
                else
                    local nextCategory = GetCategoryFromOrder( v.Order+1 )
                    if( not nextCategory ) then return end
                    values[nextCategory].Order = v.Order
                    values[k].Order = v.Order+1
                end

                PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "StoreCategories", values )
                RefreshOrder()
            end
        end

        local topMargin = (variablePanel:GetTall()-PROJECT0.FUNC.ScreenScale( 40 ))/2
        local iconSize = PROJECT0.FUNC.ScreenScale( 16 )

        local editButton = vgui.Create( "DButton", variablePanel )
        editButton:Dock( RIGHT )
        editButton:SetWide( PROJECT0.FUNC.ScreenScale( 40 ) )
        editButton:DockMargin( 0, topMargin, topMargin, topMargin )
        editButton:SetText( "" )
        editButton.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.1, 5 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, self2.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
            surface.SetMaterial( editMat )
            surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
        end
        editButton.DoClick = function()
            self:CreateConfigPopup( k, values )
        end
    end

    addNewButton = vgui.Create( "DButton", self.scrollPanel )
    addNewButton:Dock( TOP )
    addNewButton:SetTall( PROJECT0.FUNC.ScreenScale( 50 ) )
    addNewButton:DockMargin( 0, 0, PROJECT0.UI.Margin10, 0 )
    addNewButton:SetText( "" )
    addNewButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.1, 50 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
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

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, h-3, w, 3 )

        draw.SimpleText( "ADD NEW", "MontserratBold22", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 100+(self2.alpha/50)*155 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    addNewButton.DoClick = function( self2 )
        self2.lastClicked = CurTime()

        PROJECT0.FUNC.DermaStringRequest( "What should the name be?", "CREATE CATEGORY", "New Category", "Confirm", function( name )
            table.insert( values, {
                Name = name,
                Icon = "project0/icons/paint_64.png",
                Order = table.Count( values )+1,
            } )
            
            PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "StoreCategories", values )
            self:Refresh()
        end )
    end

    RefreshOrder()
end

function PANEL:CreateConfigPopup( valueKey, values )
    if( IsValid( self.popup ) ) then return end

    local configItem = values[valueKey]

    local valueChanged = false
    local function ChangeItemVariable( field, value )
        valueChanged = true
        configItem[field] = value
    end

    local popup = vgui.Create( "pz_config_popup" )
    popup:SetHeader( "CATEGORY CONFIG" )
    popup.OnClose = function()
        if( not valueChanged ) then return end
        PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "StoreCategories", values )
        self:Refresh()
    end
    popup:FinishSetup()

    self.popup = popup

    popup:SetInfo( "Category Info", "Basic information and actions.", Material( "project0/icons/data.png" ) )

    popup:AddActionButton( "Delete", Material( "project0/icons/delete.png" ), function()
        if( table.Count( values ) == 1 ) then
            PROJECT0.FUNC.DermaMessage( "You must have at least 1 category.", "ERROR" )
            return
        end

        PROJECT0.FUNC.DermaQuery( "Are you sure you want to delete this category?", "CATEGORY DELETION", "Confirm", function()
            values[valueKey] = nil
            valueChanged = true

            local sortedCategories = {}
            for k, v in pairs( values ) do
                table.insert( sortedCategories, { v.Order, k } )
            end

            table.SortByMember( sortedCategories, 1, true )

            for k, v in ipairs( sortedCategories ) do
                values[v[2]].Order = k
            end
            
            popup:Close()
        end, "Cancel" )
    end )

    -- VARIABLES --
    local margin10 = PROJECT0.UI.Margin10

    -- ITEM ID --
    local itemIDLeftPadding = PROJECT0.FUNC.ScreenScale( 40 )

    local itemIDBack = vgui.Create( "Panel", popup.infoBottom )
    itemIDBack:Dock( LEFT )
    itemIDBack:DockMargin( margin10, margin10, 0, margin10 )
    itemIDBack:DockPadding( itemIDLeftPadding, 0, 0, 0 )
    itemIDBack:SetWide( PROJECT0.FUNC.ScreenScale( 150 ) )
    itemIDBack.Paint = function( self2, w, h ) 
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )

        draw.SimpleText( "ID:", "MontserratBold20", itemIDLeftPadding/2, h/2-1, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local itemIDEntry = vgui.Create( "pz_textentry", itemIDBack )
    itemIDEntry:Dock( FILL )
    itemIDEntry:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
    itemIDEntry:SetHighlightColor( PROJECT0.FUNC.GetTheme( 1 ) )
    itemIDEntry:SetValue( valueKey )
    itemIDEntry:SetEnabled( false )
    itemIDEntry:DisableShadows( true )

    -- ITEM SLOT --
    local imageTexture = vgui.Create( "pz_imagepanel", popup )
    imageTexture:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 100 ), 2 ) )
    imageTexture:SetPos( popup.sectionMargin+popup.sectionWide/2-imageTexture:GetWide()/2, popup.header:GetTall()+(popup.mainPanel.targetH-popup.header:GetTall()-popup.infoBack:GetTall())/2-imageTexture:GetTall()/2 )
    imageTexture:SetImagePath( configItem.Icon )

    -- NAME --
    local nameField = popup:AddField( "Name", "The name of the category.", Material( "project0/icons/name_24.png" ) )
    nameField:SetExtraHeight( PROJECT0.FUNC.ScreenScale( 60 ) )

    local nameEntry = vgui.Create( "pz_textentry", nameField )
    nameEntry:Dock( TOP )
    nameEntry:DockMargin( margin10, margin10, margin10, margin10 )
    nameEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    nameEntry:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
    nameEntry:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 25 ) )
    nameEntry:SetValue( configItem.Name )
    nameEntry:DisableShadows( true )
    nameEntry.OnChange = function( self2 )
        ChangeItemVariable( "Name", self2:GetValue() )
    end

    -- IMAGE --
    local imageField = popup:AddField( "Icon", "The icon used for the category.", Material( "project0/icons/image_24.png" ) )

    local imageEntry
    surface.SetFont( "MontserratBold22" )

    local imageHint = vgui.Create( "DPanel", imageField )
    imageHint:Dock( TOP )
    imageHint:DockMargin( 0, margin10, 0, margin10 )
    imageHint:SetTall( select( 2, surface.GetTextSize( "Press enter to update image" ) ) )
    imageHint.Paint = function( self2, w, h ) 
        local text = "Image loaded"
        if( IsValid( imageEntry ) and imageEntry:GetValue() != configItem.Icon ) then
            text = "Press enter to update image"
        elseif( imageTexture.loadingImage ) then
            text = "Loading image..."
        end

        draw.SimpleText( text, "MontserratBold22", w/2, 0, PROJECT0.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER )
    end

    imageEntry = vgui.Create( "pz_textentry", imageField )
    imageEntry:Dock( TOP )
    imageEntry:DockMargin( margin10, 0, margin10, 0 )
    imageEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    imageEntry:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
    imageEntry:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 25 ) )
    imageEntry:SetValue( configItem.Icon )
    imageEntry:DisableShadows( true )
    imageEntry.OnEnter = function( self2 )
        ChangeItemVariable( "Icon", self2:GetValue() )
        imageTexture:SetImagePath( configItem.Icon )
    end

    imageField:SetExtraHeight( margin10+imageHint:GetTall()+margin10+imageEntry:GetTall()+margin10 )
end

vgui.Register( "pz_config_customiser_storecategories", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
