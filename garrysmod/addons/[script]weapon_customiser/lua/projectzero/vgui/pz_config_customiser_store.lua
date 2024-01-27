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

local cosmeticTypes = {
    {
        Name = "Charm",
        Description = "A charm hanging from a weapon.",
        Icon = Material( "project0/icons/charm.png", "noclamp smooth" ),
        GetItemInfo = function( itemKey )
            local configTable = PROJECT0.CONFIG.CUSTOMISER.Charms[itemKey]
            if( not configTable ) then return end

            return { configTable.Rarity, configTable.Name }
        end,
        GetItemList = function()
            local items = {}
            for k, v in pairs( PROJECT0.CONFIG.CUSTOMISER.Charms ) do
                table.insert( items, { k, v.Name } )
            end

            return items
        end,
        OnCreatePnl = function( pnl, itemKey )
            local modelPanel = vgui.Create( "pz_modelpanel", pnl )
            modelPanel:Dock( FILL )
            modelPanel:SetFOV( 30 )
            modelPanel:ChangeModel( PROJECT0.CONFIG.CUSTOMISER.Charms[itemKey].Model )
        end
    },
    {
        Name = "Sticker",
        Description = "A sticker on the weapon.",
        Icon = Material( "project0/icons/sticker.png", "noclamp smooth" ),
        GetItemInfo = function( itemKey )
            local configTable = PROJECT0.CONFIG.CUSTOMISER.Stickers[itemKey]
            if( not configTable ) then return end

            return { configTable.Rarity, configTable.Name }
        end,
        GetItemList = function()
            local items = {}
            for k, v in pairs( PROJECT0.CONFIG.CUSTOMISER.Stickers ) do
                table.insert( items, { k, v.Name } )
            end

            return items
        end,
        OnCreatePnl = function( pnl, itemKey )
            local skinTexture = vgui.Create( "pz_imagepanel", pnl )
            skinTexture:Dock( FILL )
            skinTexture:SetImagePath( PROJECT0.CONFIG.CUSTOMISER.Stickers[itemKey].Icon )
        end
    },
    {
        Name = "Skin",
        Description = "A new material for the weapon.",
        Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" ),
        GetItemInfo = function( itemKey )
            local devConfig = PROJECT0.DEVCONFIG.WeaponSkins[itemKey]
            if( not devConfig ) then return end

            return { PROJECT0.FUNC.GetSkinRarity( itemKey ), devConfig.Name }
        end,
        GetItemList = function()
            local items = {}
            for k, v in pairs( PROJECT0.DEVCONFIG.WeaponSkins ) do
                table.insert( items, { k, v.Name } )
            end

            return items
        end,
        OnCreatePnl = function( pnl, itemKey )
            local skinTexture = vgui.Create( "pz_imagepanel", pnl )
            skinTexture:Dock( FILL )
            skinTexture:SetImagePath( PROJECT0.DEVCONFIG.WeaponSkins[itemKey].Icon )
        end
    }
}

