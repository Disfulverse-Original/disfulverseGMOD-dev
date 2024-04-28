/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local boneName, clientSideModelColor, lerpBack = "ValveBiped.Bip01_Head1", AAS.Colors["whiteConfig"], false

local function addLabel(scroll, text)
    if not IsValid(scroll) then return end 

    local dLabel = vgui.Create("DLabel", scroll)
    dLabel:SetText(text)
    dLabel:SetFont("AAS:Font:03")
    dLabel:SetTextColor(AAS.Colors["white"])
    dLabel:DockMargin(0,0,0,AAS.ScrH*0.003)
end

local function getItemSettings(typeSet)
    local tbl = AAS.ClientTable["AdminPos"] or {}
    for i=1, 3 do tbl[i] = tbl[i] or {} end 

    if typeSet == "pos" then 
        return Vector((tbl[1][typeSet] or 0), (tbl[2][typeSet] or 0), (tbl[3][typeSet] or 0))
    elseif typeSet == "rotate" then 
        return Angle((tbl[1][typeSet] or 0), (tbl[2][typeSet] or 0), (tbl[3][typeSet] or 0))
    elseif typeSet == "scale" then 
        return Vector((tbl[1][typeSet] or 1), (tbl[2][typeSet] or 1), (tbl[3][typeSet] or 1))
    end
end

local function sliderMove(x, y, panel, title, name, model)
    local sliderPanel = vgui.Create("DPanel", panel)
    sliderPanel:SetSize(AAS.ScrW*0.33, AAS.ScrH*0.17)
    sliderPanel:SetPos(x, y)

    sliderPanel.Paint = function(self,w,h)
        draw.RoundedBoxEx(8, 0, 0, w, h, AAS.Colors["black18230"], false, false, true, true)
        draw.RoundedBox(4, 0, 0, w, h*0.24, AAS.Colors["grey53"])
        draw.RoundedBox(0, 0, h*0.26, w, h*0.05, AAS.Colors["black18100"])
        
        draw.DrawText(title, "AAS:Font:05", w/2, h*0.04, AAS.Colors["white"], TEXT_ALIGN_CENTER)
    end 
    
    local uniqueId = istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].uniqueId or nil

    AAS.ClientTable["ItemsOffsetModel"] = AAS.ClientTable["ItemsOffsetModel"] or {}
    
    local offset = AAS.ClientTable["ItemsOffsetModel"][uniqueId] or {}
    local mdl = string.lower((model or ""))
    local offsetModel = offset[mdl] or {}

    for i=1, 3 do 
        local slider = vgui.Create("AAS:Slider", sliderPanel)
        slider:SetPos(0, i*AAS.ScrH*0.04)
        slider:ChangeBackground(false)
        slider:SetSize(AAS.ScrW*0.35, AAS.ScrH*0.1)
        slider.Slider:SetSize(AAS.ScrW*0.292, AAS.ScrH*0.01)
        
        if name == "pos" then
            slider.Slider:SetMin(-100)
            slider.Slider:SetMax(100)
            slider.Slider:SetValue(0)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */
            
            if offsetModel["pos"] then
                slider.Slider:SetValue(offsetModel["pos"][i])
            else
                if istable(AAS.ClientTable["ItemSelected"]) and isvector(AAS.ClientTable["ItemSelected"].pos) then 
                    slider.Slider:SetValue(AAS.ClientTable["ItemSelected"].pos[i])
                end 
            end
        elseif name == "rotate" then
            slider.Slider:SetMin(-360)
            slider.Slider:SetMax(360)
            slider.Slider:SetValue(0)
                
            if offsetModel["ang"] then
                slider.Slider:SetValue(offsetModel["ang"][i])
            else
                if istable(AAS.ClientTable["ItemSelected"]) and isangle(AAS.ClientTable["ItemSelected"].ang) then 
                    slider.Slider:SetValue(AAS.ClientTable["ItemSelected"].ang[i])
                end
            end
        end 

        if name == "scale" then
            local scaleVector = IsValid(AASClientSide) and AASClientSide:GetManipulateBoneScale(1) or Vector(1,1,1)
            local scaleTbl = {
                [1] = scaleVector.x,
                [2] = scaleVector.y,
                [3] = scaleVector.z
            }
            
            slider.Slider:SetMin(-5)
            slider.Slider:SetMax(5)
            slider.Slider:SetValue(scaleTbl[i])

            if offsetModel["scale"] then
                slider.Slider:SetValue(offsetModel["scale"][i])
            else
                if istable(AAS.ClientTable["ItemSelected"]) and isvector(AAS.ClientTable["ItemSelected"].scale) then 
                    slider.Slider:SetValue(AAS.ClientTable["ItemSelected"].scale[i])
                end
            end

            slider:SetAccurateNumber(0.002)
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */
        
        AAS.ClientTable["AdminPos"][i] = AAS.ClientTable["AdminPos"][i] or {}
        AAS.ClientTable["AdminPos"][i][name] = slider.Slider:GetValue()
        
        slider.Slider.OnValueChanged = function()
            AAS.ClientTable["AdminPos"][i][name] = slider.Slider:GetValue()
        end
    end 
