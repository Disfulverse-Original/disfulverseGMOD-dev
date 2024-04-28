local PANEL = {}

function PANEL:Init()
    self:SetHeader( "Награды за Вход" )
    self:SetDrawHeader( false )
    self.closeButton:Remove()

    local leftWide = ScrW()*0.15
    self.slotSize, self.slotSpacing = 150, 30
    self.rowSpacing = self.slotSpacing
    self.outerBorder = 50

    self:SetPopupWide( leftWide+(2*self.outerBorder)+(5*(self.slotSize+self.slotSpacing))-self.slotSpacing+self.rowSpacing )
    self:SetExtraHeight( (3*(self.slotSize+self.rowSpacing))-self.rowSpacing+(2*self.outerBorder)+25 )

    self.centerArea = vgui.Create( "DPanel", self )
    self.centerArea:SetPos( 0, 0 )
    self.centerArea:SetSize( self:GetPopupWide(), self.mainPanel.targetH )
    self.centerArea.Paint = function( self, w, h ) end

    self.leftArea = vgui.Create( "DPanel", self.centerArea )
    self.leftArea:Dock( LEFT )
    self.leftArea:SetWide( leftWide )
    self.leftArea.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )

        BOTCHED.FUNC.BeginShadow( "loginrewards_sidepanel", self:GetShadowBounds() )
        BOTCHED.FUNC.SetShadowSize( "loginrewards_sidepanel", w, h-4 )
        draw.RoundedBoxEx( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ), true, false, true, false )
        BOTCHED.FUNC.EndShadow( "loginrewards_sidepanel", x, y, 1, 2, 2, 255, 0, 5, true )

        draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 1 ), true, false, true, false )
        draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 35 ), true, false, true, false )

        draw.SimpleText( "Награда", "MontserratBold30", w/2, 25, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, 0 )
    end

    self.rightArea = vgui.Create( "DPanel", self.centerArea )
    self.rightArea:Dock( FILL )
    self.rightArea:SetSize( self:GetPopupWide()-self.leftArea:GetWide(), self.centerArea:GetTall() )
    self.rightArea.Paint = function( self, w, h ) end

    local bottomArea = vgui.Create( "DPanel", self.rightArea )
    bottomArea:Dock( BOTTOM )
    bottomArea:DockMargin( 0, 25, 0, 25 )
    bottomArea:SetSize( self.rightArea:GetWide()-50, 50 )
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

    surface.SetFont( "MontserratMedium20" )
    local textX, textY = surface.GetTextSize( "Страница 1" )

    local pageController = vgui.Create( "DPanel", bottomArea )
    pageController:SetSize( 80+textX+25, 40 )
    pageController:SetPos( bottomArea:GetWide()-pageController:GetWide(), (bottomArea:GetTall()/2)-(pageController:GetTall()/2) )
    pageController.Paint = function( self2, w, h )
        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ) )

        draw.SimpleText( "Страница " .. (self.currentPage or 0), "MontserratMedium20", w/2, h/2-1, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local nextPage = vgui.Create( "DButton", pageController )
    nextPage:Dock( RIGHT )
    nextPage:SetWide( pageController:GetTall() )
    nextPage:SetText( "" )
    local nextIconMat = Material( "materials/botched/icons/next_16.png" )
    nextPage.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( false, 50 )

        draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ), false, true, false, true )
        draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 3, self2.alpha ), false, true, false, true )

        BOTCHED.FUNC.DrawClickCircle( self2, w, h, BOTCHED.FUNC.GetTheme( 3, 150 ), 8 )

        surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 4 ) )
        surface.SetMaterial( nextIconMat )
        local iconSize = 16
        surface.DrawTexturedRect( (w/2)-(iconSize/2), (h/2)-(iconSize/2), iconSize, iconSize )
    end
    nextPage.DoClick = function()
        if( self.currentPage == 2 ) then return end
        self:OpenPage( 2 )
    end

    local previousPage = vgui.Create( "DButton", pageController )
    previousPage:Dock( LEFT )
    previousPage:SetWide( pageController:GetTall() )
    previousPage:SetText( "" )
    local previousIconMat = Material( "materials/botched/icons/previous_16.png" )
    previousPage.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( false, 50 )

        draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ), true, false, true, false )
        draw.RoundedBoxEx( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 3, self2.alpha ), true, false, true, false )

        BOTCHED.FUNC.DrawClickCircle( self2, w, h, BOTCHED.FUNC.GetTheme( 3, 150 ), 8 )

        surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 4 ) )
        surface.SetMaterial( previousIconMat )
        local iconSize = 16
        surface.DrawTexturedRect( (w/2)-(iconSize/2), (h/2)-(iconSize/2), iconSize, iconSize )
    end
    previousPage.DoClick = function()
        if( self.currentPage == 1 ) then return end
        self:OpenPage( 1 )
    end

    self.rowArea = vgui.Create( "DPanel", self.rightArea )
    self.rowArea:Dock( FILL )
    self.rowArea.Paint = function( self, w, h ) end

    timer.Simple( 0.2, function() 
        if( not IsValid( self ) ) then return end
        self:Refresh() 
    end )

    hook.Add( "Botched.Hooks.LoginRewardsUpdated", self, self.Refresh )
