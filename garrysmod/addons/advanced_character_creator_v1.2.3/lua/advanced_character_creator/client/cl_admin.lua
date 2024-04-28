--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

ACC2 = ACC2 or {}
ACC2.Categories = ACC2.Categories or {}
ACC2.Factions = ACC2.Factions or {}

local settingsMenu, adminMenu, configureFactionModel, factionMenu, categoryMenu

function ACC2.SaveConfigSettings()
    ACC2.AdvancedConfiguration = ACC2.AdvancedConfiguration or {}
    ACC2.AdvancedConfiguration["settings"] = ACC2.AdvancedConfiguration["settings"] or {}
        
    net.Start("ACC2:Admin:Configuration")
        net.WriteUInt(1, 4)
        net.WriteUInt(table.Count(ACC2.AdvancedConfiguration["settings"]), 12)
        for k, v in pairs(ACC2.AdvancedConfiguration["settings"]) do
            local valueType = type(v)

            net.WriteString(valueType)
            net.WriteString(k)
            net["Write"..ACC2.TypeNet[valueType]](v, ((ACC2.TypeNet[valueType] == "Int") and 32))
        end
    net.SendToServer()
end

function ACC2.Settings()
    if IsValid(settingsMenu) then settingsMenu:Remove() end

    ACC2.AdvancedConfiguration["settings"] = {}

    settingsMenu = vgui.Create("DFrame")
    settingsMenu:SetSize(ACC2.ScrW*0.55, ACC2.ScrH*0.695)
    settingsMenu:SetDraggable(false)
    settingsMenu:MakePopup()
    settingsMenu:SetTitle("")
    settingsMenu:ShowCloseButton(false)
    settingsMenu:Center()
    settingsMenu.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.9998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-self:GetWide()*0.978/2, h*0.02, self:GetWide()*0.978, ACC2.ScrH*0.062)

        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminSettingsDescription"), "ACC2:Font:14", w*0.025, h*0.06, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    local scrollConfig = vgui.Create("ACC2:DScroll", settingsMenu)
    scrollConfig:SetSize(settingsMenu:GetWide()*0.977, ACC2.ScrH*0.55)
    scrollConfig:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.083)
    scrollConfig:DockMargin(0, 0, 0, ACC2.ScrH*0.006)

    if ACC2.ParametersConfig && ACC2.ParametersConfig["transfertSettings"] && #ACC2.ParametersConfig["transfertSettings"] > 0 then
        local transfertSettings = vgui.Create("ACC2:Accordion", scrollConfig)
        transfertSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
        transfertSettings:Dock(TOP)
        transfertSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
        transfertSettings:SetText("transfertSettings")
        transfertSettings:InitializeCategory("transfertSettings", nil, false, nil)
    end

    if ACC2.ParametersConfig && ACC2.ParametersConfig["compatibilitiesList"] && #ACC2.ParametersConfig["compatibilitiesList"] > 0 then
        local compatibilitiesList = vgui.Create("ACC2:Accordion", scrollConfig)
        compatibilitiesList:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
        compatibilitiesList:Dock(TOP)
        compatibilitiesList:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
        compatibilitiesList:SetText("compatibilitiesList")
        compatibilitiesList:InitializeCategory("compatibilitiesList", nil, false, nil)
    end

    local generalSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    generalSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    generalSettings:Dock(TOP)
    generalSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    generalSettings:SetText("generalSettings")
    generalSettings:InitializeCategory("generalSettings", nil, false, nil)

    local menuSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    menuSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    menuSettings:Dock(TOP)
    menuSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    menuSettings:SetText("menuSettings")
    menuSettings:InitializeCategory("menuSettings", nil, false, nil)

    local keySettings = vgui.Create("ACC2:Accordion", scrollConfig)
    keySettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    keySettings:Dock(TOP)
    keySettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    keySettings:SetText("keySettings")
    keySettings:InitializeCategory("keySettings", nil, false, nil)

    local npcSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    npcSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    npcSettings:Dock(TOP)
    npcSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    npcSettings:SetText("npcSettings")
    npcSettings:InitializeCategory("npcSettings", nil, false, nil)

    local groupModelsSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    groupModelsSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    groupModelsSettings:Dock(TOP)
    groupModelsSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    groupModelsSettings:SetText("groupModelsSettings")
    groupModelsSettings:InitializeCategory("groupModelsSettings", nil, false, nil)

    local loadSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    loadSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    loadSettings:Dock(TOP)
    loadSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    loadSettings:SetText("loadSettings")
    loadSettings:InitializeCategory("loadSettings", nil, false, nil)

    local characterSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    characterSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    characterSettings:Dock(TOP)
    characterSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    characterSettings:SetText("characterSettings")
    characterSettings:InitializeCategory("characterSettings", nil, false, nil)

    local musicSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    musicSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    musicSettings:Dock(TOP)
    musicSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    musicSettings:SetText("soundSettings")
    musicSettings:InitializeCategory("soundSettings", nil, false, nil)

    local buttonsSettings = vgui.Create("ACC2:Accordion", scrollConfig)
    buttonsSettings:SetSize(ACC2.ScrW*0.538, ACC2.ScrH*0.03)
    buttonsSettings:Dock(TOP)
    buttonsSettings:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    buttonsSettings:SetText("buttonsSettings")
    buttonsSettings:InitializeCategory("buttonsSettings", nil, false, nil)

    local saveSettings = vgui.Create("ACC2:SlideButton", settingsMenu)
    saveSettings:SetSize(settingsMenu:GetWide()*0.9785, ACC2.ScrH*0.041)
    saveSettings:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.6425)
    saveSettings:SetFont("ACC2:Font:15")
    saveSettings:SetTextColor(ACC2.Colors["white"])
    saveSettings:InclineButton(0)
    saveSettings.MinMaxLerp = {50, 200}
    saveSettings:SetIconMaterial(nil)
    saveSettings:SetText(ACC2.GetSentence("saveSettings"))
    saveSettings:SetButtonColor(ACC2.Colors["purple"])
    saveSettings.DoClick = function()
        ACC2.AdvancedConfiguration["settings"] = ACC2.AdvancedConfiguration["settings"] or {}
        
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(1, 4)
            net.WriteUInt(table.Count(ACC2.AdvancedConfiguration["settings"]), 12)
            for k,v in pairs(ACC2.AdvancedConfiguration["settings"]) do
                local valueType = type(v)
    
                net.WriteString(valueType)
                net.WriteString(k)
                net["Write"..ACC2.TypeNet[valueType]](v, ((ACC2.TypeNet[valueType] == "Int") and 32))
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", settingsMenu)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(settingsMenu:GetWide()*0.945, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        settingsMenu:Remove()
    end
end

function ACC2.CreateButtons()
    local buttons = {
        {
            ["name"] = "close",
            ["mat"] = ACC2.Materials["icon_close"],
            ["func"] = function(panel, modifyCharacter, button)
                if not IsValid(panel) then return end

                local hasCharacter = ACC2.GetNWVariables("characterId", ACC2.LocalPlayer)
                
                if hasCharacter then
                    panel:Remove()
                    
                    if IsValid(ACC2.Sound) then
                        ACC2.Sound:Stop()
                    end
                elseif not hasCharacter then
                    ACC2.ConfirmLeave = ACC2.ConfirmLeave or false

                    if not ACC2.ConfirmLeave then
                        button:SetIconMaterial(ACC2.Materials["valid"])
                        
                        ACC2.Notification(2, ACC2.GetSentence("areYouSureToLeave"))

                        ACC2.ConfirmLeave = true
                        timer.Simple(2, function()
                            if IsValid(button) then
                                button:SetIconMaterial(ACC2.Materials["icon_close"])
                            end

                            ACC2.ConfirmLeave = false
                        end)
                    else
                        RunConsoleCommand("disconnect")
                    end
                end
            end,
        },
    }

    local serverIP = string.Replace(game.GetIPAddress(), ".", "")
    serverIP = string.Replace(serverIP, ":", "")
    
    for i=1, 4 do
        if not ACC2.GetSetting("buttonsEnable"..i, "boolean") then continue end
        ACC2.CacheMaterial(ACC2.GetSetting("buttonsImage"..i, "string"), "buttonsImage"..i)

        buttons[#buttons + 1] = {
            ["name"] = "buttons"..i,
            ["mat"] = "../data/acc2_image_cache/"..serverIP.."/buttonsImage"..i..".png",
            ["func"] = function(panel, modifyCharacter)
                gui.OpenURL(ACC2.GetSetting("buttonsLinks"..i, "string"))
            end,
        }
    end

    return buttons
end

local scrollJobConfig
local function reloadCategory(tableToConfig)
    if not IsValid(scrollJobConfig) then return end
    scrollJobConfig:Clear()
    
    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        local jobButton = vgui.Create("DButton", scrollJobConfig)
        jobButton:SetSize(0, ACC2.ScrH*0.037)
        jobButton:Dock(TOP)
        jobButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        jobButton:SetText("")
        jobButton.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)
        end
        
        local jobName = vgui.Create("DLabel", jobButton)
        jobName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.037)
        jobName:SetPos(ACC2.ScrW*0.008, 0)
        jobName:SetText(team.GetName(k))
        jobName:SetTextColor(ACC2.Colors["white100"])
        jobName:SetFont("ACC2:Font:09")

        local checkBox = vgui.Create("ACC2:CheckBox", jobButton)
        checkBox:SetSize(ACC2.ScrH*0.023, ACC2.ScrH*0.023)
        checkBox:SetPos(ACC2.ScrW*0.268, jobButton:GetTall()/2 - checkBox:GetTall()/2)

        if tableToConfig then
            local activate = tableToConfig[v.Name]
            
            if activate then
                checkBox:SetActive(activate)
                tableToConfig[v.Name] = activate
            end
        end

        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            tableToConfig[v.Name] = (active and true or nil)
        end

        jobButton.DoClick = function()
            local active = checkBox:GetActive()

            checkBox:SetActive(!active)
            tableToConfig[v.Name] = (!active and true or nil)
        end
    end
end

function ACC2.JobConfig(tableToConfig)
    if IsValid(ACC2JobConfig) then ACC2JobConfig:Remove() end

    ACC2JobConfig = vgui.Create("DFrame")
    ACC2JobConfig:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.533)
    ACC2JobConfig:Center()
    ACC2JobConfig:SetTitle("")
    ACC2JobConfig:ShowCloseButton(false)
    ACC2JobConfig:MakePopup()
    ACC2JobConfig.Paint = function(self, w, h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.9998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-self:GetWide()*0.97/2, h*0.02, self:GetWide()*0.97, ACC2.ScrH*0.062)

        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.035, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminSettingsJobs"), "ACC2:Font:14", w*0.035, h*0.08, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    scrollJobConfig = vgui.Create("ACC2:DScroll", ACC2JobConfig)
    scrollJobConfig:SetSize(ACC2JobConfig:GetWide()*0.968, ACC2.ScrH*0.4)
    scrollJobConfig:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.078)

    reloadCategory(tableToConfig)

    local saveJob = vgui.Create("ACC2:SlideButton", ACC2JobConfig)
    saveJob:SetSize(ACC2JobConfig:GetWide()/1.035, ACC2.ScrH*0.041)
    saveJob:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.483)
    saveJob:SetText(ACC2.GetSentence("saveJob"))
    saveJob:SetFont("ACC2:Font:15")
    saveJob:SetTextColor(ACC2.Colors["white"])
    saveJob:InclineButton(0)
    saveJob.MinMaxLerp = {100, 200}
    saveJob:SetIconMaterial(nil)
    saveJob:SetButtonColor(ACC2.Colors["purple"])
    saveJob.DoClick = function()
        if IsValid(ACC2JobConfig) then ACC2JobConfig:Remove() end
        ACC2.SaveConfigSettings()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", ACC2JobConfig)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(ACC2JobConfig:GetWide()*0.915, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        ACC2JobConfig:Remove()
    end
end

function ACC2.PrefixConfig()
    if IsValid(ACC2PrefixJob) then ACC2PrefixJob:Remove() end

    local prefixTable = ACC2.GetSetting("prefixTable", "table")

    ACC2PrefixJob = vgui.Create("DFrame")
    ACC2PrefixJob:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.545)
    ACC2PrefixJob:Center()
    ACC2PrefixJob:SetTitle("")
    ACC2PrefixJob:ShowCloseButton(false)
    ACC2PrefixJob:MakePopup()
    ACC2PrefixJob.Paint = function(self, w, h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.9998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-self:GetWide()*0.97/2, h*0.02, self:GetWide()*0.97, ACC2.ScrH*0.062)

        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.035, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("descPrefix"), "ACC2:Font:14", w*0.035, h*0.075, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    scrollTableConfig = vgui.Create("ACC2:DScroll", ACC2PrefixJob)
    scrollTableConfig:SetSize(ACC2PrefixJob:GetWide()*0.968, ACC2.ScrH*0.405)
    scrollTableConfig:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.078)
    
    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end
                
        local jobButton = vgui.Create("DPanel", scrollTableConfig)
        jobButton:SetSize(0, ACC2.ScrH*0.03)
        jobButton:Dock(TOP)
        jobButton:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
        jobButton:SetText("")
        jobButton.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)
    
            local color = team.GetColor(k)
            color.a = 50
    
            surface.SetDrawColor(color)
            surface.DrawRect(0, 0, w*0.02, h)
        end

        local playerName = vgui.Create("DLabel", jobButton)
        playerName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
        playerName:SetPos(ACC2.ScrW*0.01, 0)
        playerName:SetText(v.Name)
        playerName:SetTextColor(ACC2.Colors["white100"])
        playerName:SetFont("ACC2:Font:17")

        local jobName = team.GetName(k)
        local placeHolder = "{name}-{N}{L}"

        local prefixEntry = vgui.Create("ACC2:TextEntry", jobButton)
        prefixEntry:SetSize(ACC2.ScrH*0.15, ACC2.ScrH*0.0235)
        prefixEntry:SetPos(ACC2.ScrW*0.2, ACC2.ScrH*0.0038)
        prefixEntry:SetPlaceHolder(placeHolder)
        prefixEntry.entry.OnChange = function(self)
            local value = string.Trim(self:GetText())
            local bool = (value == "" or value == placeHolder)

            ACC2.AdvancedConfiguration["settings"]["prefixTable"] = ACC2.AdvancedConfiguration["settings"]["prefixTable"] or {}

            if bool then
                ACC2.AdvancedConfiguration["settings"]["prefixTable"][jobName] = nil
            else
                ACC2.AdvancedConfiguration["settings"]["prefixTable"][jobName] = value
            end
        end

        if isstring(prefixTable[jobName]) then
            prefixEntry:SetText(prefixTable[jobName])
        end
    end

    local saveSettings = vgui.Create("ACC2:SlideButton", ACC2PrefixJob)
    saveSettings:SetSize(ACC2PrefixJob:GetWide()/1.035, ACC2.ScrH*0.041)
    saveSettings:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.493)
    saveSettings:SetText(ACC2.GetSentence("saveSettings"))
    saveSettings:SetFont("ACC2:Font:15")
    saveSettings:SetTextColor(ACC2.Colors["white"])
    saveSettings:InclineButton(0)
    saveSettings.MinMaxLerp = {100, 200}
    saveSettings:SetIconMaterial(nil)
    saveSettings:SetButtonColor(ACC2.Colors["purple"])
    saveSettings.DoClick = function()
        ACC2.SaveConfigSettings()
        ACC2PrefixJob:Remove()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", ACC2PrefixJob)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(ACC2PrefixJob:GetWide()*0.915, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        ACC2.AdvancedConfiguration["settings"]["prefixTable"] = {}
        ACC2PrefixJob:Remove()
    end
end

local scrollTableConfig
local function reloadTableConfig(tableToConfig, valueOnKey)
    if not IsValid(scrollTableConfig) then return end
    scrollTableConfig:Clear()
    
    for k, v in pairs(tableToConfig) do
        local valueButton = vgui.Create("DButton", scrollTableConfig)
        valueButton:SetSize(0, ACC2.ScrH*0.037)
        valueButton:Dock(TOP)
        valueButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        valueButton:SetText("")
        valueButton.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)
        end

        local name = (valueOnKey and k or v)
        
        local value = vgui.Create("DLabel", valueButton)
        value:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.037)
        value:SetPos(ACC2.ScrW*0.008, 0)
        value:SetText(isstring(name) and name or "Error")
        value:SetTextColor(ACC2.Colors["white100"])
        value:SetFont("ACC2:Font:09")

        local deleteLerp = 50
        local delete = vgui.Create("DButton", valueButton)
        delete:SetSize(ACC2.ScrH*0.02, ACC2.ScrH*0.02)
        delete:SetPos(ACC2.ScrW*0.269, valueButton:GetTall()/2 - delete:GetTall()/2)
        delete:SetText("")
        delete.Paint = function(self,w,h)
            deleteLerp = Lerp(FrameTime()*5, deleteLerp, (delete:IsHovered() and 50 or 100))
    
            surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], deleteLerp))
            surface.SetMaterial(ACC2.Materials["icon_delete"])
            surface.DrawTexturedRect(0, 0, w, h)
        end
        delete.DoClick = function()
            if valueOnKey then
                tableToConfig[k] = nil
                table.ClearKeys(tableToConfig)
            else
                table.remove(tableToConfig, k)
            end

            reloadTableConfig(tableToConfig, valueOnKey)
        end
    end
