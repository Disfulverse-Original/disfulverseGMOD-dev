--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    
end

function PANEL:FillPanel()
    local topPanel = vgui.Create( "Panel", self )
	topPanel:Dock( TOP )
	topPanel:SetTall( PROJECT0.FUNC.ScreenScale( 70 ) )
	topPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.FUNC.ScreenScale( 120 ), PROJECT0.UI.Margin50, 0 )
	topPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "menu_page_invpanel" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_page_invpanel", x, y, 1, 1, 1, 100, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 75 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    self.searchBar = vgui.Create( "pz_searchbar", topPanel )
	self.searchBar:Dock( LEFT )
	self.searchBar:SetWide( ScrW()*0.1 )
	self.searchBar:DockMargin( PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, 0, PROJECT0.UI.Margin15 )
	self.searchBar:DisableShadows( true )
	self.searchBar.OnChange = function()
        self:Refresh()
	end

    self.sortType = 1
    self.sortTypes = {
        {
            Name = PROJECT0.L( "default" ),
            SortItems = function( itemsTable ) 
                table.sort( itemsTable, function( a, b ) 
                    return a[1] > b[1]
                end )
            end
        },
        {
            Name = PROJECT0.L( "rarity" ),
            SortItems = function( itemsTable ) 
                table.sort( itemsTable, function( a, b ) 
                    return PROJECT0.FUNC.GetRarityOrder( a[2][1] ) > PROJECT0.FUNC.GetRarityOrder( b[2][1] )
                end )
            end
        }
    }

    self.sortCombo = vgui.Create( "pz_combo", topPanel )
	self.sortCombo:Dock( RIGHT )
	self.sortCombo:SetWide( ScrW()*0.06 )
	self.sortCombo:DockMargin( 0, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15 )
	self.sortCombo:DisableShadows( true )
	self.sortCombo:SetIcon( Material( "project0/icons/sort.png", "noclamp smooth" ) )

    for k, v in ipairs( self.sortTypes ) do
        self.sortCombo:AddChoice( v.Name, k )
    end

	self.sortCombo.OnSelect = function( self2, index, value, data )
        self.sortType = data
        self:Refresh()
    end

    local cosmeticTypes = {
        {
            Name = PROJECT0.L( "charms" ),
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" )
        },
        {
            Name = PROJECT0.L( "stickers" ),
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" )
        },
        {
            Name = PROJECT0.L( "skins" ),
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" )
        }
    }

    self.unselectedTypes = {}
    for k, v in ipairs( cosmeticTypes ) do
        local checkButton = vgui.Create( "pz_checkbutton", topPanel )
        checkButton:Dock( RIGHT )
        checkButton:DockMargin( 0, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15, PROJECT0.UI.Margin15 )
        checkButton:DisableShadows( true )
        checkButton:SetIcon( v.Icon )
        checkButton:SetLabelText( v.Name )
        checkButton:SetValue( true )
        checkButton.OnChange = function( self2, val )
            self.unselectedTypes[k] = not val
            self:Refresh()
        end
    end

    self.scrollPanel = vgui.Create( "pz_scrollpanel", self )
    self.scrollPanel:Dock( FILL )
    self.scrollPanel:DockMargin( PROJECT0.UI.Margin50, PROJECT0.UI.Margin25, PROJECT0.UI.Margin50, PROJECT0.UI.Margin50 )
    self.scrollPanel:SetSize( self:GetWide()-(2*PROJECT0.UI.Margin50), self:GetTall()-(PROJECT0.FUNC.ScreenScale( 120 )+PROJECT0.UI.Margin50+topPanel:GetTall()+PROJECT0.UI.Margin25) )
    self.scrollPanel.screenY = 0, 0
    self.scrollPanel.Paint = function( self2, w, h )
        local screenY = select( 2, self2:LocalToScreen( 0, 0 ) )
        if( self2.screenY == screenY ) then return end

        self2.screenY = screenY
        self:Refresh()
    end

    local spacing = PROJECT0.UI.Margin25
    local gridWide = self:GetWide()-(2*PROJECT0.UI.Margin50)-self.scrollPanel:GetVBar():GetWide()-spacing
    local slotsWide = math.floor( gridWide/PROJECT0.FUNC.ScreenScale( 150 ) )
    self.slotSize = (gridWide-((slotsWide-1)*spacing))/slotsWide

    self.grid = vgui.Create( "DIconLayout", self.scrollPanel )
    self.grid:Dock( TOP )
    self.grid:SetSpaceY( spacing )
    self.grid:SetSpaceX( spacing )

    hook.Add( "Project0.Hooks.OwnedSkinsUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.CosmeticInventoryUpdated", self, function() self:Refresh() end )
    hook.Add( "Project0.Hooks.ConfigUpdated", self, function() self:Refresh() end )
end

