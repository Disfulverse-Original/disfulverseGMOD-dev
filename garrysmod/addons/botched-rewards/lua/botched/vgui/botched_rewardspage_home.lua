local PANEL = {}

function PANEL:Init()
    hook.Add( "Botched.Hooks.ConfigUpdated", self, function()
        self:FillPanel()
    end )
end

function PANEL:FillPanel()
    self:Clear()
    
    local margin5 = BOTCHED.FUNC.ScreenScale( 5 )
    local margin10 = BOTCHED.FUNC.ScreenScale( 10 )
    local margin25 = BOTCHED.FUNC.ScreenScale( 25 )
    local margin50 = BOTCHED.FUNC.ScreenScale( 50 )

    local iconArea = BOTCHED.FUNC.ScreenScale( 50 )
    local iconSpacing = BOTCHED.FUNC.ScreenScale( 10 )
    local iconSize = BOTCHED.FUNC.ScreenScale( 32 )
    local borderR = 3
    local displayWide = (self:GetWide()-(2*margin50)-(2*margin25))/3
    local notifIcon = Material( "botched/icons/reward_16.png" )

    self:DockPadding( margin50, margin50, margin50, margin50 )

    local displays = {}
    local function CreateDisplay( title, iconMat, unClaimedFunc, clickFunc )
        title = string.upper( title )
        local currentDisplay = #displays+1

        local displayPanel = vgui.Create( "DPanel", self )
        displayPanel:Dock( LEFT )
        displayPanel:DockMargin( 0, 0, margin25, 0 )
        displayPanel:SetSize( displayWide, self:GetTall()-(2*margin50) )
        displayPanel.Paint = function( self2, w, h )
            local uniqueID = "rewardshome_" .. currentDisplay
            BOTCHED.FUNC.BeginShadow( uniqueID )
            local x, y = self2:LocalToScreen( 0, 0 )
            draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 2 ) )
            BOTCHED.FUNC.EndShadow( uniqueID, x, y, 1, 1, 1, 255, 0, 0, false )

            draw.RoundedBox( 8, borderR, borderR, w-(2*borderR), h-(2*borderR), BOTCHED.FUNC.GetTheme( 1 ) )

            if( IsValid( self2.icons ) ) then 
                BOTCHED.FUNC.DrawRoundedMask( 8, 0, 0, w, h, function()
                    self2.icons:PaintManual()
                end )
            end
    
            if( IsValid( self2.button ) ) then 
                self2.button:CreateFadeAlpha( false, 50 )
                draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, self2.button.alpha ) )
        
                BOTCHED.FUNC.DrawClickCircle( self2.button, w, h, BOTCHED.FUNC.GetTheme( 2 ), 8 )
            end
    
            --draw.SimpleText( "Новое", "MontserratBold20", margin25, margin25, BOTCHED.FUNC.GetTheme( 3 ), 0, 0 )
            draw.SimpleText( title, "MontserratBold30",BOTCHED.FUNC.ScreenScale( 65 ),margin50, BOTCHED.FUNC.GetTheme( 4, 75 ), 0, 0 )

            -- Unclaimed Notification
            local unClaimedAmount = unClaimedFunc()
            if( unClaimedAmount <= 0 ) then return end

            local notifH = BOTCHED.FUNC.ScreenScale( 36 )
            local iconSize = BOTCHED.FUNC.ScreenScale( 16 )

            local text = "Доступно наград: ".. unClaimedAmount
            surface.SetFont( "MontserratBold20" )
            local textX = surface.GetTextSize( text )

            local notifW = notifH+textX+(2*margin10)
            local notifX, notifY = w-margin25-notifW, h-margin25-notifH

            BOTCHED.FUNC.BeginShadow( uniqueID .. "_notif" )
            local x, y = self2:LocalToScreen( notifX, notifY )
            draw.RoundedBox( 8, x, y, notifW, notifH, BOTCHED.FUNC.GetTheme( 1 ) )
            BOTCHED.FUNC.EndShadow( uniqueID .. "_notif", x, y, 1, 1, 1, 100, 0, 0, false )

            draw.RoundedBoxEx( 8, notifX, notifY, notifH, notifH, BOTCHED.FUNC.GetTheme( 2, 100 ), true, false, true, false )

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 4, 75 ) )
            surface.SetMaterial( notifIcon )
            surface.DrawTexturedRect( notifX+(notifH/2)-(iconSize/2), notifY+(notifH/2)-(iconSize/2), iconSize, iconSize )

            draw.SimpleText( text, "MontserratBold20", notifX+notifH+(notifW-notifH)/2, notifY+(notifH/2)-1, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        local iconsPanel = vgui.Create( "DPanel", displayPanel )
        iconsPanel:SetPos( 0, 0 )
        iconsPanel:SetSize( displayPanel:GetTall()*2, displayPanel:GetTall()*2 )
        iconsPanel:SetPaintedManually( true )
        iconsPanel.Paint = function( self2, w, h )
            if( (self2.activeW or 0) != w or (self2.activeH or 0) != h ) then
                self2.activeW, self2.activeH = w, h
                self2.iconPosData = nil
            end

            if( not self2.iconPosData ) then
                self2.iconPosData = {}

                local currentH = iconSpacing
                while( currentH < h ) do
                    local currentW = iconSpacing
                    while( currentW < w ) do
                        table.insert( self2.iconPosData, { currentW+(iconArea/2)-(iconSize/2), currentH+(iconArea/2)-(iconSize/2) } )
                        
                        currentW = currentW+iconArea+iconSpacing
                    end

                    currentH = currentH+iconArea+iconSpacing
                end
            end

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 2 ) )
            surface.SetMaterial( iconMat )

            for k, v in pairs( self2.iconPosData ) do
                surface.DrawTexturedRect( v[1], v[2], iconSize, iconSize )
            end
        end
        iconsPanel.StartAnimation = function( self2 )
            self2:MoveTo( -(self2:GetWide()/2), -(self2:GetTall()/2), 15, 0, 1, function()
                self2:MoveTo( 0, 0, 15, 0, 1, function()
                    self2:StartAnimation()
                end )
            end )
        end
        iconsPanel:StartAnimation()
        displayPanel.icons = iconsPanel

        displayPanel.button = vgui.Create( "DButton", displayPanel )
        displayPanel.button:Dock( FILL )
        displayPanel.button:SetText( "" )
        displayPanel.button.Paint = function( self2, w, h ) end
        displayPanel.button.DoClick = clickFunc

        table.insert( displays, displayPanel )

        return displayPanel
    end

    -- Login Rewards
    CreateDisplay( "Награды за вход", Material( "botched/icons/calendar.png" ), function() 
        return LocalPlayer():Botched():CanClaimLoginReward() and 1 or 0
    end, function()
        BOTCHED.FUNC.OpenLoginRewardsMenu()
    end )

    -- Time Rewards
    local timeDisplay = CreateDisplay( "Награды за время", Material( "botched/icons/timer_32.png" ), function() 
        local claimedRewards = LocalPlayer():Botched():GetClaimedTimeRewards()
        local unclaimedCount = 0
        for k, v in pairs( BOTCHED.CONFIG.REWARDS.TimeRewards ) do
            if( LocalPlayer():Botched():GetTimePlayed() < v.Time or claimedRewards[k] ) then continue end
            unclaimedCount = unclaimedCount+1
        end
        
        return unclaimedCount
    end, function()
        BOTCHED.FUNC.OpenTimeRewardsMenu()
    end )

    local timeRewardPanel = vgui.Create( "DPanel", timeDisplay )
    timeRewardPanel:SetSize( BOTCHED.FUNC.ScreenScale( 270 ), BOTCHED.FUNC.ScreenScale( 65 ) )
    timeRewardPanel:SetPos( (timeDisplay:GetWide()/2)-(timeRewardPanel:GetWide()/2), (timeDisplay:GetTall()/2)-(timeRewardPanel:GetTall()/2) )
    timeRewardPanel.Paint = function( self2, w, h )
        BOTCHED.FUNC.BeginShadow( "home_screen_time" )
        local x, y = self2:LocalToScreen( 0, 0 )
        draw.RoundedBox( 8, x, y, w, h, BOTCHED.FUNC.GetTheme( 1 ) )
        BOTCHED.FUNC.EndShadow( "home_screen_time", x, y, 1, 1, 1, 255, 0, 0, false )

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

        local progressBarH = BOTCHED.FUNC.ScreenScale( 8 )
        BOTCHED.FUNC.DrawRoundedMask( 8, 0, h-(progressBarH*2), w, progressBarH*2, function()
            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 1 ) )
            surface.DrawRect( 0, h-progressBarH, w, progressBarH )

            surface.SetDrawColor( BOTCHED.FUNC.GetTheme( 3 ) )
            surface.DrawRect( 0, h-progressBarH, w*math.Clamp( plyTimePlayed/(nextTimeReward and nextTimeReward.Time or 1), 0, 1 ), progressBarH )
        end )
    end

    -- Referral Rewards
    CreateDisplay( "Реферальные награды", Material( "botched/icons/link_32.png" ), function() 
        return 0
    end, function() 
        BOTCHED.FUNC.OpenReferralRewardsMenu()
    end )
end

function PANEL:Paint( w, h )

end

vgui.Register( "botched_rewardspage_home", PANEL, "DPanel" )