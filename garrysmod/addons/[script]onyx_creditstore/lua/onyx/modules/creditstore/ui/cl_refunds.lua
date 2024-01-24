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
local colorQuaternary = onyx:Config('colors.quaternary')
local colorGray = onyx:Config('colors.gray')
local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')

local font0 = onyx.Font('Roboto@16')
local font1 = onyx.Font('Roboto@20')
local font2 = onyx.Font('Roboto@16')
local font3 = onyx.Font('Roboto@24')

local wimgEmpty = onyx.wimg.Simple('https://i.imgur.com/1E8Nx8L.png', 'smooth mips')

function PANEL:Init()
    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)

    hook.Add('onyx.credistore.InventoryUpdated', self, function(panel)
        panel:LoadItems()
    end)

    self:LoadItems()
    self.empty = #self.list:GetItems() <= 0
    self.textNothing = onyx.lang:Get('nothingToRefund')
end

function PANEL:PaintOver(w, h)
    -- print(self.empty)
    if (self.empty) then
        local size = onyx.ScaleTall(64)
        local space = onyx.ScaleTall(30)
        local text = self.textNothing
        local textWidth, textHeight = onyx.GetTextSize(text, font3)
        local totalH = size + space + textHeight
        local y = h * .5 - totalH * .5
        
        wimgEmpty:Draw(w * .5 - size * .5, y, size, size, colorTertiary)
        draw.SimpleText(text, font3, w * .5, y + size + space, colorTertiary, 1, 1)
    end
end

function PANEL:LoadItems()
    for _, panel in ipairs(self.list:GetItems()) do
        panel:Remove()
    end

    local inventory = onyx.creditstore:GetPlayerInventory(LocalPlayer())

    local sorted = {}

    for index, it in ipairs(inventory) do
        local id = it.id
        local data = it.data or {}

        if (data and data.price and data.unix) then
            local endTime = onyx.creditstore:GetRefundEndTime(data.unix)
            if (endTime >= os.time()) then
                table.insert(sorted, {
                    it = it,
                    index = index,
                    endTime = endTime,
                    unix = data.unix,
                    price = data.price
                })
            end
        end
    end

    table.sort(sorted, function(a, b)
        return a.unix > b.unix
    end)

    for _, slot in ipairs(sorted) do
        local it = slot.it
        local itemID = it.id
        local itemTable = onyx.creditstore.items[itemID]
        if (not itemTable) then continue end
        local itemTypeData = onyx.creditstore.types[itemTable.type]
        if (not itemTypeData) then continue end

        local itemTypeName = onyx.lang:Get(itemTypeData.name)
        local itemTypeColor = itemTypeData.color
        local model = itemTable.model
        local icon = itemTable.icon
        local padding = onyx.ScaleTall(5)
        local untilDate = slot.endTime
        local untilDateStr = os.date('%d %B %H:%M', untilDate)
        local textRefundableUntil = onyx.lang:Get('refundableUntil')

        local row = self.list:Add('onyx.Button')
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

            draw.SimpleText(textRefundableUntil, font2, w * .5, h * .5, colorGray, 1, 4)
            draw.SimpleText(untilDateStr, font0, w * .5, h * .5, color_white, 1, 0)
        end)
        row.DoClick = function()
            local dmenu = vgui.Create('onyx.Menu')
            local sub = dmenu:AddSubMenu(onyx.lang:Get('requestRefund'))
            
            sub:AddOption(onyx.lang:Get('confirm'), function()
                net.Start('onyx.creditstore:Refund')
                    net.WriteUInt(slot.index, 16)
                net.SendToServer()
            end)

            sub:AddOption(onyx.lang:Get('cancel'), function()
                
            end)

            dmenu:ToCursor()
            dmenu:Open()
            -- net.Start('onyx.creditstore:AdminGiveItem')
            --     net.WriteString(self.steamid64)
            --     net.WriteString(itemID)
            -- net.SendToServer()
        end

        local money = row:Add('onyx.Label')
        money:Font('Roboto@20')
        money:SetTextColor(color_white)
        money:Dock(RIGHT)
        money:SetZPos(-1)
        money:SetContentAlignment(4)
        money:SetMouseInputEnabled(true)
        money:SetText(onyx.creditstore.FormatMoney(onyx.creditstore:GetRefundPrice(slot.price)))
        money:SizeToContentsX(onyx.ScaleWide(10))
        money:SetMouseInputEnabled(false)
        money.Paint = function(p, w, h)
            draw.RoundedBoxEx(8, 0, 0, w, h, colorPrimary, nil, true, nil, true)
        end
        self.money = money
    
        local picon = row:Add('onyx.Image')
        picon:Dock(RIGHT)
        picon:SetZPos(-1)
        picon:SetImageWide(onyx.ScaleTall(16))
        picon:SetImageTall(picon:GetImageWide())
        picon:SetWide(row:GetTall() - padding * 2)
        picon:DockMargin(0, 0, 0, 0)
        picon:SetColor(colorAccent)
        picon:SetMouseInputEnabled(false)
        -- picon:DockMargin(onyx.ScaleWide(5), 0, 0, 0)
        picon.m_WebImage = wimgCoin
        picon.PaintBackground = function(p, w, h)
            draw.RoundedBoxEx(8, 0, 0, w, h, colorPrimary, true, nil, true)
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

onyx.gui.Register('onyx.creditstore.Refunds', PANEL)