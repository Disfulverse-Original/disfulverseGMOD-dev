--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    PROJECT0.TEMP.CustomiserItemID = (PROJECT0.TEMP.CustomiserItemID or 0)+1
    self.shadowUniqueID = "pz_customiser_cosmeticitem_" .. PROJECT0.TEMP.CustomiserItemID

    self.gradientAnim = vgui.Create( "pz_gradientanim", self )
    self.gradientAnim:SetSize( self:GetSize() )
    self.gradientAnim:SetAnimSize( self:GetWide()*6 )
    self.gradientAnim:SetPaintedManually( true )

    self.coverButton = vgui.Create( "Button", self )
    self.coverButton:Dock( FILL )
    self.coverButton:SetZPos( 1000 )
    self.coverButton:SetText( "" )
    self.coverButton.Paint = function() end
    self.coverButton.DoClick = function()
        if( not self.DoClick ) then return end
        self:DoClick()
        self.lastClicked = CurTime()
    end
    self.coverButton.OnCursorEntered = function( self2 )
        self2.cursorEnteredTime = CurTime()
    end
    self.coverButton.OnCursorExited = function()
        self:DeletePopup()
    end
    self.coverButton.Think = function( self2 )
        if( not self2:IsHovered() or CurTime() < (self2.cursorEnteredTime or 0)+0.2 or IsValid( self.popup ) ) then return end
        self:CreatePopup()
    end

    self.childrenToDraw = {}
end

function PANEL:OnChildAdded( pnl )
    if( not self.childrenToDraw ) then return end

    pnl:SetPaintedManually( true )
    table.insert( self.childrenToDraw, pnl )
end

function PANEL:OnSizeChanged( w, h )
    self.gradientAnim:SetSize( w, h )
    self.gradientAnim:SetAnimSize( w*6 )
end

function PANEL:SetRarity( rarity )
    self.rarityConfig = PROJECT0.CONFIG.GENERAL.Rarities[rarity]
    if( not self.rarityConfig ) then return end
    
    self.gradientAnim:SetColors( unpack( self.rarityConfig.Colors ) )
    self.gradientAnim:StartAnim()
end

function PANEL:OnRemove()
    PROJECT0.FUNC.DeleteShadow( self.shadowUniqueID )
    PROJECT0.FUNC.DeleteShadow( self.shadowUniqueID .. "_border" )
end

function PANEL:SetActive( isActive, instant )
    self.isActive = isActive

    if( instant ) then
        self.borderPercent = 100
    end
end

function PANEL:SetPopup( type, title, info )
    local cosmeticTypes = {
        {
            Name = "CHARM",
            Icon = Material( "project0/icons/charm.png", "noclamp smooth" )
        },
        {
            Name = "STICKER",
            Icon = Material( "project0/icons/sticker.png", "noclamp smooth" )
        },
        {
            Name = "SKIN",
            Icon = Material( "project0/icons/paint_64.png", "noclamp smooth" )
        }
    }

    self.popupData = {
        Title = string.upper( title ),
        Icon = cosmeticTypes[type].Icon,
        Type = cosmeticTypes[type].Name,
        Info = {
            { "Rarity", Material( "project0/icons/rarity.png", "noclamp smooth" ), self.rarityConfig.Title, self.rarityConfig.Colors }
        }
    }

    for k, v in ipairs( info ) do
        table.insert( self.popupData.Info, v )
    end
end

