local PANEL = {}

function PANEL:Init()
    self:SetSize( ScrW()*0.5, ScrH()*0.55 )
    self:Center()
    self:MakePopup()
    self:SetTitle( "" )
    self.headerHeight = 40
    self:DockPadding( 0, self.headerHeight, 0, 0 )
    self:SetDraggable( false )
    self:ShowCloseButton( false )

    RunConsoleCommand( "tooltip_delay", 0.1 )
    self.spacing = 5

    local closeButton = vgui.Create( "DButton", self )
	local size = 24
	closeButton:SetSize( size, size )
	closeButton:SetPos( self:GetWide()-size-((self.headerHeight-size)/2), (self.headerHeight/2)-(size/2) )
	closeButton:SetText( "" )
    local CloseMat = Material( "materials/bricks_server/close.png" )
    local textColor = BRICKS_SERVER.Func.GetTheme( 6 )
	closeButton.Paint = function( self2, w, h )
		if( self2:IsHovered() and !self2:IsDown() ) then
			surface.SetDrawColor( textColor.r*0.6, textColor.g*0.6, textColor.b*0.6 )
		elseif( self2:IsDown() || self2.m_bSelected ) then
			surface.SetDrawColor( textColor.r*0.8, textColor.g*0.8, textColor.b*0.8 )
		else
			surface.SetDrawColor( BRICKS_SERVER.Func.GetTheme( 7 ) )
		end

		surface.SetMaterial( CloseMat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
    closeButton.DoClick = function()
        net.Start( "BRS.Net.MarketplaceClose" )
        net.SendToServer()

        RunConsoleCommand( "tooltip_delay", 0.5 )

        self:Remove()
    end

    local mainSheet = vgui.Create( "bricks_server_colsheet_top", self )
    mainSheet:Dock( FILL )
    mainSheet.pageClickFunc = function( page )
        self.page = page
    end

    local function CreateTopBar( parent, sortByClick, searchBarChange, showEndedClick )
        local topBar = vgui.Create( "DPanel", parent )
        topBar:Dock( TOP )
        topBar:DockMargin( 0, 0, 0, 5 )
        topBar:SetTall( 40 )
        topBar.Paint = function( self2, w, h ) end

        local sortBy = vgui.Create( "DButton", topBar )
        sortBy:Dock( RIGHT )
        sortBy:DockMargin( 5, 0, 0, 0 )
        sortBy:SetWide( topBar:GetTall() )
        sortBy:SetText( "" )
        local changeAlpha = 0
        local sortMat = Material( "materials/bricks_server/sort.png" )
        sortBy.Paint = function( self2, w, h ) 
            if( self2:IsDown() ) then
                changeAlpha = math.Clamp( changeAlpha+10, 0, 255 )
            elseif( self2:IsHovered() ) then
                changeAlpha = math.Clamp( changeAlpha+10, 0, 255 )
            else
                changeAlpha = math.Clamp( changeAlpha-10, 0, 255 )
            end
            
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            surface.SetAlphaMultiplier( changeAlpha/255 )
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 4 ) )
            surface.SetAlphaMultiplier( 1 )

            surface.SetDrawColor( BRICKS_SERVER.Func.GetTheme( 6 ) )
            surface.SetMaterial( sortMat )
            local iconSize = 24
            surface.DrawTexturedRect( (h-iconSize)/2, (h/2)-(iconSize/2), iconSize, iconSize )
        end
        sortBy.DoClick = function()
            sortByClick( sortBy )
        end

        if( showEndedClick ) then
            local showEnded = vgui.Create( "DButton", topBar )
            showEnded:Dock( RIGHT )
            showEnded:DockMargin( 5, 0, 0, 0 )
            showEnded:SetWide( topBar:GetTall() )
            showEnded:SetText( "" )
            local changeAlpha = 0
            local timeMat = Material( "materials/bricks_server/time.png" )
            local x, y = 0, 0
            showEnded.Paint = function( self2, w, h ) 
                local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
                if( x != toScreenX or y != toScreenY ) then
                    x, y = toScreenX, toScreenY
    
                    self2:SetBRSToolTip( x, y, w, h, "Показать купленные лоты" )
                end

                if( self2.showEnded ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 255 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 255 )
                end
                
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

                surface.SetAlphaMultiplier( changeAlpha/255 )
                    draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 4 ) )
                surface.SetAlphaMultiplier( 1 )

                surface.SetDrawColor( BRICKS_SERVER.Func.GetTheme( 6 ) )
                surface.SetMaterial( timeMat )
                local iconSize = h*0.65
                surface.DrawTexturedRect( (h-iconSize)/2, (h/2)-(iconSize/2), iconSize, iconSize )
            end
            showEnded.DoClick = showEndedClick
        end

        local searchBarBack = vgui.Create( "DPanel", topBar )
        searchBarBack:Dock( FILL )
        local search = Material( "materials/bricks_server/search.png" )
        local Alpha = 0
        local Alpha2 = 20
        local color1 = BRICKS_SERVER.Func.GetTheme( 2 )
        local searchBar
        searchBarBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            if( searchBar:IsEditing() ) then
                Alpha = math.Clamp( Alpha+5, 0, 100 )
                Alpha2 = math.Clamp( Alpha2+20, 20, 255 )
            else
                Alpha = math.Clamp( Alpha-5, 0, 100 )
                Alpha2 = math.Clamp( Alpha2-20, 20, 255 )
            end
            
            draw.RoundedBox( 5, 0, 0, w, h, Color( color1.r, color1.g, color1.b, Alpha ) )
        
            surface.SetDrawColor( 255, 255, 255, Alpha2 )
            surface.SetMaterial(search)
            local size = 24
            surface.DrawTexturedRect( w-size-(h-size)/2, (h-size)/2, size, size )
        end

        searchBar = vgui.Create( "bricks_server_search", searchBarBack )
        searchBar:Dock( FILL )
        searchBar.OnChange = function()
            searchBarChange( searchBar )
        end
    end
    
    -- AUCTIONS PANEL --
    local auctionPanel = vgui.Create( "DPanel", mainSheet )
    auctionPanel:Dock( FILL )
    auctionPanel:DockMargin( 10, 5, 10, 10 )
    auctionPanel.Paint = function( self, w, h ) end 
    mainSheet:AddSheet( "Лоты", auctionPanel )

    self.auctionSortChoice = "time_low_to_high"
    self.auctionShowEnded = false
    self.auctionSearchText = ""
    CreateTopBar( auctionPanel, function()
        auctionPanel.menu = DermaMenu()
        auctionPanel.menu:AddOption( "Заканчиваются скоро", function() self.auctionSortChoice = "time_low_to_high" self:Refresh() end )
        auctionPanel.menu:AddOption( "Заканчиваются не скоро", function() self.auctionSortChoice = "time_high_to_low" self:Refresh() end )
        auctionPanel.menu:AddOption( "Ставка - меньшее к большему", function() self.auctionSortChoice = "price_low_to_high" self:Refresh() end )
        auctionPanel.menu:AddOption( "Ставка - большее к меньшему", function() self.auctionSortChoice = "price_high_to_low" self:Refresh() end )
        auctionPanel.menu:Open()
    end, function( searchBar )
        self.auctionSearchText = searchBar:GetValue() or ""
        self:Refresh()
    end )

    self.auctionScrollPanel = vgui.Create( "bricks_server_scrollpanel", auctionPanel )
    self.auctionScrollPanel:Dock( FILL )
    self.auctionScrollPanel.Paint = function( self, w, h ) end 

