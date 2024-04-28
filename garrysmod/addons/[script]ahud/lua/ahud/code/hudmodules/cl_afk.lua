local CurTime = CurTime
local draw = draw
local surface = surface
local math = math


// Get darker color than HUD_Bad for background
local stripes = Material("akulla/flux/stripes.png", "smooth noclamp")
local red = ahud.Colors.HUD_Bad
local hue, sat = ColorToHSV(red)

local packedClr = HSVToColor(hue, sat, 0.45)
local r, g, b = packedClr.r, packedClr.g, packedClr.b

local function c()
    hook.Remove("HUDPaint", "AFK_HUD")
end

c()
hook.Add("DarkRPFinishedLoading", "ahud_removeAFK", c)
hook.Add("OnReloaded", "ahud_removeAFK", c)

hook.Add("ahud_draw", "ahud_AFK", function(local_ply, w, h)
    if !DarkRP or ahud.DisableModules.AFK then return end

    local isAFK = local_ply:getDarkRPVar("AFK")
    if !isAFK then return end

    surface.SetMaterial(stripes)
    surface.SetDrawColor(r, g, b, math.abs(math.sin(CurTime() * 3)) * 20 + 5)

    local slide = CurTime() * 2
    surface.DrawTexturedRectUV(0, h * 0.1, w, h * 0.3, slide, 0, 50 + slide, 2)

    surface.SetDrawColor(red)
    surface.DrawRect(0, h * 0.1, w, 2)
    surface.DrawRect(0, h * 0.4, w, 2)

    local center = w / 2

    local _, texth = draw.SimpleText("\"", "ahud_Icon64", center, h * 0.15, color_white, 1, 1)
    texth = texth + select(2, draw.SimpleText(ahud.L("AFKSince"), "ahud_40", center, h * 0.15 + texth, color_white, 1, 0))

    //
    local mainStr

    if !LocalPlayer():getDarkRPVar("AFKDemoted") then
        mainStr = DarkRP.getPhrase("no_auto_demote")
    else
        mainStr = DarkRP.getPhrase("youre_afk_demoted")
    end
    draw.SimpleText(mainStr, "ahud_60", center, h * 0.15 + texth, color_white, 1, 0)
    //

    draw.SimpleText(DarkRP.getPhrase("salary_frozen") .. " " .. DarkRP.getPhrase("afk_cmd_to_exit"), "ahud_17", center, h * 0.36, color_white, 1, 0)
end)