end

function ACC2.AddOnTableConfig(tableToConfig, valueOnKey)
    tableToConfig = tableToConfig or {}
    if IsValid(ACC2JobConfig) then ACC2JobConfig:Remove() end

    ACC2JobConfig = vgui.Create("DFrame")
    ACC2JobConfig:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.545)
    ACC2JobConfig:Center()
    ACC2JobConfig:SetTitle("")
    ACC2JobConfig:ShowCloseButton(false)
    ACC2JobConfig:MakePopup()
    ACC2JobConfig.Paint = function(self, w, h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.9998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-self:GetWide()*0.97/2, h*0.02, self:GetWide()*0.97, ACC2.ScrH*0.062)

        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.035, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("descAddValue"), "ACC2:Font:14", w*0.035, h*0.08, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    scrollTableConfig = vgui.Create("ACC2:DScroll", ACC2JobConfig)
    scrollTableConfig:SetSize(ACC2JobConfig:GetWide()*0.968, ACC2.ScrH*0.36)
    scrollTableConfig:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.078)

    reloadTableConfig(tableToConfig, valueOnKey)

    local textEntry = vgui.Create("ACC2:TextEntry", ACC2JobConfig)
    textEntry:SetSize(ACC2JobConfig:GetWide()/1.035, ACC2.ScrH*0.041)
    textEntry:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.447)
    textEntry:SetPlaceHolder(ACC2.GetSentence("insertValue"))

    local addValue = vgui.Create("ACC2:SlideButton", ACC2JobConfig)
    addValue:SetSize(ACC2JobConfig:GetWide()/1.035, ACC2.ScrH*0.041)
    addValue:SetPos(ACC2.ScrW*0.0055, ACC2.ScrH*0.493)
    addValue:SetText(ACC2.GetSentence("addValue"))
    addValue:SetFont("ACC2:Font:15")
    addValue:SetTextColor(ACC2.Colors["white"])
    addValue:InclineButton(0)
    addValue.MinMaxLerp = {100, 200}
    addValue:SetIconMaterial(nil)
    addValue:SetButtonColor(ACC2.Colors["purple"])
    addValue.DoClick = function()
        if valueOnKey then
            tableToConfig[textEntry:GetText()] = true
        else
            tableToConfig[#tableToConfig + 1] = textEntry:GetText()
        end
        reloadTableConfig(tableToConfig, valueOnKey)
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", ACC2JobConfig)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(ACC2JobConfig:GetWide()*0.915, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        ACC2JobConfig:Remove()
        ACC2.SaveConfigSettings()
    end
end

local scrollCategory, scrollFactions
local function reloadCategory()
    if not IsValid(scrollCategory) then return end
    scrollCategory:Clear()
    
    for k, v in pairs(ACC2.Categories) do
        local categoryButton = vgui.Create("DButton", scrollCategory)
        categoryButton:SetSize(0, ACC2.ScrH*0.037)
        categoryButton:Dock(TOP)
        categoryButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        categoryButton:SetText("")
        categoryButton.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)
        end
        
        local groupName = vgui.Create("DLabel", categoryButton)
        groupName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.037)
        groupName:SetPos(ACC2.ScrW*0.008, 0)
        groupName:SetText(("(%s) "..v.name or "nil"):format(v.categoryUniqueId))
        groupName:SetTextColor(ACC2.Colors["white100"])
        groupName:SetFont("ACC2:Font:09")

        local editButton = vgui.Create("ACC2:SlideButton", categoryButton)
        editButton:SetSize(ACC2.ScrH*0.032, ACC2.ScrH*0.032)
        editButton:SetPos(ACC2.ScrW*0.2053, ACC2.ScrH*0.0033)
        editButton:SetText("")
        editButton.MinMaxLerp = {5, 7}
        editButton:SetIconMaterial(nil)
        editButton:SetButtonColor(ACC2.Colors["white5"])
        editButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white100"])
            surface.SetMaterial(ACC2.Materials["icon_edit"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        editButton.DoClick = function()
            if IsValid(adminMenu) then adminMenu:Remove() end
            ACC2.CreateCategory(v)
        end

        local removeButton = vgui.Create("ACC2:SlideButton", categoryButton)
        removeButton:SetSize(ACC2.ScrH*0.032, ACC2.ScrH*0.032)
        removeButton:SetPos(ACC2.ScrW*0.2253, ACC2.ScrH*0.0033)
        removeButton:SetText("")
        removeButton.MinMaxLerp = {60, 120}
        removeButton:SetIconMaterial(nil)
        removeButton:SetButtonColor(ACC2.Colors["purple120"])
        removeButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white100"])
            surface.SetMaterial(ACC2.Materials["icon_delete"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        removeButton.DoClick = function()
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(5, 4)
                net.WriteUInt(k, 16)
            net.SendToServer()
        end
    end
end

local function reloadFactions()
    if not IsValid(scrollFactions) then return end
    scrollFactions:Clear()
    
    for k, v in pairs(ACC2.Factions) do
        local factionButton = vgui.Create("DButton", scrollFactions)
        factionButton:SetSize(0, ACC2.ScrH*0.037)
        factionButton:Dock(TOP)
        factionButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        factionButton:SetText("")
        factionButton.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)
        end

        local categories = ACC2.Categories[v.groupId] or {}
        local name = categories["name"] or ACC2.GetSentence("noCategory")
        
        local groupName = vgui.Create("DLabel", factionButton)
        groupName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.037)
        groupName:SetPos(ACC2.ScrW*0.008, 0)
        groupName:SetText(("[%s] (%s) "..v.name or "nil"):format(name, v.factionUniqueId))
        groupName:SetTextColor(ACC2.Colors["white100"])
        groupName:SetFont("ACC2:Font:09")

        local editButton = vgui.Create("ACC2:SlideButton", factionButton)
        editButton:SetSize(ACC2.ScrH*0.032, ACC2.ScrH*0.032)
        editButton:SetPos(ACC2.ScrW*0.2053, ACC2.ScrH*0.0033)
        editButton:SetText("")
        editButton.MinMaxLerp = {5, 7}
        editButton:SetIconMaterial(nil)
        editButton:SetButtonColor(ACC2.Colors["white5"])
        editButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white100"])
            surface.SetMaterial(ACC2.Materials["icon_edit"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        editButton.DoClick = function()
            if IsValid(adminMenu) then adminMenu:Remove() end
            ACC2.CreateFaction(v)
        end

        local removeButton = vgui.Create("ACC2:SlideButton", factionButton)
        removeButton:SetSize(ACC2.ScrH*0.032, ACC2.ScrH*0.032)
        removeButton:SetPos(ACC2.ScrW*0.2253, ACC2.ScrH*0.0033)
        removeButton:SetText("")
        removeButton.MinMaxLerp = {60, 120}
        removeButton:SetIconMaterial(nil)
        removeButton:SetButtonColor(ACC2.Colors["purple120"])
        removeButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white100"])
            surface.SetMaterial(ACC2.Materials["icon_delete"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        removeButton.DoClick = function()
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(3, 4)
                net.WriteUInt(k, 16)
            net.SendToServer()
        end
    end
end

function ACC2.AdminMenuFaction()
    if IsValid(settingsMenu) then settingsMenu:Remove() end
    if IsValid(adminMenu) then adminMenu:Remove() end
    if IsValid(factionMenu) then factionMenu:Remove() end
    if IsValid(categoryMenu) then categoryMenu:Remove() end

    adminMenu = vgui.Create("DFrame")
    adminMenu:SetSize(ACC2.ScrW*0.503, ACC2.ScrH*0.603)
    adminMenu:SetDraggable(false)
    adminMenu:MakePopup()
    adminMenu:SetTitle("")
    adminMenu:ShowCloseButton(false)
    adminMenu:Center()
    adminMenu.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10)

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.9998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.02, ACC2.ScrW*0.49, ACC2.ScrH*0.062)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.13, ACC2.ScrW*0.243, ACC2.ScrH*0.045)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(ACC2.ScrW*0.2515, h*0.13, ACC2.ScrW*0.245, ACC2.ScrH*0.045)
        
        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminSettingsFactionsAndCategories"), "ACC2:Font:14", w*0.025, h*0.07, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(ACC2.GetSentence("category"), "ACC2:Font:17", w*0.25, h*0.145, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("factions"), "ACC2:Font:17", w*0.75, h*0.145, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
    end

    scrollCategory = vgui.Create("ACC2:DScroll", adminMenu)
    scrollCategory:SetSize(adminMenu:GetWide()/2.07, ACC2.ScrH*0.417)
    scrollCategory:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.1285)

    reloadCategory()

    scrollFactions = vgui.Create("ACC2:DScroll", adminMenu)
    scrollFactions:SetSize(adminMenu:GetWide()/2.055, ACC2.ScrH*0.417)
    scrollFactions:SetPos(adminMenu:GetWide()/2, ACC2.ScrH*0.1285)

    reloadFactions()

    local createCategory = vgui.Create("ACC2:SlideButton", adminMenu)
    createCategory:SetSize(adminMenu:GetWide()/2.072, ACC2.ScrH*0.041)
    createCategory:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.552)
    createCategory:SetText(ACC2.GetSentence("createCategory"))
    createCategory:SetFont("ACC2:Font:15")
    createCategory:SetTextColor(ACC2.Colors["white"])
    createCategory:InclineButton(0)
    createCategory:SetIconMaterial(nil)
    createCategory.MinMaxLerp = {100, 200}
    createCategory:SetIconMaterial(nil)
    createCategory:SetButtonColor(ACC2.Colors["purple"])
    createCategory.DoClick = function()
        ACC2.CreateCategory()
        if IsValid(adminMenu) then adminMenu:Remove() end
    end

    local createFaction = vgui.Create("ACC2:SlideButton", adminMenu)
    createFaction:SetSize(adminMenu:GetWide()/2.055, ACC2.ScrH*0.041)
    createFaction:SetPos(adminMenu:GetWide()/2, ACC2.ScrH*0.552)
    createFaction:SetText(ACC2.GetSentence("createFaction"))
    createFaction:SetFont("ACC2:Font:15")
    createFaction:SetTextColor(ACC2.Colors["white"])
    createFaction:InclineButton(0)
    createFaction.MinMaxLerp = {100, 200}
    createFaction:SetIconMaterial(nil)
    createFaction:SetButtonColor(ACC2.Colors["purple"])
    createFaction.DoClick = function()
        ACC2.CreateFaction()
        if IsValid(adminMenu) then adminMenu:Remove() end
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", adminMenu)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(adminMenu:GetWide()*0.94, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        adminMenu:Remove()
    end
end

function ACC2.CreateFaction(editTable)
    if IsValid(factionMenu) then factionMenu:Remove() end

    ACC2.FactionTable = {
        ["name"] = "",
        ["logo"] = "",
        ["description"] = "",
        ["ranksAccess"] = {},
        ["jobsAccess"] = {},
        ["groupId"] = 0,
        ["models"] = {},
    }

    factionMenu = vgui.Create("DFrame")
    factionMenu:SetSize(ACC2.ScrW*0.503, ACC2.ScrH*0.66)
    factionMenu:SetDraggable(false)
    factionMenu:MakePopup()
    factionMenu:SetTitle("")
    factionMenu:ShowCloseButton(false)
    factionMenu:Center()
    factionMenu.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10)

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.9998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.02, self:GetWide()*0.9758, ACC2.ScrH*0.061)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.347, ACC2.ScrW*0.243, ACC2.ScrH*0.045)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(ACC2.ScrW*0.2515, h*0.347, ACC2.ScrW*0.245, ACC2.ScrH*0.045)
        
        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminFactionDescription"), "ACC2:Font:14", w*0.025, h*0.066, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(ACC2.GetSentence("ranksAccess"), "ACC2:Font:17", w*0.25, h*0.362, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("jobsAccess"), "ACC2:Font:17", w*0.75, h*0.362, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
    end

    local entryName = vgui.Create("ACC2:TextEntry", factionMenu)
    entryName:SetSize(factionMenu:GetWide()/2-ACC2.ScrW*0.0082, ACC2.ScrH*0.046)
    entryName:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.0785)
    entryName:SetPlaceHolder(ACC2.GetSentence("enterName"))
    entryName.entry.OnChange = function()
        ACC2.FactionTable["name"] = entryName:GetText()
    end
    if editTable && isstring(editTable["name"]) then
        entryName:SetText(editTable["name"])
        ACC2.FactionTable["name"] = editTable["name"]
    end

    local entryLogo = vgui.Create("ACC2:TextEntry", factionMenu)
    entryLogo:SetSize(factionMenu:GetWide()/2-ACC2.ScrW*0.0062, ACC2.ScrH*0.046)
    entryLogo:SetPos(factionMenu:GetWide()/2, ACC2.ScrH*0.0785)
    entryLogo:SetPlaceHolder(ACC2.GetSentence("enterMaterials"))
    entryLogo.entry.OnChange = function()
        ACC2.FactionTable["logo"] = entryLogo:GetText()
    end
    if editTable && isstring(editTable["logo"]) then
        entryLogo:SetText(editTable["logo"])
        ACC2.FactionTable["logo"] = editTable["logo"]
    end
    
    local category = vgui.Create("ACC2:DComboBox", factionMenu)
    category:SetSize(factionMenu:GetWide()/2-ACC2.ScrW*0.0082, ACC2.ScrH*0.046)
    category:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.128)
    category:SetText("Category")
    category:AddChoice(ACC2.GetSentence("noneGroup"), {["categoryUniqueId"] = 0})

    for k, v in pairs(ACC2.Categories) do
        category:AddChoice(v.name, v)
        
        if editTable && isnumber(editTable["groupId"]) then
            if v.categoryUniqueId == editTable["groupId"] then
                category:ChooseOption(v.name, k)
                ACC2.FactionTable["groupId"] = editTable["groupId"]
            elseif editTable["groupId"] == 0 then
                ACC2.FactionTable["groupId"] = 0
            end
        else
            ACC2.FactionTable["groupId"] = 0
        end
    end
    category.OnSelect = function(self, index, text, data)
        ACC2.FactionTable["groupId"] = data["categoryUniqueId"]
    end
    
    local selectModels = vgui.Create("DButton", factionMenu)
    selectModels:SetSize(factionMenu:GetWide()/2-ACC2.ScrW*0.0058, ACC2.ScrH*0.046)
    selectModels:SetPos(factionMenu:GetWide()/2, ACC2.ScrH*0.178)
    selectModels:SetText("")
    selectModels.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)

        draw.DrawText(ACC2.GetSentence("configureModels"):format(table.Count(ACC2.FactionTable["models"])), "ACC2:Font:18", ACC2.ScrW*0.006, h*0.2, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end
    selectModels.DoClick = function()
        ACC2.AddOnTableConfig(ACC2.FactionTable["models"], true)
    end
    if editTable && istable(editTable["models"]) then
        ACC2.FactionTable["models"] = editTable["models"]
    end

    local defaultJob = vgui.Create("ACC2:DComboBox", factionMenu)
    defaultJob:SetSize(factionMenu:GetWide()/2-ACC2.ScrW*0.0058, ACC2.ScrH*0.046)
    defaultJob:SetPos(factionMenu:GetWide()/2, ACC2.ScrH*0.128)
    defaultJob:SetText(ACC2.GetSentence("defaultFactionJob"))
    defaultJob:AddChoice(ACC2.GetSentence("noneGroup"), "")

    ACC2.FactionTable["defaultJob"] = ""

    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        local name = team.GetName(k)
        defaultJob:AddChoice(name, name)

        if editTable && isstring(editTable["defaultJob"]) then
            if name == editTable["defaultJob"] then
                defaultJob:ChooseOption(name, name)
                ACC2.FactionTable["defaultJob"] = name
            elseif not isstring(editTable["defaultJob"]) or editTable["defaultJob"] == "" then
                ACC2.FactionTable["defaultJob"] = ""
            end
        else
            ACC2.FactionTable["defaultJob"] = ""
        end
    end

    defaultJob.OnSelect = function(self, index, text, data)
        ACC2.FactionTable["defaultJob"] = data
    end

    local entryDescription = vgui.Create("ACC2:TextEntry", factionMenu)
    entryDescription:SetSize(factionMenu:GetWide()/2-ACC2.ScrW*0.0082, ACC2.ScrH*0.046)
    entryDescription:SetPos(ACC2.ScrW*0.006, ACC2.ScrH*0.178)
    entryDescription:SetPlaceHolder(ACC2.GetSentence("description"))
    entryDescription.entry.OnChange = function()
        ACC2.FactionTable["description"] = entryDescription:GetText()
    end
    if editTable && isstring(editTable["description"]) then
        entryDescription:SetText(editTable["description"])
        ACC2.FactionTable["description"] = editTable["description"]
    end

    local scrollRanks = vgui.Create("ACC2:DScroll", factionMenu)
    scrollRanks:SetSize(factionMenu:GetWide()/2.07, ACC2.ScrH*0.322)
    scrollRanks:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.2797)

    local userTable = CAMI and CAMI.GetUsergroups() or {}
    for k, v in pairs(userTable) do
        local rankButton = vgui.Create("DButton", scrollRanks)
        rankButton:SetSize(0, ACC2.ScrH*0.037)
        rankButton:Dock(TOP)
        rankButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        rankButton:SetText("")
        rankButton.Paint = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(v.Name, "ACC2:Font:09", w*0.035, h*0.5, ACC2.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local checkBox = vgui.Create("ACC2:CheckBox", rankButton)
        checkBox:SetSize(ACC2.ScrH*0.023, ACC2.ScrH*0.023)
        checkBox:SetPos(ACC2.ScrW*0.222, rankButton:GetTall()/2 - checkBox:GetTall()/2)

        if editTable && istable(editTable["ranksAccess"]) then
            local activate = editTable["ranksAccess"][v.Name]
            
            if activate then
                checkBox:SetActive(activate)

                ACC2.FactionTable["ranksAccess"][v.Name] = activate
            end
        end
        
        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            ACC2.FactionTable["ranksAccess"][v.Name] = active and true or nil
        end

        rankButton.DoClick = function()
            local active = checkBox:GetActive()

            checkBox:SetActive(!active)
            ACC2.FactionTable["ranksAccess"][v.Name] = !active and true or nil
        end
    end

    local scrollJobs = vgui.Create("ACC2:DScroll", factionMenu)
    scrollJobs:SetSize(factionMenu:GetWide()/2.053, ACC2.ScrH*0.322)
    scrollJobs:SetPos(factionMenu:GetWide()/2, ACC2.ScrH*0.2797)

    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        local jobButton = vgui.Create("DButton", scrollJobs)
        jobButton:SetSize(0, ACC2.ScrH*0.037)
        jobButton:Dock(TOP)
        jobButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        jobButton:SetText("")
        jobButton.Paint = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(v.Name, "ACC2:Font:09", w*0.035, h*0.5, ACC2.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local checkBox = vgui.Create("ACC2:CheckBox", jobButton)
        checkBox:SetSize(ACC2.ScrH*0.023, ACC2.ScrH*0.023)
        checkBox:SetPos(ACC2.ScrW*0.225, jobButton:GetTall()/2 - checkBox:GetTall()/2)

        if editTable && istable(editTable["jobsAccess"]) then
            local activate = editTable["jobsAccess"][v.Name]

            if activate then
                checkBox:SetActive(activate)

                ACC2.FactionTable["jobsAccess"][v.Name] = activate
            end
        end

        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            ACC2.FactionTable["jobsAccess"][v.Name] = active and true or nil
        end

        jobButton.DoClick = function()
            local active = checkBox:GetActive()

            checkBox:SetActive(!active)
            ACC2.FactionTable["jobsAccess"][v.Name] = !active and true or nil
        end
    end

    local cancel = vgui.Create("ACC2:SlideButton", factionMenu)
    cancel:SetSize(factionMenu:GetWide()/2.072, ACC2.ScrH*0.041)
    cancel:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.608)
    cancel:SetText(ACC2.GetSentence("cancel"))
    cancel:SetFont("ACC2:Font:15")
    cancel:SetTextColor(ACC2.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(ACC2.Colors["grey69"])
    cancel.DoClick = function()
        if IsValid(factionMenu) then factionMenu:Remove() end
        ACC2.AdminMenuFaction()
    end

    local createFaction = vgui.Create("ACC2:SlideButton", factionMenu)
    createFaction:SetSize(factionMenu:GetWide()/2.055, ACC2.ScrH*0.041)
    createFaction:SetPos(factionMenu:GetWide()/2, ACC2.ScrH*0.608)
    createFaction:SetText(ACC2.GetSentence((istable(editTable) and "updateFaction" or "validatecreateFaction")))
    createFaction:SetFont("ACC2:Font:15")
    createFaction:SetTextColor(ACC2.Colors["white"])
    createFaction:InclineButton(0)
    createFaction.MinMaxLerp = {100, 200}
    createFaction:SetIconMaterial(nil)
    createFaction:SetButtonColor(ACC2.Colors["purple"])
    createFaction.DoClick = function()
        if not isstring(ACC2.FactionTable["name"]) or ACC2.FactionTable["name"] == "" then
            ACC2.Notification(5, ACC2.GetSentence("errorName"))
            return
        end

        if not isstring(ACC2.FactionTable["logo"]) or ACC2.FactionTable["logo"] == "" then
            ACC2.Notification(5, ACC2.GetSentence("errorLogo"))
            return
        end

        if not isstring(ACC2.FactionTable["description"]) or ACC2.FactionTable["description"] == "" then
            ACC2.Notification(5, ACC2.GetSentence("errorDescription"))
            return
        end

        local models = ACC2.FactionTable["models"] or {}
        local modelsCount = table.Count(models)

        if not istable(models) or modelsCount <= 0 then
            ACC2.Notification(5, ACC2.GetSentence("errorModels"))
            return
        end
        
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(2, 4)
            net.WriteBool(istable(editTable))
            net.WriteString(ACC2.FactionTable["name"])
            net.WriteString(ACC2.FactionTable["logo"])
            net.WriteString(ACC2.FactionTable["description"])
            net.WriteString(ACC2.FactionTable["defaultJob"])
            net.WriteUInt(ACC2.FactionTable["groupId"], 16)

            net.WriteUInt(modelsCount, 16)

            for model, _ in pairs(models) do
                net.WriteString(model)
            end

            local ranksAccess = ACC2.FactionTable["ranksAccess"] or {}
            net.WriteUInt(table.Count(ranksAccess), 16)

            for job, _ in pairs(ranksAccess) do
                net.WriteString(job)
            end

            local jobsAccess = ACC2.FactionTable["jobsAccess"] or {}
            net.WriteUInt(table.Count(jobsAccess), 16)

            for job, _ in pairs(jobsAccess) do
                net.WriteString(job)
            end

            if editTable && isnumber(editTable["factionUniqueId"]) then
                net.WriteUInt(editTable["factionUniqueId"], 16)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", factionMenu)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(factionMenu:GetWide()*0.94, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        factionMenu:Remove()
    end
end

function ACC2.CreateCategory(editTable)
    if IsValid(categoryMenu) then categoryMenu:Remove() end

    ACC2.CategoriesTable = {
        ["name"] = "",
        ["logo"] = "",
        ["description"] = "",
        ["ranksAccess"] = {},
    }
    
    categoryMenu = vgui.Create("DFrame")
    categoryMenu:SetSize(ACC2.ScrW*0.255, ACC2.ScrH*0.66)
    categoryMenu:SetDraggable(false)
    categoryMenu:MakePopup()
    categoryMenu:SetTitle("")
    categoryMenu:ShowCloseButton(false)
    categoryMenu:Center()
    categoryMenu.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10)

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.999, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w-ACC2.ScrW*0.497/2, h*0.02, ACC2.ScrW*0.242, ACC2.ScrH*0.061)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w-ACC2.ScrW*0.497/2, h*0.347, ACC2.ScrW*0.242, ACC2.ScrH*0.045)
        
        draw.DrawText(ACC2.GetSentence("adminSettingsTitle2"), "ACC2:Font:13", w*0.05, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminCategoryDescription"), "ACC2:Font:14", w*0.05, h*0.066, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(ACC2.GetSentence("ranksAccess"), "ACC2:Font:17", w*0.05, h*0.362, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
    end

    local entryName = vgui.Create("ACC2:TextEntry", categoryMenu)
    entryName:SetSize(categoryMenu:GetWide()-ACC2.ScrW*0.013, ACC2.ScrH*0.046)
    entryName:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.0785)
    entryName:SetPlaceHolder(ACC2.GetSentence("enterName"))
    entryName.entry.OnChange = function()
        ACC2.CategoriesTable["name"] = entryName:GetText()
    end
    if editTable && isstring(editTable["name"]) then
        entryName:SetText(editTable["name"])
        ACC2.CategoriesTable["name"] = editTable["name"]
    end

    local entryLogo = vgui.Create("ACC2:TextEntry", categoryMenu)
    entryLogo:SetSize(categoryMenu:GetWide()-ACC2.ScrW*0.013, ACC2.ScrH*0.046)
    entryLogo:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.128)
    entryLogo:SetPlaceHolder(ACC2.GetSentence("enterMaterials"))
    entryLogo.entry.OnChange = function()
        ACC2.CategoriesTable["logo"] = entryLogo:GetText()
    end
    if editTable && isstring(editTable["logo"]) then
        entryLogo:SetText(editTable["logo"])
        ACC2.CategoriesTable["logo"] = editTable["logo"]
    end

    local entryDescription = vgui.Create("ACC2:TextEntry", categoryMenu)
    entryDescription:SetSize(categoryMenu:GetWide()-ACC2.ScrW*0.013, ACC2.ScrH*0.046)
    entryDescription:SetPos(ACC2.ScrW*0.006, ACC2.ScrH*0.178)
    entryDescription:SetPlaceHolder(ACC2.GetSentence("description"))
    entryDescription.entry.OnChange = function()
        ACC2.CategoriesTable["description"] = entryDescription:GetText()
    end
    if editTable && isstring(editTable["description"]) then
        entryDescription:SetText(editTable["description"])
        ACC2.CategoriesTable["description"] = editTable["description"]
    end

    local scrollRanks = vgui.Create("ACC2:DScroll", categoryMenu)
    scrollRanks:SetSize(categoryMenu:GetWide()-ACC2.ScrW*0.013, ACC2.ScrH*0.322)
    scrollRanks:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.2795)

    local userTable = CAMI and CAMI.GetUsergroups() or {}
    for k, v in pairs(userTable) do
        local rankButton = vgui.Create("DButton", scrollRanks)
        rankButton:SetSize(0, ACC2.ScrH*0.037)
        rankButton:Dock(TOP)
        rankButton:DockMargin(0, 0, 0, ACC2.ScrH*0.005)
        rankButton:SetText("")
        rankButton.Paint = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(v.Name, "ACC2:Font:09", w*0.035, h*0.5, ACC2.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local checkBox = vgui.Create("ACC2:CheckBox", rankButton)
        checkBox:SetSize(ACC2.ScrH*0.023, ACC2.ScrH*0.023)
        checkBox:SetPos(ACC2.ScrW*0.222, rankButton:GetTall()/2 - checkBox:GetTall()/2)

        if editTable && istable(editTable["ranksAccess"]) then
            local activate = editTable["ranksAccess"][v.Name]
            
            if activate then
                checkBox:SetActive(activate)

                ACC2.CategoriesTable["ranksAccess"][v.Name] = activate
            end
        end
        
        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            ACC2.CategoriesTable["ranksAccess"][v.Name] = active and true or nil
        end

        rankButton.DoClick = function()
            local active = checkBox:GetActive()

            checkBox:SetActive(!active)
            ACC2.CategoriesTable["ranksAccess"][v.Name] = !active and true or nil
        end
    end

    local cancel = vgui.Create("ACC2:SlideButton", categoryMenu)
    cancel:SetSize(categoryMenu:GetWide()/1.055, ACC2.ScrH*0.037)
    cancel:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.568)
    cancel:SetText(ACC2.GetSentence("cancel"))
    cancel:SetFont("ACC2:Font:15")
    cancel:SetTextColor(ACC2.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(ACC2.Colors["grey69"])
    cancel.DoClick = function()
        if IsValid(categoryMenu) then categoryMenu:Remove() end
        ACC2.AdminMenuFaction()
    end

    local createCategory = vgui.Create("ACC2:SlideButton", categoryMenu)
    createCategory:SetSize(categoryMenu:GetWide()/1.055, ACC2.ScrH*0.037)
    createCategory:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.61)
    createCategory:SetText(ACC2.GetSentence((istable(editTable) and "validateupdateCategory" or "validatecreateCategory")))
    createCategory:SetFont("ACC2:Font:15")
    createCategory:SetTextColor(ACC2.Colors["white"])
    createCategory:InclineButton(0)
    createCategory.MinMaxLerp = {100, 200}
    createCategory:SetIconMaterial(nil)
    createCategory:SetButtonColor(ACC2.Colors["purple"])
    createCategory.DoClick = function()
        if not isstring(ACC2.CategoriesTable["name"]) or ACC2.CategoriesTable["name"] == "" then
            ACC2.Notification(5, ACC2.GetSentence("errorName"))
            return
        end

        if not isstring(ACC2.CategoriesTable["logo"]) or ACC2.CategoriesTable["logo"] == "" then
            ACC2.Notification(5, ACC2.GetSentence("errorLogo"))
            return
        end

        if not isstring(ACC2.CategoriesTable["description"]) or ACC2.CategoriesTable["description"] == "" then
            ACC2.Notification(5, ACC2.GetSentence("errorDescription"))
            return
        end

        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(4, 4)
            net.WriteBool(istable(editTable))
            net.WriteString(ACC2.CategoriesTable["name"])
            net.WriteString(ACC2.CategoriesTable["logo"])
            net.WriteString(ACC2.CategoriesTable["description"])

            local ranksAccess = ACC2.CategoriesTable["ranksAccess"] or {}
            net.WriteUInt(table.Count(ranksAccess), 16)

            for job, _ in pairs(ranksAccess) do
                net.WriteString(job)
            end
            if editTable && isnumber(editTable["categoryUniqueId"]) then
                net.WriteUInt(editTable["categoryUniqueId"], 16)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", categoryMenu)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(categoryMenu:GetWide()*0.9, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        categoryMenu:Remove()
    end
