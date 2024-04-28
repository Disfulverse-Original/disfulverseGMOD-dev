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

    local values = PROJECT0.FUNC.GetChangedVariable( "GENERAL", "Rarities" ) or PROJECT0.CONFIGMETA.GENERAL:GetConfigValue( "Rarities" )

    local function GetRarityFromOrder( order )
        for k, v in pairs( values ) do
            if( v.Order != order ) then continue end
            return k
        end

        return nil
    end

    local variablePanels = {}
    local addNewButton
    local function RefreshOrder()
        table.sort( variablePanels, function( a, b ) return values[a.RarityKey].Order < values[b.RarityKey].Order end )

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
    local deleteMat = Material( "project0/icons/delete.png", "noclamp smooth" )
    local addMat = Material( "project0/icons/add.png", "noclamp smooth" )
    for k, v in pairs( values ) do
        local textMargin = 5+PROJECT0.UI.Margin10+(2*PROJECT0.FUNC.ScreenScale( 30 ))+PROJECT0.UI.Margin10+PROJECT0.UI.Margin15

        local variablePanel = vgui.Create( "DPanel", self.scrollPanel )
        variablePanel:Dock( TOP )
        variablePanel:SetTall( panelH )
        variablePanel:DockMargin( 0, 0, PROJECT0.UI.Margin10, PROJECT0.UI.Margin10 )
        variablePanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            draw.SimpleText( v.Title, "MontserratBold22", textMargin, h/2+1, PROJECT0.FUNC.GetSolidColor( v.Colors ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "Order: " .. v.Order, "MontserratMedium21", textMargin, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end

        variablePanel.RarityKey = k
        table.insert( variablePanels, variablePanel )

        surface.SetFont( "MontserratBold22" )
        local nameW, nameH = surface.GetTextSize( v.Title )

        local nameButton = vgui.Create( "DButton", variablePanel )
        nameButton:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 16 ), 2 ) )
        nameButton:SetPos( textMargin+nameW+PROJECT0.UI.Margin5, panelH/2-nameH/2-nameButton:GetTall()/2+2 )
        nameButton:SetText( "" )
        nameButton.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 100 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50+self2.alpha ) )
            surface.SetMaterial( editMat )
            surface.DrawTexturedRect( 0, 0, w, h )
        end
        nameButton.DoClick = function()
            PROJECT0.FUNC.DermaStringRequest( "What should the new name be?", "EDIT RARITY", v.Title, "Confirm", function( value )
                values[k].Title = value
                
                PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
                self:Refresh()
            end )
        end

        local gradientAnim = vgui.Create( "pz_gradientanim", variablePanel )
        gradientAnim:SetSize( 5, panelH )
        gradientAnim:SetDirection( 1 )
        gradientAnim:SetAnimSize( panelH*6 )
        gradientAnim:SetColors( unpack( v.Colors ) )
        gradientAnim:StartAnim()

        local orderButtonsPanel = vgui.Create( "Panel", variablePanel )
        orderButtonsPanel:Dock( LEFT )
        orderButtonsPanel:SetWide( PROJECT0.FUNC.ScreenScale( 30 ) )
        orderButtonsPanel:DockMargin( gradientAnim:GetWide()+PROJECT0.UI.Margin10, PROJECT0.UI.Margin15, 0, PROJECT0.UI.Margin15 )

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
                    values[GetRarityFromOrder( v.Order-1 )].Order = v.Order
                    values[k].Order = v.Order-1
                else
                    local nextRarity = GetRarityFromOrder( v.Order+1 )
                    if( not nextRarity ) then return end
                    values[nextRarity].Order = v.Order
                    values[k].Order = v.Order+1
                end

                PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
                RefreshOrder()
            end
        end

        variablePanel.RefreshColors = function( self2 )
            for k, v in ipairs( self2.colorPanels or {} ) do
                v:Remove()
            end

            local topMargin = (self2:GetTall()-PROJECT0.FUNC.ScreenScale( 40 ))/2
            local iconSize = PROJECT0.FUNC.ScreenScale( 16 )

            local colorAddButton = vgui.Create( "DButton", self2 )
            colorAddButton:Dock( RIGHT )
            colorAddButton:SetWide( PROJECT0.FUNC.ScreenScale( 40 ) )
            colorAddButton:DockMargin( 0, topMargin, topMargin, topMargin )
            colorAddButton:SetText( "" )
            colorAddButton.Paint = function( self2, w, h )
                self2:CreateFadeAlpha( 0.1, 5 )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, self2.alpha ) )
                surface.DrawRect( 0, 0, w, h )

                PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
                surface.SetMaterial( addMat )
                surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
            end
            colorAddButton.DoClick = function()
                table.insert( values[k].Colors, Color( 255, 255, 255 ) )
                PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
                self2:RefreshColors()
            end

            self2.colorPanels = { colorAddButton }

            for key, val in ipairs( v.Colors ) do
                local colorPanel = vgui.Create( "Panel", self2 )
                colorPanel:Dock( RIGHT )
                colorPanel:SetWide( PROJECT0.FUNC.ScreenScale( 75 ) )
                colorPanel:DockMargin( 0, topMargin, PROJECT0.UI.Margin10, topMargin )
                colorPanel.Paint = function( self2, w, h )
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                    surface.DrawRect( 0, 0, w, h )

                    surface.SetDrawColor( val )
                    surface.DrawRect( 0, h-5, w, 5 )
                end
                colorPanel.AddButton = function( self2, iconMat, doClick )
                    local button = vgui.Create( "DButton", self2 )
                    button:Dock( LEFT )
                    button:SetWide( self2:GetWide()/2 )
                    button:DockMargin( 0, 0, 0, 5 )
                    button:SetText( "" )
                    button.Paint = function( self2, w, h )
                        self2:CreateFadeAlpha( 0.1, 5 )

                        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, self2.alpha ) )
                        surface.DrawRect( 0, 0, w, h )

                        PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )
        
                        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
                        surface.SetMaterial( iconMat )
                        surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
                    end
                    button.DoClick = doClick
                end

                colorPanel:AddButton( editMat, function() 
                    PROJECT0.FUNC.DermaColorRequest( "What should the new colour be?", "EDIT COLOUR", val, "Confirm", function( value ) 
                        values[k].Colors[key] = value
                        PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
                        self2:RefreshColors()
                    end )
                end )

                colorPanel:AddButton( deleteMat, function()
                    if( #values[k].Colors == 1 ) then 
                        PROJECT0.FUNC.DermaMessage( "You can't remove the last color.", "ERROR" )
                        return
                    end

                    table.remove( values[k].Colors, key )
                    PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
                    self2:RefreshColors()
                end )

                table.insert( self2.colorPanels, colorPanel )
            end
        end
        variablePanel:RefreshColors()

        local deleteButton = vgui.Create( "DButton", variablePanel )
        deleteButton:Dock( LEFT )
        deleteButton:SetWide( PROJECT0.FUNC.ScreenScale( 30 ) )
        deleteButton:DockMargin( PROJECT0.UI.Margin10, PROJECT0.UI.Margin15, 0, PROJECT0.UI.Margin15 )
        deleteButton:SetText( "" )
        local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
        deleteButton.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 100 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
            surface.SetMaterial( deleteMat )
            surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
        end
        deleteButton.DoClick = function()
            if( table.Count( values ) == 1 ) then
                PROJECT0.FUNC.DermaMessage( "You must have at least 1 rarity.", "ERROR" )
                return
            end

            PROJECT0.FUNC.DermaQuery( "Do you want to delete the rarity?", "RARITY REMOVAL", "Confirm", function() 
                values[k] = nil

                local sortedRarities = {}
                for k, v in pairs( values ) do
                    table.insert( sortedRarities, { v.Order, k } )
                end
    
                table.SortByMember( sortedRarities, 1, true )
    
                for k, v in ipairs( sortedRarities ) do
                    values[v[2]].Order = k
                end
                
                PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
                self:Refresh()
            end, "Cancel" )
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

        PROJECT0.FUNC.DermaStringRequest( "What should the unique ID be?", "CREATE RARITY", "new_rarity", "Confirm", function( rarityKey )
            if( values[rarityKey] ) then
                PROJECT0.FUNC.DermaMessage( "A rarity with this ID already exists.", "ERROR" )
                return
            end

            values[rarityKey] = {
                Order = table.Count( values )+1,
                Title = "New Rarity",
                Type = "Gradient", 
                Colors = { Color( 255, 255, 255 ), Color( 100, 100, 100 ) }
            }
            
            PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Rarities", values )
            self:Refresh()
        end )
    end

    RefreshOrder()
end

vgui.Register( "pz_config_rarities", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
