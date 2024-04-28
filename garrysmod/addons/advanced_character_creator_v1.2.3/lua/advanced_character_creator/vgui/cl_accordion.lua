--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

local PANEL = {}

function PANEL:Init()
    self:SetButtonTall(ACC2.ScrH*0.05)
    self:SetTextFont("ACC2:Font:17")
    self:SetRightTextFont("ACC2:Font:17")
    self:SetArrowFont("ACC2:Font:16")
    self.ACC2Text = ACC2.GetSentence("noText")
    self.ACC2Deploy = false
    self.ACC2SizeY = ACC2.ScrH*0.15
    self.ACC2Params = {}
    self.ACC2SizeYPanel = 0
    self.ACC2HoveredAlpha = 0
    self.ACC2HoveredAlpha2 = 0
    self.ACC2CanInteract = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
    
        self.Button = vgui.Create("DButton", self)
        self.Button:SetSize(self:GetWide(), self.ACC2ButtonSizeY)
        self.Button:SetText("")
        self.Button.Paint = function() end
        self.Button.DoClick = function()
            if not self.ACC2CanInteract then return end

            self:Deploy(self.ACC2SizeY)
        end
    end)
end

function PANEL:SetSizeY(number, notDeploy, bool)
    self.ACC2Base = bool
    self.ACC2SizeY = self.ACC2SizeY - self.ACC2SizeYPanel + number
    self.ACC2SizeYPanel = number

    if not notDeploy then
        self:Deploy(self.ACC2SizeY)
    end
end

function PANEL:Paint(w,h)
    self.ACC2HoveredAlpha = Lerp(FrameTime()*3, (self.ACC2HoveredAlpha or 0), 20)
    self.ACC2HoveredAlpha2 = Lerp(FrameTime()*3, (self.ACC2HoveredAlpha2 or 0), 245)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

    draw.RoundedBox(0, 0, 0, w, self.ACC2ButtonSizeY, ColorAlpha(ACC2.Colors["white20"], self.ACC2HoveredAlpha))
    draw.RoundedBox(0, 0, self.ACC2ButtonSizeY, w, h, ACC2.Colors["white2"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */
    
    if IsValid(self.Button) then
        local white = ColorAlpha(ACC2.Colors["white"], self.ACC2HoveredAlpha2)
        draw.DrawText(ACC2.GetSentence(self.ACC2Text), self.ACC2TextFont, ACC2.ScrW*0.007, (self.ACC2ButtonSizeY - self.ACC2TextFontSizeY)/2, white, TEXT_ALIGN_LEFT)
    
        draw.DrawText("▼", self.ACC2ArrowFont, w-ACC2.ScrW*0.016, (self.ACC2ButtonSizeY - self.SetArrowFontSizeY)/2, ACC2.Colors["grey30"], TEXT_ALIGN_LEFT)
    
        if isstring(self.ACC2RightText) then
            draw.DrawText(self.ACC2RightText, self.ACC2RightTextFont, w-ACC2.ScrW*0.017-self.ACC2RightTextSizeX, (self.ACC2ButtonSizeY - self.SetRightTextFontSizeY)/2, white, TEXT_ALIGN_LEFT)
        end
    end
end

function PANEL:SetText(text)
    self.ACC2Text = text
end

function PANEL:SetInteract(bool)
    self.ACC2CanInteract = bool
end

function PANEL:SetRightText(text)
    surface.SetFont("ACC2:Font:17")
    self.ACC2RightText, self.ACC2RightTextSizeX, self.ACC2RightTextSizeY = text, surface.GetTextSize(text)
end

function PANEL:SetTextFont(fontName)
    self.ACC2TextFont = fontName

    surface.SetFont(fontName)
    self.ACC2TextFontSizeY = select(2, surface.GetTextSize("AAA"))
end

function PANEL:SetRightTextFont(fontName)
    self.ACC2RightTextFont = fontName

    surface.SetFont(fontName)
    self.SetRightTextFontSizeY = select(2, surface.GetTextSize("AAA"))
end

function PANEL:SetArrowFont(fontName)
    self.ACC2ArrowFont = fontName

    surface.SetFont(fontName)
    self.SetArrowFontSizeY = select(2, surface.GetTextSize("▼"))
end

function PANEL:SetButtonTall(y)

    if IsValid(self.Button) then
        self.Button:SetTall(y)
    end
    self.ACC2ButtonSizeY = y
end

function PANEL:InitializeCategory(name, panelLink, letOpen, editVehicle)
    if not istable(ACC2.ParametersConfig[name]) then return end

    local borderX, borderY = ACC2.ScrW*0.0034, ACC2.ScrH*0.005
    local sizeToSet = 0

    if istable(self.ACC2Params) && #self.ACC2Params != 0 then
        for k,v in ipairs(self.ACC2Params) do
            if not IsValid(v) then continue end

            v:Remove()
        end
    end
    
    for line, elements in ipairs(ACC2.ParametersConfig[name]) do
        local numberElements = #elements

        local sizeYUp = 0
        for k, v in ipairs(elements) do
            local sizeX = math.Round(self:GetWide()/numberElements - borderX - borderX/numberElements)
            local sizeY = self.ACC2ButtonSizeY+borderY*(line==1 and 1 or line)+((line-1)*self.ACC2ButtonSizeY)

            local posX = math.Round(sizeX*(k-1) + (borderX*k))

            local dPanel = vgui.Create("DPanel", self)
            dPanel:SetPos(posX-ACC2.ScrW*0.00001, sizeY)
            dPanel.Paint = function(_,w,h)
                dPanel:SetSize(sizeX, v.sizeYPanel and ACC2.ScrH*v.sizeYPanel + self.ACC2SizeYPanel or self.ACC2ButtonSizeY)
            
                local text = ACC2.GetSentence(v.text)
                if text == "" or text == "Lang Problem" then
                    text = v.text
                end

                draw.DrawText(text, "ACC2:Font:18", ACC2.ScrW*0.01, h*0.25, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

                if not v.disableBackgroundColor then
                    draw.RoundedBox(4,0,0,w,h,ACC2.Colors["white2"])
                end
            end

            local params = vgui.Create(v.class, dPanel)
            params:SetSize(ACC2.ScrW*v.sizeX, ACC2.ScrH*v.sizeY)
            params:SetPos(ACC2.ScrW*v.posX, ACC2.ScrH*v.posY)
            if isfunction(v.func) then
                local succ, err = pcall(function() v.func(params, panelLink, editVehicle, self) end)
                if not succ then
                    print(err)
                end
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

            sizeYUp = sizeYUp + (v.sizeYPanel and ACC2.ScrH*v.sizeYPanel + self.ACC2SizeYPanel or self.ACC2SizeYPanel )

            self.ACC2Params[#self.ACC2Params + 1] = dPanel
        end

        sizeToSet = sizeToSet + (sizeYUp == 0 and self.ACC2ButtonSizeY or sizeYUp) + borderY
    end
    
    self.ACC2SizeY = sizeToSet + borderY

    if not letOpen then
        self:Deploy(sizeToSet + borderY)
    end
end

function PANEL:Deploy(size, force, noAnim)
    self.ACC2Deploy = (force and force or !self.ACC2Deploy)
    
    self:SizeTo(-1, self.ACC2ButtonSizeY + (self.ACC2Deploy and (self.ACC2Base and self.ACC2SizeYPanel or size) or 0), (noAnim and 0 or 0.5))
end

derma.DefineControl("ACC2:Accordion", "ACC2 Accordion", PANEL)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
