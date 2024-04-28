--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self.scrollBar = vgui.Create( "Panel", self )
    self.scrollBar:SetTall( 5 )
    self.scrollBar.Paint = function( self2, w, h )
        surface.SetDrawColor( self.barBackColor or PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    self.scrollBar.grip = vgui.Create( "DButton", self.scrollBar )
    self.scrollBar.grip:SetPos( 0, 0 )
    self.scrollBar.grip:SetSize( 0, self.scrollBar:GetTall() )
    self.scrollBar.grip:SetText( "" )
    self.scrollBar.grip.Paint = function( self2, w, h )
        surface.SetDrawColor( self.barColor or PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, 0, w, h )
    end
    self.scrollBar.grip.SetScrollX = function( self2, x )
        self2:SetX( math.Clamp( x, 0, self:GetWide()-self2:GetWide() ) )
    end
    self.scrollBar.grip.OnMousePressed = function( self2 )
        self2.mouseStartX = gui.MouseX()
        self2.startX = self2:GetX()
        self2.isDragging = true
    end
    self.scrollBar.grip.OnMouseReleased = function( self2 )
        self2.isDragging = false
        self2.mouseStartX = nil
    end
    self.scrollBar.grip.Think = function( self2 )
        if( not self2.isDragging ) then return end

        if( not input.IsMouseDown( MOUSE_LEFT ) ) then
            self2.isDragging = false
            self2.mouseStartX = nil
            return
        end

        self:SetScroll( (self2.startX+gui.MouseX()-self2.mouseStartX)/(self:GetWide()-self2:GetWide()) )
    end

    self.pnlCanvas = vgui.Create( "Panel", self )
    self.pnlCanvas:SetPos( 0, 0 )
    self.pnlCanvas:SetSize( 0, self:GetTall() )
    self.pnlCanvas:SetZPos( -100 )
end

function PANEL:OnMouseWheeled( delta )
    self:SetScrollX( self:GetScrollX()+(50*delta) )
end

function PANEL:SetScrollX( x )
    local maxX = self:GetWide()-self.pnlCanvas:GetWide()
    local newX = math.Clamp( x, maxX, 0 )
    self.pnlCanvas:SetX( newX )

    self.scrollBar.grip:SetScrollX( (self:GetWide()-self.scrollBar.grip:GetWide())*(math.abs( newX )/math.abs( maxX )) )
end

function PANEL:GetScrollX()
    return self.pnlCanvas:GetX()
end

function PANEL:SetScroll( percent )
    self.scrollPercent = math.Clamp( percent, 0, 1 )

    local maxX = self:GetWide()-self.pnlCanvas:GetWide()
    local newX = math.Clamp( maxX*self.scrollPercent, maxX, 0 )
    self.pnlCanvas:SetX( newX )

    self.scrollBar.grip:SetScrollX( percent*(self:GetWide()-self.scrollBar.grip:GetWide()) )
end

function PANEL:GetScroll()
    return self.scrollPercent or 0
end

function PANEL:PerformLayout( w, h )
    self.pnlCanvas:SizeToChildren( true )
    self.pnlCanvas:SetSize( self.pnlCanvas:GetWide(), h )

    if( not IsValid( self.scrollBar ) ) then return end

    self.scrollBar:SetWide( w )
    self.scrollBar:SetPos( 0, h-self.scrollBar:GetTall() )

    self:CheckShouldEnable()
end

function PANEL:OnChildAdded( child )
    if( not self.pnlCanvas ) then return end

    child:SetParent( self.pnlCanvas )
    self.pnlCanvas:SizeToChildren( true )

    self:CheckShouldEnable()
end

function PANEL:CheckShouldEnable()
    if( not IsValid( self.scrollBar.grip ) ) then return end

    local w = self:GetWide()
    if( self.pnlCanvas:GetWide() > w ) then
        self.scrollBar.grip:SetWide( w/3 )
    else
        self.scrollBar.grip:SetWide( 0 )
    end
end

function PANEL:Clear()
    self.pnlCanvas:Clear()
end

function PANEL:Think()
    if( not input.IsMouseDown( MOUSE_LEFT ) ) then
        if( not self.isDragging ) then return end

        self.isDragging = false
        return
    end

    local startX, startY = self:LocalToScreen( 0, 0 )
    local endX, endY = startX+self:GetWide(), startY+self:GetTall()

    local mouseX, mouseY = gui.MouseX(), gui.MouseY()
    local withinBounds = mouseX >= startX and mouseX <= endX and mouseY >= startY and mouseY <= endY

    if( not withinBounds ) then
        self.isDragging = false
        return
    end

    if( not self.isDragging ) then
        self.isDragging = true
        self.dragMouseStartX = mouseX
        self.dragPosStartX = self:GetScrollX()
    end

    self:SetScrollX( self.dragPosStartX+mouseX-self.dragMouseStartX )
end

function PANEL:SetBarColor( color )
    self.barColor = color
end

function PANEL:SetBarBackColor( color )
    self.barBackColor = color
end

vgui.Register( "pz_horizontal_scrollpanel", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
