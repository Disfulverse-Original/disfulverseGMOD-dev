--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local PANEL = {}

Derma_Install_Convar_Functions( PANEL )

AccessorFunc( PANEL, "m_bDoSort", "SortItems", FORCE_BOOL )

function PANEL:Init()
	self:SetTall( 40 )
	self:Clear()

	self:SetIsMenu( true )
	self:SetSortItems( true )
	self:SetText( "" )
end

function PANEL:SetBackColor( color )
    self.backColor = color
end

function PANEL:SetHighlightColor( color )
    self.highlightColor = color
end

function PANEL:Clear()
	self.Choices = {}
	self.Data = {}
	self.ChoiceIcons = {}
	self.selected = nil

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end
end

function PANEL:GetOptionText( id )
	return self.Choices[ id ]
end

function PANEL:GetOptionData( id )
	return self.Data[ id ]
end

function PANEL:GetOptionTextByData( data )
	for id, dat in pairs( self.Data ) do
		if ( dat == data ) then
			return self:GetOptionText( id )
		end
	end

	-- Try interpreting it as a number
	for id, dat in pairs( self.Data ) do
		if ( dat == tonumber( data ) ) then
			return self:GetOptionText( id )
		end
	end

	-- In case we fail
	return data
end

function PANEL:PerformLayout()

end

function PANEL:ChooseOption( value, index )
	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.text = value

	-- This should really be the here, but it is too late now and convar changes are handled differently by different child elements
	--self:ConVarChanged( self.Data[ index ] )

	self.selected = index
	self:OnSelect( index, value, self.Data[ index ] )
end

function PANEL:ChooseOptionID( index )
	local value = self:GetOptionText( index )
	self:ChooseOption( value, index )
end

function PANEL:GetSelectedID()
	return self.selected
end

function PANEL:GetSelected()
	if ( !self.selected ) then return end

	return self:GetOptionText( self.selected ), self:GetOptionData( self.selected )
end

function PANEL:OnSelect( index, value, data )

	-- For override

end

function PANEL:AddChoice( value, data, select, icon )
	local i = table.insert( self.Choices, value )

	if ( data ) then
		self.Data[ i ] = data
	end
	
	if ( icon ) then
		self.ChoiceIcons[ i ] = icon
	end

	if ( select ) then

		self:ChooseOption( value, i )

	end

	return i
end

function PANEL:IsMenuOpen()
	return IsValid( self.Menu ) && self.Menu:IsVisible()
end

function PANEL:OpenMenu( pControlOpener )
	if ( pControlOpener && pControlOpener == self.TextEntry ) then
		return
	end

	-- Don't do anything if there aren't any options..
	if ( #self.Choices == 0 ) then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Menu = vgui.Create( "DMenu" )

	if ( self:GetSortItems() ) then
		local sorted = {}
		for k, v in pairs( self.Choices ) do
			local val = tostring( v ) --tonumber( v ) || v -- This would make nicer number sorting, but SortedPairsByMemberValue doesn't seem to like number-string mixing
			if ( string.len( val ) > 1 && !tonumber( val ) && val:StartWith( "#" ) ) then val = language.GetPhrase( val:sub( 2 ) ) end
			table.insert( sorted, { id = k, data = v, label = val } )
		end
		for k, v in SortedPairsByMemberValue( sorted, "label" ) do
			local option = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
			if ( self.ChoiceIcons[ v.id ] ) then
				option:SetIcon( self.ChoiceIcons[ v.id ] )
			end
		end
	else
		for k, v in pairs( self.Choices ) do
			local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
			if ( self.ChoiceIcons[ k ] ) then
				option:SetIcon( self.ChoiceIcons[ k ] )
			end
		end
	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )

	self.Menu:SetMaxHeight( ScrH()*0.2 )
	self.Menu.dontRoundTop = true
	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, false, self )
end

function PANEL:CloseMenu()
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
	end
end

function PANEL:CheckConVarChanges()
	if ( !self.m_strConVar ) then return end

	local strValue = GetConVarString( self.m_strConVar )
	if ( self.m_strConVarValue == strValue ) then return end

	self.m_strConVarValue = strValue

	self:SetValue( self:GetOptionTextByData( self.m_strConVarValue ) )
end

function PANEL:Think()
	self:CheckConVarChanges()
end

function PANEL:SetValue( strValue )
	self.text = strValue
end

function PANEL:DoClick()
	if ( self:IsMenuOpen() ) then
		return self:CloseMenu()
	end

	self:OpenMenu()
end

function PANEL:DisableShadows( disable )
    self.disableShadows = disable
end

function PANEL:SetIcon( iconMat )
    self.iconMat = iconMat
end

function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.2, 155, false, false, self:IsMenuOpen(), 155 )

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
	if( self:IsMenuOpen() ) then
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

	-- Icon/Text
	if( self.iconMat ) then
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 75 ) )
		surface.SetMaterial( self.iconMat )
		local iconSize = h*0.5
		surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
	end

	draw.SimpleText( (self.text or PROJECT0.L( "none" )), "MontserratBold20", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 100+self.alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

derma.DefineControl( "pz_combo", "", PANEL, "DButton" )


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
