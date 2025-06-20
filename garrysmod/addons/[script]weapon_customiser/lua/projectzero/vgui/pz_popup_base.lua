--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetSize( ScrW(), ScrH() )
    self:MakePopup()
    self:SetTitle( "" )
    self:SetDraggable( false )
    self:ShowCloseButton( false )
    self:SetAlpha( 0 )
    self:AlphaTo( 255, 0.2 )
    self:SetDrawHeader( true )

    self.backButton = vgui.Create( "DButton", self )
	self.backButton:Dock( FILL )
	self.backButton:SetText( "" )
	self.backButton:SetCursor( "arrow" )
	self.backButton.Paint = function() end
    self.backButton.DoClick = function()
        self:Close()
    end

    self.mainPanel = vgui.Create( "DPanel", self )
    self.mainPanel:SetSize( ScrW()*0.15, 0 )
    self.mainPanel:Center()
    self.mainPanel.Paint = function( self2, w, h )
        PROJECT0.FUNC.BeginShadow( "popup_" .. self.headerText )
        PROJECT0.FUNC.SetShadowSize( "popup_" .. self.headerText, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )	
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "popup_" .. self.headerText, x, y, 1, 1, 1, 255, 0, 0, false )
    end
    self.mainPanel.OnSizeChanged = function( self2 )
        self2:Center()
    end

    self.header = vgui.Create( "DPanel", self.mainPanel )
    self.header:Dock( TOP )
    self.header:SetTall( 55 )
    self.header.Paint = function( self2, w, h )
        if( not self.headerShouldDraw ) then return end
        draw.SimpleText( self.headerText or "HEADER", "MontserratBold30", w/2, h/2-1, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local size = 24
    self.closeButton = vgui.Create( "DButton", self.mainPanel )
	self.closeButton:SetSize( size, size )
	self.closeButton:SetPos( self.mainPanel:GetWide()-(self.header:GetTall()/2)-(size/2), (self.header:GetTall()/2)-(size/2) )
	self.closeButton:SetText( "" )
    local closeMat = Material( "materials/project0/icons/close.png" )
    local textColor = PROJECT0.FUNC.GetTheme( 4 )
	self.closeButton.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.2, 255 )

        surface.SetMaterial( closeMat )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 200 ) )
		surface.DrawTexturedRect( 0, 0, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, self2.alpha ) )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
    self.closeButton.DoClick = self.backButton.DoClick

    self.initFinished = true

    self.mainPanel.targetH = self.header:GetTall()
    self.mainPanel:SetTall( self.mainPanel.targetH )
end

function PANEL:Close()
    self.FullyOpened = false

    if( self.OnClose ) then self:OnClose() end

    self:AlphaTo( 0, 0.2 )
    self.mainPanel:SizeTo( self.mainPanel:GetWide(), 0, 0.2, 0, -1, function()
        self:Remove()
    end )
end

function PANEL:SetHeader( header )
    self.headerText = header
end

function PANEL:SetDrawHeader( shouldDraw )
    self.headerShouldDraw = shouldDraw
end

function PANEL:SetPopupWide( width )
    self.mainPanel:SetWide( width )
    self.closeButton:SetPos( self.mainPanel:GetWide()-(self.header:GetTall()/2)-(self.closeButton:GetWide()/2), (self.header:GetTall()/2)-(self.closeButton:GetTall()/2) )
end

function PANEL:GetPopupWide()
    return self.mainPanel:GetWide()
end

function PANEL:GetPopupTall()
    return self.mainPanel.targetH
end

function PANEL:SetExtraHeight( extraH )
    self.mainPanel.targetH = self.header:GetTall()+extraH
    self.mainPanel:SizeTo( self.mainPanel:GetWide(), self.mainPanel.targetH, 0.2, 0, -1, function()
        self.FullyOpened = true
        if( self.OnOpen ) then self:OnOpen() end
    end )
end

function PANEL:OnChildAdded( panel )
    if( not self.initFinished ) then return end

    panel:SetParent( self.mainPanel )
end

function PANEL:Paint( w, h )
    PROJECT0.FUNC.DrawBlur( self, 4, 4 )
end

vgui.Register( "pz_popup_base", PANEL, "DFrame" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