end

function ACC2.ConfigureModel(currentTable)
    if IsValid(configureFactionModel) then configureFactionModel:Remove() end
    if IsValid(factionMenu) then factionMenu:SetVisible(false) end

    currentTable = currentTable or {}

    configureFactionModel = vgui.Create("DFrame")
    configureFactionModel:SetSize(ACC2.ScrW*0.503, ACC2.ScrH*0.66)
    configureFactionModel:SetDraggable(false)
    configureFactionModel:MakePopup()
    configureFactionModel:SetTitle("")
    configureFactionModel:ShowCloseButton(false)
    configureFactionModel:Center()
    configureFactionModel.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10)

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.02, self:GetWide()*0.978, ACC2.ScrH*0.061)

        draw.DrawText(ACC2.GetSentence("adminSettingsTitle"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("selecteModels"), "ACC2:Font:14", w*0.025, h*0.066, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end
    configureFactionModel.OnRemove = function()
        if IsValid(factionMenu) then factionMenu:SetVisible(true) end
    end

    local modelPanelByModel = {}

    local scrollModels
    local placeHolder = ACC2.GetSentence("searchBarModel")

    local searchBar = vgui.Create("ACC2:TextEntry", configureFactionModel)
    searchBar:SetSize(configureFactionModel:GetWide()*0.978, ACC2.ScrH*0.046)
    searchBar:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.0785)
    searchBar:SetPlaceHolder(placeHolder)
    searchBar.entry.OnChange = function()
        for k, v in pairs(modelPanelByModel) do
            local value = searchBar.entry:GetValue()

            if (value != "" && value != nil) && not isnumber(string.find(k:lower(), value:lower())) then
                v:SetVisible(false)
            else
                v:SetVisible(true)
            end 

            scrollModels:InvalidateLayout()
            scrollModels:Rebuild()
        end
    end

    scrollModels = vgui.Create("ACC2:DScroll", configureFactionModel)
    scrollModels:SetSize(configureFactionModel:GetWide()*0.978, ACC2.ScrH*0.47)
    scrollModels:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.131)

    local modelList = vgui.Create("DIconLayout", scrollModels)
    modelList:Dock(FILL)
    modelList:SetSpaceY(ACC2.ScrW*0.004)
    modelList:SetSpaceX(ACC2.ScrW*0.004)

    local allModelsTable = player_manager.AllValidModels()
    local countPlayerModelTable = table.Count(allModelsTable)
    local getKeys = table.GetKeys(allModelsTable)

    timer.Create("acc2_load_all_models", 0.05, countPlayerModelTable, function()
        local modelString = allModelsTable[getKeys[(countPlayerModelTable-timer.RepsLeft("acc2_load_all_models"))]]
        
        if not isstring(modelString) then return end
        if not IsValid(searchBar.entry) then return end

        local value = searchBar.entry:GetValue()

        if (value != "" && value != nil) && not isnumber(string.find(modelString:lower(), value:lower())) then
            if IsValid(scrollModels) then
                scrollModels:PerformLayout()
            else
                timer.Remove("acc2_load_all_models")
                return 
            end

            local lerpColor = 0
            local modelPanel = vgui.Create("DPanel", modelList)
            modelPanel:SetSize(ACC2.ScrH*0.118, ACC2.ScrH*0.118)
            modelPanel.Paint = function(self, w, h)
                lerpColor = Lerp(FrameTime()*5, lerpColor, (currentTable[modelString] and 255 or 0))

                draw.RoundedBox(2, 0, 0, w, h, ACC2.Colors["white5"])
                draw.RoundedBox(2, 0, 0, w, h, ColorAlpha(ACC2.Colors["purple84"], lerpColor))
            end
            modelPanelByModel[modelString] = modelPanel

            local SpawnI = vgui.Create("SpawnIcon", modelPanel)
            SpawnI:Dock(FILL)
            SpawnI:SetModel(modelString)

            local selectButton = vgui.Create("DButton", modelPanel)
            selectButton:Dock(FILL)
            selectButton:SetText("")
            selectButton.Paint = function() end
            selectButton.DoClick = function()
                local newValue = !currentTable[modelString]
                currentTable[modelString] = (newValue and true or nil)
            end
        end
    end)

    local cancel = vgui.Create("ACC2:SlideButton", configureFactionModel)
    cancel:SetSize(configureFactionModel:GetWide()/2.072, ACC2.ScrH*0.041)
    cancel:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.608)
    cancel:SetText(ACC2.GetSentence("cancel"))
    cancel:SetFont("ACC2:Font:15")
    cancel:SetTextColor(ACC2.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(ACC2.Colors["grey69"])
    cancel.DoClick = function()        
        if IsValid(configureFactionModel) then configureFactionModel:Remove() end
    end

    local validateModels = vgui.Create("ACC2:SlideButton", configureFactionModel)
    validateModels:SetSize(configureFactionModel:GetWide()/2.055, ACC2.ScrH*0.041)
    validateModels:SetPos(configureFactionModel:GetWide()/2, ACC2.ScrH*0.608)
    validateModels:SetText(ACC2.GetSentence("validateModels"))
    validateModels:SetFont("ACC2:Font:15")
    validateModels:SetTextColor(ACC2.Colors["white"])
    validateModels:InclineButton(0)
    validateModels.MinMaxLerp = {100, 200}
    validateModels:SetIconMaterial(nil)
    validateModels:SetButtonColor(ACC2.Colors["purple"])
    validateModels.DoClick = function()
        if table.Count(currentTable) < 1 then
            ACC2.Notification(5, ACC2.GetSentence("errorModels"))
            return
        end
        if IsValid(configureFactionModel) then configureFactionModel:Remove() end
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", configureFactionModel)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(configureFactionModel:GetWide()*0.94, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        configureFactionModel:Remove()
    end
end

local playerList, searchSteamId
local function addPlayer(steamId, pnl)
    if not IsValid(pnl) then return end

    local ply = player.GetBySteamID64(steamId)
    
    local playerButton = vgui.Create("DButton", pnl)
    playerButton:SetSize(0, ACC2.ScrH*0.048)
    playerButton:Dock(TOP)
    playerButton:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    playerButton:SetText("")
    playerButton.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local playerAvatar = vgui.Create("ACC2:CircularAvatar", playerButton)
    playerAvatar:SetSize(ACC2.ScrH*0.04, ACC2.ScrH*0.04)
    playerAvatar:SetPos(ACC2.ScrW*0.0025, ACC2.ScrH*0.005)
    if IsValid(ply) then
        playerAvatar.ACC2Avatar:SetPlayer(ply, 64)
    end
    
    local playerName = vgui.Create("DLabel", playerButton)
    playerName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.028)
    playerName:SetPos(ACC2.ScrW*0.0305, 0)
    playerName:SetText((ply and ply:Name() or ACC2.GetSentence("disconnected")))
    playerName:SetTextColor(ACC2.Colors["white100"])
    playerName:SetFont("ACC2:Font:19")

    local playerId = vgui.Create("DLabel", playerButton)
    playerId:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.028)
    playerId:SetPos(ACC2.ScrW*0.0305, ACC2.ScrH*0.018)
    playerId:SetText((steamId or "71111111111111111"))
    playerId:SetTextColor(ACC2.Colors["white100"])
    playerId:SetFont("ACC2:Font:18")

    local editButton = vgui.Create("ACC2:SlideButton", playerButton)
    editButton:SetSize(ACC2.ScrH*0.04, ACC2.ScrH*0.04)
    editButton:SetPos(ACC2.ScrW*0.2185, ACC2.ScrH*0.004)
    editButton:SetText("")
    editButton.MinMaxLerp = {5, 7}
    editButton:SetIconMaterial(nil)
    editButton:SetButtonColor(ACC2.Colors["white5"])
    editButton.PaintOver = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.SetMaterial(ACC2.Materials["icon_edit"])
        surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
    end
    editButton.DoClick = function()
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(6, 4)
            net.WriteString(steamId)
        net.SendToServer()
    end
