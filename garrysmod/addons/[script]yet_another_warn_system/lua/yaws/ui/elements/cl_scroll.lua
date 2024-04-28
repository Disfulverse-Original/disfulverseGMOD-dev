-- Scroll Panel
local PANEL = {}

function PANEL:Init()
    local colors = YAWS.UI.ColorScheme()

    self.vBar = self:GetVBar()
    self.vBar:SetWide(3)
    self.vBar:SetHideButtons(true)
    self.vBar.bgClr = colors['scroll_bg']
    self.vBar.gripClr = colors['scroll_grip']
    self.vBar.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, s.bgClr)
    end
    self.vBar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, self.vBar.gripClr)
    end
end

function PANEL:Paint(w, h) end

vgui.Register("yaws.scroll", PANEL, "DScrollPanel")