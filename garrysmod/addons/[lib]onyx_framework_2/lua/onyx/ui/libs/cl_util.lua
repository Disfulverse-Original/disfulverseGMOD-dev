--[[

Author: tochnonement
Email: tochnonement@gmail.com

05/06/2022

--]]

do
    local Lerp = Lerp
    local Color = Color
    local Clamp = math.Clamp
    function onyx.LerpColor(speed, from, to)
        local r = Lerp(speed, from.r, to.r)
        local g = Lerp(speed, from.g, to.g)
        local b = Lerp(speed, from.b, to.b)
        local a = Lerp(speed, from.a, to.b)

        if r == to.r and g == to.g and b == to.b == a == to.a then
            return from
        end

        return Color(r, g, b, a)
    end

    function onyx.CopyColor(color)
        assert(color, 'missing color')
        return Color(color.r, color.g, color.b, color.a)
    end

    function onyx.ColorBetween(clr1, clr2, fraction)
        fraction = fraction or .5
        local r = Lerp(fraction, clr1.r, clr2.r)
        local g = Lerp(fraction, clr1.g, clr2.g)
        local b = Lerp(fraction, clr1.b, clr2.b)
        return Color(r, g, b)
    end

    function onyx.OffsetColor(color, offset)
        assert(color, 'missing color')

        offset = offset or 0
        
        local r = Clamp(color.r + offset, 0, 255)
        local g = Clamp(color.g + offset, 0, 255)
        local b = Clamp(color.b + offset, 0, 255)

        return Color(r, g, b)
    end

    function onyx.ColorEditHSV(color, hue, saturation, value)
        local h, s, v = ColorToHSV(color)
        return HSVToColor(hue or h, saturation or s, value or v)
    end

    function onyx.GetOppositeAccentColor()
        local color = onyx:Config('colors.accent')
        local h, s, v = ColorToHSV(color)
        return onyx.ColorEditHSV(color, (h + 180) % 360)
    end
end

do
    local matBlur = Material('pp/blurscreen')

    local UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
    local DrawTexturedRect = surface.DrawTexturedRect
    local SetMaterial = surface.SetMaterial
    local SetDrawColor = surface.SetDrawColor

    function onyx.DrawBlurExpensive(panel, amount)
        local x, y = panel:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()
    
        SetDrawColor(255, 255, 255)
        SetMaterial(matBlur)
    
        for i = 1, 3 do
            matBlur:SetFloat('$blur', (i / 3) * (amount or 6))
            matBlur:Recompute()
            UpdateScreenEffectTexture()
            DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end
end

do
    local DrawTexturedRectRotated = surface.DrawTexturedRectRotated
    local DrawTexturedRect = surface.DrawTexturedRect
    local SetDrawColor = surface.SetDrawColor
    local SetMaterial = surface.SetMaterial

    function onyx.DrawMaterial(mat, x, y, w, h, color)
        color = color or color_white

        SetMaterial(mat)
        SetDrawColor(color)
        DrawTexturedRect(x, y, w, h)
    end

    function onyx.DrawMaterialRotated(mat, x, y, w, h, angle, color)
        color = color or color_white
        angle = angle or 0

        SetMaterial(mat)
        SetDrawColor(color)
        DrawTexturedRectRotated(x + w * .5, y + h * .5, w, h, angle)
    end
end

function onyx.DrawTextInBox(text, font, x, y, roundness, paddingX, paddingY, textColor, boxColor, alignmentX, alignmentY)
    alignmentX = alignmentX or 1
    alignmentY = alignmentY or 1

    surface.SetFont(font)
    local textW, textH = surface.GetTextSize(text)

    textW = textW + paddingX * 2
    textH = textH + paddingY * 2

    draw.RoundedBox(roundness, x - textW * .5, y - textH * .5, textW, textH, boxColor)
    draw.SimpleText(text, font, x, y, textColor, alignmentX, alignmentY)
end

do
    local matGradientToBottom = Material('vgui/gradient-u')
    local matGradientToTop = Material('vgui/gradient-d')

    local SetMaterial = surface.SetMaterial
    local SetDrawColor = surface.SetDrawColor
    local DrawTexturedRect = surface.DrawTexturedRect

    function onyx.DrawMatGradient(x, y, w, h, dir, color)
        if dir == BOTTOM then
            SetMaterial(matGradientToBottom)
        else
            SetMaterial(matGradientToTop)
        end
        SetDrawColor(color)
        DrawTexturedRect(x, y, w, h)
    end