end

local function reloadPlayers(pnl)
    pnl:Clear()

    local playerList = table.Copy(player.GetAll())
    table.sort(playerList, function(a, b) return a:Nick():lower() < b:Nick():lower() end)

    for k,v in ipairs(playerList) do
        if v:IsBot() then continue end

        addPlayer(v:SteamID64(), pnl)
    end
end

function ACC2.ManagePlayers()
    if IsValid(settingsMenu) then settingsMenu:Remove() end
    if IsValid(managePlayer) then managePlayer:Remove() end

    managePlayer = vgui.Create("DFrame")
    managePlayer:SetSize(ACC2.ScrW*0.503, ACC2.ScrH*0.603)
    managePlayer:SetDraggable(false)
    managePlayer:MakePopup()
    managePlayer:SetTitle("")
    managePlayer:ShowCloseButton(false)
    managePlayer:Center()
    managePlayer.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.02, ACC2.ScrW*0.49, ACC2.ScrH*0.062)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.13, ACC2.ScrW*0.243, ACC2.ScrH*0.045)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(ACC2.ScrW*0.2515, h*0.13, ACC2.ScrW*0.245, ACC2.ScrH*0.045)
        
        draw.DrawText(ACC2.GetSentence("adminMenuPlayers"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminMenuPlayerDesc"), "ACC2:Font:14", w*0.025, h*0.07, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(ACC2.GetSentence("connectedPlayers"), "ACC2:Font:17", w*0.25, h*0.145, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("searchDisconnected"), "ACC2:Font:17", w*0.75, h*0.145, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
    end

    playerList = vgui.Create("ACC2:DScroll", managePlayer)
    playerList:SetSize(managePlayer:GetWide()/2.07, ACC2.ScrH*0.417)
    playerList:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.1285)

    reloadPlayers(playerList)
    
    searchSteamId = vgui.Create("ACC2:DScroll", managePlayer)
    searchSteamId:SetSize(managePlayer:GetWide()/2.055, ACC2.ScrH*0.417)
    searchSteamId:SetPos(managePlayer:GetWide()/2, ACC2.ScrH*0.1285)
    
    local entryName = vgui.Create("ACC2:TextEntry", searchSteamId)
    entryName:SetSize(0, ACC2.ScrH*0.048)
    entryName:Dock(TOP)
    entryName:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    entryName:SetPlaceHolder(ACC2.GetSentence("searchBySteamID"))

    local searchAccept = vgui.Create("ACC2:SlideButton", searchSteamId)
    searchAccept:SetSize(0, ACC2.ScrH*0.042)
    searchAccept:Dock(TOP)
    searchAccept:SetText(ACC2.GetSentence("searchPlayer"))
    searchAccept:SetFont("ACC2:Font:15")
    searchAccept:SetTextColor(ACC2.Colors["white"])
    searchAccept:InclineButton(0)
    searchAccept.MinMaxLerp = {100, 200}
    searchAccept:SetIconMaterial(nil)
    searchAccept:SetButtonColor(ACC2.Colors["purple"])
    searchAccept.DoClick = function()
        if entryName:GetText() == ACC2.GetSentence("searchBySteamID") then return end

        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(6, 4)
            net.WriteString(entryName:GetText())
        net.SendToServer()
    end

    local cancel = vgui.Create("ACC2:SlideButton", managePlayer)
    cancel:SetSize(managePlayer:GetWide()/2.072, ACC2.ScrH*0.041)
    cancel:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.552)
    cancel:SetText(ACC2.GetSentence("cancel"))
    cancel:SetFont("ACC2:Font:15")
    cancel:SetTextColor(ACC2.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(ACC2.Colors["grey69"])
    cancel.DoClick = function()
        if IsValid(managePlayer) then managePlayer:Remove() end
        ACC2.Settings()
    end

    local refreshButton = vgui.Create("ACC2:SlideButton", managePlayer)
    refreshButton:SetSize(managePlayer:GetWide()/2.055, ACC2.ScrH*0.041)
    refreshButton:SetPos(managePlayer:GetWide()/2, ACC2.ScrH*0.552)
    refreshButton:SetText(ACC2.GetSentence("refreshList"))
    refreshButton:SetFont("ACC2:Font:15")
    refreshButton:SetTextColor(ACC2.Colors["white"])
    refreshButton:InclineButton(0)
    refreshButton.MinMaxLerp = {100, 200}
    refreshButton:SetIconMaterial(nil)
    refreshButton:SetButtonColor(ACC2.Colors["purple"])
    refreshButton.DoClick = function()
        reloadPlayers(playerList)
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", managePlayer)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(managePlayer:GetWide()*0.94, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        managePlayer:Remove()
    end
end

ACC2.JobSelected = ACC2.JobSelected or nil

local function addCollapstiblePermission(k, tbl, pnl, jobName, colorPanel)
    if not IsValid(pnl) then return end
    
    local jobButton = vgui.Create("DButton", pnl)
    jobButton:SetSize(0, ACC2.ScrH*0.03)
    jobButton:Dock(TOP)
    jobButton:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    jobButton:SetText("")
    jobButton.deploy = false
    jobButton.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)

        local color = (IsColor(colorPanel) and table.Copy(colorPanel) or team.GetColor(k))
        
        surface.SetDrawColor(ACC2.Colors["white10"])
        surface.DrawRect(ACC2.ScrW*0.01, ACC2.ScrH*0.03, w*0.93, ACC2.ScrH*0.002)
        
        color.a = 50
        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, w*0.02, h)

        draw.DrawText(ACC2.GetSentence("whitelistPoint"), "ACC2:Font:17", ACC2.ScrW*0.01, ACC2.ScrH*0.04, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("blacklistPoint"), "ACC2:Font:17", ACC2.ScrW*0.12, ACC2.ScrH*0.04, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
    end
    jobButton.DoClick = function(self)
        jobButton.deploy = !jobButton.deploy

        self:SizeTo(-1, (jobButton.deploy and ACC2.ScrH*0.075 or ACC2.ScrH*0.03), 0.5, 0, 0.5)
    end

    local keyName = tbl.Name
    ACC2.WhitelistSettingsTable[jobName] = ACC2.WhitelistSettingsTable[jobName] or {}
    ACC2.WhitelistSettingsTable[jobName]["permissions"] = ACC2.WhitelistSettingsTable[jobName]["permissions"] or {}
    ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName] = ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName] or {}

    surface.SetFont("ACC2:Font:17")
    local sizeToggleWhitelist = surface.GetTextSize(ACC2.GetSentence("whitelistPoint"))

    local value = ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName]["canManageWhitelist"]
    local whitelistToggle = vgui.Create("ACC2:Toggle", jobButton)
    whitelistToggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
    whitelistToggle:SetPos(ACC2.ScrW*0.012 + sizeToggleWhitelist, ACC2.ScrH*0.042)
    whitelistToggle:SetDefaultStatut(value)
    whitelistToggle.OnChange = function(self)
        ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName]["canManageWhitelist"] = self:GetStatut()
    end
    ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName]["canManageWhitelist"] = value

    surface.SetFont("ACC2:Font:17")
    local sizeToggleBlacklist = surface.GetTextSize(ACC2.GetSentence("blacklistPoint"))

    local value = ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName]["canManageBlacklist"]
    local blacklistToggle = vgui.Create("ACC2:Toggle", jobButton)
    blacklistToggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
    blacklistToggle:SetPos(ACC2.ScrW*0.122 + sizeToggleBlacklist, ACC2.ScrH*0.042)
    blacklistToggle:SetDefaultStatut(value)
    blacklistToggle.OnChange = function(self)
        ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName]["canManageBlacklist"] = self:GetStatut()
    end
    ACC2.WhitelistSettingsTable[jobName]["permissions"][keyName]["canManageBlacklist"] = value

    local playerName = vgui.Create("DLabel", jobButton)
    playerName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    playerName:SetPos(ACC2.ScrW*0.01, 0)
    playerName:SetText(keyName)
    playerName:SetTextColor(ACC2.Colors["white100"])
    playerName:SetFont("ACC2:Font:17")
end

