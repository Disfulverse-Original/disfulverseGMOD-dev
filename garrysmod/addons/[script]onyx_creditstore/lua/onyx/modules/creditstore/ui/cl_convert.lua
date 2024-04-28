--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/05/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local colorGray = onyx:Config('colors.gray')
local colorBetween = onyx.ColorBetween(colorPrimary, colorSecondary)
local colorMoney = Color(66, 184, 76)
local colorNegative = onyx:Config('colors.negative')

local font0 = onyx.Font('Roboto@24')
local font1 = onyx.Font('Roboto@20')

-- local wimgLongArrow = onyx.wimg.Simple('https://i.imgur.com/Kf3q9WO.png', 'smooth mips')

local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')
function PANEL:Init()
    self.mode = onyx.creditstore:GetOptionValue('converter_mode')

    self.rightBlock = self:Add('Panel')
    self.rightBlock.text = onyx.lang:Get('youReceive')
    self.rightBlock.Paint = function(panel, w, h)
        draw.SimpleText(panel.text, font0, w * .5, h * .25, color_white, 1, 1)

        local current = self.combo.current
        if (current > 0) then
            local amt = onyx.creditstore:CalculateConvertResult(current == 2, tonumber(self.entry:GetValue()) or 0)
            if (current == 2) then
                local iconSize = onyx.ScaleTall(14)
                local textAmount = onyx.creditstore.FormatMoney(amt)
                local textW, textH = onyx.GetTextSize(textAmount, font0)
                local space = onyx.ScaleWide(5)
                local totalW = textW + iconSize + space
                local x = w * .5 - totalW * .5

                local boxW = totalW + onyx.ScaleWide(20)
                local boxH = textH + onyx.ScaleTall(20)

                draw.RoundedBox(8, w * .5 - boxW * .5, h * .5 - boxH * .5, boxW, boxH, colorBetween)
        
                wimgCoin:Draw(x, h * .5 - iconSize * .5, iconSize, iconSize, colorAccent)
                draw.SimpleText(textAmount, font0, x + iconSize + space, h * .5, color_white, 0, 1)
            else
                local textAmount = DarkRP.formatMoney(amt)
                local textW, textH = onyx.GetTextSize(textAmount, font0)

                local boxW = textW + onyx.ScaleWide(20)
                local boxH = textH + onyx.ScaleTall(20)

                draw.RoundedBox(8, w * .5 - boxW * .5, h * .5 - boxH * .5, boxW, boxH, colorBetween)

                draw.SimpleText(textAmount, font0, w * .5, h * .5, colorMoney, 1, 1)
            end
        end
    end

    self.leftBlock = self:Add('Panel')
    self.leftBlock.text = onyx.lang:Get('youGive')
    self.leftBlock.Paint = function(panel, w, h)
        draw.SimpleText(panel.text, font0, w * .5, h * .25, color_white, 1, 1)
    end

    self.entry = self.leftBlock:Add('onyx.TextEntry')
    self.entry:SetPlaceholderText('100')
    self.entry:On('OnLoseFocus', function(panel)
        if (self.combo.current == 2) then
            local rate = onyx.creditstore:GetOptionValue('converter_rate')
            local value = tonumber(panel:GetValue()) or 0
            local receiveAmount = onyx.creditstore:CalculateConvertResult(true, value)
            local giveAmount = math.floor(receiveAmount * rate)
            
            timer.Simple(engine.TickInterval(), function()
                if (IsValid(panel)) then
                    panel:KillFocus()        
                    panel:SetValue(giveAmount)

                    if (giveAmount == 0) then
                        panel:Highlight(colorNegative, 1)
                    end
                end
            end)
        end
    end)

    local first = onyx.lang:Get('credits') .. ' → ' .. onyx.lang:Get('money')
    local second = onyx.lang:Get('money') .. ' → ' .. onyx.lang:Get('credits')

    self.combo = self.leftBlock:Add('onyx.ComboBox')
    self.combo:AddOption(first)
    self.combo:AddOption(second)
    if (self.mode < 3) then
        self.combo:ChooseOptionID(self.mode)
        self.combo:SetDisabled(true)
        -- self.combo:Hide()
    else
        self.combo:ChooseOptionID(1)
    end

    self.button = self.leftBlock:Add('onyx.Button')
    self.button:SetText(onyx.lang:Get('convert'))
    self.button.DoClick = function(panel)
        local amt = tonumber(self.entry:GetValue())
        if (amt and amt > 0) then
            net.Start('onyx.creditstore:Convert')
                net.WriteUInt(amt, 32)
                net.WriteBool(self.combo.current == 2)
            net.SendToServer()
        end
    end

    self.buttonChange = self:Add('onyx.ImageButton')
    self.buttonChange:SetURL('https://i.imgur.com/Kf3q9WO.png', 'smooth mips')
    self.buttonChange:SetDisabled(self.mode ~= 3)
    self.buttonChange.DoClick = function(panel)
        local optionID = self.combo.current
        if (optionID > 0) then
            local oppositeID = (optionID == 1) and 2 or 1
            local oldPrice = tonumber(self.entry:GetValue()) or 0
            local newPrice = onyx.creditstore:CalculateConvertResult(oppositeID == 1, oldPrice)

            self.combo:ChooseOptionID(oppositeID)
            self.entry:SetValue(newPrice)
        end
    end

    local rate = DarkRP.formatMoney(onyx.creditstore:GetOptionValue('converter_rate'))
    self.textConverter = onyx.lang:Get('convert_u')
    self.textRate = onyx.lang:Get('currentRate', {rate = rate})
end

function PANEL:PerformLayout(w, h)
    self.rightBlock:Dock(RIGHT)
    self.rightBlock:SetWide(w * .5)
    self.leftBlock:Dock(FILL)

    local wide = w * .5

    -- children
    local children = {}
    for _, child in ipairs(self.leftBlock:GetChildren()) do
        if (IsValid(child) and child:IsVisible()) then
            table.insert(children, child)
        end
    end

    local amt = #children
    local childTall = onyx.ScaleTall(30)
    local childWide = wide * .5
    local space = onyx.ScaleTall(5)
    local totalH = childTall * amt + space * (amt - 1)
    local childY = h * .5 - totalH * .5

    for _, child in ipairs(children) do
        child:SetSize(childWide, childTall)
        child:SetPos(0, childY)
        child:CenterHorizontal()

        childY = childY + childTall + space
    end

    -- button
    local size = onyx.ScaleTall(24)

    self.buttonChange:SetSize(size, size)
    self.buttonChange:Center()
    -- self.entry:SetWide(wide * .5)

    -- self.combo:SetWide(wide * .5)
    -- self.combo:Center()

    -- self.button:SetWide(wide * .5)
end

function PANEL:Paint(w, h)
    local _, texth = draw.SimpleText(self.textConverter, font0, w * .5, 0, color_white, 1, 0)
    draw.SimpleText(self.textRate, font1, w * .5, texth, colorGray, 1, 0)

    local size = onyx.ScaleTall(24)
    
    -- wimgLongArrow:Draw(w * .5 - size * .5, h * .5 - size * .5, size, size, colorGray)
end

onyx.gui.Register('onyx.creditstore.Converter', PANEL)