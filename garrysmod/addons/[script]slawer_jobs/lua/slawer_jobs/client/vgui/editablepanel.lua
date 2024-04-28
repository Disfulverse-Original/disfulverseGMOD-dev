local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

AccessorFunc(PANEL, "sTitle", "Title", FORCE_STRING)

function PANEL:Init()
    Slawer.Jobs:GenerateFonts()
    
    self:SetAlpha(0)
    self:AlphaTo(255, 0.25)
    self:MakePopup()

    self.iHeaderH = self:GetTall() * 0.1

    self.startTime = SysTime()

    self.dClose = vgui.Create("DButton", self)
    self.dClose:SetSize(self.iHeaderH, self.iHeaderH)
    self.dClose:SetText("")
    function self.dClose:Paint(iW, iH)
        draw.SimpleText("✕", "Slawer.Jobs:R25", iW * 0.5, iH * 0.5, THEME.Texts, 1, 1)
    end
    function self.dClose:DoClick()
        self:GetParent():Delete()
    end
end

function PANEL:Delete()
    if self.bDeleted then return end

    self.bDeleted = true

    gui.HideGameUI()

    self:AlphaTo(0, 0.25, 0, function()
        if not IsValid(self) then return end

        self:Remove()
    end)
end

function PANEL:Paint(iW, iH)
    if input.IsKeyDown(KEY_ESCAPE) then
        self:Delete()
    end

    Derma_DrawBackgroundBlur(self, self.startTime)

    draw.RoundedBox(16, 0, 0, iW, iH, THEME.Secondary)

    draw.RoundedBoxEx(16, 0, 0, iW, self.iHeaderH, THEME.Primary, true, true, false, false)

    draw.SimpleText(self:GetTitle(), "Slawer.Jobs:R25", iW * 0.5, self.iHeaderH * 0.5, THEME.Texts, 1, 1)
end

function PANEL:PerformLayout(iW, iH)
    self.iHeaderH = self:GetTall() * 0.09

    self.dClose:SetSize(self.iHeaderH, self.iHeaderH)
    self.dClose:SetPos(iW - self.dClose:GetWide(), 0)

    if self.PerformLayout2 then self:PerformLayout2(iW, iH) end 
end

vgui.Register("Slawer.Jobs:EditablePanel", PANEL, "EditablePanel")