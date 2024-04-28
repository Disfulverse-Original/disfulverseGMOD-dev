function YAWS.UI.Tabs.Settings(master)
    master:Clear()

    -- Settings Panel
    local scrollContainer = vgui.Create("yaws.panel", master)
    local settingsPanel = vgui.Create("yaws.scroll", scrollContainer)

    local panels = {}
    local i = 0
    local max = table.Count(YAWS.UserSettings.Settings) -- Not numerically indexed ;-;
    
    for k,v in pairs(YAWS.UserSettings.Settings) do
        i = i + 1

        local panel = vgui.Create("yaws.settings_entry", settingsPanel)
        panel:SetName(YAWS.Language.GetTranslation(v.name))
        panel:SetDesc(YAWS.Language.GetTranslation(v.desc))
        panel:SetType(v.type)
        panel:Construct()
        panel:SetValue((v.value != nil) && v.value || v.default)

        -- Switch
        if(v.type == "boolean") then
            panel.OnChange = function(val)
                YAWS.UserSettings.SetValue(k, val)
            end
        end

        -- Combo Box
        if(v.type == "combo") then
            panel:SetOptions(v.options)
            panel.OnChange = function(index, value, data)
                YAWS.UserSettings.SetValue(k, value)
            end

            panel.element:Dim()
        end

        local divider = nil
        if(i < max) then
            divider = vgui.Create("yaws.divider", settingsPanel)
        end

        panels[#panels + 1] = {
            ['panel'] = panel,
            ['divider'] = divider
        }
    end
    
    settingsPanel.PerformLayout = function(s, w, h)
        for x,y in ipairs(panels) do
            y.panel:Dock(TOP)
            y.panel:UseReccomendedHeight()

            if(y.divider != nil) then
                y.divider:Dock(TOP)
                y.divider:SetHeight(2)
            end
        end
    end

    master.Paint = function(self, w, h) end
    master.PerformLayout = function(self, w, h)
        scrollContainer:Dock(FILL)
        scrollContainer:DockMargin(10, 10, 10, 10)

        settingsPanel:Dock(FILL)
        settingsPanel:DockMargin(0, 0, 0, 0)
    end
    
    master:InvalidateLayout()
end