local PANEL = {}

function PANEL:Init()
    local colors = YAWS.UI.ColorScheme()
    
    self:SetTextColor(colors['text_main'])
    self:SetFont("yaws.6")

    self.DropButton.Paint = function(s, w, h)
        local triangle = {
        	{x = 0, y = (h * 0.3)},
            {x = w * 0.8, y = (h * 0.3)},
        	{x = (w * 0.8) / 2, y = (h * 0.7)},
        }

        YAWS.UI.SetSurfaceDrawColor(colors['text_main'])
    	draw.NoTexture()
    	surface.DrawPoly(triangle)
    end

    self.frameTime = 0
    self.borderColor = YAWS.UI.ColorScheme()['text_entry_border_inactive']

    self.sideShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow = vgui.Create("yaws.shadow", self:GetParent())
    self.bottomShadow:Down()
end

function PANEL:Paint(w, h)
    self.frameTime = RealFrameTime()
    local colors = YAWS.UI.ColorScheme()
    
    -- don't question this
    if(self:IsMenuOpen()) then 
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_active'])
    else
        self.borderColor = YAWS.UI.LerpColor(self.frameTime * 5, self.borderColor, colors['text_entry_border_inactive'])
    end 
    
    draw.RoundedBox(0, 0, 0, w, h, self.borderColor)
    draw.RoundedBox(0, 1, 1, w - 2, h - 2, colors['input_bg'])
    
    self:DrawTextEntryText(colors["text_main"], colors["theme"], colors["theme"])
end

function PANEL:Dim() end -- stub incase i forget to remove any calls that use it 

function PANEL:PerformLayout(w, h)
    local x,y = self:GetPos()
    self.sideShadow:SetPos(x + w, y)
    self.sideShadow:SetSize(3, h)
    
    self.bottomShadow:SetPos(x, y + h)
    self.bottomShadow:SetSize(w + 1, 3)

    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dcombobox.lua#L77
    self.DropButton:SetSize(15, 15)
	self.DropButton:AlignRight(4)
	self.DropButton:CenterVertical()
	DButton.PerformLayout(self, w, h)
end 
function PANEL:OnRemove()
    self.sideShadow:Remove()
    self.bottomShadow:Remove()
end 

vgui.Register("yaws.combo", PANEL, "DComboBox")