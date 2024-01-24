--[[

Author: tochnonement
Email: tochnonement@gmail.com

19/04/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local colorQuaternary = onyx:Config('colors.quaternary')
local colorGray = Color(155, 155, 155)
local colorRed = Color(196, 77, 77)
local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')

local font0 = onyx.Font('Roboto@16')
local font1 = onyx.Font('Roboto@20')
local font2 = onyx.Font('Roboto@16')

function PANEL:Init()
    local margin = onyx.ScaleTall(10)
    local padding = onyx.ScaleTall(5)

    self.list = self:Add('Panel')
    self.list:Dock(FILL)
    self.list:DockMargin(margin, margin, margin, margin)

    self.header = self.list:Add('DPanel')
    self.header:Dock(TOP)
    self.header:SetTall(onyx.ScaleTall(45))
    self.header:DockPadding(padding, padding, padding, padding)
    self.header:DockMargin(0, 0, 0, onyx.ScaleTall(10))
    self.header.Paint = function(panel, w, h)
        draw.RoundedBox(8, 0, 0, w, h, colorSecondary)
    end

    self.avatar = self.header:Add('onyx.RoundedAvatar')
    self.avatar:Dock(LEFT)
    self.avatar:SetWide(self.header:GetTall() - padding * 2 )
    self.avatar:DockMargin(0, 0, margin, 0)

    self.lblName = self.header:Add('onyx.Label')
    self.lblName:Dock(TOP)
    self.lblName:SetText('UNKNOWN')
    self.lblName:SetTall((self.header:GetTall() - padding * 2) * .5)
    self.lblName:Font('Roboto@18')

    self.lblSteamID = self.header:Add('onyx.Label')
    self.lblSteamID:Dock(FILL)
    self.lblSteamID:SetText('UNKNOWN')
    self.lblSteamID:Font('Roboto@16')
    self.lblSteamID:SetTextColor(colorGray)

    self.inventory = self.list:Add('onyx.creditstore.Inventory')
    self.inventory:Dock(FILL)
    self.inventory.DoSlotClick = function(_, panel, it)
        if (not self.canTakeItems) then
            return
        end

        local menu = vgui.Create('onyx.Menu')
        menu:ToCursor()

        local submenu, option = menu:AddSubMenu(onyx.lang:Get('delete'))
        option:SetIconURL('https://i.imgur.com/CZH6F2I.png')

        local function delete(amt)
            local multiple = amt > 1
            net.Start('onyx.creditstore:AdminTakeItem')
                net.WriteString(self.steamid64)
                net.WriteBool(multiple)
                if (multiple) then
                    net.WriteUInt(amt, 8)
                    net.WriteString(panel.itemTable.id)
                else
                    net.WriteUInt(it.index, 16)
                end
            net.SendToServer()
        end

        submenu:AddOption(onyx.lang:Get('single') .. ' (1)', function()
            delete(1)
        end)

        local amount = panel.amount
        if (amount > 1) then
            local half = math.floor(amount * .5)
            submenu:AddOption(onyx.lang:Get('half') .. ' (' .. half .. ')', function()
                delete(half)
            end)
            
            submenu:AddOption(onyx.lang:Get('all') .. ' (' .. amount .. ')', function()
                delete(amount)
            end)
        end

        menu:Open()
    end

    local money = self.header:Add('onyx.Label')
    money:Font('Roboto@20')
    money:SetTextColor(color_white)
    money:Dock(RIGHT)
    money:SetZPos(-1)
    money:SetContentAlignment(4)
    money:SetMouseInputEnabled(true)
    money.Paint = function(p, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, colorPrimary, nil, true, nil, true)
    end
    self.money = money

    local icon = self.header:Add('onyx.Image')
    icon:Dock(RIGHT)
    icon:SetZPos(-1)
    icon:SetImageWide(onyx.ScaleTall(16))
    icon:SetImageTall(icon:GetImageWide())
    icon:SetWide(self.inventory.toolbar:GetTall() - padding * 2)
    icon:DockMargin(0, 0, 0, 0)
    icon:SetColor(colorAccent)
    icon:DockMargin(onyx.ScaleWide(5), 0, 0, 0)
    icon.m_WebImage = wimgCoin
    icon.PaintBackground = function(p, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, colorPrimary, true, nil, true)
    end

    self.btnCreate = self.inventory.toolbar:Add('onyx.Button')
    self.btnCreate:Dock(RIGHT)
    self.btnCreate:SetText(onyx.lang:Get('giveItem'))
    self.btnCreate:SizeToContentsX(onyx.ScaleWide(20))
    self.btnCreate:SetFont(onyx.Font('Roboto@16'))
    self.btnCreate:SetVisible(false)
    self.btnCreate.DoClick = function()
        self:StartItemGive()
    end

    CAMI.PlayerHasAccess(LocalPlayer(), 'onyx_creditstore_give_items', function(bAllowed)
        if (IsValid(self.btnCreate)) then
            self.btnCreate:SetVisible(bAllowed)
        end
    end)

    CAMI.PlayerHasAccess(LocalPlayer(), 'onyx_creditstore_take_items', function(bAllowed)
        if (IsValid(self)) then
            self.canTakeItems = bAllowed
        end
    end)
end

function PANEL:Request(steamid64)
    self.avatar:SetSteamID(steamid64, 64)
    self.lblSteamID:SetText(util.SteamIDFrom64(steamid64))
    self.steamid64 = steamid64

    steamworks.RequestPlayerInfo(steamid64, function(steamName)
        self.lblName:SetText(steamName)
    end)

    onyx.AdminPlayerInventoryPanel = self

    net.Start('onyx.creditstore:AdminRequestInventory')
        net.WriteString(steamid64)
    net.SendToServer()
end

function PANEL:StartItemGive()
    local margin = onyx.ScaleTall(10)
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(ScrW() * .25, ScrH() * .5)
    frame:Center()
    frame:MakePopup()
    frame:Focus()
    frame:SetTitle('CHOOSE ITEM')

    local content = frame:Add('Panel')
    content:Dock(FILL)
    content:DockMargin(margin, margin, margin, margin)

    local toolbar = content:Add('Panel')
    toolbar:Dock(TOP)
    toolbar:DockMargin(0, 0, 0, onyx.ScaleTall(10))
    toolbar:SetTall(onyx.ScaleTall(30))
    -- toolbar.Paint = function(p, w, h)
    --     draw.RoundedBox(8, 0, 0, w, h, colorSecondary)
    -- end

    local plist
    local psearch = toolbar:Add('onyx.TextEntry')
    psearch:SetPlaceholderText(onyx.lang:Get('searchName'))
    psearch:SetPlaceholderIcon('https://i.imgur.com/Nk3IUJT.png', 'smooth mips')
    psearch:Dock(FILL)
    psearch:SetWide(onyx.ScaleWide(150))
    psearch:SetUpdateOnType(true)
    psearch.OnValueChange = function(panel, value)
        value = value:lower()

        for _, item in ipairs(plist:GetItems()) do
            if (item.itemName:lower():find(value, nil, true)) then
                item:SetVisible(true)
            else
                item:SetVisible(false)
            end
        end

        plist:InvalidateLayout(true)
    end

    plist = content:Add('onyx.ScrollPanel')
    plist:Dock(FILL)

    local sorted = {}
    for itemID, itemTable in pairs(onyx.creditstore.items) do
        table.insert(sorted, itemTable)
    end
    
    table.sort(sorted, function(a, b)
        if (a.type == b.type) then
            return a.name < b.name
        end

        return a.type < b.type
    end)

    for _, itemTable in ipairs(sorted) do
        local itemID = itemTable.id
        local itemTypeData = onyx.creditstore.types[itemTable.type]
        if (not itemTypeData) then continue end

        local itemTypeName = onyx.lang:Get(itemTypeData.name)
        local itemTypeColor = itemTypeData.color
        local model = itemTable.model
        local icon = itemTable.icon
        local padding = onyx.ScaleTall(5)

        local row = plist:Add('onyx.Button')
        row:SetTall(onyx.ScaleTall(50))
        row:Dock(TOP)
        row:SetColorIdle(colorSecondary)
        row:SetColorHover(colorTertiary)
        row:SetText('')
        row:InjectEventHandler('Paint')
        row:Padding(padding)
        row:AddClickEffect()
        row:AddHoverSound()
        row:On('Paint', function(panel, w, h)
            draw.SimpleText(itemTable.name, font1, h + onyx.ScaleWide(5), h * .5, color_white, 0, 4)
            draw.SimpleText(itemTypeName, font2, h + onyx.ScaleWide(5), h * .5, itemTypeColor, 0, 0)
        end)
        row.DoClick = function()
            net.Start('onyx.creditstore:AdminGiveItem')
                net.WriteString(self.steamid64)
                net.WriteString(itemID)
            net.SendToServer()

            frame:Remove()
        end

        local slot = row:Add('Panel')
        slot:Dock(LEFT)
        slot:SetWide(row:GetTall() - padding * 2)
        slot.Paint = function(p, w, h)
            draw.RoundedBox(8, 0, 0, w, h, colorPrimary)

            if (p.icon) then
                local sz = math.ceil(h * .66)
                p.icon:Draw(w * .5 - sz * .5, h * .5 - sz * .5, sz, sz)
            end
        end

        row.itemName = itemTable.name

        if (icon) then
            slot.icon = onyx.wimg.Simple(icon, '')
        elseif (model) then
            row.dmodel = slot:Add('DModelPanel')
            row.dmodel:Dock(FILL)
            row.dmodel:SetMouseInputEnabled(false)
            row.dmodel:SetModel(model)

            local ent = row.dmodel.Entity
            if (IsValid(ent)) then
                local min, max = ent:GetRenderBounds()
                local center = (min + max) / 2
                local distance = 0

                for _, key in ipairs({"x", "y", "z"}) do
                    distance = math.max(distance, max[key])
                end

                row.dmodel:SetLookAt(center)
                row.dmodel:SetFOV(distance + 5)
                row.dmodel.LayoutEntity = function() end
            end
        end
    end
end

function PANEL:LoadBalance(balance)
    self.money:SetText(onyx.creditstore.FormatMoney(balance))
    self.money:SizeToContentsX(onyx.ScaleWide(10))
end

onyx.gui.Register('onyx.creditstore.AdminPlayerInventory', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .5, .75, function(self)
--     self:MakePopup()

--     local content = self:Add('onyx.creditstore.AdminPlayerInventory')
--     content:Dock(FILL)
--     content:Request('76561198086200873')
-- end)