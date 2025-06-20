--[[

	DVScrollBar

	Usage:

	Place this control in your panel. You will ideally have another panel or
		control which is bigger than the original panel. This is the Canvas.

	scrollbar:SetUp( _barsize_, _canvassize_ ) should be called whenever
		the size of your 'canvas' changes.

	scrollbar:GetOffset() can be called to get the offset of the canvas.
		You should call this in your PerformLayout function and set the Y
		pos of your canvas to this value.

	Example:

	function PANEL:PerformLayout()

		local Wide = self:GetWide()
		local YPos = 0

		-- Place the scrollbar
		self.VBar:SetPos( self:GetWide() - 16, 0 )
		self.VBar:SetSize( 16, self:GetTall() )

		-- Make sure the scrollbar knows how big our canvas is
		self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )

		-- Get data from the scrollbar
		YPos = self.VBar:GetOffset()

		-- If the scrollbar is enabled make the canvas thinner so it will fit in.
		if ( self.VBar.Enabled ) then Wide = Wide - 16 end

		-- Position the canvas according to the scrollbar's data
		self.pnlCanvas:SetPos( self.Padding, YPos + self.Padding )
		self.pnlCanvas:SetSize( Wide - self.Padding * 2, self.pnlCanvas:GetTall() )

	end

--]]

local PANEL = {}

function PANEL:Init()
	self.Offset = 0
	self.Scroll = 0
	self.CanvasSize = 1
	self.BarSize = 1
	self.cornerRadius = 5

	self.btnGrip = vgui.Create( "DScrollBarGrip", self )
	local Alpha = 0
	self.btnGrip.Paint = function( self2, w, h )
		if( h >= self.BarSize-1 ) then return end

		if( self2:IsHovered() ) then
			Alpha = math.Clamp( Alpha+10, 0, 100 )
		else
			Alpha = math.Clamp( Alpha-10, 0, 100 )
		end
	
		if( self.roundedBoxEx ) then
			draw.RoundedBoxEx( self.cornerRadius, 0, 0, w, h, (self.barColor or BRICKS_SERVER.Func.GetTheme( 3 )), self.roundTopLeft, self.roundTopRight, self.roundBottomLeft, self.roundBottomRight )
		else
			draw.RoundedBox( self.cornerRadius, 0, 0, w, h, (self.barColor or BRICKS_SERVER.Func.GetTheme( 3 )) )
		end

		surface.SetAlphaMultiplier( Alpha/255 )
		if( self.roundedBoxEx ) then
			draw.RoundedBoxEx( self.cornerRadius, 0, 0, w, h, (self.barDownColor or BRICKS_SERVER.Func.GetTheme( 2 )), self.roundTopLeft, self.roundTopRight, self.roundBottomLeft, self.roundBottomRight )
		else
			draw.RoundedBox( self.cornerRadius, 0, 0, w, h, (self.barDownColor or BRICKS_SERVER.Func.GetTheme( 2 )) )
		end
		surface.SetAlphaMultiplier( 1 )
	end

	self:SetSize( 10, 15 )
	self:SetEnabled( true )
end

function PANEL:SetRoundedCorners( roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight )
	self.roundedBoxEx = true
	self.roundTopLeft, self.roundTopRight, self.roundBottomLeft, self.roundBottomRight = roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight
end

function PANEL:SetRounded( cornerRadius )
	self.cornerRadius = cornerRadius
end

function PANEL:SetEnabled( b )

	if ( !b ) then

		self.Offset = 0
		self:SetScroll( 0 )
		self.HasChanged = true

	end

	self:SetMouseInputEnabled( b )
	self:SetVisible( b )

	-- We're probably changing the width of something in our parent
	-- by appearing or hiding, so tell them to re-do their layout.
	if ( self.Enabled != b ) then

		self:GetParent():InvalidateLayout()

		if ( self:GetParent().OnScrollbarAppear ) then
			self:GetParent():OnScrollbarAppear()
		end

	end

	self.Enabled = b

end

function PANEL:Value()

	return self.Pos

end

function PANEL:BarScale()

	if ( self.BarSize == 0 ) then return 1 end

	return self.BarSize / ( self.CanvasSize + self.BarSize )

