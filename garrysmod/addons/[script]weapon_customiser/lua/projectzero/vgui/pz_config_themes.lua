--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:FillPanel()
    self:CreateScrollPanel()
end

function PANEL:Refresh()
    self.scrollPanel:Clear()

    local values = PROJECT0.FUNC.GetChangedVariable( "GENERAL", "Themes" ) or PROJECT0.CONFIGMETA.GENERAL:GetConfigValue( "Themes" )

    local descriptions = {
        "Background colour.",
        "Foreground colour.",
        "Text and icon colour.",
        "Accent colour."
    }

    local panelH = PROJECT0.FUNC.ScreenScale( 125 )
    for k, v in ipairs( values ) do
        local variablePanel = vgui.Create( "DPanel", self.scrollPanel )
        variablePanel:Dock( TOP )
        variablePanel:SetTall( panelH )
        variablePanel:DockMargin( 0, 0, PROJECT0.UI.Margin10, PROJECT0.UI.Margin10 )
        variablePanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.DrawRect( 0, 0, 5, h )

            draw.SimpleText( "Theme " .. k, "MontserratBold22", PROJECT0.UI.Margin25, h/2+1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( descriptions[k], "MontserratMedium21", PROJECT0.UI.Margin25, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end

        local colorPicker = vgui.Create( "DColorMixer", variablePanel )
        colorPicker:Dock( RIGHT )
        colorPicker:SetWide( PROJECT0.FUNC.ScreenScale( 300 ) )
        colorPicker:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin10, 4 ) )
        colorPicker:SetPalette( false )
        colorPicker:SetAlphaBar( false )
        colorPicker:SetWangs( true )
        colorPicker:SetColor( v )
        colorPicker.ValueChanged = function( self2, col )
            values[k] = col
            PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Themes", values )
        end

        local colorPanel = vgui.Create( "Panel", variablePanel )
        colorPanel:Dock( RIGHT )
        colorPanel:SetWide( PROJECT0.FUNC.ScreenScale( 50 ) )
        colorPanel:DockMargin( 0, PROJECT0.UI.Margin10, 0, PROJECT0.UI.Margin10 )
        colorPanel.Paint = function( self2, w, h )
            PROJECT0.FUNC.BeginShadow( "config_page_theme_" .. k )
            local x, y = self2:LocalToScreen( 0, 0 )
            surface.SetDrawColor( values[k] )
            surface.DrawRect( x, y, w, h )
            PROJECT0.FUNC.EndShadow( "config_page_theme_" .. k, x, y, 1, 1, 1, 255, 0, 0, false )
        end
    end

    local resetThemesButton = vgui.Create( "DButton", self.scrollPanel )
    resetThemesButton:Dock( TOP )
    resetThemesButton:SetTall( PROJECT0.FUNC.ScreenScale( 50 ) )
    resetThemesButton:DockMargin( 0, 0, PROJECT0.UI.Margin10, 0 )
    resetThemesButton:SetText( "" )
    resetThemesButton.Paint = function( self2, w, h )
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

        draw.SimpleText( "RESET TO DEFAULT", "MontserratBold22", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 100+(self2.alpha/50)*155 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    resetThemesButton.DoClick = function( self2 )
        self2.lastClicked = CurTime()

        values = table.Copy( PROJECT0.CONFIGMETA.GENERAL:GetConfigDefaultValue( "Themes" ) )
        PROJECT0.FUNC.RequestConfigChange( "GENERAL", "Themes", values )
    end
end

vgui.Register( "pz_config_themes", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
