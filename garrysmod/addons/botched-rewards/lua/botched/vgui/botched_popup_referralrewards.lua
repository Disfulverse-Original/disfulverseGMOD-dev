local PANEL = {}

function PANEL:Init()
    self:SetHeader( "Реферальные награды" )
    self:SetDrawHeader( false )
    self.header:SetTall( 0 )
    self.closeButton:Remove()

    local margin5 = BOTCHED.FUNC.ScreenScale( 5 )
    local margin10 = BOTCHED.FUNC.ScreenScale( 10 )
    local margin25 = BOTCHED.FUNC.ScreenScale( 25 )
    local margin50 = BOTCHED.FUNC.ScreenScale( 50 )

    self:SetPopupWide( ScrW()*0.5 )

    local headerPanel = vgui.Create( "DPanel", self )
    headerPanel:Dock( TOP )
    headerPanel:DockMargin( 0, margin50, 0, 0 )
    headerPanel:SetTall( BOTCHED.FUNC.ScreenScale( 45 ) )
    headerPanel.Paint = function( self2, w, h ) 
        draw.SimpleText( "Реферальные награды", "MontserratBold30", w/2, 0, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, 0 )
        --draw.SimpleText( "Refer players for rewards", "MontserratMedium20", w/2, h, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    end

    local topPanel = vgui.Create( "DPanel", self )
    topPanel:Dock( TOP )
    topPanel:DockPadding( 0, margin25, 0, margin25 )
    topPanel:DockMargin( margin50, margin50, margin50, margin50 )
    topPanel:SetTall( BOTCHED.FUNC.ScreenScale( 125 ) )
    topPanel.Paint = function( self2, w, h ) 
        local x, y = self2:LocalToScreen( 0, 0 )

        if( self.FullyOpened ) then
            BOTCHED.FUNC.BeginShadow( "referralrewards_toppanel" )
            BOTCHED.FUNC.SetShadowSize( "referralrewards_toppanel", w, h )
            draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ) )
            BOTCHED.FUNC.EndShadow( "referralrewards_toppanel", x, y, 1, 1, 1, 255, 0, 0, false )
        end

        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )
    end
    topPanel.AddStatPanel = function( self2, title, subTitle )
        self2.statPanels = self2.statPanels or {}

        if( #self2.statPanels >= 1 ) then
            local spacingPanel = vgui.Create( "DPanel", self2 )
            spacingPanel:Dock( LEFT )
            spacingPanel:SetWide( margin25 )
            spacingPanel.Paint = function( self2, w, h ) 
                local spacerW = 4
                draw.RoundedBox( spacerW/2, (w/2)-(spacerW/2), 0, spacerW, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )
            end
        end

        surface.SetFont( "MontserratBold25" )
        local titleY = select( 2, surface.GetTextSize( title ) )

        surface.SetFont( "MontserratBold50" )
        local subTitleY = select( 2, surface.GetTextSize( subTitle() ) )

        local contentH = titleY+subTitleY-BOTCHED.FUNC.ScreenScale( 30 )

        local statPanel = vgui.Create( "DPanel", self2 )
        statPanel:Dock( LEFT )
        statPanel.Paint = function( self2, w, h ) 
            draw.SimpleText( title, "MontserratBold25", w/2, (h/2)-(contentH/2)-BOTCHED.FUNC.ScreenScale( 8 ), BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, 0 )
            draw.SimpleText( subTitle(), "MontserratBold50", w/2, (h/2)+(contentH/2)+BOTCHED.FUNC.ScreenScale( 25 ), BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
        end

        table.insert( self2.statPanels, statPanel )
    end

    topPanel:AddStatPanel( "Перешло по рефералке", function() 
        return LocalPlayer():Botched():GetReferralCount()
    end )

    topPanel:AddStatPanel( "Наград получено", function() 
        local count = 0
        for k, v in pairs( LocalPlayer():Botched():GetClaimedReferralRewards() ) do
            local rewardConfig = (BOTCHED.CONFIG.REWARDS.ReferralRewards[k] or {}).Reward
            if( not rewardConfig ) then continue end

            for key, val in pairs( rewardConfig ) do
                if( key == "Items" ) then
                    count = count+table.Count( val )
                    continue
                end

                count = count+1
            end
        end

        return count
    end )

    topPanel:AddStatPanel( "Отыгранное время", function() 
        return string.upper( BOTCHED.FUNC.FormatLongLetterTime( LocalPlayer():Botched():GetTimePlayed() ) )
    end )

    for k, v in ipairs( topPanel.statPanels ) do
        v:SetWide( (self:GetPopupWide()-(2*margin50)-((#topPanel.statPanels-1)*margin25))/#topPanel.statPanels )
    end

    -- Actions
    local actionsPanel = vgui.Create( "DPanel", self )
    actionsPanel:Dock( TOP )
    actionsPanel:SetTall( BOTCHED.FUNC.ScreenScale( 110 ) )
    actionsPanel:DockMargin( margin50, 0, margin50, 0 )
    actionsPanel.Paint = function( self2, w, h ) end
    actionsPanel.AddActionPanel = function( self2, title, subTitle )
        local actionPanel = vgui.Create( "DPanel", self2 )
        actionPanel:Dock( LEFT )
        actionPanel:SetWide( (self:GetPopupWide()-(2*margin50)-(2*margin25))/3 )
        actionPanel:DockMargin( 0, 0, margin25, 0 )
        actionPanel.Paint = function( self2, w, h ) 
            local x, y = self2:LocalToScreen( 0, 0 )
            
            if( self2.OnPositionUpdated and ((self2.actualX or 0) != x or (self2.actualY or 0) != y) ) then
                self2.actualX, self2.actualY = x, y
                self2:OnPositionUpdated()
            end
    
            if( self.FullyOpened ) then
                BOTCHED.FUNC.BeginShadow( "referralrewards_referpanel" )
                BOTCHED.FUNC.SetShadowSize( "referralrewards_referpanel", w, h )
                draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ) )
                BOTCHED.FUNC.EndShadow( "referralrewards_referpanel", x, y, 1, 1, 1, 255, 0, 0, false )
            end
    
            draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )
    
            draw.SimpleText( title, "MontserratBold25", margin10, margin10, BOTCHED.FUNC.GetTheme( 3 ) )
    
            draw.SimpleText( subTitle, "MontserratMedium20", margin10, BOTCHED.FUNC.ScreenScale( 35 ), BOTCHED.FUNC.GetTheme( 4, 75 ) )
        end

        return actionPanel
    end

    local referralsPanel = actionsPanel:AddActionPanel( "Использовать рефералку", "Выберите рефералку игрока:" )
    referralsPanel.OnPositionUpdated = function( self2 ) 
        self2:CreatePlayerList()
    end
    referralsPanel.CreatePlayerList = function( self2 )
        if( IsValid( self2.referralsSearch ) ) then
            self2.referralsSearch:Remove()
        end

        local x, y = self.mainPanel:ScreenToLocal( self2.actualX, self2.actualY )

        local ignorePlayers = { LocalPlayer() }
        for k, v in pairs( LocalPlayer():Botched():GetReferredPlayers() ) do
            local ply = player.GetBySteamID64( k )
            if( not IsValid( ply ) ) then continue end

            table.insert( ignorePlayers, ply )
        end

        self2.referralsSearch = vgui.Create( "botched_combo_players", self )
        self2.referralsSearch:SetSize( BOTCHED.FUNC.ScreenScale( 200 ), BOTCHED.FUNC.ScreenScale( 40 ) )
        self2.referralsSearch:SetPos( x+margin10, y+referralsPanel:GetTall()-margin10-self2.referralsSearch:GetTall() )
        self2.referralsSearch:IgnorePlayers( unpack( ignorePlayers ) )
        self2.referralsSearch.OnSelect = function( self2, steamID64 )
            local victim = player.GetBySteamID64( steamID64 )
            if( not IsValid( victim ) ) then return end

            net.Start( "Botched.RequestSendReferral" )
                net.WriteEntity( victim )
            net.SendToServer()
        end
    end

    local claimPanel = actionsPanel:AddActionPanel( "Получить награды", "Здесь вы можете забрать свои награды:" )

    local claimButton = vgui.Create( "DButton", claimPanel )
    claimButton:Dock( BOTTOM )
    claimButton:SetTall( BOTCHED.FUNC.ScreenScale( 40 ) )
    claimButton:DockMargin( margin10, 0, margin10, margin10 )
    claimButton:SetText( "" )
    claimButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 155 )

        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 150+(self2.alpha or 0) ) )

        local unclaimedRewards = table.Count( LocalPlayer():Botched():GetUnClaimedReferralRewards() )
        draw.SimpleText( "Забрать награды: " .. unclaimedRewards , "MontserratMedium20", w/2, h/2, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    claimButton.DoClick = function()
        if( #LocalPlayer():Botched():GetUnClaimedReferralRewards() <= 0 ) then return end

        net.Start( "Botched.RequestClaimReferralRewards" )
        net.SendToServer()
    end

    local referredPanel = actionsPanel:AddActionPanel( "Перешедшие по рефералке", "Отправка/принятие рефералок" )

    local acceptedMat = Material( "botched/icons/accepted.png" )

    local playersBack = vgui.Create( "DPanel", referredPanel )
    playersBack:Dock( BOTTOM )
    playersBack:SetTall( BOTCHED.FUNC.ScreenScale( 40 ) )
    playersBack:DockMargin( margin10, 0, margin10, margin10 )
    playersBack.Paint = function( self2, w, h ) end
    playersBack.Refresh = function( self2 )
        self2:Clear()

        local referredPlayers = LocalPlayer():Botched():GetReferredPlayers()
        local referredIDs = table.GetKeys( referredPlayers )
        local currentKey = 1

        local function CreatePlayerEntry( parent, steamID64, name, accepted )
            local playerEntry = vgui.Create( "DPanel", parent )
            playerEntry:Dock( LEFT )
            playerEntry:SetWide( BOTCHED.FUNC.ScreenScale( 100 ) )
            playerEntry:DockMargin( 0, 0, margin10, 0 )
            playerEntry.playerName = name
            playerEntry.Paint = function( self2, w, h )
                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 150 ) )
        
                draw.SimpleText( self2.playerName, "MontserratMedium20", h+margin5, h/2, BOTCHED.FUNC.GetTheme( 4, 75 ), 0, TEXT_ALIGN_CENTER )

                DisableClipping( true )

                surface.SetDrawColor( accepted and BOTCHED.FUNC.GetTheme( 3 ) or BOTCHED.FUNC.GetTheme( 2 ) )
                surface.SetMaterial( acceptedMat )
                local iconSize = BOTCHED.FUNC.ScreenScale( 16 )
                surface.DrawTexturedRect( w-iconSize+margin5, -margin5, iconSize, iconSize )

                DisableClipping( false )
            end

            local avatar = vgui.Create( "botched_avatar", playerEntry )
            avatar:SetPos( margin5, margin5 )
            avatar:SetSize( self2:GetTall()-(2*margin5), self2:GetTall()-(2*margin5) )
            avatar:SetCircleAvatar( true )
            avatar:SetSteamID( steamID64 )

            return playerEntry
        end

        local function CreateViewAllButton( amountLeft )
            local viewAllButton = vgui.Create( "DButton", self2 )
            viewAllButton:Dock( LEFT )
            viewAllButton:SetWide( self2:GetTall() )
            viewAllButton:DockMargin( 0, 0, margin10, 0 )
            viewAllButton:SetText( "" )
            viewAllButton.Paint = function( self2, w, h )
                self2:CreateFadeAlpha( 0.2, 155 )
        
                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 150+(self2.alpha or 0) ) )
        
                draw.SimpleText( "+" .. amountLeft, "MontserratBold25", w/2-1, h/2-1, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

                -- Tooltip
                if( IsValid( self2.viewAllPopup ) and not self2:IsHovered() and not self2.viewAllPopup.removingStarted ) then
                    self2.viewAllPopup.removingStarted = true
                    self2.viewAllPopup:AlphaTo( 0, 0.2, 0, function() 
                        self2.viewAllPopup:Remove()
                    end )
                elseif( not IsValid( self2.viewAllPopup ) and self2:IsHovered() ) then
                    self2:CreatePopup()
                end
            end
            viewAllButton.CreatePopup = function( self2 )
                if( IsValid( self2.viewAllPopup ) ) then return end

                self2.viewAllPopup = vgui.Create( "DPanel" )
                self2.viewAllPopup:SetSize( BOTCHED.FUNC.ScreenScale( 200 ), margin10+margin5 )
                self2.viewAllPopup:SetPos( self2:LocalToScreen( self2:GetWide()+margin10, 0 ) )
                self2.viewAllPopup:DockPadding( margin10, margin10, margin10, 0 )
                self2.viewAllPopup:SetDrawOnTop( true )
                self2.viewAllPopup:SetAlpha( 0 )
                self2.viewAllPopup:AlphaTo( 255, 0.2 )
                self2.viewAllPopup.Think = function( self3 )
                    if( not IsValid( self2 ) ) then
                        self3:Remove()
                    end
                end
                self2.viewAllPopup.Paint = function( self3, w, h )
                    local x, y = self3:LocalToScreen( 0, 0 )

                    BOTCHED.FUNC.BeginShadow( "referralrewards_viewallpopup" )
                    BOTCHED.FUNC.SetShadowSize( "referralrewards_viewallpopup", w, h )
                    draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ) )
                    BOTCHED.FUNC.EndShadow( "referralrewards_viewallpopup", x, y, 1, 1, 1, 255, 0, 0, false )
            
                    draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )
                end

                for k, v in ipairs( referredIDs ) do
                    if( k < currentKey ) then continue end

                    local playerEntry = CreatePlayerEntry( self2.viewAllPopup, v, v, referredPlayers[v][1] )
                    playerEntry:Dock( TOP )
                    playerEntry:SetTall( BOTCHED.FUNC.ScreenScale( 40 ) )
                    playerEntry:DockMargin( 0, 0, 0, margin5 )

                    steamworks.RequestPlayerInfo( v, function( steamName )
                        if( not IsValid( playerEntry ) ) then return end
                        playerEntry.playerName = steamName
                    end )

                    self2.viewAllPopup:SetTall( self2.viewAllPopup:GetTall()+margin5+playerEntry:GetTall() )
                end
            end
        end

        local totalW = self2:GetTall()
        local function AddPlayer( steamID64 )
            if( not steamID64 ) then return end

            steamworks.RequestPlayerInfo( steamID64, function( steamName )
                if( not IsValid( self2 ) ) then return end

                surface.SetFont( "MontserratMedium20" )
                local textX = surface.GetTextSize( steamName )

                local width = self2:GetTall()+textX+margin10+margin5
                totalW = totalW+width+margin10

                if( totalW >= referredPanel:GetWide()-(2*margin10) ) then
                    local amountLeft = #referredIDs-(currentKey-1)
                    if( amountLeft > 0 ) then
                        CreateViewAllButton( amountLeft )
                    end

                    return
                end

                local playerEntry = CreatePlayerEntry( self2, steamID64, steamName, referredPlayers[steamID64][1] )
                playerEntry:Dock( LEFT )
                playerEntry:SetWide( width )
                playerEntry:DockMargin( 0, 0, margin10, 0 )

                currentKey = currentKey+1
                AddPlayer( referredIDs[currentKey] )
            end )
        end

        AddPlayer( referredIDs[1] )
    end
    playersBack:Refresh()

    hook.Add( "Botched.Hooks.ReferredPlayersUpdated", self, function() playersBack:Refresh() end )

    -- Rewards
    local rewardsHeader = vgui.Create( "DPanel", self )
    rewardsHeader:Dock( TOP )
    rewardsHeader:SetTall( BOTCHED.FUNC.ScreenScale( 30 ) )
    rewardsHeader:DockMargin( margin50, margin50, margin50, 0 )
    rewardsHeader.Paint = function( self2, w, h ) 
        draw.SimpleText( "Награды", "MontserratBold25", 0, 0, BOTCHED.FUNC.GetTheme( 3 ) )
    end

    local scrollPanel = vgui.Create( "DPanel", self )
    scrollPanel:Dock( TOP )
    scrollPanel:SetWide( self:GetPopupWide()-(2*margin50) )
    scrollPanel:DockMargin( margin50, 0, margin50, 0 )
    scrollPanel.Paint = function() end 
    scrollPanel.OnMouseWheeled = function( self2, data )
        local x, y = self2.scrollBar.Grip:GetPos()
        self2.scrollBar.Grip:UpdatePos( x-(self2.scrollBar:GetWide()*(data*0.05)) )
    end

    scrollPanel.scrollBar = vgui.Create( "DPanel", scrollPanel )
    scrollPanel.scrollBar:Dock( BOTTOM )
    scrollPanel.scrollBar:SetSize( scrollPanel:GetWide(), 10 )
    scrollPanel.scrollBar.Paint = function( self2, w, h ) 
        draw.RoundedBox( h/2, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )

        BOTCHED.FUNC.DrawRoundedMask( 8, 0, 0, w, h, function()
            self2.Grip:PaintManual()
        end )
    end

    scrollPanel.scrollBar.Grip = vgui.Create( "DButton", scrollPanel.scrollBar )
    scrollPanel.scrollBar.Grip:SetPos( 0, 0 )
    scrollPanel.scrollBar.Grip:SetSize( 0, scrollPanel.scrollBar:GetTall() )
    scrollPanel.scrollBar.Grip:SetText( "" )
    scrollPanel.scrollBar.Grip:SetPaintedManually( true )
    scrollPanel.scrollBar.Grip.GetMaxX = function( self2 )
        return scrollPanel.scrollBar:GetWide()-self2:GetWide()
    end
    scrollPanel.scrollBar.Grip.Paint = function( self2, w, h ) 
        if( self2:IsDown() ) then
            self2.alpha = 100
        else
            self2:CreateFadeAlpha( false, 100 )
        end

		draw.RoundedBox( h/2, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2 ) )
		draw.RoundedBox( h/2, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 3, self2.alpha ) )
    end
    scrollPanel.scrollBar.Grip.UpdatePos = function( self2, newXPos )
        local targetMaxXPos = self2:GetMaxX()
        local maxXPos = targetMaxXPos+100
        newXPos = math.Clamp( newXPos, -100, maxXPos )

        self2:SetPos( newXPos, 0 )
        scrollPanel.content:SetPos( (scrollPanel:GetWide()-scrollPanel.content:GetWide())*(newXPos/targetMaxXPos), 0 )
    end
    scrollPanel.scrollBar.Grip.Think = function( self2 )
        if( self2:IsDown() ) then
            if( not self2.startClickPanelX or not self2.startClickX ) then
                self2.startClickPanelX = self2:GetPos()
                self2.startClickX = gui.MouseX()
            end

            self2:UpdatePos( self2.startClickPanelX+gui.MouseX()-self2.startClickX )
        elseif( self2.startClickX ) then
            self2.startClickPanelX = nil
            self2.startClickX = nil
        end

        local targetMaxXPos = self2:GetMaxX()
        local panelX = self2:GetPos()

        if( panelX > targetMaxXPos ) then
            scrollPanel.scrollBar.Grip:UpdatePos( Lerp( FrameTime()*5, panelX, targetMaxXPos ) )
        elseif( panelX < 0 ) then
            scrollPanel.scrollBar.Grip:UpdatePos( Lerp( FrameTime()*5, panelX, 0 ) )
        end
    end

    scrollPanel.content = vgui.Create( "DPanel", scrollPanel )
    scrollPanel.content:SetPos( 0, 0 )
    scrollPanel.content.Paint = function( self, w, h ) end 

    local rewardSlotW = BOTCHED.FUNC.ScreenScale( 150 )
    local rewardSlotSpacing = BOTCHED.FUNC.ScreenScale( 10 )
    local rewardTierH = BOTCHED.FUNC.ScreenScale( 40 )

    self.rewardsRow = vgui.Create( "DPanel", scrollPanel.content )
    self.rewardsRow:Dock( TOP )
    self.rewardsRow:SetTall( rewardTierH+rewardSlotW )
    self.rewardsRow:DockMargin( 0, 0, 0, 10 )
    self.rewardsRow.Paint = function( self, w, h ) end 

    self.slotPanels = {}
    local function AddSlotPanel( parent, uniqueID, itemInfo, amount )
        local slotPanel = vgui.Create( "botched_item_slot", parent )
        slotPanel:Dock( LEFT )
        slotPanel:DockMargin( 0, 0, rewardSlotSpacing, 0 )
        slotPanel:SetSize( rewardSlotW, rewardSlotW )
        slotPanel:SetItemInfo( itemInfo, amount, false, uniqueID )
        slotPanel:DisableText( true )
        slotPanel:DisableShadows( true )

        table.insert( self.slotPanels, slotPanel )
    end

    timer.Simple( 0, function() 
        local x = self.mainPanel:LocalToScreen( 0, 0 )

        local x, y, w, h = x+margin50, 0, x+self:GetPopupWide()-margin50, ScrH()
        for k, v in ipairs( self.slotPanels ) do
            v:SetShadowScissor( x, y, w, h ) 
        end
    end )

    local claimedRewards = LocalPlayer():Botched():GetClaimedReferralRewards()
    hook.Add( "Botched.Hooks.ClaimedReferralRewardsUpdated", self, function() 
        claimedRewards = LocalPlayer():Botched():GetClaimedReferralRewards()
    end )

    local rewardsW = -margin25

    local sortedRewards = {}
    for k, v in pairs( BOTCHED.CONFIG.REWARDS.ReferralRewards ) do
        table.insert( sortedRewards, { k, v } )
    end

    table.SortByMember( sortedRewards, 1, true )

    for k, v in pairs( sortedRewards ) do
        local referralRewardKey, referralRewardCfg = v[1], v[2]

        local slotCount = table.Count( referralRewardCfg )
        if( referralRewardCfg.Items ) then
            slotCount = slotCount-1+table.Count( referralRewardCfg.Items )
        end

        local rewardTierPanel = vgui.Create( "DPanel", self.rewardsRow )
        rewardTierPanel:Dock( LEFT )
        rewardTierPanel:DockPadding( 0, rewardTierH, 0, 0 )
        rewardTierPanel:DockMargin( 0, 0, margin25, 0 )
        rewardTierPanel:SetWide( (slotCount*rewardSlotW)+((slotCount-1)*rewardSlotSpacing) )
        rewardTierPanel.Paint = function( self, w, h ) 
            local lineSize, lineTall, lineDist = 3, BOTCHED.FUNC.ScreenScale( 10 ), BOTCHED.FUNC.ScreenScale( 5 )

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2 ) )
            surface.DrawRect( 0, rewardTierH-lineDist-lineTall, w, lineSize )
            surface.DrawRect( 0, rewardTierH-lineDist-lineTall, lineSize, lineTall )
            surface.DrawRect( w-lineSize, rewardTierH-lineDist-lineTall, lineSize, lineTall )

            draw.SimpleText( referralRewardKey .. " Переходов по рефералке.", "MontserratMedium20", w/2, 0, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, 0 )

            if( claimedRewards[k] ) then
                draw.SimpleText( "Получено", "MontserratBold20", w, 0, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_RIGHT, 0 )
            end
        end 

        rewardsW = rewardsW+rewardTierPanel:GetWide()+margin25

        for key, val in pairs( referralRewardCfg ) do
            if( not BOTCHED.DEVCONFIG.RewardTypes[key] ) then 
                itemInfo = {
                    Name = "Error", 
                    Model = "botched/icons/error.png"
                } 
            elseif( key == "Items" ) then
                for key2, val2 in pairs( referralRewardCfg.Items ) do
                    local configItem = BOTCHED.CONFIG.LOCKER.Items[key2]
                    if( not configItem ) then continue end
            
                    AddSlotPanel( rewardTierPanel, "referral_rewards_" .. k .. "_" .. key .. "_" .. key2, key2, val2 )
                end 
            else
                local rewardCfg = BOTCHED.DEVCONFIG.RewardTypes[key]
                itemInfo = {
                    Name = rewardCfg.Name,
                    Model = rewardCfg.Material,
                    Border = rewardCfg.Border,
                    Stars = rewardCfg.Stars
                }

                AddSlotPanel( rewardTierPanel, "referral_rewards_" .. k .. "_" .. key, itemInfo, val )
            end
        end
    end

    scrollPanel:SetTall( scrollPanel.scrollBar:GetTall()+25+self.rewardsRow:GetTall() )
    scrollPanel.content:SetSize( rewardsW, scrollPanel:GetTall()-scrollPanel.scrollBar:GetTall()-25 )

    local contentViewW = self:GetPopupWide()-50
    scrollPanel.scrollBar.Grip:SetWide( (contentViewW/scrollPanel.content:GetWide())*contentViewW )

    -- Bottom Area
    local bottomArea = vgui.Create( "DPanel", self )
    bottomArea:Dock( BOTTOM )
    bottomArea:DockMargin( 0, margin25, 0, margin50 )
    bottomArea:SetTall( BOTCHED.FUNC.ScreenScale( 50 ) )
    bottomArea.Paint = function( self2, w, h ) end

    local bottomButton = vgui.Create( "DButton", bottomArea )
    bottomButton:Dock( FILL )
    bottomButton:DockMargin( self:GetPopupWide()*0.2, 0, self:GetPopupWide()*0.2, 0 )
    bottomButton:SetText( "" )
    bottomButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 255 )

        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100+((self2.alpha/255)*100) ) )

        BOTCHED.FUNC.DrawClickCircle( self2, w, h, BOTCHED.FUNC.GetTheme( 2 ), 8 )

        BOTCHED.FUNC.DrawPartialRoundedBox( 8, 0, h-5, w, 5, BOTCHED.FUNC.GetTheme( 3, self2.alpha ), false, 16, false, h-5-11 )

        draw.SimpleText( "Закрыть", "MontserratMedium20", w/2, h/2, BOTCHED.FUNC.GetTheme( 4, 75+(180*(self2.alpha/100)) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    bottomButton.DoClick = function()
        self:Close()
    end

    self:SetExtraHeight( margin50+headerPanel:GetTall()+margin50+topPanel:GetTall()+margin50+actionsPanel:GetTall()+margin50+rewardsHeader:GetTall()+scrollPanel:GetTall()+margin50+bottomArea:GetTall()+margin50 )
end

function PANEL:OnOpen()
    for k, v in ipairs( self.slotPanels or {} ) do
        if( not IsValid( v ) ) then continue end
        v:DisableShadows( false )
    end
end

function PANEL:OnClose()
    for k, v in ipairs( self.slotPanels or {} ) do
        if( not IsValid( v ) ) then continue end
        v:DisableShadows( true )
    end
end

vgui.Register( "botched_popup_referralrewards", PANEL, "botched_popup_base" )