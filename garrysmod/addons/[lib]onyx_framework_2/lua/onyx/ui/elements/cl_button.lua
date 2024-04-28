--[[

Author: tochnonement
Email: tochnonement@gmail.com

16/04/2022

--]]

PANEL = {}

AccessorFunc(PANEL, 'm_colIdle', 'ColorIdle')
AccessorFunc(PANEL, 'm_colHover', 'ColorHover')
AccessorFunc(PANEL, 'm_colPressed', 'ColorPressed')
AccessorFunc(PANEL, 'm_colGradient', 'ColorGradient')

-- local COLOR_SCHEMA = {
--     ['common'] = {
--         m_colIdle = onyx.OffsetColor( onyx:Color('colors.secondary') ),
--         m_colHover = onyx.OffsetColor(onyx.colors.PrimaryLight, 10),
--         m_colPressed = onyx.OffsetColor(onyx.colors.PrimaryLight, 20)
--     },
--     ['disabled'] = {
--         m_colIdle = Color(40, 40, 40),
--         m_colHover = Color(40, 40, 40),
--         m_colPressed = Color(40, 40, 40)
--     }
-- }

local function applyColorSchema(panel, id)
    local data = COLOR_SCHEMA[id]
    if data then
        for k, v in pairs(data) do
            panel[k] = v
        end

        panel.m_colCurrent = onyx.CopyColor(data.m_colIdle)
    end
end

local colorAccent = onyx:Config('colors.accent')

function PANEL:Init()
    self:Import('click')
    self:Import('hovercolor')
    self:SetTall(ScreenScale(10))
    self:CenterText()

    local _SetColorIdle = self.SetColorIdle
    self.SetColorIdle = function(panel, color)
        _SetColorIdle(panel, color)

        local h, s, v = ColorToHSV(color)
        if (v > .5) then
            panel:SetTextColor(color_black)
        else
            panel:SetTextColor(color_white)
        end
    end

    self:SetColorKey('backgroundColor')
    self:SetColorIdle(colorAccent)
    -- self:SetColorHover(onyx.OffsetColor(self:GetColorIdle(), -80))
    self:SetColorHover(onyx.ColorEditHSV(self:GetColorIdle(), nil, nil, .66))

    -- applyColorSchema(self, 'common')
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self.backgroundColor)
end

onyx.gui.Register('onyx.Button', PANEL, 'onyx.Label')

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .4, .65, function(self)
--     self:MakePopup()

--     for i = 1, 10 do
--         local btn = self:Add('onyx.Button')
--         btn:Dock(TOP)
--         btn:SetText('Button #' .. i)
--         btn.DoClickInternal = function()
            
--         end
--         btn.DoClick = function()
--             print('test')
--         end

--         if i % 2 == 0 then
--             btn:SetDisabled(true)
--         end
--     end
-- end)