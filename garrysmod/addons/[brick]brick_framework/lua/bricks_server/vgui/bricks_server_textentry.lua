
local PANEL = {}

local strAllowedNumericCharacters = "1234567890.-"

AccessorFunc( PANEL, "m_bAllowEnter", "EnterAllowed", FORCE_BOOL )
AccessorFunc( PANEL, "m_bUpdateOnType", "UpdateOnType", FORCE_BOOL ) -- Update the convar as we type
AccessorFunc( PANEL, "m_bNumeric", "Numeric", FORCE_BOOL )
AccessorFunc( PANEL, "m_bHistory", "HistoryEnabled", FORCE_BOOL )
AccessorFunc( PANEL, "m_bDisableTabbing", "TabbingDisabled", FORCE_BOOL )

AccessorFunc( PANEL, "m_FontName", "Font" )
AccessorFunc( PANEL, "m_bBorder", "DrawBorder" )
AccessorFunc( PANEL, "m_bBackground", "PaintBackground" )
AccessorFunc( PANEL, "m_bBackground", "DrawBackground" ) -- Deprecated

AccessorFunc( PANEL, "m_colText", "TextColor" )
AccessorFunc( PANEL, "m_hintText", "HintText" )
AccessorFunc( PANEL, "m_colHighlight", "HighlightColor" )
AccessorFunc( PANEL, "m_colCursor", "CursorColor" )

AccessorFunc( PANEL, "m_colPlaceholder", "PlaceholderColor" )
AccessorFunc( PANEL, "m_txtPlaceholder", "PlaceholderText" )

Derma_Install_Convar_Functions( PANEL )

function PANEL:Init()

	self:SetHistoryEnabled( false )
	self.History = {}
	self.HistoryPos = 50

	--
	-- We're going to draw these ourselves in
	-- the skin system - so disable them here.
	-- This will leave it only drawing text.
	--
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackgroundEnabled( false )

	--
	-- These are Lua side commands
	-- Defined above using AccessorFunc
	--
	self:SetDrawBorder( true )
	self:SetPaintBackground( true )
	self:SetEnterAllowed( true )
	self:SetUpdateOnType( false )
	self:SetNumeric( false )
	self:SetAllowNonAsciiCharacters( true )

	-- Nicer default height
	self:SetTall( 20 )

	-- Clear keyboard focus when we click away
	self.m_bLoseFocusOnClickAway = true

	-- Beam Me Up Scotty
	self:SetCursor( "beam" )

	self:SetFont( "BRICKS_SERVER_Font23" )
	self:SetText( "" )
	self:SetTextColor( Color( 255, 255, 255, 20 ) )
	self:SetCursorColor( Color( 255, 255, 255 ) )
	self:DockMargin( 10, 0, 0, 0 )
end

function PANEL:IsEditing()
	return self == vgui.GetKeyboardFocus()
end

function PANEL:OnKeyCodeTyped( code )

	self:OnKeyCode( code )

	if ( code == KEY_ENTER && !self:IsMultiline() && self:GetEnterAllowed() ) then

		if ( IsValid( self.Menu ) ) then
			self.Menu:Remove()
		end

		self:FocusNext()
		self:OnEnter()
		self.HistoryPos = 0

	end

	if ( self.m_bHistory || IsValid( self.Menu ) ) then

		if ( code == KEY_UP ) then
			self.HistoryPos = self.HistoryPos - 1
			self:UpdateFromHistory()
		end

		if ( code == KEY_DOWN || code == KEY_TAB ) then
			self.HistoryPos = self.HistoryPos + 1
			self:UpdateFromHistory()
		end

	end

end

function PANEL:OnKeyCode( code )
end

function PANEL:ApplySchemeSettings()

	self:SetFontInternal( self.m_FontName )

	derma.SkinHook( "Scheme", "TextEntry", self )

end

function PANEL:GetTextColor()

	return self.m_colText || self:GetSkin().colTextEntryText

