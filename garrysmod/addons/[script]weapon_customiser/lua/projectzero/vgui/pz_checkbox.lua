--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local PANEL = {}

function PANEL:Init()
	self:SetText( "" )
	self:SetTall( PROJECT0.FUNC.ScreenScale( 30 ) )
end

function PANEL:SetValue( val )
    self.value = val
	
	if( self.OnChange ) then
		self:OnChange( val )
	end
end

function PANEL:GetValue()
    return self.value
end

function PANEL:SetLabelText( text )
    self.labelText = text
end

function PANEL:SetLabelFont( font )
    self.labelFont = font
end

function PANEL:DoClick()
	self:SetValue( not self.value )
end

function PANEL:DisableShadows( disable )
    self.disableShadows = disable
end

local tickMat = Material( "project0/icons/tick.png", "noclamp smooth" )
function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.2, 150 )

	-- Background
	local old = DisableClipping( true )

	local border = 5
	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, self.alpha ) )
	surface.DrawRect( -border, -border, w+(2*border), h+(2*border) )

	DisableClipping( old )

	if( not self.disableShadows ) then
		PROJECT0.FUNC.BeginShadow( "menu_checkbox_" .. tostring( self ) )
		local x, y = self:LocalToScreen( 0, 0 )
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
		surface.DrawRect( x, y, h, h )
		PROJECT0.FUNC.EndShadow( "menu_checkbox_" .. tostring( self ), x, y, 1, 1, 1, 255, 0, 0, false )
	else
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
		surface.DrawRect( 0, 0, h, h )
	end

	-- Border and hover effects
	if( self.value ) then
		self.hoverPercent = math.Clamp( (self.hoverPercent or 0)+3, 0, 100 )
	else
		self.hoverPercent = math.Clamp( (self.hoverPercent or 0)-3, 0, 100 )
	end

	local borderR = 2
	local borderL = PROJECT0.FUNC.ScreenScale( 10 )

	local hoverPercent = self.hoverPercent/100
	local borderH = borderL+((h-borderL)*hoverPercent)

	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, hoverPercent*100 ) )
	surface.DrawRect( 0, 0, h, h )

	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
	surface.DrawRect( 0, 0, borderH, borderR )
	surface.DrawRect( 0, 0, borderR, borderH )
	surface.DrawRect( h-borderH, h-borderR, borderH, borderR )
	surface.DrawRect( h-borderR, h-borderH, borderR, borderH )

	if( self.value ) then
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
		surface.SetMaterial( tickMat )
		local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
		surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize)
	end

	draw.SimpleText( self.labelText or "", "MontserratBold19", w, h/2, PROJECT0.FUNC.GetTheme( 4 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
end

vgui.Register( "pz_checkbox", PANEL, "DButton" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
