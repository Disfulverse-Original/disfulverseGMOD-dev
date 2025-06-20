local PANEL = {}

AccessorFunc(PANEL, "placeholder", "Placeholder")

function PANEL:Init()
    self:SetFont("yaws.6")

    self.frameTime = RealFrameTime()

    self.borderColor = YAWS.UI.ColorScheme()['text_entry_border_inactive']

    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end 

function PANEL:Paint(w, h)
    self.frameTime = RealFrameTime()
    local colors = YAWS.UI.ColorScheme()

    -- don't question this
    if(self:HasFocus()) then 
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_active'])
    else
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_inactive'])
    end 

    draw.RoundedBox(0, 0, 0, w, h, self.borderColor)
    draw.RoundedBox(0, 1, 1, w - 2, h - 2, colors['input_bg'])

    self:DrawTextEntryText(colors["text_main"], colors["theme"], colors["theme"])
    if(self:GetText() == "" && (!self:HasFocus() || !self:IsEnabled())) then 
        draw.SimpleText(self.placeholder, self:GetFont(), h / 4, (!self:IsMultiline()) && h / 2 || 5, colors['text_placeholder'], 0, (!self:IsMultiline()) && 1 || 0)
    end 
end 

function PANEL:PerformLayout(w, h)
    local x,y = self:GetPos()
    self.sideShadow:SetPos(x + w, y)
    self.sideShadow:SetSize(3, h)
    
    self.bottomShadow:SetPos(x, y + h)
    self.bottomShadow:SetSize(w + 1, 3)

    -- old perform layout with a couple of changes - https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumberwang.lua#L177
    local s = math.floor(self:GetTall() * 0.5)
    self.Up:SetSize(s, s - 1)
    self.Up:AlignRight(3)
    self.Up:AlignTop(3)

    self.Down:SetSize(s, s - 1)
    self.Down:AlignRight(3)
    self.Down:AlignBottom(3)
end 
function PANEL:OnRemove()
    self.sideShadow:Remove()
    self.bottomShadow:Remove()
end 

vgui.Register("yaws.wang", PANEL, "DNumberWang") -- hehe wang 