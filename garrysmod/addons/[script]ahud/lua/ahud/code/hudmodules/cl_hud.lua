// Cache functions
local CurTime = CurTime
local draw = draw
local surface = surface
local math = math
local Lerp = Lerp
local LocalPlayer = LocalPlayer
//

// I'm sorry for these detection ways, but there no hook/variables to know if TTT or murder is loaded
local function loadTTT()
    if GAMEMODE then
        timer.Simple(2, function()
            if GAMEMODE.TTTPlayerColor then
                ahud.ttt = ahud.ttt or {
                    L = LANG.GetUnsafeLanguageTable(),
                    roundstate_string = {
                        [ROUND_WAIT]   = "round_wait",
                        [ROUND_PREP]   = "round_prep",
                        [ROUND_ACTIVE] = "round_active",
                        [ROUND_POST]   = "round_post"
                    },
                    spectatorDeathmatch = isbool(SpecDM)
                }
            elseif GAMEMODE.RoundSettings and GAMEMODE.RoundSettings.AdminPanelAllowed then
                ahud.murder = true
            elseif PHE then
                ahud.phe = true

                // Sad way to get it, but there no other way
                local func = hook.GetTable().HUDPaint["PHE.MainHUD"]

                if func then
                    local avatar = debug.getupvalue(func, 3)

                    if IsValid(avatar) then
                        avatar:Remove()
                    end
                end

                hook.Remove("HUDPaint", "PHE.MainHUD")
                hook.Remove("HUDPaint", "PH_AutoTauntPaint")
                function GAMEMODE:UpdateHUD_Alive() return end
            end
        end)
    end
end

loadTTT()
hook.Add("PostGamemodeLoaded", "ahud_CheckTTT", loadTTT)

//
local function getAmmo(local_ply)
    local wep = local_ply:GetActiveWeapon()
    local bulletCount = -1
    local bulletClip = -1
    
    if IsValid(wep) then
        bulletCount = local_ply:GetAmmoCount(wep:GetPrimaryAmmoType())
        bulletClip = wep:Clip1()
    end

    return bulletCount, bulletClip
end

