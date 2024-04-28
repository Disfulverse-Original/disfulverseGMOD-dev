function YAWS.UI.Tabs.Warnings(master)
    master:Clear()
    master.PerformLayout = function() end 
    
    -- YAWS.UI.CurrentData.self_warns
    local playerPanel = vgui.Create("yaws.panel", master)
    local picture = vgui.Create("yaws.round_avatar", playerPanel)
    picture:SetPlayer(LocalPlayer(), 256)

    playerPanel.PerformLayout = function(self, w, h)
        self:LayoutShadows(w, h)
        
        picture:Dock(LEFT)
        picture:DockMargin(10, 10, 10, 10)
        picture:SetWide(picture:GetTall())
    end 

    -- Warning Points
    surface.SetFont("yaws.7")
    local pointsTextSize = surface.GetTextSize(YAWS.UI.CurrentData.self_warn_point_count)
    local expiredPointsTextSize = surface.GetTextSize(YAWS.UI.CurrentData.self_warn_expired_point_count)

    playerPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

        draw.SimpleText(LocalPlayer():Name(), "yaws.10", h + (5), h * 0.375, colors['text_header'], 0, 1)
        draw.SimpleText(LocalPlayer():SteamID(), "yaws.7", h + (5), h * 0.625, colors['text_main'], 0, 1)

        -- points 
        draw.NoTexture()
        surface.SetMaterial(YAWS.UI.MaterialCache['warning'])
        YAWS.UI.SetSurfaceDrawColor(colors['active_warning'])
        surface.DrawTexturedRect(w - 14 - (h * 0.235) - pointsTextSize, h - (h * 0.235) - 10, h * 0.235, h * 0.235)

        draw.SimpleText(YAWS.UI.CurrentData.self_warn_point_count, "yaws.7", w - 10, h * 0.775, colors['text_main'], 2, 1)

        -- expired points 
        if(YAWS.Config.GetValue("point_cooldown_time") != 0) then
            draw.NoTexture()
            surface.SetMaterial(YAWS.UI.MaterialCache['warning'])
            YAWS.UI.SetSurfaceDrawColor(colors['expired_warning'])
            surface.DrawTexturedRect(w - 24 - ((h * 0.235) * 2) - pointsTextSize - expiredPointsTextSize - 5, h - (h * 0.235) - 10, h * 0.235, h * 0.235)
            
            draw.SimpleText(YAWS.UI.CurrentData.self_warn_expired_point_count, "yaws.7", w - 22 - (h * 0.235) - pointsTextSize - 5, h * 0.775, colors['text_main'], 2, 1)
        end
    end 


    local warnTable = vgui.Create("yaws.table", master)
    warnTable:Dock(FILL)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_admin"), 0.125)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_reason"), 0.425)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_time"), 0.15)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_points"), 0.15)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_server"), 0.15)

    if(table.Count(YAWS.UI.CurrentData.self_warns) <= 0) then -- they're numberically indexed but not guarenteed to start at 0
        warnTable:RemoveDividersInBody()
        warnTable:SetCenterMessage("viewing_player_no_warns_found")
    else 
        local defaultPlayerData = {
            steamid = LocalPlayer():SteamID64(),
            realSteamID = LocalPlayer():SteamID(),
            name = LocalPlayer():Name(),
            usergroup = LocalPlayer():GetUserGroup()
        }
        for k,v in SortedPairsByMemberValue(YAWS.UI.CurrentData.self_warns, "timestamp", true) do
            warnTable:AddEntry(function()
                YAWS.UI.StateCache["viewing_self"] = {
                    -- data = data
                }
                YAWS.UI.StateCache["warn_data_return"] = "viewing_self"
    
                YAWS.UI.DisplayWarnData(defaultPlayerData, v)
            end, {
                {
                    name = YAWS.Language.GetTranslation("viewing_player_table_right_admin"),
                    func = function() 
                        SetClipboardText(v.admin .. "(" .. util.SteamIDFrom64(v.adminSteamID or "") ")") 
                    end,
                    icon = "icon16/group_key.png"
                },
                {
                    name = YAWS.Language.GetTranslation("viewing_player_table_right_reason"),
                    func = function() 
                        SetClipboardText(v.reason)
                    end,
                    icon = "icon16/page_edit.png"
                },
                { 
                    name = YAWS.Language.GetTranslation("viewing_player_table_right_time"),
                    func = function() 
                        SetClipboardText(os.date("%H:%M:%S on %d/%m/%Y", v.time))
                    end,
                    icon = "icon16/clock.png"
                },
                {
                    name = YAWS.Language.GetTranslation("viewing_player_table_right_points"),
                    func = function() 
                        SetClipboardText(v.points .. " points")
                    end,
                    icon = "icon16/award_star_gold_3.png"
                },
                {
                    name = YAWS.Language.GetTranslation("viewing_player_table_right_server"),
                    func = function() 
                        SetClipboardText(v.server_id)
                    end,
                    icon = "icon16/computer.png"
                },
                {
                    name = YAWS.Language.GetTranslation("viewing_player_table_right_log"),
                    func = function() 
                        SetClipboardText(string.format("[%s] %s(%s) warned %s(%s) for the reason \"%s\", adding %s points.", os.date("%H:%M:%S on %d/%m/%Y", v.time), v.admin, util.SteamIDFrom64(v.adminSteamID or ""), LocalPlayer():Name(), LocalPlayer():SteamID(), v.reason, v.points))
                    end,
                    icon = "icon16/folder.png"
                },
            }, v.admin, v.reason, string.NiceTime(os.time() - v.timestamp) .. " ago", v.points, v.server_id)
        end
    end

    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        playerPanel:Dock(TOP)
        playerPanel:SetHeight(h * 0.15)
        playerPanel:DockMargin(10, 10, 10, 10)

        warnTable:Dock(FILL)
        warnTable:DockMargin(10, 0, 10, 10)
        if(table.Count(YAWS.UI.CurrentData.self_warns) > 0) then
            warnTable:FindBestSize()
        end
    end
    master:InvalidateLayout()
end