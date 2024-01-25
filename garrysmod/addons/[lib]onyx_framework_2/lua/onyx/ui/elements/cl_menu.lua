--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

PANEL = {}

AccessorFunc(PANEL, 'm_bDeleteSelf', 'DeleteSelf')
AccessorFunc(PANEL, 'm_iMinimumWidth', 'MinimumWidth')

local wimgArrow = onyx.wimg.Simple('https://i.imgur.com/KGC51Ws.png', 'smooth mips')
local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local colorGray = Color(155, 155, 155)

function PANEL:Init()
    self.backgroundColor = colorPrimary
    self.outlineColor = colorSecondary
    self.options = {}
    self.submenus = {}

	self:SetDrawOnTop(true)
    self:SetDeleteSelf(true)
    self:SetVisible(false)
    self:SetMinimumWidth(onyx.ScaleWide(120))

    local padding = onyx.ScaleTall(2)

    self:DockPadding(padding, padding, padding, padding)

    self.canvas:SetSpace(0)

	RegisterDermaMenuForClose(self)
end

function PANEL:PerformLayout(_, h)
    local _, padding1, _, padding2 = self:GetDockPadding()
    local _, localY = self:LocalToScreen(0, 0)
	local width = self:GetMinimumWidth()
	local height = padding1 + padding2
    local children = self.canvas:GetPanels()
    local childrenCount = #children

	for index, child in pairs(self.canvas:GetPanels()) do
		height = height + child:GetTall()
    
        if (index < childrenCount) then
            height = height + select(4, child:GetDockMargin())
        end
    
		width = math.max(width, child:GetContentWidth() + onyx.ScaleTall(10))
	end

    if (localY + height) > ScrH() then
        height = ScrH() - localY
    end

	self:SetWide(width)
    self:SetTall(height)

	self.BaseClass.PerformLayout(self, width, height)

    self.scroll:DockMargin(0, 0, 0, 0)
end

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen()

	onyx.bshadows.BeginShadow()
        -- draw.RoundedBox(8, x, y, w, h, self.bgColor)
        -- draw.RoundedBox(8, x, y, w, h, self.bgColor)
        local thickness = 1
    
        draw.RoundedBox(8, x, y, w, h, self.outlineColor)
        draw.RoundedBox(8, x + thickness, y + thickness, w - thickness * 2, h - thickness * 2, self.backgroundColor)
    onyx.bshadows.EndShadow(1, 3, 3)
end

function PANEL:ToCursor()
    self:SetPos(input.GetCursorPos())
end

function PANEL:AddOption(text, callback)
    local button = self:Add('onyx.Button')
    button:SetText(text)

    button.OnMousePressed = function(panel)
        onyx.menuButtonPressTime = CurTime()

        panel:Call('DoClick')

        self:Remove()
    end

    button:On('OnCursorEntered', function(panel)
        self:CloseSubMenu()
    end)

    if callback then
        button.DoClick = callback
    end

    local index = table.insert(self.options, button)
    -- local color = onyx.OffsetColor(self.backgroundColor, index % 2 == 0 and 1 or 0)
    local color = self.backgroundColor
    
    button:SetColorIdle(color)
    button:SetColorHover(onyx.OffsetColor(button:GetColorIdle(), 10))
    button:SetContentAlignment(4)
    button:SetText('')
    button:InjectEventHandler('Paint')
    button:On('Paint', function(panel, w, h)
        local material = panel.wimage and panel.wimage:GetMaterial() or panel.material
        local x = onyx.ScaleWide(10)

        if (material) then
            local size = onyx.ScaleTall(12)

            surface.SetDrawColor(color_white)
            surface.SetMaterial(material)
            surface.DrawTexturedRect(x, h * .5 - size * .5, size, size)

            x = x + size + onyx.ScaleWide(5)
        end

        draw.SimpleText(text, panel:GetFont(), x, h * .5, panel:GetTextColor(), 0, 1)
    end)

    button.GetContentWidth = function(panel)
        surface.SetFont(panel:GetFont())
        local w = surface.GetTextSize(text)
        local material = panel.wimage and panel.wimage:GetMaterial() or panel.material

        w = w + onyx.ScaleWide(10)
    
        if (material) then
            w = w + onyx.ScaleTall(12) + onyx.ScaleWide(5)
        end
        
        if (panel.submenu) then
            w = w + onyx.ScaleTall(12) + onyx.ScaleWide(5)
        end
        
        return w
    end

    button.SetIcon = function(panel, path, params)
        assert(path, 'no path provided')
        assert(isstring(path), 'path should be a string! alternative method: `SetMaterial`')
        panel.material = Material(path, params)
    end

    button.SetMaterial = function(panel, material)
        assert(material, 'no material provided')
        assert(type(material) == 'IMaterial', 'provided argument should be a IMaterial!')
        panel.material = material
    end

    button.SetIconURL = function(panel, url, params)
        assert(url, 'no url provided')
        panel.wimage = onyx.wimg.Simple(url, params)
    end

    -- for index, option in pairs(self.options) do
    --     print(index, option)
    --     if (index == 1 or option == button) then
    --         option.Paint = function(panel, w, h)
    --             draw.RoundedBox(8, 0, 0, w, h, panel.backgroundColor)
    --         end
    --     else
    --         option.Paint = function(panel, w, h)
    --             surface.SetDrawColor(panel.backgroundColor)
    --             surface.DrawRect(0, 0, w, h)
    --         end
    --     end        
    -- end

    return button
