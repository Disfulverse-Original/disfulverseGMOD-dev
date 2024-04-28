function YAWS.UI.Tabs.Admin(master)
    master:Clear()

    -- Content Panel
    local settingsSidebar = vgui.Create("yaws.sidebar", master)

    local panelContainer = vgui.Create("yaws.panel", master)
    panelContainer.Paint = function() end 
    panelContainer:RemoveShadows()

    local settingsPanel = vgui.Create("yaws.panel", panelContainer)
    
    -- this is really shit but idk how else to make this work properly
    local function clearPanel()
        panelContainer:Clear()
        settingsPanel = vgui.Create("yaws.panel", panelContainer)

        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide(w * 0.1)
            settingsSidebar:DockMargin(10, 10, 5, 10)
            
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
    
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 10)
        end 
        master:InvalidateLayout()
    end 

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_permissions"), YAWS.UI.MaterialCache['permissions'], true, function()
        settingsPanel:Clear() 
        clearPanel()

        -- Permissions Shit
        local groupSelect = vgui.Create("yaws.combo", panelContainer)
        for k,v in pairs(CAMI.GetUsergroups()) do 
            groupSelect:AddChoice(k, k)
        end 
        
        -- The actual permissions entries
        local grid = vgui.Create("ThreeGrid", settingsPanel)
        grid:SetColumns(2)
        grid:SetHorizontalMargin(10)
        grid:SetVerticalMargin(10)
        grid:InvalidateParent(true)
        
        local changed = {}
        groupSelect.OnSelect = function(self, index, value, data)
            grid:Clear()
            
            local defaults = {}
            if(YAWS.UI.CurrentData['admin_settings']['current_permissions'][value]) then 
                defaults = YAWS.UI.CurrentData['admin_settings']['current_permissions'][value]
            end 

            if(!YAWS.UI.PermissionsNames) then 
                YAWS.UI.UpdatePermissionNames()
            end 
            for k,v in ipairs(YAWS.UI.Permissions) do
                local entry = vgui.Create("yaws.permissions_entry", grid)
                entry:SetName(YAWS.UI.PermissionsNames[v])
                entry:UseReccomendedHeight()
                if(defaults[v]) then 
                    entry:SetValue(defaults[v])
                end 
                entry.OnChange = function(val)
                    if(!changed[value]) then 
                        changed[value] = {} 
                    end 
                    changed[value][v] = val
                end 
                
                grid:AddCell(entry)
            end
        end
        groupSelect:ChooseOptionID(1)

        local save = vgui.Create("yaws.button", panelContainer)
        save:SetLabel(YAWS.Language.GetTranslation("generic_save"))
        save.DoClick = function()
            net.Start("yaws.permissions.updatepermissions")

            net.WriteUInt(table.Count(changed), 16)
            for k,v in pairs(changed) do 
                net.WriteString(k)

                net.WriteUInt(table.Count(v), 16)
                for x,y in pairs(v) do 
                    net.WriteString(x)
                    net.WriteBool(y)
                end 
            end 

            net.SendToServer()
        end 
        
        settingsPanel.PerformLayout = function(self, w, h)
            self:LayoutShadows(w, h)

            grid:Dock(FILL)
        end 
        master.PerformLayout = function(s, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide(w * 0.1)
            settingsSidebar:DockMargin(10, 10, 5, 10)

            groupSelect:Dock(TOP)
            groupSelect:SetHeight(h * 0.059)
            groupSelect:DockMargin(5, 10, 10, 5)

            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)

            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 5, 10, 5)

            save:Dock(BOTTOM)
            save:SetHeight(h * 0.055)
            save:DockMargin(5, 5, 10, 10)
        end 

        master:InvalidateLayout()
    end)

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_settings"), YAWS.UI.MaterialCache['settings'], true, function()
        settingsPanel:Clear() 
        clearPanel()
        
        local scrollPanel = vgui.Create("yaws.scroll", settingsPanel)
        
        -- Settings n shit
        local panels = {}
        local i = 0
        local max = #YAWS.Config.SettingOrder
        local changed = {}

        for k,v in ipairs(YAWS.Config.SettingOrder) do
            i = i + 1
            local k,v = v, YAWS.Config.Settings[v] -- ah the glory of laziness of changing around variable names
            local uiData = YAWS.Config.UIData[k]

            local panel = vgui.Create("yaws.settings_entry", scrollPanel)
            panel:SetName(YAWS.Language.GetTranslation(uiData.name))
            panel:SetDesc(YAWS.Language.GetTranslation(uiData.desc))
            panel:SetType(v.type)
            panel:Construct()
            panel:SetValue((v.value != nil) && v.value || v.default)

            -- Text Entry
            if(v.type == "string") then
                panel.OnChange = function(val)
                    changed[k] = {
                        type = "string",
                        value = val
                    }
                end
            end

            -- Switch
            if(v.type == "boolean") then
                panel.OnChange = function(val)
                    changed[k] = {
                        type = "boolean",
                        value = val
                    }
                end
            end

            -- Combo Box
            if(v.type == "combo") then
                panel:SetOptions(v.options)
                panel.OnChange = function(index, value, data)
                    changed[k] = {
                        type = "combo",
                        value = value
                    }
                end

                panel.element:Dim()
            end

            -- Color
            if(v.type == "color") then
                panel.OnChange = function(val)
                    changed[k] = {
                        type = "color",
                        value = val
                    }
                end
            end

            -- Number/Integer
            if(v.type == "number") then
                panel.OnChange = function(val)
                    changed[k] = {
                        type = "number",
                        value = val
                    }
                end
            end

            local divider = nil
            if(i < max) then
                divider = vgui.Create("yaws.divider", scrollPanel)
            end

            panels[#panels + 1] = {
                ['panel'] = panel,
                ['divider'] = divider
            }
        end

        local save = vgui.Create("yaws.button", panelContainer)
        save:SetLabel(YAWS.Language.GetTranslation("generic_save"))
        save.DoClick = function()
            net.Start("yaws.config.update")

            net.WriteUInt(table.Count(changed), 16) -- have to bite not using a numerical table here to prevent dupe entries
            for k,v in pairs(changed) do
                net.WriteString(k)

                if(v.type == "string" || v.type == "combo") then 
                    net.WriteString(v.value)
                end 
                if(v.type == "boolean") then 
                    net.WriteBool(v.value)
                end 
                if(v.type == "color") then 
                    net.WriteUInt(v.value.r, 8)
                    net.WriteUInt(v.value.g, 8)
                    net.WriteUInt(v.value.b, 8)
                    net.WriteUInt(v.value.a, 8)
                end 
                if(v.type == "number") then 
                    if(k == "point_max") then 
                        net.WriteUInt(v.value, 12)
                        continue 
                    end 

                    net.WriteInt(v.value, 32)
                end 
            end

            net.SendToServer()
        end

        settingsPanel.PerformLayout = function(self, w, h)
            self:LayoutShadows(w, h)

            scrollPanel:Dock(FILL)

            for x,y in pairs(panels) do
                y.panel:Dock(TOP)
                y.panel:UseReccomendedHeight()
    
                if (y.divider != nil) then
                    y.divider:Dock(TOP)
                    y.divider:SetHeight(2)
                end
            end
        end 
        settingsPanel:InvalidateLayout()

        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide(w * 0.1)
            settingsSidebar:DockMargin(10, 10, 5, 10)
    
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
    
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 5)
    
            save:Dock(BOTTOM)
            save:SetHeight(h * 0.055)
            save:DockMargin(5, 5, 10, 10)
        end 
        master:InvalidateLayout()
    end)

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_presets"), YAWS.UI.MaterialCache['paper'], true, function()
        settingsPanel:Clear() 
        clearPanel()

        local scrollPanel = vgui.Create("yaws.scroll", settingsPanel)
        local i = 1
        local max = table.Count(YAWS.UI.CurrentData.current_presets)
        if(max == 0) then 
            scrollPanel.Paint = function(self, w, h)
                draw.SimpleText(YAWS.Language.GetTranslation("admin_tab_presets_none"), "yaws.7", w / 2, h / 2, YAWS.UI.ColorScheme()['text_main'], 1, 1)
            end 
        end 
        for k,v in pairs(YAWS.UI.CurrentData.current_presets) do 
            local panel = vgui.Create("DPanel", scrollPanel)
            panel:Dock(TOP)
            panel:SetHeight(60)
            panel.Paint = function(self, w, h)
                -- draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
                local colors = YAWS.UI.ColorScheme() 

                -- WHY WAS I UNAWARE THIS RETURNED TEXT SIZES????!?!?!?!?!?!
                draw.SimpleText(k, "yaws.9", 10, h * 0.325, colors['text_header'], 0, 1)
                draw.SimpleText(YAWS.UI.CutoffText(v.reason, "yaws.7", w * 0.75) .. " · " .. YAWS.Language.GetFormattedTranslation("points_format", v.points), "yaws.7", 10, h * 0.675, colors['text_main'], 0, 1)
            end
            
            local remove = vgui.Create("DButton", panel)
            remove:SetText("")
            remove.Paint = function(self, w, h)
                draw.NoTexture()
                surface.SetDrawColor(YAWS.UI.ColorScheme()['text_main'])
                surface.SetMaterial(YAWS.UI.MaterialCache['close'])
                surface.DrawTexturedRect(h * 0.35, h * 0.35, h * 0.35, h * 0.35)
            end 
            remove.DoClick = function()
                YAWS.UI.CurrentData.WaitingForServerResponse = true 
                YAWS.UI.DisplayLoading(master)

                net.Start("yaws.config.removepreset")
                net.WriteString(k)
                net.SendToServer()

                YAWS.UI.LoadingCache = {
                    panel = "remove_preset",
                    key = k
                }
            end 
            
            panel.PerformLayout = function(self, w, h) 
                remove:Dock(RIGHT)
                remove:SetWide(h)
            end 

            if(i != max) then
                local div = vgui.Create("yaws.divider", scrollPanel)
                div:Dock(TOP)
            end

            i = i + 1
        end 
        
        
        local createPreset = vgui.Create("yaws.panel", panelContainer)
        
        local settings = vgui.Create("yaws.panel", createPreset)
        settings.Paint = function() end 
        settings:RemoveShadows()

        local name = vgui.Create("yaws.text_entry", settings)
        name:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_presets_name"))
        name:SetMaximumCharCount(25)

        local reason = vgui.Create("yaws.text_entry", settings)
        reason:SetPlaceholder(YAWS.Language.GetTranslation("admin_tab_presets_reason"))
        reason:SetMaximumCharCount(150)

        local points = vgui.Create("yaws.wang", settings)
        points:SetText("")
        points:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
        points:SetMin(0)
        points:SetMax(YAWS.Config.GetValue("player_warn_maxpoints"))

        local create = vgui.Create("yaws.button", createPreset)
        create:SetLabel(YAWS.Language.GetTranslation("admin_tab_presets_create"))
        create.DoClick = function()
            YAWS.UI.CurrentData.WaitingForServerResponse = true 
            YAWS.UI.DisplayLoading(master)

            net.Start("yaws.config.addpreset")
            net.WriteString(name:GetValue())
            net.WriteString(reason:GetValue())
            net.WriteUInt(points:GetValue(), 12)
            net.SendToServer()

            YAWS.UI.LoadingCache = {
                panel = "add_preset",
                name = name:GetValue(),
                reason = reason:GetValue(),
                points = points:GetValue()
            }
        end

        settings.PerformLayout = function(self, w, h)
            -- self:LayoutShadows(w, h)
            name:Dock(LEFT)
            name:SetWidth(w * 0.2)

            reason:Dock(LEFT)
            reason:DockMargin(10, 0, 0, 0)
            reason:SetWidth((w * 0.65) - 10)

            points:Dock(RIGHT)
            points:SetWidth(w * 0.15 - 9)
        end 

        createPreset.PerformLayout = function(self, w, h)
            self:LayoutShadows(w, h)

            settings:Dock(TOP)
            settings:SetHeight(h * 0.35)
            settings:DockMargin(10, 10, 10, 10)

            create:Dock(FILL)
            create:DockMargin(10, 0, 10, 10)
        end 

        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide(w * 0.1)
            settingsSidebar:DockMargin(10, 10, 5, 10)
            
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
    
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 10)

            scrollPanel:Dock(FILL)

            createPreset:Dock(BOTTOM)
            createPreset:DockMargin(5, 0, 10, 10)
            createPreset:SetHeight(h * 0.16)
        end 
    end)

    settingsSidebar:AddTab(YAWS.Language.GetTranslation("admin_tab_sidebar_punishments"), YAWS.UI.MaterialCache['gavel'], true, function()
        settingsPanel:Clear() 
        clearPanel()
    
        local scrollPanel = vgui.Create("yaws.scroll", settingsPanel)
        local i = 1
        local max = table.Count(YAWS.UI.CurrentData.admin_settings.current_punishments)
        if(max == 0) then 
            scrollPanel.Paint = function(self, w, h)
                draw.SimpleText(YAWS.Language.GetTranslation("admin_tab_punishments_none"), "yaws.7", w / 2, h / 2, YAWS.UI.ColorScheme()['text_main'], 1, 1)
            end 
        end 
        for k,v in pairs(YAWS.UI.CurrentData.admin_settings.current_punishments) do
            local panel = vgui.Create("DPanel", scrollPanel)
            panel:Dock(TOP)
            panel:SetHeight(60)
            local type = YAWS.Punishments.Types[v.type]
            panel.Paint = function(self, w, h)
                -- draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
                local colors = YAWS.UI.ColorScheme() 

                draw.SimpleText(YAWS.Language.GetFormattedTranslation("points_format", k), "yaws.9", 10, h * 0.325, colors['text_header'], 0, 1)
                draw.SimpleText(type.name, "yaws.7", 10, h * 0.675, colors['text_main'], 0, 1)
            end
            
            local remove = vgui.Create("DButton", panel)
            remove:SetText("")
            remove.Paint = function(self, w, h)
                draw.NoTexture()
                surface.SetDrawColor(YAWS.UI.ColorScheme()['text_main'])
                surface.SetMaterial(YAWS.UI.MaterialCache['close'])
                surface.DrawTexturedRect(h * 0.35, h * 0.35, h * 0.35, h * 0.35)
            end 
            remove.DoClick = function()
                YAWS.UI.CurrentData.WaitingForServerResponse = true 
                YAWS.UI.DisplayLoading(master)

                net.Start("yaws.punishments.removepunishment")
                net.WriteUInt(k, 16)
                net.SendToServer()

                YAWS.UI.LoadingCache = {
                    panel = "remove_punishment",
                    key = k,
                }
            end 
            
            panel.PerformLayout = function(self, w, h) 
                remove:Dock(RIGHT)
                remove:SetWide(h)
            end 

            if(i != max) then
                local div = vgui.Create("yaws.divider", scrollPanel)
                div:Dock(TOP)
            end

            i = i + 1
        end 
        
        local new = vgui.Create("DPanel", panelContainer)
        new.Paint = function() end 

        local typeDescription = YAWS.Language.GetTranslation("admin_tab_punishments_notype")
        local createPreset = vgui.Create("yaws.panel", new)
        createPreset.Paint = function(self, w, h)
            local colors = YAWS.UI.ColorScheme() 
            draw.RoundedBox(0, 0, 0, w, h, colors['panel_background'])

            -- Punishment type description
            draw.SimpleText(typeDescription, "yaws.6", w / 2, h * 0.6, colors['text_main'], 1, 1)
        end
        local alterPreset = vgui.Create("yaws.panel", new)

        local selectType = vgui.Create("yaws.combo", createPreset)
        selectType:SetText(YAWS.Language.GetTranslation("admin_tab_punishments_selecttype"))
        for k,v in pairs(YAWS.Punishments.Types) do
            selectType:AddChoice(v.name, k)
        end
        
        local pointCount = vgui.Create("yaws.wang", createPreset)
        pointCount:SetText("")
        pointCount:SetPlaceholder(YAWS.Language.GetTranslation("generic_point_count"))
        pointCount:SetMin(0)
        pointCount:SetMax(4096)

        local submit = vgui.Create("yaws.button", createPreset)
        submit:SetLabel(YAWS.Language.GetTranslation("admin_tab_punishments_create"))
        
        local scroll = vgui.Create("yaws.scroll", alterPreset)
        local options = {}
        local function updateOptionList(newType)
            scroll:Clear()
            options = {}
            
            local type = YAWS.Punishments.Types[newType]
            for k,v in pairs(type.params) do 
                options[k] = v.default
                -- Create a panel for each param and dock it to the top of the scroll panel. Make it display the name and description of the parameter in the paint function.
                local panel = vgui.Create("DPanel", scroll)
                panel:Dock(TOP)
                panel:SetTall(scroll:GetTall() * 0.52)
                panel:DockMargin(0, 1, 0, 0)
                panel.Paint = function(self, w, h)
                    -- draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
                    -- draw.RoundedBox(0, 0, 0, w, 1, Color(0, 255, 0))
                    local colors = YAWS.UI.ColorScheme() 
                    -- Parameter name
                    local _,nextY = draw.SimpleText(v.name, "yaws.8", 10, 10, colors['text_header'], 0, 0)

                    -- Parameter description
                    draw.SimpleText(v.description, "yaws.7", 10, nextY + 10, colors['text_main'], 0, 0)
                end
            
                if(v.type == "string") then 
                    local textEntry = vgui.Create("yaws.text_entry", panel)
                    textEntry:SetValue(v.default)
                    textEntry.OnChange = function(self)
                        options[k] = self:GetValue()
                    end
                    
                    panel.PerformLayout = function(self, w, h)
                        textEntry:Dock(BOTTOM)
                        textEntry:SetHeight(h * 0.33)
                        textEntry:DockMargin(10, 0, 10, 10)
                    end
                end 
                if(v.type == "number") then 
                    local wang = vgui.Create("yaws.wang", panel)
                    wang:SetValue(v.default)
                    wang.OnChange = function(self)
                        options[k] = self:GetValue()
                    end
                    
                    panel.PerformLayout = function(self, w, h)
                        wang:Dock(BOTTOM)
                        wang:SetHeight(h * 0.33)
                        wang:DockMargin(10, 0, 10, 10)
                    end
                end 
            end
        end 

        submit.DoClick = function(self)
            YAWS.UI.CurrentData.WaitingForServerResponse = true 
            YAWS.UI.DisplayLoading(master)

            local typeKey = selectType:GetOptionData(selectType:GetSelectedID())
            net.Start("yaws.punishments.createpunishment")
            net.WriteString(typeKey)
            net.WriteUInt(pointCount:GetValue(), 12)
            
            net.WriteUInt(table.Count(options), 16)
            for k,v in pairs(options) do 
                net.WriteString(k)
                net.WriteString(YAWS.Punishments.Types[typeKey].params[k].type)
                if(YAWS.Punishments.Types[typeKey].params[k].type == "string") then 
                    net.WriteString(v)
                end 
                if(YAWS.Punishments.Types[typeKey].params[k].type == "number") then 
                    net.WriteUInt(v, 32)
                end
            end

            net.SendToServer()

            YAWS.UI.LoadingCache = {
                panel = "add_punishment",
                type = typeKey,
                pointValue = pointCount:GetValue()
            }
        end

        selectType.OnSelect = function(self, index, value, data)
            typeDescription = YAWS.Punishments.Types[data].description
            updateOptionList(data)
        end 

        createPreset.PerformLayout = function(self, w, h)
            self:LayoutShadows(w, h)

            selectType:Dock(TOP)
            selectType:SetHeight(h * 0.164)
            selectType:DockMargin(10, 10, 10, 10)

            pointCount:Dock(TOP)
            pointCount:SetHeight(h * 0.164)
            pointCount:DockMargin(10, 0, 10, 10)

            submit:Dock(BOTTOM)
            submit:SetHeight(h * 0.164)
            submit:DockMargin(10, 0, 10, 10)
        end 
        alterPreset.PerformLayout = function(self, w, h)
            self:LayoutShadows(w, h)
            scroll:Dock(FILL)
        end
        new.PerformLayout = function(self, w, h)
            createPreset:Dock(LEFT)
            createPreset:SetWide((w * 0.45) - 5)
            
            alterPreset:Dock(RIGHT)
            alterPreset:SetWide((w * 0.55) - 5)
        end 
    
        master.PerformLayout = function(self, w, h)
            settingsSidebar:Dock(LEFT)
            settingsSidebar:SetWide(w * 0.1)
            settingsSidebar:DockMargin(10, 10, 5, 10)
                
            panelContainer:Dock(FILL)
            panelContainer:DockMargin(0, 0, 0, 0)
        
            settingsPanel:Dock(FILL)
            settingsPanel:DockMargin(5, 10, 10, 10)
    
            scrollPanel:Dock(FILL)
    
            new:Dock(BOTTOM)
            new:DockMargin(5, 0, 10, 10)
            new:SetHeight(h * 0.32)
        end 
    end)
    
    master.Paint = function(self, w, h) end 
    master.PerformLayout = function(self, w, h)
        settingsSidebar:Dock(LEFT)
        settingsSidebar:SetWide(w * 0.1)
        settingsSidebar:DockMargin(10, 10, 5, 10)
        
        panelContainer:Dock(FILL)
        panelContainer:DockMargin(0, 0, 0, 0)

        settingsPanel:Dock(FILL)
        settingsPanel:DockMargin(5, 10, 10, 10)
    end 
    
    master:InvalidateLayout()

    -- Net message on confirmation of done adding presets
    net.Receive("yaws.config.confirmupdate", function(len)
        YAWS.Core.PayloadDebug("yaws.config.confirmpreset", len)
        if(!YAWS.UI.CurrentData.WaitingForServerResponse) then 
            YAWS.Core.Print("[yaws.config.confirmpreset] Just got a message from the server without wanting data from the server..?")
            return
        end 

        local success = net.ReadBool()
        if(success) then 
            if(YAWS.UI.LoadingCache['panel'] == "add_preset") then 
                YAWS.UI.CurrentData.current_presets[YAWS.UI.LoadingCache.name] = {
                    points = YAWS.UI.LoadingCache.points,
                    reason = YAWS.UI.LoadingCache.reason
                }
            end 
            if(YAWS.UI.LoadingCache['panel'] == "remove_preset") then 
                YAWS.UI.CurrentData.current_presets[YAWS.UI.LoadingCache.key] = nil
            end 
            if(YAWS.UI.LoadingCache['panel'] == "add_punishment") then 
                YAWS.UI.CurrentData.admin_settings.current_punishments[YAWS.UI.LoadingCache.pointValue] = {
                    type = YAWS.UI.LoadingCache.type
                }
            end 
            if(YAWS.UI.LoadingCache['panel'] == "remove_punishment") then 
                YAWS.UI.CurrentData.admin_settings.current_punishments[YAWS.UI.LoadingCache.key] = nil
            end 
        end 
        
        YAWS.UI.CurrentData.FrameCache:SetSidebarSelectedName(YAWS.Language.GetTranslation("sidebar_admin"))
        YAWS.UI.Tabs.Admin(YAWS.UI.CurrentData.MasterCache)
        YAWS.UI.CurrentData.WaitingForServerResponse = false
    end)
    
    if(YAWS.UI.LoadingCache) then 
        if(YAWS.UI.LoadingCache.panel == "add_preset" || YAWS.UI.LoadingCache.panel == "remove_preset") then 
            settingsSidebar:SetSelectedName(YAWS.Language.GetTranslation("admin_tab_sidebar_presets"))
        end 
        if(YAWS.UI.LoadingCache.panel == "add_punishment" || YAWS.UI.LoadingCache.panel == "remove_punishment") then 
            settingsSidebar:SetSelectedName(YAWS.Language.GetTranslation("admin_tab_sidebar_punishments"))
        end 

        YAWS.UI.LoadingCache = nil
    end 
end 