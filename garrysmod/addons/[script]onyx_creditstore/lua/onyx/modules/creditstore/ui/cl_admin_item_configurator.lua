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

local font0 = onyx.Font('Roboto@16')
local font1 = onyx.Font('Roboto@20')
local wimgLinked = onyx.wimg.Simple('https://i.imgur.com/jSCI5Ma.png', 'smooth mips')
local wimgLock = onyx.wimg.Simple('https://i.imgur.com/R9B3Zm3.png', 'smooth mips')

function PANEL:Init()
    local margin = onyx.ScaleTall(10)

    self.typeSettingsPanels = {}
    self.fields = {}

    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)
    self.list:DockMargin(margin, margin, margin, margin)

    -- IDENTIFIER
    self:AddField({
        key = 'id',
        name = 'IDENTIFIER',
        desc = 'The unique identifier of the item.',
        icon = 'https://i.imgur.com/GUrwAHN.png',
        type = 'string',
        placeholder = 'money10k'
    })
    -- TYPE
    do
        local options = {}

        for id, data in pairs(onyx.creditstore.types) do
            table.insert(options, {
                text = onyx.lang:Get(data.fullName or data.name),
                data = id
            })
        end

        table.sort(options, function(a, b)
            return a.text < b.text
        end)
    
        self:AddField({
            key = 'type',
            name = 'TYPE',
            desc = 'The type of the item.',
            icon = 'https://i.imgur.com/4sjUcaV.png',
            type = 'combo',
            options = options,
            onChoose = function(index, text, data)
                self:OnTypeChanged(data)
            end
        })
    end
    -- NAME
    self:AddField({
        key = 'name',
        name = 'NAME',
        desc = 'The name of the item.',
        icon = 'https://i.imgur.com/tRA1npP.png',
        type = 'string',
        placeholder = '$10 000'
    })
    -- PRICE
    self:AddField({
        key = 'price',
        name = 'PRICE',
        desc = 'The price of the item.',
        webImage = 'creditstore_truecurrency3',
        type = 'number',
        placeholder = '10000'
    })
    -- ICON
    self:AddField({
        key = 'icon',
        name = 'ICON',
        desc = 'The icon/model of the item.',
        icon = 'https://i.imgur.com/hiJ6Qft.png',
        type = 'icon/model'
    })
    -- CATEGORY
    do
        local options = {}

        for id, data in pairs(onyx.creditstore.categories) do
            table.insert(options, {
                text = data.name,
                data = id,
                iconURL = data.icon,
                iconParams = 'smooth mips'
            })
        end

        self:AddField({
            key = 'category',
            name = 'CATEGORY',
            desc = 'The category of the item.',
            icon = 'https://i.imgur.com/tXOFRPL.png',
            type = 'combo',
            options = options
        })
    end

    self.btnCreate = self.list:Add('onyx.Button')
    self.btnCreate:SetText(onyx.lang:Get('create_u'))
    self.btnCreate:SetZPos(99)
end

function PANEL:PerformLayout(w, h)

end

function PANEL:ItemCreation()
    self.fields.category.combo:ChooseOptionID(1)
    self.btnCreate.DoClick = function(panel)
        local itemData = self:GenerateItemData()
        if (itemData) then
            net.Start('onyx.creditstore:CreateItem')
                onyx.net.WriteTable(itemData)
            net.SendToServer()

            self:Call('OnEditRequested')

            surface.PlaySound('onyx/ui/on_affirm/echo_affirm1.wav')
        else
            surface.PlaySound('onyx/ui/on_deny/echo_deny.wav')
        end
    end
end

function PANEL:GenerateItemData(bEdit)
    local fields = self.fields
    local item = {}

    item.id = fields.id.entry:GetValue()
    item.name = fields.name.entry:GetValue()
    item.price = fields.price.entry:GetValue()
    item.type = fields.type.combo:GetOptionData() or ''
    item.category = fields.category.combo:GetOptionData() or ''
    
    local isIcon3D = fields.icon.picker:GetOptionData()

    if (isIcon3D) then
        item.model = fields.icon.entry:GetValue()
    else
        item.icon = fields.icon.entry:GetValue()
    end

    local sorted = {'id', 'type', 'name', 'price', 'model', 'icon', 'category'}

    if (bEdit) then
        table.RemoveByValue(sorted, 'id')
    end
    
    for _, key in ipairs(sorted) do
        local value = item[key]
        if not value then continue end

        local valid, reason = onyx.creditstore:ValidateFieldValue(key, value)
        -- print(key, valid, reason)
        if (not valid) then
            notification.AddLegacy(reason, 1, 3)

            local fieldKey = key
            if (fieldKey == 'model') then
                fieldKey = 'icon'
            end

            if (fields[fieldKey]) then
                if (fields[fieldKey].entry) then
                    fields[fieldKey].entry:Highlight(Color(179, 70, 70))
                elseif (fields[fieldKey].combo) then
                    fields[fieldKey].combo:Highlight(Color(179, 70, 70))
                end
            end

            return false
        end
    end

    --[[------------------------------
    Go through item's type required data
    --------------------------------]]
    item.data = {}

    local typeData = onyx.creditstore.types[item.type]

    for _, option in ipairs(typeData.settings or {}) do
        local key = option.key
        local field = self.typeSettingsPanels[key]
        assert(field, 'no field found for type settings (' .. key .. ')')

        local value
        local highlightPanel
        if (option.type == 'string') then
            value = field.entry:GetValue()
            highlightPanel = field.entry
        elseif (option.type == 'number') then
            value = tonumber(field.entry:GetValue())
            highlightPanel = field.entry
        elseif (option.type == 'combo') then
            value = field.combo:GetOptionData()
            highlightPanel = field.combo
        end

        local valid, reason = option.validateOption(value)
        if (not valid) then
            if (reason) then
                notification.AddLegacy(reason, 1, 5)
            else
                notification.AddLegacy('Something wrong with ' .. option.name .. ' field.', 1, 5)
            end
            if (highlightPanel) then
                highlightPanel:Highlight(Color(179, 70, 70))
            end
            return false
        end

        item.data[key] = value
    end

    return item