end

local itemModel, skinList, panelBack, playerModelAdmin, modelChoice
local itemName, itemPrice, categoryList, itemDesc, itemColor, itemNew, itemVip

function AAS.settingsScroll(panel, posy, sizey, editItem, title, rightPos, modifyPos)
    if IsValid(sliderList) then sliderList:Remove() end
    if IsValid(panelBack) then panelBack:Remove() end

    for i=1, 4 do AAS.ClientTable["ResizeIcon"][i] = 0 end
    
    if istable(AAS.ClientTable["ItemSelected"]) then
        local pos = AAS.ClientTable["ItemSelected"].pos
        local ang = AAS.ClientTable["ItemSelected"].ang
        local scale = AAS.ClientTable["ItemSelected"].scale
        
        for i=1, 3 do
            if not isvector(pos) or not isangle(ang) or not isvector(scale) then continue  end
            AAS.ClientTable["AdminPos"][i] = AAS.ClientTable["AdminPos"][i] or {}
        end
    end
    
    clientSideModelColor = AAS.Colors["whiteConfig"]
    
    --[[ Global for know when the menu was open ]]
    sliderList = vgui.Create("AAS:ScrollPanel", panel)
    sliderList:SetSize(AAS.ScrW*0.19, sizey)
    sliderList:SetPos(panel:GetWide() - AAS.ScrW*0.195, posy)
    sliderList:DockMargin(0,AAS.ScrH*0.01,0,-AAS.ScrH*0.01)

    addLabel(sliderList, AAS.GetSentence("name"))


    itemName = vgui.Create("AAS:TextEntry", sliderList)
    itemName:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemName:SetHoldText(AAS.GetSentence("itemName"))
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemName:SetText(AAS.ClientTable["ItemSelected"].name) end

    addLabel(sliderList, AAS.GetSentence("desc"))

    itemDesc = vgui.Create("AAS:TextEntry", sliderList)
    itemDesc:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemDesc:SetHoldText(AAS.GetSentence("description"))
    itemDesc:SetSize(0,AAS.ScrH*0.065)
    itemDesc:SetMultiline(true)
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemDesc:SetText(AAS.ClientTable["ItemSelected"].description) end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5 */

    if editItem then
        addLabel(sliderList, AAS.GetSentence("itemUniqueId"))

        local itemId = vgui.Create("AAS:TextEntry", sliderList)
        itemId:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        itemId:SetEditable(false)
        if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemId:SetText(AAS.ClientTable["ItemSelected"].uniqueId) end
    end

    addLabel(sliderList, AAS.GetSentence("model"))

    itemModel = vgui.Create("AAS:TextEntry", sliderList)
    itemModel:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemModel:SetHoldText("models/props_junk/TrafficCone001a.mdl")
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemModel:SetText(AAS.ClientTable["ItemSelected"].model) end

    itemModel.OnChange = function()
        if IsValid(skinList) then
            skinList:Clear()

            for i=0, NumModelSkins(itemModel:GetText()) do
                skinList:AddChoice(i)
            end

            skinList:SetValue(0)
        end
    end

    addLabel(sliderList, AAS.GetSentence("itemPrice"))

    itemPrice = vgui.Create("AAS:TextEntry", sliderList)
    itemPrice:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.008)
    itemPrice:SetHoldText("1000")
    itemPrice:SetNumeric(true)
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemPrice:SetText(AAS.ClientTable["ItemSelected"].price) end

    itemColor = vgui.Create( "DColorMixer", sliderList)
    itemColor:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemColor:SetSize(0, AAS.ScrH*0.2)
    itemColor:SetWangs(false)
    itemColor:SetColor(AAS.Colors["white"])
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and istable(AAS.ClientTable["ItemSelected"].options.color) then itemColor:SetColor(AAS.ClientTable["ItemSelected"].options.color) end

    itemColor.ValueChanged = function(panel, color)
        clientSideModelColor = color
    end

    addLabel(sliderList, AAS.GetSentence("choosecategory"))

    itemCategory = vgui.Create("AAS:ComboBox", sliderList)
    itemCategory:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.027)
    itemCategory:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemCategory:SetText(AAS.GetSentence("combocategory"))

    for k,v in ipairs(AAS.Category["mainMenu"]) do
        if istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].category == v.uniqueName then
            boneName = v.bone
        end

        if v.all then continue end
        itemCategory:AddChoice(v.uniqueName, v.bone)
    end

    itemCategory.OnSelect = function(self, index, value)
        local data = self:GetOptionData(self:GetSelectedID())
        boneName = data
    end
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and isstring(AAS.ClientTable["ItemSelected"].category) then itemCategory:SetValue(AAS.ClientTable["ItemSelected"].category) end
      
    if modifyPos then
        addLabel(sliderList, AAS.GetSentence("itemPos"))

        local posSetup = vgui.Create("DButton", sliderList)
        posSetup:DockMargin(0,0,AAS.ScrH*0.006, AAS.ScrH*0.006)
        posSetup:SetText("")
        posSetup:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.027)

        posSetup.Paint = function(self,w,h)
            draw.RoundedBox(3, 0, 0, w, h, AAS.Colors["black18"])
            draw.SimpleText(AAS.GetSentence("modifypos"), "AAS:Font:03", w*0.02, h/2.1, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        posSetup.DoClick = function()
            AAS.PositionSettings(editItem, playerModel, itemModel:GetText(), tonumber(skinList:GetValue()))
        end
    end

    addLabel(sliderList, AAS.GetSentence("chooseskin"))

    skinList = vgui.Create("AAS:ComboBox", sliderList)
    skinList:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.027)
    skinList:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    skinList:SetText(AAS.GetSentence("comboskin"))

    for i=0, NumModelSkins(itemModel:GetText()) do
        skinList:AddChoice(i)
    end

    if editItem and istable(AAS.ClientTable["ItemSelected"]) and isnumber(tonumber(AAS.ClientTable["ItemSelected"].options.skin)) then skinList:SetValue(AAS.ClientTable["ItemSelected"].options.skin) end

    local buttonlist = vgui.Create("AAS:ScrollPanel", sliderList)
    buttonlist:SetSize(0, AAS.ScrH*0.05)
    buttonlist:DockMargin(0,AAS.ScrH*0.01,0,-AAS.ScrH*0.01)

    itemVip = vgui.Create("AAS:Button", buttonlist)
    itemVip:SetTheme(true)
    itemVip:DockMargin(10,0,65,0)
    itemVip:Dock(RIGHT)
    itemVip:ChangeStatut()
    itemVip.DoClick = function()
        itemVip:ChangeStatut()
    end 
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].options.vip then itemVip:ChangeStatut() end
    
    itemNew = vgui.Create("AAS:Button", buttonlist)
    itemNew:SetTheme(false)
    itemNew:DockMargin(200,0,0,0)
    itemNew:Dock(LEFT)
    itemNew:ChangeStatut()
    itemNew.DoClick = function()
        itemNew:ChangeStatut()
    end 
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].options.new then itemNew:ChangeStatut() end

    addLabel(sliderList, AAS.GetSentence("titleactivate"))

    local activateList = vgui.Create("AAS:ComboBox", sliderList)
    activateList:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.025)
    activateList:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    activateList:AddChoice(AAS.GetSentence("activate"), true)
    activateList:AddChoice(AAS.GetSentence("desactivate"), false)
    activateList:ChooseOptionID(1)
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and isbool(AAS.ClientTable["ItemSelected"].options.activate) then activateList:ChooseOptionID(AAS.ClientTable["ItemSelected"].options.activate and 1 or 2) end

    addLabel(sliderList, AAS.GetSentence("itemJob"))

    local jobTable = {}
    for k, v in ipairs(team.GetAllTeams()) do 
        if k == 0 then continue end
        
        local jobPanel = vgui.Create("DButton", sliderList)
        jobPanel:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        jobPanel:SetText("")
        jobPanel.Paint = function(self,w,h)
            draw.RoundedBox(3, 0, 0, w, h, AAS.Colors["black18"])
            draw.SimpleText(v.Name, "AAS:Font:03", w*0.02, h/2.1, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        
        local checkBox = vgui.Create("AAS:CheckBox", jobPanel)
        checkBox:SetSize(AAS.ScrH*0.015, AAS.ScrH*0.0155)
        checkBox:SetPos(sliderList:GetWide()*0.9, jobPanel:GetTall()*0.5 - AAS.ScrH*0.015/2)
        checkBox:SetValue(false)

        if istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].job[v.Name] then 
            jobTable[v.Name] = true
            checkBox:SetValue(true)
        end
        checkBox.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            jobTable[v.Name] = (bool and true or nil)
        end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */
        
        jobPanel.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            jobTable[v.Name] = (bool and true or nil)
        end 
    end

    addLabel(sliderList, AAS.GetSentence("rankBlackList"))

    local rankTable = {}
    for k,v in pairs(CAMI.GetUsergroups()) do 
        local rankPanel = vgui.Create("DButton", sliderList)
        rankPanel:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        rankPanel:SetText("")
        rankPanel.Paint = function(self,w,h)
            draw.RoundedBox(3, 0, 0, w, h, AAS.Colors["black18"])
            draw.SimpleText(k, "AAS:Font:03", w*0.02, h/2.1, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        
        local checkBox = vgui.Create("AAS:CheckBox", rankPanel)
        checkBox:SetSize(AAS.ScrH*0.015, AAS.ScrH*0.0155)
        checkBox:SetPos(sliderList:GetWide()*0.9, rankPanel:GetTall()*0.5 - AAS.ScrH*0.015/2)
        checkBox:SetValue(true)

        if istable(AAS.ClientTable["ItemSelected"]) and istable(AAS.ClientTable["ItemSelected"].options.usergroups) then
            if AAS.ClientTable["ItemSelected"].options.usergroups[k] == true then
            
                rankTable[k] = true
                checkBox:SetValue(false)
            end
        end

        checkBox.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            rankTable[k] = !bool
        end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796
        
        rankPanel.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            rankTable[k] = !bool
        end 
    end

    if not IsValid(mainPanel) then
        addLabel(sliderList, AAS.GetSentence("iconPos"))
        
        for i=1, 4 do
            if i == 4 then 
                addLabel(sliderList, AAS.GetSentence("iconFov"))                
            end

            local slider = vgui.Create("AAS:Slider", sliderList)
            slider:DockMargin(0,0,AAS.ScrW*0.003,AAS.ScrH*0.006)
            slider.Slider:SetMin(-100)
            slider.Slider:SetMax(100)

            slider.rightButton:SetX(slider.rightButton:GetX() - AAS.ScrW*0.005)
            slider.Slider:SetWide(slider.Slider:GetWide() - AAS.ScrW*0.005)

            if istable(AAS.ClientTable["ItemSelected"]) then
                if i == 4 then
                    if isnumber(AAS.ClientTable["ItemSelected"]["options"]["iconFov"]) then
                        slider.Slider:SetValue(AAS.ClientTable["ItemSelected"]["options"]["iconFov"])
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconFov"]
                    end
                elseif i < 4 then
                    if isvector(AAS.ClientTable["ItemSelected"]["options"]["iconPos"]) then
                        slider.Slider:SetValue(AAS.ClientTable["ItemSelected"]["options"]["iconPos"][i])
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconPos"][i]
                    end
                end
            end

            slider.Slider.OnValueChanged = function(self, value)
                AAS.ClientTable["ResizeIcon"][i] = value
            end
        end
    else
        for i=1, 4 do
            if istable(AAS.ClientTable["ItemSelected"]) then
                if i == 4 then
                    if isnumber(AAS.ClientTable["ItemSelected"]["options"]["iconFov"]) then
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconFov"]
                    end
                elseif i < 4 then
                    if isvector(AAS.ClientTable["ItemSelected"]["options"]["iconPos"]) then
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconPos"][i]
                    end
                end
            end
        end
    end
    
    panelBack = vgui.Create("DPanel", panel)
    panelBack:SetSize(AAS.ScrW*0.197, AAS.ScrH*0.04)
    panelBack:SetPos(rightPos and accessoriesFrame:GetWide()*0.67 or AAS.ScrW*0.006, rightPos and AAS.ScrH*0.065 or AAS.ScrH*0.01)
    panelBack.Paint = function(self,w,h)
        draw.DrawText((title or ""), "AAS:Font:04", w*0.02, h*0.1, AAS.Colors["white"], TEXT_ALIGN_LEFT)
        draw.RoundedBox(0, w*0.025, h*0.93, w*0.94, AAS.ScrH*0.002, AAS.Colors["white"])
    end
    
    local lerpFirstButton = 255
    local firstButton = vgui.Create("DButton", panelBack)
    firstButton:SetSize(AAS.ScrW*0.055, AAS.ScrH*0.027)
    firstButton:SetPos(panelBack:GetWide()*0.685, AAS.ScrH*0.0)
    firstButton:SetFont("AAS:Font:04")
    firstButton:SetTextColor(AAS.Colors["white"])
    firstButton:SetText(AAS.GetSentence("cancel"))
    firstButton.Paint = function(self,w,h)
        lerpFirstButton = Lerp(FrameTime()*10, lerpFirstButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["red49"], lerpFirstButton))
    end 
    firstButton.DoClick = function()
        if AAS.ClientTable["Id"] == 1 then 
            panel:Remove()
            AAS.ItemMenu()
        elseif AAS.ClientTable["Id"] == 2 then
            AAS.AdminSetting()
        end
    end 

    local lerpSecondButton = 255
    local secondButton = vgui.Create("DButton", panelBack)
    secondButton:SetSize(AAS.ScrW*0.065, AAS.ScrH*0.027)
    secondButton:SetPos(panelBack:GetWide()*0.33, AAS.ScrH*0.0)
    secondButton:SetFont("AAS:Font:04")
    secondButton:SetTextColor(AAS.Colors["white"])
    secondButton:SetText(AAS.GetSentence("save"))
    secondButton.Paint = function(self,w,h)
        lerpSecondButton = Lerp(FrameTime()*10, lerpSecondButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["selectedBlue"], lerpSecondButton))
    end
    secondButton.DoClick = function()
        local activate = activateList:GetOptionData(activateList:GetSelectedID()) or false
        local options = istable(AAS.ClientTable["ItemSelected"]) and (table.Copy(isstring(AAS.ClientTable["ItemSelected"]["options"]) and util.JSONToTable(AAS.ClientTable["ItemSelected"]["options"]) or AAS.ClientTable["ItemSelected"]["options"]) or {}) or {}

        options["new"] = itemNew:GetStatut()
        options["vip"] = itemVip:GetStatut()
        options["activate"] = activate
        options["color"] = itemColor:GetColor()
        options["bone"] = boneName
        options["iconFov"] = AAS.ClientTable["ResizeIcon"][4]
        options["iconPos"] = Vector(AAS.ClientTable["ResizeIcon"][1], AAS.ClientTable["ResizeIcon"][2], AAS.ClientTable["ResizeIcon"][3])
        options["skin"] = skinList:GetValue()
        options["usergroups"] = rankTable

        local adminTable = {
            ["name"] = itemName:GetText(),
            ["description"] = itemDesc:GetText(),
            ["model"] = itemModel:GetText(),
            ["price"] = itemPrice:GetText(),
            ["options"] = options,
            ["category"] = itemCategory:GetText(),
            ["pos"] = (getItemSettings("pos") or AAS.ClientTable["ItemSelected"]["pos"]),
            ["ang"] = (getItemSettings("rotate") or AAS.ClientTable["ItemSelected"]["ang"]),
            ["scale"] = (getItemSettings("scale") or AAS.ClientTable["ItemSelected"]["scale"]), 
            ["job"] = jobTable,
            ["uniqueId"] = istable(AAS.ClientTable["ItemSelected"]) and isnumber(AAS.ClientTable["ItemSelected"].uniqueId) and AAS.ClientTable["ItemSelected"].uniqueId or nil,
            ["customModel"] = (IsValid(modelChoice) and modelChoice:GetText() or ""),
        }

        if not editItem && IsValid(playerModelAdmin) then
            itemContainer:Clear()
            
            for k,v in pairs(sliderList:GetChildren()) do
                v:SetVisible(true)
            end

            local itemPreview = vgui.Create("AAS:Cards", itemContainer)
            itemPreview:SetSize(AAS.ScrW*0.11, AAS.ScrH*0.26)
            itemPreview:AddItemView(itemScroll, accessoriesFrame, itemContainer, {})
            itemPreview:RemoveButton()
            
            itemPreview.AASTable = adminTable

            if IsValid(playerModelAdmin) then
                playerModelAdmin:Remove()
            end

            if IsValid(modelChoice) then
                modelChoice:Remove()
            end

            return
        else 
            if IsValid(playerModelAdmin) then playerModelAdmin:Remove() end
            if IsValid(modelChoice) then modelChoice:Remove() end

            for k,v in pairs(sliderList:GetChildren()) do
                v:SetVisible(true)
            end

            AAS.ClientTable["Id"] = 1
        end

        if itemName:GetText() == "" or itemName:GetText() == AAS.GetSentence("itemName") then AAS.Notification(5, AAS.GetSentence("adminname")) return end
        if itemDesc:GetText() == "" or itemDesc:GetText() == AAS.GetSentence("description") then AAS.Notification(5, AAS.GetSentence("faildesc")) return end
        if itemModel:GetText() == "" then AAS.Notification(5, AAS.GetSentence("choosemodel")) return end
        if itemPrice:GetText() == "" or tonumber(itemPrice:GetText()) < 0 then AAS.Notification(5, AAS.GetSentence("failprice")) return end
        if not AAS.CheckCategory(itemCategory:GetText()) then AAS.Notification(5, AAS.GetSentence("failcategory")) return end  
        
        net.Start("AAS:Main")
            net.WriteUInt(AAS.ClientTable["ItemSelected"] != nil and 3 or 1, 5)
            net.WriteTable(adminTable)
        net.SendToServer()
    end 
