
local PANEL = {

	Init = function( self )

		self:SetContentAlignment( 4 )
		self:SetTextInset( 5, 0 )
		self:SetFont( "DermaDefaultBold" )

	end,

	DoClick = function( self )

		self:GetParent():Toggle()

	end,

	UpdateColours = function( self, skin )

		if ( !self:GetParent():GetExpanded() ) then
			self:SetExpensiveShadow( 0, Color( 0, 0, 0, 200 ) )
			return self:SetTextStyleColor( skin.Colours.Category.Header_Closed )
		end

		self:SetExpensiveShadow( 1, Color( 0, 0, 0, 100 ) )
		return self:SetTextStyleColor( skin.Colours.Category.Header )

	end,

	Paint = function( self )

		-- Do nothing!

	end,

	GenerateExample = function()

		-- Do nothing!

	end

}

derma.DefineControl( "bricks_server_dcategoryheader", "Category Header", PANEL, "DButton" )

local PANEL = {}

AccessorFunc( PANEL, "m_bSizeExpanded",		"Expanded", FORCE_BOOL )
AccessorFunc( PANEL, "m_iContentHeight",	"StartHeight" )
AccessorFunc( PANEL, "m_fAnimTime",			"AnimTime" )
AccessorFunc( PANEL, "m_bDrawBackground",	"PaintBackground", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDrawBackground",	"DrawBackground", FORCE_BOOL ) -- deprecated
AccessorFunc( PANEL, "m_iPadding",			"Padding" )
AccessorFunc( PANEL, "m_pList",				"List" )

function PANEL:Init()

	self.Header = vgui.Create( "bricks_server_dcategoryheader", self )
	self.Header:Dock( TOP )
	self.Header:SetSize( 20, 40 )

	self:SetSize( 16, 16 )
	self:SetExpanded( true )
	self:SetMouseInputEnabled( true )

	self:SetAnimTime( 0.2 )
	self.animSlide = Derma_Anim( "Anim", self, self.AnimSlide )

	self:SetPaintBackground( true )
	self:DockMargin( 0, 0, 0, 5 )
	self:DockPadding( 0, 0, 0, 0 )

end

function PANEL:Add( strName )

	local button = vgui.Create( "DButton", self )
	button.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	button.UpdateColours = function( button, skin )

		if ( button.AltLine ) then

			if ( button.Depressed || button.m_bSelected ) then	return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Selected ) end
			if ( button.Hovered ) then							return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text_Hover ) end
			return button:SetTextStyleColor( skin.Colours.Category.LineAlt.Text )

		end

		if ( button.Depressed || button.m_bSelected ) then	return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Selected ) end
		if ( button.Hovered ) then							return button:SetTextStyleColor( skin.Colours.Category.Line.Text_Hover ) end
		return button:SetTextStyleColor( skin.Colours.Category.Line.Text )

	end

	button:SetHeight( 40 )
	button:SetTextInset( 4, 0 )

	button:SetContentAlignment( 4 )
	button.DoClickInternal = function()

		if ( self:GetList() ) then
			self:GetList():UnselectAll()
		else
			self:UnselectAll()
		end

		button:SetSelected( true )

	end

	button:Dock( TOP )
	button:SetText( strName )

	self:InvalidateLayout( true )
	self:UpdateAltLines()

	return button

end

function PANEL:UnselectAll()

	local children = self:GetChildren()
	for k, v in pairs( children ) do

		if ( v.SetSelected ) then
			v:SetSelected( false )
		end

	end

end

function PANEL:UpdateAltLines()

	local children = self:GetChildren()
	for k, v in pairs( children ) do
		v.AltLine = k % 2 != 1
	end

end

function PANEL:Think()

	self.animSlide:Run()

end

function PANEL:SetLabel( strLabel )

	self.Header:SetText( strLabel )

end

function PANEL:Paint( w, h )
	draw.RoundedBox( 5, 0, 0, w, h, (self.fillBackColor or BRICKS_SERVER.Func.GetTheme( 2 )) )
	draw.RoundedBox( 5, 0, 0, w, 40, Color(24, 23, 26, 200) ) --BRICKS_SERVER.Func.GetTheme( 3 )

	BRICKS_SERVER.Func.DrawPartialRoundedBox( 5, 0, 0, 3, 40, (self.backColor or BRICKS_SERVER.Func.GetTheme( 4 )), 10, 40 )

	draw.SimpleText( (self.headerText or BRICKS_SERVER.Func.L( "nil" )), "BRICKS_SERVER_Font20", 15, 40/2, BRICKS_SERVER.Func.GetTheme( 6 ), 0, TEXT_ALIGN_CENTER )
end