local modificationContainer, saveButton
local function reloadWhitelistSettingPanel(jobName)
    local jobTable = ACC2.GetJobTblById(jobName)
    if not istable(jobTable) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

    ACC2.CategorySelected = "settings"
    ACC2.WhitelistSettingsTable =  ACC2.WhitelistSettingsTable or {}

    modificationContainer:Clear()
    
    local enableWhitelist = vgui.Create("DButton", modificationContainer)
    enableWhitelist:SetSize(0, ACC2.ScrH*0.05)
    enableWhitelist:Dock(TOP)
    enableWhitelist:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    enableWhitelist:SetText("")
    enableWhitelist.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local jobName = jobTable.Name
    if not isstring(jobName) then return end

    ACC2.WhitelistSettingsTable[jobName] = ACC2.WhitelistSettingsTable[jobName] or {}
    ACC2.WhitelistSettingsTable[jobName]["jobName"] = jobName

    local label = vgui.Create("DLabel", enableWhitelist)
    label:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    label:SetPos(ACC2.ScrW*0.01, ACC2.ScrH*0.01)
    label:SetText(ACC2.GetSentence("enableWhitelist"))
    label:SetTextColor(ACC2.Colors["white100"])
    label:SetFont("ACC2:Font:17")

    local toggle = vgui.Create("ACC2:Toggle", enableWhitelist)
    toggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
    toggle:SetPos(ACC2.ScrW*0.211, ACC2.ScrH*0.012)
    toggle:SetDefaultStatut(ACC2.WhitelistSettingsTable[jobName]["whitelistEnable"])
    toggle.OnChange = function(self, bool)
        ACC2.WhitelistSettingsTable[jobName]["whitelistEnable"] = self:GetStatut()
    end

    enableWhitelist.DoClick = function(self)
        local bool = not toggle:GetStatut()

        toggle:ChangeStatut(bool)
        ACC2.WhitelistSettingsTable[jobName]["whitelistEnable"] = bool
    end

    local enableBlacklist = vgui.Create("DButton", modificationContainer)
    enableBlacklist:SetSize(0, ACC2.ScrH*0.05)
    enableBlacklist:Dock(TOP)
    enableBlacklist:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    enableBlacklist:SetText("")
    enableBlacklist.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local label = vgui.Create("DLabel", enableBlacklist)
    label:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    label:SetPos(ACC2.ScrW*0.01, ACC2.ScrH*0.01)
    label:SetText(ACC2.GetSentence("enableBlacklist"))
    label:SetTextColor(ACC2.Colors["white100"])
    label:SetFont("ACC2:Font:17")

    local toggle = vgui.Create("ACC2:Toggle", enableBlacklist)
    toggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
    toggle:SetPos(ACC2.ScrW*0.211, ACC2.ScrH*0.012)
    toggle:SetDefaultStatut(ACC2.WhitelistSettingsTable[jobName]["blacklistEnable"])
    toggle.OnChange = function(self)
        ACC2.WhitelistSettingsTable[jobName]["blacklistEnable"] = self:GetStatut()
    end

    enableBlacklist.DoClick = function(self)
        local bool = not toggle:GetStatut()

        toggle:ChangeStatut(bool)
        ACC2.WhitelistSettingsTable[jobName]["blacklistEnable"] = bool
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

    local whitelistDefault = vgui.Create("DButton", modificationContainer)
    whitelistDefault:SetSize(0, ACC2.ScrH*0.05)
    whitelistDefault:Dock(TOP)
    whitelistDefault:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    whitelistDefault:SetText("")
    whitelistDefault.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local label = vgui.Create("DLabel", whitelistDefault)
    label:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    label:SetPos(ACC2.ScrW*0.01, ACC2.ScrH*0.01)
    label:SetText(ACC2.GetSentence("defaultWhitelist"))
    label:SetTextColor(ACC2.Colors["white100"])
    label:SetFont("ACC2:Font:17")

    local toggle = vgui.Create("ACC2:Toggle", whitelistDefault)
    toggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
    toggle:SetPos(ACC2.ScrW*0.211, ACC2.ScrH*0.012)
    toggle.ACC2LerpColor = ACC2.Colors["grey"]
    toggle:SetDefaultStatut(ACC2.WhitelistSettingsTable[jobName]["defaultWhitelist"])
    toggle.OnChange = function(self, bool)
        ACC2.WhitelistSettingsTable[jobName]["defaultWhitelist"] = self:GetStatut()
    end

    whitelistDefault.DoClick = function(self)
        local bool = not toggle:GetStatut()

        toggle:ChangeStatut(bool)
        ACC2.WhitelistSettingsTable[jobName]["defaultWhitelist"] = bool
    end

    local blacklistDefault = vgui.Create("DButton", modificationContainer)
    blacklistDefault:SetSize(0, ACC2.ScrH*0.05)
    blacklistDefault:Dock(TOP)
    blacklistDefault:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    blacklistDefault:SetText("")
    blacklistDefault.Paint = function(self,w,h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local label = vgui.Create("DLabel", blacklistDefault)
    label:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    label:SetPos(ACC2.ScrW*0.01, ACC2.ScrH*0.01)
    label:SetText(ACC2.GetSentence("defaultBlacklist"))
    label:SetTextColor(ACC2.Colors["white100"])
    label:SetFont("ACC2:Font:17")

    local toggle = vgui.Create("ACC2:Toggle", blacklistDefault)
    toggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
    toggle:SetPos(ACC2.ScrW*0.211, ACC2.ScrH*0.012)
    toggle.ACC2LerpColor = ACC2.Colors["grey"]
    toggle:SetDefaultStatut(ACC2.WhitelistSettingsTable[jobName]["defaultBlacklist"])
    toggle.OnChange = function(self, bool)
        ACC2.WhitelistSettingsTable[jobName]["defaultBlacklist"] = self:GetStatut()
    end

    blacklistDefault.DoClick = function(self)
        local bool = not toggle:GetStatut()

        toggle:ChangeStatut(bool)
        ACC2.WhitelistSettingsTable[jobName]["defaultBlacklist"] = bool
    end

    local whitelistPermission = vgui.Create("DPanel", modificationContainer)
    whitelistPermission:SetSize(0, ACC2.ScrH*0.05)
    whitelistPermission:Dock(TOP)
    whitelistPermission:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    whitelistPermission:SetText("")
    whitelistPermission.Paint = function(self,w,h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local label = vgui.Create("DLabel", whitelistPermission)
    label:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    label:SetPos(ACC2.ScrW*0.01, ACC2.ScrH*0.01)
    label:SetText(ACC2.GetSentence("jobsAllowedTo"))
    label:SetTextColor(ACC2.Colors["white100"])
    label:SetFont("ACC2:Font:17")

    local open = vgui.Create("DButton", whitelistPermission)
    open:SetSize(ACC2.ScrW*0.045, ACC2.ScrH*0.025)
    open:SetPos(ACC2.ScrW*0.196, ACC2.ScrH*0.013)
    open:SetText(ACC2.GetSentence("open"))
    open:SetTextColor(ACC2.Colors["white100"])
    open:SetFont("ACC2:Font:09")
    
    open.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    open.DoClick = function()
        modificationContainer:Clear()
        modificationContainer:SetSize(whitelistSettings:GetWide()/2.055, ACC2.ScrH*0.378)

        for k, v in pairs(team.GetAllTeams()) do
            if not v.Joinable then continue end

            addCollapstiblePermission(k, v, modificationContainer, jobName)
        end
    end

    local whitelistPermissionUserGroup = vgui.Create("DPanel", modificationContainer)
    whitelistPermissionUserGroup:SetSize(0, ACC2.ScrH*0.05)
    whitelistPermissionUserGroup:Dock(TOP)
    whitelistPermissionUserGroup:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    whitelistPermissionUserGroup:SetText("")
    whitelistPermissionUserGroup.Paint = function(self,w,h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local label = vgui.Create("DLabel", whitelistPermissionUserGroup)
    label:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    label:SetPos(ACC2.ScrW*0.01, ACC2.ScrH*0.01)
    label:SetText(ACC2.GetSentence("usergroupsAllowedTo"))
    label:SetTextColor(ACC2.Colors["white100"])
    label:SetFont("ACC2:Font:17")

    local open = vgui.Create("DButton", whitelistPermissionUserGroup)
    open:SetSize(ACC2.ScrW*0.045, ACC2.ScrH*0.025)
    open:SetPos(ACC2.ScrW*0.196, ACC2.ScrH*0.013)
    open:SetText(ACC2.GetSentence("open"))
    open:SetTextColor(ACC2.Colors["white100"])
    open:SetFont("ACC2:Font:09")
    open.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    open.DoClick = function(self, bool)
        modificationContainer:Clear()
        modificationContainer:SetSize(whitelistSettings:GetWide()/2.055, ACC2.ScrH*0.378)

        local userTable = CAMI and CAMI.GetUsergroups() or {}

        for k, v in pairs(userTable) do
            addCollapstiblePermission(k, v, modificationContainer, jobName, ACC2.Colors["purple"])
        end
    end

    if IsValid(saveButton) then
        saveButton:SetVisible(true)
    end

    modificationContainer:SetSize(whitelistSettings:GetWide()/2.055, ACC2.ScrH*0.425)
end

local function sendWhitelistNet(whitelistType, jobName, page)    
    net.Start("ACC2:Admin:Configuration")
        net.WriteUInt(10, 4)
        net.WriteUInt(page, 12)
        net.WriteString(whitelistType)
        net.WriteString(jobName)
    net.SendToServer()
end

local function reloadWhitelistPlayers(whitelistTable, countValues, whitelistType, jobName, pageSelected, whitelistedTable)
    if not IsValid(modificationContainer) then return end
    if not isstring(jobName) then return end

    whitelistTable = whitelistTable or {}
    
    modificationContainer:Clear()

    local whitelistPlayers = vgui.Create("DListView", modificationContainer)
    whitelistPlayers:SetSize(ACC2.ScrW*0.246, ACC2.ScrH*0.34)
    whitelistPlayers:SetMultiSelect(false)
    whitelistPlayers:SetHeaderHeight(ACC2.ScrH*0.02285)
	whitelistPlayers:SetDataHeight(ACC2.ScrH*0.02285)
    local typeColumn = whitelistPlayers:AddColumn(ACC2.GetSentence("type"), 1)
    typeColumn:SetFixedWidth(ACC2.ScrW*0.035)

    local characterIdColumn = whitelistPlayers:AddColumn(ACC2.GetSentence("id"), 2)
    characterIdColumn:SetFixedWidth(ACC2.ScrW*0.025)

    local steamIdColumn = whitelistPlayers:AddColumn(ACC2.GetSentence("steamId"), 3)
    steamIdColumn:SetFixedWidth(ACC2.ScrW*0.08)

    local nameColumn = whitelistPlayers:AddColumn(ACC2.GetSentence("name"), 4)

    local sbar = whitelistPlayers.VBar
    if IsValid(sbar) then
        function sbar:Paint(w, h)
            surface.SetDrawColor(ACC2.Colors["grey30"])
            surface.DrawRect(0, 0, w, h)
        end
        function sbar.btnUp:Paint(w, h)
            surface.SetDrawColor(ACC2.Colors["grey30"])
            surface.DrawRect(0, 0, w, h)
        end
        function sbar.btnDown:Paint(w, h)
            surface.SetDrawColor(ACC2.Colors["grey30"])
            surface.DrawRect(0, 0, w, h)
        end
        function sbar.btnGrip:Paint(w, h)
            surface.SetDrawColor(ACC2.Colors["grey30"])
            surface.DrawRect(0, 0, w, h)
        end
    end
    
    local pageSelectorSize = ACC2.ScrW*0.2455
    local pageSelector = vgui.Create("DPanel", modificationContainer)
    pageSelector:SetSize(pageSelectorSize, ACC2.ScrH*0.038)
    pageSelector:SetPos(0, ACC2.ScrH*0.34)
    pageSelector.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end 

    local pages = math.ceil(countValues/ACC2.MaxPerPage)
    local maxPage, space, sizePage = math.Clamp(pages, 0, ACC2.MaxPage), ACC2.ScrW*0.002, ACC2.ScrH*0.027

    for i=(maxPage > 1 and 0 or 1), (maxPage > 1 and (maxPage + 1) or maxPage) do
        local page = vgui.Create("ACC2:SlideButton", pageSelector)
        page:SetSize(sizePage, sizePage)
        page:SetPos(math.Round(sizePage*i - sizePage + space*i + pageSelectorSize/2 - sizePage*maxPage/2 - (space*maxPage)/2) - ACC2.ScrW*0.001, ACC2.ScrH*0.0025)
        page:SetFont("ACC2:Font:16")
        page:SetTextColor(ACC2.Colors["white"])
        page:InclineButton(0)
        page.MinMaxLerp = {100, 200}
        page:SetIconMaterial(nil)
        page:SetButtonColor(ACC2.Colors["grey69"])

        local pointMore = math.ceil(maxPage - maxPage/3)
        if i == 0 && maxPage > 1 then
            page:SetText("◀")
            page.DoClick = function(self)
                local page = tonumber(pageSelected)
                if not isnumber(page) then return end

                page = (page > 0 and (page - 1) or 0)

                sendWhitelistNet(whitelistType, jobName, page)
            end
        elseif i == (maxPage + 1) && maxPage > 1 then
            page:SetText("▶")
            page.DoClick = function(self)
                local page = tonumber(pageSelected)
                if not isnumber(page) then return end

                page = (page < pages and (page + 1) or pages)

                sendWhitelistNet(whitelistType, jobName, page)
            end
        elseif i == pointMore && maxPage > 6 && pageSelected <= (pages - pointMore) then
            page:SetText("...")
        elseif i > pointMore && maxPage > 6 then
            local dif = pages - (maxPage - i)

            page.pageId = dif
            page:SetText(dif)
            page.DoClick = function(self)
                local page = tonumber(page:GetText())
                if not isnumber(page) then return end

                sendWhitelistNet(whitelistType, jobName, page)
            end
        else
            local endPage = (pageSelected > (pages - maxPage) + 2) && (i > 1)
            local bool = ((pageSelected > (pointMore - 2) && maxPage > 6) && (i > 1)) && not endPage
            local id = (bool and i + 1*(pageSelected - (pointMore - 2)) or (endPage and (pages - (maxPage - i)) or i))

            page.pageId = id
            page:SetText(id)
            
            page.DoClick = function(self)
                local page = tonumber(page:GetText())
                if not isnumber(page) then return end

                sendWhitelistNet(whitelistType, jobName, page)
            end
        end
        page.Paint = function(self, w, h)
            if self.pageId == pageSelected then
                surface.SetDrawColor(ACC2.Colors["purple"])
                surface.DrawRect(0, 0, w, h)
            else
                surface.SetDrawColor(ACC2.Colors["white5"])
                surface.DrawRect(0, 0, w, h)
            end
        end
    end

    for k, v in ipairs(whitelistTable) do
        whitelistPlayers:AddLine((v.ownerId64 == "NULL" and ACC2.GetSentence("userGroup") or ACC2.GetSentence("steamId")), v.characterId, (v.ownerId64 == "NULL" and "-" or v.ownerId64), v.globalName)
    end

    if IsValid(saveButton) then
        saveButton:SetVisible(false)
    end

    for k, v in pairs(whitelistPlayers.Columns) do
        if IsValid(v.Header) then                
            v.Header.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end

            v.Header:SetTextColor(ACC2.Colors["white100"])
            v.Header:SetFont("ACC2:Font:25")
        end
    end

    for k, v in pairs(whitelistPlayers.Lines) do
        whitelistPlayers.Lines[k].Paint = function(self, w, h)
            if self:IsSelected() then
                surface.SetDrawColor(ACC2.Colors["purple120"])
            elseif self.Hovered then
                surface.SetDrawColor(ACC2.Colors["purple3"])
            elseif self.m_bAlt then
                surface.SetDrawColor(0, 0, 0, 60)
            end
    
            surface.DrawRect(0, 0, w, h)
        end
        
        for k, v in pairs(whitelistPlayers.Lines[k].Columns) do
            v:SetTextColor(ACC2.Colors["white100"])
            v:SetFont("ACC2:Font:26")

            if k != 4 then
                v:SetContentAlignment(5)
            end
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944

    whitelistPlayers.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local whitelistLayout = vgui.Create("DIconLayout", modificationContainer)
    whitelistLayout:SetSize(ACC2.ScrW*0.25, ACC2.ScrH*0.11)
    whitelistLayout:SetPos(ACC2.ScrW*0.0, ACC2.ScrH*0.3861)
    whitelistLayout:SetSpaceY(ACC2.ScrW*0.0022)
    whitelistLayout:SetSpaceX(ACC2.ScrW*0.0022)
    
    local remove = vgui.Create("ACC2:SlideButton", whitelistLayout)
    remove:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.04)
    remove:SetText(ACC2.GetSentence("remove"))
    remove:SetFont("ACC2:Font:15")
    remove:SetTextColor(ACC2.Colors["white"])
    remove:InclineButton(0)
    remove.MinMaxLerp = {100, 200}
    remove:SetIconMaterial(nil)
    remove:SetButtonColor(ACC2.Colors["red202"])
    remove.DoClick = function()
        local selected = whitelistPlayers:GetSelected()[1]
        if not IsValid(selected) then
            ACC2.Notification(5, ACC2.GetSentence("selectLineToDelete"))
            return 
        end

        local typeName = tostring(selected:GetValue(1))
        
        if typeName == ACC2.GetSentence("userGroup") then
            local name = tostring(selected:GetValue(4))
            if not isstring(name) then return end
        
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(12, 4)
                net.WriteString(name)
                net.WriteString(jobName)
                net.WriteUInt((pageSelected or 1), 12)
                net.WriteString(whitelistType)
                net.WriteBool(false)
            net.SendToServer()
        elseif typeName == ACC2.GetSentence("steamId") then
            local characterId = tonumber(selected:GetValue(2))
            if not isnumber(characterId) then return end
    
            local steamId64 = selected:GetValue(3)
            if not isstring(steamId64) then return end
        
            net.Start("ACC2:Admin:Configuration")
                net.WriteUInt(11, 4)
                net.WriteString(steamId64)
                net.WriteBool(true)
                net.WriteUInt(characterId, 22)
                net.WriteUInt((pageSelected or 1), 12)
                net.WriteString(jobName)
                net.WriteString(whitelistType)
                net.WriteBool(false)
            net.SendToServer()
        end
    end

    local addPlayer = vgui.Create("ACC2:SlideButton", whitelistLayout)
    addPlayer:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.04)
    addPlayer:SetText(ACC2.GetSentence("addPlayer"))
    addPlayer:SetFont("ACC2:Font:15")
    addPlayer:SetTextColor(ACC2.Colors["white"])
    addPlayer:InclineButton(0)
    addPlayer.MinMaxLerp = {100, 200}
    addPlayer:SetIconMaterial(nil)
    addPlayer:SetButtonColor(ACC2.Colors["purple120"])
    addPlayer.DoClick = function()
        local players = DermaMenu()
        players:SetDrawColumn(true)

        local sbar = players.VBar
        sbar:SetWide(0)
        if IsValid(sbar) then
            function sbar:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
            function sbar.btnUp:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
            function sbar.btnDown:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
            function sbar.btnGrip:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
        end        
        players.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["grey69"])
            surface.DrawRect(0, 0, w, h)
        end

        local playersButton = players:AddOption(ACC2.GetSentence("addBySteamId"))
        playersButton:SetIcon("icon16/bug.png")
        playersButton:SetFont("ACC2:Font:17")
        playersButton:SetTextColor(ACC2.Colors["white100"])
        local pnl = playersButton:GetChildren()[1]
        pnl.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["purple"])
            surface.DrawRect(0, 0, w, h)
        end
        playersButton.DoClick = function()
            local addBySteamId = vgui.Create("DFrame")
            addBySteamId:SetSize(ACC2.ScrW*0.2, ACC2.ScrH*0.15)
            addBySteamId:SetDraggable(true)
            addBySteamId:MakePopup()
            addBySteamId:SetTitle("")
            addBySteamId:ShowCloseButton(false)
            addBySteamId:Center()
            addBySteamId.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["blackpurple"])
                surface.DrawRect(0, 0, w*0.998, h)

                surface.SetDrawColor(ACC2.Colors["white20"])
                surface.DrawRect(ACC2.ScrW*0.0038, h*0.045, addBySteamId:GetWide()/1.04, ACC2.ScrH*0.041)
                
                draw.DrawText(string.upper(ACC2.GetSentence("steamId")), "ACC2:Font:13", w*0.05, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
            end

            local textEntry = vgui.Create("ACC2:TextEntry", addBySteamId)
            textEntry:SetSize(addBySteamId:GetWide()/1.04, ACC2.ScrH*0.043)
            textEntry:SetPos(ACC2.ScrW*0.0038, ACC2.ScrH*0.0533)
            textEntry:SetPlaceHolder("76561198107512648")

            local saveButton = vgui.Create("ACC2:SlideButton", addBySteamId)
            saveButton:SetSize(addBySteamId:GetWide()/1.04, ACC2.ScrH*0.041)
            saveButton:SetPos(ACC2.ScrW*0.0038, ACC2.ScrH*0.102)
            saveButton:SetText(string.upper(ACC2.GetSentence("addBySteamId")))
            saveButton:SetFont("ACC2:Font:15")
            saveButton:SetTextColor(ACC2.Colors["white"])
            saveButton:InclineButton(0)
            saveButton.MinMaxLerp = {100, 200}
            saveButton:SetIconMaterial(nil)
            saveButton:SetButtonColor(ACC2.Colors["purple"])
            saveButton.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(6, 4)
                    net.WriteString(textEntry:GetText())
                net.SendToServer()
                
                addBySteamId:Remove()
            end

            local closeLerp = 50
            local close = vgui.Create("DButton", addBySteamId)
            close:SetSize(ACC2.ScrH*0.025, ACC2.ScrH*0.025)
            close:SetPos(addBySteamId:GetWide()*0.875, ACC2.ScrH*0.016)
            close:SetText("")
            close.Paint = function(self,w,h)
                closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))
        
                surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
                surface.SetMaterial(ACC2.Materials["icon_close"])
                surface.DrawTexturedRect(0, 0, w, h)
            end
            close.DoClick = function()
                addBySteamId:Remove()
            end
        end

        local distanceButtons, parent = players:AddSubMenu(ACC2.GetSentence("distance"))
        parent:SetIcon("icon16/world.png")
        parent:SetFont("ACC2:Font:17")
        parent:SetTextColor(ACC2.Colors["white100"])
        local pnl = parent:GetChildren()[1]
        pnl.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["grey69"])
            surface.DrawRect(0, 0, w, h)
        end
        
        local playerByDistance = {}

        for k, v in pairs(player.GetAll()) do
            playerByDistance[#playerByDistance + 1] = {
                ["ply"] = v,
                ["distance"] = v:GetPos():Distance(ACC2.LocalPlayer:GetPos())
            }
        end

        table.SortByMember(playerByDistance, "distance", true)

        for k, v in pairs(playerByDistance) do
            local ply = v.ply
            if not IsValid(ply) then continue end

            if whitelistedTable[ply:SteamID64()] then continue end

            local playersButton = distanceButtons:AddOption((ply:Name().." (%sm)"):format(math.Round(v.distance)))
            playersButton:SetIcon("icon16/world.png")
            playersButton:SetFont("ACC2:Font:17")
            playersButton:SetTextColor(ACC2.Colors["white100"])
            
            local pnl = playersButton:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(team.GetColor(ply:Team()))
                surface.DrawRect(0, 0, w, h)
            end
            playersButton.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(11, 4)
                    net.WriteString(ply:SteamID64())
                    net.WriteBool(false)
                    net.WriteUInt((pageSelected or 1), 12)
                    net.WriteString(jobName)
                    net.WriteString(whitelistType)
                    net.WriteBool(true)
                net.SendToServer()
            end
        end

        local playerCollapse, parent = players:AddSubMenu(ACC2.GetSentence("name"))
        parent:SetIcon("icon16/monitor.png")
        parent:SetFont("ACC2:Font:17")
        parent:SetTextColor(ACC2.Colors["white100"])
        local pnl = parent:GetChildren()[1]
        pnl.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["grey69"])
            surface.DrawRect(0, 0, w, h)
        end

        local playerByName = {}

        for k, v in pairs(player.GetAll()) do
            playerByName[#playerByName + 1] = {
                ["ply"] = v,
                ["name"] = v:Name()
            }
        end

        table.SortByMember(playerByName, "name", true)
        
        for k, v in pairs(playerByName) do
            local ply = v.ply
            if not IsValid(ply) then continue end

            if whitelistedTable[ply:SteamID64()] then continue end

            local playersButton = playerCollapse:AddOption(ply:Name())
            playersButton:SetIcon("icon16/monitor.png")
            playersButton:SetFont("ACC2:Font:17")
            playersButton:SetTextColor(ACC2.Colors["white100"])
            
            local pnl = playersButton:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(team.GetColor(ply:Team()))
                surface.DrawRect(0, 0, w, h)
            end
            playersButton.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(11, 4)
                    net.WriteString(ply:SteamID64())
                    net.WriteBool(false)
                    net.WriteUInt((pageSelected or 1), 12)
                    net.WriteString(jobName)
                    net.WriteString(whitelistType)
                    net.WriteBool(true)
                net.SendToServer()
            end
        end

        local playerCollapse, parent = players:AddSubMenu(ACC2.GetSentence("team"))
        parent:SetIcon("icon16/user_gray.png")
        parent:SetFont("ACC2:Font:17")
        parent:SetTextColor(ACC2.Colors["white100"])
        local pnl = parent:GetChildren()[1]
        pnl.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["grey69"])
            surface.DrawRect(0, 0, w, h)
        end

        local playersByTeam = {}

        for k, v in pairs(player.GetAll()) do
            playersByTeam[#playersByTeam + 1] = {
                ["ply"] = v,
                ["team"] = v:Team()
            }
        end

        table.SortByMember(playersByTeam, "team", true)
        
        for k, v in pairs(playersByTeam) do
            local ply = v.ply
            if not IsValid(ply) then continue end

            if whitelistedTable[ply:SteamID64()] then continue end

            local playersButton = playerCollapse:AddOption((ply:Name().." (%s)"):format(team.GetName(ply:Team())))
            playersButton:SetIcon("icon16/user_gray.png")
            playersButton:SetFont("ACC2:Font:17")
            playersButton:SetTextColor(ACC2.Colors["white100"])
            
            local pnl = playersButton:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(team.GetColor(ply:Team()))
                surface.DrawRect(0, 0, w, h)
            end
            playersButton.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(11, 4)
                    net.WriteString(ply:SteamID64())
                    net.WriteBool(false)
                    net.WriteUInt((pageSelected or 1), 12)
                    net.WriteString(jobName)
                    net.WriteString(whitelistType)
                    net.WriteBool(true)
                net.SendToServer()
            end
        end

        local playerCollapse, parent = players:AddSubMenu(ACC2.GetSentence("usergroups"))
        parent:SetIcon("icon16/shield.png")
        parent:SetFont("ACC2:Font:17")
        parent:SetTextColor(ACC2.Colors["white100"])
        local pnl = parent:GetChildren()[1]
        pnl.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["grey69"])
            surface.DrawRect(0, 0, w, h)
        end

        local playerByUserGroups = {}

        for k, v in pairs(player.GetAll()) do
            playerByUserGroups[#playerByUserGroups + 1] = {
                ["ply"] = v,
                ["usergroups"] = v:GetUserGroup()
            }
        end

        table.SortByMember(playerByUserGroups, "usergroups", true)
        
        for k, v in pairs(playerByUserGroups) do
            local ply = v.ply
            if not IsValid(ply) then continue end

            if whitelistedTable[ply:SteamID64()] then continue end

            local playersButton = playerCollapse:AddOption((ply:Name().." (%s)"):format(ply:GetUserGroup()))
            playersButton:SetIcon("icon16/user_gray.png")
            playersButton:SetFont("ACC2:Font:17")
            playersButton:SetTextColor(ACC2.Colors["white100"])
            
            local pnl = playersButton:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["purple"])
                surface.DrawRect(0, 0, w, h)
            end
            playersButton.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(11, 4)
                    net.WriteString(ply:SteamID64())
                    net.WriteBool(false)
                    net.WriteUInt((pageSelected or 1), 12)
                    net.WriteString(jobName)
                    net.WriteString(whitelistType)
                    net.WriteBool(true)
                net.SendToServer()
            end
        end

        players:Open()
    end

    local userTable = CAMI and CAMI.GetUsergroups() or {}

    local addUserGroup = vgui.Create("ACC2:SlideButton", whitelistLayout)
    addUserGroup:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.04)
    addUserGroup:SetText(ACC2.GetSentence("addUserGroup"))
    addUserGroup:SetFont("ACC2:Font:15")
    addUserGroup:SetTextColor(ACC2.Colors["white"])
    addUserGroup:InclineButton(0)
    addUserGroup.MinMaxLerp = {100, 200}
    addUserGroup:SetIconMaterial(nil)
    addUserGroup:SetButtonColor(ACC2.Colors["purple120"])
    addUserGroup.DoClick = function()
        local userGroup = DermaMenu()
        userGroup:SetDrawColumn(true)

        local sbar = userGroup.VBar
        sbar:SetWide(ACC2.ScrW*0.005)
        if IsValid(sbar) then
            function sbar:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
            function sbar.btnUp:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
            function sbar.btnDown:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
            function sbar.btnGrip:Paint(w, h)
                surface.SetDrawColor(ACC2.Colors["grey30"])
                surface.DrawRect(0, 0, w, h)
            end
        end        
        userGroup.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["grey69"])
            surface.DrawRect(0, 0, w, h)
        end
        
        local count = 0
        for k, v in pairs(userTable) do
            if whitelistedTable[k] then continue end

            local group = userGroup:AddOption(k)
            group:SetIcon("icon16/bug.png")
            group:SetFont("ACC2:Font:17")
            group:SetTextColor(ACC2.Colors["white100"])
            
            local pnl = group:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["purple"])
                surface.DrawRect(0, 0, w, h)
            end

            group.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(12, 4)
                    net.WriteString(k)
                    net.WriteString(jobName)
                    net.WriteUInt((pageSelected or 1), 12)
                    net.WriteString(whitelistType)
                    net.WriteBool(true)
                net.SendToServer()
            end

            count = count + 1
        end

        if count <= 0 then
            ACC2.Notification(5, ACC2.GetSentence("noUserGroupToAdd"))
            return
        end

        userGroup:Open()
    end