end

function AAS.AdminSetting(loadId)
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end
        
    AAS.BaseMenu(AAS.GetSentence("adminDashboard"), false, AAS.ScrW*0.2, "customcharacter")
    AAS.ClientTable["Id"] = 1

    local LerpPos = 0
    local categoryList = vgui.Create("DScrollPanel", accessoriesFrame)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.1)
    categoryList.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, LerpPos, AAS.ScrW*0.038, AAS.ScrH*0.038, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, AAS.ScrW*0.038 - AAS.ScrW*0.0017, LerpPos, AAS.ScrW*0.002, AAS.ScrH*0.038, AAS.Colors["white200"])
    end

    for k,v in ipairs(AAS.Category["adminMenu"]) do 
        local categoryButton = vgui.Create("DButton", categoryList)
        categoryButton:SetSize(0, AAS.ScrH*0.038)
        categoryButton:Dock(TOP)
        categoryButton:SetText("")
        categoryButton:DockMargin(0,0,0,AAS.ScrH*0.006)
        categoryButton.Paint = function(self,w,h)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.material, "smooth")
            surface.DrawTexturedRect((w/2)-(AAS.ScrW*v.sizeX/2), h/2-(AAS.ScrH*v.sizeY/2), AAS.ScrW*v.sizeX, AAS.ScrH*v.sizeY)

            LerpPos = Lerp(FrameTime()*5, LerpPos, (AAS.ScrH*0.038 + AAS.ScrH*0.006)*(AAS.ClientTable["Id"] - 1))
        end 
        categoryButton.DoClick = function()
            AAS.ClientTable["Id"] = k
            timer.Simple(0.3, function()
                v.callBack()
            end)
        end
    end

    --[[ Global for update player and admin cards ]]
    itemScroll = vgui.Create( "AAS:ScrollPanel", accessoriesFrame)
    itemScroll:SetSize(AAS.ScrW*0.343, AAS.ScrH*0.542)
    itemScroll:SetPos(AAS.ScrW*0.052, AAS.ScrH*0.1)

    itemContainer = vgui.Create("DIconLayout", itemScroll)
    itemContainer:SetSize(AAS.ScrW*0.343, AAS.ScrH*0.542)
    itemContainer:SetSpaceX(AAS.ScrW*0.001) 
    itemContainer:SetSpaceY(AAS.ScrW*0.016)

    for k,v in ipairs(AAS.ClientTable["ItemsTable"]) do 
        local itemBackground = vgui.Create("AAS:Cards", itemContainer)
        itemBackground:SetSize(AAS.ScrW*0.11, AAS.ScrH*0.26)
        itemBackground:AddItemView(itemScroll, accessoriesFrame, itemContainer, v)

        if not loadId then
            if k == 1 then 
                AAS.ClientTable["ItemSelected"] = v
            end 
        else
            AAS.ClientTable["ItemSelected"] = AAS.ClientTable["ItemSelected"] or v
        end
    end 

    local searchBar = vgui.Create("AAS:SearchBar", accessoriesFrame)
    searchBar:SetPos(accessoriesFrame:GetWide()*0.11, AAS.ScrH*0.055)

    
    local newButton = vgui.Create("AAS:Button", accessoriesFrame)
    newButton:SetPos(accessoriesFrame:GetWide()*0.42, AAS.ScrH*0.055)
    newButton:SetTheme(false)
    newButton.DoClick = function()
        newButton:ChangeStatut(true)

        AAS.UpdateList(AAS.ClientTable["ItemsVisible"], true)
    end

    local vipButton = vgui.Create("AAS:Button", accessoriesFrame)
    vipButton:SetPos(accessoriesFrame:GetWide()*0.5255, AAS.ScrH*0.055)
    vipButton:SetTheme(true)
    vipButton.DoClick = function()
        vipButton:ChangeStatut(true)

        AAS.UpdateList(AAS.ClientTable["ItemsVisible"], true)
    end



    AAS.settingsScroll(accessoriesFrame, AAS.ScrH*0.11, AAS.ScrH*0.525, true, AAS.GetSentence("edititem"), true, true)

    local storeButton = vgui.Create("DButton", accessoriesFrame)
    storeButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
    storeButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, accessoriesFrame:GetTall()*0.92)
    storeButton:SetText("")
    storeButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["market"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    storeButton.DoClick = function()
        AAS.ItemMenu()
    end 

    if #AAS.ClientTable["ItemsTable"] == 0 then
        AAS.CreateAccessory()    
    end
end

function AAS.CreateAccessory(loadId)
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end
    
    AAS.BaseMenu(AAS.GetSentence("adminDashboard"), false, AAS.ScrW*0.2, "customcharacter")
    AAS.ClientTable["Id"] = 2
    AAS.ClientTable["ItemSelected"] = nil

    local LerpPos = 0
    local categoryList = vgui.Create("DScrollPanel", accessoriesFrame)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.1)
    categoryList.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, LerpPos, AAS.ScrW*0.038, AAS.ScrH*0.038, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, AAS.ScrW*0.038 - AAS.ScrW*0.0017, LerpPos, AAS.ScrW*0.002, AAS.ScrH*0.038, AAS.Colors["white200"])
    end

    for k,v in ipairs(AAS.Category["adminMenu"]) do 
        local categoryButton = vgui.Create("DButton", categoryList)
        categoryButton:SetSize(0, AAS.ScrH*0.038)
        categoryButton:Dock(TOP)
        categoryButton:SetText("")
        categoryButton:DockMargin(0,0,0,AAS.ScrH*0.006)
        categoryButton.Paint = function(self,w,h)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.material, "smooth")
            surface.DrawTexturedRect((w/2)-(AAS.ScrW*v.sizeX/2), h/2-(AAS.ScrH*v.sizeY/2), AAS.ScrW*v.sizeX, AAS.ScrH*v.sizeY)

            LerpPos = (AAS.ScrH*0.038 + AAS.ScrH*0.006)*(AAS.ClientTable["Id"] - 1)
        end 
        categoryButton.DoClick = function()
            AAS.ClientTable["Id"] = k
            timer.Simple(0.3, function()
                v.callBack()
            end)
        end
    end

    --[[ Global for update player and admin cards ]]
    itemScroll = vgui.Create( "AAS:ScrollPanel", accessoriesFrame)
    itemScroll:SetSize(AAS.ScrW*0.343, AAS.ScrH*0.542)
    itemScroll:SetPos(AAS.ScrW*0.052, AAS.ScrH*0.1)

    itemContainer = vgui.Create("DIconLayout", itemScroll)
    itemContainer:SetSize(AAS.ScrW*0.343, AAS.ScrH*0.542)
    itemContainer:SetSpaceX(AAS.ScrW*0.001) 
    itemContainer:SetSpaceY(AAS.ScrW*0.016) 

    local itemPreview = vgui.Create("AAS:Cards", itemContainer)
    itemPreview:SetSize(AAS.ScrW*0.11, AAS.ScrH*0.26)
    itemPreview:AddItemView(itemScroll, accessoriesFrame, itemContainer, {})
    itemPreview:RemoveButton()

    itemPreview.Think = function()
        local previewTable = {
            ["name"] = itemName:GetText(),
            ["description"] = itemDesc:GetText(),
            ["model"] = itemModel:GetText(),
            ["price"] = tonumber(itemPrice:GetText()),
            ["preview"] = true,
            ["options"] = {
                ["new"] = itemNew:GetStatut(),
                ["vip"] = itemVip:GetStatut(),
                ["color"] = itemColor:GetColor(),
                ["bone"] = boneName,
                ["iconFov"] = AAS.ClientTable["ResizeIcon"][4],
                ["iconPos"] = Vector(AAS.ClientTable["ResizeIcon"][1], AAS.ClientTable["ResizeIcon"][2], AAS.ClientTable["ResizeIcon"][3]),
                ["skin"] = skinList:GetValue(),
            },
            ["category"] = itemCategory:GetText(),
        }

        itemPreview.AASTable = previewTable
    end

    local searchBar = vgui.Create("AAS:SearchBar", accessoriesFrame)
    searchBar:SetPos(accessoriesFrame:GetWide()*0.11, AAS.ScrH*0.055)
    searchBar.AASTextEntry:SetEditable(false)

    local newButton = vgui.Create("AAS:Button", accessoriesFrame)
    newButton:SetPos(accessoriesFrame:GetWide()*0.42, AAS.ScrH*0.055)
    newButton:SetTheme(false)

    local vipButton = vgui.Create("AAS:Button", accessoriesFrame)
    vipButton:SetPos(accessoriesFrame:GetWide()*0.5255, AAS.ScrH*0.055)
    vipButton:SetTheme(true)

    AAS.settingsScroll(accessoriesFrame, AAS.ScrH*0.11, AAS.ScrH*0.525, false, AAS.GetSentence("edititem"), true, true)

    local storeButton = vgui.Create("DButton", accessoriesFrame)
    storeButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
    storeButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, accessoriesFrame:GetTall()*0.92)
    storeButton:SetText("")
    storeButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["market"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    storeButton.DoClick = function()
        AAS.ItemMenu()
    end 
end

local curentPosx, curentPosY, curentFov = 0, 0, 0
function AAS.PositionSettings(edit, playerModel, model, skinValue)
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end

    itemContainer:Clear()
            
    for k,v in pairs(sliderList:GetChildren()) do
        v:SetVisible(false)
    end

    AAS.ClientTable["Id"] = 2
    AAS.ClientTable["AdminPos"] = {}

    local boneName
    for k,v in ipairs(AAS.Category["mainMenu"]) do
        if v.all then continue end

        if istable(AAS.ClientTable["ItemSelected"]) and v.uniqueName == AAS.ClientTable["ItemSelected"].category then
            boneName = v.bone
        end
    end

    playerModelAdmin = vgui.Create("AAS:DModel", accessoriesFrame)
    playerModelAdmin:SetSize(AAS.ScrW*0.184, AAS.ScrH*0.48)
    playerModelAdmin:SetPos(AAS.ScrW*0.405, AAS.ScrH*0.11)
    playerModelAdmin:SetFOV(30)
    
    if edit then
        modelChoice = vgui.Create("AAS:ComboBox", accessoriesFrame)
        modelChoice:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.027)
        modelChoice:SetPos(AAS.ScrW*0.405, AAS.ScrH*0.61)
        modelChoice:SetText("Configure position for all models")
        modelChoice:AddChoice("Configure position for all models", LocalPlayer():GetModel())
        for k,v in pairs(list.Get("PlayerOptionsModel")) do
            modelChoice:AddChoice(v, v)
        end
        modelChoice.OnSelect = function(self)
            local data = self:GetOptionData(self:GetSelectedID())
            playerModelAdmin:SetModel(data)

            itemContainer:Clear()
            sliderMove(AAS.ScrW*0.13, AAS.ScrH*0.82, itemContainer, AAS.GetSentence("position"), "pos", data)
            sliderMove(AAS.ScrW*0.34, AAS.ScrH*0.82, itemContainer, AAS.GetSentence("rotation"), "rotate", data)
            sliderMove(AAS.ScrW*0.55, AAS.ScrH*0.82, itemContainer, AAS.GetSentence("scale"), "scale", data)
        end
    end

    sliderMove(AAS.ScrW*0.13, AAS.ScrH*0.82, itemContainer, AAS.GetSentence("position"), "pos")
    sliderMove(AAS.ScrW*0.34, AAS.ScrH*0.82, itemContainer, AAS.GetSentence("rotation"), "rotate")
    sliderMove(AAS.ScrW*0.55, AAS.ScrH*0.82, itemContainer, AAS.GetSentence("scale"), "scale")

    AAS.SettingsModel(playerModelAdmin, model, skinValue, boneName)

    playerModelAdmin.DrawModel = function(self)
        if not IsValid(AASClientSide) then return end
        
        AASClientSide:DrawModel()
        self.Entity:DrawModel()
    end
