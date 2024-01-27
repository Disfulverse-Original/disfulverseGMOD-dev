--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local PANEL = {}

function PANEL:Init()
	self:SetBackColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
	self:SetHighlightColor( PROJECT0.FUNC.GetTheme( 2 ) )

	self.numberWang = vgui.Create( "DNumberWang", self )
	self.numberWang:Dock( FILL )
	self.numberWang:DockMargin( 10, 0, 0, 0 )
	self.numberWang:SetFont( "MontserratMedium25" )
	self.numberWang:SetText( "" )
	self.numberWang:SetTextColor( Color( 255, 255, 255, 20 ) )
	self.numberWang:SetCursorColor( Color( 255, 255, 255 ) )
	self.numberWang:SetMinMax( 0, 99999999 )
	self.numberWang.backTextColor = PROJECT0.FUNC.GetTheme( 3, 100 )
	self.numberWang.Paint = function( self2, w, h )
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
	self.numberWang.OnChange = function()
        if( self.OnChange ) then self:OnChange() end
    end
    self.numberWang.OnEnter = function()
        if( self.OnEnter ) then self:OnEnter() end
    end
	self.numberWang.OnLoseFocus = function( self2 )
		timer.Simple( 0, function() 
			if( not IsValid( self2 ) ) then return end
			self2:SetValue( math.Clamp( self2:GetValue(), self2:GetMin(), self2:GetMax() ) ) 
		end )

        if( self.OnLoseFocus ) then self:OnLoseFocus() end
    end
end

function PANEL:SetMinMax( min, max )
    self.numberWang:SetMinMax( min, max )
end

function PANEL:SetValue( val )
    self.numberWang:SetValue( val )
end

function PANEL:GetValue()
    return self.numberWang:GetValue()
end

function PANEL:SetBackColor( color )
    self.backColor = color
end

function PANEL:SetHighlightColor( color )
    self.highlightColor = color
end

function PANEL:SetMinMax( min, max )
    self.numberWang:SetMinMax( min, max )
end

function PANEL:DisableShadows( disable )
    self.disableShadows = disable
end

function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.2, 155, false, false, self.numberWang:IsEditing(), 155 )

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
	if( self.numberWang:IsEditing() ) then
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

vgui.Register( "pz_numberwang", PANEL, "DPanel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
