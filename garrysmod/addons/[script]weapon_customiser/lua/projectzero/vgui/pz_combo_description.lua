--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local PANEL = {}

function PANEL:Init()
	self:SetTall( PROJECT0.FUNC.ScreenScale( 50 ) )
	self:SetText( "" )

	self.choices = {}
	self.textureRotation = -90
	self.choiceHeight = PROJECT0.FUNC.ScreenScale( 50 )
end

function PANEL:AddChoice( index, title, description )
	self.choices[index] = { title, description }
end

function PANEL:SelectChoice( index )
	self.selected = index
	if( self.OnSelect ) then self:OnSelect( index ) end
end

function PANEL:DoRotationAnim( expanding )
	local anim = self:NewAnimation( 0.2, 0, -1 )

	anim.Think = function( anim, pnl, fraction )
		if( expanding ) then
			self.textureRotation = (1-fraction)*-90
		else
			self.textureRotation = fraction*-90
		end
	end
end

function PANEL:DoClick()
	if( self.opened or CurTime() < (self.lastDeleted or 0)+0.2 ) then return end
	self:Open()
end

function PANEL:Open()
	if( IsValid( self.menu ) ) then return end

	self.opened = true
	self:DoRotationAnim( true )

	self.menu = vgui.Create( "pz_scrollpanel" )
	self.menu:SetPos( self:LocalToScreen( 0, self:GetTall() ) )
	self.menu:SetSize( self:GetWide(), 0 )
	self.menu:SetDrawOnTop( true )
	self.menu:SetIsMenu( true )
	self.menu.GetDeleteSelf = function() return true end
	self.menu.OnRemove = function()
		self.lastDeleted = CurTime()
		self.opened = false
		self:DoRotationAnim( false )
	end
	self.menu:SetBarBackColor( PROJECT0.FUNC.GetTheme( 1, 100 ) )
	self.menu:SetBarColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
	self.menu:SetBarDownColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
	self.menu.paintInMask = {}
	self.menu.Paint = function( self2, w, h )
		draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 1 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 2, 100 ), false, false, true, true )

		PROJECT0.FUNC.DrawRoundedExMask( 0, 0, 0, w, h, function()
			for k, v in ipairs( self2.paintInMask ) do
				v:PaintManual()
			end
        end, false, false, true, true )
	end

	self.menu:GetVBar():SetPaintedManually( true )
	table.insert( self.menu.paintInMask, self.menu:GetVBar() )

	for k, v in pairs( self.choices ) do
		local button = vgui.Create( "DButton", self.menu )
        button:Dock( TOP )
        button:SetTall( self.choiceHeight )
        button:SetText( "" )
        button:SetPaintedManually( true )
        button.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 100 )

			draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 3, self2.alpha ), false, false, false, false )

			draw.SimpleText( v[1], "MontserratBold20", PROJECT0.UI.Margin10, h/2+2, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( v[2], "MontserratMedium17", PROJECT0.UI.Margin10, h/2-2, PROJECT0.FUNC.GetTheme( 3 ) )
        end
        button.DoClick = function()
            self:SelectChoice( k )
			self.menu:Remove()
        end

		table.insert( self.menu.paintInMask, button )
	end

	self.menu:SizeTo( self:GetWide(), math.min( table.Count( self.choices ), 3 )*self.choiceHeight, 0.2 )
	self.menu:MakePopup()
	RegisterDermaMenuForClose( self.menu )
end

function PANEL:OnRemove()
	if( not IsValid( self.menu ) ) then return end
	self.menu:Remove()
end

function PANEL:SetBackColor( color )
    self.backColor = color
end

function PANEL:SetHighlightColor( color )
    self.highlightColor = color
end

local arrow16Mat = Material( "project0/icons/down_16.png" )
function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.2, 155, false, false, self.opened, 155 )

	local roundBottom = not self.opened
	draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 2, 100+(self.alpha or 0) ), true, true, roundBottom, roundBottom )

	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, 100 ) )
	surface.SetMaterial( arrow16Mat )
	local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
	surface.DrawTexturedRectRotated( w-((h-iconSize)/2)-(iconSize/2), h/2, iconSize, iconSize, math.Clamp( (self.textureRotation or -90), -90, 0 ) )

	local currentSelect = self.choices[self.selected or ""]
	if( not currentSelect ) then return end

	local margin10 = PROJECT0.FUNC.ScreenScale( 10 )
	draw.SimpleText( currentSelect[1], "MontserratBold20", PROJECT0.UI.Margin10, h/2+2, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( currentSelect[2], "MontserratMedium17", PROJECT0.UI.Margin10, h/2-2, PROJECT0.FUNC.GetTheme( 3, 150 ) )
end

derma.DefineControl( "pz_combo_description", "", PANEL, "DButton" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
