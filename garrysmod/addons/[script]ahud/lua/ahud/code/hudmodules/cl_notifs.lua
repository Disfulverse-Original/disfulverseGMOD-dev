// Cache functions
local CurTime = CurTime
local draw = draw
local surface = surface
local math = math
local LocalPlayer = LocalPlayer
//

// Notifications Code
local notif_pnl = {}

local clrtbl = {
    [0] = ahud.Colors.HUD_Warning,
    [1] = ahud.Colors.HUD_Bad,
    [2] = ahud.Colors.HUD_Tip,
    [3] = ahud.Colors.HUD_Bar,
    [4] = ahud.Colors.HUD_Good,
}

local function AddNotify(txt, type, length, isVote, param)
    surface.SetFont("ahud_25")

    local size_x, size_y = surface.GetTextSize(txt)
    local optionH = select(2, surface.GetTextSize("a"))

    local pnl = vgui.Create("DPanel")
    pnl:SetSize(size_x + ahud.GetSize(33), isVote != nil and size_y + optionH * 2 or size_y + ahud.GetSize(20))

    local height = ahud.GetSize(50)

    for _, v in pairs(notif_pnl) do
        if IsValid(v) then
            height = v:GetTall() + ahud.GetSize(20) + height
        end
    end

    pnl:SetPos(ScrW() - pnl:GetWide() - ahud.GetSize(50), (ahud.InvertNotifications and (ScrH() - height - pnl:GetTall()) or height))
    pnl:SetPaintBackground(false)

    local pnl_follower = vgui.Create("DPanel", pnl)
    pnl_follower:SetPos(pnl:GetWide(), 0)
    pnl_follower:SetSize(pnl:GetSize())
    pnl_follower:MoveTo(0, 0, 0.3, 0, 0.5)

    function pnl_follower:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, ahud.Colors.HUD_Background)
        draw.DrawText(txt, "ahud_25", w - ahud.GetSize(18), ahud.GetSize(10), ahud.Colors.C230, 2)
    end

    local pnl_line = vgui.Create("DPanel", pnl)
    pnl_line:Dock(RIGHT)
    pnl_line:SetWide(ahud.GetSize(15))

    local OldTime = CurTime()
    function pnl_line:Paint(w,h)
        if isVote != nil then
            surface.SetDrawColor(ahud.Colors.HUD_Bar)
            surface.DrawRect(w - ahud.GetSize(5), 0, ahud.GetSize(5), h)

            local rat = 1 / length * (CurTime() - OldTime)
            surface.SetDrawColor(ahud.Colors.HUD_Tip)
            surface.DrawRect(w - ahud.GetSize(5), h * rat, ahud.GetSize(5), h)

            math.ceil(length - (CurTime() - OldTime))
        else
            surface.SetDrawColor(clrtbl[type])
            surface.DrawRect(w - ahud.GetSize(5), 0, ahud.GetSize(5), h)
        end
    end

    function pnl_line:OnRemove()
        local height = ahud.GetSize(50)

        for k, v in pairs(notif_pnl) do
            if v == self or !IsValid(v) then
                notif_pnl[k] = nil
                k = k - 1
            else
                v:MoveTo(select(1, v:GetPos()), (ahud.InvertNotifications and (ScrH() - height - v:GetTall()) or height), 0.2, 0, 0.3)
                height = v:GetTall() + ahud.GetSize(20) + height
            end
        end
    end

    timer.Simple(length or 5, function()
        if IsValid(pnl) then
            pnl:Remove()
        end
    end)

    table.insert(notif_pnl, pnl)

    if isVote != nil then
        local pnl_optionContainer = vgui.Create("EditablePanel", pnl_follower)
        pnl_optionContainer:Dock(BOTTOM)
        pnl_optionContainer:SetTall(optionH)
        pnl_optionContainer:DockMargin(0, 0, ahud.GetSize(18), optionH * 0.25)

        local pnl_accept = vgui.Create("DButton", pnl_optionContainer)
        pnl_accept:Dock(RIGHT)
        pnl_accept:SetFont("ahud_17")
        pnl_accept:SetText(DarkRP.getPhrase("yes"))
        pnl_accept:SetPaintBackground(false)
        pnl_accept:SetTextColor(ahud.Colors.C200_120)
        pnl_accept:SetWide(pnl:GetWide() / 2)
        pnl_accept:ahud_AlphaHover(100)

        function pnl_accept:DoClick()
            if isVote then
                LocalPlayer():ConCommand("vote " .. param .. " yea\n")
            else
                LocalPlayer():ConCommand("ans " .. param .. " 1\n")
            end

            pnl:Remove()
        end

        local pnl_refuse = vgui.Create("DButton", pnl_optionContainer)
        pnl_refuse:Dock(RIGHT)
        pnl_refuse:SetFont("ahud_17")
        pnl_refuse:SetText(DarkRP.getPhrase("no"))
        pnl_refuse:SetPaintBackground(false)
        pnl_refuse:SetTextColor(ahud.Colors.C200_120)
        pnl_refuse:SetWide(pnl:GetWide() / 2)
        pnl_refuse:DockMargin(0, 0, 0, 0)
        pnl_refuse:ahud_AlphaHover(100)

        function pnl_refuse:DoClick()
            if isVote then
                LocalPlayer():ConCommand("vote " .. param .. " nay\n")
            else
                LocalPlayer():ConCommand("ans " .. param .. " 2\n")
            end

            pnl:Remove()
        end
    end