end

function PANEL:CreateSlotPanel( parent, i, name, model, amount, border, stars )
    local x, y = self.rightArea:LocalToScreen( 0, 0 )

    local slotPanel = vgui.Create( "botched_item_slot", parent )
    slotPanel:Dock( LEFT )
    slotPanel:SetSize( self.slotSize, self.slotSize )
    slotPanel:DockMargin( 0, 0, self.slotSpacing, 0 )
    slotPanel:DisableShadows( true )
    slotPanel:SetItemInfo( {
        Name = "День " .. i,
        Model = model or "",
        Stars = stars or 3,
        Border = border
    }, amount )
    slotPanel:SetShadowScissor( x, y, x+self.rightArea:GetWide(), y+self.rightArea:GetTall() )

    return slotPanel
end

function PANEL:GetRewardInfo( rewardCfg )
    if( rewardCfg.RewardType != "Items" and not BOTCHED.DEVCONFIG.RewardTypes[rewardCfg.RewardType] ) then return end

    if( rewardCfg.RewardType == "Items" and istable( rewardCfg.RewardValue ) ) then
        local configItem = BOTCHED.CONFIG.LOCKER.Items[rewardCfg.RewardValue[1]]
        if( not configItem ) then return end

        return configItem.Name, configItem.Model, rewardCfg.RewardValue[2], configItem.Border, configItem.Stars
    else
        local rewardTypeCfg = BOTCHED.DEVCONFIG.RewardTypes[rewardCfg.RewardType]
        return rewardTypeCfg.Name, rewardTypeCfg.Material, rewardCfg.RewardValue, rewardTypeCfg.Border
    end
end

