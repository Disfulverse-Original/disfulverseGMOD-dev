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

    self.fields = {}

    self.list = self:Add('onyx.ScrollPanel')
    self.list:Dock(FILL)
    self.list:DockMargin(margin, margin, margin, margin)

    -- IDENTIFIER
    self:AddField({
        key = 'id',
        name = 'IDENTIFIER',
        desc = 'The unique identifier of the category.',
        icon = 'https://i.imgur.com/GUrwAHN.png',
        type = 'string',
        placeholder = 'knives'
    })
    -- NAME
    self:AddField({
        key = 'name',
        name = 'NAME',
        desc = 'The name of the category.',
        icon = 'https://i.imgur.com/tRA1npP.png',
        type = 'string',
        placeholder = 'Knives'
    })
    -- ORDER
    self:AddField({
        key = 'order',
        name = 'ORDER',
        desc = 'The order of the category.',
        icon = 'https://i.imgur.com/l1JfnNY.png',
        type = 'number',
        placeholder = '1'
    })
    -- ICON
    self:AddField({
        key = 'icon',
        name = 'ICON',
        desc = 'The icon of the category.',
        icon = 'https://i.imgur.com/hiJ6Qft.png',
        type = 'string',
        placeholder = 'https://i.imgur.com/09h2MHS.png'
    })

    self.btnCreate = self.list:Add('onyx.Button')
    self.btnCreate:SetText(onyx.lang:Get('create_u'))
    self.btnCreate:SetZPos(99)
end

function PANEL:PerformLayout(w, h)

end

function PANEL:CategoryCreation()
    self.btnCreate.DoClick = function(panel)
        local categoryData = self:GenerateCategoryData()
        if (categoryData) then
            net.Start('onyx.creditstore:CreateCategory')
                onyx.net.WriteTable(categoryData)
            net.SendToServer()

            self:Call('OnEditRequested')

            surface.PlaySound('onyx/ui/on_affirm/echo_affirm1.wav')
        else
            surface.PlaySound('onyx/ui/on_deny/echo_deny.wav')
        end
    end
end

function PANEL:GenerateCategoryData(bEdit)
    local fields = self.fields
    local category = {}

    category.id = fields.id.entry:GetValue()
    category.name = fields.name.entry:GetValue()
    category.order = fields.order.entry:GetValue()
    category.icon = fields.icon.entry:GetValue()

    local sorted = {'id', 'name', 'order', 'icon'}

    if (bEdit) then
        table.RemoveByValue(sorted, 'id')
    end
    
    for _, key in ipairs(sorted) do
        local value = category[key]
        if not value then continue end

        local valid, reason = onyx.creditstore:ValidateFieldValue(key, value)
        -- print(key, valid, reason)
        if (not valid) then
            notification.AddLegacy(reason, 1, 3)

            local fieldKey = key
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

    return category
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
            text = 'Icon',
            iconURL = 'https://i.imgur.com/QhuSK6f.png',
            iconParams = 'smooth mips',
            data = false
        })
        picker:AddOptionAdvanced({
            text = 'Model',
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

function PANEL:CategoryEditor(categoryID, categoryTable)
    local fields = self.fields

    -- PrintTable(categoryTable)

    fields.id.entry:SetValue(categoryTable.id)
    fields.id.entry:SetDisabled(true)

    fields.name.entry:SetValue(categoryTable.name)

    fields.order.entry:SetValue(tostring(categoryTable.order))

    fields.icon.entry:SetValue(categoryTable.icon)

    self.btnDelete = self.list:Add('onyx.Button')
    self.btnDelete:SetText(onyx.lang:Get('delete_u'))
    self.btnDelete:SetZPos(100)
    self.btnDelete:SetColorIdle(onyx:Config('colors.negative'))
    self.btnDelete:SetColorHover(onyx.OffsetColor(self.btnDelete:GetColorIdle(), -30))
    self.btnDelete.DoClick = function()
        net.Start('onyx.creditstore:DeleteCategory')
            net.WriteString(categoryID)
        net.SendToServer()

        self:Call('OnEditRequested')
    end

    self.btnCreate:SetText(onyx.lang:Get('edit_u'))
    self.btnCreate.DoClick = function(panel)
        local categoryData = self:GenerateCategoryData(true)
        if (categoryData) then
            local id = categoryData.id

            categoryData.id = nil

            net.Start('onyx.creditstore:EditCategory')
                net.WriteString(id)
                onyx.net.WriteTable(categoryData)
            net.SendToServer()

            self:Call('OnEditRequested')

            surface.PlaySound('onyx/ui/on_affirm/echo_affirm1.wav')
        else
            surface.PlaySound('onyx/ui/on_deny/echo_deny.wav')
        end
    end
end

onyx.gui.Register('onyx.creditstore.AdminCategoryConfigurator', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .33, .5, function(self)
--     self:MakePopup()

--     local content = self:Add('onyx.creditstore.AdminCategoryConfigurator')
--     content:Dock(FILL)
--     content:CategoryCreation()
--     content.OnEditRequested = function()
--         self:Remove()
--     end
-- end)