--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local PANEL = {}

function PANEL:Init()
	self:SetText( "" )
	self:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )

	self.boxSize = self:GetTall()*0.75
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

	surface.SetFont( "MontserratBold20" )
	local textX = surface.GetTextSize( text )

	self:SetWide( self:GetTall()+textX+(self:GetTall()*0.25)+self.boxSize+(self:GetTall()-self.boxSize)/2 )
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

function PANEL:SetIcon( iconMat )
    self.iconMat = iconMat
end

local tickMat = Material( "project0/icons/tick.png", "noclamp smooth" )
function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.1, 100 )

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

	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, self.alpha ) )
	surface.DrawRect( 0, 0, w, h )

	-- Checkbox
	local boxSize = self.boxSize

	if( self.value ) then
		self.hoverPercent = math.Clamp( (self.hoverPercent or 0)+3, 0, 100 )
	else
		self.hoverPercent = math.Clamp( (self.hoverPercent or 0)-3, 0, 100 )
	end

	local borderR = 2
	local borderL = PROJECT0.FUNC.ScreenScale( 10 )

	local hoverPercent = self.hoverPercent/100
	local borderH = borderL+((boxSize-borderL)*hoverPercent)

	local boxX, boxY = w-boxSize-(h/2-boxSize/2), h/2-boxSize/2

	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1, 100 ) )
	surface.DrawRect( boxX, boxY, boxSize, boxSize )

	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
	surface.DrawRect( boxX, boxY, borderH, borderR )
	surface.DrawRect( boxX, boxY, borderR, borderH )
	surface.DrawRect( boxX+boxSize-borderH, boxY+boxSize-borderR, borderH, borderR )
	surface.DrawRect( boxX+boxSize-borderR, boxY+boxSize-borderH, borderR, borderH )

	if( self.value ) then
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
		surface.SetMaterial( tickMat )
		local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
		surface.DrawTexturedRect( boxX+boxSize/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize)
	end

	-- Icon/Text
	if( self.iconMat ) then
		surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 75 ) )
		surface.SetMaterial( self.iconMat )
		local iconSize = h*0.5
		surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )
	end

	draw.SimpleText( (self.labelText or "None"), "MontserratBold20", h, h/2, PROJECT0.FUNC.GetTheme( 3, 100+self.alpha ), 0, TEXT_ALIGN_CENTER )
end

vgui.Register( "pz_checkbutton", PANEL, "DButton" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