end

function PANEL:AddField(data, attached)
    local padding = onyx.ScaleTall(7)

    data.desc = onyx.lang:GetWFallback(data.name .. '_Desc', data.desc)
    data.name = onyx.lang:Get(data.name)

    local field = self.list:Add('DPanel')
    field:SetTall(onyx.ScaleTall(85))
    field:Dock(TOP)
    field:DockMargin(0, 0, 0, onyx.ScaleTall(5))
    field.Paint = function(p, w, h)
        draw.RoundedBox(8, 0, 0, w, h, colorSecondary)
    end
    self.fields[data.key] = field

    local info = field:Add('Panel')
    info:Dock(TOP)
    info:SetTall(field:GetTall() * .5)
    info:DockPadding(padding, padding, padding, padding)
    info.Paint = function(p, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, colorTertiary, true, true)
        
        -- surface.SetDrawColor(0, 0, 0, 100)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawRect(0, h - 1, w, 1)

        local child = field.entry or field.combo
        local locked = child:GetDisabled()
        local size = onyx.ScaleTall(12)

        if (locked) then
            wimgLock:Draw(w - h * .5 - size * .5, h * .5 - size * .5, size, size, colorRed)
        elseif (attached) then
            wimgLinked:Draw(w - h * .5 - size * .5, h * .5 - size * .5, size, size, colorGray)
        end
    end

    local icon = info:Add('onyx.Image')
    icon:Dock(LEFT)
    icon:SetWide(info:GetTall() - padding * 2)
    if (data.webImage) then
        icon:SetWebImage(data.webImage, 'smooth mips')
    else
        icon:SetURL(data.icon, 'smooth mips')
    end
    icon:SetImageWide(onyx.ScaleTall(16))
    icon:SetImageTall(icon:GetImageWide())

    local lblName = info:Add('onyx.Label')
    lblName:Font('Roboto@14')
    lblName:SetText(data.name)
    lblName:Color(colorAccent)
    lblName:Dock(FILL)

    if (attached) then
        lblName:Color(onyx.GetOppositeAccentColor())
    end

    local lblDesc = info:Add('onyx.Label')
    lblDesc:Font('Roboto@14')
    lblDesc:SetText(data.desc)
    lblDesc:SizeToContentsY()
    lblDesc:Dock(BOTTOM)

    local content = field:Add('Panel')
    content:Dock(FILL)
    content:DockPadding(padding, padding, padding, padding)

    if (data.type == 'combo') then
        local combo = content:Add('onyx.ComboBox')
        combo:Dock(FILL)
        combo.OnSelect = function(panel, index, text, optionData)
            if (data.onChoose) then
                data.onChoose(index, text, optionData, self.fields)
            end
        end

        local options = data.getOptions and data.getOptions() or data.options

        for _, option in pairs(options) do
            combo:AddOptionAdvanced(option)
        end

        field.combo = combo
    elseif (data.type == 'icon/model') then
        local divider = content:Add('Panel')
        divider:Dock(FILL)

        local entry = divider:Add('onyx.TextEntry')
        entry:Dock(FILL)

        field.entry = entry

        local picker = divider:Add('onyx.ComboBox')
        picker:Dock(LEFT)
        picker:SetWide(onyx.ScaleWide(100))
        picker:DockMargin(0, 0, onyx.ScaleWide(5), 0)
        picker:AddOptionAdvanced({
            text = onyx.lang:Get('icon'),
            iconURL = 'https://i.imgur.com/QhuSK6f.png',
            iconParams = 'smooth mips',
            data = false
        })
        picker:AddOptionAdvanced({
            text = onyx.lang:Get('model'),
            iconURL = 'https://i.imgur.com/9mcE5Ge.png',
            iconParams = 'smooth mips',
            data = true
        })
        picker.OnSelect = function(panel, index, text, data)
            entry:SetValue('')
            if (data) then
                entry:SetPlaceholderText('Write the path to the model')
            else
                entry:SetPlaceholderText('Write the URL to the icon')
            end
        end

        picker:ChooseOptionID(1)

        field.picker = picker
    else
        local entry = content:Add('onyx.TextEntry')
        entry:Dock(FILL)
        entry:SetPlaceholderText(data.placeholder)

        field.entry = entry
    end

    return field
