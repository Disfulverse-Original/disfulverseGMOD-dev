local THEME = Slawer.Jobs.CFG["Theme"]

local PANEL = {}

AccessorFunc(PANEL, "cBackground", "BackgroundColor")

function PANEL:Init()
    self.sText = ""
    self.cBackground = THEME.Blue
    self.iRoundness = 0
    self.iLerp = 0

    self:SetText("")
    self:SetFont("Slawer.Jobs:R20")
    self:SetTextColor(color_white)

    function self:SetText(sText)
        self.sText = sText
    end

    function self:GetText() return self.sText end
end

function PANEL:SetRoundness(iRoundness)
    self.iRoundness = math.Clamp(iRoundness, 0, self:GetTall() * 0.5)
end

function PANEL:GetRoundness()
    return self.iRoundness
end

function PANEL:Paint(iW, iH)
    self.iLerp = Lerp(RealFrameTime() * 8, self.iLerp, self:IsHovered() and 75 or 0)

    draw.RoundedBox(self:GetRoundness(), 0, 0, iW, iH, self:GetBackgroundColor())
    draw.RoundedBox(self:GetRoundness(), 0, 0, iW, iH, Color(0, 0, 0, self.iLerp))

    draw.SimpleText(self:GetText(), self:GetFont(), iW *.5, iH *.5, self:GetTextColor(), 1, 1)
end

vgui.Register("Slawer.Jobs:DButton", PANEL, "DButton")