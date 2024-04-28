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
	self.choiceHeight = PROJECT0.FUNC.ScreenScale( 40 )

	self.textEntry = vgui.Create( "pz_textentry", self )
	self.textEntry:Dock( FILL )
	self.textEntry.Paint = function() end
	self.textEntry:SetBackText( "SEARCH" )
	self.textEntry:SetFont( "MontserratBold19" )
	self.textEntry.OnChange = function()
        self.menu:Refresh( self.textEntry:GetValue() )
    end
	self.textEntry.OnGetFocus = function()
		self:Open()
	end
	self.textEntry.OnLoseFocus = function( self2 )
		timer.Simple( 0, function() self2:SetValue( "" ) end )
	end
end

function PANEL:Open()
	if( IsValid( self.menu ) ) then return end

    local stoppedEditing
	self.opened = true
	self:DoRotationAnim( true )

	self.menu = vgui.Create( "pz_scrollpanel", self:GetParent() )
	self.menu:SetPos( self:LocalToScreen( self:GetParent():ScreenToLocal( 0, self:GetTall() ) ) )
	self.menu:SetSize( self:GetWide(), 0 )
	self.menu.GetDeleteSelf = function() return true end
	self.menu.OnRemove = function()
		if( not IsValid( self ) ) then return end
		self.lastDeleted = CurTime()
		self.opened = false
        self:DoRotationAnim( false )
	end
	self.menu.Think = function()
        if( not self.textEntry:IsEditing() and not stoppedEditing ) then
            stoppedEditing = CurTime()
        elseif( self.textEntry:IsEditing() ) then
            stoppedEditing = nil
        end

		if( not IsValid( self ) or (not self.textEntry:IsEditing() and CurTime() >= stoppedEditing+0.1) ) then
			self.menu:Remove()
		end
	end
	self.menu:SetBarBackColor( PROJECT0.FUNC.GetTheme( 1, 100 ) )
	self.menu:SetBarColor( PROJECT0.FUNC.GetTheme( 3, 50 ) )
	self.menu:SetBarDownColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
	self.menu.paintInMask = {}
	self.menu.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )

        PROJECT0.FUNC.BeginShadow( "combo_description_search", 0, y, ScrW(), y+h+10 )
        PROJECT0.FUNC.SetShadowSize( "combo_description_search", w, h )
		draw.RoundedBoxEx( 0, x, y, w, h, PROJECT0.FUNC.GetTheme( 1 ), false, false, true, true )
        PROJECT0.FUNC.EndShadow( "combo_description_search", x, y, 1, 2, 2, 255, 0, 0, true )

        draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 1 ), false, false, true, true )
		draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 2, 100 ), false, false, true, true )

		PROJECT0.FUNC.DrawRoundedExMask( 0, 0, 0, w, h, function()
			for k, v in ipairs( self2.paintInMask ) do
                if( not IsValid( v ) ) then
                    table.remove( self2.paintInMask, k )
                    continue
                end

				v:PaintManual()
			end
        end, false, false, true, true )
	end

	self.menu:GetVBar():SetPaintedManually( true )
	table.insert( self.menu.paintInMask, self.menu:GetVBar() )

    self.menu.Refresh = function( self2, searchText )
        self2:Clear()

        searchText = string.lower( searchText )

        local sortedChoices = {}
        for k, v in pairs( self.choices ) do
            local foundInName, foundInDescription = string.find( string.lower( v[1] ), searchText ), string.find( string.lower( v[2] ), searchText )
            if( not foundInName and not foundInDescription ) then continue end

            table.insert( sortedChoices, { k, (foundInName and 100) or 0 } )
        end

        table.SortByMember( sortedChoices, 2 )

        local margin10 = PROJECT0.FUNC.ScreenScale( 10 )
        for k, v in pairs( sortedChoices ) do
            local choiceInfo = self.choices[v[1]]

            local description = PROJECT0.FUNC.NiceTrimText( choiceInfo[2], "MontserratMedium15", self:GetWide()-10-(2*margin10) )

            local button = vgui.Create( "DButton", self2 )
            button:Dock( TOP )
            button:SetTall( self.choiceHeight )
            button:SetText( "" )
            button:SetPaintedManually( true )
            button.Paint = function( self2, w, h )
                self2:CreateFadeAlpha( 0.2, 100 )

                draw.RoundedBoxEx( 0, 0, 0, w, h, PROJECT0.FUNC.GetTheme( 3, self2.alpha ), false, false, false, false )

                draw.SimpleText( choiceInfo[1], "MontserratBold20", margin10, h/2+1, PROJECT0.FUNC.GetTheme( 3 ), 0, TEXT_ALIGN_BOTTOM )
                draw.SimpleText( description, "MontserratMedium15", margin10, h/2-1, PROJECT0.FUNC.GetTheme( 4 ) )
            end
            button.DoClick = function()
                self:SelectChoice( v[1] )
                self2:Remove()
            end

            table.insert( self2.paintInMask, button )
        end

        self.menu:SizeTo( self:GetWide(), math.min( #sortedChoices, 4 )*self.choiceHeight, 0.2 )
    end

    self.menu:Refresh( self.textEntry:GetValue() )
end

local arrow16Mat = Material( "project0/icons/down_16.png" )
function PANEL:Paint( w, h )
	self:CreateFadeAlpha( 0.2, 155, false, false, self.opened, 155 )

	-- Background
	PROJECT0.FUNC.BeginShadow( "menu_combo_search" )
	local x, y = self:LocalToScreen( 0, 0 )
	surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
	surface.DrawRect( x, y, w, h )
	PROJECT0.FUNC.EndShadow( "menu_combo_search", x, y, 1, 1, 1, 255, 0, 0, false )

	-- Border and hover effects
	if( self.opened ) then
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

	surface.SetDrawColor( self.textEntry.textEntry.backTextColor )
	surface.SetMaterial( arrow16Mat )
	local iconSize = PROJECT0.FUNC.ScreenScale( 16 )
	surface.DrawTexturedRectRotated( w-((h-iconSize)/2)-(iconSize/2), h/2, iconSize, iconSize, math.Clamp( (self.textureRotation or -90), -90, 0 ) )
end

derma.DefineControl( "pz_combo_description_search", "", PANEL, "pz_combo_description" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