end

function PANEL:GetHintText()

	return self.m_hintText

end

function PANEL:GetPlaceholderColor()

	return self.m_colPlaceholder || self:GetSkin().colTextEntryTextPlaceholder

end

function PANEL:GetHighlightColor()

	return self.m_colHighlight || self:GetSkin().colTextEntryTextHighlight

end

function PANEL:GetCursorColor()

	return self.m_colCursor || self:GetSkin().colTextEntryTextCursor

end

function PANEL:UpdateFromHistory()

	if ( IsValid( self.Menu ) ) then
		return self:UpdateFromMenu()
	end

	local pos = self.HistoryPos
	-- Is the Pos within bounds?
	if ( pos < 0 ) then pos = #self.History end
	if ( pos > #self.History ) then pos = 0 end

	local text = self.History[ pos ]
	if ( !text ) then text = "" end

	self:SetText( text )
	self:SetCaretPos( text:len() )

	self:OnTextChanged()

	self.HistoryPos = pos

end

function PANEL:UpdateFromMenu()

	local pos = self.HistoryPos
	local num = self.Menu:ChildCount()

	self.Menu:ClearHighlights()

	if ( pos < 0 ) then pos = num end
	if ( pos > num ) then pos = 0 end

	local item = self.Menu:GetChild( pos )
	if ( !item ) then
		self:SetText( "" )
		self.HistoryPos = pos
		return
	end

	self.Menu:HighlightItem( item )

	local txt = item:GetText()

	self:SetText( txt )
	self:SetCaretPos( txt:len() )

	self:OnTextChanged( true )

	self.HistoryPos = pos

end

function PANEL:OnTextChanged( noMenuRemoval )

	self.HistoryPos = 0

	if ( self:GetUpdateOnType() ) then
		self:UpdateConvarValue()
		self:OnValueChange( self:GetText() )
	end

	if ( IsValid( self.Menu ) && !noMenuRemoval ) then
		self.Menu:Remove()
	end

	local tab = self:GetAutoComplete( self:GetText() )
	if ( tab ) then
		self:OpenAutoComplete( tab )
	end

	self:OnChange()

end

function PANEL:OnChange()
end

function PANEL:OpenAutoComplete( tab )

	if ( !tab ) then return end
	if ( #tab == 0 ) then return end

	self.Menu = DermaMenu()

	for k, v in pairs( tab ) do

		self.Menu:AddOption( v, function() self:SetText( v ) self:SetCaretPos( v:len() ) self:RequestFocus() end )

	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )
	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, true, self )
	self.Menu:SetPos( x, y )
	self.Menu:SetMaxHeight( ( ScrH() - y ) - 10 )

end

local Alpha = 20
function PANEL:Think()

	self:ConVarStringThink()

	if( self:IsEditing() and Alpha != 255 ) then
		Alpha = math.Clamp( Alpha+20, 20, 255 )
	elseif( not self:IsEditing() and Alpha != 20 ) then
		Alpha = math.Clamp( Alpha-20, 20, 255 )
	end

	if( self:GetTextColor() != Color( 255, 255, 255, 255 ) or self:GetTextColor() != Color( 255, 255, 255, 20 ) ) then
		self:SetTextColor( Color( 255, 255, 255, Alpha ) )
	end
end

function PANEL:OnEnter()

	-- For override
	self:UpdateConvarValue()
	self:OnValueChange( self:GetText() )

end

function PANEL:UpdateConvarValue()

	-- This only kicks into action if this variable has
	-- a ConVar associated with it.
	self:ConVarChanged( self:GetValue() )

end

