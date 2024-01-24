--[[

Author: tochnonement
Email: tochnonement@gmail.com

08/03/2023

--]]

local PANEL = {}

local colorPrimary = onyx:Config('colors.primary')
local colorSecondary = onyx:Config('colors.secondary')
local colorAccent = onyx:Config('colors.accent')
local colorTertiary = onyx:Config('colors.tertiary')
local font0 = onyx.Font('Roboto@16')

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

    self.btnCreate = self.toolbar:Add('onyx.Button')
    self.btnCreate:Dock(RIGHT)
    self.btnCreate:SetText(onyx.lang:Get('createCategory'))
    self.btnCreate:SizeToContentsX(onyx.ScaleWide(20))
    self.btnCreate:SetFont(onyx.Font('Roboto@16'))
    self.btnCreate.DoClick = function()
        self:StartCategoryCreation()
    end

    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)

    hook.Add('onyx.credistore.ItemsSynced', self, function(panel)
        panel:LoadItems()
    end)

    hook.Add('onyx.credistore.CategoriesSynced', self, function(panel)
        panel:LoadItems()
    end)

    self:LoadItems()
end

function PANEL:StartCategoryCreation()
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(onyx.ScaleWide(500), onyx.ScaleTall(500))
    frame:MakePopup()
    frame:Center()
    frame:SetTitle('ITEM CREATION')
    -- frame:Focus()

    local content = frame:Add('onyx.creditstore.AdminCategoryConfigurator')
    content:Dock(FILL)
    content:CategoryCreation()
    content.OnEditRequested = function()
        frame:Remove()
    end
end

function PANEL:LoadItems()
    local items = onyx.creditstore.items
    local cats = onyx.creditstore.categories

    --[[------------------------------
    Remove old items in case of update
    --------------------------------]]
    for _, child in ipairs(self.list:GetItems()) do
        child:Remove()
    end

    --[[------------------------------
    Sort items
    --------------------------------]]
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
        if (cats[a].nocategory) then
            aOrder = -1
        end
        if (cats[b].nocategory) then
            bOrder = -1
        end
        return aOrder < bOrder
    end)

    --[[------------------------------
    Add items
    --------------------------------]]

    local bFound = {}

    for catIndex, catID in pairs(sortedCategories) do
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

        if (not catData.nocategory) then
            local btnEdit = cat.button:Add('onyx.ImageButton')
            btnEdit:SetURL('https://i.imgur.com/oOlN03M.png', 'smooth mips')
            btnEdit:Dock(RIGHT)
            btnEdit:SetImageSize(onyx.ScaleTall(16))
            btnEdit:DockMargin(0, 0, cat.button:GetTall() * .5, 0)
            btnEdit:SetColorIdle(colorAccent)
            btnEdit.DoClick = function()
                self:StartCategoryEdit(catID, catData)
            end
        end

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

        if (catData.nocategory) then
            local slot = content:Add('onyx.creditstore.Item')
            slot:SetLabelHidden(true)
            slot.icon = onyx.wimg.Simple('https://i.imgur.com/MQ0s2hN.png', 'mips smooth')
            slot.text1 = onyx.lang:Get('create_u')
            slot.text2 = onyx.lang:Get('newItem')
            slot.PaintOver = function(p, w, h)
                local headerHeight = math.ceil(h * .2)
            
                draw.SimpleText(p.text1, font0, w * .5, headerHeight * .5, color_white, 1, 1)
                draw.SimpleText(p.text2, font0, w * .5, h - headerHeight * .5, color_white, 1, 1)
            end
            slot.DoClick = function(panel)
                self:StartItemCreation()
            end
        end

        for _, id in ipairs(sortedItems) do
            local item = items[id]
            if ((item.category and item.category == catID) or (catData.nocategory and not bFound[id])) then
                
                local slot = content:Add('onyx.creditstore.Item')
                slot:SetItem(id, {})
                slot:SetPriceTagVisible(true)
                slot.DoClick = function()
                    self:StartItemEdit(id, item)
                end

            end
        end

        cat:SetExpanded(true)
        cat:UpdateInTick(1)
        cat:UpdateInTick(10)
        cat:UpdateInTick(100)
    end
end

function PANEL:StartItemCreation()
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(onyx.ScaleWide(500), onyx.ScaleTall(500))
    frame:MakePopup()
    frame:Center()
    frame:SetTitle('ITEM CREATION')
    -- frame:Focus()

    local content = frame:Add('onyx.creditstore.AdminItemConfigurator')
    content:Dock(FILL)
    content:ItemCreation()
    content.OnEditRequested = function()
        frame:Remove()
    end
end

function PANEL:StartItemEdit(id, item)
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(onyx.ScaleWide(500), onyx.ScaleTall(500))
    frame:MakePopup()
    frame:Center()
    frame:SetTitle('ITEM EDITOR')
    -- frame:Focus()

    local content = frame:Add('onyx.creditstore.AdminItemConfigurator')
    content:Dock(FILL)
    content:ItemEditor(id, item)
    content.OnEditRequested = function()
        frame:Remove()
    end
end

function PANEL:StartCategoryEdit(id, category)
    local frame = vgui.Create('onyx.Frame')
    frame:SetSize(onyx.ScaleWide(500), onyx.ScaleTall(500))
    frame:MakePopup()
    frame:Center()
    frame:SetTitle('CATEGORY EDITOR')

    local content = frame:Add('onyx.creditstore.AdminCategoryConfigurator')
    content:Dock(FILL)
    content:CategoryEditor(id, category)
    content.OnEditRequested = function()
        frame:Remove()
    end
end

vgui.Register('onyx.creditstore.AdminItems', PANEL)