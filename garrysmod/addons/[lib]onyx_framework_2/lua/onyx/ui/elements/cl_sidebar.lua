--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/06/2022

--]]

local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local colorHover = onyx.ColorBetween(colorSecondary, colorTertiary)

PANEL = {}

function PANEL:Init()
    self.color = Color(255, 255, 255)
    self.curLineThickness = 0

    self:Import('click')
    self:Import('hovercolor')
    self:SetTall(onyx.ScaleTall(40))
    self:SetColorKey('color')
    self:SetColorIdle(onyx.OffsetColor(onyx:Config('colors.secondary'), 0))
    self:SetColorHover(colorTertiary)
    self:SetColorPressed(onyx:Config('colors.quaternary'))

    self.divIcon = self:Add('onyx.Image')
    self.divIcon:SetImageSize(20, 20)

    self.lblTitle = self:Add('onyx.Label')
    self.lblTitle:SetText('NAME')
    self.lblTitle:SetFont(onyx.Font('Roboto@16'))
    -- self.lblTitle:SetContentAlignment(1)

    -- self.lblDesc = self:Add('onyx.Label')
    -- self.lblDesc:SetText('Description')
    -- self.lblDesc:SetContentAlignment(7)
    -- self.lblDesc:SetFont(onyx.Font('Roboto@14'))
    -- self.lblDesc:SetTextColor(Color(141, 141, 141))
    -- self.lblDesc:SetFont()
end

function PANEL:PerformLayout(w, h)
    self.divIcon:Dock(LEFT)
    self.divIcon:SetWide(h)
    self.lblTitle:Dock(FILL)
    self.lblTitle:SetTall(h * .5)
    -- self.lblDesc:Dock(FILL)

    self.lineThickness = math.ceil(ScreenScale(1))
end

function PANEL:Paint(w, h)
    -- surface.SetDrawColor(self.color)
    -- surface.DrawRect(0, 0, w, h)
    local inset = 0

    draw.RoundedBox(8, inset, inset, w - inset * 2, h - inset * 2, self.color)

    -- surface.SetDrawColor(colorAccent)
    -- surface.DrawRect(0, 0, self.curLineThickness, h)
end

function PANEL:Setup(data)
    assert(data.name, 'The \"name\" field is missing')
    assert(data.desc, 'The \"desc\" field is missing')

    self.lblTitle:SetText(data.name)
    -- self.lblDesc:SetText(data.desc)

    if (data.nameColor) then
        self.lblTitle:SetTextColor(data.nameColor)
    end

    -- if (data.descColor) then
    --     self.lblDesc:SetTextColor(data.descColor)
    -- end

    if (data.iconColor) then
        self.divIcon:SetColor(data.iconColor)
    end

    if data.wimg then
        self.divIcon:SetWebImage(data.wimg, 'smooth mips')
    elseif data.icon then
        self.divIcon:SetURL(data.icon, 'smooth mips')
    end

    self.data = data
end

function PANEL:SetState(bool)
    local target = bool and self.lineThickness or 0

    self:SetHoverBlocked(bool)

    if not bool then
        self:Call('OnCursorExited')
    else
        -- onyx.anim.Remove(self, onyx.anim.ANIM_HOVER)
        -- self.color = colorTertiary
    end

    -- onyx.anim.Create(self, .33, {
    --     index = onyx.anim.ANIM_HOVER,
    --     target = {
    --         [self.m_ColorKey] = colorTertiary
    --     }
    -- })

    onyx.anim.Create(self, .1, {
        index = 44,
        target = {
            curLineThickness = target
        }
    })
end

function PANEL:DoClick()
    self.bool = not self.bool
    self:SetState(self.bool)
end

onyx.gui.Register('onyx.Sidebar.Tab', PANEL)

--[[------------------------------
Main
--------------------------------]]

PANEL = {}

AccessorFunc(PANEL, 'm_pContainer', 'Container')

function PANEL:Init(arguments)
    local padding = onyx.ScaleTall(10)
    
    self.padding = padding
    self.tabs = {}
    
    -- self:DockPadding(padding, padding, padding, padding)
    self:DockPadding(padding, 0, padding, padding)
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(8, 0, 0, w, h, colorSecondary, nil, nil, true)
end

