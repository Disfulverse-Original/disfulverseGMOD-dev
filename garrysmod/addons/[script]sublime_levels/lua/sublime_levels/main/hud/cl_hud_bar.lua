local path = Sublime.GetCurrentPath();
local experience = 0;
local localplayer;

local width     = ScrW();
local size      = 25;
--[[
hook.Add("HUDPaint", path, function()
    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer();

    if (not IsValid(localplayer)) then
        return;
    end

    local shouldDisplayHUD = Sublime.Settings.Get("hud", "display", "boolean");
    if (not shouldDisplayHUD) then
        return;
    end

    local bar_hud = Sublime.Settings.Get("hud", "hud_bar", "boolean");
    if (not bar_hud) then
        return;
    end

    local y = Sublime.Settings.Get("hud", "hud_y", "number");

    local have      = localplayer:SL_GetExperience();
    local needed    = localplayer:SL_GetNeededExperience();
    local level     = localplayer:SL_GetLevel();
    experience      = Lerp(0.1, experience, have);

    surface.SetDrawColor(0, 0, 0, 150);
    surface.DrawRect(0, y - size, width, size);

    surface.SetDrawColor(Sublime.Colors.Outline);
    surface.DrawRect(0, y - size, width, 1);
    surface.DrawRect(0, y, width, 1);
    
    local perc = experience / needed;
    surface.DrawRect(0, y - 24, width * perc, size - 1);

    Sublime:DrawTextOutlined(math.floor(perc * 100) .. "%", "Sublime.22", width / 2, y - 13, Sublime.Colors.White, Sublime.Colors.Black, TEXT_ALIGN_CENTER, true);
    Sublime:DrawTextOutlined(level - 1, "Sublime.22", 5, y - 13, Sublime.Colors.White, Sublime.Colors.Black, TEXT_ALIGN_LEFT, true);
    Sublime:DrawTextOutlined(level + 1, "Sublime.22", width - 5, y - 13, Sublime.Colors.White, Sublime.Colors.Black, TEXT_ALIGN_RIGHT, true);
end);
--]]