end

function PANEL:OnTypeChanged(typeName)
    for key, child in pairs(self.typeSettingsPanels) do
        child:Remove()
    end

    self.typeSettingsPanels = {}

    local data = onyx.creditstore.types[typeName]

    local iconValue = self.fields.icon.entry:GetValue()
    if (iconValue == '' or iconValue == (self.fields.icon.oldModel or '')) then
        if (data.defaultIcon) then
            self.fields.icon.picker:ChooseOptionID(1)
            self.fields.icon.entry:SetValue(data.defaultIcon)
            self.fields.icon.oldModel = data.defaultIcon
        else
            self.fields.icon.entry:SetValue('')
            self.fields.icon.oldModel = nil
        end
    end

    for _, option in ipairs(data.settings or {}) do
        local field = self:AddField(option, true)

        self.typeSettingsPanels[option.key] = field
    end

    self.oldTypeData = data
end

function PANEL:ItemEditor(itemID, itemTable)
    local fields = self.fields

    -- PrintTable(itemTable)

    fields.id.entry:SetValue(itemTable.id)
    fields.id.entry:SetDisabled(true)

    fields.name.entry:SetValue(itemTable.name)

    fields.price.entry:SetValue(tostring(itemTable.price))

    if (itemTable.model) then
        fields.icon.picker:ChooseOptionID(2)
        fields.icon.entry:SetValue(itemTable.model)
    else
        fields.icon.picker:ChooseOptionID(1)
        fields.icon.entry:SetValue(itemTable.icon)
    end

    local itemType = itemTable.type
    local _, index = fields.type.combo:FindOptionByData(itemType)

    if (index) then
        fields.type.combo:ChooseOptionID(index)

        local itemTypeData = onyx.creditstore.types[itemType]

        for _, option in ipairs(itemTypeData.settings or {}) do
            local key = option.key
            local field = self.typeSettingsPanels[key]
            local value = itemTable.data[key]

            if (option.type == 'string' or option.type == 'number') then
                field.entry:SetValue(value)
            elseif (option.type == 'combo') then
                local _, index2 = field.combo:FindOptionByData(value)
                if (index2) then
                    field.combo:ChooseOptionID(index2, true) -- ignores `OnSelect` event
                    field.combo:Highlight(onyx:Config('colors.positive'), 3)
                else
                    field.combo:SetCurrentOptionText('NOT FOUND: ' .. tostring(value))
                    field.combo:Highlight(onyx:Config('colors.negative'))
                end
            end
        end
    else
        fields.type.combo:SetCurrentOptionText('INVALID ITEM TYPE: ' .. itemType)
        fields.type.combo:Highlight(onyx:Config('colors.negative'))

        self.btnCreate:SetDisabled(true)
    end

    local category = itemTable.category
    local _, index = fields.category.combo:FindOptionByData(category)
    if (index) then
        fields.category.combo:ChooseOptionID(index)
    else
        fields.category.combo:SetCurrentOptionText('INVALID CATEGORY: ' .. category)
        fields.category.combo:Highlight(onyx:Config('colors.negative'))
    end

    -- fields.type.combo:SetDisabled(true)

    self.btnDelete = self.list:Add('onyx.Button')
    self.btnDelete:SetText(onyx.lang:Get('delete_u'))
    self.btnDelete:SetZPos(100)
    self.btnDelete:SetColorIdle(onyx:Config('colors.negative'))
    self.btnDelete:SetColorHover(onyx.OffsetColor(self.btnDelete:GetColorIdle(), -30))
    self.btnDelete.DoClick = function()
        net.Start('onyx.creditstore:DeleteItem')
            net.WriteString(itemID)
        net.SendToServer()

        self:Call('OnEditRequested')
    end

    self.btnCreate:SetText(onyx.lang:Get('edit_u'))
    self.btnCreate.DoClick = function(panel)
        local itemData = self:GenerateItemData(true)
        if (itemData) then
            local id = itemData.id

            itemData.id = nil
            -- itemData.type = nil

            net.Start('onyx.creditstore:EditItem')
                net.WriteString(id)
                onyx.net.WriteTable(itemData)
            net.SendToServer()

            self:Call('OnEditRequested')

            surface.PlaySound('onyx/ui/on_affirm/echo_affirm1.wav')
        else
            surface.PlaySound('onyx/ui/on_deny/echo_deny.wav')
        end
    end
end

onyx.gui.Register('onyx.creditstore.AdminItemConfigurator', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .33, .5, function(self)
--     self:MakePopup()

--     local content = self:Add('onyx.creditstore.AdminItemConfigurator')
--     content:Dock(FILL)
--     content.OnEditRequested = function()
--         self:Remove()
--     end
-- end)