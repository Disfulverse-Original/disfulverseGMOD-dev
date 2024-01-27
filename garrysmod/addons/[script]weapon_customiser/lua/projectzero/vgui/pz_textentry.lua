--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local PANEL = {}

function PANEL:Init()
	self:SetBackColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
	self:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2 ) )

	self.textEntry = vgui.Create( "DTextEntry", self )
	self.textEntry:Dock( FILL )
	self.textEntry:DockMargin( PROJECT0.UI.Margin15, 0, 0, 0 )
	self.textEntry:SetFont( "MontserratBold20" )
	self.textEntry:SetText( "" )
	self.textEntry:SetTextColor( Color( 255, 255, 255, 20 ) )
	self.textEntry:SetCursorColor( Color( 255, 255, 255 ) )
	self.textEntry.backTextColor = PROJECT0.FUNC.GetTheme( 3, 100 )
	self.textEntry.Paint = function( self2, w, h )
		if( self2:GetTextColor().a != 255 or self2:GetTextColor().a != 0 ) then
			self2:SetTextColor( Color( 255, 255, 255, 100+(self.alpha or 0) ) )
		end

		if( self2.GetPlaceholderText && self2.GetPlaceholderColor && self2:GetPlaceholderText() && self2:GetPlaceholderText():Trim() != "" && self2:GetPlaceholderColor() && ( !self2:GetText() || self2:GetText() == "" ) ) then
			local oldText = self2:GetText()
	
			local str = self2:GetPlaceholderText()
			if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
			str = language.GetPhrase( str )
	
			self2:SetText( str )
			self2:DrawTextEntryText( self2:GetPlaceholderColor(), self2:GetHighlightColor(), self2:GetCursorColor() )
			self2:SetText( oldText )
	
			return
		end
	
		self2:DrawTextEntryText( self2:GetTextColor(), self2:GetHighlightColor(), self2:GetCursorColor() )
	
		if( not self2:IsEditing() and self2:GetText() == "" ) then
			draw.SimpleText( self2.backText or "", self2:GetFont(), 0, h/2, self2.backTextColor, 0, TEXT_ALIGN_CENTER )
		end
	end
	self.textEntry.OnChange = function( self2 )
        if( self.OnChange ) then self:OnChange( self2:GetValue() ) end
    end
    self.textEntry.OnEnter = function()
        if( self.OnEnter ) then self:OnEnter() end
    end
    self.textEntry.OnGetFocus = function()
        if( self.OnGetFocus ) then self:OnGetFocus() end
    end
    self.textEntry.OnLoseFocus = function()
        if( self.OnLoseFocus ) then self:OnLoseFocus() end
    end
end

function PANEL:RequestFocus()
    return self.textEntry:RequestFocus()
end

function PANEL:IsEditing()
    return self.textEntry:IsEditing()
end

function PANEL:SetValue( val )
    self.textEntry:SetValue( val )
end

function PANEL:GetValue()
    return self.textEntry:GetValue()
end

function PANEL:SetBackText( backText )
    self.textEntry.backText = backText
end

function PANEL:SetBackColor( color )
    self.backColor = color
end

function PANEL:SetHighlightColor( color )
    self.highlightColor = color
end

function PANEL:SetFont( font )
    self.textEntry:SetFont( font )
end

function PANEL:SetEnabled( enabled )
    self.textEntry:SetEnabled( enabled )
end

function PANEL:DisableShadows( disable )
    self.disableShadows = disable
end

function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.2, 155, false, false, self.textEntry:IsEditing(), 155 )

	-- Background
	if( not self.disableShadows ) then
		PROJECT0.FUNC.BeginShadow( "menu_text_entry_" .. tostring( self ) )
		local x, y = self:LocalToScreen( 0, 0 )
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
		surface.DrawRect( x, y, w, h )
		PROJECT0.FUNC.EndShadow( "menu_text_entry_" .. tostring( self ), x, y, 1, 1, 1, 255, 0, 0, false )
	else
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
		surface.DrawRect( 0, 0, w, h )
	end

	-- Border and hover effects
	if( self.textEntry:IsEditing() ) then
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
end

vgui.Register( "pz_textentry", PANEL, "DPanel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
