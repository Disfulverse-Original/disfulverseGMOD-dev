--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

local PANEL = {}

local colorAccent = onyx:Config('colors.accent')
local wimgLoading = onyx.wimg.Simple('https://i.imgur.com/VVswRpx.png', 'smooth mips')
local font0 = onyx.Font('Roboto@20')
local font1 = onyx.Font('Roboto@16')
local font2 = onyx.Font('Roboto@16')
local colorGray = Color(144, 144, 144)
local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')

function PANEL:Init()
    local client = LocalPlayer()
    onyx.creditstore.frame = self
    self.container = self:Add('Panel')
    self.container.PaintOver = function(p, w, h)

        local text1 = 'LOADING INVENTORY'
        local text2 = 'PROCESSING THINGS'
        local subtext = 'Please do not disconnect'
        local bProcessing = LocalPlayer():onyx_GetNetVar('store_busy')
        local bInventoryLoaded = LocalPlayer():onyx_GetNetVar('store_loaded')
        local show = bProcessing or not bInventoryLoaded
        local text = bProcessing and text2 or text1

        if (show) then
            onyx.DrawBlurExpensive(p, 3)

            local maxSize = onyx.ScaleTall(64)
            local size = maxSize * .5 + maxSize * .5 * math.abs(math.sin(CurTime()))
            
            wimgLoading:DrawRotated(w * .5, h * .5, size, size, (CurTime() * 100) % 360)

            local textY = h * .5 + maxSize * .5 + onyx.ScaleTall(10)

            local _, texth = draw.SimpleText(text, font0, w * .5, textY, color_white, 1, 0)
            draw.SimpleText(subtext, font1, w * .5, textY + texth, colorGray, 1, 0)
        end

        p:SetMouseInputEnabled(not show)
    end

    self.sidebar = self:Add('onyx.Sidebar')
    self.sidebar:SetContainer(self.container)

    local padding = onyx.ScaleTall(8)
    local profile = self.sidebar:Add('Panel')
    profile:Dock(TOP)
    profile:DockMargin(0, 0, 0, onyx.ScaleTall(5))
    profile:SetTall(onyx.ScaleTall(50))
    profile:DockPadding(padding, padding, padding, padding)
    profile.Paint = function(panel, w, h)
        local size = onyx.ScaleTall(14)

        -- -- 1var.
        -- nothing

        -- -- 2var.
        -- draw.RoundedBox(8, 0, 0, w, h, colorPrimary)

        -- -- 3var.
        -- draw.RoundedBox(8, 0, 0, w, h, colorPrimary)
        -- draw.RoundedBox(8, 1, 1, w - 2, h - 2, colorSecondary)

        -- 4var.
        -- draw.RoundedBox(8, 0, 0, w, h, colorTertiary)
        -- draw.RoundedBox(8, 1, 1, w - 2, h - 2, colorSecondary)

        -- 5var.
        -- draw.RoundedBox(8, 0, 0, w, h, colorTertiary)

        -- 6var.
        -- draw.RoundedBox(8, 0, 0, w, h, colorTertiary)
        -- draw.RoundedBox(8, 1, 1, w - 2, h - 2, colorPrimary)

        draw.SimpleText(client:Name(), font2, h, h * .5, color_white, 0, 4)

        local _, texth = draw.SimpleText(onyx.creditstore:GetCredits(client), font2, h + size + onyx.ScaleWide(5), h * .5, colorAccent, 0, 0)
        wimgCoin:Draw(h, h * .5 + texth * .5 - size * .5, size, size, colorAccent)
    end

    local avatar = profile:Add('onyx.RoundedAvatar')
    avatar:SetPlayer(client, 64)
    avatar:SetWide(profile:GetTall() - padding * 2)
    avatar:Dock(LEFT)
    -- avatar.PerformLayout = function(panel, w, h)
    --     panel.mask = onyx.CalculateRoundedBox(8, 0, 0, w, h)
    -- end
    self:SetTitle('')
    self:LoadTabs()
end

