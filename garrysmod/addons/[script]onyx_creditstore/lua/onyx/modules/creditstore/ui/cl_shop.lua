--[[

Author: tochnonement
Email: tochnonement@gmail.com

02/03/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local colorQuaternary = onyx:Config('colors.quaternary')
local colorGray = Color(155, 155, 155)

local font0 = onyx.Font('Roboto@16')
local font1 = onyx.Font('Roboto@20')
local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')

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
    self.search:SetPlaceholderText(onyx.lang:Get('searchName'))
    self.search:SetPlaceholderIcon('https://i.imgur.com/Nk3IUJT.png', 'smooth mips')
    self.search:Dock(LEFT)
    self.search:SetWide(onyx.ScaleWide(150))
    self.search:SetUpdateOnType(true)
    self.search.OnValueChange = function(panel, value)
        value = value:lower()

        for _, cat in ipairs(self.list:GetItems()) do
            local layout = cat.canvas:GetChild(0)
            local items = layout:GetChildren()
            local visibleItemAmount = 0

            for _, item in ipairs(items) do
                if (item:GetName():lower():find(value, nil, true)) then
                    item:SetVisible(true)
                    visibleItemAmount = visibleItemAmount + 1
                else
                    item:SetVisible(false)
                end
            end

            layout:InvalidateLayout()

            cat:SetVisible(value == '' or visibleItemAmount > 0)
            cat:UpdateInTick()
        end
    end

    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)

    self:LoadItems()
end

function PANEL:LoadItems()
    local items = onyx.creditstore.items
    local cats = onyx.creditstore.categories

    local sortedItems = {}
    for id in pairs(items) do
        table.insert(sortedItems ,id)
    end
    table.sort(sortedItems, function(a, b)
        return items[a].price < items[b].price
    end)

    local sortedCategories = {}
    for id in pairs(cats) do
        table.insert(sortedCategories ,id)
    end
    table.sort(sortedCategories, function(a, b)
        local aOrder = (cats[a].order or 98)
        local bOrder = (cats[b].order or 98)
        return aOrder < bOrder
    end)

    local bFound = {}

    for catIndex, catID in ipairs(sortedCategories) do
        for _, id in ipairs(sortedItems) do
            local item = items[id]
            if (item.category and item.category == catID) then
                bFound[id] = true
            end
        end
    end

    for catIndex, catID in pairs(sortedCategories) do
        local catData = cats[catID]
        local cat = self.list:Add('onyx.Category')
        cat:Dock(TOP)
        cat:SetIcon(catData.icon, 'smooth mips')
        cat:SetTitle(catData.name:upper())
        cat:SetSpace(0)
        cat:SetInset(onyx.ScaleTall(15))
        cat:DockMargin(0, 0, 0, onyx.ScaleTall(10))

        local content = cat:Add('onyx.Grid')
        content:Dock(TOP)
        content:SetTall(0)
        content:SetSpaceX(onyx.ScaleTall(10))
        content:SetSpaceY(content:GetSpaceX())
        content:SetColumnCount(5)
        content:SetSizeRatio(1.25)

        cat.canvas.Paint = function(p, w, h)
            draw.RoundedBox(8, 0, 0, w, h, colorPrimary)
        end

        local amt = 0
        for _, id in pairs(sortedItems) do
            local item = items[id]
            if ((item.category and item.category == catID) or (catData.nocategory and not bFound[id])) then
                
                local slot = content:Add('onyx.creditstore.Item')
                slot:SetItem(id, {})
                slot:SetPriceTagVisible(true)
                slot.store = true
                slot.DoClick = function(panel)
                    if (panel.owned) then return end

                    local price = item.price
                    if (onyx.creditstore:GetCredits(LocalPlayer()) < price) then
                        notification.AddLegacy(onyx.lang:Get('notEnoughCredits'), 1, 5)
                        return
                    end

                    local dmenu = vgui.Create('onyx.Menu')
                    dmenu:ToCursor()

                    local sub = dmenu:AddSubMenu(onyx.lang:Get('purchaseItem', {item = item.name}))
                    sub:AddOption(onyx.lang:Get('confirm'), function()
                        net.Start('onyx.creditstore:PurchaseItem')
                            net.WriteString(id)
                        net.SendToServer()
                    end)
                    sub:AddOption(onyx.lang:Get('cancel'), function()
                        
                    end)

                    dmenu:Open()

                end

                local typeData = onyx.creditstore.types[item.type]
                if (typeData) then
                    local customCheck = typeData.customCheck
                    if (customCheck) then
                        local allowed, status = customCheck(LocalPlayer(), item)
                        if (allowed == false) then
                            slot.DoClick = nil
                            slot.status = status
                        end
                    end
                end

                amt = amt + 1

            end
        end

        if (amt > 0 or not catData.nocategory) then
            cat:SetExpanded(true)
            cat:UpdateInTick(1)
            cat:UpdateInTick(10)
            cat:UpdateInTick(100)
        else
            cat:Remove()
        end
    end
end

onyx.gui.Register('onyx.creditstore.Shop', PANEL)