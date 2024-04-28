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
local colorOutline = Color(255, 255, 255, 5)
local colorShade = Color(0, 0, 0, 50)
local colorGray = onyx:Config('colors.gray')

local matGradientToBottom = Material('vgui/gradient-u', 'smooth mips')

local font0 = onyx.Font('Roboto@16')
local font1 = onyx.Font('Roboto@14')

AccessorFunc(PANEL, 'm_Name', 'Name')
AccessorFunc(PANEL, 'm_Category', 'Category')
AccessorFunc(PANEL, 'm_Color', 'Color')
AccessorFunc(PANEL, 'm_Price', 'Price')
AccessorFunc(PANEL, 'm_bPriceTagVisible', 'PriceTagVisible')
AccessorFunc(PANEL, 'm_bLabelHidden', 'LabelHidden')

function PANEL:Init()
    self:SetName('INVALID')
    self:SetCategory('Unknown')
    self:Import('click')
    self:Import('hovercolor')
    self:SetColorKey('backgroundColor')
    self:SetColorIdle(colorSecondary)
    self:SetColorHover(onyx.OffsetColor(colorSecondary, 5))
    self:SetColor(color_white)
    self:AddHoverSound()
    self:AddClickEffect()
    self.textOwned = onyx.lang:Get('owned_u')
end

local wimgCoin = onyx.wimg.Create('creditstore_truecurrency3', 'smooth mips')
local bGradient = false
function PANEL:Paint(w, h)
    local x, y = self:LocalToScreen(0, 0)
	-- onyx.bshadows.BeginShadow()
        -- surface.SetDrawColor(colorSecondary)
        -- surface.DrawRect(0, 0, w, h)
    -- onyx.bshadows.EndShadow(1, 5, .001, nil, 0, 2)

    -- surface.SetDrawColor(self.backgroundColor)
    -- surface.DrawRect(0, 0, w, h)

    -- surface.SetDrawColor(255, 255, 255, 1)
    -- surface.SetDrawColor(0, 0, 0, 50)
    draw.RoundedBox(8, 0, 0, w, h, colorOutline)

    draw.RoundedBox(8, 1, 1, w - 2, h - 2, self.backgroundColor)
    
    local headerHeight = math.ceil(h * .2)
    local headerColor = onyx.ColorBetween(colorPrimary, colorSecondary)

    if (not self.m_bLabelHidden) then
        -- surface.SetDrawColor(0, 0, 0, 75)
        -- surface.DrawRect(0, 0, w, headerHeight)
        draw.RoundedBoxEx(8, 0, 0, w, headerHeight, colorShade, true, true)
    
        if (bGradient) then
            onyx.DrawMatGradient(0, 0, w, headerHeight, BOTTOM, ColorAlpha(self:GetColor(), 10))
        
            surface.SetDrawColor(self:GetColor())
            surface.DrawRect(0, headerHeight - 1, w, 1)
        end
    
        draw.SimpleText(self:GetName(), font0, w * .5, headerHeight * .5, color_white, 1, 4)
        draw.SimpleText(self:GetCategory(), font1, w * .5, headerHeight * .5, self:GetColor(), 1, 0)
    end

    if (self.icon) then
        local size = math.ceil(math.min(w, h) * .5)
        
        self.icon:Draw(w * .5 - size * .5, h * .5 - size * .5, size, size)
    end

    if (self:GetPriceTagVisible()) then
        -- surface.SetDrawColor(0, 0, 0, 75)
        -- surface.DrawRect(0, h - headerHeight, w, headerHeight)
        draw.RoundedBoxEx(8, 0, h - headerHeight, w, headerHeight, colorShade, nil, nil, true, true)

        if (self.owned) then
            draw.SimpleText(self.textOwned, font0, w * .5, h - headerHeight * .5, colorGray, 1, 1)
        elseif (self.status) then
            draw.SimpleText(self.status, font0, w * .5, h - headerHeight * .5, colorGray, 1, 1)
        else
            local price = self:GetPrice()
            local iconSize = onyx.ScaleTall(14)
            local textPrice = onyx.creditstore.FormatMoney(price)
            local textW = onyx.GetTextSize(textPrice, font0)
            local space = onyx.ScaleWide(5)
            local totalW = textW + iconSize + space
            local x = w * .5 - totalW * .5
    
            wimgCoin:Draw(x, h - headerHeight * .5 - iconSize * .5, iconSize, iconSize, colorAccent)
            draw.SimpleText(textPrice, font0, x + iconSize + space, h - headerHeight * .5, color_white, 0, 1)
        end
    end
end

function PANEL:PerformLayout(w, h)
    local headerHeight = math.ceil(h * .2)
    if (IsValid(self.dmodel)) then
        self.dmodel:DockMargin(0, headerHeight, 0, headerHeight)
    end
end

function PANEL:Think()
    if ((self.nextThink or 0) <= CurTime()) then
        local itemTable = self.itemTable
        local itemTypeData = self.itemTypeData
    
        if (itemTypeData and self.store) then
            if (itemTypeData.noDuplicates) then
                self.owned = onyx.creditstore:GetPlayerItemAmount(LocalPlayer(), itemTable.id) > 0
            end
        end

        self.nextThink = CurTime() + .1
    end
end

function PANEL:SetItem(itemID, itemData)
    local item = onyx.creditstore.items[itemID]

    if (item) then
        local model = item.model
        local icon = item.icon
        local type = item.type
        local typeData = onyx.creditstore.types[type]
        local typeName = typeData and typeData.name or '_UNKNOWN_'
        local typeColor = typeData and typeData.color or onyx:Config('colors.negative')

        self:SetName(item.name:upper())
        self:SetCategory(onyx.lang:Get(typeName))
        self:SetColor(typeColor)
        self:SetPrice(item.price)
        self.itemTable = item
        self.itemTypeData = typeData
        self.itemData = itemData
        self.equipped = itemData and itemData.equipped

        if (model) then
            
            self.dmodel = self:Add('DModelPanel')
            self.dmodel:Dock(FILL)
            self.dmodel:SetMouseInputEnabled(false)
            self.dmodel:SetModel(model)

            if (type:find('vehicle')) then
                self.dmodel:SetCamPos(Vector(0, 200, -15))
                self.dmodel.LayoutEntity = function(panel, ent) 
                    ent:SetAngles(Angle(0, 25, -15))
                end
            else
                local ent = self.dmodel.Entity
                if (IsValid(ent)) then
                    if (typeData.setupModelPanel) then
                        typeData.setupModelPanel(self.dmodel, item)
                    else
                        local min, max = ent:GetRenderBounds()
                        local center = (min + max) / 2
                        local distance = 0
        
                        for _, key in ipairs({"x", "y", "z"}) do
                            distance = math.max(distance, max[key])
                        end
        
                        self.dmodel:SetLookAt(center)
                        self.dmodel:SetFOV(distance + 20)
                        self.dmodel.LayoutEntity = function() end
                    end
                end
            end
        elseif (icon) then

            self.icon = onyx.wimg.Simple(icon, '')

        end
    else
        self:SetName('(' .. itemID .. ')')
    end
end

onyx.gui.Register('onyx.creditstore.Item', PANEL)