function PANEL:PerformLayout(w, h)
    self.BaseClass.PerformLayout(self, w, h)

    self.sidebar:SetWide(w * .2)
    self.sidebar:Dock(LEFT)

    local p = onyx.ScaleTall(15)
    
    self.container:Dock(FILL)
    self.container:DockPadding(p, p, p, p)
end

function PANEL:LoadTabs()
    self.sidebar:AddTab({
        name = onyx.lang:Get('store_u'),
        desc = 'Purchase fancy stuff',
        icon = 'https://i.imgur.com/agUmpea.png',
        class = 'onyx.creditstore.Shop'
    })

    self.sidebar:AddTab({
        name = onyx.lang:Get('inventory_u'),
        desc = 'Manage your items',
        icon = 'https://i.imgur.com/JnyDkrG.png',
        class = 'onyx.creditstore.Inventory',
        onSelected = function(content)
            content:MakePlayerInventory()
        end
    })

    if (onyx.creditstore:GetOptionValue('refunds_enabled')) then
        self.sidebar:AddTab({
            name = onyx.lang:Get('refunds_u'),
            desc = 'Refund your purchases',
            icon = 'https://i.imgur.com/pjwbqs2.png',
            class = 'onyx.creditstore.Refunds'
        })
    end

    if (DarkRP and onyx.creditstore:GetOptionValue('converter_enabled')) then
        self.sidebar:AddTab({
            name = onyx.lang:Get('convert_u'),
            desc = 'Convert money and credits',
            icon = 'https://i.imgur.com/nkd7Twr.png',
            class = 'onyx.creditstore.Converter'
        })
    end

    CAMI.PlayerHasAccess(LocalPlayer(), 'onyx_creditstore_see_inventory', function(bAllowed)
        if (bAllowed and IsValid(self.sidebar)) then
            self.sidebar:AddTab({
                name = onyx.lang:Get('admin_u'),
                desc = 'Configuration',
                icon = 'https://i.imgur.com/0OE893O.png',
                onClick = function()
                    self:Remove()
                    onyx.creditstore.OpenAdminSettings()
                    
                    return false
                end
            })
        end
        
    end)

    local donateStr = onyx.lang:Get('donate_u')
    local colorDonate = Color(255 ,204, 65)
    local websiteURL = onyx.creditstore:GetOptionValue('website_url')
    if (onyx.creditstore:GetOptionValue('website_ingame')) then
        self.sidebar:AddTab({
            name = donateStr,
            desc = 'Receive premium currency',
            wimg = 'creditstore_truecurrency3',
            class = 'HTML',
            donate = true,
    
            nameColor = colorDonate,
            iconColor = colorDonate,
            descColor = onyx.ColorEditHSV(colorDonate, nil, .25, .75),
    
            onSelected = function(panel)
                panel:OpenURL(websiteURL)
                panel.OnBeginLoadingDocument = function(panel)
                    if (not panel.bLoaded) then
                        panel.bLoading = true
                    end
                end
                panel.OnFinishLoadingDocument = function(panel)
                    panel.bLoading = nil
                    panel.bLoaded = true
                end
                panel.PaintOver = function(panel, w, h)
                    if (panel.bLoading) then
                        local maxSize = onyx.ScaleTall(64)
                        local size = maxSize * .5 + maxSize * .5 * math.abs(math.sin(CurTime()))
                        
                        wimgLoading:DrawRotated(w * .5, h * .5, size, size, (CurTime() * 100) % 360)
                    end
                end
            end
        })
    else
        self.sidebar:AddTab({
            name = donateStr,
            desc = 'Receive premium currency',
            wimg = 'creditstore_truecurrency3',
            donate = true,
    
            nameColor = colorDonate,
            iconColor = colorDonate,
            descColor = onyx.ColorEditHSV(colorDonate, nil, .25, .75),
    
            onClick = function(panel)
                gui.OpenURL(websiteURL)
                return false
            end
        })
    end

    self.sidebar:ChooseTab(1)
end

onyx.gui.Register('onyx.creditstore.Frame', PANEL, 'onyx.Frame')

-- ANCHOR Test

-- onyx.gui.Test('onyx.creditstore.Frame', .65, .65, function(self)
--     self:MakePopup()
-- end)