end

local function addJob(k, jobTable, jobList, notSendNet)
    if not IsValid(jobList) then return end

    local jobButton = vgui.Create("DButton", jobList)
    jobButton:SetSize(0, ACC2.ScrH*0.03)
    jobButton:Dock(TOP)
    jobButton:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    jobButton:SetText("")
    jobButton.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)

        local color = team.GetColor(k)
        color.a = 50

        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, w*0.02, h)
    end
    jobButton.DoClick = function()
        sendWhitelistNet("whitelisted", team.GetName(k), 1)
    end
    
    local playerName = vgui.Create("DLabel", jobButton)
    playerName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    playerName:SetPos(ACC2.ScrW*0.01, 0)
    playerName:SetText(jobTable.Name)
    playerName:SetTextColor(ACC2.Colors["white100"])
    playerName:SetFont("ACC2:Font:17")

    local editButton = vgui.Create("ACC2:SlideButton", jobButton)
    editButton:SetSize(ACC2.ScrH*0.0235, ACC2.ScrH*0.0235)
    editButton:SetPos(ACC2.ScrW*0.2235, ACC2.ScrH*0.0038)
    editButton:SetText("")
    editButton.MinMaxLerp = {5, 7}
    editButton:SetIconMaterial(nil)
    editButton:SetButtonColor(ACC2.Colors["white5"])
    editButton.PaintOver = function(self, w, h)
        if ACC2.JobSelected == team.GetName(k) then
            surface.SetDrawColor(ACC2.Colors["purple120"])
            surface.DrawRect(0, 0, w, h)
        end

        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.SetMaterial(ACC2.Materials["icon_edit"])
        surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
    end
    editButton.DoClick = function()
        sendWhitelistNet("whitelisted", team.GetName(k), 1)   
    end

    if not notSendNet then
        if not ACC2.JobSelected then
            sendWhitelistNet("whitelisted", team.GetName(k), 1)   
        else
            sendWhitelistNet("whitelisted", ACC2.JobSelected, 1)   
        end
    end
end

function ACC2.GetJobTblById(value)
    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        if k == jobId or v.Name == value then
            return v 
        end
    end
end

function ACC2.WhitelistSettings()
    if IsValid(settingsMenu) then settingsMenu:Remove() end
    if IsValid(whitelistSettings) then whitelistSettings:Remove() end

    ACC2.CategorySelected = "whitelisted"

    whitelistSettings = vgui.Create("DFrame")
    whitelistSettings:SetSize(ACC2.ScrW*0.503, ACC2.ScrH*0.603)
    whitelistSettings:SetDraggable(false)
    whitelistSettings:MakePopup()
    whitelistSettings:SetTitle("")
    whitelistSettings:ShowCloseButton(false)
    whitelistSettings:Center()
    whitelistSettings.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.02, ACC2.ScrW*0.49, ACC2.ScrH*0.062)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.13, ACC2.ScrW*0.243, ACC2.ScrH*0.045)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(ACC2.ScrW*0.2515, h*0.13, ACC2.ScrW*0.245, ACC2.ScrH*0.045)
        
        draw.DrawText(ACC2.GetSentence("whitelistTitle"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("whitelistDesc"), "ACC2:Font:14", w*0.025, h*0.07, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(ACC2.GetSentence("jobsList"), "ACC2:Font:17", w*0.25, h*0.145, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("configureJob"), "ACC2:Font:17", w*0.75, h*0.145, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
    end

    modificationContainer = vgui.Create("ACC2:DScroll", whitelistSettings)
    modificationContainer:SetSize(whitelistSettings:GetWide()/2.055, ACC2.ScrH*0.425)
    modificationContainer:SetPos(whitelistSettings:GetWide()/2, ACC2.ScrH*0.1675)

    local whitelistLayout = vgui.Create("DIconLayout", whitelistSettings)
    whitelistLayout:SetSize(ACC2.ScrW*0.25, ACC2.ScrH*0.005)
    whitelistLayout:SetPos(ACC2.ScrW*0.252, ACC2.ScrH*0.128)
    whitelistLayout:SetSpaceY(ACC2.ScrW*0.0022)
    whitelistLayout:SetSpaceX(ACC2.ScrW*0.0022)
    
    local whitelistSelection = vgui.Create("ACC2:SlideButton", whitelistLayout)
    whitelistSelection:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.035)
    whitelistSelection:SetText(ACC2.GetSentence("whitelist"))
    whitelistSelection:SetFont("ACC2:Font:15")
    whitelistSelection:SetTextColor(ACC2.Colors["white"])
    whitelistSelection:InclineButton(0)
    whitelistSelection.MinMaxLerp = {100, 200}
    whitelistSelection:SetIconMaterial(nil)
    whitelistSelection:SetButtonColor(ACC2.Colors["purple"])
    whitelistSelection.DoClick = function()
        if not isstring(ACC2.JobSelected) then return end

        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(10, 4)
            net.WriteUInt(1, 12)
            net.WriteString("whitelisted")
            net.WriteString(ACC2.JobSelected)
        net.SendToServer()
    end
    whitelistSelection.Think = function(self)
        if ACC2.CategorySelected == "whitelisted" then
            self.ACC2Color = ACC2.Colors["purple"]
        else
            self.ACC2Color = ACC2.Colors["grey69"]
        end
    end

    local blacklistSelection = vgui.Create("ACC2:SlideButton", whitelistLayout)
    blacklistSelection:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.035)
    blacklistSelection:SetText(ACC2.GetSentence("blacklist"))
    blacklistSelection:SetFont("ACC2:Font:15")
    blacklistSelection:SetTextColor(ACC2.Colors["white"])
    blacklistSelection:InclineButton(0)
    blacklistSelection.MinMaxLerp = {100, 200}
    blacklistSelection:SetIconMaterial(nil)
    blacklistSelection:SetButtonColor(ACC2.Colors["grey69"])
    blacklistSelection.DoClick = function()
        if not isstring(ACC2.JobSelected) then return end

        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(10, 4)
            net.WriteUInt(1, 12)
            net.WriteString("blacklisted")
            net.WriteString(ACC2.JobSelected)
        net.SendToServer()
    end
    blacklistSelection.Think = function(self)
        if ACC2.CategorySelected == "blacklisted" then
            self.ACC2Color = ACC2.Colors["purple"]
        else
            self.ACC2Color = ACC2.Colors["grey69"]
        end
    end

    local settings = vgui.Create("ACC2:SlideButton", whitelistLayout)
    settings:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.035)
    settings:SetText(ACC2.GetSentence("settings"))
    settings:SetFont("ACC2:Font:15")
    settings:SetTextColor(ACC2.Colors["white"])
    settings:InclineButton(0)
    settings.MinMaxLerp = {100, 200}
    settings:SetIconMaterial(nil)
    settings:SetButtonColor(ACC2.Colors["grey69"])
    settings.DoClick = function()
        reloadWhitelistSettingPanel(ACC2.JobSelected)
    end
    settings.Think = function(self)
        if ACC2.CategorySelected == "settings" then
            self.ACC2Color = ACC2.Colors["purple"]
        else
            self.ACC2Color = ACC2.Colors["grey69"]
        end
    end

    local jobList = vgui.Create("ACC2:DScroll", whitelistSettings)
    jobList:SetSize(whitelistSettings:GetWide()/2.07, ACC2.ScrH*0.382)
    jobList:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.164)

    local searchBar = vgui.Create("ACC2:TextEntry", whitelistSettings)
    searchBar:SetSize(whitelistSettings:GetWide()/2.07, ACC2.ScrH*0.03)
    searchBar:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.1285)
    searchBar:SetPlaceHolder(ACC2.GetSentence("searchBar"))
    searchBar.entry.OnChange = function(self)
        jobList:Clear()

        local value = self:GetValue()

        for k, v in pairs(team.GetAllTeams()) do
            if not v.Joinable then continue end
            if (value != "" && value != nil) && not isnumber(string.find(v.Name:lower(), value:lower())) then continue end
    
            addJob(k, v, jobList, true)
        end
    end

    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        addJob(k, v, jobList)
    end

    local cancel = vgui.Create("ACC2:SlideButton", whitelistSettings)
    cancel:SetSize(whitelistSettings:GetWide()/2.072, ACC2.ScrH*0.041)
    cancel:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.552)
    cancel:SetText(ACC2.GetSentence("cancel"))
    cancel:SetFont("ACC2:Font:15")
    cancel:SetTextColor(ACC2.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(ACC2.Colors["grey69"])
    cancel.DoClick = function()
        if IsValid(whitelistSettings) then whitelistSettings:Remove() end
        ACC2.Settings()
    end

    saveButton = vgui.Create("ACC2:SlideButton", whitelistSettings)
    saveButton:SetSize(whitelistSettings:GetWide()/2.055, ACC2.ScrH*0.041)
    saveButton:SetPos(whitelistSettings:GetWide()/2, ACC2.ScrH*0.552)
    saveButton:SetText(ACC2.GetSentence("saveSettings"))
    saveButton:SetFont("ACC2:Font:15")
    saveButton:SetTextColor(ACC2.Colors["white"])
    saveButton:InclineButton(0)
    saveButton.MinMaxLerp = {100, 200}
    saveButton:SetIconMaterial(nil)
    saveButton:SetButtonColor(ACC2.Colors["purple"])
    saveButton.DoClick = function()
        local jobName = ACC2.JobSelected
        if not isstring(jobName) then return end

        ACC2.WhitelistSettingsTable[jobName] = ACC2.WhitelistSettingsTable[jobName] or {}

        local settingsTable = ACC2.WhitelistSettingsTable[jobName]
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(9, 4)
            net.WriteString(jobName)
            net.WriteBool(settingsTable["whitelistEnable"])
            net.WriteBool(settingsTable["blacklistEnable"])
            net.WriteBool(settingsTable["defaultWhitelist"])
            net.WriteBool(settingsTable["defaultBlacklist"])
            net.WriteUInt(table.Count(settingsTable["permissions"] or {}), 16)
            for k, v in pairs(settingsTable["permissions"] or {}) do
                net.WriteString(k)

                net.WriteBool(v.canManageWhitelist)
                net.WriteBool(v.canManageBlacklist)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", whitelistSettings)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(whitelistSettings:GetWide()*0.94, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        whitelistSettings:Remove()
    end
end

local function modificationPanel(modificationsList, name, panelClass, posX, posY, sizeX, sizeY, callback)
    local modificationPanel = vgui.Create("DPanel", modificationsList)
    modificationPanel:SetSize(0, ACC2.ScrH*0.048)
    modificationPanel:Dock(TOP)
    modificationPanel:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    modificationPanel:SetText("")
    modificationPanel.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local modificationText = vgui.Create("DLabel", modificationPanel)
    modificationText:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.048)
    modificationText:SetPos(ACC2.ScrW*0.008, 0)
    modificationText:SetTextColor(ACC2.Colors["white100"])
    modificationText:SetFont("ACC2:Font:17")
    modificationText:SetText(name)

    local component = vgui.Create(panelClass, modificationPanel)
    component:SetSize(sizeX, sizeY)
    component:SetPos(posX, posY)

    if isfunction(callback) then
        callback(modificationPanel, component)
    end