local tbl = {
    {
        char = "3",
        value = function(p) return math.max(p:Health(), 0) end,
        value_from = 0,
        value_to = 0,
        lastchange = 0,
    },

    {
        char = "+",
        value = function(p) return p:Armor() end,
        check_enable = function(p) return p:Armor() > 0 end,
        value_from = 0,
        value_to = 0,
        lastchange = 0,
    },

    {
        char = "-",
        value = function(p)
            return p:getDarkRPVar("rpname") or "John Doe"
        end,
        check_enable = function() return DarkRP end,
    },

    {
        char = "`",
        value = function(p)
            if ahud.ttt then
                return ahud.ttt.L[ GAMEMODE.round_state == ROUND_ACTIVE and p:GetRoleStringRaw() or ahud.ttt.roundstate_string[GAMEMODE.round_state] ]
            else
                return team.GetName(p:Team())
            end
        end,
        check_enable = function() return ahud.ttt or DarkRP end,
    },

    {
        char = ",",
        value = function(p) return DarkRP.formatMoney(p:getDarkRPVar("money")) end,
        check_enable = function() return DarkRP end,
        value_from = 0,
        value_to = 0,
        lastchange = 0,
    },

    {
        char = ahud.dollarIcon and "K" or "F",
        value = function(p) return p:getDarkRPVar("salary") end,
        check_enable = function(p)
            return DarkRP and p:getDarkRPVar("salary") and p:getDarkRPVar("salary") > 0
        end,
        value_from = 0,
        value_to = 0,
        lastchange = 0,
    },
--[[
    {
        char = "J",
        value = function(p)
            local a, c = getAmmo(p)
            return c .. "/" .. a
        end,
        check_enable = function(p)
            local maxBullet, ammo = getAmmo(p)
            return maxBullet > 0 or ammo > 0
        end,
        value_from = 0,
        value_to = 0,
        lastchange = 0,
    },
--]]
    {
        char = "y",
        check_enable = function(p)
            return (DarkRP and p:getDarkRPVar("HasGunlicense")) or (ahud.murder and p:HasWeapon("weapon_mu_magnum"))
        end,

        value = function()
            return "" 
        end
    },

    {
        char = "`",

        check_enable = function() return ahud.phe end,
        value = function()
            local tim = team.GetPlayers(TEAM_PROPS)
            local liveply = liveply or 0

            for _, pl in pairs(tim) do
                if IsValid(pl) and pl:Alive() then
                    liveply = liveply + 1
                end
            end

            return liveply
        end
    },

    {
        char = "V",

        check_enable = function(p)
            return (ahud.murder and p:HasWeapon("weapon_mu_knife")) or ahud.phe
        end,

        value = function(p)
            if ahud.murder and p:HasWeapon("weapon_mu_knife") then
                return ""
            else
                local tim = team.GetPlayers(TEAM_HUNTERS)
                local liveply = liveply or 0

                for _, pl in pairs(tim) do
                    if IsValid(pl) and pl:Alive() then
                        liveply = liveply + 1
                    end
                end

                return liveply
            end
        end
    },

    /// Specific to gamemode there, show them BEFORE "only logos"
    /// TTT

    {
        char = "|",
        value = function(p) return p:GetBaseKarma() end,
        check_enable = function() return ahud.ttt end,
        value_from = 0,
        value_to = 0,
        lastchange = 0,
    },

    {
        char = "n",
        value = function(p)
            local lastTauntTime = p:GetNWFloat("LastTauntTime")
            local nextTauntTime = lastTauntTime + (GetConVar("ph_autotaunt_delay"):GetInt() or 45)

            return string.FormattedTime(math.max(0, math.ceil(nextTauntTime - CurTime())), "%02i:%02i")
        end,
        check_enable = function(p) return ahud.phe and p:Team() == TEAM_PROPS and GetConVar("ph_autotaunt_enabled"):GetBool() and p:IsPlaying() end,
    },

    {
        char = "j",
        value = function()
            if ahud.ttt then
                local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()

                if hastetime < 0 then
                    haste_time = (is_traitor and math.ceil(CurTime()) % 6 < 2) and endtime or t
                else
                    haste_time = GetGlobalFloat("ttt_round_end", 0) - CurTime()
                end

                return util.SimpleTime(math.max(0, haste_time), "%02i:%02i")
            elseif ahud.murder then
                local t = GAMEMODE.RoundStart

                if t then
                    return string.FormattedTime(math.max(0, CurTime() - t), "%02i:%02i")
                end
            elseif ahud.phe then
                local timeLeft = math.max(0, GetGlobalFloat("RoundEndTime", 0) - CurTime())
                local str = string.FormattedTime(timeLeft, "%02i:%02i")

                if GAMEMODE.RoundBased then
                    str = str .. ", " .. GetGlobalInt("RoundNumber", 0) .. " " .. string.lower(PHE.LANG.HUD.ROUND)

                    if GetGlobalInt("RoundNumber", 0) > 1 then
                        str = str .. "s"
                    end
                end

                return str
            end
        end,
        check_enable = function() return ahud.ttt or (ahud.murder and GAMEMODE.RoundStart) or ahud.phe end,
    },
    
    // End of specific gamemode
    {
        char = "I",
        is_perc = true,
        value = function(p) return (p:getDarkRPVar("Energy") or 0) / 100 end,
        check_enable = function() return DarkRP and !DarkRP.disabledDefaults.modules.hungermod end,
    },

    {
        char = "u",
        check_enable = function() return GetGlobalBool("DarkRP_LockDown") end,
    },

    {
        char = "~",
        check_enable = function(p) return DarkRP and p:getDarkRPVar("wanted") end,
    },

    {
        char = ")",
        check_enable = function(p) return p:IsSpeaking() end,
    },

    {
        char = "}",
        check_enable = function(p) return ahud.phe and p:FlashlightIsOn() end,
    }
}

