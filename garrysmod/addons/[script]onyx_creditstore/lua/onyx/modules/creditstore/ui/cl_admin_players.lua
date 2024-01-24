--[[

Author: tochnonement
Email: tochnonement@gmail.com

30/04/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local colorGray = onyx:Config('colors.gray')
local font0 = onyx.Font('Roboto@18')
local font1 = onyx.Font('Roboto@16')

function PANEL:Init()
    self.toolbar = self:Add('Panel')
    self.toolbar:Dock(TOP)
    self.toolbar:SetTall(onyx.ScaleTall(35))
    self.toolbar:DockMargin(0, 0, 0, onyx.ScaleTall(10))
    local padding = onyx.ScaleTall(5)
    self.toolbar.Paint = function(p, w, h)
        draw.RoundedBox(8, 0, 0, w, h, colorSecondary)
    end

    self.toolbar:DockPadding(padding, padding, padding, padding)

    self.search = self.toolbar:Add('onyx.TextEntry')
    self.search:SetPlaceholderText(onyx.lang:Get('searchNameSteamID'))
    self.search:SetPlaceholderIcon('https://i.imgur.com/Nk3IUJT.png', 'smooth mips')
    self.search:Dock(LEFT)
    self.search:SetWide(onyx.ScaleWide(200))
    self.search:SetUpdateOnType(true)
    self.search.OnValueChange = function(panel, value)
        value = value:lower()

        for _, item in ipairs(self.grid:GetItems()) do
            if (item.playerName:lower():find(value, nil, true) or item.playerSteamID:lower() == value) then
                item:SetVisible(true)
            else
                item:SetVisible(false)
            end
        end

        self.grid:InvalidateLayout(true)
    end

    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)

    self.grid = self.list:Add('onyx.Grid')
    self.grid:Dock(TOP)
    self.grid:SetColumnCount(3)
    self.grid:SetSpace(onyx.ScaleTall(5))

    self:LoadPlayers()
end

function PANEL:LoadPlayers()
    local padding = onyx.ScaleTall(5)
    for _, ply in ipairs(player.GetAll()) do
        local name = ply:GetName()
        local sg = ply:GetUserGroup()
        local sgColor = colorGray
        if (sg ~= 'user') then
            sgColor = colorAccent
        end

        local button = self.grid:Add('onyx.Button') 
        button:SetText('')
        button:SetTall(onyx.ScaleTall(40))
        button:SetColorIdle(colorSecondary)
        button:SetColorHover(colorTertiary)
        button:AddClickEffect()
        button:AddHoverSound()
        button:Padding(padding)
        button:InjectEventHandler('Paint')
        button:On('Paint', function(panel, w, h)
            draw.SimpleText(name, font0, h + onyx.ScaleWide(5), h * .5, color_white, 0, 4)
            draw.SimpleText(sg, font1, h + onyx.ScaleWide(5), h * .5, sgColor, 0, 0)
        end)

        button.playerName = name
        button.playerSteamID = ply:SteamID()
        button.playerSteamID64 = ply:SteamID64()
        button.DoClick = function(panel)
            if (IsValid(ply)) then
                onyx.creditstore.OpenAdminPlayerInventory(panel.playerSteamID64)
            end
        end

        local container = button:Add('Panel')
        container:Dock(LEFT)
        container:SetWide(button:GetTall() - padding * 2)
        container.PerformLayout = function(panel, w, h)
            panel.mask = onyx.CalculateCircle(w * .5, h * .5, h * .5, 24)
        end
        container.Paint = function(panel, w, h)
            local mask = panel.mask
            local avatar = panel.avatar
            if (mask and avatar) then
                onyx.MaskFn(function()
                    onyx.DrawPoly(mask)
                end, function()
                    avatar:PaintManual()
                end)
            end
        end

        local avatar = container:Add('AvatarImage')
        avatar:Dock(FILL)
        avatar:SetPlayer(ply, 64)
        avatar:SetPaintedManually(true)
        container.avatar = avatar
    end
end

vgui.Register('onyx.creditstore.AdminPlayers', PANEL)