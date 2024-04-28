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
local font1 = onyx.Font('Roboto@16')
local colorGray = onyx:Config('colors.gray')
local colorGreen = onyx:Config('colors.positive')
local colorRed = onyx:Config('colors.negative')
local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')

AccessorFunc(PANEL, 'm_bHideDeletedItems', 'HideDeletedItems')

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

        local layout = self.content
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
    end

    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)

    self.content = self.list:Add('onyx.Grid')
    self.content:Dock(TOP)
    self.content:SetTall(0)
    self.content:SetSpaceX(onyx.ScaleTall(10))
    self.content:SetSpaceY(self.content:GetSpaceX())
    self.content:SetColumnCount(5)
    self.content:SetSizeRatio(1.25)

    self:SetHideDeletedItems(false)
end

local function translateOption(key)
    return onyx.lang:Get(key)
end

function PANEL:MakePlayerInventory()
    self:SetHideDeletedItems(true)

    hook.Add('onyx.credistore.InventoryUpdated', self, function(panel)
        panel:LoadItems(onyx.creditstore:GetPlayerInventory(LocalPlayer()))
    end)

    self:LoadItems(onyx.creditstore:GetPlayerInventory(LocalPlayer()))
    self.DoSlotClick = function(self, panel, it)
        local itemTypeData = panel.itemTypeData
        if (not itemTypeData) then return end

        local options = table.Copy(itemTypeData.options or {})
    
        if (itemTypeData.equip) then
            if (panel.equipped) then
                options['unequip'] = {}
            else
                options['equip'] = {}
            end
        end

        if (table.IsEmpty(options)) then return end

        local menu = vgui.Create('onyx.Menu')
        menu:ToCursor()

        for key, option in pairs(options) do
            local name = translateOption(key)
            menu:AddOption(name, function()
                local allowed, reason
                if (option.check) then
                    allowed, reason = option.check(LocalPlayer(), panel.itemTable.data)
                else
                    allowed = true
                end

                if (allowed == false) then
                    if (reason) then
                        notification.AddLegacy(reason, 1, 4)
                    end
                else
                    net.Start('onyx.creditstore:UseOption')
                        net.WriteUInt(it.index, 16)
                        net.WriteString(key)
                    net.SendToServer()
                end
            end)
        end

        menu:Open()
    end
end

local colorShade = Color(0, 0, 0, 50)
local colorGradient = Color(0, 0, 0, 150)
function PANEL:LoadItems(items)
    for _, child in ipairs(self.content:GetChildren()) do
        child:Remove()
    end

    --[[------------------------------
    Sort items
    --------------------------------]]
    local itemsCopy = table.Copy(items)
    local sortedItems = {}
    local tStackingList = {}

    for index, it in ipairs(itemsCopy) do
        local id = it.id

        local stackingBaseItemSortedIndex = tStackingList[id]
        if stackingBaseItemSortedIndex then
            local stackingBaseItem = itemsCopy[stackingBaseItemSortedIndex]
            
            stackingBaseItem.amount = stackingBaseItem.amount + 1
            table.insert(stackingBaseItem.list, index)

            goto CONTINUE 
        end

        local invalid = false
    
        local itemTable = onyx.creditstore.items[id]
        if (not itemTable) then invalid = true end
        
        local typeData = itemTable and onyx.creditstore.types[itemTable.type]
        if (not typeData) then invalid = true end

        if (not invalid) then
            if (typeData.stacking) then
                it.amount = 1
                it.list = {}
    
                tStackingList[id] = index
            end
        elseif (self.m_bHideDeletedItems) then
            goto CONTINUE
        end

        it.index = index
        it.sortedIndex = table.insert(sortedItems, it)

        ::CONTINUE::
    end

    table.sort(sortedItems, function(a, b)
        local aData = onyx.creditstore.items[a.id]
        local bData = onyx.creditstore.items[b.id]

        local aType = aData and aData.type or ''
        local bType = bData and bData.type or ''

        if (aType == bType) then
            local aName = aData and aData.name or ''
            local bName = bData and bData.name or ''
            
            return aName < bName
        end

        return aType < bType
    end)

    local textActive = onyx.lang:Get('active_u')
    local textUnactive = onyx.lang:Get('unactive_u')
    local textOwned = onyx.lang:Get('owned_u')
    
    --[[------------------------------
    Add items
    --------------------------------]]
    for _, it in ipairs(sortedItems) do
        local id = it.id
        local data = it.data or {}
        local amount = it.amount
        local item = items[id]
            
        local slot = self.content:Add('onyx.creditstore.Item')
        slot:SetItem(id, data)
        slot:SetPriceTagVisible(false)
        slot:InjectEventHandler('Paint')
        slot:On('Paint', function(p, w, h)
            local headerHeight = h * .2

            draw.RoundedBoxEx(8, 0, h - headerHeight, w, headerHeight, colorShade, nil, nil, true, true)
            -- draw.SimpleText('OWNED' .. (amount and (' (x' .. amount .. ')') or ''), font1, w * .5, h - headerHeight * .5, colorGray, 1, 1)
            if (p.itemTypeData and p.itemTypeData.equip) then
                if (p.equipped) then
                    draw.SimpleText(textActive, font0, w * .5, h - headerHeight * .5, colorGreen, 1, 1)
                    -- onyx.DrawTextInBox('ACTIVE', font0, w * .5, h - headerHeight * .5, 8, onyx.ScaleWide(10), onyx.ScaleTall(5), color_black, colorGreen)
                else
                    draw.SimpleText(textUnactive, font0, w * .5, h - headerHeight * .5, colorGray, 1, 1)
                end
            else
                if (amount) then
                    onyx.DrawTextInBox(amount .. 'x', font0, w * .5, h - headerHeight * .5, 8, onyx.ScaleWide(10), onyx.ScaleTall(5), color_white, colorShade)
                else
                    draw.SimpleText(textOwned, font0, w * .5, h - headerHeight * .5, colorGray, 1, 1)
                end
            end

            -- if (amount) then
            --     draw.SimpleText('x' .. amount, font1, w - onyx.ScaleWide(10), headerHeight * .5, color_white, 2, 1)
            -- end
        end)
        slot.PerformLayout = function(panel, w, h)
            local button = panel.button
            local headerHeight = h * .2
            if (IsValid(button)) then
                local buttonHeight = headerHeight * .66
                
                -- button:SetWide(w * .66)
                button:SetTall(buttonHeight)
                button:SetPos(0, h - headerHeight * .5 - buttonHeight * .5)
                button:CenterHorizontal()
            end
        end

        slot.DoClick = function(panel)
            self:Call('DoSlotClick', nil, panel, it)
        end

        slot.amount = amount or 1
        
        -- local button = slot:Add('onyx.Button')
        -- button:SetText('USE')
        -- button:Font('Roboto@16')
        -- button:SizeToContentsX(onyx.ScaleWide(30))
        slot.button = button
    end
end

onyx.gui.Register('onyx.creditstore.Inventory', PANEL)