local tickMat = Material( "materials/botched/icons/tick_24.png" )
function PANEL:Refresh()
    self.leftArea:Clear()

    local daysClaimed, claimTime = LocalPlayer():Botched():GetLoginRewardInfo()
    local canClaim = LocalPlayer():Botched():CanClaimLoginReward()
    local loginStreak = LocalPlayer():Botched():GetLoginRewardStreak()

    local currentDay = loginStreak+(canClaim and 1 or 0)
    local name, model, amount, border = self:GetRewardInfo( BOTCHED.CONFIG.REWARDS.LoginRewards[currentDay] )

    local currentDaySlot = vgui.Create( "botched_item_slot", self.leftArea )
    currentDaySlot:SetSize( self.slotSize, self.slotSize )
    currentDaySlot:SetPos( (self.leftArea:GetWide()/2)-(currentDaySlot:GetWide()/2), 75 )
    if( model ) then
        currentDaySlot:SetItemInfo( {
            Model = model,
            Stars = stars,
            Border = border
        }, amount, false, "login_rewards_current_day" )
    end
    currentDaySlot:DisableText( true )

    if( not canClaim ) then
        local claimedCover = vgui.Create( "DPanel", currentDaySlot )
        claimedCover:Dock( FILL )
        claimedCover.Paint = function( self, w, h )
            surface.SetMaterial( tickMat )
            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2 ) )
            local iconSize = 24
            surface.DrawTexturedRect( w-11-iconSize, 10, iconSize, iconSize )
        end
    end

    surface.SetFont( "MontserratBold30" )
    local textX, textY = surface.GetTextSize( "DAY " .. currentDay )

    local currentDayTitle = vgui.Create( "DPanel", self.leftArea )
    currentDayTitle:Dock( TOP )
    currentDayTitle:SetTall( textY+2 )
    currentDayTitle:DockMargin( 0, 75+currentDaySlot:GetTall()+15, 0, 0 )
    currentDayTitle.Paint = function( self2, w, h )
        draw.SimpleTextOutlined( "День " .. currentDay, "MontserratBold30", w/2, h/2, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, BOTCHED.FUNC.GetTheme( 2 ) )
    end

    if( not canClaim ) then
        local currentDayNextReward = vgui.Create( "DPanel", self.leftArea )
        currentDayNextReward:Dock( TOP )
        currentDayNextReward:SetTall( 40 )
        currentDayNextReward:DockMargin( 0, 10, 0, 0 )
        currentDayNextReward.Paint = function( self2, w, h )
            draw.SimpleTextOutlined( (amount > 1 and ("x" .. string.Comma( amount ) .. " ") or "") .. name, "MontserratMedium20", w/2, h/2+1, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, BOTCHED.FUNC.GetTheme( 2 ) )
            draw.SimpleTextOutlined( "Получено: " .. os.date( "%H:%M:%S - %d/%m/%Y" , claimTime ), "MontserratMedium20", w/2, h/2-1, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, 0, 1, BOTCHED.FUNC.GetTheme( 2 ) )
        end
    end

    local claimButton = vgui.Create( "DButton", self.leftArea )
    claimButton:Dock( BOTTOM )
    claimButton:SetTall( 50 )
    claimButton:DockMargin( 25, 0, 25, 25 )
    claimButton:SetText( "" )
    claimButton:SetEnabled( canClaim )
    claimButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( false, 255 )

        draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2 ) )

        BOTCHED.FUNC.DrawClickCircle( self2, w, h, BOTCHED.FUNC.GetTheme( 2 ), 8 )
        BOTCHED.FUNC.DrawPartialRoundedBox( 8, 0, h-5, w, 5, BOTCHED.FUNC.GetTheme( 3, self2.alpha ), false, 16, false, h-5-11 )

        draw.SimpleText( "Получить", "MontserratBold25", w/2, h/2, BOTCHED.FUNC.GetTheme( 4, 75+(180*(self2.alpha/255)) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    claimButton.DoClick = function()
        net.Start( "Botched.RequestClaimLoginReward" )
        net.SendToServer()
    end

    if( not canClaim ) then
        local errorPanel = vgui.Create( "DPanel", self.leftArea )
        errorPanel:Dock( BOTTOM )
        errorPanel:DockMargin( 25, 0, 25, 10 )
        errorPanel:SetTall( 30 )
        errorPanel.Paint = function( self2, w, h )
            draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.DEVCONFIG.Colors.DarkRed )

            draw.SimpleText( "Награда уже получена!", "MontserratBold20", w/2, h/2-1, BOTCHED.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end

    local currentDayNextReward = vgui.Create( "DPanel", self.leftArea )
    currentDayNextReward:Dock( BOTTOM )
    currentDayNextReward:SetTall( 40 )
    currentDayNextReward:DockMargin( 0, 0, 0, 25 )
    currentDayNextReward.Paint = function( self2, w, h )
        draw.SimpleTextOutlined( "Следующая выдача: " .. BOTCHED.FUNC.FormatLetterTime( os.difftime( BOTCHED.FUNC.GetNextLoginRewardTime(), BOTCHED.FUNC.UTCTime() ) ), "MontserratMedium20", w/2, h/2+1, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, BOTCHED.FUNC.GetTheme( 2 ) )
        draw.SimpleTextOutlined( "Награды каждый день в 16:00 МСК", "MontserratMedium20", w/2, h/2-1, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, 0, 1, BOTCHED.FUNC.GetTheme( 2 ) )
    end

    self:OpenPage( currentDay >= 16 and 2 or 1 )
end

function PANEL:OpenPage( pageNum )
    local moveWide = self.rightArea:GetWide()+self.outerBorder

    local oldRowBack = self.previousRowBack
    if( IsValid( oldRowBack ) ) then
        if( (self.currentPage or 1) != pageNum ) then
            oldRowBack:MoveTo( pageNum == 1 and moveWide or -moveWide, self.outerBorder, 0.4, 0, -1, function()
                oldRowBack:Remove()
            end )
        else
            oldRowBack:Remove()
        end
    end

    local rowBack = vgui.Create( "DPanel", self.rowArea )
    rowBack:SetSize( self.rightArea:GetWide(), self.mainPanel.targetH )
    rowBack.Paint = function() end
    self.previousRowBack = rowBack

    if( not self.currentPage or self.currentPage == pageNum ) then
        rowBack:SetPos( self.outerBorder, self.outerBorder )
    else
        rowBack:SetPos( pageNum == 1 and -moveWide or moveWide, self.outerBorder )
        rowBack:MoveTo( self.outerBorder, self.outerBorder, 0.4 )
    end

    self.currentPage = pageNum

    local loginStreak = LocalPlayer():Botched():GetLoginRewardStreak()

    local rewardRows = {}
    for i = 1, 3 do
        local rowPanel = vgui.Create( "DPanel", rowBack )
        rowPanel:Dock( TOP )
        rowPanel:SetTall( self.slotSize )
        rowPanel:DockMargin( 0, 0, 0, self.rowSpacing )
        rowPanel:DockPadding( i == 2 and self.rowSpacing or 0, 0, 0, 0 )
        rowPanel.Paint = function( self, w, h ) end

        rewardRows[i] = rowPanel
    end

    local currentRow = 1
    for i = 1, 15 do
        local rowPanel = rewardRows[currentRow]
        rowPanel.Entries = (rowPanel.Entries or 0)+1

        if( rowPanel.Entries >= 5 ) then
            currentRow = currentRow+1
        end

        local rewardKey = ((pageNum-1)*15)+i
        if( not BOTCHED.CONFIG.REWARDS.LoginRewards[rewardKey] ) then break end
        
        local slotPanel = self:CreateSlotPanel( rowPanel, rewardKey, self:GetRewardInfo( BOTCHED.CONFIG.REWARDS.LoginRewards[rewardKey] ) )
        if( loginStreak >= rewardKey ) then
            local claimedCover = vgui.Create( "DPanel", slotPanel )
            claimedCover:Dock( FILL )
            claimedCover.Paint = function( self, w, h )
                surface.SetMaterial( tickMat )
                surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2 ) )
                local iconSize = 24
                surface.DrawTexturedRect( w-11-iconSize, 10, iconSize, iconSize )
            end
        end
    end
end

function PANEL:GetShadowBounds()
    local x, y = self.mainPanel:LocalToScreen( 0, 0 )
    return 0, y-10, ScrW(), y+self.mainPanel:GetTall()+20
end

vgui.Register( "botched_popup_loginrewards", PANEL, "botched_popup_base" )