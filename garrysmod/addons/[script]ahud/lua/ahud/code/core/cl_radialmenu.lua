local PANEL = {}

function PANEL:Init()
    ahud.radMenuOpened = true

    local size = ScrH() * 0.66

    self:SetSize(size, size)
    self:MakePopup()
    self:Center()

    local button = vgui.Create("DButton", self)
    button:SetText(language.GetPhrase("GameUI_Close"))
    button:SetFont("ahud_25")
    button:Center()
    button:SetTextColor(ahud.Colors.C230)
    button:ahud_AlphaHover(120)
    self.button = button

    local s = self
    function button:DoClick()
        s:AltRemove()
    end

    function button:Paint(w, h)
        surface.SetDrawColor(ahud.ColorTo(ahud.Colors.HUD_Background, ahud.Colors.HUD_Bar, self.perc or 0))
        surface.DrawRect(0, 0, w, h)
    end
    ahud.AddHoverTimer(button, 4)
end

function PANEL:AltRemove()
    if self.ahudanim then return end

    self.ahudanim = true
    local center = self:GetWide() / 2

    for k, v in ipairs(self:GetChildren()) do
        v:MoveTo(center - v:GetWide() / 2, center - v:GetTall() / 2, 0.33, 0, 0.3)
        v:AlphaTo(0, 0.15)
    end

    timer.Simple(0.33, function()
        // why it would happens ?
        if IsValid(self) then
            self:Remove()
        end
    end)
end

function PANEL:OnRemove()
    ahud.radMenuOpened = false
end

function PANEL:BuildPanels(tbl)
    local c = table.Count(tbl)
    local piDiff = (math.pi * 2) / c

    local center = self:GetWide() / 2
    local radSize = center

    local longestText = 0
    local id = 0

    for k, v in ipairs(tbl) do
        local a = string.len(v.txt)
        if a > longestText then
            id = k
            longestText = a
        end
    end

    surface.SetFont("ahud_25")
    local txtW, txtH = surface.GetTextSize(tbl[id].txt)
    txtW = txtW + 20
    txtH = txtH * 1.25 + 20

    self.button:SetSize(txtW, txtH)
    self.button:Center()

    radSize = radSize - txtW / 2

    local s = self
    for i = 0, c-1 do
        local blob = tbl[i + 1]
        local x, y = math.sin(piDiff * i), math.cos(piDiff * i)

        x = x * radSize
        y = y * radSize

        local b = vgui.Create("DButton", self)
        b:SetSize(txtW, txtH)
        b:SetPos(center, center)
        b:SetAlpha(0)
        b:SetText(blob.txt)
        b:SetFont("ahud_25")
        b:SetTextColor(self.button:GetTextColor())
        b:ahud_AlphaHover(120)

        b:MoveTo(center - x - b:GetWide() / 2, center - y - b:GetTall() / 2, 0.33, 0, 0.3)
        b:AlphaTo(255, 0.33, 0)
        b.Paint = self.button.Paint

        function b:DoClick()
            blob.callback()
            s:AltRemove()
        end
    end
end

vgui.Register("ahudRadial", PANEL, "EditablePanel")