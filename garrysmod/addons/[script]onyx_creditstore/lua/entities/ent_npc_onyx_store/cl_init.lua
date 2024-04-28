include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH -- to render in front of doors and etc.

function ENT:Draw()
    self:DrawModel()
    self:DrawInfo()
end

local renderDistance = 512 ^ 2
local font = 'onyx.creditstore.3d2d'
local vectorOffset = Vector(0, 0, 78)
local vectorOffsetAnimated = Vector(0, 0, 0)
local colorBG = Color(0, 0, 0, 200)
local colorAccent = onyx:Config('colors.accent')
local colorPrimary = onyx:Config('colors.primary')

surface.CreateFont(font, {
    font = 'Roboto',
    size = 64, -- no scaling for 3d2d
    extended = true
})

function ENT:DrawInfo()
    vectorOffsetAnimated.z = math.sin(CurTime()) * 1
    
    local pos = self:GetPos() + vectorOffset + vectorOffsetAnimated
    local ang = Angle(0, EyeAngles().y - 90, 90)

    if (pos:DistToSqr(LocalPlayer():GetPos()) > renderDistance) then
        return
    end

    cam.Start3D2D(pos, ang, .05)
        surface.SetFont(font)
        local text = onyx.creditstore:GetOptionValue('npc_label')
        local textw, texth = surface.GetTextSize(text)
        local margin = 20
        local boxw, boxh = textw + margin * 2, texth + margin * 2
        local o = 3

        -- draw.RoundedBox(16, -boxw * .5, -boxh * .5, boxw, boxh, colorBG)
        draw.RoundedBox(16, -boxw * .5, -boxh * .5, boxw, boxh, colorAccent)
        draw.RoundedBox(16, -boxw * .5 + o, -boxh * .5 + o, boxw - o * 2, boxh - o * 2, colorPrimary)
        draw.SimpleText(text, font, 2, 2, color_black, 1, 1)
        draw.SimpleText(text, font, 0, 0, color_white, 1, 1)
    cam.End3D2D()
end