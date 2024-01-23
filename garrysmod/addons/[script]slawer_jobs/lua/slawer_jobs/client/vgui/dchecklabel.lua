local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

AccessorFunc(PANEL, "sTitle", "Title", FORCE_STRING)

function PANEL:Init()
    self.dLabel = Label("", self)
    self.dLabel:SetContentAlignment(4)
    self.dLabel:SetFont("Slawer.Jobs:R22")

    self.dCombo = vgui.Create("DCheckBox", self)
    function self.dCombo:Paint(iW, iH)
        surface.SetDrawColor(THEME.Tertiary)
        surface.DrawRect(0, 0, iW, iH)

        if self:GetChecked() then
            surface.SetDrawColor(THEME.Blue)
            surface.DrawRect(0, 0, iW, iH)
            draw.SimpleText("✓", "Slawer.Jobs:R22", iW * 0.5, iH * 0.5 - 1, color_white, 1, 1)
        end
    end
end

function PANEL:GetChecked()
    return self.dCombo:GetChecked()
end

function PANEL:SetChecked(...)
    return self.dCombo:SetChecked(...)
end

function PANEL:Paint(iW, iH)
    surface.SetDrawColor(THEME.Primary)
    surface.DrawRect(0, 0, iW, iH)
end

function PANEL:PerformLayout(iW, iH)
    self.dLabel:SetTextInset(iW * 0.05, 0)

    self.dCombo:SetPos(iW - iH * 0.9, iH * 0.12)
    self.dCombo:SetSize(iH * 0.8, iH * 0.8)

    self.dLabel:SetSize(iW - iH, iH)
end

vgui.Register("Slawer.Jobs:DCheckLabel", PANEL, "DPanel")