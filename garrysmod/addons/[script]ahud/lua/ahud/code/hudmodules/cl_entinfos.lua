local draw = draw
local surface = surface

local d = ahud.maxDistDraw or (200*200)
hook.Add("ahud_draw", "ahud_drawOwner", function(local_ply, w, h, e, c1, c2)
    if DarkRP and IsValid(e) and !ahud.hideEntInfo and e:GetPos():DistToSqr(local_ply:GetPos()) < d then
        local owner = e:CPPIGetOwner()
        if !IsValid(owner) then return end

        surface.SetFont("ahud_25")
        local name = owner:Nick()
        local line_w, line_h = surface.GetTextSize(name)
        line_w = line_w + 20
        line_h = line_h + 20

        surface.SetDrawColor(c1)
        surface.DrawRect(w - line_w, h / 2 - line_h / 2, line_w, line_h)

        surface.SetDrawColor(c2)
        surface.DrawRect(w - 5, h / 2-line_h / 2, 5, line_h)

        draw.SimpleText(name, "ahud_25", w - line_w + 7.5, h / 2, ahud.Colors.C230, 0, 1)
    end
end)