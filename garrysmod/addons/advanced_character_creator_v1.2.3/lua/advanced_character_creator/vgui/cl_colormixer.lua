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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
  
local function slider()
    local slider = vgui.Create("Panel")
    slider.BarX = 0
    slider.Material = ACC2.Materials["colorsBar"]

    function slider:PrePaint(w, h)
        ACC2.RoundedTextureRect(4, 0, 0, w, h, self.Material, ACC2.Colors["white"])
    end

    function slider:Paint(w, h)
        self:PrePaint(w, h)
        
        ACC2.MaskStencil(function()
            ACC2.DrawCircle(self.BarX-h/2, h/2, h*0.3, h*0.3, 360, ACC2.Colors["white"])
        end, function()
            ACC2.DrawCircle(self.BarX-h/2, h/2, h*0.4, h*0.4, 360, ACC2.Colors["white"])
        end, true)
    end

    function slider:OnCursorMoved(x, y)
        if not input.IsMouseDown(MOUSE_LEFT) then return end

        local color = self:GetPosColor(x, y)
        if color then
            self.Color = color
            self:OnChange(color)
        end

        self.BarX = math.Clamp(x, 0, self:GetWide()-2)
    end

    function slider:GetBarX()
        return self.BarX/self:GetWide()
    end

    function slider:SetBarX(x)
        self.BarX = math.Clamp(self:GetWide()*x, 0, self:GetWide()-2)
    end

    function slider:OnMousePressed(code)
        self:MouseCapture(true)
        self:OnCursorMoved(self:CursorPos())
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

    function slider:OnMouseReleased(code)
        self:MouseCapture(false)
        self:OnCursorMoved(self:CursorPos())
    end

    function slider:GetPosColor(x, y)
        local w = x/self:GetWide()*self.Material:Width()
        local h = y/self:GetTall()*self.Material:Height()

        w = math.Clamp(w, 0, self.Material:Width()-1)
        h = math.Clamp(h, 0, self.Material:Height()-1)

        return self.Material:GetColor(w, h), w, h
    end

    return slider
end

function PANEL:Init()
    self:SetSize(ACC2.ScrW*0.2, ACC2.ScrH*0.35)

    self.colorCube = vgui.Create("DColorCube", self)
    self.colorCube:Dock(FILL)
    self.colorCube.PaintOver = nil
    self.colorCube.Knob:SetSize(10, 10)
    self.colorCube.Knob.Paint = function(panel, w, h)
        ACC2.MaskStencil(function()
            ACC2.DrawCircle(w/2, h/2, w/2.5, 0, 360, ACC2.Colors["white"])
        end, function()
            ACC2.DrawCircle(w/2, h/2, w/2, 0, 360, ACC2.Colors["white"])
        end, true)
    end

    local colorCube = self.colorCube
    
    function colorCube.BGValue:Paint(w, h)
        ACC2.MaskStencil(function()
            ACC2.DrawRoundedRect(4, 0, 0, w, h)
        end, function()
            self:PaintAt(0, 0, w, h)
        end)
    end

    function colorCube.BGSaturation:Paint(w, h)
        ACC2.MaskStencil(function()
            ACC2.DrawRoundedRect(4, 0, 0, w, h)
        end, function()
            self:PaintAt(0, 0, w, h)
        end)
    end
    
    function colorCube:Paint(w, h)
        ACC2.MaskStencil(function()
            ACC2.DrawRoundedRect(4, 0, 0, w, h)
        end, function()
            surface.SetDrawColor(self.m_BaseRGB.r, self.m_BaseRGB.g, self.m_BaseRGB.b, 255)
            self:DrawFilledRect()
        end)
    end
    
    local barsContainer = vgui.Create("Panel", self)
    barsContainer:Dock(BOTTOM)
    barsContainer:DockMargin(0, 0, 0, -ACC2.ScrH*0.004)
    barsContainer:SetZPos(1)
    barsContainer:InvalidateParent(true)
    barsContainer:SetTall(ACC2.ScrH*0.026)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

    local colorBar = slider()
    colorBar:SetParent(barsContainer)
    colorBar:Dock(TOP)
    colorBar:InvalidateParent(true)
    colorBar:DockMargin(0, ACC2.ScrH*0.004, 0, -ACC2.ScrH*0.004)
    colorBar:SetTall(barsContainer:GetTall()*0.4)

    function colorBar:OnChange(color)
        local sX, sY = colorCube:GetSlideX(), colorCube:GetSlideY()
        colorCube:SetColor(color)

        colorCube:SetSlideX(sX)
        colorCube:SetSlideY(sY)
    end

    local saturationBar = slider()
    saturationBar:SetParent(barsContainer)
    saturationBar:Dock(BOTTOM)
    saturationBar:InvalidateParent(true)
    saturationBar:SetTall(barsContainer:GetTall()*0.3)
    saturationBar.Material = ACC2.Materials["gratientBar"]
    
    function colorCube:GetColorAt(x, y)
        x = x or self:GetSlideX()
        y = y or self:GetSlideY()
        return HSVToColor(ColorToHSV(self.m_BaseRGB), 1-x, 1-y)
    end

    function saturationBar:PrePaint(w, h)
        ACC2.DrawRoundedRect(4, 0, 0, w, h, ACC2.Colors["white"])
        ACC2.RoundedTextureRect(4, 0, 0, w, h, self.Material, colorCube:GetColorAt(0))
    end
    
    function saturationBar:OnChange(color)
        colorCube:SetSlideX(1-saturationBar:GetBarX())
    end

    function colorCube:OnUserChanged(color)
        saturationBar:SetBarX(1-self:GetSlideX())
    end
    
    function colorCube:SetColorG(color)
        self:SetColor(color)
        saturationBar:SetBarX(1-self:GetSlideX())
    end
    
    local colorsContainer = vgui.Create("Panel", self)
    colorsContainer:Dock(BOTTOM)
    colorsContainer:DockMargin(0, ACC2.ScrW*0.007, 0, ACC2.ScrW*0.004)
    colorsContainer:SetTall(ACC2.ScrH*0.1225)
    colorsContainer:InvalidateParent(true)  

    local layout = vgui.Create("DIconLayout", colorsContainer)
    layout:Dock(FILL)
    layout:InvalidateParent(true)
    layout:SetSpaceX(ACC2.ScrW*0.0024)
    layout:SetSpaceY(ACC2.ScrH*0.004)
    layout.Items = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

    local cols = 10
    local rows = math.ceil(#ACC2.ColorPaletteColors/cols)

    for i, v in ipairs(ACC2.ColorPaletteColors) do
        local item = vgui.Create("DButton", layout)
        item:SetSize(ACC2.ScrH*0.021, ACC2.ScrH*0.021)
        item:SetText("")
        function item:DoClick()
            colorCube:SetColorG(v)
            colorCube.OnUserChanged(colorCube)
        end

        function item:Paint(w, h)
            ACC2.DrawCircle(w/2, h/2, h*0.5, 0, 360, v)
        end
        layout.Items[#layout.Items + 1] = item
    end

    self:SetColor(ACC2.Colors["white"])

    return frame
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

function PANEL:GetColor()
    return (self.colorCube:GetRGB() or ACC2.Colors["white"])
end

function PANEL:SetColor(color)
    self.colorCube:SetRGB(color or ACC2.Colors["white"])
    self.colorCube:SetColor(color or ACC2.Colors["white"])
    self.colorCube.OnUserChanged(self.colorCube)
end

function PANEL:Paint() end

derma.DefineControl("ACC2:ColorPicker", "ACC2 ColorPicker", PANEL, "DPanel")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
