local PANEL = {}

function PANEL:Init()
    self:SetHeader( "Награды за время" )
    self:SetPopupWide( ScrW()*0.45 )

    local bottomButton = vgui.Create( "DButton", self )
    bottomButton:Dock( BOTTOM )
    bottomButton:DockMargin( self:GetPopupWide()*0.3, 25, self:GetPopupWide()*0.3, 25 )
    bottomButton:SetTall( 50 )
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

    self.infoPanel = vgui.Create( "DPanel", self )
    self.infoPanel:Dock( TOP )
    self.infoPanel:SetTall( ScrH()*0.3 )
    self.infoPanel:DockMargin( 25, 0, 25, 0 )
    self.infoPanel.Paint = function() end 

    local claimedRewards
    local function RefreshUnclaimed()
        if( IsValid( self.infoPanel.UnclaimedPanel ) ) then
            self.infoPanel.UnclaimedPanel:Remove()
        end

        claimedRewards = LocalPlayer():Botched():GetClaimedTimeRewards()
        local hasUnclaimed = false
        for k, v in pairs( BOTCHED.CONFIG.REWARDS.TimeRewards ) do
            if( LocalPlayer():Botched():GetTimePlayed() < v.Time or claimedRewards[k] ) then continue end
            hasUnclaimed = true
            break
        end

        if( hasUnclaimed ) then
            local unClaimedRewards = vgui.Create( "DPanel", self.infoPanel )
            unClaimedRewards:SetSize( ScrW()*0.125, 45+40 )
            unClaimedRewards:SetPos( self:GetPopupWide()-50-unClaimedRewards:GetWide(), 0 )
            unClaimedRewards:DockPadding( 0, 40, 0, 0 )
            unClaimedRewards.Paint = function( self2, w, h )
                if( self.FullyOpened ) then
                    BOTCHED.FUNC.BeginShadow( "popup_screen_unclaimed" )
                    BOTCHED.FUNC.SetShadowSize( "popup_screen_unclaimed", w, h )
                    local x, y = self2:LocalToScreen( 0, 0 )
                    draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ) )
                    BOTCHED.FUNC.EndShadow( "popup_screen_unclaimed", x, y, 1, 1, 1, 255, 0, 0, false )
                end

                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )

                draw.SimpleText( "Доступно наград", "MontserratBold20", w/2, 40/2, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end

            self.infoPanel.UnclaimedPanel = unClaimedRewards

            unClaimedRewards.bottom = vgui.Create( "DPanel", unClaimedRewards )
            unClaimedRewards.bottom:Dock( BOTTOM )
            unClaimedRewards.bottom:SetTall( 40 )
            unClaimedRewards.bottom.Paint = function( self2, w, h )
                draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 1 ), false, false, true, true )
            end

            surface.SetFont( "MontserratBold20" )
            local textX, textY = surface.GetTextSize( "Получить всё" )

            unClaimedRewards.button = vgui.Create( "DButton", unClaimedRewards.bottom )
            unClaimedRewards.button:Dock( RIGHT )
            unClaimedRewards.button:SetWide( textX+15 )
            unClaimedRewards.button:DockMargin( 0, 5, 5, 5 )
            unClaimedRewards.button:SetText( "" )
            unClaimedRewards.button.Paint = function( self2, w, h )
                self2:CreateFadeAlpha( false, 75 )
                
                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )
                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 3, self2.alpha ) )

                draw.SimpleText( "Получить всё", "MontserratBold20", w/2, h/2-1, BOTCHED.FUNC.GetTheme( 4, 75+(180*(self2.alpha/75)) ), 1, 1 )
            end
            unClaimedRewards.button.DoClick = function()
                BOTCHED.FUNC.DermaQuery( "Вы хотите получить все награды?", "Награды", "Да", function()
                    net.Start( "Botched.RequestClaimTimeRewards" )
                    net.SendToServer()
                end, "Нет" )
            end

            for k, v in pairs( BOTCHED.CONFIG.REWARDS.TimeRewards ) do
                if( LocalPlayer():Botched():GetTimePlayed() < v.Time or claimedRewards[k] ) then continue end

                if( not BOTCHED.DEVCONFIG.RewardTypes[v.RewardType] ) then continue end
 
                local name, border = "Error"
                if( v.RewardType == "Items" ) then
                    local itemConfig = BOTCHED.CONFIG.LOCKER.Items[v.RewardValue[1]]
                    if( itemConfig ) then name, border = (v.RewardValue[2] > 1 and "x" .. v.RewardValue[2] .. " " or "") .. itemConfig.Name, itemConfig.Border end
                else
                    local rewardCfg = BOTCHED.DEVCONFIG.RewardTypes[v.RewardType]
                    name, border = "x" .. string.Comma( v.RewardValue ) .. " " .. rewardCfg.Name, rewardCfg.Border
                end

                border = BOTCHED.CONFIG.GENERAL.Borders[border or 1]

                local bottomH = 4
                local rewardPanel = vgui.Create( "DPanel", unClaimedRewards )
                rewardPanel:Dock( TOP )
                rewardPanel:SetSize( unClaimedRewards:GetWide()-20, 40 )
                rewardPanel:DockMargin( 10, 0, 10, 5 )
                rewardPanel.Paint = function( self2, w, h )
                    if( not border.Anim ) then
                        BOTCHED.FUNC.DrawRoundedMask( 8, 1, h-16, w-2, 16, function()
                            BOTCHED.FUNC.DrawGradientBox( 1, h-16, w-2, 16, 1, unpack( border.Colors ) )
                        end )
                    end
                end

                if( border.Anim ) then
                    rewardPanel.borderAnim = vgui.Create( "botched_gradientanim", rewardPanel )
                    rewardPanel.borderAnim:SetSize( rewardPanel:GetWide()-2, 16 )
                    rewardPanel.borderAnim:SetPos( 1, rewardPanel:GetTall()-16 )
                    rewardPanel.borderAnim:SetZPos( -100 )
                    rewardPanel.borderAnim:SetDirection( 0 )
                    rewardPanel.borderAnim:SetAnimTime( 5 )
                    rewardPanel.borderAnim:SetAnimSize( rewardPanel.borderAnim:GetWide()*6 )
                    rewardPanel.borderAnim:SetColors( unpack( border.Colors ) )
                    rewardPanel.borderAnim:SetCornerRadius( 8 )
                    rewardPanel.borderAnim:StartAnim()
                end

                rewardPanel.cover = vgui.Create( "DPanel", rewardPanel )
                rewardPanel.cover:Dock( FILL )
                rewardPanel.cover.Paint = function( self2, w, h )
                    BOTCHED.FUNC.DrawPartialRoundedBox( 8, 0, 0, w, h-bottomH, BOTCHED.FUNC.GetTheme( 1 ), false, h, false, false )

                    draw.SimpleText( name, "MontserratBold20", 12, h/2-1, BOTCHED.FUNC.GetTheme( 4, 75 ), 0, TEXT_ALIGN_CENTER )
                end

                surface.SetFont( "MontserratBold20" )
                local textX, textY = surface.GetTextSize( "Получить" )

                rewardPanel.button = vgui.Create( "DButton", rewardPanel.cover )
                rewardPanel.button:Dock( RIGHT )
                rewardPanel.button:SetWide( textX+15 )
                rewardPanel.button:DockMargin( 0, 5, 5, 5+bottomH )
                rewardPanel.button:SetText( "" )
                rewardPanel.button.Paint = function( self2, w, h )
                    self2:CreateFadeAlpha( false, 75 )
                    
                    draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )
                    draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 3, self2.alpha ) )

                    draw.SimpleText( "Получить", "MontserratBold20", w/2, h/2-1, BOTCHED.FUNC.GetTheme( 4, 75+(180*(self2.alpha/75)) ), 1, 1 )
                end
                rewardPanel.button.DoClick = function()
                    BOTCHED.FUNC.DermaQuery( "Вы хотите получить эту награду?", "Награды", "Да", function()
                        net.Start( "Botched.RequestClaimTimeReward" )
                            net.WriteString( k )
                        net.SendToServer()
                    end, "Нет" )
                end

                unClaimedRewards:SetTall( unClaimedRewards:GetTall()+45 )
            end
        end
    end
    RefreshUnclaimed()

    hook.Add( "Botched.Hooks.ClaimedTimeRewardsUpdated", self, RefreshUnclaimed )

    local timePlayed = vgui.Create( "DPanel", self.infoPanel )
    timePlayed:SetSize( ScrW()*0.1, 65 )
    timePlayed:SetPos( self:GetPopupWide()-50-timePlayed:GetWide(), self.infoPanel:GetTall()-timePlayed:GetTall() )
    timePlayed.Paint = function( self2, w, h )
        if( self.FullyOpened ) then
            BOTCHED.FUNC.BeginShadow( "popup_screen_time" )
            local x, y = self2:LocalToScreen( 0, 0 )
            draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ) )
            BOTCHED.FUNC.EndShadow( "popup_screen_time", x, y, 1, 1, 1, 255, 0, 0, false )
        end

        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )

        draw.SimpleText( "Отыгранное время", "MontserratBold20", 10, 5, BOTCHED.FUNC.GetTheme( 3 ) )

        local plyTimePlayed = LocalPlayer():Botched():GetTimePlayed()
        draw.SimpleText( BOTCHED.FUNC.FormatLetterTime( plyTimePlayed ), "MontserratBold20", 10, h-10, BOTCHED.FUNC.GetTheme( 4, 75 ), 0, TEXT_ALIGN_BOTTOM )

        local sortedTimeRewards = {}
        for k, v in pairs( BOTCHED.CONFIG.REWARDS.TimeRewards ) do
            table.insert( sortedTimeRewards, { v.Time, v } )
        end

        table.SortByMember( sortedTimeRewards, 1, true )

        local nextTimeReward
        for k, v in ipairs( sortedTimeRewards ) do
            if( plyTimePlayed >= v[1] ) then continue end

            nextTimeReward = v[2]
            break
        end

        draw.SimpleText( "Следующая: " .. (nextTimeReward and BOTCHED.FUNC.FormatLetterTime( nextTimeReward.Time ) or "-"), "MontserratBold20", w-10, h-10, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

        local progressBarH = 8
        BOTCHED.FUNC.DrawRoundedMask( 8, 0, h-progressBarH-8, w, progressBarH+8, function()
            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 1 ) )
            surface.DrawRect( 0, h-progressBarH, w, progressBarH )

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 3 ) )
            surface.DrawRect( 0, h-progressBarH, w*math.Clamp( plyTimePlayed/(nextTimeReward and nextTimeReward.Time or 1), 0, 1 ), progressBarH )
        end )
    end

    self.rewardSlotSize, self.rewardsPanelSpacing = BOTCHED.FUNC.ScreenScale( 150 ), 10

    local scrollPanel = vgui.Create( "DPanel", self )
    scrollPanel:Dock( TOP )
    scrollPanel:SetWide( self:GetPopupWide()-50 )
    scrollPanel:DockMargin( 25, 0, 25, 0 )
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

    self.rewardsRow = vgui.Create( "DPanel", scrollPanel.content )
    self.rewardsRow:Dock( TOP )
    self.rewardsRow:SetTall( 50+(self.rewardSlotSize*1.2) )
    self.rewardsRow:DockMargin( 0, 0, 0, 10 )
    self.rewardsRow.Paint = function( self, w, h ) end 

    self.slotPanels = {}

    local sortedRewards = {}
    for k, v in pairs( BOTCHED.CONFIG.REWARDS.TimeRewards ) do
        table.insert( sortedRewards, { v.Time, k, v } )
    end

    table.SortByMember( sortedRewards, 1, true )

    local tickMat = Material( "materials/botched/icons/tick_24.png" )
    local function AddSlotPanel( parent, rewardKey, itemInfo, amount, doClick )
        parent.slotPanel = vgui.Create( "botched_item_slot", parent )
        parent.slotPanel:SetSize( self.rewardSlotSize, self.rewardSlotSize )
        parent.slotPanel:SetPos( 0, self.rewardsRow:GetTall()-parent.slotPanel:GetTall() )
        parent.slotPanel:SetItemInfo( itemInfo, amount, doClick, "time_rewards_" .. rewardKey )
        parent.slotPanel:DisableText( true )
        parent.slotPanel:DisableShadows( true )
        parent.slotPanel:SetShadowScissor( self:GetShadowBounds() )

        table.insert( self.slotPanels, parent.slotPanel )

        local claimedCover = vgui.Create( "DPanel", parent.slotPanel.hoverDraw )
        claimedCover:Dock( FILL )
        claimedCover:SetZPos( -100 )
        claimedCover.Paint = function( self2, w, h ) 
            if( claimedRewards[rewardKey] ) then
                surface.SetMaterial( tickMat )
                surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2 ) )
                local iconSize = 24
                surface.DrawTexturedRect( w-11-iconSize, 10, iconSize, iconSize )
            end
        end

        local rewardConfig = BOTCHED.CONFIG.REWARDS.TimeRewards[rewardKey]
        if( not IsValid( self.displayRewardPanel ) and (LocalPlayer():Botched():GetTimePlayed() < rewardConfig.Time or rewardKey == #BOTCHED.CONFIG.REWARDS.TimeRewards) ) then
            doClick()
        end
    end

    timer.Simple( 0, function()
        for k, v in ipairs( sortedRewards ) do
            local rewardKey, rewardCfg = v[2], v[3]

            local headerTall = 50

            local rewardsPanel = vgui.Create( "DPanel", self.rewardsRow )
            rewardsPanel:Dock( LEFT )
            rewardsPanel:SetWide( self.rewardSlotSize )
            rewardsPanel:DockMargin( 0, 0, self.rewardsPanelSpacing, 0 )
            rewardsPanel.Paint = function( self2, w, h ) 
                if( not IsValid( self2.slotPanel ) ) then return end
                draw.SimpleText( "Награда " .. k, "MontserratBold25", w/2, h-self2.slotPanel:GetTall()-headerTall/2, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end 

            local itemInfo, amount = nil, rewardCfg.RewardValue
            local function CreateSlotPanel( doClick )
                if( rewardCfg.RewardType == "Items" and BOTCHED.CONFIG.LOCKER.Items[itemKey] ) then
                    local itemKey = rewardCfg.RewardValue[1]
                    itemInfo, amount = BOTCHED.CONFIG.LOCKER.Items[itemKey], rewardCfg.RewardValue[2]

                    AddSlotPanel( rewardsPanel, rewardKey, itemKey, rewardCfg.RewardValue[2], doClick )
                elseif( BOTCHED.DEVCONFIG.RewardTypes[rewardCfg.RewardType] ) then
                    local rewardCfg = BOTCHED.DEVCONFIG.RewardTypes[rewardCfg.RewardType]
                    itemInfo = {
                        Name = rewardCfg.Name, 
                        Model = rewardCfg.Material, 
                        Border = rewardCfg.Border, 
                        Stars = rewardCfg.Stars
                    }

                    AddSlotPanel( rewardsPanel, rewardKey, itemInfo, amount, doClick )
                else
                    itemInfo = {
                        Name = "Error", 
                        Model = "botched/icons/error.png",
                        Stars = 0
                    }

                    AddSlotPanel( rewardsPanel, rewardKey, itemInfo, amount, doClick )
                end
            end

            local type = string.upper( (BOTCHED.DEVCONFIG.RewardTypes[rewardCfg.RewardType] or {}).Name or "ERROR" )

            CreateSlotPanel( function()
                self:SetDisplayReward( rewardsPanel.slotPanel, itemInfo.Name, itemInfo.Model, amount, itemInfo.Stars, type )
                
                rewardsPanel.slotPanel:SetTall( self.rewardSlotSize*1.2 )
                rewardsPanel.slotPanel:SetPos( 0, self.rewardsRow:GetTall()-rewardsPanel.slotPanel:GetTall() )
            end )

            if( rewardCfg.RewardType == "Items" ) then
                local itemTypeConfig = BOTCHED.DEVCONFIG.ItemTypes[itemInfo.Type or ""] or {}
                type = string.upper( itemTypeConfig.Title or "Item" )
            end
        end
    end )

    local rewardTimes = {}
    for k, v in ipairs( sortedRewards ) do
        local text = string.upper( BOTCHED.FUNC.FormatLetterTime( v[1] ) )

        surface.SetFont( "MontserratBold20" )
        local textX, textY = surface.GetTextSize( text )
        textX = textX+15

        local boxX = (k*(self.rewardSlotSize+self.rewardsPanelSpacing))-self.rewardsPanelSpacing-textX

        rewardTimes[k] = { text, textX, boxX }
    end

    local progressBarColor = BOTCHED.FUNC.GetTheme( 3, 100 )

    local progressPanel = vgui.Create( "DPanel", scrollPanel.content )
    progressPanel:Dock( TOP )
    progressPanel:SetTall( 24 )
    progressPanel.Paint = function( self2, w, h ) 
        local progressBarH = 8

        draw.RoundedBox( progressBarH/2, 0, (h/2)-(progressBarH/2), w, progressBarH, BOTCHED.FUNC.GetTheme( 2, 100 ) )

        local timePlayed = LocalPlayer():Botched():GetTimePlayed()

        local previousTime, currentTimeReward, currentTimeGoal = 0, 1, 0
        for k, v in ipairs( sortedRewards ) do
            if( timePlayed >= v[1] ) then
                previousTime = v[1]
                continue
            end

            currentTimeReward = k
            currentTimeGoal = v[1]
            break
        end

        for k, v in ipairs( rewardTimes ) do
            local textX, boxX = v[2], v[3]

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 1 ) )
            surface.DrawRect( boxX, 0, textX, h )

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2, 100 ) )
            surface.DrawRect( boxX, 0, textX, h )
        end

        local progressW = ((currentTimeReward-1)*(self.rewardSlotSize+self.rewardsPanelSpacing))
        local currentSectionW = self.rewardSlotSize+self.rewardsPanelSpacing
        progressW = progressW-(currentTimeReward > 1 and self.rewardsPanelSpacing or 0)+(currentSectionW*math.Clamp( (timePlayed-previousTime)/(currentTimeGoal-previousTime), 0, 1 ))
        
        local panelX, panelY = self2:LocalToScreen( 0, 0 )
        render.SetScissorRect( panelX, panelY, panelX+progressW, panelY+h, true )

        surface.SetDrawColor( progressBarColor )
        surface.DrawRect( 0, (h/2)-(progressBarH/2)+1, w, progressBarH-2 )

        for k, v in ipairs( rewardTimes ) do
            local textX, boxX = v[2], v[3]

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 1 ) )
            surface.DrawRect( boxX, 0, textX, h )

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 1 ) )
            surface.DrawRect( boxX+1, 1, textX-2, h-2 )

            surface.SetDrawColor( progressBarColor )
            surface.DrawRect( boxX+1, 1, textX-2, h-2 )
        end

        render.SetScissorRect( 0, 0, 0, 0, false )

        for k, v in ipairs( rewardTimes ) do
            draw.SimpleTextOutlined( v[1], "MontserratBold20", v[3]+(v[2]/2), h/2-1, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, BOTCHED.FUNC.GetTheme( 1 ) )
        end
    end 

    scrollPanel:SetTall( scrollPanel.scrollBar:GetTall()+25+self.rewardsRow:GetTall()+10+progressPanel:GetTall() )
    scrollPanel.content:SetSize( (#sortedRewards*(self.rewardSlotSize+self.rewardsPanelSpacing))-self.rewardsPanelSpacing, scrollPanel:GetTall()-scrollPanel.scrollBar:GetTall()-25 )

    local contentViewW = self:GetPopupWide()-50
    scrollPanel.scrollBar.Grip:SetWide( (contentViewW/scrollPanel.content:GetWide())*contentViewW )

    self:SetExtraHeight( bottomButton:GetTall()+self.infoPanel:GetTall()+50+scrollPanel:GetTall() )
end

function PANEL:SetDisplayReward( slotPanel, name, model, amount, stars, type )
    if( IsValid( self.activeDisplaySlot ) ) then
        self.activeDisplaySlot:SetTall( self.rewardSlotSize )
        self.activeDisplaySlot:SetPos( 0, self.rewardsRow:GetTall()-self.activeDisplaySlot:GetTall() )
    end

    self.activeDisplaySlot = slotPanel

    if( IsValid( self.displayRewardPanel ) ) then
        self.displayRewardPanel:Remove()
    end

    local iconSize, iconSpacing = 32, 2
    local starMat = Material( "materials/botched/icons/star_32.png" )
    local starBlankMat = Material( "materials/botched/icons/star_32_blank.png" )

    name = string.upper( name )
    if( amount and amount > 1 ) then name = "x" .. string.Comma( amount ) .. " " .. name end

    surface.SetFont( "MontserratBold50" )
    local nameX, nameY = surface.GetTextSize( name )

    local iconMat
    if( model and (string.EndsWith( model, ".png" ) or string.EndsWith( model, ".jpg" )) ) then
        iconMat = Material( model )
    end

    local modelW = self:GetPopupWide()*0.4

    self.displayRewardPanel = vgui.Create( "DPanel", self.infoPanel )
    self.displayRewardPanel:Dock( FILL )
    self.displayRewardPanel:SetZPos( -100 )
    self.displayRewardPanel.Paint = function( self2, w, h )
        draw.SimpleText( type, "MontserratBold20", 0, 0, BOTCHED.FUNC.GetTheme( 3 ) )
        draw.SimpleText( name, "MontserratBold50", 0, 8, BOTCHED.FUNC.GetTheme( 4, 75 ) )

        surface.SetMaterial( starBlankMat )
        surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2, 100 ) )
        for i = 1, 5 do
            surface.DrawTexturedRect( ((i-1)*(iconSize+iconSpacing)), nameY+10, iconSize, iconSize )
        end

        surface.SetMaterial( starMat )
        surface.SetDrawColor( 255, 255, 255 )
        for i = 1, stars do
            surface.DrawTexturedRect( ((i-1)*(iconSize+iconSpacing)), nameY+10, iconSize, iconSize )
        end

        if( iconMat ) then
            local iconSize = modelW*0.4
            surface.SetDrawColor( 255, 255, 255 )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( (modelW/2)-(iconSize/2), (h/2)-(iconSize/2), iconSize, iconSize )
        end
    end

    if( model and string.EndsWith( model, ".mdl" ) ) then
        local modelPanel = vgui.Create( "DModelPanel", self.displayRewardPanel )
        modelPanel:Dock( LEFT )
        modelPanel:SetWide( modelW )
        modelPanel:DockMargin( 0, nameY, 0, 0 )
        modelPanel:SetCursor( "arrow" )
        modelPanel:SetModel( model )
        modelPanel.LayoutEntity = function() end
        if( IsValid( modelPanel.Entity ) ) then
            local mn, mx = modelPanel.Entity:GetRenderBounds()
            local size = 0
            size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
            size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
            size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

            modelPanel:SetFOV( 45 )
            modelPanel:SetCamPos( Vector( size, size, size ) )
            modelPanel:SetLookAt( (mn + mx) * 0.5 )
        end
    end
end

function PANEL:GetShadowBounds()
    local x, y = self.mainPanel:LocalToScreen( 0, 0 )
    return x+25, 0, x+self:GetPopupWide()-25, ScrH()
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

vgui.Register( "botched_popup_timerewards", PANEL, "botched_popup_base" )