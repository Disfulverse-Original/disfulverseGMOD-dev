local iLastH = 0

local THEME = Slawer.Jobs.CFG["Theme"]

surface.CreateFont("Slawer.Jobs:95", { font = "Cambria", size = 95 })

function Slawer.Jobs:GenerateFonts()
    if iLastH == ScrH() then return end

    iLastH = ScrH()

    surface.CreateFont("Slawer.Jobs:R25", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550,  size = iLastH * 0.024 })
    surface.CreateFont("Slawer.Jobs:R15", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.014 })
    surface.CreateFont("Slawer.Jobs:R20", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.013 })
    surface.CreateFont("Slawer.Jobs:R22", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.021 })
    surface.CreateFont("Slawer.Jobs:SB22", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.021 })
    surface.CreateFont("Slawer.Jobs:SB30", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.02 })
    surface.CreateFont("Slawer.Jobs:B30", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.02 })
    surface.CreateFont("Slawer.Jobs:SB35", { font = "Cambria", extended  = true, antialias = true, italic = true, weight = 550, size = iLastH * 0.022 })
end