end

function AAS.SettingsModel(panel, model, skinValue, boneName)
    local ent = panel.Entity
    if not IsValid(panel) or not IsValid(ent) then return end
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end

    if IsValid(AASClientSide) then AASClientSide:Remove() end 

    AASClientSide = ClientsideModel("models/props_c17/oildrum001_explosive.mdl")
    AASClientSide:SetNoDraw(true)
    if IsValid(skinList) and isnumber(tonumber(skinList:GetValue())) then
        AASClientSide:SetSkin(tonumber(skinList:GetValue()))
    end
	AASClientSide:Spawn()
    
    timer.Create("AAS:updateClientSideModel", 0, 0, function()
        local ent = panel.Entity

        if not IsValid(ent) then return end
        if not IsValid(AASClientSide) then timer.Remove("AAS:updateClientSideModel") return end

        local boneName, boneId = (boneName and boneName or "ValveBiped.Bip01_Head1"), 6
        local checkBone = ent:LookupBone(boneName)
        if not isnumber(checkBone) then
            for i=1, ent:GetBoneCount() do
                local name = ent:GetBoneName(i)

                AAS.SimilarityBones[boneName] = AAS.SimilarityBones[boneName] or {}
                local bool = AAS.SimilarityBones[boneName][name]
    
                if bool then
                    boneId = i
                    boneName = name
                    break
                end
            end
        else
            boneId = checkBone
        end
        
        local matrix = ent:GetBoneMatrix(boneId)
        if not matrix then 
            return
        end

        local newpos = AAS.ConvertVector(matrix:GetTranslation(), getItemSettings("pos"), matrix:GetAngles())
        local newang = AAS.ConvertAngle(matrix:GetAngles(), getItemSettings("rotate"))
        
        if isnumber(skinValue) then
            AASClientSide:SetSkin(skinValue)
        end

        AASClientSide:SetPos(newpos)
        AASClientSide:SetAngles(newang)
        AASClientSide:SetModel(model)
        AASClientSide:SetColor(clientSideModelColor)

        local mat = Matrix()
        mat:Scale(getItemSettings("scale"))
        AASClientSide:EnableMatrix("RenderMultiply", mat)
    end)
end