end

function PANEL:SetUp( _barsize_, _canvassize_ )

	self.BarSize = _barsize_
	self.CanvasSize = math.max( _canvassize_ - _barsize_, 1 )

	self:InvalidateLayout()

end

function PANEL:OnMouseWheeled( dlta )

	if ( !self:IsVisible() ) then return false end

	-- We return true if the scrollbar changed.
	-- If it didn't, we feed the mousehweeling to the parent panel

	if( self.btnGrip:GetTall() >= self.BarSize-1 ) then return end

	return self:AddScroll( dlta * -2 )

end

function PANEL:AddScroll( dlta )

	local OldScroll = self:GetScroll()

	dlta = dlta * 25
	self:SetScroll( self:GetScroll() + dlta )

	return OldScroll != self:GetScroll()

end

function PANEL:SetScroll( scrll )

	if ( !self.Enabled ) then self.Scroll = 0 return end
	
	self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )

	self:InvalidateLayout()

	-- If our parent has a OnVScroll function use that, if
	-- not then invalidate layout (which can be pretty slow)

	local func = self:GetParent().OnVScroll
	if ( func ) then

		func( self:GetParent(), self:GetOffset() )

	else

		self:GetParent():InvalidateLayout()

	end

end

function PANEL:AnimateTo( scrll, length, delay, ease )

	local anim = self:NewAnimation( length, delay, ease )
	anim.StartPos = self.Scroll
	anim.TargetPos = scrll
	anim.Think = function( anim, pnl, fraction )

		pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )

	end

end

function PANEL:GetScroll()

	if ( !self.Enabled ) then self.Scroll = 0 end
	return self.Scroll

end

function PANEL:GetOffset()

	if ( !self.Enabled ) then return 0 end
	return self.Scroll * -1

end

function PANEL:Think()
end

function PANEL:Paint( w, h )
	if( self.roundedBoxEx ) then
		draw.RoundedBoxEx( self.cornerRadius, 0, 0, w, h, (self.backColor or BRICKS_SERVER.Func.GetTheme( 2 )), self.roundTopLeft, self.roundTopRight, self.roundBottomLeft, self.roundBottomRight )
	else
		draw.RoundedBox( self.cornerRadius, 0, 0, w, h, (self.backColor or BRICKS_SERVER.Func.GetTheme( 2 )) )
	end
end

function PANEL:OnMousePressed()

	local x, y = self:CursorPos()

	local PageSize = self.BarSize

	if ( y > self.btnGrip.y ) then
		self:SetScroll( self:GetScroll() + PageSize )
	else
		self:SetScroll( self:GetScroll() - PageSize )
	end

end

function PANEL:OnMouseReleased()

	self.Dragging = false
	self.DraggingCanvas = nil
	self:MouseCapture( false )

	self.btnGrip.Depressed = false

end

function PANEL:OnCursorMoved( x, y )

	if ( !self.Enabled ) then return end
	if ( !self.Dragging ) then return end

	local x, y = self:ScreenToLocal( 0, gui.MouseY() )

	-- Uck.
	y = y - self.HoldPos

	local TrackSize = self:GetTall() - self.btnGrip:GetTall()

	y = y / TrackSize

	self:SetScroll( y * self.CanvasSize )

end

function PANEL:Grip()

	if ( !self.Enabled ) then return end
	if ( self.BarSize == 0 ) then return end

	self:MouseCapture( true )
	self.Dragging = true

	local x, y = self.btnGrip:ScreenToLocal( 0, gui.MouseY() )
	self.HoldPos = y

	self.btnGrip.Depressed = true

end

function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local Scroll = self:GetScroll() / self.CanvasSize
	local BarSize = math.max( self:BarScale() * ( self:GetTall() ), 10 )
	local Track = self:GetTall() - BarSize
	Track = Track + 1

	Scroll = Scroll * Track

	self.btnGrip:SetPos( 0, Scroll )
	self.btnGrip:SetSize( Wide, BarSize )
end

derma.DefineControl( "bricks_server_dvscrollbar", "A Scrollbar", PANEL, "Panel" )