function PANEL:CreatePopup()
    if( not self.popupData or IsValid( self.popup ) ) then return end

    local x, y = self:LocalToScreen( self:GetWide()+PROJECT0.UI.Margin10, self:GetTall()/2 )
    local padding = PROJECT0.UI.Margin10
    local popupData = self.popupData

    local borderL, borderR = PROJECT0.FUNC.ScreenScale( 20 ), 2
    local iconSize = PROJECT0.FUNC.ScreenScale( 34 )

    self.popup = vgui.Create( "DPanel" )
    self.popup:SetDrawOnTop( true )
    self.popup:DockPadding( padding, padding+iconSize, padding, padding )
    self.popup.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )

        PROJECT0.FUNC.BeginShadow( self.shadowUniqueID .. "_ttt" )
        PROJECT0.FUNC.SetShadowSize( self.shadowUniqueID.. "_ttt", w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( self.shadowUniqueID.. "_ttt", x, y, 1, 1, 1, 255, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, 0, borderL, borderR )
        surface.DrawRect( 0, 0, borderR, borderL )
        surface.DrawRect( w-borderL, h-borderR, borderL, borderR )
        surface.DrawRect( w-borderR, h-borderL, borderR, borderL )

        surface.SetMaterial( popupData.Icon )
        surface.DrawTexturedRect( padding, padding, iconSize, iconSize )

        local textX = padding+iconSize+PROJECT0.UI.Margin5
        draw.SimpleText( popupData.Title, "MontserratBold22", textX, padding, PROJECT0.FUNC.GetTheme( 3 ), 0, 0 )
        draw.SimpleText( popupData.Type, "MontserratBold17", textX, padding+iconSize, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
    end
    self.popup.Think = function( self2 )
        if( IsValid( self ) ) then return end
        self2:Remove()
    end

    local maxContentW, contentH = PROJECT0.FUNC.ScreenScale( 150 ), iconSize

    surface.SetFont( "MontserratBold22" )
    maxContentW = math.max( maxContentW, iconSize+padding+surface.GetTextSize( popupData.Title ) )

    for k, v in ipairs( popupData.Info ) do
        local iconSize = PROJECT0.FUNC.ScreenScale( 24 )
        local title = string.upper( v[1] )

        local infoRow = vgui.Create( "DPanel", self.popup )
        infoRow:Dock( TOP )
        infoRow:SetTall( iconSize )
        infoRow:DockMargin( 0, PROJECT0.UI.Margin10, 0, 0 )
        infoRow.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 75 ) )
            surface.SetMaterial( v[2] )
            surface.DrawTexturedRect( 0, 0, h, h )

            draw.SimpleText( v[3], "MontserratBold20", h+PROJECT0.UI.Margin5, -4, PROJECT0.FUNC.GetSolidColor( v[4] ), 0, 0 )
            draw.SimpleText( title, "MontserratBold17", h+PROJECT0.UI.Margin5, h+3, PROJECT0.FUNC.GetTheme( 3, 75 ), 0, TEXT_ALIGN_BOTTOM )
        end

        contentH = contentH+PROJECT0.UI.Margin10+infoRow:GetTall()
    end

    self.popup:SetSize( maxContentW+(2*padding), contentH+(2*padding) )
    self.popup:SetPos( x, y-self.popup:GetTall()/2 )
end

function PANEL:DeletePopup()
    if( not IsValid( self.popup ) ) then return end
    self.popup:Remove()
end

function PANEL:SetShadowBounds( startX, startY, endX, endY )
    self.startX, self.startY, self.endX, self.endY = startX, startY, endX, endY
end

function PANEL:Paint( w, h )
    self.coverButton:CreateFadeAlpha( 0.1, 100 )

    local x, y = self:LocalToScreen( 0, 0 )

    PROJECT0.FUNC.BeginShadow( self.shadowUniqueID, self.startX, self.startY, self.endX, self.endY )
    PROJECT0.FUNC.SetShadowSize( self.shadowUniqueID, w, h )
    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
    surface.DrawRect( x, y, w, h )
    PROJECT0.FUNC.EndShadow( self.shadowUniqueID, x, y, 1, 1, 1, 255, 0, 0, false )

    for k, v in pairs( self.childrenToDraw ) do
        v:PaintManual()
    end

    local clickPercent = math.Clamp( (CurTime()-(self.lastClicked or 0))/0.3, 0, 1 )
    if( self.lastClicked and self.lastClicked+0.3 > CurTime() ) then
        local size = (w+PROJECT0.FUNC.ScreenScale( 100 ))*math.Clamp( clickPercent/0.5, 0, 1 )
        local offset = PROJECT0.FUNC.ScreenScale( 200 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, 150-(math.Clamp( (clickPercent-0.5)*2, 0, 1 )*150) ) )
        draw.NoTexture()
        surface.DrawPoly( {
            { x = w-size+offset, y = -offset },
            { x = w+offset, y = size-offset },
            { x = size-offset, y = h+offset },
            { x = -offset, y = h-size+offset }
        } )
    end

    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, self.coverButton.alpha ) )
    surface.DrawRect( 0, 0, w, h )

    -- Border and active effects
    if( self.isActive ) then
        self.borderPercent = math.Clamp( (self.borderPercent or 0)+3, 0, 100 )
    else
        self.borderPercent = math.Clamp( (self.borderPercent or 0)-3, 0, 100 )
    end

    local borderL, borderR = w*0.2, 2

    local borderPercent = self.borderPercent/100
    local borderW = borderL+((w-borderL)*borderPercent)
    local borderH = borderL+((h-borderL)*borderPercent)

    if( not IsValid( self.gradientAnim ) ) then return end

    render.ClearStencil()
    render.SetStencilEnable( true )

    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )

    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )

    draw.NoTexture()
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawRect( 0, 0, borderW, borderR )
    surface.DrawRect( 0, 0, borderR, borderH )
    surface.DrawRect( w-borderW, h-borderR, borderW, borderR )
    surface.DrawRect( w-borderR, h-borderH, borderR, borderH )

    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilReferenceValue( 1 )

    self.gradientAnim:PaintManual()

    render.SetStencilEnable( false )
    render.ClearStencil()
end

vgui.Register( "pz_cosmetic_item", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
