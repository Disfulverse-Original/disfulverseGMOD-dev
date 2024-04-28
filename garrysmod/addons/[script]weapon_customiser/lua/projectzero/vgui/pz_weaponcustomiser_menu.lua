--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetSize( ScrW(), ScrH() )
    self:Center()
    self:MakePopup()
    self.pages = {}
    self.activePage = 0

    -- Side Panel --
    self.sidePanel = vgui.Create( "DPanel", self )
    self.sidePanel:SetSize( ScrW()*0.1, ScrH()-ScrW()*0.2 )
    self.sidePanel:SetPos( ScrW()*0.1, (ScrH()/2)-(self.sidePanel:GetTall()/2) )
    self.sidePanel.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( 0, 0, w, h )

        PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_sidepanel" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_sidepanel", x, y, 1, 1, 1, 255, 0, 0, false )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawRect( 0, h-5, w, 5 )
    end

    local iconMat = Material( "project0/icons/paint_64.png", "noclamp smooth" )

    local titlePanel = vgui.Create( "DPanel", self.sidePanel )
    titlePanel:Dock( TOP )
    titlePanel:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
    titlePanel:SetTall( PROJECT0.FUNC.ScreenScale( 65 ) )
    titlePanel.Paint = function( self2, w, h )
        local x, y = self2:LocalToScreen( 0, 0 )
        local iconSize = PROJECT0.FUNC.ScreenScale( 44 )

        PROJECT0.FUNC.BeginShadow( "menu_titles" )
        draw.SimpleText( "PROJECT0", "MontserratBold19", x, y, PROJECT0.FUNC.GetTheme( 4 ) )
        draw.SimpleText( "WEAPON", "MontserratBold30", x+iconSize+PROJECT0.UI.Margin5, y+h-(iconSize/2)+PROJECT0.UI.Margin5, PROJECT0.FUNC.GetTheme( 3 ), 0, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( "CUSTOMISER", "MontserratBold30", x+iconSize+PROJECT0.UI.Margin5, y+h-(iconSize/2)-PROJECT0.UI.Margin5, PROJECT0.FUNC.GetTheme( 3 ), 0, 0 )
        PROJECT0.FUNC.EndShadow( "menu_titles", x, y, 3, 1, 1, 100, 0, 0, false )
        
        surface.SetMaterial( iconMat )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3 ) )
        surface.DrawTexturedRect( 0, h-iconSize, iconSize, iconSize )
    end

    local closeButton = vgui.Create( "DButton", self.sidePanel )
    closeButton:Dock( BOTTOM )
    closeButton:DockMargin( PROJECT0.FUNC.Repeat( PROJECT0.UI.Margin25, 4 ) )
    closeButton:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    closeButton:SetText( "" )
    closeButton.Paint = function( self2, w, h )
        if( self2:IsHovered() ) then
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)+5, 0, 100 )
        else
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)-5, 0, 100 )
        end

        PROJECT0.FUNC.BeginShadow( "menu_btn_close" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_btn_close", x, y, 1, 1, 1, 255, 0, 0, false )

        local hoverPercent = self2.hoverPercent/100
        local offset = PROJECT0.FUNC.ScreenScale( 15 )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.NoTexture()
        surface.DrawPoly( {
            { x = 0, y = 0 },
            { x = hoverPercent*((w/2)+(offset/2)), y = 0 },
            { x = hoverPercent*(w/2)-(offset/2), y = h },
            { x = 0, y = h }
        } )
        surface.DrawPoly( {
            { x = w-hoverPercent*(w/2)+(offset/2), y = 0 },
            { x = w, y = 0 },
            { x = w, y = h },
            { x = w-hoverPercent*((w/2)+(offset/2)), y = h },
        } )

        draw.SimpleText( PROJECT0.L( "close" ), "MontserratBold19", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 200+(55*hoverPercent) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    closeButton.DoClick = function()
        if( PROJECT0.TEMP.RemoveOnClose ) then
            self:Remove()
            return
        end

        self:SetVisible( false )
    end

    -- Pages --
    self.contentPanel = vgui.Create( "DPanel", self )
    self.contentPanel:SetSize( ScrW()*0.65, ScrH()-ScrW()*0.2 )
    self.contentPanel:SetPos( ScrW()*0.9-self.contentPanel:GetWide(), (ScrH()/2)-(self.contentPanel:GetTall()/2) )
    self.contentPanel.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( 0, 0, w, h )

        PROJECT0.FUNC.BeginShadow( "menu_weaponcustomiser_content" )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 1 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_weaponcustomiser_content", x, y, 1, 1, 1, 255, 0, 0, false )
    end
    self.contentPanel.SetActivePage = function( self2, pageKey )
        return self:SetActivePage( pageKey )
    end

    self:AddPage( PROJECT0.L( "dashboard" ), vgui.Create( "pz_weaponcustomiser_page_dashboard", self.contentPanel ), "project0/icons/dashboard.png" )
    self:AddPage( PROJECT0.L( "armory" ), vgui.Create( "pz_weaponcustomiser_page_armory", self.contentPanel ), "project0/icons/armory.png" )
    self:AddPage( PROJECT0.L( "inventory" ), vgui.Create( "pz_weaponcustomiser_page_inventory", self.contentPanel ), "project0/icons/inventory.png" )
    self:AddPage( PROJECT0.L( "store" ), vgui.Create( "pz_weaponcustomiser_page_store", self.contentPanel ), "project0/icons/store.png" )

    self:SetActivePage( 1 )
end

function PANEL:AddPage( title, panel, icon )
    local key = #self.pages+1
    panel:SetVisible( false )
    panel:Dock( FILL )
    panel:SetSize( self.contentPanel:GetSize() )
    if( panel.FillPanel ) then panel:FillPanel() end

    local iconMat = Material( icon, "noclamp smooth" )
    local iconSize = PROJECT0.FUNC.ScreenScale( 20 )

    local pageButton = vgui.Create( "DButton", self.sidePanel )
    pageButton:Dock( TOP )
    pageButton:DockMargin( PROJECT0.UI.Margin25, 0, PROJECT0.UI.Margin25, PROJECT0.UI.Margin15 )
    pageButton:SetTall( PROJECT0.FUNC.ScreenScale( 40 ) )
    pageButton:SetText( "" )
    pageButton.Paint = function( self2, w, h )
        -- Background
        PROJECT0.FUNC.BeginShadow( "menu_btn_" .. title )
        local x, y = self2:LocalToScreen( 0, 0 )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2 ) )
        surface.DrawRect( x, y, w, h )
        PROJECT0.FUNC.EndShadow( "menu_btn_" .. title, x, y, 1, 1, 1, 255, 0, 0, false )

        -- Click effects
        local clickPercent = math.Clamp( (CurTime()-(self2.lastClicked or 0))/0.2, 0, 1 )
        if( self2.lastClicked and self2.lastClicked+0.2 > CurTime() ) then
            local offset = 15
            local startX = math.Clamp( (clickPercent-0.5)*2, 0, 1 )*(w+offset)

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            draw.NoTexture()
            surface.DrawPoly( {
                { x = startX, y = 0 },
                { x = ((clickPercent*2)*w)+offset, y = 0 },
                { x = (clickPercent*2)*w, y = h },
                { x = startX-offset, y = h }
            } )
        end

        if( self.activePage == key ) then
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4, clickPercent*25 ) )
            surface.DrawRect( 0, 0, w, h )
        end

        -- Border and hover effects
        if( self2:IsHovered() or self.activePage == key ) then
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)+3, 0, 100 )
        else
            self2.hoverPercent = math.Clamp( (self2.hoverPercent or 0)-3, 0, 100 )
        end

        local borderR = 2
        local borderL = PROJECT0.FUNC.ScreenScale( 20 )

        local hoverPercent = self2.hoverPercent/100
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
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 75 ) )
        surface.SetMaterial( iconMat )
        surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )

        draw.SimpleText( title, "MontserratBold19", w/2, h/2, PROJECT0.FUNC.GetTheme( 3, 200+(55*hoverPercent) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
    pageButton.DoClick = function( self2 )
        self2.lastClicked = CurTime()
        self:SetActivePage( key )
    end

    self.pages[key] = { pageButton, panel }
end

function PANEL:SetActivePage( num )
    if( self.pages[self.activePage] ) then
        self.pages[self.activePage][2]:SetVisible( false )
    end

    self.activePage = num
    self.pages[num][2]:SetVisible( true )

    return self.pages[num][2]
end

function PANEL:Paint( w, h )
    PROJECT0.FUNC.DrawBlur( self, 4, 4 )
end

vgui.Register( "pz_weaponcustomiser_menu", PANEL, "EditablePanel" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