end

// Detour
function notification.AddLegacy(txt, type, length)
    AddNotify(txt, type, length)
end

hook.Add("OnReloaded", "ahud_refreshNotif", function()
    timer.Simple(0.5, function()    
        function notification.AddLegacy(txt, type, length)
            AddNotify(txt, type, length)
        end
    end)
end)

usermessage.Hook("_Notify", function(msg)
    // Wtf
    if GAMEMODE.Config.notificationSound then
        surface.PlaySound(GAMEMODE.Config.notificationSound)
    end

    AddNotify(msg:ReadString(), msg:ReadShort(), msg:ReadLong())
end )

// Don't enable this parameter, it's made for undefined cases
if ahud.debugnotifs then
    timer.Create("ahud_refreshnotif", 2, 0, function()
        function notification.AddLegacy(txt, type, length)
            AddNotify(txt, type, length)
        end
    end)
end

hook.Add("HUDWeaponPickedUp", "ahud_wepPickup", function(wep)
    notification.AddLegacy(ahud.L("wepPickup", wep.PrintName or wep:GetClass()), 4, 3)
    return false
end)

hook.Add( "HUDAmmoPickedUp", "ahud_ammoPickup", function( itemName, amount )
    notification.AddLegacy(ahud.L("ammoPickup", amount, itemName), 4, 3)
    return false
end )

// Hijack voting
local function createVoteUI(isVote, question, param, timeleft)
    if !IsValid(LocalPlayer()) then return end

    LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
    local txt = DarkRP.textWrap(string.Replace(DarkRP.deLocalise(question), "\n", " "), "ahud_25", ScrW() * 0.33)
    AddNotify(txt, 1, timeleft == 0 and 100 or timeleft, isVote, param)
end

local function detour()
    timer.Simple(0, function()
        usermessage.Hook("DoVote", function(msg)
            createVoteUI(true, msg:ReadString(), msg:ReadShort(), msg:ReadFloat())
        end)

        usermessage.Hook("DoQuestion", function(msg)
            createVoteUI(false, msg:ReadString(), msg:ReadString(), msg:ReadFloat())
        end)

        usermessage.Hook("_Notify", function(msg)
            // Wtf
            if GAMEMODE.Config.notificationSound then
                surface.PlaySound(GAMEMODE.Config.notificationSound)
            end
            AddNotify(msg:ReadString(), msg:ReadShort(), msg:ReadLong())
        end )
    end)
end

detour()
hook.Add("PostGamemodeLoaded", "ahud_detourVote", detour)