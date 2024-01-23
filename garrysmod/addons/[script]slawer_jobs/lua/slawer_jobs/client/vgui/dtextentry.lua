local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

AccessorFunc(PANEL, "sTitle", "Title", FORCE_STRING)

function PANEL:Init()
    self.dEntry = vgui.Create("DTextEntry", self)
    self.dEntry:Dock(BOTTOM)
    self.dEntry:SetDrawLanguageID(false)
    self.dEntry:SetFont("Slawer.Jobs:R15")
    self.dEntry:SetTextColor(color_white)
    self.dEntry:SetUpdateOnType(true)
    function self.dEntry:OnValueChange()
        local dParent = self:GetParent()
        if dParent.Validation then
            dParent.bValid = dParent:Validation(self:GetText())
        end
    end
    function self.dEntry:Paint(iW, iH)
        surface.SetDrawColor(self.cBackground or THEME.Primary)
        surface.DrawRect(0, 0, iW, iH)

        self:DrawTextEntryText(self:GetTextColor(), THEME.Blue, self:GetTextColor())
    end

    self.dValidator = vgui.Create("DPanel", self)
    function self.dValidator:Paint(iW, iH)
        if self:GetParent().bValid then
            surface.SetDrawColor(THEME.Blue)
            surface.DrawRect(0, 0, iW, iH)

            draw.SimpleText("✓", "Slawer.Jobs:R20", iW * 0.5 - 1, iH * 0.5, color_white, 1, 1)
        else
            surface.SetDrawColor(THEME.Red)
            surface.DrawRect(0, 0, iW, iH)

            draw.SimpleText("✕", "Slawer.Jobs:R20", iW * 0.5 - 1, iH * 0.5, color_white, 1, 1)
        end
    end

    function self:SetText(...) self.dEntry:SetText(...) self.dEntry:OnValueChange() end
    function self:GetText() return self.dEntry:GetText() end
end

function PANEL:Paint(iW, iH)
    draw.SimpleText(self:GetTitle(), "Slawer.Jobs:R20", 0, iH * 0.25, color_white, 0, 1)
end

function PANEL:PerformLayout(iW, iH)
    self.dEntry:SetTall(iH * 0.5)
    self.dEntry:DockMargin(0, 0, self.dEntry.customMargin or (iH * 0.5), 0)

    if IsValid(self.dValidator) then
        self.dValidator:SetSize(iH * 0.5, iH * 0.5)
        self.dValidator:SetPos(iW - iH * 0.5, iH * 0.5)
    end
end

vgui.Register("Slawer.Jobs:DTextEntry", PANEL, "DPanel")