function PANEL:AddTab(data)
    local btnTab = self:Add('onyx.Sidebar.Tab')
    btnTab:Setup(data)
    btnTab:Dock(TOP)
    btnTab:DockMargin(0, 0, 0, onyx.ScaleTall(5))
    btnTab.DoClick = function(panel)
        self:Call('OnTabSelected', nil, panel)
    end

    table.insert(self.tabs, btnTab)
end

function PANEL:ChooseTab(index)
    local tab = self.tabs[index]
    if (tab) then
        self:OnTabSelected(tab)
    end
end

function PANEL:OnTabSelected(panel)
    local data = panel.data

    assert(data, 'No data for a tab')

    if (self.oldTabPanel == panel) then
        return
    end

    if data.onClick and not data.onClick() then
        return
    end

    if IsValid(self.oldTabPanel) then
        self.oldTabPanel:SetState(false)
    end

    panel:Call('OnCursorEntered')
    panel:SetState(true)
    self.oldTabPanel = panel

    local container = self:GetContainer()

    assert(IsValid(container), 'You must link a valid container to the sidebar!')
    assert(data.class, 'The tab must be blocked via `onClick` or create a panel!')

    if IsValid(container.content) then
        container.content:Remove()
    end

    container.content = vgui.Create(data.class)
    container.content:SetParent(container)
    container.content:Dock(FILL)
    -- container.content:SetAlpha(0)
    -- container.content:AlphaTo(255, .1)

    if data.onSelected then
        data.onSelected(container.content)
    end
end

onyx.gui.Register('onyx.Sidebar', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .65, .65, function(self, w, h)
--     local sidebar = self:Add('onyx.Sidebar')
--     sidebar:SetWide(w * .2)
--     sidebar:Dock(LEFT)

--     local container = self:Add('Panel')
--     container:Dock(FILL)

--     -- local between = onyx.ColorBetween(colorSecondary, onyx:Config('colors.primary'))
--     -- local accent = onyx:Config('colors.accent')
--     -- local shade = Color(0, 0, 0, 200)

--     -- local meow = sidebar:Add('Panel')
--     -- meow:Dock(TOP)
--     -- meow:SetTall(ScreenScale(13))
--     -- meow.Paint = function(p, w, h)
--     --     surface.SetDrawColor(accent)
--     --     surface.DrawRect(0, 0, w, h)

--     --     onyx.DrawMatGradient(0, 0, w, h, TOP, shade)
--     -- end

--     -- local avatar = onyx.abstract.SquareInContainer(meow, 'AvatarImage', ScreenScale(22), nil, .8, LEFT)
--     -- avatar:SetPlayer(LocalPlayer(), 64)

--     -- local label = meow:Add('onyx.Label')
--     -- label:SetText(LocalPlayer():Name())
--     -- label:SetTextColor(color_white)
--     -- label:Font('Roboto@16')
--     -- -- label:Shadow(1, 200)
--     -- label:Color(color_black)
--     -- label:Dock(FILL)
--     -- label:AlignText(4)
--     -- label:DockMargin(5, 0, 0, 0)

--     sidebar:SetContainer(container)
--     sidebar:AddTab({
--         name = 'DASHBOARD',
--         desc = 'Main things',
--         wimg = 'dashboard',
--         class = 'DButton',
--         onSelected = function(panel)
--             panel:SetText('Meow')
--         end
--     })
--     sidebar:AddTab({
--         name = 'JOBS',
--         desc = 'Choose your destiny',
--         wimg = 'user',
--         onClick = function()
--             gui.OpenURL('https://google.com')
--             return false
--         end
--     })
--     sidebar:AddTab({
--         name = 'SHOP',
--         desc = 'Find items you need',
--         icon = 'https://i.imgur.com/FuzalfM.png'
--     })
--     sidebar:AddTab({
--         name = 'SETTINGS',
--         desc = 'Configure the game as you wish',
--         wimg = 'gear'
--     })
-- end)