// Anim
local lerp_time = 0.5
local hold_time = 0.5
local ratio_mult = 1 / lerp_time

// Clrs
local bad_changeClr = ahud.Colors.HUD_Bad
local good_changeClr = ahud.Colors.HUD_Good
local idle_change = ahud.Colors.C160

// Res
local w = ScrW()
local h = ScrH()
local space = ahud.GetSize(10)
local wStart = ahud.GetSize(10)
local hBar = ahud.GetSize(40) // w
local hBarDiv2 = hBar / 2
local hStart = h - space - hBar
surface.SetFont("ahud_Icon22")
local logoSize = surface.GetTextSize("a")
local logoSizeDiv2 = math.ceil(logoSize / 2)
local logoMult = 0.8

// We always use the last calculated size, rather than recalculate every frame. The size can be 1 frame behind but the performance gain is really worth it
local oldSize = space

local function drawMiddleVertical(txt, font, w, h, color)
    surface.SetFont(font)
    surface.SetTextColor(color)

    local txtw, txth = surface.GetTextSize(txt)
    surface.SetTextPos(w, h - txth / 2)
    surface.DrawText(txt)

    return txtw
end

hook.Add("ahudPostScreenSizeChanged", "ahudRefreshHud", function()
    w = ScrW()
    h = ScrH()

    local ratio_h = h / 1080
    local ratio_w = w / 1920
    local new_ratio = ratio_h < ratio_w and ratio_h or ratio_w
    
    oldSize = 0
    space = ahud.GetSize(10)
    wStart = ahud.GetSize(10)
    hBar = ahud.GetSize(40)
    hBarDiv2 = hBar / 2
    hStart = h - space - hBar

    logoSize = 22 * new_ratio
    logoSizeDiv2 = math.ceil(logoSize / 2)
end)

// Background part
local function getBackground(local_ply)
    if ahud.ttt then
        if GAMEMODE.round_state != ROUND_ACTIVE then
            return ahud.Colors.HUD_NoGame, ahud.Colors.HUD_NoGameBar
        elseif local_ply:IsTraitor() then
            return ahud.Colors.HUD_Traitor, ahud.Colors.HUD_TraitorBar
        elseif local_ply:IsDetective() then
            return ahud.Colors.HUD_Background, ahud.Colors.HUD_Bar
        else
            return ahud.Colors.HUD_Innocent, ahud.Colors.HUD_InnocentBar
        end
    elseif ahud.murder then
        if GAMEMODE:GetAmMurderer() then
            return ahud.Colors.HUD_Traitor, ahud.Colors.HUD_TraitorBar
        else
            return ahud.Colors.HUD_Background, ahud.Colors.HUD_Bar
        end
    elseif ahud.phe then
        if !GetGlobalBool("InRound") then
            return ahud.Colors.HUD_NoGame, ahud.Colors.HUD_NoGameBar
        elseif local_ply:Team() == TEAM_HUNTERS then
            return ahud.Colors.HUD_Traitor, ahud.Colors.HUD_TraitorBar
        end
    elseif ahud.ColorTeam then
        return ahud.ColorTeam[1], ahud.ColorTeam[2]
    end

    return ahud.Colors.HUD_Background, ahud.Colors.HUD_Bar
end

net.Receive("ahud_changedteam", function()
    local t = net.ReadUInt(16)
    ahud.ColorTeam = ahud.ColorsTeam and ahud.ColorsTeam[team.GetName(t)] or nil
end)

