local PANEL = {}

function PANEL:Init()
    self:SetHeader( "RECEIVED REFERRALS" )
    self:SetPopupWide( ScrW()*0.15 )
    self.header:SetTall( 0 )
    self.closeButton:Remove()

    local margin5 = BOTCHED.FUNC.ScreenScale( 5 )
    local margin10 = BOTCHED.FUNC.ScreenScale( 10 )
    local margin25 = BOTCHED.FUNC.ScreenScale( 25 )

    local receivedReferrals = BOTCHED.LOCALPLYMETA.ReceivedReferrals or {}
    local alreadyReferred = false
    for k, v in pairs( receivedReferrals ) do
        if( v[2] == true ) then
            alreadyReferred = true
            break
        end
    end

    local subHeaderText = not alreadyReferred and "Нажмите на игрока для подтвержения" or "На вас уже задействовали реферал"

    local headerPanel = vgui.Create( "DPanel", self )
    headerPanel:Dock( TOP )
    headerPanel:DockMargin( 0, margin25, 0, margin25 )
    headerPanel:SetTall( BOTCHED.FUNC.ScreenScale( 45 ) )
    headerPanel.Paint = function( self2, w, h ) 
        draw.SimpleText( "Полученные рефералы", "MontserratBold30", w/2, 0, BOTCHED.FUNC.GetTheme( 3 ), TEXT_ALIGN_CENTER, 0 )
        draw.SimpleText( subHeaderText, "MontserratMedium20", w/2, h, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
    end

    local bottomButton = vgui.Create( "DButton", self )
    bottomButton:Dock( BOTTOM )
    bottomButton:DockMargin( margin25, margin25, margin25, margin25 )
    bottomButton:SetTall( BOTCHED.FUNC.ScreenScale( 50 ) )
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

    
    surface.SetFont( "MontserratBold17" )
    local titleY = select( 2, surface.GetTextSize( "ONLINE" ) )

    surface.SetFont( "MontserratBold20" )
    local subTitleY = select( 2, surface.GetTextSize( "BRICKWALL" ) )

    local contentH = titleY+subTitleY-margin5
    local entryH = BOTCHED.FUNC.ScreenScale( 50 )

    for k, v in pairs( receivedReferrals ) do
        local playerName = "BRICKWALL"
        steamworks.RequestPlayerInfo( v[1], function( steamName )
            playerName = string.upper( steamName )
        end )

        local timeText = BOTCHED.FUNC.FormatLetterTime( os.difftime( BOTCHED.FUNC.UTCTime(), v[3] ) )
        local statusText = IsValid( player.GetBySteamID64( v[1] ) ) and "ONLINE" or "OFFLINE"

        local playerEntry = vgui.Create( "DPanel", self )
        playerEntry:Dock( TOP )
        playerEntry:SetTall( entryH )
        playerEntry:DockMargin( margin25, 0, margin25, margin10 )
        playerEntry.Paint = function( self2, w, h )
            if( not IsValid( self2.buttonCover ) ) then return end

            self2.buttonCover:CreateFadeAlpha( 0.2, 100 )

            draw.RoundedBox( 8, 0, 0, w, h, BOTCHED.FUNC.GetTheme( 2, 100+self2.buttonCover.alpha ) )
            BOTCHED.FUNC.DrawClickCircle( self2.buttonCover, w, h, BOTCHED.FUNC.GetTheme( 2, 100 ), 8 )
    
            draw.SimpleText( statusText, "MontserratBold17", h+margin5, (h/2)-(contentH/2), BOTCHED.FUNC.GetTheme( 3 ) )
            draw.SimpleText( playerName, "MontserratBold20", h+margin5, (h/2)+(contentH/2), BOTCHED.FUNC.GetTheme( 4, 75 ), 0, TEXT_ALIGN_BOTTOM )

            draw.SimpleText( timeText, "MontserratBold20", w-margin10, h/2, BOTCHED.FUNC.GetTheme( 4, 75 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
        end

        local avatar = vgui.Create( "botched_avatar", playerEntry )
        avatar:SetPos( margin10, margin10 )
        avatar:SetSize( playerEntry:GetTall()-(2*margin10), playerEntry:GetTall()-(2*margin10) )
        avatar:SetCircleAvatar( true )
        avatar:SetSteamID( v[1] )

        local buttonCover = vgui.Create( "DButton", playerEntry )
        buttonCover:Dock( FILL )
        buttonCover:SetText( "" )
        buttonCover.Paint = function( self2, w, h ) end
        buttonCover.DoClick = function()
            if( alreadyReferred ) then 
                BOTCHED.FUNC.CreateNotification( "REFERRAL ERROR", "You have already been referred!", "error" )
                return 
            end

            BOTCHED.FUNC.DermaQuery( "Вы уверены в своём действии?", "Рефералы", "Подтвердить", function()
                net.Start( "Botched.RequestAcceptReferral" )
                    net.WriteUInt( k, 16 )
                net.SendToServer()

                self:Close()
            end, "Отменить" )
        end

        playerEntry.buttonCover = buttonCover
    end

    self:SetExtraHeight( math.max( ScrH()*0.3, margin25+headerPanel:GetTall()+margin25+(table.Count( receivedReferrals )*(entryH+margin10))-margin10+margin25+bottomButton:GetTall()+margin25 ) )
end

vgui.Register( "botched_popup_receivedreferrals", PANEL, "botched_popup_base" )