function PANEL:AddButton( material, func )
	local button = vgui.Create( "DButton", self.Header )
	button:Dock( RIGHT )
	button:DockMargin( 2, 2, 2, 2 )
	button:SetWide( 36 )
	button:SetText( "" )
	local changeAlpha = 0
	local x, y = 0, 0
	button.Paint = function( self2, w, h )
		local toScreenX, toScreenY = self2:LocalToScreen( 0, 0 )
		if( x != toScreenX or y != toScreenY ) then
			x, y = toScreenX, toScreenY
		end

		if( self2:IsDown() ) then
			changeAlpha = math.Clamp( changeAlpha+10, 0, 125 )
		elseif( self2:IsHovered() ) then
			changeAlpha = math.Clamp( changeAlpha+10, 0, 95 )
		else
			changeAlpha = math.Clamp( changeAlpha-10, 0, 95 )
		end

		surface.SetAlphaMultiplier( changeAlpha/255 )
		draw.RoundedBox( 5, 0, 0, w, h, BRICKS_SERVER.Func.GetTheme( 2 ) )
		surface.SetAlphaMultiplier( 1 )

		surface.SetMaterial( material )
		local size = 24
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( (h-size)/2-1, (h-size)/2+1, size, size )

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( (h-size)/2, (h-size)/2, size, size )
	end
	button.DoClick = function()
		func( x, y, button:GetWide(), button:GetWide() )
	end
end

function PANEL:SetContents( pContents )

	self.Contents = pContents
	self.Contents:SetParent( self )
	self.Contents:Dock( FILL )

	if ( !self:GetExpanded() ) then

		self.OldHeight = self:GetTall()

	elseif ( self:GetExpanded() && IsValid( self.Contents ) && self.Contents:GetTall() < 1 ) then

		self.Contents:SizeToChildren( false, true )
		self.OldHeight = self.Contents:GetTall()
		self:SetTall( self.OldHeight )

	end

	self:InvalidateLayout( true )

end

function PANEL:SetExpanded( expanded )

	self.m_bSizeExpanded = tobool( expanded )

	if ( !self:GetExpanded() ) then
		if ( !self.animSlide.Finished && self.OldHeight ) then return end
		self.OldHeight = self:GetTall()
	end

end

function PANEL:Toggle()

	self:SetExpanded( !self:GetExpanded() )

	self.animSlide:Start( self:GetAnimTime(), { From = self:GetTall() } )

	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

	local open = "1"
	if ( !self:GetExpanded() ) then open = "0" end
	self:SetCookie( "Open", open )

	self:OnToggle( self:GetExpanded() )

end

function PANEL:OnToggle( expanded )

	-- Do nothing / For developers to overwrite

end

function PANEL:DoExpansion( b )

	if ( self:GetExpanded() == b ) then return end
	self:Toggle()

end

function PANEL:PerformLayout()

	if ( IsValid( self.Contents ) ) then

		if ( self:GetExpanded() ) then
			self.Contents:InvalidateLayout( true )
			self.Contents:SetVisible( true )
		else
			self.Contents:SetVisible( false )
		end

	end

	if ( self:GetExpanded() ) then

		if ( IsValid( self.Contents ) && #self.Contents:GetChildren() > 0 ) then self.Contents:SizeToChildren( false, true ) end
		self:SizeToChildren( false, true )

	else

		if ( IsValid( self.Contents ) && !self.OldHeight ) then self.OldHeight = self.Contents:GetTall() end
		self:SetTall( self.Header:GetTall() )

	end

	-- Make sure the color of header text is set
	self.Header:ApplySchemeSettings()

	self.animSlide:Run()
	self:UpdateAltLines()

end

function PANEL:OnMousePressed( mcode )

	if ( !self:GetParent().OnMousePressed ) then return end

	return self:GetParent():OnMousePressed( mcode )

end

function PANEL:AnimSlide( anim, delta, data )

	self:InvalidateLayout()
	self:InvalidateParent()

	if ( anim.Started ) then
		if ( !IsValid( self.Contents ) && ( self.OldHeight || 0 ) < self.Header:GetTall() ) then
			-- We are not using self.Contents and our designated height is less
			-- than the header size, something is clearly wrong, try to rectify
			self.OldHeight = 0
			for id, pnl in pairs( self:GetChildren() ) do
				self.OldHeight = self.OldHeight + pnl:GetTall()
			end
		end

		if ( self:GetExpanded() ) then
			data.To = math.max( self.OldHeight, self:GetTall() )
		else
			data.To = self:GetTall()
		end
	end

	if ( IsValid( self.Contents ) ) then self.Contents:SetVisible( true ) end

	self:SetTall( Lerp( delta, data.From, data.To ) )

end

function PANEL:LoadCookies()

	local Open = self:GetCookieNumber( "Open", 1 ) == 1

	self:SetExpanded( Open )
	self:InvalidateLayout( true )
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

end

derma.DefineControl( "bricks_server_dcollapsiblecategory", "Collapsable Category Panel", PANEL, "Panel" )
