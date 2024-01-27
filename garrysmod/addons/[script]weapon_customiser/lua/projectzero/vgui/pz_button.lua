--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    self:SetText( "" )
end

function PANEL:SetButtonText( text )
    self.buttonText = text
end

function PANEL:OnMousePressed()
    self.lastClicked = CurTime()
end

function PANEL:Paint( w, h )
    -- Background
    PROJECT0.FUNC.BeginShadow( "menu_btn_" .. self.buttonText )
    local x, y = self:LocalToScreen( 0, 0 )
    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
    surface.DrawRect( x, y, w, h )
    PROJECT0.FUNC.EndShadow( "menu_btn_" .. self.buttonText, x, y, 1, 1, 1, 255, 0, 0, false )

    -- Click effects
    local clickPercent = math.Clamp( (CurTime()-(self.lastClicked or 0))/0.2, 0, 1 )
    if( self.lastClicked and self.lastClicked+0.2 > CurTime() ) then
        local offset = 15
        local startX = math.Clamp( (clickPercent-0.5)*2, 0, 1 )*(w+offset)

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        draw.NoTexture()
        surface.DrawPoly( {
            { x = startX, y = 0 },
            { x = ((clickPercent*2)*w)+offset, y = 0 },
            { x = (clickPercent*2)*w, y = h },
            { x = startX-offset, y = h }
        } )
    end

    -- Border and hover effects
    if( self:IsHovered() ) then
        self.hoverPercent = math.Clamp( (self.hoverPercent or 0)+3, 0, 100 )
    else
        self.hoverPercent = math.Clamp( (self.hoverPercent or 0)-3, 0, 100 )
    end

    local borderR = 2
    local borderL = PROJECT0.FUNC.ScreenScale( 20 )

    local hoverPercent = self.hoverPercent/100
    local borderW = borderL+((w-borderL)*hoverPercent)
    local borderH = borderL+((h-borderL)*hoverPercent)

    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, hoverPercent*100 ) )
    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
    surface.DrawRect( 0, 0, borderW, borderR )
    surface.DrawRect( 0, 0, borderR, borderH )
    surface.DrawRect( w-borderW, h-borderR, borderW, borderR )
    surface.DrawRect( w-borderR, h-borderH, borderR, borderH )

    -- Text
    draw.SimpleText( self.buttonText, "MontserratBold19", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 200+(55*hoverPercent) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

vgui.Register( "pz_button", PANEL, "DButton" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
