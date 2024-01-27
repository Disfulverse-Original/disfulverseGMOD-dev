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

    local values = PROJECT0.FUNC.GetChangedVariable( "CUSTOMISER", "Stickers" ) or PROJECT0.CONFIGMETA.CUSTOMISER:GetConfigValue( "Stickers" )

    local sortedStickers = {}
    for k, v in pairs( values ) do
        table.insert( sortedStickers, { PROJECT0.FUNC.GetRarityOrder( v.Rarity ), k } )
    end

    table.SortByMember( sortedStickers, 1 )

    local panelH = PROJECT0.FUNC.ScreenScale( 75 )
    local textMargin = 5+panelH+PROJECT0.UI.Margin15
    for k, v in ipairs( sortedStickers ) do
        local stickerKey = v[2]
        local stickerConfig = values[stickerKey]

        local rarityName = PROJECT0.FUNC.GetRarityName( stickerConfig.Rarity )
        local colors = PROJECT0.FUNC.GetRarityColor( stickerConfig.Rarity )

        local variablePanel = self.grid:Add( "Panel" )
        variablePanel:SetSize( slotSize, panelH )
        variablePanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            draw.SimpleText( stickerConfig.Name, "MontserratBold22", textMargin, h/2+1, PROJECT0.FUNC.GetSolidColor( colors ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( rarityName, "MontserratMedium21", textMargin, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end

        local gradientAnim = vgui.Create( "pz_gradientanim", variablePanel )
        gradientAnim:SetSize( 5, panelH )
        gradientAnim:SetDirection( 1 )
        gradientAnim:SetAnimSize( panelH*6 )
        gradientAnim:SetColors( unpack( colors ) )
        gradientAnim:StartAnim()

        local imageTexture = vgui.Create( "pz_imagepanel", variablePanel )
        imageTexture:Dock( LEFT )
        imageTexture:SetWide( panelH-(2*PROJECT0.UI.Margin10) )
        imageTexture:DockMargin( 5+PROJECT0.UI.Margin10, PROJECT0.UI.Margin10, 0, PROJECT0.UI.Margin10 )
        imageTexture:SetImagePath( stickerConfig.Icon )

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
            self:CreateConfigPopup( stickerKey, values )
        end
    end

    local addNewButton = self.grid:Add( "DButton" )
    addNewButton:SetSize( slotSize, panelH )
    addNewButton:SetText( "" )
    local addMat = Material( "project0/icons/add.png", "noclamp smooth" )
    local iconSize = PROJECT0.FUNC.ScreenScale( 32 )
    addNewButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.1, 50 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
        surface.DrawRect( 0, 0, w, h )

        PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, h-3, w, 3 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
        surface.SetMaterial( addMat )
        surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
    end
    addNewButton.DoClick = function()
        table.insert( values, {
            Name = "New Sticker",
            Icon = "https://i.imgur.com/ynMWYER.png",
            Rarity = PROJECT0.FUNC.GetFirstRarity()
        } )
        
        PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Stickers", values )
        self:Refresh()
    end
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
    popup:SetHeader( "STICKER CONFIG" )
    popup.OnClose = function()
        if( not valueChanged ) then return end
        PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Stickers", values )
        self:Refresh()
    end
    popup:FinishSetup()

    self.popup = popup

    popup:SetInfo( "Sticker Info", "Basic information and actions.", Material( "project0/icons/data.png" ) )

    popup:AddActionButton( "Delete", Material( "project0/icons/delete.png" ), function()
        PROJECT0.FUNC.DermaQuery( "Are you sure you want to delete this sticker?", "CHARM DELETION", "Confirm", function()
            values[valueKey] = nil
            valueChanged = true
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
    imageTexture:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 200 ), 2 ) )
    imageTexture:SetPos( popup.sectionMargin+popup.sectionWide/2-imageTexture:GetWide()/2, popup.header:GetTall()+(popup.mainPanel.targetH-popup.header:GetTall()-popup.infoBack:GetTall())/2-imageTexture:GetTall()/2 )
    imageTexture:SetImagePath( configItem.Icon )

    -- NAME --
    local nameField = popup:AddField( "Name", "The name of the sticker.", Material( "project0/icons/name_24.png" ) )
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

    -- RARITY --
    local rarityField = popup:AddField( "Rarity", "The rarity of the sticker.", Material( "project0/icons/rarity.png", "noclamp smooth" ) )
    rarityField:SetExtraHeight( PROJECT0.FUNC.ScreenScale( 60 ) )

    local rarityEntry = vgui.Create( "pz_combo", rarityField )
    rarityEntry:Dock( TOP )
    rarityEntry:DockMargin( margin10, margin10, margin10, margin10 )
    rarityEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    rarityEntry:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
    rarityEntry:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 25 ) )
	rarityEntry:DisableShadows( true )
    rarityEntry:SetValue( (PROJECT0.CONFIG.GENERAL.Rarities[configItem.Rarity] or {}).Title or "Error" )
    rarityEntry.OnSelect = function( self2, index, value, data )
        ChangeItemVariable( "Rarity", data )
    end

    for k, v in pairs( PROJECT0.CONFIG.GENERAL.Rarities ) do
        rarityEntry:AddChoice( v.Title, k )
    end

    -- IMAGE --
    local imageField = popup:AddField( "Image", "The image used for the sticker.", Material( "project0/icons/image_24.png" ) )

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

vgui.Register( "pz_config_customiser_stickers", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
