function YAWS.UI.Tabs.Players(master, results)
    master:Clear()
    
    -- Player panel shit
    local playerPanel = vgui.Create("yaws.panel", master)

    local grid = vgui.Create("ThreeGrid", playerPanel)
    grid:SetColumns(3)
    grid:SetHorizontalMargin(10)
    grid:SetVerticalMargin(10)
    grid:InvalidateParent(true)
    
    -- this is kinda poopy but eh it's fine
    local function placeCards(filter)
        grid:Clear()
        local cards = {}

        for k,v in ipairs(player.GetAll()) do
            if(v:IsBot()) then continue end 
            if(string.Trim(filter) != "" && !string.find(string.lower(v:Name()), string.lower(filter), 1, true) && string.lower(v:SteamID()) != string.Trim(string.lower(filter)) && v:SteamID64() != string.Trim(filter)) then continue end

            local playerCard = vgui.Create("yaws.player_card", grid)
            playerCard:SetPlayer(v)
            playerCard:SetHeight(master:GetTall() * 0.15)
            playerCard.DoClick = function()
                YAWS.UI.StateCache["searching_players"] = {
                    filter = filter,
                    includeOffline = false 
                }

                YAWS.UI.HandleGettingPlayerWarndata(master, {
                    steamid = v:SteamID64(),
                    name = v:Name(),
                    usergroup = v:GetUserGroup(),
                })
            end 
            cards[#cards + 1] = playerCard
        end

        for k,v in ipairs(cards) do
            grid:AddCell(v)
        end
    end
    if(!results) then 
        placeCards("")
    else 
        -- If we're being told to put in results automatically (for offline
        -- peeps) - shit solution but i cba makingn the other local func do it
        -- cus thats a pain to check for and add
        grid:Clear()
        local cards = {}
    
        for k,v in pairs(results) do
            local playerCard = vgui.Create("yaws.player_card", grid)
            playerCard:SetOfflinePlayer(k, v)
            playerCard:SetHeight(master:GetTall() * 0.15)
            playerCard.DoClick = function()
                YAWS.UI.StateCache["searching_players"] = {
                    filter = YAWS.UI.PlayerSearchCache,
                    includeOffline = true 
                }

                YAWS.UI.HandleGettingPlayerWarndata(master, {
                    steamid = k,
                    name = v.name,
                    usergroup = v.usergroup,
                })
            end 
            cards[#cards + 1] = playerCard
        end
    
        for k,v in ipairs(cards) do
            grid:AddCell(v)
        end
    end 

    -- Search Stuff at the top
    local searchPanel = vgui.Create("DPanel", master)
    searchPanel.Paint = function() end

    local search = vgui.Create("yaws.text_entry", searchPanel)
    search:SetPlaceholder(YAWS.Language.GetTranslation("players_tab_search"))
    search:SetMaximumCharCount(75)
    
    local searchSubmit = vgui.Create("yaws.button", searchPanel)
    searchSubmit:SetLabel(YAWS.Language.GetTranslation("players_tab_search_button"))
    
    local includeOffline = vgui.Create("yaws.switch", searchPanel)
    includeOffline:SetValue(false)
    includeOffline:SetColor(YAWS.UI.ColorScheme()['theme'])
    
    searchSubmit.DoClick = function() -- needs to be here for includeOffline to be an object
        if(includeOffline:GetValue()) then 
            YAWS.UI.HandleOfflinePlayerSearch(master, search:GetValue())
            return 
        end 

        placeCards(search:GetValue())
    end
    
    local offlineLabel = vgui.Create("DLabel", searchPanel)
    offlineLabel:SetText(YAWS.Language.GetTranslation("players_tab_offline"))
    offlineLabel:SetFont("yaws.6")
    offlineLabel:SetColor(YAWS.UI.ColorScheme()['text_main'])

    master.Paint = function() end
    master.PerformLayout = function(self, w, h)
        -- searchPanel:DockMargin(10, 10, 10, 10)
        searchPanel:Dock(TOP)
        searchPanel:SetHeight(h * 0.09)

        search:Dock(FILL)
        search:DockMargin(10, 10, 10, 10)

        searchSubmit:Dock(RIGHT)
        searchSubmit:DockMargin(0, 10, 10, 10)
        searchSubmit:SetWide(w * 0.15)
        
        includeOffline:Dock(RIGHT)
        includeOffline:DockMargin(0, search:GetTall() * 0.485, 10, search:GetTall() * 0.485)
        includeOffline:SetWide(math.max(30, w * 0.045))
        
        offlineLabel:Dock(RIGHT)
        offlineLabel:DockMargin(0, 0, 10, 0)
        surface.SetFont(offlineLabel:GetFont())
        offlineLabel:SetWide(surface.GetTextSize(offlineLabel:GetText()))


        playerPanel:DockMargin(10, 0, 10, 10)
        playerPanel:Dock(FILL)

        grid:Dock(FILL)
        grid:DockMargin(10, 10, 10, 10)
    end

    master:InvalidateLayout()

    if(YAWS.UI.LoadingCache) then 
        if(YAWS.UI.LoadingCache.panel == "searching_players") then 
            search:SetValue(YAWS.UI.LoadingCache.filter)
            includeOffline:SetValue(YAWS.UI.LoadingCache.offline)
            YAWS.UI.PlayerSearchCache = YAWS.UI.LoadingCache.filter -- This is needed for reinputting the loading cache on selecting a offline player card

            YAWS.UI.LoadingCache = nil
        end 
    end 
    if(YAWS.UI.StateCache) then 
        if(YAWS.UI.StateCache["searching_players"] && !YAWS.UI.StateCache["player_ignore"]) then 
            search:SetValue(YAWS.UI.StateCache["searching_players"].filter)
            includeOffline:SetValue(YAWS.UI.StateCache["searching_players"].includeOffline)
            if(!YAWS.UI.StateCache["searching_players"].includeOffline) then 
                placeCards(YAWS.UI.StateCache["searching_players"].filter)
            else 
                YAWS.UI.HandleOfflinePlayerSearch(master, YAWS.UI.StateCache["searching_players"].filter)
            end 
        
            YAWS.UI.StateCache["searching_players"] = nil
        end 
    end 
    -- YAWS.UI.StateCache["searching_players"] = {
    --     filter = filter,
    --     includeOffline = false 
    -- }
end


function YAWS.UI.HandleOfflinePlayerSearch(master, filter)
    if(string.Trim(filter) == "") then return end 
    YAWS.UI.DisplayLoading(master)

    -- Query the server for the results.
    net.Start("yaws.core.offlineplayersearch")
    net.WriteString(filter)
    net.SendToServer()

    YAWS.UI.CurrentData.WaitingForServerResponse = true 
    YAWS.UI.LoadingCache = {
        panel = "searching_players",
        filter = filter,
        offline = true
    }
end 
net.Receive("yaws.core.offlineplayerresults", function(len)
    YAWS.Core.PayloadDebug("yaws.core.offlineplayerresults", len)
    if(!YAWS.UI.CurrentData.WaitingForServerResponse) then
        YAWS.Core.Print("[yaws.core.offlineplayerresults] Just got a message from the server without wanting data from the server..?")
        return
    end 
    
    local results = {}
    local size = net.ReadUInt(16)
    for i=0,size - 1 do 
        results[net.ReadString()] = {
            name = net.ReadString(),
            usergroup = net.ReadString()
        }
    end 
    YAWS.UI.Tabs.Players(YAWS.UI.CurrentData.MasterCache, results)
    YAWS.UI.CurrentData.WaitingForServerResponse = false
end)

-- admin notes thing is for the context menu
-- this doesn't use a loading cache as it doesn't return anywhere
function YAWS.UI.HandleGettingPlayerWarndata(master, data, toAdminNotes) 
    YAWS.UI.DisplayLoading(master)

    -- Query the server for the results.
    net.Start("yaws.core.playerwarndata")
    net.WriteString(data.steamid)
    net.SendToServer()

    YAWS.UI.CurrentData.WaitingForServerResponse = true 
    YAWS.UI.CurrentData.PlayerDataCache = data 
    if(toAdminNotes) then 
        YAWS.UI.CurrentData.ForceAdminNotes = true
    end 
end 
net.Receive("yaws.core.playerwarndataresults", function(len)
    YAWS.Core.PayloadDebug("yaws.core.playerwarndataresults", len)
    if(!YAWS.UI.CurrentData.WaitingForServerResponse) then
        YAWS.Core.Print("[yaws.core.playerwarndataresults] Just got a message from the server without wanting data from the server..?")
        return
    end 

    local length = net.ReadUInt(16)
    local warns = util.JSONToTable(util.Decompress(net.ReadData(length)))
    local data = YAWS.UI.CurrentData.PlayerDataCache
    data.warnData = warns
    data.adminNotes = net.ReadString()

    if(YAWS.UI.CurrentData.ForceAdminNotes) then 
        YAWS.UI.DisplayPlayerNotes(YAWS.UI.CurrentData.MasterCache, data)
    else 
        YAWS.UI.DisplayPlayerInfo(YAWS.UI.CurrentData.MasterCache, data)
    end 

    YAWS.UI.CurrentData.WaitingForServerResponse = false 
end)


-- Displaying Player Shit
-- Data needs to follow something like: 
-- {
--     steamid = "76561198121018313",
--     name = "Livaco",
--     usergroup = "the server femboy",
--     warnData = {
--         [1] = {
--             id = "yeet",
--             -- blah blah
--         }
--     },
--     adminNotes = "yeetus feetus"
-- }
function YAWS.UI.DisplayPlayerInfo(master, data)
    data.realSteamID = util.SteamIDFrom64(data.steamid or "")
    master:Clear()
    master.PerformLayout = function() end 
    
    local playerPanel = vgui.Create("yaws.panel", master)
    local picture = vgui.Create("yaws.round_avatar", playerPanel)
    picture:SetSteamID(data.steamid, 256)

    -- delete all warnings
    local deleteWarns = vgui.Create("yaws.button", playerPanel)
    deleteWarns:SetColors("text_placeholder", "button_warn_hover")
    deleteWarns:SetLabel("")
    deleteWarns.sideShadow:Remove()
    deleteWarns.bottomShadow:Remove()
    deleteWarns.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()

        if(self:IsHovered()) then 
            self.color = YAWS.UI.LerpColor(self.frameTime * 5, self.color, colors[self.hoverColor])
        else 
            self.color = YAWS.UI.LerpColor(self.frameTime * 5, self.color, colors[self.baseColor])
        end

        -- Display a delete icon
        YAWS.UI.SetSurfaceDrawColor(self.color)
        surface.SetMaterial(YAWS.UI.MaterialCache['close'])
        surface.DrawTexturedRect(0, 0, w, h)
    end 
    deleteWarns.PerformLayout = function() end
    deleteWarns.DoClick = function()
        YAWS.UI.ConfirmDeleteWarns(master, data)
    end 

    -- Warning Points
    surface.SetFont("yaws.7")
    local pointsTextSize = surface.GetTextSize(data.warnData.pointCount)
    local expiredPointsTextSize = surface.GetTextSize(data.warnData.expiredPointCount)

    playerPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

        draw.SimpleText(data.name, "yaws.10", h + (5), h * 0.375, colors['text_header'], 0, 1)
        draw.SimpleText(data.realSteamID, "yaws.7", h + (5), h * 0.625, colors['text_main'], 0, 1)

        -- points 
        draw.NoTexture()
        surface.SetMaterial(YAWS.UI.MaterialCache['warning'])
        YAWS.UI.SetSurfaceDrawColor(colors['active_warning'])
        surface.DrawTexturedRect(w - 14 - (h * 0.235) - pointsTextSize, h - (h * 0.235) - 10, h * 0.235, h * 0.235)

        draw.SimpleText(data.warnData.pointCount, "yaws.7", w - 10, h * 0.775, colors['text_main'], 2, 1)
        
        -- expired points 
        if(YAWS.Config.GetValue("point_cooldown_time") != 0) then
            draw.NoTexture()
            surface.SetMaterial(YAWS.UI.MaterialCache['warning'])
            YAWS.UI.SetSurfaceDrawColor(colors['expired_warning'])
            surface.DrawTexturedRect(w - 24 - ((h * 0.235) * 2) - pointsTextSize - expiredPointsTextSize - 5, h - (h * 0.235) - 10, h * 0.235, h * 0.235)
            
            draw.SimpleText(data.warnData.expiredPointCount, "yaws.7", w - 22 - (h * 0.235) - pointsTextSize - 5, h * 0.775, colors['text_main'], 2, 1)
        end 
    end 
    playerPanel.PerformLayout = function(self, w, h)
        self:LayoutShadows(w, h)
        
        picture:Dock(LEFT)
        picture:DockMargin(10, 10, 10, 10)
        picture:SetWide(picture:GetTall())
        
        deleteWarns:SetSize(playerPanel:GetTall() * 0.2, playerPanel:GetTall() * 0.2)
        deleteWarns:SetPos(w - deleteWarns:GetWide() - 10, 10)
    end 

    local warnTable = vgui.Create("yaws.table", master)
    warnTable:Dock(FILL)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_admin"), 0.125)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_reason"), 0.425)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_time"), 0.15)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_points"), 0.15)
    warnTable:AddColumn(YAWS.Language.GetTranslation("viewing_player_table_server"), 0.15)
    
    if(table.Count(data.warnData.warnings) <= 0) then -- they're numberically indexed but not guarenteed to be neat (e.g 1, 2, 3 -> they'll be 1, 5, 8, etc you get it)
        warnTable:RemoveDividersInBody()
        warnTable:SetCenterMessage("viewing_player_no_warns_found")
    else 
        for k,v in SortedPairsByMemberValue(data.warnData.warnings, "timestamp", true) do
            warnTable:AddEntry(function()
                YAWS.UI.StateCache["viewing_player"] = {
                    data = data
                }
                YAWS.UI.StateCache["warn_data_return"] = "viewing_player"

                YAWS.UI.DisplayWarnData(data, v)
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
                        SetClipboardText(string.format("[%s] %s(%s) warned %s(%s) for the reason \"%s\", adding %s points.", os.date("%H:%M:%S on %d/%m/%Y", v.time), v.admin, util.SteamIDFrom64(v.adminSteamID or ""), data.name, data.realSteamID, v.reason, v.points))
                    end,
                    icon = "icon16/folder.png"
                },
            }, v.admin, v.reason, string.NiceTime(os.time() - v.timestamp) .. " ago", v.points, v.server_id)
        end
    end

    local actionPanel = vgui.Create("yaws.panel", master)
    -- actionPanel:DockPadding(10, 10, 10, 10)
    actionPanel:RemoveShadows()

    local goBackButton = vgui.Create("yaws.button", actionPanel)
    goBackButton:SetLabel(YAWS.Language.GetTranslation("generic_back"))
    goBackButton.DoClick = function()
        YAWS.UI.Tabs.Players(master)
    end 

    local createWarnButton = vgui.Create("yaws.button", actionPanel)
    createWarnButton:SetLabel(YAWS.Language.GetTranslation("viewing_player_action_submit_warn"))
    createWarnButton.DoClick = function()
        if(!YAWS.UI.CurrentData['can_view']['warn_players']) then 
            YAWS.Language.SendMessage("chat_no_permission")
            return
        end 

        YAWS.UI.CurrentData.FrameCache:Remove()
        YAWS.UI.WarnPlayerPopup({
            name = data.name,
            steamid = data.steamid,
            realSteamID = data.realSteamID,
            usergroup = data.usergroup
        })
    end 

    local viewNotesButton = vgui.Create("yaws.button", actionPanel)
    viewNotesButton:SetLabel(YAWS.Language.GetTranslation("viewing_player_action_view_notes"))
    viewNotesButton.DoClick = function()
        YAWS.UI.DisplayPlayerNotes(master, data)
    end

    actionPanel.Paint = function() end 
    actionPanel.PerformLayout = function(self, w, h)
        -- self:LayoutShadows(w, h)

        goBackButton:Dock(LEFT)
        goBackButton:SetWide((w / 3) - 6)

        viewNotesButton:Dock(RIGHT)
        viewNotesButton:SetWide((w / 3) - 6)

        createWarnButton:Dock(FILL)
        createWarnButton:DockMargin(10, 0, 10, 0)
    end 

    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        playerPanel:Dock(TOP)
        playerPanel:SetHeight(h * 0.15)
        playerPanel:DockMargin(10, 10, 10, 10)

        warnTable:Dock(FILL)
        warnTable:DockMargin(10, 0, 10, 10)
        if(table.Count(data.warnData.warnings) > 0) then
            warnTable:FindBestSize()
        end
        
        actionPanel:Dock(BOTTOM)
        actionPanel:SetHeight(33)
        actionPanel:DockMargin(10, 0, 10, 10)
    end
    master:InvalidateLayout()
