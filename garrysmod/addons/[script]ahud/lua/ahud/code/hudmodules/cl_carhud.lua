if ahud.DisableModules.Speedometer then return end

// Cache Functions
local draw = draw
local surface = surface
local math = math
//

// Disable speedometer
local function disableSpeedometer()
    if SVMOD and !ahud.DisableModules.Speedometer then
        SVMOD:DisableHUD()
    end
end

disableSpeedometer()

hook.Add("PostGamemodeLoaded", "ahud_disableSpeedometers", function()
    timer.Simple(10, disableSpeedometer)
end)

// Functions to get vehicle infos
local function getVehHealth(veh)
    if veh.VC_getHealth then
        return veh:VC_getHealth(true) / 100
    elseif veh.SV_GetPercentHealth then
        return veh:SV_GetPercentHealth() / 100
    end
end

local function getVehSpeed(veh)
    if veh.VC_getSpeedKmH then
        return veh:VC_getSpeedKmH()
    elseif SVMOD and SVMOD:IsVehicle(veh) then
        return veh:SV_GetSpeed()
    end
end

local function getVehFuel(veh)
    if veh.VC_fuelGet then
        return veh:VC_fuelGet(true) / 100
    elseif veh.SV_GetFuel then
        return veh:SV_GetFuel() / veh:SV_GetMaxFuel()
    end
end

local icon_txt = {
    [2] = "Z",
    [1] = "e",
    [0] = "f",
}

local function getVehLights(veh)
    /*
        0: Running lights
        1: Low Beams
        2: High beams
    */

    local state
    if veh.VC_getStates then
        local cpy = veh:VC_getStates()

        if cpy.HighBeamsOn then
            state = 2
        elseif cpy.LowBeamsOn then
            state = 1
        else
            state = 0
        end
    elseif veh.SV_GetHeadlightsState then
        if veh:SV_GetHeadlightsState() then
            state = 2
        else
            state = 0
        end
    end

    if !state then
        return
    elseif state > 1 then
        return 1, icon_txt[state]
    end

    return 0, icon_txt[state]
end

// Position of icons, and their infos
local l = {
    {
        i = "3",
        f = function(veh)
            return getVehHealth(veh)
        end,
        w = -35 - 80,
    },

    {
        i = "a",
        f = function(veh)
            return getVehFuel(veh)
        end,
        w = -80,
    },

    {
        f = function(veh)
            return getVehLights(veh)
        end,
        w = 80,
    },
}

// Cache size/positions
local ang_start = 120
local r = ahud.GetSize(65)
local black_40 = ahud.Colors.C40
local iconSize = ahud.GetSize(30) / 2
local iconSize16 = ahud.GetSize(16) / 2

local size8 = ahud.GetSize(8)
local size9 = ahud.GetSize(9)
local size20 = ahud.GetSize(20)
local size32 = ahud.GetSize(32)
local size34 = ahud.GetSize(34)
local size64 = ahud.GetSize(64)

// Refresh cache size/positions
hook.Add("ahudPostScreenSizeChanged", "ahudRefreshCarHud", function()
    r = ahud.GetSize(65)
    iconSize = ahud.GetSize(30) / 2
    iconSize16 = ahud.GetSize(16) / 2

    size8 = ahud.GetSize(8)
    size9 = ahud.GetSize(9)
    size20 = ahud.GetSize(20)
    size32 = ahud.GetSize(32)
    size34 = ahud.GetSize(34)
    size64 = ahud.GetSize(64)
end)

hook.Add("ahud_drawCar", "CarHUD", function(local_ply, w, h, veh)
    draw.NoTexture()
    h = h * 0.935 + size32

    // I call it to apply default stencil params
    ahud.StartStencil()
    ahud.EndStencil()

    // Draw list of vehicle infos
    for k, v in ipairs(l) do
        local w = w * 0.5 + ahud.GetSize(v.w)
        local frac, icon = v.f(veh)

        if frac == nil then continue end

        local h_frac = size64 * frac

        surface.SetFont("ahud_Icon30")
        ahud.drawText("d", w - iconSize, h - iconSize, black_40)

        render.ClearStencil()
        render.SetStencilEnable(true)
            surface.SetDrawColor(0, 0, 0, 1)
            surface.DrawRect(w - size32, h - h_frac + size34, size64, h_frac)
        render.SetStencilCompareFunction( STENCIL_EQUAL )
            ahud.drawText("d", w - iconSize, h - iconSize, ahud.Colors.C125_60)
        render.SetStencilEnable( false )

        surface.SetFont("ahud_Icon16")
        ahud.drawText(icon or v.i, w - iconSize16, h - iconSize16, ahud.Colors.C230)
    end

    local speed = getVehSpeed(veh)
    ahud.EndStencil()

    if !speed then return end
    draw.SimpleText("h", "ahud_Icon128", w * 0.5, h * 0.92 + size8, black_40, 1, 1)
    surface.SetDrawColor(color_white)

    local circle = {
        [1] = {
            x = w * 0.5,
            y = h * 0.92 + size20,
        }
    }

    local ratio_speed = speed / 150

    ratio_speed = ratio_speed > 1 and 1 or ratio_speed

    // 2 per 2, don't change a lot on visuals and faster
    for i = ang_start, (410 - ang_start) * ratio_speed + ang_start, 2 do
        table.insert(circle, {
            x = w * 0.5 + math.cos(math.rad(i * 360) / 360) * r,
            y = h * 0.92 + size20 + math.sin(math.rad(i * 360) / 360) * r
        })
    end

    surface.SetDrawColor(1, 1, 1, 1)
    draw.NoTexture()

    local clr1 = ahud.Colors.HUD_Warning
    local clr2 = ahud.Colors.HUD_Bad
    local clr3 = ahud.ColorTo(clr1, clr2, ratio_speed) // Color of speedometer, between yellow and red

    ahud.StartStencil()
        surface.DrawPoly(circle)
    render.SetStencilCompareFunction( STENCIL_EQUAL )
        draw.SimpleText("h", "ahud_Icon128", w * 0.5, h * 0.92 + size8, clr3, 1, 1)
    ahud.EndStencil()

    draw.SimpleText(math.Round(speed), "ahud_40", w * 0.5, h * 0.92 + size8, color_white, 1, 1)

    surface.SetFont("ahud_17")
    ahud.drawText("KmH", w * 0.5 - size9 * 1.5, h * 0.955 - size9, ahud.Colors.C200_120)
end)