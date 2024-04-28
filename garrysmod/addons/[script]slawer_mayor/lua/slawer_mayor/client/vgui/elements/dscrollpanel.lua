--[[  
    Addon: Night Club System
    By: SlownLS & Slawer
]]

local PANEL = {}

function PANEL:Init()
    self.VBar:SetHideButtons(true)
    self.VBar:SetWide(20)

    function self.VBar:Paint(intW, intH)
    end

    function self.VBar.btnGrip:Paint(intW, intH)
        surface.SetDrawColor(Slawer.Mayor.Colors.Blue)
        surface.DrawRect(7, 0, 4, intH)
    end
end

vgui.Register("Slawer.Mayor:DScrollPanel",PANEL,"DScrollPanel")