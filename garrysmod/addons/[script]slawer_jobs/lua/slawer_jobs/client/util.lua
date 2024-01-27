local iLastH = 0

local THEME = Slawer.Jobs.CFG["Theme"]

surface.CreateFont("Slawer.Jobs:95", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550,  size = 95 })

function Slawer.Jobs:GenerateFonts()
    if iLastH == ScrH() then return end

    iLastH = ScrH()

    surface.CreateFont("Slawer.Jobs:R25", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550,  size = iLastH * 0.022 }) -- npc frame
    surface.CreateFont("Slawer.Jobs:R15", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.012 }) -- adm panel
    surface.CreateFont("Slawer.Jobs:R20", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.011 }) -- adm panel
    surface.CreateFont("Slawer.Jobs:R22", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.019 }) -- desc
    surface.CreateFont("Slawer.Jobs:SB22", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.015 }) -- job frame
    surface.CreateFont("Slawer.Jobs:SB30", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.01 })
    surface.CreateFont("Slawer.Jobs:B30", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.01 })
    surface.CreateFont("Slawer.Jobs:SB35", { font = "Roboto", extended  = true, antialias = true, italic = false, weight = 550, size = iLastH * 0.021 }) -- job desc name
end