// Draw HUD
local function localPlayerInfos(local_ply)
    local size = space + w * 0.007 // Default Size

    local clr1, clr2 = getBackground(local_ply)
    surface.SetDrawColor(clr1)
    surface.DrawRect(wStart, hStart, oldSize, hBar)

    surface.SetDrawColor(clr2)
    surface.DrawRect(wStart, hStart, w * 0.0027, hBar)

    for k,v in ipairs(tbl) do
        if v.check_enable and !v.check_enable(local_ply) then continue end
        local value = v.value and v.value(local_ply)

        surface.SetFont("ahud_Icon22")

        // Percent value ?
        if v.is_perc then
            surface.SetDrawColor(ahud.Colors.C125_60)

            local reduce = 1 - value

            ahud.drawText(v.char, size + hBarDiv2 - logoSizeDiv2, hStart + hBarDiv2 - logoSizeDiv2, ahud.Colors.C125_60)

            ahud.StartStencil()
                surface.SetDrawColor(100, 100, 100, 1)
                surface.DrawRect(size + logoSizeDiv2, hStart + hBarDiv2 - logoSizeDiv2 + logoSize * reduce, logoSize, logoSize)
            ahud.ReplaceStencil(1)
                ahud.drawText(v.char, size + hBarDiv2 - logoSizeDiv2, hStart + hBarDiv2 - logoSizeDiv2, color_white)
            ahud.EndStencil()

            size = size + logoSize + space * 2
        else
            // Make color flick if there no value
            local clr = !value and ahud.ColorTo(color_white, ahud.Colors.C125_60, math.abs(math.sin(CurTime()))) or color_white

            drawMiddleVertical(v.char, "ahud_Icon22", size + (hBar * logoMult) / 2 - logoSizeDiv2, hStart + hBarDiv2, clr)
            size = size + logoSize + space

            clr = ahud.Colors.C200_120

            if isnumber(value) and v.value_to then
                if v.value_to != value then
                    if ahud.disableHUDAnimations then
                        v.value_from = value
                        v.value_to = value
                    else
                        v.lastchange = CurTime() + 1
                        v.value_from = v.value_to
                        v.value_to = value
                    end
                end

                local clamp = v.value_to and math.Clamp((CurTime() - v.lastchange) * lerp_time, 0, 1) or 1

                if clamp != 1 then
                    local rat = (clamp - hold_time) * ratio_mult
                    local avoidColorTransition = clamp < hold_time
                    local add = v.value_from < value

                    clr = add and good_changeClr or bad_changeClr

                    if !avoidColorTransition then
                        clr = ahud.ColorTo(clr, idle_change, rat)
                    end

                    value = math.Round(Lerp(clamp, v.value_from, v.value_to))
                end
            elseif !value or value == "" then
                size = size + space / 4
                continue
            end

            size = size + space + drawMiddleVertical(value, "ahud_17", size, hStart + hBarDiv2, clr)
        end
    end

    oldSize = size
end

// Agenda
local function drawArrest(local_ply)
    if !local_ply:getDarkRPVar("Arrested") then return end

    local time = local_ply.ahud_unarrestAt

    local _, txtH = draw.SimpleText(ahud.L("Arrested"), "ahud_25", w / 2, h / 4, ahud.Colors.C200_120, 1, 1)
    draw.SimpleText(ahud.L("ReleaseIn", math.ceil(time - CurTime())), "ahud_40", w / 2, h / 4 + txtH, ahud.Colors.C230, 1, 1)
    draw.SimpleText("!", "ahud_Icon40", w / 2, h / 4 - txtH, ahud.Colors.C200_120, 1, 4)
end

hook.Add("HUDPaint", "ahud", function()
    local local_ply = LocalPlayer()

    if ahud.ttt and ahud.ttt.spectatorDeathmatch and local_ply:IsGhost() then return end

    // Core
    localPlayerInfos(local_ply)

    local veh = local_ply:GetVehicle()
    local inCar = IsValid(veh) and veh:GetDriver() == local_ply and veh:GetModel() != "models/nova/airboat_seat.mdl"
    ahud.inCar = inCar

    hook.Run("ahud_draw", local_ply, w, h, local_ply:GetEyeTrace().Entity, getBackground(local_ply))

    if inCar then
        hook.Run("ahud_drawCar", local_ply, w, h, veh)
    elseif DarkRP then
        drawArrest(local_ply)
    end
end)