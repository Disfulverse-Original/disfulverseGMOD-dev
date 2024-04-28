local PANEL = {}

function PANEL:Init()
    self:SetText("")

    self.text = ""
    self.textColor = color_white
    self.textFont = WasiedAdminSystem:Font(30)
    self.lerpVal = 0

end

function PANEL:SetRPos(x, y)
	self:SetPos(WasiedAdminSystem:RespX(x), WasiedAdminSystem:RespY(y))
end

function PANEL:SetRSize(x, y)
	self:SetSize(WasiedAdminSystem:RespX(x), WasiedAdminSystem:RespY(y))
end

function PANEL:GetLibText()
    return self.text
end

function PANEL:SetLibText(text, color, font)
    if IsColor(color) && isstring(text) then
        self.text = text
        self.textColor = color

        if isstring(font) then
            self.textFont = font
        end
    end
end

function PANEL:DoClick()
    if IsValid(self) then
        surface.PlaySound(WasiedAdminSystem.Constants["strings"][28])
    end
end

function PANEL:Paint(w, h)

    if self:IsHovered() then
        self.lerpVal = Lerp(FrameTime()*2, self.lerpVal, self:GetWide()+10)
    else
        self.lerpVal = Lerp(FrameTime(), self.lerpVal, 0)
    end

    draw.RoundedBox(6, 0, 0, w, h, WasiedAdminSystem.Constants["colors"][10])
    draw.RoundedBoxEx(16, 0, 0, self.lerpVal, h, WasiedAdminSystem.Constants["colors"][8], false, true, false, true)
    draw.SimpleText(self.text, self.textFont, w/2, h/2, self.textColor, 1, 1)

end

derma.DefineControl("WASIED_DButton", "WasiedLib DButton", PANEL, "DButton")