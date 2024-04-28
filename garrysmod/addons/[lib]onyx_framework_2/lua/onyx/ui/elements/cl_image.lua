--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/06/2022

--]]

PANEL = {}

AccessorFunc(PANEL, 'm_Material', 'Material')
AccessorFunc(PANEL, 'm_colColor', 'Color')
AccessorFunc(PANEL, 'm_iImageAngle', 'ImageAngle')
AccessorFunc(PANEL, 'm_iImageScale', 'ImageScale')
AccessorFunc(PANEL, 'm_iImageWide', 'ImageWide')
AccessorFunc(PANEL, 'm_iImageTall', 'ImageTall')

function PANEL:Init()
    self:SetImageScale(1)
    self:SetImageAngle(0)
    self:SetColor(color_white)
    self:SetURL('https://i.imgur.com/PnE3dNf.png', 'smooth mips')
end

function PANEL:SetImageSize(w, h)
    h = h or w -- square

    self:SetImageWide(w)
    self:SetImageTall(h)
end

function PANEL:SetURL(url, parameters)
    self.m_WebImage = onyx.wimg.Simple(url, parameters)
end

function PANEL:SetWebImage(id, parameters)
    self.m_WebImage = onyx.wimg.Create(id, parameters)
end

function PANEL:SetImage(path, params)
    self:SetMaterial(Material(path, params))
end

function PANEL:GetWebImage()
    return self.m_WebImage
end

function PANEL:Paint(w, h)
    self:Call('PaintBackground', nil, w, h)

    local webImage = self:GetWebImage()
    local material = self:GetMaterial()
    local color = self:GetColor()
    local scale = self:GetImageScale()
    local angle = self:GetImageAngle()
    local iw, ih = self:GetImageWide() or w, self:GetImageTall() or h
    local ix, iy = w * .5, h * .5

    iw = iw * scale
    ih = ih * scale

    if webImage then
        webImage:DrawRotated(ix, iy, iw, ih, angle, color)
    elseif material then
        onyx.DrawMaterialRotated(material, ix, iy, iw, ih, angle, color)
    end
end

onyx.gui.Register('onyx.Image', PANEL)

-- ANCHOR Test

-- onyx.gui.Test('onyx.Frame', .65, .65, function(self)
    
-- end)