end

function YAWS.UI.DisplayPlayerNotes(master, data)
    master:Clear()
    master.PerformLayout = function() end 
    
    local playerPanel = vgui.Create("yaws.panel", master)
    local picture = vgui.Create("yaws.round_avatar", playerPanel)
    picture:SetSteamID(data.steamid, 256)

    playerPanel.PerformLayout = function(self, w, h)
        self:LayoutShadows(w, h)
        
        picture:Dock(LEFT)
        picture:DockMargin(10, 10, 10, 10)
        picture:SetWide(picture:GetTall())
    end 
    playerPanel.Paint = function(self, w, h)
        local colors = YAWS.UI.ColorScheme()
        draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

        draw.SimpleText(data.name, "yaws.10", h + (5), h * 0.375, colors['text_header'], 0, 1)
        draw.SimpleText(data.steamid, "yaws.7", h + (5), h * 0.625, colors['text_main'], 0, 1)
    end 
    
    local notesPanel = vgui.Create("yaws.text_entry", master)
    notesPanel:SetMultiline(true)
    notesPanel:SetText(data.adminNotes)
    notesPanel:SetMaximumCharCount(3000)
    notesPanel:SetPlaceholder(YAWS.Language.GetTranslation("viewing_player_player_notes"))
    notesPanel.overrideX = 8 -- cope https://upload.livaco.dev/u/XE4mTWJSeQ.png

    local actionPanel = vgui.Create("yaws.panel", master)
    -- actionPanel:DockPadding(10, 10, 10, 10)
    actionPanel:RemoveShadows()

    local goBackButton = vgui.Create("yaws.button", actionPanel)
    goBackButton:SetLabel(YAWS.Language.GetTranslation("generic_back"))
    goBackButton.DoClick = function()
        YAWS.UI.DisplayPlayerInfo(master, data)
    end 
    local saveNotesButton = vgui.Create("yaws.button", actionPanel)
    saveNotesButton:SetLabel(YAWS.Language.GetTranslation("viewing_player_save_player_notes"))
    saveNotesButton.DoClick = function()
        net.Start("yaws.adminnotes.updatenotes")
        net.WriteString(data.steamid)
        net.WriteString(notesPanel:GetValue())
        net.SendToServer()

        YAWS.UI.Tabs.Players(master)
    end

    actionPanel.Paint = function() end 
    actionPanel.PerformLayout = function(self, w, h)
        -- self:LayoutShadows(w, h)

        goBackButton:Dock(LEFT)
        goBackButton:SetWide((w / 2) - 5)

        saveNotesButton:Dock(RIGHT)
        saveNotesButton:SetWide((w / 2) - 5)
    end 

    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h) 
        playerPanel:Dock(TOP)
        playerPanel:SetHeight(h * 0.15)
        playerPanel:DockMargin(10, 10, 10, 10)

        notesPanel:Dock(FILL)
        notesPanel:DockMargin(10, 0, 10, 10)
        
        actionPanel:Dock(BOTTOM)
        actionPanel:SetHeight(33)
        actionPanel:DockMargin(10, 0, 10, 10)
    end
    master:InvalidateLayout()
end


function YAWS.UI.DisplayWarnData(playerData, warnData)
    YAWS.UI.ViewWarning(playerData, warnData)
    YAWS.UI.CurrentData.FrameCache:Remove()
end