-- MY BUYS PANEL --
    local myBuysPanel = vgui.Create( "DPanel", mainSheet )
    myBuysPanel:Dock( FILL )
    myBuysPanel:DockMargin( 10, 5, 10, 10 )
    myBuysPanel.Paint = function( self, w, h ) end 
    mainSheet:AddSheet( "Мои покупки", myBuysPanel )

    self.myBuysSortChoice = "time_low_to_high"
    self.myBuysSearchText = ""
    CreateTopBar( myBuysPanel, function()
        myBuysPanel.menu = DermaMenu()
        myBuysPanel.menu:AddOption( "Заканчиваются скоро", function() self.myBuysSortChoice = "time_low_to_high" self:RefreshMyBuys() end )
        myBuysPanel.menu:AddOption( "Заканчиваются не скоро", function() self.myBuysSortChoice = "time_high_to_low" self:RefreshMyBuys() end )
        myBuysPanel.menu:AddOption( "Ставка - меньшее к большему", function() self.myBuysSortChoice = "price_low_to_high" self:RefreshMyBuys() end )
        myBuysPanel.menu:AddOption( "Ставка - большее к меньшему", function() self.myBuysSortChoice = "price_high_to_low" self:RefreshMyBuys() end )
        myBuysPanel.menu:Open()
    end, function( searchBar )
        self.myBuysSearchText = searchBar:GetValue() or ""
        self:RefreshMyBuys()
    end )

    self.myBuysScrollPanel = vgui.Create( "bricks_server_scrollpanel", myBuysPanel )
    self.myBuysScrollPanel:Dock( FILL )
    self.myBuysScrollPanel.Paint = function( self, w, h ) end 

-- MY BIDS PANEL --
    local myBidsPanel = vgui.Create( "DPanel", mainSheet )
    myBidsPanel:Dock( FILL )
    myBidsPanel:DockMargin( 10, 5, 10, 10 )
    myBidsPanel.Paint = function( self, w, h ) end 
    mainSheet:AddSheet( "Мои ставки", myBidsPanel )

    self.myBidsSortChoice = "time_low_to_high"
    self.myBidsSearchText = ""
    CreateTopBar( myBidsPanel, function()
        myBidsPanel.menu = DermaMenu()
        myBidsPanel.menu:AddOption( "Заканчиваются скоро", function() self.myBidsSortChoice = "time_low_to_high" self:RefreshMyBids() end )
        myBidsPanel.menu:AddOption( "Заканчиваются не скоро", function() self.myBidsSortChoice = "time_high_to_low" self:RefreshMyBids() end )
        myBidsPanel.menu:AddOption( "Ставка - меньшее к большему", function() self.myBidsSortChoice = "price_low_to_high" self:RefreshMyBids() end )
        myBidsPanel.menu:AddOption( "Ставка - большее к меньшему", function() self.myBidsSortChoice = "price_high_to_low" self:RefreshMyBids() end )
        myBidsPanel.menu:Open()
    end, function( searchBar )
        self.myBidsSearchText = searchBar:GetValue() or ""
        self:RefreshMyBids()
    end )

    self.myBidsScrollPanel = vgui.Create( "bricks_server_scrollpanel", myBidsPanel )
    self.myBidsScrollPanel:Dock( FILL )
    self.myBidsScrollPanel.Paint = function( self, w, h ) end 

-- MY AUCTION PANEL --
    local myAuctionPanel = vgui.Create( "DPanel", mainSheet )
    myAuctionPanel:Dock( FILL )
    myAuctionPanel:DockMargin( 10, 5, 10, 10 )
    myAuctionPanel.Paint = function( self, w, h ) end 
    mainSheet:AddSheet( "Мои лоты", myAuctionPanel )

    self.myAuctionSortChoice = "time_low_to_high"
    self.myAuctionSearchText = ""
    CreateTopBar( myAuctionPanel, function()
        myAuctionPanel.menu = DermaMenu()
        myAuctionPanel.menu:AddOption( "Заканчиваются скоро", function() self.myAuctionSortChoice = "time_low_to_high" self:RefreshMyAuctions() end )
        myAuctionPanel.menu:AddOption( "Заканчиваются не скоро", function() self.myAuctionSortChoice = "time_high_to_low" self:RefreshMyAuctions() end )
        myAuctionPanel.menu:AddOption( "Ставка - меньшее к большему", function() self.myAuctionSortChoice = "price_low_to_high" self:RefreshMyAuctions() end )
        myAuctionPanel.menu:AddOption( "Ставка - большее к меньшему", function() self.myAuctionSortChoice = "price_high_to_low" self:RefreshMyAuctions() end )
        myAuctionPanel.menu:Open()
    end, function( searchBar )
        self.myAuctionSearchText = searchBar:GetValue() or ""
        self:RefreshMyAuctions()
    end )

    self.myAuctionScrollPanel = vgui.Create( "bricks_server_scrollpanel", myAuctionPanel )
    self.myAuctionScrollPanel:Dock( FILL )
    self.myAuctionScrollPanel.Paint = function( self, w, h ) end 