function PANEL:Refresh()
    self.grid:Clear()

    local cosmeticTypes = {
        {
            Name = PROJECT0.L( "charms" ),
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" ),
            GetOwnedItems = function()
                local items = {}
                for k, v in pairs( LocalPlayer():Project0():GetCosmeticInventory() ) do
                    local type, itemKey = PROJECT0.FUNC.ReverseCosmeticKey( k )
                    if( type != PROJECT0.COSMETIC_TYPES.CHARM ) then continue end
            
                    local configTable = PROJECT0.CONFIG.CUSTOMISER.Charms[itemKey]
                    if( not configTable ) then continue end

                    table.insert( items, { configTable.Rarity, itemKey, configTable.Name } )
                end

                return items
            end,
            OnCreatePnl = function( pnl, data )
                local modelPanel = vgui.Create( "pz_modelpanel", pnl )
                modelPanel:Dock( FILL )
                modelPanel:SetFOV( 30 )
                modelPanel:ChangeModel( PROJECT0.CONFIG.CUSTOMISER.Charms[data[2]].Model )
            end,
            GetCosmeticInfo = function( data )
                return {}
            end
        },
        {
            Name = PROJECT0.L( "stickers" ),
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" ),
            GetOwnedItems = function()
                local items = {}
                for k, v in pairs( LocalPlayer():Project0():GetCosmeticInventory() ) do
                    local type, itemKey = PROJECT0.FUNC.ReverseCosmeticKey( k )
                    if( type != PROJECT0.COSMETIC_TYPES.STICKER ) then continue end
            
                    local configTable = PROJECT0.CONFIG.CUSTOMISER.Stickers[itemKey]
                    if( not configTable ) then continue end
            
                    table.insert( items, { configTable.Rarity, itemKey, configTable.Name } )
                end

                return items
            end,
            OnCreatePnl = function( pnl, data )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                local margin = PROJECT0.UI.Margin10
                local heightMargin = ((pnl:GetWide()*1.2)-pnl:GetWide())/2+margin
                skinTexture:DockMargin( margin, heightMargin, margin, heightMargin )
                skinTexture:SetImagePath( PROJECT0.CONFIG.CUSTOMISER.Stickers[data[2]].Icon )
            end,
            GetCosmeticInfo = function( data )
                return {}
            end
        },
        {
            Name = PROJECT0.L( "skins" ),
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" ),
            GetOwnedItems = function()
                local items = {}
                for k, v in pairs( LocalPlayer():Project0():GetOwnedSkins() ) do
                    local devConfig = PROJECT0.DEVCONFIG.WeaponSkins[k]
                    if( not devConfig ) then continue end

                    table.insert( items, { PROJECT0.FUNC.GetSkinRarity( k ), k, devConfig.Name } )
                end

                return items
            end,
            OnCreatePnl = function( pnl, data )
                local skinTexture = vgui.Create( "pz_imagepanel", pnl )
                skinTexture:Dock( FILL )
                skinTexture:SetImagePath( PROJECT0.DEVCONFIG.WeaponSkins[data[2]].Icon )
            end,
            GetCosmeticInfo = function( data )
                local weaponString = ""
                local ownedSkins = LocalPlayer():Project0():GetOwnedSkins()

                for k, v in pairs( ownedSkins[data[2]] or {} ) do
                    if( k == "*" ) then
                        weaponString = PROJECT0.L( "all" )
                        break
                    end

                    weaponString = weaponString .. ((weaponString != "" and ", ") or "") .. PROJECT0.FUNC.GetWeaponName( k )
                end

                return {
                    { PROJECT0.L( "weapons" ), Material( "project0/icons/weapon.png", "noclamp smooth" ), weaponString }
                }
            end
        }
    }

    local sortedItems = {}
    for type, cosmeticType in pairs( cosmeticTypes ) do
        if( self.unselectedTypes[type] ) then continue end

        for k, v in pairs( cosmeticType.GetOwnedItems() ) do
            if( not string.find( string.lower( v[3] ), string.lower( self.searchBar:GetValue() ) ) ) then continue end

            table.insert( sortedItems, { type, v } )
        end
    end

    self.sortTypes[self.sortType].SortItems( sortedItems )

    for k, v in pairs( sortedItems ) do
        local typeInfo = cosmeticTypes[v[1]]

        local infoPanel = vgui.Create( "pz_cosmetic_item", self.grid )
        infoPanel:SetSize( self.slotSize, self.slotSize*1.2 )
        infoPanel:SetRarity( v[2][1] )
        infoPanel:SetPopup( v[1], v[2][3], typeInfo.GetCosmeticInfo( v[2] ) )
        infoPanel:SetShadowBounds( 0, self.scrollPanel.screenY, ScrW(), self.scrollPanel.screenY+self.scrollPanel:GetTall() )
        infoPanel.DoClick = function()

        end

        typeInfo.OnCreatePnl( infoPanel, v[2] )
    end
end

function PANEL:Paint( w, h )
    local x, y = self:LocalToScreen( 0, 0 )

    PROJECT0.FUNC.BeginShadow( "menu_inventory_title" )
    draw.SimpleText( PROJECT0.L( "cosmetic_inventory" ), "MontserratBold35", x+PROJECT0.UI.Margin50, y+PROJECT0.UI.Margin50, PROJECT0.FUNC.GetTheme( 3 ) )
    PROJECT0.FUNC.EndShadow( "menu_inventory_title", x, y, 1, 1, 1, 100, 0, 0, false )

    PROJECT0.FUNC.BeginShadow( "menu_inventory_description" )
    draw.SimpleText( PROJECT0.L( "view_all_cosmetics" ), "MontserratBold19", x+PROJECT0.UI.Margin50, y+PROJECT0.FUNC.ScreenScale( 80 ), PROJECT0.FUNC.GetTheme( 4 ) )
    PROJECT0.FUNC.EndShadow( "menu_inventory_description", x, y, 1, 1, 1, 100, 0, 0, false )
end

vgui.Register( "pz_weaponcustomiser_page_inventory", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