end

function onyx.GetTextSize(text, font)
    surface.SetFont(font)
    return surface.GetTextSize(text)
end

do
    local ScrW = ScrW
    local ScrH = ScrH
    local Round = math.Round

    function onyx.ScaleWide(w, ref)
        ref = ref or 1600
        return Round(w / ref * ScrW())
    end

    function onyx.ScaleTall(h, ref)
        ref = ref or 900
        return Round(h / ref * ScrH())
    end
end

--[[------------------------------
SHAPES
--------------------------------]]
function onyx.CalculateCircle(x0, y0, radius, vertices)
    local tbl, count = {}, 0
    local step = math.Round(360 / vertices)

    for ang = 0, 360, step do
        local rad = math.rad(ang)
        local cos = math.cos(rad)
        local sin = math.sin(rad)

        local x = x0 + radius * cos
        local y = y0 + radius * sin

        count = count + 1
        tbl[count] = {x = x, y = y}
    end

    return tbl
end

do
    local function calculateCircle(x, y, ang, p, rad, seg)
        seg = seg or 80
        ang = (-ang) + 180

        local circle = {}

        for i = 0, seg do
            local a = math.rad((i / seg) * -p + ang)

            table.insert(circle, {x = x + math.sin(a) * rad, y = y + math.cos(a) * rad})
        end

        return circle
    end

    -- Custom
    function onyx.CalculateRoundedBoxEx(r, x, y, w, h, ruCorner, rbCorner, ldCorner, lbCorner)
        r = math.ceil(math.min(r, h / 2))

        if (r == 0) then
            ruCorner = false
            rbCorner = false
            ldCorner = false
            lbCorner = false
        end

        local vertices = {}

        table.insert(vertices, {x = x + r, y = y})

        -- Right Upper Corner
        if (ruCorner) then
            table.insert(vertices, {x = x + w - r, y = y})
            table.Add(vertices, calculateCircle(x + w - r, y + r, 0, 90, r, r))
            table.insert(vertices, {x = x + w, y = y + r})
        else
            table.insert(vertices, {x = x + w, y = y})
        end

        -- Right Bottom Corner
        if (rbCorner) then
            table.insert(vertices, {x = x + w, y = y + h - r})
            table.Add(vertices, calculateCircle(x + w - r, y + h - r, 90, 90, r, r))
            table.insert(vertices, {x = x + w - r, y = y + h})
        else
            table.insert(vertices, {x = x + w, y = y + h})
        end

        -- Left Bottom Corner
        if (ldCorner) then
            table.insert(vertices, {x = x + r, y = y + h})
            table.Add(vertices, calculateCircle(x + r, y + h - r, 180, 90, r, r))
            table.insert(vertices, {x = x, y = y + h - r})
        else
            table.insert(vertices, {x = x, y = y + h})
        end

        -- Left Upper Corner
        if (lbCorner) then
            table.insert(vertices, {x = x, y = y + r})
            table.Add(vertices, calculateCircle(x + r, y + r, 270, 90, r, r))
            table.insert(vertices, {x = x + r, y = y})
        else
            table.insert(vertices, {x = x, y = y})
        end

        return vertices
    end

    function onyx.CalculateRoundedBox(r, x, y, w, h)
        return onyx.CalculateRoundedBoxEx(r, x, y, w, h, true, true, true, true)
    end
end

function onyx.DrawPoly(poly, color, material)
    if (not poly or #poly < 1) then
        return
    end

    if (material) then
        surface.SetMaterial(material)
    else
        draw.NoTexture()
    end

    surface.SetDrawColor(color or color_white)
    surface.DrawPoly(poly)
end

--[[------------------------------
MASKING
--------------------------------]]
function onyx.MaskFn(funcMask, funcDraw)
	render.SetStencilWriteMask(255)
	render.SetStencilTestMask(255)
	render.SetStencilReferenceValue(0)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_NEVER)
	render.SetStencilFailOperation(STENCIL_REPLACE)

    funcMask()
    
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)

    funcDraw()

    render.SetStencilEnable(false)
end