function PANEL:Paint( w, h )
	if( self.backColor ) then
		if( self:IsEditing() ) then
			draw.RoundedBox( 5, 0, 0, w, h, self.backColor )
		else
			surface.SetAlphaMultiplier( 0.75 )
			draw.RoundedBox( 5, 0, 0, w, h, self.backColor )
			surface.SetAlphaMultiplier( 1 )
		end
	end

	local panel = self

	if ( panel.GetPlaceholderText && panel.GetPlaceholderColor && panel:GetPlaceholderText() && panel:GetPlaceholderText():Trim() != "" && panel:GetPlaceholderColor() && ( !panel:GetText() || panel:GetText() == "" ) ) then

		local oldText = panel:GetText()

		local str = panel:GetPlaceholderText()
		if ( str:StartWith( "#" ) ) then str = str:sub( 2 ) end
		str = language.GetPhrase( str )

		panel:SetText( str )
		panel:DrawTextEntryText( panel:GetPlaceholderColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
		panel:SetText( oldText )

		return
	end

	panel:DrawTextEntryText( panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
end

function PANEL:PerformLayout()

	derma.SkinHook( "Layout", "TextEntry", self )

end

function PANEL:SetValue( strValue )

	-- Don't update if we're typing into it!
	-- I'm sure a lot of people will want to reverse this behaviour :(
	if ( vgui.GetKeyboardFocus() == self ) then return end

	local CaretPos = self:GetCaretPos()

	self:SetText( strValue )
	self:OnValueChange( strValue )

	self:SetCaretPos( CaretPos )

end

function PANEL:OnValueChange( strValue )
	-- For Override
end

function PANEL:CheckNumeric( strValue )

	-- Not purely numeric, don't run the check
	if ( !self:GetNumeric() ) then return false end

	-- God I hope numbers look the same in every language
	if ( !string.find( strAllowedNumericCharacters, strValue, 1, true ) ) then

		-- Noisy Error?
		return true

	end

	return false

end

function PANEL:SetDisabled( bDisabled )
	self:SetEnabled( !bDisabled )
end

function PANEL:GetDisabled( bDisabled )
	return !self:IsEnabled()
end

function PANEL:AllowInput( strValue )

	-- This is layed out like this so you can easily override and
	-- either keep or remove this numeric check.
	if ( self:CheckNumeric( strValue ) ) then return true end

end

function PANEL:SetEditable( b )

	self:SetKeyboardInputEnabled( b )
	self:SetMouseInputEnabled( b )

end

function PANEL:OnGetFocus()

	--
	-- These hooks are here for the sake of things like the spawn menu
	-- which don't have key focus until you click on one of the text areas.
	--
	-- If you make a control for the spawnmenu that requires keyboard input
	-- You should have these 3 functions in your panel, so it can handle it.
	--

	hook.Run( "OnTextEntryGetFocus", self )

end

function PANEL:OnLoseFocus()

	self:UpdateConvarValue()

	hook.Call( "OnTextEntryLoseFocus", nil, self )

end

function PANEL:OnMousePressed( mcode )

	self:OnGetFocus()

end

function PANEL:AddHistory( txt )

	if ( !txt || txt == "" ) then return end

	table.RemoveByValue( self.History, txt )
	table.insert( self.History, txt )

end

function PANEL:GetAutoComplete( txt )
	-- for override. Return a table of strings.
end

function PANEL:GetInt()

	return math.floor( tonumber( self:GetText() ) + 0.5 )

end

function PANEL:GetFloat()

	return tonumber( self:GetText() )

end

derma.DefineControl( "bricks_server_textentry", "A simple TextEntry control", PANEL, "TextEntry" )

--[[---------------------------------------------------------
	Clear the focus when we click away from us..
-----------------------------------------------------------]]
hook.Add( "VGUIMousePressed", "BRS_TextEntryLoseFocus", function( panel, mcode )
	hook.Remove( "VGUIMousePressed", "TextEntryLoseFocus" )

	local pnl = vgui.GetKeyboardFocus()
	if ( !pnl ) then return end
	if ( pnl == panel ) then return end
	if ( panel:GetName() == "bricks_server_dmenuoption" ) then return end
	if ( !pnl.m_bLoseFocusOnClickAway ) then return end

	pnl:FocusNext()
end )