end

local function addJobCollapstible(k, jobTable, jobList, whitelist, userOpen, canManageWhitelist, canManageBlacklist)
    if not IsValid(jobList) then return end

    ACC2.WhitelistPlayerSettings = ACC2.WhitelistPlayerSettings or {}
    
    local jobButton = vgui.Create("DButton", jobList)
    jobButton:SetSize(0, ACC2.ScrH*0.03)
    jobButton:Dock(TOP)
    jobButton:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    jobButton:SetText("")
    jobButton.deploy = false
    jobButton.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)

        local color = team.GetColor(k)
        
        surface.SetDrawColor(ACC2.Colors["white10"])
        surface.DrawRect(ACC2.ScrW*0.01, ACC2.ScrH*0.03, w*0.93, ACC2.ScrH*0.002)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
        
        color.a = 50

        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, w*0.02, h)

        if not userOpen or canManageWhitelist then
            draw.DrawText(ACC2.GetSentence("whitelistPoint"), "ACC2:Font:17", ACC2.ScrW*0.01, ACC2.ScrH*0.04, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
        end

        if not userOpen or canManageBlacklist then
            draw.DrawText(ACC2.GetSentence("blacklistPoint"), "ACC2:Font:17", ((userOpen && not canManageWhitelist) and ACC2.ScrW*0.01 or ACC2.ScrW*0.12), ACC2.ScrH*0.04, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
        end
    end
    jobButton.DoClick = function(self)
        jobButton.deploy = !jobButton.deploy

        self:SizeTo(-1, (jobButton.deploy and ACC2.ScrH*0.075 or ACC2.ScrH*0.03), 0.5, 0, 0.5)
    end

    local jobName = jobTable.Name

    surface.SetFont("ACC2:Font:17")
    local sizeToggleWhitelist = surface.GetTextSize(ACC2.GetSentence("whitelistPoint"))

    if not userOpen or canManageWhitelist then
        ACC2.WhitelistPlayerSettings[jobName] = ACC2.WhitelistPlayerSettings[jobName] or {}

        local whitelistToggle = vgui.Create("ACC2:Toggle", jobButton)
        whitelistToggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
        whitelistToggle:SetPos(ACC2.ScrW*0.014 + sizeToggleWhitelist, ACC2.ScrH*0.0418)
        whitelistToggle:SetDefaultStatut(tobool(whitelist["whitelisted"]))
        whitelistToggle.OnChange = function(self)
            ACC2.WhitelistPlayerSettings[jobName]["whitelisted"] = self:GetStatut()

            ACC2.WhitelistPlayerSettingsSend[jobName] = true
        end
        ACC2.WhitelistPlayerSettings[jobName]["whitelisted"] = whitelist["whitelisted"]
    end

    if not userOpen or canManageBlacklist then
        surface.SetFont("ACC2:Font:17")
        local sizeToggleBlacklist = surface.GetTextSize(ACC2.GetSentence("blacklistPoint"))

        ACC2.WhitelistPlayerSettings[jobName] = ACC2.WhitelistPlayerSettings[jobName] or {}

        local blacklistToggle = vgui.Create("ACC2:Toggle", jobButton)
        blacklistToggle:SetSize(ACC2.ScrW*0.03, ACC2.ScrH*0.025)
        blacklistToggle:SetPos(((userOpen && not canManageWhitelist) and ACC2.ScrW*0.014 + sizeToggleWhitelist or ACC2.ScrW*0.124 + sizeToggleBlacklist), ACC2.ScrH*0.0418)
        blacklistToggle:SetDefaultStatut(tobool(whitelist["blacklisted"]))
        blacklistToggle.OnChange = function(self)
            ACC2.WhitelistPlayerSettings[jobName]["blacklisted"] = self:GetStatut()

            ACC2.WhitelistPlayerSettingsSend[jobName] = true
        end
        ACC2.WhitelistPlayerSettings[jobName]["blacklisted"] = whitelist["blacklisted"]
    end

    local playerName = vgui.Create("DLabel", jobButton)
    playerName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.03)
    playerName:SetPos(ACC2.ScrW*0.01, 0)
    playerName:SetText(jobName)
    playerName:SetTextColor(ACC2.Colors["white100"])
    playerName:SetFont("ACC2:Font:17")
end

local function reloadJobWhitelist(whitelistScroll, whitelist, searchText)
    local count = 0
    for k, v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        if searchText != nil && searchText != "" && (not v.Name:lower():find(searchText:lower())) then continue end

        local userGroup = ACC2.LocalPlayer:GetUserGroup()

        if not ACC2.AdminRank[userGroup] then
            local permissions = ACC2.WhitelistSettingsTable[v.Name] or {}
            local permission = permissions["permissions"] or {}
            
            local jobPermission = permission[team.GetName(ACC2.LocalPlayer:Team())] or {}
            local userGroupPermission = permission[ACC2.LocalPlayer:GetUserGroup()] or {}

            local canManageWhitelist = jobPermission["canManageWhitelist"] or userGroupPermission["canManageWhitelist"]
            local canManageBlacklist = jobPermission["canManageBlacklist"] or userGroupPermission["canManageBlacklist"]

            if canManageWhitelist or canManageBlacklist then
                local whitelist = whitelist[v.Name] or {}
        
                addJobCollapstible(k, v, whitelistScroll, whitelist, true, canManageWhitelist, canManageBlacklist)

                count = count + 1
            end
        else
            local whitelist = whitelist[v.Name] or {}
        
            addJobCollapstible(k, v, whitelistScroll, whitelist, false)

            count = count + 1
        end
    end

    if count <= 0 && (searchText == nil or searchText == "") then
        if IsValid(managePlayer) then managePlayer:Remove() end
        return
    end
end

local function reloadCharacterInformation(modificationsList, charactersCreated, selectedCharacter, steamId64)
    if not IsValid(modificationsList) or not istable(charactersCreated) or not isnumber(selectedCharacter) then return end

    modificationsList:Clear()

    local admin = ACC2.AdminRank[ACC2.LocalPlayer:GetUserGroup()]

    if admin then
        modificationPanel(modificationsList, ACC2.GetSentence("firstName"), "ACC2:TextEntry", ACC2.ScrW*0.108, ACC2.ScrH*0.009, ACC2.ScrW*0.13, ACC2.ScrH*0.03, function(modificationPanel, component)
            component:SetRounded(4)
            
            local character = charactersCreated[selectedCharacter] or {}
            local name = character["name"]

            if isstring(name) then
                component:SetText(name)
            end

            ACC2.ManagePlayerInfo["name"] = name

            component.Think = function(self)
                ACC2.ManagePlayerInfo["name"] = self:GetText()
            end
        end)

        modificationPanel(modificationsList, ACC2.GetSentence("lastName"), "ACC2:TextEntry", ACC2.ScrW*0.108, ACC2.ScrH*0.009, ACC2.ScrW*0.13, ACC2.ScrH*0.03, function(modificationPanel, component)
            component:SetRounded(4)

            local character = charactersCreated[selectedCharacter] or {}
            local lastName = character["lastName"]

            if isstring(lastName) then
                component:SetText(lastName)
            end

            ACC2.ManagePlayerInfo["lastName"] = lastName

            component.Think = function(self)
                ACC2.ManagePlayerInfo["lastName"] = self:GetText()
            end
        end)

        modificationPanel(modificationsList, ACC2.GetSentence("model"), "ACC2:TextEntry", ACC2.ScrW*0.108, ACC2.ScrH*0.009, ACC2.ScrW*0.13, ACC2.ScrH*0.03, function(modificationPanel, component)
            component:SetRounded(4)

            local character = charactersCreated[selectedCharacter] or {}
            local model = character["model"]

            if isstring(model) then
                component:SetText(model)
            end

            ACC2.ManagePlayerInfo["model"] = model

            component.Think = function(self)
                ACC2.ManagePlayerInfo["model"] = self:GetText()
            end
        end)

        modificationPanel(modificationsList, ACC2.GetSentence("money"), "ACC2:TextEntry", ACC2.ScrW*0.108, ACC2.ScrH*0.009, ACC2.ScrW*0.13, ACC2.ScrH*0.03, function(modificationPanel, component)
            component:SetRounded(4)
            component:SetNumeric(true)

            local character = charactersCreated[selectedCharacter] or {}
            local money = character["money"]

            if isnumber(money) then
                component:SetText(money)
            end

            ACC2.ManagePlayerInfo["money"] = money

            component.Think = function(self)
                ACC2.ManagePlayerInfo["money"] = self:GetText()
            end
        end)
    end

    local whitelistPanel = vgui.Create("DPanel", modificationsList)
    whitelistPanel:SetSize(0, (admin and ACC2.ScrH*0.228 or ACC2.ScrH*0.492))
    whitelistPanel:Dock(TOP)
    whitelistPanel:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
    whitelistPanel:SetText("")
    whitelistPanel.Paint = function(self,w,h)
        surface.SetDrawColor(ACC2.Colors["white5"])
        surface.DrawRect(0, 0, w, h)
    end

    local whitelistText = vgui.Create("DLabel", whitelistPanel)
    whitelistText:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.048)
    whitelistText:SetPos(ACC2.ScrW*0.008, 0)
    whitelistText:SetTextColor(ACC2.Colors["white100"])
    whitelistText:SetFont("ACC2:Font:17")
    whitelistText:SetText(ACC2.GetSentence("manageWhitelist"))

    local whitelistScroll = vgui.Create("ACC2:DScroll", whitelistPanel)
    whitelistScroll:SetPos(ACC2.ScrW*0.008, ACC2.ScrH*0.045)
    whitelistScroll:SetSize(ACC2.ScrW*0.232, (admin and ACC2.ScrH*0.175 or ACC2.ScrH*0.44))
    
    local character = charactersCreated[selectedCharacter] or {}
    local whitelist = character["whitelist"] or {}

    ACC2.WhitelistSettingsTable = ACC2.WhitelistSettingsTable or {}

    reloadJobWhitelist(whitelistScroll, whitelist)

    local searchBar = vgui.Create("ACC2:TextEntry", whitelistPanel)
    searchBar:SetSize(ACC2.ScrW*0.08, ACC2.ScrH*0.025)
    searchBar:SetPos(ACC2.ScrW*0.158, ACC2.ScrH*0.01)
    searchBar:SetRounded(4)
    searchBar:SetPlaceHolder(ACC2.GetSentence("searchBar"))
    searchBar.entry.OnChange = function(self)
        whitelistScroll:Clear()

        reloadJobWhitelist(whitelistScroll, whitelist, searchBar.entry:GetValue())
    end

    if admin then
        local character = charactersCreated[selectedCharacter] or {}
        local deletedAt = character["deletedAt"]

        local deleteButton = vgui.Create("ACC2:SlideButton", modificationsList)
        deleteButton:SetSize(managePlayer:GetWide()/2.055, ACC2.ScrH*0.041)
        deleteButton:Dock(TOP)
        deleteButton:SetText(deletedAt and string.upper(ACC2.GetSentence("enableCharacter")) or string.upper(ACC2.GetSentence("disableCharacter")))
        deleteButton:SetFont("ACC2:Font:15")
        deleteButton:SetTextColor(ACC2.Colors["white"])
        deleteButton:InclineButton(0)
        deleteButton.MinMaxLerp = {100, 200}
        deleteButton:SetIconMaterial(nil)
        deleteButton:SetButtonColor(deletedAt and ACC2.Colors["purple"] or ACC2.Colors["red45"])
        deleteButton.DoClick = function()
            local characterId = tonumber(character["characterId"])
            if not isnumber(characterId) then return end

            if deletedAt then
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(13, 4)
                    net.WriteString(steamId64)
                    net.WriteUInt(characterId, 22)
                net.SendToServer()
            else
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(8, 4)
                    net.WriteString(steamId64)
                    net.WriteUInt(characterId, 22)
                net.SendToServer()
            end
        end
    end
end

function ACC2.CheckPermissionWhitelist(jobName)
    local userGroup = ACC2.LocalPlayer:GetUserGroup()
    if ACC2.AdminRank[userGroup] then return true end

    ACC2.WhitelistSettingsTable = ACC2.WhitelistSettingsTable or {}

    if not ACC2.WhitelistSettingsTable[jobName] then return false end
    if not ACC2.WhitelistSettingsTable[jobName]["permissions"] then return false end

    local returnValue = false
    local permissionTable = ACC2.WhitelistSettingsTable[jobName]["permissions"] or {}

    local teamName = team.GetName(ACC2.LocalPlayer:Team())

    permissionTable[teamName] = permissionTable[teamName] or {}
    permissionTable[userGroup] = permissionTable[userGroup] or {}

    if permissionTable[teamName]["canManageWhitelist"] or permissionTable[userGroup]["canManageWhitelist"] then
        returnValue = true
    end

    if permissionTable[teamName]["canManageBlacklist"] or permissionTable[userGroup]["canManageBlacklist"] then
        returnValue = true
    end

    return returnValue
end

function ACC2.CanOpenWhitelist()
    ACC2.WhitelistSettingsTable = ACC2.WhitelistSettingsTable or {}

    local jobPermissions = ACC2.WhitelistSettingsTable[team.GetName(ACC2.LocalPlayer:Team())] or {}
    local userGroupPermissions = ACC2.WhitelistSettingsTable[ACC2.LocalPlayer:GetUserGroup()] or {}

    if ACC2.AdminRank[ACC2.LocalPlayer:GetUserGroup()] then
        return true
    elseif table.Count(jobPermissions) > 0 then
        return true
    elseif table.Count(userGroupPermissions) > 0 then
        return true
    end

    return false
end