-- CREATE AUCTION PANEL --
    local inventoryTable = LocalPlayer():BRS():GetInventory()

    local createAuctionPanel = vgui.Create( "DPanel", mainSheet )
    createAuctionPanel:Dock( FILL )
    createAuctionPanel.Paint = function( self, w, h ) end 
    mainSheet:AddSheet( "Создать лот", createAuctionPanel )

    local createAuctionInvScroll = vgui.Create( "bricks_server_scrollpanel", createAuctionPanel )
    createAuctionInvScroll:Dock( LEFT )
    createAuctionInvScroll:DockMargin( 10, 10, 10, 10 )
    createAuctionInvScroll:SetWide( (self:GetWide()-40-5)/2 )
    createAuctionInvScroll.Paint = function( self, w, h ) end 

    self.createAuctionInvGrid = vgui.Create( "DIconLayout", createAuctionInvScroll )
    self.createAuctionInvGrid:Dock( FILL )
    self.createAuctionInvGrid:SetSpaceY( self.spacing )
    self.createAuctionInvGrid:SetSpaceX( self.spacing )

    self.createAuctionInfo = vgui.Create( "DPanel", createAuctionPanel )
    self.createAuctionInfo:Dock( RIGHT )
    self.createAuctionInfo:DockMargin( 10, 10, 10, 10 )
    self.createAuctionInfo:SetWide( (self:GetWide()-40-5)/2 )
    self.createAuctionInfo.Paint = function( self, w, h ) end 

    local centerBar = vgui.Create( "DPanel", createAuctionPanel )
    centerBar:Dock( FILL )
    centerBar:DockMargin( 1, 10, 1, 10 )
    centerBar.Paint = function( self2, w, h ) 
        draw.RoundedBox( 3, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
    end

    self.selected = #inventoryTable

-- ADMIN PANEL --
    if( BRICKS_SERVER.Func.HasAdminAccess( LocalPlayer() ) ) then
        local adminPanel = vgui.Create( "DPanel", mainSheet )
        adminPanel:Dock( FILL )
        adminPanel:DockMargin( 10, 5, 10, 10 )
        adminPanel.Paint = function( self, w, h ) end 
        mainSheet:AddSheet( "Админская", adminPanel )

        self.adminSortChoice = "time_low_to_high"
        self.adminShowEnded = false
        self.adminSearchText = ""
        CreateTopBar( adminPanel, function()
            adminPanel.menu = DermaMenu()
            adminPanel.menu:AddOption( "Ending soonest", function() self.adminSortChoice = "time_low_to_high" self:RefreshAdmin() end )
            adminPanel.menu:AddOption( "Ending latest", function() self.adminSortChoice = "time_high_to_low" self:RefreshAdmin() end )
            adminPanel.menu:AddOption( "Bid - low to high", function() self.adminSortChoice = "price_low_to_high" self:RefreshAdmin() end )
            adminPanel.menu:AddOption( "Bid - high to low", function() self.adminSortChoice = "price_high_to_low" self:RefreshAdmin() end )
            adminPanel.menu:Open()
        end, function( searchBar )
            self.adminSearchText = searchBar:GetValue() or ""
            self:RefreshAdmin()
        end, function( showEndedButton )
            self.adminShowEnded = not self.adminShowEnded
            showEndedButton.showEnded = self.adminShowEnded
            self:RefreshAdmin()
        end )

        self.adminScrollPanel = vgui.Create( "bricks_server_scrollpanel", adminPanel )
        self.adminScrollPanel:Dock( FILL )
        self.adminScrollPanel.Paint = function( self, w, h ) end 
    end

    hook.Add( "BRS.Hooks.FillInventory", self, function()
        self:RefreshInventory()
        self:RefreshSelection()
    end )
end

function PANEL:Refresh()
    if( IsValid( self.auctionGrid ) ) then
        self.auctionGrid:Remove()
    end

    self.auctionGrid = vgui.Create( "DIconLayout", self.auctionScrollPanel )
    self.auctionGrid:Dock( FILL )
    self.auctionGrid:SetSpaceY( self.spacing )
    self.auctionGrid:SetSpaceX( self.spacing )

    local gridWide = (self:GetWide()-20)/2
    local wantedSlotSize = 200*(ScrW()/2560)
    local slotsWide = math.floor( gridWide/wantedSlotSize )
    
    local slotSize = (gridWide-5-((slotsWide-1)*self.spacing))/slotsWide

    local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        notification.AddLegacy( "BRICKS SERVER ERROR: Invalid Currency", 1, 5 )
        return 
    end

    local sortedMarketPlace = table.Copy( BRS_MARKETPLACE or {} )
    for k, v in pairs( sortedMarketPlace ) do
        v.key = k
    end

    if( self.auctionSortChoice ) then
        if( self.auctionSortChoice == "time_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.auctionSortChoice == "time_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) > ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.auctionSortChoice == "price_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) < ((b or {})[2] or 0) end )
        elseif( self.auctionSortChoice == "price_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) > ((b or {})[2] or 0) end )
        end
    else
        table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
    end

    for k, v in pairs( sortedMarketPlace ) do
        local itemTable = v[5] or {}
        if( (self.auctionSearchText or "") != "" and not string.find( string.lower( v[7] or "NIL" ), string.lower( (self.auctionSearchText or "") ) ) and not string.find( string.lower( itemTable[4] or "NIL" ), string.lower( (self.auctionSearchText or "") ) ) ) then
            continue
        end

        if( os.time() >= ((v[4] or 0)+(v[3] or 0)) ) then continue end
        if v[9] then continue end

        local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( ((itemTable or {})[1] or ""), "GetInfo" )( itemTable )
        
        local tooltipInfo = {}
        tooltipInfo[1] = { itemInfo[1], false, "BRICKS_SERVER_Font23B" }
        tooltipInfo[2] = "Кол-во: " .. (v[1] or 1)
        tooltipInfo[3] = "Продавец: " .. (v[7] or "NIL")
        if( itemInfo[3] ) then
            local rarityInfo = BRICKS_SERVER.Func.GetRarityInfo( itemInfo[3] )
            tooltipInfo[2] = { itemInfo[3], function() return BRICKS_SERVER.Func.GetRarityColor( rarityInfo ) end, "BRICKS_SERVER_Font17" }
            tooltipInfo[3] = "Кол-во: " .. (v[1] or 1)
            tooltipInfo[4] = "Продавец: " .. (v[7] or "NIL")
        end

        local slotBack = self.auctionGrid:Add( "DPanel" )
        slotBack:SetSize( slotSize, slotSize )
        local x, y, w, h = 0, 0, slotSize, slotSize
        local itemModel
        local changeAlpha = 0
        local topBidder = player.GetBySteamID( table.GetWinningKey( v[10] or {} ) or "" )
        slotBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
            if( x != toScreenX or y != toScreenY ) then
                x, y = toScreenX, toScreenY

                itemModel:SetBRSToolTip( x, y, w, h, tooltipInfo )
            end
            
            if( IsValid( itemModel ) ) then
                if( itemModel:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                elseif( itemModel:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end
            end

            surface.SetAlphaMultiplier( changeAlpha/255 )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            surface.SetAlphaMultiplier( 1 )

            draw.SimpleText( ("Текущая ставка: " .. currencyTable.formatFunction( v[2] or 0 )), "BRICKS_SERVER_Font20", w/2, h-25, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( ("Цена выкупа: " .. currencyTable.formatFunction( v[8] or 0 )), "BRICKS_SERVER_Font20", w/2, h-45, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            if( IsValid( topBidder ) ) then
                draw.SimpleText( topBidder:Nick(), "BRICKS_SERVER_Font15", w/2, h-3, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end

            draw.SimpleText( BRICKS_SERVER.Func.FormatTime( ((v[4] or 0)+(v[3] or 0))-os.time() ), "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )

            if( os.time() >= ((v[4] or 0)+(v[3] or 0)) ) then 
                self2:Remove()
            end
        end

        if( itemTable[2] ) then
            itemModel = vgui.Create( "DModelPanel" , slotBack )
            itemModel:Dock( FILL )
            itemModel:SetModel( itemTable[2] )
            itemModel:SetFOV( 60 )
            itemModel:SetCamPos( Vector( 0, 50, 5 ) )
            itemModel:SetLookAng( Angle( 180, 90, 180 ) )
            
            if( itemTable[1] == "bricks_server_resource" ) then
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] ) then
                    itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] )
                end
            end
        end

        local actions = {
            [1] = { "Торги", function()
                if v[6] == LocalPlayer():SteamID64() then
                    notification.AddLegacy("Вы не можете делать ставки на свои товары!", 1, 5)
                    return
                end

                local minBid = math.floor((v[2] or 1000) * (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Bid Increment"] or 1.1))
                BRICKS_SERVER.Func.StringRequest("Bidding", "Сколько вы хотите поставить?", minBid, function(number)
                    if number >= minBid then
                        net.Start("BRS.Net.MarketplaceBid")
                        net.WriteUInt(v.key, 16)
                        net.WriteUInt(number, 32)
                        net.WriteString(v[6] or "")
                        net.SendToServer()
                    else
                        notification.AddLegacy("Новая ставка должна быть на 10% выше в цене чем старая!", 1, 5)
                    end
                end, function() end, "OK", "Отмена", true)
            end },
            [2] = { "Выкупить", function()
                if v[6] == LocalPlayer():SteamID64() then
                    notification.AddLegacy("Вы не можете выкупить свой же товар!", 1, 5)
                    return
                end
                net.Start("BRS.Net.MarketplaceBuyout")
                net.WriteUInt(v.key, 16)  -- Write the auction item key
                net.WriteString(v[6] or "")  -- Write the owner's SteamID
                net.SendToServer()
            end },
        }

        if itemModel then
            itemModel.DoClick = function()
                local menu = vgui.Create("bricks_server_dmenu")
                for _, action in pairs(actions) do
                    menu:AddOption(action[1], action[2])
                end
                menu:Open()
                menu:SetPos(x + w + 5, y + (h / 2) - (menu:GetTall() / 2))
            end
        end

    end

    self.auctionScrollPanel:Rebuild()
end

function PANEL:RefreshMyBids()
    if( IsValid( self.myBidsGrid ) ) then
        self.myBidsGrid:Remove()
    end

    self.myBidsGrid = vgui.Create( "DIconLayout", self.myBidsScrollPanel )
    self.myBidsGrid:Dock( FILL )
    self.myBidsGrid:SetSpaceY( self.spacing )
    self.myBidsGrid:SetSpaceX( self.spacing )

    local gridWide = (self:GetWide()-20)/2
    local wantedSlotSize = 200*(ScrW()/2560)
    local slotsWide = math.floor( gridWide/wantedSlotSize )
    
    local slotSize = (gridWide-5-((slotsWide-1)*self.spacing))/slotsWide

    local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        notification.AddLegacy( "BRICKS SERVER ERROR: Invalid Currency", 1, 5 )
        return 
    end

    local sortedMarketPlace = table.Copy( BRS_MARKETPLACE or {} )
    for k, v in pairs( sortedMarketPlace ) do
        v.key = k
    end

    if( self.myBidsSortChoice ) then
        if( self.myBidsSortChoice == "time_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.myBidsSortChoice == "time_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) > ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.myBidsSortChoice == "price_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) < ((b or {})[2] or 0) end )
        elseif( self.myBidsSortChoice == "price_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) > ((b or {})[2] or 0) end )
        end
    else
        table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
    end

    for k, v in pairs( sortedMarketPlace ) do
        if( not ((v or {})[10] or {})[LocalPlayer():SteamID()] ) then
            continue
        elseif( v[11] and (table.GetWinningKey( v[10] or {} ) or "") == LocalPlayer():SteamID() ) then
            continue
        elseif (v[9] == true) and (v[13] == LocalPlayer():SteamID()) then
            continue
        end

        --PrintTable(v)
        local itemTable = v[5] or {}
        if( (self.myBidsSearchText or "") != "" and not string.find( string.lower( v[7] or "NIL" ), string.lower( (self.myBidsSearchText or "") ) ) and not string.find( string.lower( itemTable[4] or "NIL" ), string.lower( (self.myBidsSearchText or "") ) ) ) then
            continue
        end

        local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( ((itemTable or {})[1] or ""), "GetInfo" )( itemTable )
        
        local tooltipInfo = {}
        tooltipInfo[1] = { itemInfo[1], false, "BRICKS_SERVER_Font23B" }
        tooltipInfo[2] = "Кол-во: " .. (v[1] or 1)
        tooltipInfo[3] = "Продавец: " .. (v[7] or "NIL")
        if( itemInfo[3] ) then
            local rarityInfo = BRICKS_SERVER.Func.GetRarityInfo( itemInfo[3] )
            tooltipInfo[2] = { itemInfo[3], function() return BRICKS_SERVER.Func.GetRarityColor( rarityInfo ) end, "BRICKS_SERVER_Font17" }
            tooltipInfo[3] = "Кол-во: " .. (v[1] or 1)
            tooltipInfo[4] = "Продавец: " .. (v[7] or "NIL")
        end

        local slotBack = self.myBidsGrid:Add( "DPanel" )
        slotBack:SetSize( slotSize, slotSize )
        local x, y, w, h = 0, 0, slotSize, slotSize
        local itemModel
        local changeAlpha = 0
        local topBidder = player.GetBySteamID( table.GetWinningKey( v[10] or {} ) or "" )
        slotBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
            if( x != toScreenX or y != toScreenY ) then
                x, y = toScreenX, toScreenY

                itemModel:SetBRSToolTip( x, y, w, h, tooltipInfo )
            end
            
            if( IsValid( itemModel ) ) then
                if( itemModel:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                elseif( itemModel:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end
            end

            surface.SetAlphaMultiplier( changeAlpha/255 )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            surface.SetAlphaMultiplier( 1 )

            draw.SimpleText( currencyTable.formatFunction( v[2] or 0 ), "BRICKS_SERVER_Font20", w/2, h-15, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            if( IsValid( topBidder ) ) then
                draw.SimpleText( topBidder:Nick(), "BRICKS_SERVER_Font15", w/2, h-3, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end

            if( ((v[4] or 0)+(v[3] or 0))-os.time() > 0 ) and not v[9] == true then
                draw.SimpleText( BRICKS_SERVER.Func.FormatTime( ((v[4] or 0)+(v[3] or 0))-os.time() ), "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            elseif( (v[3] or 0) == 0 ) then
                draw.SimpleText( "Отменен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            elseif v[9] == true then
                draw.SimpleText( "Выкуплен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            else
                draw.SimpleText( "Окончен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            end

            --[[
            if v[9] == true then
                self2:Remove()
            end
            --]]

        end

        if( itemTable[2] ) then
            itemModel = vgui.Create( "DModelPanel" , slotBack )
            itemModel:Dock( FILL )
            itemModel:SetModel( itemTable[2] )
            itemModel:SetFOV( 60 )
            itemModel:SetCamPos( Vector( 0, 50, 5 ) )
            itemModel:SetLookAng( Angle( 180, 90, 180 ) )
            
            if( itemTable[1] == "bricks_server_resource" ) then
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] ) then
                    itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] )
                end
            end
        end

        local actions = {}

        if ((v[4] or 0) + (v[3] or 0) - os.time() <= 0) then
            actions[1] = { "Забрать", function()
                net.Start("BRS.Net.MarketplaceCollect")
                net.WriteUInt(v.key, 16)
                net.WriteString(v[6] or "")
                net.SendToServer()
            end }
        else
            actions[2] = { "Торги", function()
                if v[6] == LocalPlayer():SteamID64() then
                    notification.AddLegacy("Вы не можете ставить на свои же предметы!", 1, 5)
                    return
                end

                local minBid = math.floor((v[2] or 1000) * (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Bid Increment"] or 1.1))
                BRICKS_SERVER.Func.StringRequest("Admin", "Сколько вы хотите поставить?", minBid, function(number)
                    if number >= minBid then
                        net.Start("BRS.Net.MarketplaceBid")
                        net.WriteUInt(v.key, 16)
                        net.WriteUInt(number, 32)
                        net.WriteString(v[6] or "")
                        net.SendToServer()
                    else
                        notification.AddLegacy("Новая ставка должна быть на 10% выше в цене чем старая!", 1, 5)
                    end
                end, function() end, "OK", "Отмена", true )
            end }
        end

        if itemModel then
            itemModel.DoClick = function()
                local menu = vgui.Create("bricks_server_dmenu")
                for _, action in ipairs(actions) do
                    menu:AddOption(action[1], action[2])
                end
                menu:Open()
                menu:SetPos(x + w + 5, y + h / 2 - menu:GetTall() / 2)
            end
        end
    end

    self.myBidsScrollPanel:Rebuild()

end

function PANEL:RefreshMyBuys()
    if( IsValid( self.myBuysGrid ) ) then
        self.myBuysGrid:Remove()
    end

    self.myBuysGrid = vgui.Create( "DIconLayout", self.myBuysScrollPanel )
    self.myBuysGrid:Dock( FILL )
    self.myBuysGrid:SetSpaceY( self.spacing )
    self.myBuysGrid:SetSpaceX( self.spacing )

    local gridWide = (self:GetWide()-20)/2
    local wantedSlotSize = 200*(ScrW()/2560)
    local slotsWide = math.floor( gridWide/wantedSlotSize )
    
    local slotSize = (gridWide-5-((slotsWide-1)*self.spacing))/slotsWide

    local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        notification.AddLegacy( "BRICKS SERVER ERROR: Invalid Currency", 1, 5 )
        return 
    end

    local sortedMarketPlace = table.Copy( BRS_MARKETPLACE or {} )
    for k, v in pairs( sortedMarketPlace ) do
        v.key = k
    end

    if( self.myBuysSortChoice ) then
        if( self.myBuysSortChoice == "time_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.myBuysSortChoice == "time_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) > ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.myBuysSortChoice == "price_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) < ((b or {})[2] or 0) end )
        elseif( self.myBuysSortChoice == "price_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) > ((b or {})[2] or 0) end )
        end
    else
        table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
    end

    for k, v in pairs( sortedMarketPlace ) do
        --print(v[13])

        if( (v[13] or "") != LocalPlayer():SteamID() ) then continue end
        if ( v[14] == true ) then continue end

        --print("this is a winner " .. v[13])

        --print("sorted bids")
        --PrintTable(v)
        local itemTable = v[5] or {}
        if( (self.myBuysSearchText or "") != "" and not string.find( string.lower( v[7] or "NIL" ), string.lower( (self.myBuysSearchText or "") ) ) and not string.find( string.lower( itemTable[4] or "NIL" ), string.lower( (self.myBuysSearchText or "") ) ) ) then
            continue
        end

        local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( ((itemTable or {})[1] or ""), "GetInfo" )( itemTable )
        
        local tooltipInfo = {}
        tooltipInfo[1] = { itemInfo[1], false, "BRICKS_SERVER_Font23B" }
        tooltipInfo[2] = "Кол-во: " .. (v[1] or 1)
        tooltipInfo[3] = "Продавец: " .. (v[7] or "NIL")
        if( itemInfo[3] ) then
            local rarityInfo = BRICKS_SERVER.Func.GetRarityInfo( itemInfo[3] )
            tooltipInfo[2] = { itemInfo[3], function() return BRICKS_SERVER.Func.GetRarityColor( rarityInfo ) end, "BRICKS_SERVER_Font17" }
            tooltipInfo[3] = "Кол-во: " .. (v[1] or 1)
            tooltipInfo[4] = "Продавец: " .. (v[7] or "NIL")
        end

        local slotBack = self.myBuysGrid:Add( "DPanel" )
        slotBack:SetSize( slotSize, slotSize )
        local x, y, w, h = 0, 0, slotSize, slotSize
        local itemModel
        local changeAlpha = 0
        local whoubought = player.GetBySteamID( v[13] )
        slotBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
            if( x != toScreenX or y != toScreenY ) then
                x, y = toScreenX, toScreenY

                itemModel:SetBRSToolTip( x, y, w, h, tooltipInfo )
            end
            
            if( IsValid( itemModel ) ) then
                if( itemModel:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                elseif( itemModel:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end
            end

            surface.SetAlphaMultiplier( changeAlpha/255 )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            surface.SetAlphaMultiplier( 1 )

            draw.SimpleText( "Стоимость: " .. currencyTable.formatFunction( v[8] or 0 ), "BRICKS_SERVER_Font20", w/2, h-15, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            if( IsValid( whoubought ) ) then
                draw.SimpleText( whoubought:Nick(), "BRICKS_SERVER_Font15", w/2, h-3, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end

            if v[9] == true then
                draw.SimpleText( "Выкуплен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            else
                draw.SimpleText( "Окончен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            end

            --[[
            if v[9] == true then
                self2:Remove()
            end
            --]]

        end

        if( itemTable[2] ) then
            itemModel = vgui.Create( "DModelPanel" , slotBack )
            itemModel:Dock( FILL )
            itemModel:SetModel( itemTable[2] )
            itemModel:SetFOV( 60 )
            itemModel:SetCamPos( Vector( 0, 50, 5 ) )
            itemModel:SetLookAng( Angle( 180, 90, 180 ) )
            
            if( itemTable[1] == "bricks_server_resource" ) then
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] ) then
                    itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] )
                end
            end
        end

        local actions = {}

        if v[9] and ( not v[14] ) then
            actions[1] = { "Забрать", function()
                --print("doing the work")
                net.Start("BRS.Net.MarketplaceCollect")
                net.WriteUInt(v.key, 16)
                net.WriteString(v[6] or "")
                net.SendToServer()
            end }
        end

        if itemModel then
            itemModel.DoClick = function()
                local menu = vgui.Create("bricks_server_dmenu")
                for _, action in ipairs(actions) do
                    menu:AddOption(action[1], action[2])
                end
                menu:Open()
                menu:SetPos(x + w + 5, y + h / 2 - menu:GetTall() / 2)
            end
        end

    end

    self.myBuysScrollPanel:Rebuild()

end


function PANEL:RefreshMyAuctions()
    if( IsValid( self.myAuctionGrid ) ) then
        self.myAuctionGrid:Remove()
    end

    self.myAuctionGrid = vgui.Create( "DIconLayout", self.myAuctionScrollPanel )
    self.myAuctionGrid:Dock( FILL )
    self.myAuctionGrid:SetSpaceY( self.spacing )
    self.myAuctionGrid:SetSpaceX( self.spacing )

    local gridWide = (self:GetWide()-20)/2
    local wantedSlotSize = 200*(ScrW()/2560)
    local slotsWide = math.floor( gridWide/wantedSlotSize )
    
    local slotSize = (gridWide-5-((slotsWide-1)*self.spacing))/slotsWide

    local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        notification.AddLegacy( "BRICKS SERVER ERROR: Неправильная валюта", 1, 5 )
        return 
    end

    local sortedMarketPlace = table.Copy( BRS_MARKETPLACE or {} )
    for k, v in pairs( sortedMarketPlace ) do
        v.key = k
    end

    if( self.myAuctionSortChoice ) then
        if( self.myAuctionSortChoice == "time_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.myAuctionSortChoice == "time_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) > ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.myAuctionSortChoice == "price_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) < ((b or {})[2] or 0) end )
        elseif( self.myAuctionSortChoice == "price_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) > ((b or {})[2] or 0) end )
        end
    else
        table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
    end

    for k, v in pairs( sortedMarketPlace ) do
        --PrintTable(v)
        --print(v)
        --if( (v[6] or "") == LocalPlayer():SteamID64() ) then print("true") continue else print("false") return end
        if( (v[6] or "") != LocalPlayer():SteamID64() or ( v[12] ) ) then continue end

        local owner = player.GetBySteamID64( v[6] or "" )
        local ownerName = ""
        if( IsValid( owner ) ) then
            ownerName = owner:Nick()
        else
            ownerName = v[7] or "NIL"
        end

        local itemTable = v[5] or {}
        if( (self.myAuctionSearchText or "") != "" and not string.find( string.lower( ownerName ), string.lower( (self.myAuctionSearchText or "") ) ) and not string.find( string.lower( itemTable[4] or "NIL" ), string.lower( (self.myAuctionSearchText or "") ) ) ) then
            continue
        end

        local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( ((itemTable or {})[1] or ""), "GetInfo" )( itemTable )
        
        local tooltipInfo = {}
        tooltipInfo[1] = { itemInfo[1], false, "BRICKS_SERVER_Font23B" }
        tooltipInfo[2] = "Кол-во: " .. (v[1] or 1)
        if( itemInfo[3] ) then
            local rarityInfo = BRICKS_SERVER.Func.GetRarityInfo( itemInfo[3] )
            tooltipInfo[2] = { itemInfo[3], function() return BRICKS_SERVER.Func.GetRarityColor( rarityInfo ) end, "BRICKS_SERVER_Font17" }
            tooltipInfo[3] = "Кол-во: " .. (v[1] or 1)
        end

        local slotBack = self.myAuctionGrid:Add( "DPanel" )
        slotBack:SetSize( slotSize, slotSize )
        local x, y, w, h = 0, 0, slotSize, slotSize
        local itemModel
        local changeAlpha = 0
        --local whoubought = player.GetBySteamID( v[13] )
        local topBidder = player.GetBySteamID( table.GetWinningKey( v[10] or {} ) or "" )
        slotBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
            if( x != toScreenX or y != toScreenY ) then
                x, y = toScreenX, toScreenY

                itemModel:SetBRSToolTip( x, y, w, h, tooltipInfo )
            end
            
            if( IsValid( itemModel ) ) then
                if( itemModel:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                elseif( itemModel:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end
            end

            surface.SetAlphaMultiplier( changeAlpha/255 )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            surface.SetAlphaMultiplier( 1 )

            if not v[13] then
                draw.SimpleText( currencyTable.formatFunction( v[2] or 0 ), "BRICKS_SERVER_Font20", w/2, h-15, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            else
                draw.SimpleText( currencyTable.formatFunction( v[8] or 0 ), "BRICKS_SERVER_Font20", w/2, h-15, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end

            if( IsValid( topBidder ) ) then
                draw.SimpleText( topBidder:Nick(), "BRICKS_SERVER_Font15", w/2, h-3, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            elseif v[13] then
                draw.SimpleText( player.GetBySteamID(v[13]):Nick() or "nil", "BRICKS_SERVER_Font15", w/2, h-3, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end

            if( ((v[4] or 0)+(v[3] or 0))-os.time() > 0 ) and not v[9] == true then
                draw.SimpleText( BRICKS_SERVER.Func.FormatTime( ((v[4] or 0)+(v[3] or 0))-os.time() ), "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            elseif( (v[3] or 0) == 0 ) then
                draw.SimpleText( "Отменен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            elseif v[9] == true then
                draw.SimpleText( "Выкуплен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            else
                draw.SimpleText( "Окончен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            end

        end

        if( itemTable[2] ) then
            itemModel = vgui.Create( "DModelPanel" , slotBack )
            itemModel:Dock( FILL )
            itemModel:SetModel( itemTable[2] )
            itemModel:SetFOV( 60 )
            itemModel:SetCamPos( Vector( 0, 50, 5 ) )
            itemModel:SetLookAng( Angle( 180, 90, 180 ) )
            
            if( itemTable[1] == "bricks_server_resource" ) then
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] ) then
                    itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] )
                end
            end
        end

        local actions = {
            --[1] = { "View", function() 

            --end }
        }

        if( (BRICKS_SERVER.CONFIG.MARKETPLACE["Can Players Cancel Auction"] or true) and ((v[4] or 0)+(v[3] or 0))-os.time() > 0 and not v[9] == true ) then
            actions[1] = { "Отмена", function() 
                net.Start( "BRS.Net.MarketplaceCancel" )
                    net.WriteUInt( v.key, 16 )
                    net.WriteString( v[6] or "" )
                net.SendToServer()
            end }
        end

        if( ((v[4] or 0)+(v[3] or 0))-os.time() <= 0 or v[9] == true ) then
            actions[2] = { "Забрать", function() 
                net.Start( "BRS.Net.MarketplaceCollect" )
                    net.WriteUInt( v.key, 16 )
                    net.WriteString( v[6] or "" )
                net.SendToServer()
            end }
        end

        if( itemModel ) then
            itemModel.DoClick = function()
                itemModel.Menu = vgui.Create( "bricks_server_dmenu" )
                for k, v in pairs( actions ) do
                    itemModel.Menu:AddOption( v[1], v[2] )
                end
                itemModel.Menu:Open()
                itemModel.Menu:SetPos( x+w+5, y+(h/2)-(itemModel.Menu:GetTall()/2) )
            end
        end
    end

    self.myAuctionScrollPanel:Rebuild()
end

function PANEL:RefreshInventory()
    local inventoryTable = LocalPlayer():BRS():GetInventory()

    self.createAuctionInvGrid:Clear()

    local gridWide = (self:GetWide()-40-5)/2
    local wantedSlotSize = 125*(ScrW()/2560)
    local slotsWide = math.floor( gridWide/wantedSlotSize )
    
    local slotSize = (gridWide-5-((slotsWide-1)*self.spacing))/slotsWide

    for k, v in pairs( inventoryTable ) do
        local slotBack = self.createAuctionInvGrid:Add( "DPanel" )
        slotBack:SetSize( slotSize, slotSize )
        local x, y, w, h = 0, 0, slotSize, slotSize
        local itemModel
        local changeAlpha = 0
        local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( (((v or {})[2] or {})[1] or ""), "GetInfo" )( v[2] )
        
        local tooltipInfo = {}
        tooltipInfo[1] = { itemInfo[1], false, "BRICKS_SERVER_Font23B" }
        tooltipInfo[2] = itemInfo[2]
        if( itemInfo[3] ) then
            local rarityInfo = BRICKS_SERVER.Func.GetRarityInfo( itemInfo[3] )
            tooltipInfo[2] = { itemInfo[3], function() return BRICKS_SERVER.Func.GetRarityColor( rarityInfo ) end, "BRICKS_SERVER_Font17" }
            tooltipInfo[3] = itemInfo[2]
        end
        slotBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
            
            if( IsValid( itemModel ) ) then
                local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
                if( x != toScreenX or y != toScreenY ) then
                    x, y = toScreenX, toScreenY
    
                    itemModel:SetBRSToolTip( x, y, w, h, tooltipInfo )
                end
                
                if( itemModel:IsDown() or (self.selected or 0) == k ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                elseif( itemModel:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end
            end

            surface.SetAlphaMultiplier( changeAlpha/255 )
            if( (self.selected or 0) == k ) then
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 4 ) )
            else
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            end
            surface.SetAlphaMultiplier( 1 )

            draw.SimpleText( (v[1] or 1), "BRICKS_SERVER_Font20", w-10, h-5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
        end

        if( v and v[2] and v[2][2] ) then
            itemModel = vgui.Create( "DModelPanel" , slotBack )
            itemModel:Dock( FILL )
            itemModel:SetModel( v[2][2] )
            itemModel:SetFOV( 60 )
            itemModel:SetCamPos( Vector( 0, 50, 5 ) )
            itemModel:SetLookAng( Angle( 180, 90, 180 ) )
            if( v[2] and v[2][1] == "bricks_server_resource" ) then
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[v[2][3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[v[2][3]][2] ) then
                    itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[v[2][3]][2] )
                end
            end
        end

        if( itemModel ) then
            itemModel.DoClick = function()
                self.selected = k
                self:RefreshSelection()
            end
        end
    end
end

function PANEL:RefreshSelection()
    local inventoryTable = LocalPlayer():BRS():GetInventory()

    self.createAuctionInfo:Clear()

    if( not self.selected or not inventoryTable[self.selected] ) then return end

    local selectedItem = inventoryTable[self.selected]
    local selectedItemTable = inventoryTable[self.selected][2] or {}

    local infoTable = BRICKS_SERVER.Func.GetEntTypeField( (selectedItemTable[1] or ""), "GetInfo" )( selectedItemTable )

    local auctionPrice = BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000
    local auctionTime = BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300
    local amount = (selectedItem[1] or 1)

    local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        return 
    end

    local submitButton = vgui.Create( "DButton", self.createAuctionInfo )
    submitButton:Dock( BOTTOM )
    submitButton:DockMargin( 0, 5, 0, 0 )
    submitButton:SetTall( 40 )
    submitButton:SetText( "" )
    local changeAlpha = 0
    submitButton.Paint = function( self2, w, h )
		if( self2:IsHovered() ) then
			changeAlpha = math.Clamp( changeAlpha+10, 0, 255 )
		else
			changeAlpha = math.Clamp( changeAlpha-10, 0, 255 )
		end
		
		draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.Green )

		surface.SetAlphaMultiplier( changeAlpha/255 )
		draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.DarkGreen )
		surface.SetAlphaMultiplier( 1 )

        draw.SimpleText( "Создать", "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    submitButton.DoClick = function()
        if( auctionTime < (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) or auctionTime > (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) ) then
            notification.AddLegacy( "Минимальное время на лот: " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) .. ", максимальное: " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) .. "!", 1, 3 )
            return
        end

        if( auctionPrice < (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) ) then
            notification.AddLegacy( "Стартовая цена: " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) .. "!", 1, 3 )
            return
        end

        if( not buyoutPrice ) then
            notification.AddLegacy( "Укажите цену выкупа!", 1, 3 )
            return
        end

        if( buyoutPrice <= auctionPrice ) then
            notification.AddLegacy( "Цена выкупа не может быть меньше чем цена начальной ставки!", 1, 3 )
            return
        end

        if( amount > (selectedItem[1] or 1) ) then
            notification.AddLegacy( "У вас недостаточно этого предмета!", 1, 3 )
            return
        end

        net.Start("BRS.Net.MarketplaceAdd")
            net.WriteUInt(self.selected, 10)
            net.WriteUInt(amount, 10)
            net.WriteUInt(auctionPrice, 32)
            net.WriteUInt(auctionTime, 32)

            net.WriteUInt(buyoutPrice or 0, 32)          -- Buyout price (default to 0 if not present)
            net.WriteBool(false)                         -- Flag for buyout status

            -- Optionally include more fields from newAuction as needed
        net.SendToServer()
    end
    
    local priceTimeBack = vgui.Create( "DPanel", self.createAuctionInfo )
    priceTimeBack:Dock( BOTTOM )
    priceTimeBack:DockMargin( 0, 5, 0, 0 )
    priceTimeBack:SetTall( 40 )
    priceTimeBack.Paint = function( self2, w, h ) end

    local timeBack = vgui.Create( "DButton", self.createAuctionInfo )
    timeBack:Dock( BOTTOM )
    timeBack:SetWide( (self.createAuctionInfo:GetWide()-5)/2 )
    timeBack:DockMargin( 0, 5, 0, 0 )
    timeBack:SetText( "" )
    local changeAlpha = 0
    timeBack.Paint = function( self2, w, h )
        if( auctionTime >= (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) and auctionTime <= (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) ) then
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.Red )
        end
        
        if( self2:IsDown() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        elseif( self2:IsHovered() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        else
            changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
        end

        surface.SetAlphaMultiplier( changeAlpha/255 )
            if( auctionTime >= (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) and auctionTime <= (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) ) then
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            else
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.DarkRed )
            end
        surface.SetAlphaMultiplier( 1 )

        draw.SimpleText( "Время: ", "BRICKS_SERVER_Font20", 15, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
        draw.SimpleText( BRICKS_SERVER.Func.FormatTime( auctionTime ), "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    timeBack.DoClick = function()
        BRICKS_SERVER.Func.StringRequest( "Аукцион", "Как долго должен просуществовать ваш лот? Укажите в секундах.", auctionTime, function( text ) 
            if( isnumber( tonumber( text ) ) ) then
                if( text >= (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) and text <= (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) ) then
                    auctionTime = tonumber( text )
                else
                    notification.AddLegacy( "Минимальное время: " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Auction Time"] or 300) .. ", максимальное: " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Maximum Auction Time"] or 86400) .. "!", 1, 3 )
                end
            else
                notification.AddLegacy( "Неправильное время.", 1, 3 )
            end
        end, function() end, "OK", "Отмена", true )
    end

    local priceBack = vgui.Create( "DButton", priceTimeBack )
    priceBack:Dock( LEFT )
    priceBack:SetWide( (self.createAuctionInfo:GetWide()-5)/2 )
    priceBack:SetText( "" )
    local changeAlpha = 0
    priceBack.Paint = function( self2, w, h )
        if( auctionPrice >= (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) ) then
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.Red )
        end
        
        if( self2:IsDown() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        elseif( self2:IsHovered() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        else
            changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
        end

        surface.SetAlphaMultiplier( changeAlpha/255 )
            if( auctionPrice >= (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) ) then
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            else
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.DarkRed )
            end
        surface.SetAlphaMultiplier( 1 )

        draw.SimpleText( "Цена: ", "BRICKS_SERVER_Font20", 15, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
        draw.SimpleText( currencyTable.formatFunction( auctionPrice ), "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    priceBack.DoClick = function()
        BRICKS_SERVER.Func.StringRequest( "Аукцион", "Какой должна быть стартовая цена?", auctionPrice, function( text ) 
            if( isnumber( tonumber( text ) ) ) then
                if( tonumber( text ) >= (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) ) then
                    auctionPrice = tonumber( text )
                else
                    notification.AddLegacy( "Минимальная цена: " .. (BRICKS_SERVER.CONFIG.MARKETPLACE["Minimum Starting Price"] or 1000) .. "!", 1, 3 )
                end
            else
                notification.AddLegacy( "Неправильная цена.", 1, 3 )
            end
        end, function() end, "OK", "Отмена", true )
    end

    local buyoutpriceBack = vgui.Create( "DButton", priceTimeBack )
    buyoutpriceBack:Dock( LEFT )
    buyoutpriceBack:SetWide( (self.createAuctionInfo:GetWide()-5)/2 )
    buyoutpriceBack:SetText( "" )
    local changeAlpha = 0
    buyoutpriceBack.Paint = function( self2, w, h )
        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
        
        if( self2:IsDown() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        elseif( self2:IsHovered() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        else
            changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
        end

        surface.SetAlphaMultiplier( changeAlpha/255 )
        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
        surface.SetAlphaMultiplier( 1 )

        draw.SimpleText( "Цена выкупа: ", "BRICKS_SERVER_Font20", 15, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
        draw.SimpleText( currencyTable.formatFunction( buyoutPrice ), "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    local minbuyout = auctionPrice*2
    buyoutpriceBack.DoClick = function()
        BRICKS_SERVER.Func.StringRequest( "Аукцион", "Какой должна быть цена выкупа цена?", minbuyout, function( number )
            if isnumber( tonumber(number) ) and number > auctionPrice then 
                buyoutPrice = number
            else
                notification.AddLegacy( "Укажите цену выкупа больше чем начальная ставка.", 1, 3 )
            end
        end, function() end, "OK", "Отмена", true )
    end

    local amountBack = vgui.Create( "DButton", self.createAuctionInfo )
    amountBack:Dock( BOTTOM )
    amountBack:DockMargin( 0, 5, 0, 0 )
    amountBack:SetTall( 40 )
    amountBack:SetText( "" )
    local changeAlpha = 0
    amountBack.Paint = function( self2, w, h )
        if( amount <= (selectedItem[1] or 1) ) then
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )
        else
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.Red )
        end
        
        if( self2:IsDown() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        elseif( self2:IsHovered() ) then
            changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
        else
            changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
        end

        surface.SetAlphaMultiplier( changeAlpha/255 )
            if( amount <= (selectedItem[1] or 1) ) then
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            else
                draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.DEVCONFIG.BaseThemes.DarkRed )
            end
        surface.SetAlphaMultiplier( 1 )

        draw.SimpleText( "Кол-во: ", "BRICKS_SERVER_Font20", 15, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
        draw.SimpleText( amount, "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    amountBack.DoClick = function()
        BRICKS_SERVER.Func.StringRequest( "Auction", "Сколько данного товара вы хотите выставить?", amount, function( text ) 
            if( isnumber( tonumber( text ) ) ) then
                if( tonumber( text ) <= (selectedItem[1] or 1) ) then
                    amount = tonumber( text )
                else
                    notification.AddLegacy( "У вас не хватает данного товара.", 1, 3 )
                end
            else
                notification.AddLegacy( "Неправильное кол-во.", 1, 3 )
            end
        end, function() end, "OK", "Отмена", true )
    end

    local descriptionBack = vgui.Create("DPanel", self.createAuctionInfo)
    descriptionBack:Dock(TOP)
    descriptionBack:DockMargin(0, 5, 0, 0)
    descriptionBack:SetTall(80)
    descriptionBack.Paint = function(self2, w, h)
        draw.RoundedBox(5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme(3))

        local textToShow = infoTable[2] or "NIL"
        local font = "BRICKS_SERVER_Font15"
        
        surface.SetFont(font)
        local textWidth, textHeight = surface.GetTextSize(textToShow)

        local posX = (w - textWidth) /2
        local posY = (h - textHeight) /2


        draw.DrawText(textToShow, font, posX, posY, BRICKS_SERVER.Func.GetTheme(6), TEXT_ALIGN_LEFT)
    end


    local nameBack = vgui.Create( "DPanel", self.createAuctionInfo )
    nameBack:Dock( BOTTOM )
    nameBack:DockMargin( 0, 0, 0, 0 )
    nameBack:SetTall( 40 )
    nameBack.Paint = function( self2, w, h )
        draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

        draw.SimpleText( "Название: ", "BRICKS_SERVER_Font20", 15, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
        draw.SimpleText( (infoTable[1] or "NIL"), "BRICKS_SERVER_Font20", w/2, h/2, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local itemModel = vgui.Create( "DModelPanel" , self.createAuctionInfo )
    itemModel:Dock( FILL )
    itemModel:SetModel( selectedItemTable[2] or "" )
    itemModel:SetFOV( 80 )
    itemModel:SetCamPos( Vector( 0, 50, 5 ) )
    itemModel:SetLookAng( Angle( 180, 90, 180 ) )
    if( selectedItemTable[1] == "bricks_server_resource" ) then
        if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[selectedItemTable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[selectedItemTable[3]][2] ) then
            itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[selectedItemTable[3]][2] )
        end
    end
end

function PANEL:RefreshAdmin()
    if( IsValid( self.adminGrid ) ) then
        self.adminGrid:Remove()
    end

    self.adminGrid = vgui.Create( "DIconLayout", self.adminScrollPanel )
    self.adminGrid:Dock( FILL )
    self.adminGrid:SetSpaceY( self.spacing )
    self.adminGrid:SetSpaceX( self.spacing )

    local gridWide = (self:GetWide()-20)/2
    local wantedSlotSize = 200*(ScrW()/2560)
    local slotsWide = math.floor( gridWide/wantedSlotSize )
    
    local slotSize = (gridWide-5-((slotsWide-1)*self.spacing))/slotsWide

    local currencyTable
    if( BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""] ) then
        currencyTable = BRICKS_SERVER.DEVCONFIG.Currencies[(BRICKS_SERVER.CONFIG.MARKETPLACE or {})["Currency"] or ""]
    end

    if( not currencyTable ) then 
        notification.AddLegacy( "BRICKS SERVER ERROR: Invalid Currency", 1, 5 )
        return 
    end

    local sortedMarketPlace = table.Copy( BRS_MARKETPLACE or {} )
    for k, v in pairs( sortedMarketPlace ) do
        v.key = k
    end

    if( self.adminSortChoice ) then
        if( self.adminSortChoice == "time_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.adminSortChoice == "time_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) > ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
        elseif( self.adminSortChoice == "price_low_to_high" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) < ((b or {})[2] or 0) end )
        elseif( self.adminSortChoice == "price_high_to_low" ) then
            table.sort( sortedMarketPlace, function(a, b) return ((a or {})[2] or 0) > ((b or {})[2] or 0) end )
        end
    else
        table.sort( sortedMarketPlace, function(a, b) return ((((a or {})[4] or 0)+((a or {})[3] or 0))-os.time()) < ((((b or {})[4] or 0)+((b or {})[3] or 0))-os.time()) end )
    end

    for k, v in pairs( sortedMarketPlace ) do
        if( not self.adminShowEnded and ((v[4] or 0)+(v[3] or 0))-os.time() <= 0 ) then
            continue
        end

        local owner = player.GetBySteamID64( v[6] or "" )
        local ownerName = ""
        if( IsValid( owner ) ) then
            ownerName = owner:Nick()
        else
            ownerName = v[7] or "NIL"
        end

        local itemTable = v[5] or {}
        if( (self.adminSearchText or "") != "" and not string.find( string.lower( ownerName ), string.lower( (self.adminSearchText or "") ) ) and not string.find( string.lower( itemTable[4] or "NIL" ), string.lower( (self.adminSearchText or "") ) ) ) then
            continue
        end

        local itemInfo = BRICKS_SERVER.Func.GetEntTypeField( ((itemTable or {})[1] or ""), "GetInfo" )( itemTable )

        local tooltipInfo = {}
        tooltipInfo[1] = { itemInfo[1], false, "BRICKS_SERVER_Font23B" }
        tooltipInfo[2] = "Кол-во: " .. (v[1] or 1)
        tooltipInfo[3] = "Продавец: " .. (v[7] or "NIL")
        if( itemInfo[3] ) then
            local rarityInfo = BRICKS_SERVER.Func.GetRarityInfo( itemInfo[3] )
            tooltipInfo[2] = { itemInfo[3], function() return BRICKS_SERVER.Func.GetRarityColor( rarityInfo ) end, "BRICKS_SERVER_Font17" }
            tooltipInfo[3] = "Кол-во: " .. (v[1] or 1)
            tooltipInfo[4] = "Продавец: " .. (v[7] or "NIL")
        end

        local slotBack = self.adminGrid:Add( "DPanel" )
        slotBack:SetSize( slotSize, slotSize )
        local x, y, w, h = 0, 0, slotSize, slotSize
        local itemModel
        local changeAlpha = 0
        local topBidder = player.GetBySteamID( table.GetWinningKey( v[10] or {} ) or "" )
        slotBack.Paint = function( self2, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 3 ) )

            local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
            if( x != toScreenX or y != toScreenY ) then
                x, y = toScreenX, toScreenY

                itemModel:SetBRSToolTip( x, y, w, h, tooltipInfo )
            end
            
            if( IsValid( itemModel ) ) then
                if( itemModel:IsDown() ) then
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                elseif( itemModel:IsHovered() ) then
                    changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
                else
                    changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
                end
            end

            surface.SetAlphaMultiplier( changeAlpha/255 )
            draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
            surface.SetAlphaMultiplier( 1 )

            draw.SimpleText( currencyTable.formatFunction( v[2] or 0 ), "BRICKS_SERVER_Font20", w/2, h-15, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            if( IsValid( topBidder ) ) then
                draw.SimpleText( topBidder:Nick(), "BRICKS_SERVER_Font15", w/2, h-3, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
            end

            if( IsValid( owner ) ) then
                draw.SimpleText( owner:Nick(), "BRICKS_SERVER_Font15", w/2, 20, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            else
                draw.SimpleText( (v[7] or "NIL"), "BRICKS_SERVER_Font15", w/2, 20, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            end

            if( ((v[4] or 0)+(v[3] or 0))-os.time() > 0 ) then
                draw.SimpleText( BRICKS_SERVER.Func.FormatTime( ((v[4] or 0)+(v[3] or 0))-os.time() ), "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            elseif( (v[3] or 0) == 0 ) then
                draw.SimpleText( "Отменен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            else
                draw.SimpleText( "Окончен", "BRICKS_SERVER_Font17", w/2, 5, BRICKS_SERVER.Func.GetTheme( 6 ), TEXT_ALIGN_CENTER, 0 )
            end

            if( not self.adminShowEnded and os.time() >= ((v[4] or 0)+(v[3] or 0)) ) then 
                self2:Remove()
            end
        end

        if( itemTable[2] ) then
            itemModel = vgui.Create( "DModelPanel" , slotBack )
            itemModel:Dock( FILL )
            itemModel:SetModel( itemTable[2] )
            itemModel:SetFOV( 60 )
            itemModel:SetCamPos( Vector( 0, 50, 5 ) )
            itemModel:SetLookAng( Angle( 180, 90, 180 ) )
            
            if( itemTable[1] == "bricks_server_resource" ) then
                if( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]] and BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] ) then
                    itemModel:SetColor( BRICKS_SERVER.CONFIG.CRAFTING.Resources[itemTable[3]][2] )
                end
            end
        end

        local actions = {
            --[1] = { "View", function() 

            --end },
            [2] = { "Remove", function() 
                net.Start( "BRS.Net.MarketplaceAdminRemove" )
                    net.WriteUInt( v.key, 16 )
                    net.WriteString( v[6] or "" )
                net.SendToServer()
            end }
        }

        if( ((v[4] or 0)+(v[3] or 0))-os.time() > 0 ) then
            actions[3] = { "Отмена", function() 
                net.Start( "BRS.Net.MarketplaceCancel" )
                    net.WriteUInt( v.key, 16 )
                    net.WriteString( v[6] or "" )
                net.SendToServer()
            end }
        end

        if( itemModel ) then
            itemModel.DoClick = function()
                itemModel.Menu = vgui.Create( "bricks_server_dmenu" )
                for k, v in pairs( actions ) do
                    itemModel.Menu:AddOption( v[1], v[2] )
                end
                itemModel.Menu:Open()
                itemModel.Menu:SetPos( x+w+5, y+(h/2)-(itemModel.Menu:GetTall()/2) )
            end
        end
    end

    self.adminScrollPanel:Rebuild()
end

local rounded = 5
function PANEL:Paint( w, h )
    --surface.SetDrawColor(33, 33, 34, 45)
    --surface.DrawRect(0, 0, w, h)
    ACC2.DrawBlur(self, 5)
    draw.RoundedBox( rounded, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
    draw.RoundedBoxEx( rounded, 0, 0, w, self.headerHeight, BRICKS_SERVER.Func.GetTheme( 0 ), true, true, false, false )
    draw.SimpleText( "Аукцион", "BRICKS_SERVER_Font30", 10, (self.headerHeight or 40)/2-2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
end

vgui.Register( "bricks_server_ui_npc_marketplace", PANEL, "DFrame" )