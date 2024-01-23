local red = ahud.Colors.HUD_Bad
local hue, sat, val = ColorToHSV(red)
val = 0.45
local redstripes = HSVToColor(hue, sat, val)

net.Receive("ahud_events", function()
    local id = net.ReadUInt(3)

    local target = net.ReadEntity()
    local actor = net.ReadEntity()
    local reason = net.ReadString()

    local n = IsValid(target) and target:Nick() or ""
    local n2 = IsValid(actor) and actor:Nick() or ""

    local title = ""
    local desc = ""

    if id == 0 then
        desc = DarkRP.getPhrase("warrant_approved", n, reason, n2)
    elseif id == 1 then
        desc = DarkRP.getPhrase("wanted_by_police", n, reason, n2)
    elseif id == 2 then
        if IsValid(actor) then
            desc = DarkRP.getPhrase("wanted_revoked", n, n2)
        else
            desc = DarkRP.getPhrase("wanted_expired", n)
        end
    elseif id == 3 then
        desc = DarkRP.getPhrase("warrant_expired", n, n2)
    elseif id == 4 then
        desc = DarkRP.getPhrase("lockdown_started")
        ahud.Popup(desc, string.upper("Lockdown"), red, redstripes)
        return
    end

    ahud.Popup2(desc, title, 10)
end)

net.Receive("ahud_arrest", function()
    local time = net.ReadUInt(16)

    local lply = LocalPlayer()
    lply.ahud_unarrestAt = time + CurTime()
end)