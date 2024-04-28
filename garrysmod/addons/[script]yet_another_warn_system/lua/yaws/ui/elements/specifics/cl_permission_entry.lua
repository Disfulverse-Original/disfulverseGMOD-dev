local PANEL = {}

AccessorFunc(PANEL, "name", "Name", FORCE_STRING)

function PANEL:Init()
    self.name = "Unnamed"

    self.element = vgui.Create("yaws.switch", self)
    self.element:SetColor(YAWS.UI.ColorScheme()['theme'])
    self.element.OnToggle = function(val)
        self.OnChange(val)
    end 
end 

function PANEL:Paint(w, h)
    local colors = YAWS.UI.ColorScheme()
    
    draw.SimpleText(self.name, "yaws.7", 10, h / 2, colors["text_header"], 0, 1)
end

function PANEL:SetValue(val)
    self.element:SetValue(val)
end 
function PANEL:GetValue(val)
    return self.element:GetValue()
end 

function PANEL:GetReccomendedHeight()
    surface.SetFont("yaws.7")
    local _,titleHeight = surface.GetTextSize(self.name)
    return titleHeight + 20
end
function PANEL:UseReccomendedHeight()
    self:SetHeight(self:GetReccomendedHeight())
end 

function PANEL:PerformLayout(w, h)
    self.element:Dock(RIGHT)
    self.element:SetWide(math.max(30, w * 0.11))
    self.element:DockMargin(10, (h / 4), 10, (h / 4))
end 

function PANEL:OnChange(val)
end 

vgui.Register("yaws.permissions_entry", PANEL, "DPanel")