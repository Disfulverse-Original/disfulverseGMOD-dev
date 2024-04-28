local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

AccessorFunc(PANEL, "sTitle", "Title", FORCE_STRING)

function PANEL:Init()
    self.dCombo = vgui.Create("DComboBox", self)
    self.dCombo:Dock(BOTTOM)
    self.dCombo:SetDrawLanguageID(false)
    self.dCombo:SetFont("Slawer.Jobs:R15")
    self.dCombo:SetTextColor(color_white)
    self.dCombo:SetSortItems(false)
    function self.dCombo:Paint(intW, intH)
        surface.SetDrawColor(THEME.Primary)
        surface.DrawRect(0, 0, intW, intH)
    end

    function self.dCombo:DoClick()
        if self:IsMenuOpen() then
            return self:CloseMenu()
        end

        self:OpenMenu()
        
        for k, v in pairs(self.Menu:GetCanvas():GetChildren()) do
            v:SetTextColor(color_white)
            v:SetFont("Slawer.Jobs:R15")
            function v:Paint(w, h)
                surface.SetDrawColor(THEME.Tertiary)
                surface.DrawOutlinedRect(0, -1, w, h + 1)

                if self:IsHovered() then
                    surface.SetDrawColor(THEME.Blue)
                    surface.DrawRect(1, 1, w - 2, h - 2)
                end
            end
        end

        function self.Menu:Paint(intW, intH)
            surface.SetDrawColor(THEME.Primary)
            surface.DrawRect(0, 0, intW, intH)
            
            surface.SetDrawColor(THEME.Tertiary)
            surface.DrawRect(0, 0, intW, 1)
        end
    end
end

function PANEL:GetChecked()
    return self.dCombo:GetChecked() or false
end

function PANEL:GetSelected(...)
    return self.dCombo:GetSelected(...)
end

function PANEL:SetChecked(...)
    self.dCombo:SetChecked(...)
end

function PANEL:AddChoice(...)
    self.dCombo:AddChoice(...)
end

function PANEL:Paint(iW, iH)
    draw.SimpleText(self:GetTitle(), "Slawer.Jobs:R20", 0, iH * 0.25, color_white, 0, 1)
end

function PANEL:PerformLayout(iW, iH)
    self.dCombo:SetTall(iH * 0.5)
end

vgui.Register("Slawer.Jobs:DComboBox", PANEL, "DPanel")