end

function PANEL:CloseSubMenu()
    if IsValid(self.activeSubmenu) then
        self.activeSubmenu:Close()
        self.activeSubmenu:CloseSubMenu()
    end
end

function PANEL:AddSubMenu(text)
    local submenu = vgui.Create('onyx.Menu')
    submenu:SetDeleteSelf(false)

    local button = self:AddOption(text)
    button:On('OnCursorEntered', function(panel)
        submenu:SetPos(self:GetX() + self:GetWide(), self:GetY() + panel:GetY())
        submenu:Open()
        submenu.parent = panel

        self.activeSubmenu = submenu
    end)
    button:On('Paint', function(p, w, h)
        local sz = math.floor(h * .33)
        wimgArrow:DrawRotated(w - h * .5, h * .5, sz, sz, 90, color_white)
    end)
    button.submenu = true

    table.insert(self.submenus, submenu)

    return submenu, button
end

function PANEL:Open()
    self:SetVisible(true)
    self:MakePopup()
    self:InvalidateLayout(true)
end

function PANEL:Close()
    if (self.m_bDeleteSelf) then
        self:Remove()
    else
        self:SetVisible(false)
    end
end

function PANEL:OnRemove()
    for _, submenu in pairs(self.submenus) do
        if (IsValid(submenu)) then
            submenu:Remove()
        end
    end
end

onyx.gui.Register('onyx.Menu', PANEL, 'onyx.ScrollPanel')

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .3, .65, function(self)
--     self:MakePopup()

--     local content = self:Add('Panel')
--     content:Dock(FILL)
--     content:DockMargin(5, 5, 5, 5)

--     for i = 1, 10 do
--         local btn = content:Add('onyx.ComboBox')
--         btn:Dock(TOP)
--         btn:DockMargin(0, 0 ,0 ,5)
--         btn.DoClick = function(panel)
--             local x, y = panel:LocalToScreen(0, 0)

--             y = y + panel:GetTall()
    
--             local menu = vgui.Create('onyx.Menu')
--             menu:SetPos(x, y)
--             menu:SetMinimumWidth(panel:GetWide())
--             menu:AddOption('Drop')
--             menu:AddOption('Sell')
    
--             local submenu = menu:AddSubMenu('Destroy')
--             -- submenu:AddOption('Confirm'):SetIcon('icon16/tick.png')
--             -- submenu:AddOption('Cancel'):SetIcon('icon16/cross.png')
--             submenu:AddOption('Confirm'):SetIconURL('https://i.imgur.com/iK1nMwr.png', 'smooth mips')
--             submenu:AddOption('Cancel'):SetIconURL('https://i.imgur.com/TF7kX2N.png', 'smooth mips')
    
--             menu:Open()
--         end
--     end
    
-- end)