function PANEL:Refresh()
    self.grid:Clear()

    local spacing = PROJECT0.UI.Margin10
    local gridWide = self:GetWide()-self.scrollPanel:GetVBar():GetWide()-PROJECT0.UI.Margin10
    local slotsWide = 2
    local slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    local values = PROJECT0.FUNC.GetChangedVariable( "CUSTOMISER", "Store" ) or PROJECT0.CONFIGMETA.CUSTOMISER:GetConfigValue( "Store" )

    local sortedValues = {}
    for k, v in pairs( values ) do
        local itemInfo = cosmeticTypes[v.Type].GetItemInfo( v.ItemID )
        table.insert( sortedValues, { PROJECT0.FUNC.GetRarityOrder( itemInfo[1] ), k, itemInfo[1], itemInfo[2] } )
    end

    table.SortByMember( sortedValues, 1 )

    local panelH = PROJECT0.FUNC.ScreenScale( 75 )
    local textMargin = 5+panelH+PROJECT0.UI.Margin15
    for k, v in ipairs( sortedValues ) do
        local storeKey = v[2]
        local storeConfig = values[storeKey]

        local rarityName = PROJECT0.FUNC.GetRarityName( v[3] )
        local colors = PROJECT0.FUNC.GetRarityColor( v[3] )

        local variablePanel = self.grid:Add( "Panel" )
        variablePanel:SetSize( slotSize, panelH )
        variablePanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( 0, 0, w, h )

            draw.SimpleText( v[4], "MontserratBold22", textMargin, h/2+1, PROJECT0.FUNC.GetSolidColor( colors ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( PROJECT0.FUNC.FormatStoreCurrency( storeConfig.Price ), "MontserratMedium21", textMargin, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end

        local gradientAnim = vgui.Create( "pz_gradientanim", variablePanel )
        gradientAnim:SetSize( 5, panelH )
        gradientAnim:SetDirection( 1 )
        gradientAnim:SetAnimSize( panelH*6 )
        gradientAnim:SetColors( unpack( colors ) )
        gradientAnim:StartAnim()

        local displayPanel = vgui.Create( "Panel", variablePanel )
        displayPanel:Dock( LEFT )
        displayPanel:SetWide( panelH-(2*PROJECT0.UI.Margin10) )
        displayPanel:DockMargin( 5+PROJECT0.UI.Margin10, PROJECT0.UI.Margin10, 0, PROJECT0.UI.Margin10 )

        cosmeticTypes[storeConfig.Type].OnCreatePnl( displayPanel, storeConfig.ItemID )

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
            self:CreateConfigPopup( storeKey, values )
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
            Price = 1000,
            Category = 1,
            Type = 1,
            ItemID = 1
        } )
        
        PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Store", values )
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
    popup:SetHeader( "STORE CONFIG" )
    popup.OnClose = function()
        if( not valueChanged ) then return end
        PROJECT0.FUNC.RequestConfigChange( "CUSTOMISER", "Store", values )
        self:Refresh()
    end
    popup:FinishSetup()

    self.popup = popup

    popup:SetInfo( "Item Info", "Basic information and actions.", Material( "project0/icons/data.png" ) )

    popup:AddActionButton( "Delete", Material( "project0/icons/delete.png" ), function()
        PROJECT0.FUNC.DermaQuery( "Are you sure you want to delete this store item?", "STORE DELETION", "Confirm", function()
            values[valueKey] = nil
            valueChanged = true
            popup:Close()
        end, "Cancel" )
    end )

    -- VARIABLES --
    local margin5 = PROJECT0.UI.Margin5
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

    -- DISPLAY --
    local displayPanel = vgui.Create( "Panel", popup )
    displayPanel:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 200 ), 2 ) )
    displayPanel:SetPos( popup.sectionMargin+popup.sectionWide/2-displayPanel:GetWide()/2, popup.header:GetTall()+(popup.mainPanel.targetH-popup.header:GetTall()-popup.infoBack:GetTall())/2-displayPanel:GetTall()/2 )
    displayPanel.Refresh = function( self2 )
        displayPanel:Clear()
        cosmeticTypes[configItem.Type].OnCreatePnl( displayPanel, configItem.ItemID )
    end
    displayPanel:Refresh()

    -- PRICE --
    local priceField = popup:AddField( "Price", "The price of the cosmetic.", Material( "project0/icons/price.png" ) )
    priceField:SetExtraHeight( PROJECT0.FUNC.ScreenScale( 60 ) )

    local priceEntry = vgui.Create( "pz_numberwang", priceField )
    priceEntry:Dock( TOP )
    priceEntry:DockMargin( margin10, margin10, margin10, margin10 )
    priceEntry:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    priceEntry:SetBackColor( PROJECT0.FUNC.GetTheme( 1 ) )
    priceEntry:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2, 25 ) )
    priceEntry:SetValue( configItem.Price )
    priceEntry:DisableShadows( true )
    priceEntry.OnChange = function( self2 )
        ChangeItemVariable( "Price", self2:GetValue() )
    end

    -- CATEGORY --
    local categoryField = popup:AddField( "Category", "The category the item is in.", Material( "project0/icons/sort.png" ) )

    local categorySelect = vgui.Create( "pz_combo", categoryField )
    categorySelect:Dock( TOP )
    categorySelect:DockMargin( margin10, margin10, margin10, margin10 )
    categorySelect:SetValue( "Select Option" )
    categorySelect:DisableShadows( true )
    categorySelect.OnSelect = function( self2, index, value, data )
        if( configItem.Category == data ) then return end
        ChangeItemVariable( "Category", data )
    end

    for k, v in pairs( PROJECT0.CONFIG.CUSTOMISER.StoreCategories ) do
        categorySelect:AddChoice( v.Name, k, configItem.Category == k )
    end

    categoryField:SetExtraHeight( margin10+categorySelect:GetTall()+margin10 )

    -- FEATURED --
    local featuredField = popup:AddField( "Featured", "Whether the item is featured or not.", Material( "project0/icons/rarity.png" ), true )

    local featuredCheckBox = vgui.Create( "pz_checkbox", featuredField )
    featuredCheckBox:SetSize( PROJECT0.FUNC.Repeat( PROJECT0.FUNC.ScreenScale( 30 ), 2 ) )
    local topMargin = (featuredField.header:GetTall()-featuredCheckBox:GetTall())/2
    featuredCheckBox:SetPos( featuredField:GetWide()-featuredCheckBox:GetWide()-topMargin, topMargin )
    featuredCheckBox:SetValue( configItem.Featured )	
    featuredCheckBox:DisableShadows( true )
    featuredCheckBox.OnChange = function( self2, value ) 
        ChangeItemVariable( "Featured", value )
    end

    -- TYPE --
    local typeField = popup:AddField( "Cosmetic Type", "The type of cosmetic.", Material( "project0/icons/data.png" ) )

    local typeSelect = vgui.Create( "pz_combo_description", typeField )
    typeSelect:Dock( TOP )
    typeSelect:DockMargin( margin10, margin10, margin10, margin10 )
    typeSelect:SetWide( typeField:GetWide()-(2*margin10) )

    for k, v in pairs( cosmeticTypes ) do
        typeSelect:AddChoice( k, v.Name, v.Description )
    end

    typeSelect:SelectChoice( configItem.Type )

    typeField:SetExtraHeight( margin10+typeSelect:GetTall()+margin10 )

    -- ITEM --
    local itemField = popup:AddField( "Cosmetic Item", "The actual cosmetic.", Material( "project0/icons/paint_64.png" ) )

    local itemSelect = vgui.Create( "pz_combosearch", itemField )
    itemSelect:Dock( TOP )
    itemSelect:DockMargin( margin10, margin10, margin10, margin10 )
	itemSelect:SetValue( "Select Option" )
    itemSelect.OnSelect = function( self2, index, value, data )
        if( configItem.ItemID == data ) then return end
        ChangeItemVariable( "ItemID", data )
        displayPanel:Refresh()
    end
    itemSelect.RefreshChoices = function( self2 )
        self2:Clear()

        for k, v in pairs( cosmeticTypes[configItem.Type].GetItemList() ) do
            self2:AddChoice( v[2], v[1], configItem.ItemID == v[1] )
        end
    end
    itemSelect:RefreshChoices()

    itemField:SetExtraHeight( margin10+itemSelect:GetTall()+margin10 )

    -- WEAPON LIST --
    local weaponField
    local function RefreshWeaponField()
        if( IsValid( weaponField ) ) then 
            weaponField:Remove() 
        end

        if( configItem.Type != 3 ) then return end

        local weaponEntryH = PROJECT0.FUNC.ScreenScale( 30 )

        weaponField = popup:AddField( "Skin Weapons", "The weapons the skin is given for.", Material( "project0/icons/weapon.png" ) )

        local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
        local removeMat = Material( "project0/icons/delete.png", "noclamp smooth" )
        local buttonRow

        local weaponListPanel = vgui.Create( "Panel", weaponField )
        weaponListPanel:Dock( FILL )
        weaponListPanel:DockPadding( PROJECT0.FUNC.Repeat( margin10, 4 ) )
        weaponListPanel.RefreshWeapons = function( self2 )
            for k, v in ipairs( self2.weaponEntries or {} ) do
                v:Remove()
            end

            self2.weaponEntries = {}
            for k, v in ipairs( configItem.Weapons ) do
                local weaponName = PROJECT0.FUNC.GetWeaponName( v )
    
                local weaponEntry = vgui.Create( "Panel", self2 )
                weaponEntry:Dock( TOP )
                weaponEntry:SetTall( weaponEntryH )
                weaponEntry:DockMargin( 0, 0, 0, margin5 )
                weaponEntry.Paint = function( self2, w, h )
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                    surface.DrawRect( 0, 0, w, h )
    
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                    surface.DrawRect( 0, 0, 2, h )
        
                    draw.SimpleText( v == "*" and "ALL WEAPONS" or (weaponName .. " (" .. v .. ")"), "MontserratBold19", 2+margin10, h/2, PROJECT0.FUNC.GetTheme( 3, 100 ), 0, TEXT_ALIGN_CENTER )
                end

                table.insert( self2.weaponEntries, weaponEntry )
        
                local removeButton = vgui.Create( "DButton", weaponEntry )
                removeButton:Dock( RIGHT )
                removeButton:SetWide( weaponEntry:GetTall() )
                removeButton:SetText( "" )
                removeButton.Paint = function( self2, w, h )
                    self2:CreateFadeAlpha( 0.1, 5 )
        
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                    surface.DrawRect( 0, 0, w, h )
        
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, self2.alpha ) )
                    surface.DrawRect( 0, 0, w, h )
        
                    PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )
        
                    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
                    surface.SetMaterial( removeMat )
                    surface.DrawTexturedRect( w/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
                end
                removeButton.DoClick = function()
                    table.remove( configItem.Weapons, k )
                    ChangeItemVariable( "Weapons", configItem.Weapons )
                    weaponListPanel:RefreshWeapons()
                end
            end

            weaponField:SetExtraHeight( margin10+#configItem.Weapons*(weaponEntryH+margin5)+buttonRow:GetTall()+margin10 )
        end

        buttonRow = vgui.Create( "Panel", weaponListPanel )
        buttonRow:Dock( BOTTOM )
        buttonRow:SetTall( weaponEntryH )
        buttonRow.AddButton = function( self2, text, iconMat, doClick )
            surface.SetFont( "MontserratBold19" )

            local button = vgui.Create( "DButton", self2 )
            button:Dock( RIGHT )
            button:SetWide( 2+margin10+surface.GetTextSize( text )+margin10+self2:GetTall() )
            button:DockMargin( margin5, 0, 0, 0 )
            button:SetText( "" )
            button.Paint = function( self2, w, h )
                self2:CreateFadeAlpha( 0.1, 5 )
    
                -- Main Bar
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                surface.DrawRect( 0, 0, w, h )
    
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
                surface.DrawRect( 0, 0, 2, h )
    
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
                surface.DrawRect( w-h, 0, h, h )
    
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, self2.alpha ) )
                surface.DrawRect( 0, 0, w, h )
    
                PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 20 ) )
    
                -- Info
                draw.SimpleText( text, "MontserratBold19", 2+margin10, h/2, PROJECT0.FUNC.GetTheme( 3, 100 ), 0, TEXT_ALIGN_CENTER )
    
                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
                surface.SetMaterial( iconMat )
                surface.DrawTexturedRect( w-h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
            end
            button.DoClick = doClick
        end

        buttonRow:AddButton( "ADD NEW", Material( "project0/icons/add.png", "noclamp smooth" ), function()
            local options = {}
            for k, v in pairs( PROJECT0.FUNC.GetConfiguredWeapons() ) do
                if( table.HasValue( configItem.Weapons, k ) ) then continue end
                options[k] = v.Name
            end
    
            PROJECT0.FUNC.DermaComboRequest( "What weapon would you like to add?", "WEAPON EDITOR", options, false, true, false, function( value, data )
                if( not options[data] ) then return end
    
                table.insert( configItem.Weapons, data )
                ChangeItemVariable( "Weapons", configItem.Weapons )
                weaponListPanel:RefreshWeapons()
            end )
        end )

        buttonRow:AddButton( "ADD ALL", Material( "project0/icons/rarity.png", "noclamp smooth" ), function()
            configItem.Weapons = { "*" }
            ChangeItemVariable( "Weapons", configItem.Weapons )
            weaponListPanel:RefreshWeapons()
        end )

        weaponListPanel:RefreshWeapons()
    end
    RefreshWeaponField()

    -- TYPE CHANGE --
    typeSelect.OnSelect = function( self2, index )
        if( index == configItem.Type ) then return end
        ChangeItemVariable( "Type", index )

        local items = cosmeticTypes[configItem.Type].GetItemList()
        ChangeItemVariable( "ItemID", items[1][1] )

        if( index != 3 and configItem.Weapons ) then
            ChangeItemVariable( "Weapons", nil )
        elseif( index == 3 and not configItem.Weapons ) then
            ChangeItemVariable( "Weapons", {} )
        end

        itemSelect:RefreshChoices()
        RefreshWeaponField()
        displayPanel:Refresh()
    end
end

vgui.Register( "pz_config_customiser_store", PANEL, "pz_config_page_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