function ACC2.UpdateCharacters(steamId64, charactersCreated)
    charactersCreated = charactersCreated or {}

    if IsValid(managePlayer) then managePlayer:Remove() end

    ACC2.ManagePlayerInfo = {}
    ACC2.WhitelistPlayerSettingsSend = {}

    local tableToSend = {}
    managePlayer = vgui.Create("DFrame")
    managePlayer:SetSize(ACC2.ScrW*0.503, ACC2.ScrH*0.68)
    managePlayer:SetDraggable(false)
    managePlayer:MakePopup()
    managePlayer:SetTitle("")
    managePlayer:ShowCloseButton(false)
    managePlayer:Center()
    managePlayer.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10) 

        surface.SetDrawColor(ACC2.Colors["blackpurple"])
        surface.DrawRect(0, 0, w*0.998, h)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, h*0.02, ACC2.ScrW*0.49, ACC2.ScrH*0.062)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(w/2-ACC2.ScrW*0.49/2, ACC2.ScrH*0.079, ACC2.ScrW*0.243, ACC2.ScrH*0.045)

        surface.SetDrawColor(ACC2.Colors["white20"])
        surface.DrawRect(ACC2.ScrW*0.2515, ACC2.ScrH*0.079, ACC2.ScrW*0.245, ACC2.ScrH*0.045)
        
        draw.DrawText(ACC2.GetSentence("adminMenuPlayers"), "ACC2:Font:13", w*0.025, h*0.02, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(ACC2.GetSentence("adminMenuPlayerDesc"), "ACC2:Font:14", w*0.025, h*0.063, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(ACC2.GetSentence("allCharacters"), "ACC2:Font:17", w*0.25, ACC2.ScrH*0.089, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("modifyCharacter"), "ACC2:Font:17", w*0.75, ACC2.ScrH*0.089, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
    end

    charactersList = vgui.Create("ACC2:DScroll", managePlayer)
    charactersList:SetSize(managePlayer:GetWide()/2.07, ACC2.ScrH*0.492)
    charactersList:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.1285)

    local selectedCharacter, firstSelected
    for k, v in pairs(charactersCreated) do
        if not firstSelected then
            selectedCharacter = k
            firstSelected = true
        end

        if characterSelected == k then
            selectedCharacter = k
        end
        
        local characterButton = vgui.Create("DButton", charactersList)
        characterButton:SetSize(0, ACC2.ScrH*0.048)
        characterButton:Dock(TOP)
        characterButton:DockMargin(0, 0, 0, ACC2.ScrH*0.006)
        characterButton:SetText("")
        characterButton.Paint = function(self,w,h)
            surface.SetDrawColor(ACC2.Colors["white5"])
            surface.DrawRect(0, 0, w, h)

            if v.deletedAt then
                surface.SetDrawColor(ACC2.Colors["red150"])
                surface.DrawOutlinedRect(0, 0, w, h, ACC2.ScrH*0.003)
            end
        end

        local characterModel = vgui.Create("SpawnIcon", characterButton)
        characterModel:SetSize(ACC2.ScrH*0.04, ACC2.ScrH*0.04)
        characterModel:SetPos(ACC2.ScrW*0.005, ACC2.ScrH*0.005)
        characterModel:SetModel(v.model)
        characterModel:SetTooltip(false)
        characterModel.Think = function() end
        characterModel.PerformLayout = function() end
    
        local characterName = vgui.Create("DLabel", characterButton)
        characterName:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.028)
        characterName:SetPos(ACC2.ScrW*0.0305, 0)
        characterName:SetText(("%s (%s) "..ACC2.GetFormatedName(v.name, v.lastName)):format((v.deletedAt and "[DELETED]" or ""), v.characterId))
        characterName:SetTextColor(ACC2.Colors["white100"])
        characterName:SetFont("ACC2:Font:19")
    
        local characterJob = vgui.Create("DLabel", characterButton)
        characterJob:SetSize(ACC2.ScrW*0.19, ACC2.ScrH*0.028)
        characterJob:SetPos(ACC2.ScrW*0.0305, ACC2.ScrH*0.02)
        characterJob:SetText((v.job or ACC2.GetSentence("invalid")))
        characterJob:SetTextColor(ACC2.Colors["white100"])
        characterJob:SetFont("ACC2:Font:18")
    
        local lerpColor = table.Copy(ACC2.Colors["grey69"])
        local lerpAlpha = 0

        local editButton = vgui.Create("DButton", characterButton)
        editButton:SetSize(ACC2.ScrH*0.04, ACC2.ScrH*0.04)
        editButton:SetPos(ACC2.ScrW*0.2185, ACC2.ScrH*0.004)
        editButton:SetText("")
        editButton.Paint = function(self,w,h)
            lerpColor = ACC2.LerpColor(FrameTime()*5, lerpColor, ACC2.Colors[((selectedCharacter == k) and "purple" or "grey69")])
            lerpAlpha = Lerp(FrameTime()*5, lerpAlpha, (self:IsHovered() and 100 or 200))
            lerpColor = ColorAlpha(lerpColor, lerpAlpha)

            surface.SetDrawColor(lerpColor)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(ACC2.Colors["white100"])
            surface.SetMaterial(ACC2.Materials["icon_edit"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        editButton.DoClick = function()
            selectedCharacter = k
            reloadCharacterInformation(modificationsList, charactersCreated, selectedCharacter, steamId64)
        end
    end

    modificationsList = vgui.Create("ACC2:DScroll", managePlayer)
    modificationsList:SetSize(managePlayer:GetWide()/2.055, ACC2.ScrH*0.5)
    modificationsList:SetPos(managePlayer:GetWide()/2, ACC2.ScrH*0.1285)
    
    if selectedCharacter then
        reloadCharacterInformation(modificationsList, charactersCreated, selectedCharacter, steamId64)
    end

    local cancel = vgui.Create("ACC2:SlideButton", managePlayer)
    cancel:SetSize(managePlayer:GetWide()/2.072, ACC2.ScrH*0.041)
    cancel:SetPos(ACC2.ScrW*0.0065, ACC2.ScrH*0.625)
    cancel:SetText(ACC2.GetSentence("cancel"))
    cancel:SetFont("ACC2:Font:15")
    cancel:SetTextColor(ACC2.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(ACC2.Colors["grey69"])    
    cancel.DoClick = function()
        ACC2.ManagePlayers()
    end

    local saveInformations = vgui.Create("ACC2:SlideButton", managePlayer)
    saveInformations:SetSize(managePlayer:GetWide()/2.055, ACC2.ScrH*0.041)
    saveInformations:SetPos(managePlayer:GetWide()/2, ACC2.ScrH*0.625)
    saveInformations:SetText(ACC2.GetSentence("saveCharacterInformation"))
    saveInformations:SetFont("ACC2:Font:15")
    saveInformations:SetTextColor(ACC2.Colors["white"])
    saveInformations:InclineButton(0)
    saveInformations.MinMaxLerp = {100, 200}
    saveInformations:SetIconMaterial(nil)
    saveInformations:SetButtonColor(ACC2.Colors["purple"])
    saveInformations.DoClick = function()
        if not isnumber(selectedCharacter) then return end
         
        net.Start("ACC2:Admin:Configuration")
            net.WriteUInt(7, 4)
            net.WriteBool(false)
            net.WriteString(steamId64)
            net.WriteUInt(selectedCharacter, 22)

            if ACC2.AdminRank[ACC2.LocalPlayer:GetUserGroup()] then
                local money = tonumber(ACC2.ManagePlayerInfo["money"])

                net.WriteString(ACC2.ManagePlayerInfo["name"])
                net.WriteString(ACC2.ManagePlayerInfo["lastName"])
                net.WriteString(ACC2.ManagePlayerInfo["model"])
                net.WriteUInt(money, 32)
            end
            
            net.WriteUInt(table.Count(ACC2.WhitelistPlayerSettingsSend), 16)
            
            for k, v in pairs(ACC2.WhitelistPlayerSettingsSend) do
                local values = ACC2.WhitelistPlayerSettings[k]

                net.WriteString(k)
                net.WriteBool(values.whitelisted)
                net.WriteBool(values.blacklisted)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", managePlayer)
    close:SetSize(ACC2.ScrH*0.026, ACC2.ScrH*0.026)
    close:SetPos(managePlayer:GetWide()*0.94, ACC2.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        managePlayer:Remove()
    end
end

hook.Add("ACC2:Loaded:Settings", "ACC2:Reload:ContextIntegration", function()
    properties.Add("ACC2:Whitelist", {
        MenuLabel = "ACC2:Whitelist",
        Order = 1,
        MenuIcon = "icon16/group_add.png",
        MenuOpen = function(tbl, dMenu, dMenuOption)
            local ply = dMenuOption
            if not IsValid(ply) && not ply:IsPlayer() then return end
    
            local whitelistCollapse = dMenu:AddSubMenu(ACC2.GetSentence("distance"))
    
            local pnl = whitelistCollapse:GetChildren()[1]
            
            dMenu:SetFont("ACC2:Font:17")
            dMenu:SetTextColor(ACC2.Colors["white100"])
    
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["grey69"])
                surface.DrawRect(0, 0, w, h)
            end
    
            dMenu.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["grey69"])
                surface.DrawRect(0, 0, w, h)
            end
    
            local openMenu = whitelistCollapse:AddOption(ACC2.GetSentence("openMenu"))
            openMenu:SetIcon("icon16/page_edit.png")
            openMenu:SetFont("ACC2:Font:17")
            openMenu:SetTextColor(ACC2.Colors["white100"])
            openMenu.DoClick = function()
                net.Start("ACC2:Admin:Configuration")
                    net.WriteUInt(6, 4)
                    net.WriteString(ply:SteamID64())
                net.SendToServer()
            end
    
            local whitelist, parent = whitelistCollapse:AddSubMenu(ACC2.GetSentence("whitelist"))
            parent:SetIcon("icon16/add.png")
            parent:SetFont("ACC2:Font:17")
            parent:SetTextColor(ACC2.Colors["white100"])
    
            local pnl = parent:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["grey69"])
                surface.DrawRect(0, 0, w, h)
            end
    
            for k, v in pairs(team.GetAllTeams()) do
                if not v.Joinable then continue end
    
                local jobName = team.GetName(k)
                if not ACC2.CheckPermissionWhitelist(jobName) then continue end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */
    
                local job = whitelist:AddOption(jobName, function()
                    local characterId = tonumber(ACC2.GetNWVariables("characterId", ply))
                    if not isnumber(characterId) then return end
    
                    net.Start("ACC2:Admin:Configuration")
                        net.WriteUInt(7, 4)
                        net.WriteBool(true)
                        net.WriteString(ply:SteamID64())
                        net.WriteUInt(characterId, 22)
                        net.WriteUInt(1, 16)
                        net.WriteString(jobName)
                        net.WriteBool(true)
                        net.WriteBool(nil)
                    net.SendToServer()
                end)
                job:SetIcon("icon16/user_gray.png")
                job:SetFont("ACC2:Font:17")
                job:SetTextColor(ACC2.Colors["white100"])
    
                local pnl = job:GetChildren()[1]
    
                pnl.Paint = function(self, w, h)
                    surface.SetDrawColor(team.GetColor(k))
                    surface.DrawRect(0, 0, w, h)
                end
            end
    
            local blacklist, parent = whitelistCollapse:AddSubMenu(ACC2.GetSentence("blacklist"))
            parent:SetIcon("icon16/delete.png")
            parent:SetFont("ACC2:Font:17")
            parent:SetTextColor(ACC2.Colors["white100"])
    
            local pnl = parent:GetChildren()[1]
            pnl.Paint = function(self, w, h)
                surface.SetDrawColor(ACC2.Colors["grey69"])
                surface.DrawRect(0, 0, w, h)
            end
    
            for k, v in pairs(team.GetAllTeams()) do
                if not v.Joinable then continue end
    
                local jobName = team.GetName(k)
                if not ACC2.CheckPermissionWhitelist(jobName) then continue end
    
                local job = blacklist:AddOption(jobName, function()
                    local characterId = tonumber(ACC2.GetNWVariables("characterId", ply))
                    if not isnumber(characterId) then return end
    
                    net.Start("ACC2:Admin:Configuration")
                        net.WriteUInt(7, 4)
                        net.WriteBool(true)
                        net.WriteString(ply:SteamID64())
                        net.WriteUInt(characterId, 22)
                        net.WriteUInt(1, 16)
                        net.WriteString(jobName)
                        net.WriteBool(nil)
                        net.WriteBool(true)
                    net.SendToServer()
                end)
                job:SetIcon("icon16/user_gray.png")
                job:SetFont("ACC2:Font:17")
                job:SetTextColor(ACC2.Colors["white100"])
    
                local pnl = job:GetChildren()[1]
    
                pnl.Paint = function(self, w, h)
                    surface.SetDrawColor(team.GetColor(k))
                    surface.DrawRect(0, 0, w, h)
                end
            end
        end,
        Filter = function(self, ent, ply)
            if not IsValid(ent) or not ent:IsPlayer() then return false end
            if not ACC2.GetSetting("enableContextToWhitelist", "boolean") then return false end
            if not ACC2.GetNWVariables("characterId", ent) then return false end
            if not ACC2.CanOpenWhitelist() then return false end
    
            return true
        end,
        Action = function() end,
    })
end)

net.Receive("ACC2:Admin:Configuration", function()
    local uInt = net.ReadUInt(4)
    --[[ Get all settings ]]
    if uInt == 1 then
        local settingsCount = net.ReadUInt(12)
        
        for i=1, settingsCount do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))
            
            ACC2.DefaultSettings[key] = value
            
            if key == "serverLogo" then
                ACC2.CacheMaterial(value, "serverLogo")
            end
        end

        hook.Run("ACC2:Loaded:Settings")
        --[[ Open the settings menu ]]
    elseif uInt == 2 then
        ACC2.Settings()
    elseif uInt == 3 then
        ACC2.AdminMenuFaction()
    elseif uInt == 4 then
        local steamId64 = net.ReadString()

        local characterDeleted = net.ReadBool()
        local characterIdDeleted = net.ReadUInt(22)

        ACC2.ViewCharacters = ACC2.ViewCharacters or {}

        if ACC2.ViewCharacters[characterIdDeleted] then
            ACC2.ViewCharacters[characterIdDeleted]["deletedAt"] = characterDeleted
        end

        if table.Count(ACC2.ViewCharacters) >= 1 then
            ACC2.UpdateCharacters(steamId64, ACC2.ViewCharacters)
        else
            ACC2.ManagePlayers()
        end
    elseif uInt == 5 then
        ACC2.WhitelistSettingsTable = {}
        
        local tableCount = net.ReadUInt(16)
        
        for i=1, tableCount do
            local jobName = net.ReadString()
            local whitelistEnable = net.ReadBool()
            local blacklistEnable = net.ReadBool()
            local defaultWhitelist = net.ReadBool()
            local defaultBlacklist = net.ReadBool()

            local permissions = {}
            local permissionsCount = net.ReadUInt(16)
            for i=1, permissionsCount do
                local keyName = net.ReadString()
                local canManageWhitelist = net.ReadBool()
                local canManageBlacklist = net.ReadBool()

                permissions[keyName] = {
                    ["canManageWhitelist"] = canManageWhitelist,
                    ["canManageBlacklist"] = canManageBlacklist,
                }
            end

            ACC2.WhitelistSettingsTable[jobName] = {
                ["jobName"] = jobName,
                ["whitelistEnable"] = whitelistEnable,
                ["blacklistEnable"] = blacklistEnable,
                ["defaultWhitelist"] = defaultWhitelist,
                ["defaultBlacklist"] = defaultBlacklist,
                ["permissions"] = permissions,
            }
        end
    elseif uInt == 6 then
        ACC2.WhitelistSettings()
    elseif uInt == 7 then
        local countTable = net.ReadUInt(6)
        local countValues = net.ReadUInt(32)
        local page = net.ReadUInt(16)
        local whitelistType = net.ReadString()
        local jobName = net.ReadString()
        local pageReturn = {}
        
        for i=1, countTable do
            local ownerId64 = net.ReadString()
            local globalName = net.ReadString()
            local characterId = net.ReadUInt(22)

            pageReturn[#pageReturn + 1] = {
                ["ownerId64"] = ownerId64,
                ["globalName"] = globalName,
                ["characterId"] = characterId,
            }
        end

        local playersCount = net.ReadUInt(8)
        local whitelisted = {}

        for i=1, playersCount do
            local value = net.ReadString()

            whitelisted[value] = true
        end

        pageSelected = page + 1
        ACC2.CategorySelected = whitelistType
        ACC2.JobSelected = jobName

        modificationContainer:SetSize(whitelistSettings:GetWide()/2.055, ACC2.ScrH*0.425)

        reloadWhitelistPlayers(pageReturn, countValues, whitelistType, ACC2.JobSelected, pageSelected, whitelisted)
    elseif uInt == 8 then
        ACC2.ManagePlayers()
    elseif uInt == 9 then
        local countCompatibilities = net.ReadUInt(8)

        ACC2.ParametersConfig = ACC2.ParametersConfig or {}
        ACC2.ParametersConfig["compatibilitiesList"] = {}

        for i=1, countCompatibilities do
            local compatibilitiesName = net.ReadString()

            ACC2.ParametersConfig["compatibilitiesList"][#ACC2.ParametersConfig["compatibilitiesList"] + 1] = {
                {
                    ["class"] = "ACC2:CheckBox",
                    ["text"] = ACC2.GetSentence("enableCompatibility"):format(compatibilitiesName),
                    ["sizeX"] = 0.02,
                    ["sizeY"] = 0.02,
                    ["posX"] = 0.51,
                    ["posY"] = 0.015,
                    ["func"] = function(pnl, panelLink)
                        ACC2.AdvancedConfiguration["settings"] = {}
    
                        pnl:SetActive(tobool(ACC2.DefaultSettings[compatibilitiesName]))
    
                        pnl.OnChange = function(self, bChecked)
                            ACC2.AdvancedConfiguration["settings"][compatibilitiesName] = bChecked
                        end
                    end,
                },
            }
        end
    end
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
