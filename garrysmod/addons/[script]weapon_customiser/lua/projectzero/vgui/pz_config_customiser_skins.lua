--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:FillPanel()
    self:CreateScrollPanel()

    self.grid = vgui.Create( "DIconLayout", self.scrollPanel )
    self.grid:Dock( TOP )
    self.grid:SetSpaceY( PROJECT0.UI.Margin10 )
    self.grid:SetSpaceX( PROJECT0.UI.Margin10 )
end

function PANEL:Refresh()
    self.grid:Clear()

    local spacing = PROJECT0.UI.Margin10
    local gridWide = self:GetWide()-self.scrollPanel:GetVBar():GetWide()-PROJECT0.UI.Margin10
    local slotsWide = 2
    local slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    local values = PROJECT0.FUNC.GetChangedVariable( "CUSTOMISER", "Skins" ) or PROJECT0.CONFIGMETA.CUSTOMISER:GetConfigValue( "Skins" )

    local sortedSkins = {}
    for k, v in ipairs( PROJECT0.DEVCONFIG.WeaponSkins ) do
        table.insert( sortedSkins, { PROJECT0.FUNC.GetRarityOrder( (values[k] or {}).Rarity or "" ), k } )
    end

    table.SortByMember( sortedSkins, 1 )

    local panelH = PROJECT0.FUNC.ScreenScale( 75 )
    local textMargin = 5+panelH+PROJECT0.UI.Margin15
    for k, v in ipairs( sortedSkins ) do
        local skinKey = v[2]
        local devConfigInfo = PROJECT0.DEVCONFIG.WeaponSkins[skinKey]

        local rarityKey = (values[skinKey] or {}).Rarity or ""
        local rarityName = PROJECT0.FUNC.GetRarityName( rarityKey )
        local colors = PROJECT0.FUNC.GetRarityColor( rarityKey )

        local iconMat = Material( devConfigInfo.Icon )

        local variablePanel = self.grid:Add( "Panel" )
        variablePanel:SetSize( slotSize, panelH )
        variablePanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( iconMat )
            local iconSize = h-2*PROJECT0.UI.Margin10
            surface.DrawTexturedRect( 5+PROJECT0.UI.Margin10, PROJECT0.UI.Margin10, iconSize, iconSize )

            draw.SimpleText( devConfigInfo.Name, "MontserratBold22", textMargin, h/2+1, PROJECT0.FUNC.GetSolidColor( colors ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( rarityName, "MontserratMedium21", textMargin, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end

        local gradientAnim = vgui.Create( "pz_gradientanim", variablePanel )
        gradientAnim:SetSize( 5, panelH )
        gradientAnim:SetDirection( 1 )
        gradientAnim:SetAnimSize( panelH*6 )
        gradientAnim:SetColors( unpack( colors ) )
        gradientAnim:StartAnim()

        local topMargin = (panelH-PROJECT0.FUNC.ScreenScale( 40 ))/2
        local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
        local editMat = Material( "project0/icons/edit.png", "noclamp smooth" )

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
            local options = {}
            for k, v in pairs( PROJECT0.CONFIG.GENERAL.Rarities ) do
                options[k] = v.Title
            end
    
            PROJECT0.FUNC.DermaComboRequest( "What rarity should this skin be?", "SKIN EDITOR", options, false, true, false, function( value, data )
                if( not options[data] ) then return end
    
                values[skinKey] = {
                    Rarity = data
                }
    
                PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Skins", values )
                self:Refresh()
            end )
        end
    end
end

vgui.Register( "pz_config_customiser_skins", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
