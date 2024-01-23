Sublime.Player = FindMetaTable("Player");

function Sublime.GetCurrentPath()
    return debug.getinfo(2).short_src;
end

function Sublime.GetCurrentGamemode()
    return engine.ActiveGamemode()
end

Sublime.Colors = {};

local col               = Color;
Sublime.Colors.White    = col(255, 255, 255);
Sublime.Colors.Trans    = col(0, 0, 0, 100); --
Sublime.Colors.Black    = col(0, 0, 0); --
Sublime.Colors.Red      = col(200, 0, 0);
Sublime.Colors.Royal    = col(0, 150, 200);
Sublime.Colors.Green    = col(72, 219, 140, 200);
Sublime.Colors.Cyan     = col(0, 255, 191);
Sublime.Colors.Outline  = col(255, 255, 255, 200);
Sublime.Colors.Grey     = col(200, 200, 200, 200);
Sublime.Colors.Invis    = col(0, 0, 0, 0);
Sublime.Colors.Yellow   = col(200, 200, 0);
Sublime.Colors.Purple   = col(114, 0, 255);
Sublime.Colors.Orange   = col(255, 144, 0);
Sublime.Colors.Pink     = col(255, 102, 255);
Sublime.Colors.YellowIsh= col(255, 174, 144);
Sublime.Colors.BlueIsh  = col(144, 174, 255);
Sublime.Colors.Disful1  = col(181, 203, 255);
Sublime.Colors.Disful2  = col(146, 153, 252);
Sublime.Colors.Disful3  = col(171, 138, 255);
Sublime.Colors.Disful4  = col(226, 122, 255);

function Sublime.Print(s, ...)
    if (SERVER) then
        if (not Sublime.Settings.Get("other", "debug_enabled", "boolean")) then
            return false;
        end

        MsgC(Sublime.Colors.Red, "[DisFul");
        MsgC(Sublime.Colors.Red, "Levels");
        MsgC(Sublime.Colors.Red, "] ");
        MsgC(Sublime.Colors.White, string.format(s, ...));
        Msg("\n");
    else
        if (not Sublime.Settings.Get("other", "debug_enabled", "boolean")) then
            return false;
        end

        MsgC(Sublime.Colors.Red, "[");
        MsgC(Sublime.Colors.Black, "DisFul");
        MsgC(Sublime.Colors.Red, "Levels");
        MsgC(Sublime.Colors.Red, "] ");
        MsgC(Sublime.Colors.White, string.format(s, ...));
        Msg("\n");
    end
end