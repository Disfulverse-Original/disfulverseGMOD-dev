--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetPopupWide( ScrW()*0.4 )
    self:SetExtraHeight( ScrH()*0.4 )
    self:SetHeader( "POPUP CONFIG" )
end

function PANEL:FinishSetup()
    self.sectionMargin = PROJECT0.FUNC.ScreenScale( 25 )
    self.sectionWide = (self:GetPopupWide()-(3*self.sectionMargin))/2

    local margin10 = PROJECT0.FUNC.ScreenScale( 10 )
    local iconSize = PROJECT0.FUNC.ScreenScale( 24 )
    self.fieldHeaderH = PROJECT0.FUNC.ScreenScale( 50 )
    local arrowMat = Material( "project0/icons/down.png" )

    self.fieldsBack = vgui.Create( "pz_scrollpanel", self )
    self.fieldsBack:Dock( RIGHT )
    self.fieldsBack:DockMargin( 0, self.sectionMargin, self.sectionMargin, self.sectionMargin )
    self.fieldsBack:SetWide( self.sectionWide )
    self.fieldsBack.Paint = function() end
    self.fieldsBack.AddField = function( self2, name, description, iconMat, noExpandable ) 
        local fieldPanel = vgui.Create( "DPanel", self2 )
        fieldPanel:Dock( TOP )
        fieldPanel:SetSize( self.sectionWide-margin10-10, self.fieldHeaderH )
        fieldPanel:DockMargin( 0, 0, margin10, margin10 )
        fieldPanel.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
            surface.DrawRect( 0, 0, w, h )
        end
        fieldPanel.SetExpanded = function( self2, expanded )
            self2.expanded = expanded

            self2:SizeTo( self2:GetWide(), expanded and self2.fullHeight or self.fieldHeaderH, 0.2 )
            self2.header:DoRotationAnim( expanded )
        end
        fieldPanel.SetExtraHeight = function( self2, extraHeight )
            self2.fullHeight = self.fieldHeaderH+extraHeight

            if( self2.expanded ) then 
                self2:SetTall( self2.fullHeight )
                return 
            end

            self2:SetExpanded( true )
        end
        
        local expandable = noExpandable != true
        
        fieldPanel.header = vgui.Create( expandable and "DButton" or "Panel", fieldPanel )
        fieldPanel.header:Dock( TOP )
        fieldPanel.header:SetTall( self.fieldHeaderH )
        if( expandable ) then fieldPanel.header:SetText( "" ) end
        fieldPanel.header.Paint = function( self2, w, h )
            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+(self2.alpha or 0) ) )
            surface.DrawRect( 0, 0, w, self.fieldHeaderH )

            if( expandable ) then
                self2:CreateFadeAlpha( 0.2, 155 )

                PROJECT0.FUNC.DrawClickFade( self2, w, h, PROJECT0.FUNC.GetTheme( 3, 5 ) )

                surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
                surface.SetMaterial( arrowMat )
                surface.DrawTexturedRectRotated( w-(self.fieldHeaderH-iconSize)/2-iconSize/2, self.fieldHeaderH/2, iconSize, iconSize, math.Clamp( (self2.textureRotation or 0), -90, 0 ) )
            end

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( h/2-iconSize/2, h/2-iconSize/2, iconSize, iconSize )

            draw.SimpleText( name, "MontserratBold22", h, h/2+1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
            draw.SimpleText( description, "MontserratMedium20", h, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
        end
        fieldPanel.header.textureRotation = 0
        fieldPanel.header.DoRotationAnim = function( self2, expanding )
            local anim = self2:NewAnimation( 0.2, 0, -1 )
        
            anim.Think = function( anim, pnl, fraction )
                if( expanding ) then
                    self2.textureRotation = (1-fraction)*-90
                else
                    self2.textureRotation = fraction*-90
                end
            end
        end
        fieldPanel.header.DoClick = function( self2 )
            fieldPanel:SetExpanded( not fieldPanel.expanded )
        end

        return fieldPanel
    end
end

function PANEL:AddField( name, description, iconMat, noExpandable ) 
    return self.fieldsBack:AddField( name, description, iconMat, noExpandable ) 
end

function PANEL:SetInfo( title, description, iconMat )
    local margin10 = PROJECT0.FUNC.ScreenScale( 10 )

    self.infoBack = vgui.Create( "DPanel", self )
    self.infoBack:SetSize( self.sectionWide, PROJECT0.FUNC.ScreenScale( 110 ) )
    self.infoBack:SetPos( self.sectionMargin, self.mainPanel.targetH-self.sectionMargin-self.infoBack:GetTall() )
    self.infoBack.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 50 ) )
        surface.DrawRect( 0, 0, w, h )
    end

    local itemInfo = vgui.Create( "DPanel", self.infoBack )
    itemInfo:Dock( TOP )
    itemInfo:SetTall( PROJECT0.FUNC.ScreenScale( 50 ) )
    itemInfo.Paint = function( self2, w, h )
        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100 ) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 3, 100 ) )
        surface.SetMaterial( iconMat )
        local iconSize = PROJECT0.FUNC.ScreenScale( 24 )
        surface.DrawTexturedRect( (h/2)-(iconSize/2), (h/2)-(iconSize/2), iconSize, iconSize )

        draw.SimpleText( title, "MontserratBold22", h, h/2+1, PROJECT0.FUNC.GetTheme( 4 ), 0, TEXT_ALIGN_BOTTOM )
        draw.SimpleText( description, "MontserratMedium20", h, h/2-1, PROJECT0.FUNC.GetTheme( 3, 100 ) )
    end

    self.infoBottom = vgui.Create( "DPanel", self.infoBack )
    self.infoBottom:Dock( FILL )
    self.infoBottom:SetTall( self.infoBack:GetTall()-itemInfo:GetTall() )
    self.infoBottom.Paint = function( self2, w, h ) end
    self.infoBottom.AddButton = function( self2, text, iconMat, doClick )
        local iconSize = PROJECT0.FUNC.ScreenScale( 24 )
        surface.SetFont( "MontserratBold20" )

        local button = vgui.Create( "DButton", self2 )
        button:Dock( RIGHT )
        button:DockMargin( 0, margin10, margin10, margin10 )
        button:SetWide( self2:GetTall()-(2*margin10)+surface.GetTextSize( text )+margin10 )
        button:SetText( "" )
        button.Paint = function( self2, w, h )
            self2:CreateFadeAlpha( 0.2, 50 )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 2, 100+self2.alpha ) )
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( PROJECT0.FUNC.GetTheme( 4 ) )
            surface.DrawRect( 0, h-2, w, 2 )

            local textColor = PROJECT0.FUNC.GetTheme( 3, 100+(self2.alpha/50)*155 )

            surface.SetDrawColor( textColor )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( (h/2)-(iconSize/2), (h/2)-(iconSize/2), iconSize, iconSize )

            draw.SimpleText( text, "MontserratBold20", h, h/2, textColor, 0, TEXT_ALIGN_CENTER )
        end
        button.DoClick = doClick
    end
end

function PANEL:AddActionButton( text, iconMat, doClick )
    self.infoBottom:AddButton( text, iconMat, doClick )
end

vgui.Register( "pz_config_popup", PANEL, "pz_popup_base" )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
