local draw = draw
local surface = surface

local txt
hook.Add("ahud_draw", "ahud_drawAgenda", function(local_ply, w, h, _, c1, c2)
    if !DarkRP then return end
    local agenda = local_ply:getAgendaTable()

    if !agenda or !local_ply:getDarkRPVar("agenda") or local_ply:getDarkRPVar("agenda") == "" then return end

    local size = 10 + w * 0.007
    local t = string.Trim(local_ply:getDarkRPVar("agenda") or "", string.char(10))

    txt = txt or DarkRP.textWrap(t:gsub("//", "\n"):gsub("\\n", "\n"), "ahud_25", w * 0.2)

    surface.SetFont("ahud_25")
    local txtw, txth = surface.GetTextSize(DarkRP.deLocalise(txt))

    surface.SetFont("ahud_17_500")
    local txtw2, txth2 = surface.GetTextSize(agenda.Title)
    txth = txth + txth2 + ahud.GetSize(30)

    if txtw2 > txtw then
        txtw = txtw2
    end

    local wStart = w * 0.005

    surface.SetDrawColor(c1)
    surface.DrawRect(wStart + 5, w * 0.005, txtw + ahud.GetSize(30) + size, txth)

    surface.SetDrawColor(c2)
    surface.DrawRect(wStart, w * 0.005, 5, txth)

    local _, txtH = draw.SimpleText(agenda.Title, "ahud_17_500", wStart + size, w * 0.005 + ahud.GetSize(15), ahud.Colors.C200_120)
    draw.DrawNonParsedText(txt, "ahud_25", wStart + size, w * 0.005 + txtH + txth2, ahud.Colors.C230, 0)
end)

hook.Add("DarkRPVarChanged", "agendaHUD", function(ply, var, _, new)
    if ply != LocalPlayer() then return end
    if var == "agenda" and new then
        new = string.Trim(new, string.char(10))
        txt = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "ahud_25", ScrW() * 0.2)
    else
        txt = nil
    end
end)