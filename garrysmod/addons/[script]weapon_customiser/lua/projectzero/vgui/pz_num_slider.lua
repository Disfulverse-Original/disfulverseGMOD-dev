--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    self.railHeight = PROJECT0.FUNC.ScreenScale( 4 )
    self.pointerSize = PROJECT0.FUNC.ScreenScale( 15 )

    self.valueEntry = vgui.Create( "pz_textentry", self )
    self.valueEntry:Dock( RIGHT )
    self.valueEntry:SetWide( PROJECT0.FUNC.ScreenScale( 50 ) )
    self.valueEntry:DockMargin( 0, PROJECT0.UI.Margin5, 0, PROJECT0.UI.Margin5 )
    self.valueEntry:SetValue( 0 )
    self.valueEntry:SetFont( "MontserratMedium20" )
    self.valueEntry.textEntry:DockMargin( PROJECT0.UI.Margin5, 0, 0, 0 )
    self.valueEntry.OnChange = function( self2 )
        local val = tonumber( self2:GetValue() )
        if( not isnumber( val ) ) then return end
        self:SetValue( val )
    end

    self.rail = vgui.Create( "Panel", self )
    self.rail:SetSize( 0, self.railHeight )
    self.rail:SetPos( 0, self:GetTall()/2-self.railHeight/2 )
    self.rail.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    self.pointer = vgui.Create( "DButton", self )
    self.pointer:SetSize( self.pointerSize, self.pointerSize )
    self.pointer:SetPos( 0, self:GetTall()/2-self.pointerSize/2 )
    self.pointer:SetText( "" )
    self.pointer.Paint = function( self2, w, h )
        self2:CreateFadeAlpha( 0.1, 40, false, false, self2:IsDown(), 100, 0.1 )

        local old = DisableClipping( true )

        PROJECT0.FUNC.DrawCircle( w/2, h/2, h/2, PROJECT0.FUNC.GetTheme( 4 ) )
        PROJECT0.FUNC.DrawCircle( w/2, h/2, h/2+2, PROJECT0.FUNC.GetTheme( 4, self2.alpha ) )

        DisableClipping( old )
    end
    self.pointer.Think = function( self2 )
        if( not self2:IsDown() ) then
            self2.mouseStartX = nil
            self2.pointerStartX = nil
            return
        end

        if( not self2.mouseStartX or not self2.pointerStartX ) then
            self2.mouseStartX = gui.MouseX()
            self2.pointerStartX = self2:GetX()
        end

        local newX = math.Clamp( self2.pointerStartX+(gui.MouseX()-self2.mouseStartX), -self2:GetWide()/2, self.rail:GetWide()-self2:GetWide()/2 )
        self:SetPercentValue( (newX+self2:GetWide()/2)/self.rail:GetWide() )
    end

    self:SetMinMax( -100, 100 )
    self:SetValue( 0 )
    self:SetLabel( "VALUE" )
end

function PANEL:SetValue( val )
    self.value = val

    local min, max = math.abs( self.minValue ), math.abs( self.maxValue )

    local percent = (min+(val < 0 and -math.abs( val ) or math.abs( val )))/(min+max)
    self.pointer:SetX( math.Clamp( (percent*self.rail:GetWide())-(self.pointerSize/2), -self.pointerSize/2, self.rail:GetWide()-self.pointerSize/2 ) )

    self.valueEntry:SetValue( math.Round( val, 2 ) )

    if( self.OnChange ) then
        self:OnChange( val )
    end
end

function PANEL:SetPercentValue( percent )
    local minValue, maxValue = math.abs( self.minValue ), math.abs( self.maxValue )
    local minPercent = minValue/(minValue+maxValue)
    if( percent <= minPercent ) then
        self:SetValue( self.minValue-(math.max( percent/minPercent, 0 )*self.minValue) )
    else
        self:SetValue( ((percent-minPercent)/(1-minPercent))*self.maxValue )
    end
end

function PANEL:PerformLayout( w, h )
    self.rail:SetWide( w-self.valueEntry:GetWide()-PROJECT0.UI.Margin25 )
    self:SetValue( self.value )
end

function PANEL:SetMinMax( min, max )
    self.minValue, self.maxValue = min, max
end

function PANEL:SetLabel( label )
    self.label = label
end

function PANEL:SetLabelColor( color )
    self.labelColor = color
end

function PANEL:DisableShadows( disable )
    self.disableShadows = disable
    self.valueEntry:DisableShadows( disable )
end

function PANEL:Paint( w, h )
    draw.SimpleText( self.label, "MontserratBold17", 0, 0, self.labelColor or PROJECT0.FUNC.GetTheme( 4 ), 0, 0 )
end

vgui.Register( "pz_num_slider", PANEL, "Panel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
