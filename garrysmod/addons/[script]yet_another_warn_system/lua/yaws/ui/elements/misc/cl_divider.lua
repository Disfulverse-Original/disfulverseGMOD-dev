-- Another 'throwaway element' i use as a divider
local PANEL = {}

function PANEL:Init()
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme() 
    draw.RoundedBox(0, 10, 0, w - 20, h, colors['divider'])
end 

function PANEL:PerformLayout()
    self:SetHeight(2)
end 

vgui.Register("yaws.divider", PANEL, "DPanel")