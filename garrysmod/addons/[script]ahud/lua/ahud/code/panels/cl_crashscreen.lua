// Cache functions
local CurTime = CurTime
local draw = draw
local surface = surface
local math = math
//

local crashScreen

local clr = {
    Color(29, 209, 161),
    Color(72, 219, 251),
    Color(255, 107, 107),
    Color(255, 159, 67),
    Color(254, 202, 87),
    Color(255, 159, 243),
    Color(95, 39, 205),
    Color(200, 214, 229),
}

// detour
local LconnectionIssue = ahud.L("ConnectionIssue")
local LconnectionIssue2 = ahud.L("ConnectionIssue2")
local Loops = ahud.L("Oops")

local function createDisconnect()
    local p = vgui.Create("DPanel")
    local h = ScrH()
    local w = ScrW()

    p:SetSize(w, h)
    p:SetAlpha(0)
    p:AlphaTo(255, 0.33, 0.5)
    p:MakePopup()

    crashScreen = p
    local barCopy = ahud.Colors.HUD_Background
    local barDodgeItCopy = ColorAlpha(ahud.Colors.HUD_Background, 200)
    local blackCopy = ColorAlpha(ahud.Colors.C40, 60)
    local c = 0

    function p:Paint()
        c = select(2, GetTimeoutInfo())
        ahud.Blur(self, 2)
        surface.SetDrawColor(barCopy)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(Loops, "ahud_Oops", w / 2, h / 3, color_white, 1, 1)

        local _, txth = draw.SimpleTextOutlined(LconnectionIssue, "ahud_60", w / 2, h / 2, color_white, 1, 1, 1, blackCopy)
        draw.SimpleTextOutlined(LconnectionIssue2, "ahud_60", w / 2, h / 2 + txth, color_white, 1, 1, 1, blackCopy)

        surface.SetDrawColor(ahud.Colors.HUD_Bar)
        surface.DrawRect(0, h * 0.99, w * (1 / 120 * c), h * 0.01)

        if c < 1 then
            self:Remove()
            gui.EnableScreenClicker(false)
        elseif c > 120 then
            RunConsoleCommand("retry")
        end
    end

    // Width after margin: ScrW()*0.3
    local gameP = vgui.Create("DPanel", p)
    gameP:Dock(TOP)
    gameP:DockMargin(w * 0.35, h * 0.05, w * 0.35, 0)
    gameP:SetTall(0)

    local butContainer = vgui.Create("DPanel", p)
    butContainer:Dock(BOTTOM)
    butContainer:DockMargin(w * 0.2, 0, w * 0.2, h * 0.05)
    butContainer:SetPaintBackground(false)

    local butSize = (w * 0.6) / 3

    local reconnect = vgui.Create("DButton", butContainer)
    reconnect:SetText(ahud.L("Reconnect"))
    reconnect:SetContentAlignment(6)
    reconnect:SetFont("ahud_40")
    reconnect:SetTextColor(color_white)
    reconnect:Dock(LEFT)
    reconnect:SetWide(butSize)
    reconnect:SetPaintBackground(false)

    butContainer:SetTall(select(2, reconnect:GetTextSize()))

    function reconnect:DoClick()
        RunConsoleCommand("retry")
    end

    local gameBut = vgui.Create("DButton", butContainer)
    gameBut:SetText("DodgeIt!")
    gameBut:SetContentAlignment(5)
    gameBut:SetFont("ahud_40")
    gameBut:SetTextColor(color_white)
    gameBut:Dock(LEFT)
    gameBut:SetWide(butSize)
    gameBut:SetPaintBackground(false)

    local gamePInit = false
    function gameBut:DoClick()
        gameP:SetTall(gameP:GetTall() == 0 and h * 0.4 or 0)

        if gamePInit then return end
        gamePInit = true

        local main_x = w * 0.3
        local main_y = h * 0.4
        local color_white180 = ahud.Colors.C160
        local round_time = c
        local svg_30 = "ahud_Icon30"
        local s = 30

        local balls = {}

        local end_game = vgui.Create("DPanel", gameP)
        end_game:Dock(FILL)
        end_game:SetVisible(false)
        end_game:SetAlpha(0)

        function gameP:Paint(w, h)
            surface.SetDrawColor(ahud.Colors.HUD_Bar)
            surface.DrawOutlinedRect(0, 0, w, h)

            surface.SetDrawColor(barDodgeItCopy)
            surface.DrawRect(0, 0, w, h)

            if !end_game:IsVisible() then
                draw.SimpleText(math.Round(c - round_time) .. "s", "ahud_60", w / 2, h / 5, color_white180, 1, 1)
            end
        end

        function end_game:Paint(w, h)
            draw.SimpleText(end_game.win_time .. "s", "ahud_60", w / 2, h / 5, color_white180, 1, 1)
        end

        local restart = vgui.Create("DLabel", end_game)
        restart:SetFont("ahud_60")
        restart:SetContentAlignment(5)
        restart:Dock(FILL)
        restart:SetText(ahud.L("Restart"))
        restart:SetTextColor(color_white180)
        restart:ahud_AlphaHover()
        restart:SetMouseInputEnabled(true)

        local spawningBalls = false
        local timerBalls = 1
        local lastCheck = 0

        function restart:DoClick()
            round_time = c
            spawningBalls = true
            timerBalls = 1

            end_game:AlphaTo(0, 0.25, 0, function()
                end_game:SetVisible(false)
            end)
        end

        function gameP:Think()
            if lastCheck < c and spawningBalls then
                local time = timerBalls - 0.03
                time = (time >= 0.20) and time or 0.20

                timerBalls = time

                lastCheck = c + time

                local dir = math.random(1, 4)
                local move_x, move_y
                local ball = vgui.Create("DPanel", gameP)

                ball:SetSize(s, s)

                if dir == 1 then
                    local val = math.random(0, main_y)
                    ball:SetPos(-s, val)
                    move_x, move_y = main_x + s, val
                elseif dir == 2 then
                    local val = math.random(0, main_y)
                    ball:SetPos(main_x + s, val)
                    move_x, move_y = -s, val
                elseif dir == 3 then
                    local val = math.random(0, main_x)
                    ball:SetPos(val, -s)
                    move_x = val
                    move_y = main_y + s
                elseif dir == 4 then
                    local val = math.random(0, main_x)
                    ball:SetPos(val, main_y + s)
                    move_x, move_y = val, -s
                end

                ball:MoveTo(move_x, move_y, 1, 0, 1, function()
                    ball:Remove()
                    table.RemoveByValue(balls, c)
                end)

                local random_clr = clr[ math.random( #clr ) ]

                function ball:Paint(w, h)
                    draw.SimpleText("d", svg_30, w / 2, h / 2, random_clr, 1, 1)

                    // He hover a ball ? then he lost
                    if self:IsHovered() and !end_game:IsVisible() then
                        end_game.win_time = math.Round(c - round_time)

                        end_game:SetVisible(true)
                        end_game:AlphaTo(255, 0.5, 0)
                        spawningBalls = false
                    end
                end

                table.insert(balls, c)
            end

            if !self:IsHovered() and !self:IsChildHovered() and !end_game:IsVisible() then
                end_game.win_time = math.Round(c - round_time)

                end_game:SetVisible(true)
                end_game:AlphaTo(255, 0.5, 0)

                spawningBalls = true
            end
        end
    end

    local disconnect = vgui.Create("DButton", butContainer)
    disconnect:Dock(RIGHT)
    disconnect:SetWide(butSize)
    disconnect:SetContentAlignment(4)
    disconnect:SetText(language.GetPhrase( "GameUI_Disconnect" ))
    disconnect:SetFont("ahud_40")
    disconnect:SetTextColor(color_white)
    disconnect:SetPaintBackground(false)

    function disconnect:DoClick()
        RunConsoleCommand("disconnect")
    end
end

// c + 30 < CurTime(). We want to wait 30sec before creating any crash screen because you always timeout on init
local c = CurTime()
local function enableCrashScreen()
    if !ahud.DisableModules.Crashscreen and select(2, GetTimeoutInfo()) > 5 and !IsValid(crashScreen) and c + 30 < CurTime() then
        createDisconnect()
    end
end

hook.Add("Think", "ahud_Crash", enableCrashScreen)

hook.Add("PostGamemodeLoaded", "ahud_Crash", function()
    hook.Add("Think", "ahud_Crash", enableCrashScreen)
end)