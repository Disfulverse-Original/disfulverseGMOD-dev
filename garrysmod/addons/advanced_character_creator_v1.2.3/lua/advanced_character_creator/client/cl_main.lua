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
ACC2.RenderTarget = ACC2.RenderTarget or {}
ACC2.Characters = ACC2.Characters or {}

local function callStepById(id)
    ACC2.FunctionsCalled = ACC2.FunctionsCalled or {}

    if istable(ACC2.FunctionsCalled[id]) then
        local func = ACC2.FunctionsCalled[id]["func"]

        if isfunction(func) then
            local args = ACC2.FunctionsCalled[id]["args"] or {}

            ACC2.CurrentFuncIdCalled = (ACC2.CurrentFuncIdCalled - 1)
            func(args[1], args[2], args[3], args[4], args[5])
        end
    end
end

local rectangle = {
    {x = 0, y = ACC2.ScrH*0.78},
    {x = ACC2.ScrW*0.72, y = ACC2.ScrH*0.78},
    {x = ACC2.ScrW*0.72-ACC2.ScrW*0.01, y = ACC2.ScrH*0.78 + ACC2.ScrH*0.045},
    {x = 0, y = ACC2.ScrH*0.78 + ACC2.ScrH*0.045},
}

local lerpSelectedCard, lerpDeleted, characterPanelByCharacterId, selectedCharacter, selectedCharacterSequencial, scrollNow, dModelMainMenu = {}, {}, {}

function ACC2.SetPreviewModel(characterId)
    if not IsValid(dModelMainMenu) then return end

    local characterTable = ACC2.Characters[characterId]

    if characterTable && characterTable["model"] then
        dModelMainMenu:SetModel(characterTable["model"])

        local ent = dModelMainMenu.Entity

        if IsValid(ent) then
            ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
    
            local bodygroups = characterTable["bodygroups"]

            if istable(bodygroups) then
                for k, v in pairs(bodygroups) do
                    ent:SetBodygroup(k, v)
                end
            end
        end
    end
end

function ACC2.SelectCharacter(characterId)
    if not isnumber(characterId) then return end

    if not ACC2.GetSetting("canSelectWhenNotAllowed", "boolean") then
        if not ACC2.LocalPlayer:ACC2CanLoadCharacter(characterId, ACC2.Characters) then
            ACC2.Notification(5, ACC2.GetSentence("cannotInteractWithThisCharacter"))
            return 
        end
    end

    ACC2.SetPreviewModel(characterId)

    selectedCharacter = characterId
    scrollNow = true
end

local function createdCharacterCard(characterId, characterTable, notUniqueId)
    local characterPanel = vgui.Create("DButton", scrollCharacter)
    characterPanel:SetSize(ACC2.ScrW*0.2215, ACC2.ScrH*0.55)
    characterPanel:SetText("")
    characterPanelByCharacterId[characterId] = characterPanel

    local dModel = vgui.Create("ACC2:DModel", characterPanel)
    dModel:SetModel((characterTable["model"] or "models/player/Group01/Male_09.mdl"))
    dModel:SetSize(ACC2.ScrH*0.3, ACC2.ScrH*0.3)
    dModel:SetPos(ACC2.ScrW*0.025, ACC2.ScrH*0.07)
    dModel:SetPaintedManually(true)
    dModel.LayoutEntity = function() end
    dModel.DoClick = function()
        ACC2.SelectCharacter(characterId)
        if ACC2.GetSetting("selectPlay", "boolean") then
            local characterId = tonumber(selectedCharacter)
            
            if isnumber(characterId) then
                net.Start("ACC2:Character")
                    net.WriteUInt(3, 4)
                    net.WriteUInt(characterId, 22)
                net.SendToServer()
            end
        end        
    end
    dModel.uniqueId = characterId

    characterPanel.dModelPanel = dModel

    if dModel.Entity then
        local head = dModel.Entity:LookupBone("ValveBiped.Bip01_Head1")

        if isnumber(head) then
            local headpos = dModel.Entity:GetBonePosition(head)

            if isvector(headpos) then
                dModel:SetLookAt(headpos)
                dModel:SetCamPos(headpos-Vector(-17, 0, 0))
            end
        end
    end

    local bodygroups = characterTable["bodygroups"]
    if istable(bodygroups) then
        for k, v in pairs(bodygroups) do
            dModel.Entity:SetBodygroup(k, v)
        end
    end
 
    characterPanel.Paint = function(self, w, h)
        --[[ Draw card ]]
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawRect(0, 0, w, h)
        
        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white2"])
        ACC2.DrawSimpleCircle(w*0.5, h*0.35, w*0.3, 360)
        
        if IsValid(self.dModelPanel) then
            ACC2.MaskStencil(function()
                draw.NoTexture()
                surface.SetDrawColor(ACC2.Colors["white2"])
                ACC2.DrawSimpleCircle(w*0.5, h*0.35, w*0.3, 360)
            end, 
            function()
                self.dModelPanel:PaintManual()
            end, false)
        end
        --[[
        surface.SetMaterial(ACC2.Materials["user"])
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawTexturedRect(w*0.25, h*0.4, h*0.7, h*0.7)
        --]]
        lerpSelectedCard[characterId] = lerpSelectedCard[characterId] or 0
        lerpSelectedCard[characterId] = Lerp(FrameTime()*8, lerpSelectedCard[characterId], (characterId == selectedCharacter and 255 or 0))

        surface.SetDrawColor(ACC2.Colors["purple3"].r, ACC2.Colors["purple3"].g, ACC2.Colors["purple3"].b, (lerpSelectedCard[characterId] - 250))
        surface.DrawRect(0, 0, w, h)
        
        surface.SetDrawColor(ColorAlpha(ACC2.Colors["purple3"], lerpSelectedCard[characterId]))
        surface.DrawOutlinedRect(0, 0, w, h, ACC2.ScrH*0.005)

        local name = ACC2.GetFormatedName((characterTable["name"] or "Invalid"), (characterTable["lastName"] or "Invalid"))
        local prefix = characterTable["prefix"] or {}
        local jobPrefix = prefix[characterTable["job"]]

        if isstring(jobPrefix) then
            name = ACC2.PrefixedName(jobPrefix, (characterTable["name"] or "Invalid"), (characterTable["lastName"] or "Invalid"))
        end

        --[[ Draw name ]]
        draw.DrawText(name, "ACC2:Font:05", w*0.5, h*0.58, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        
        --[[ Money draw ]]
        local money = ACC2.formatMoney(characterTable["money"])

        surface.SetFont("ACC2:Font:07")

        local sizeMoney = surface.GetTextSize(money)
        local sizeX, sizeY, posY = sizeMoney + ACC2.ScrW*0.03, ACC2.ScrH*0.03, h*0.67

        draw.RoundedBox(18, w/2-(sizeX/2), posY, sizeX, sizeY, ACC2.Colors["white5"])
        
        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(w/2-(sizeX/2) + (sizeY/2), posY + (sizeY/2), sizeY/2, 360)

        local iconSize = h*0.03

        surface.SetMaterial(ACC2.Materials["money"])
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(w/2-(sizeX/2) + (sizeY/2) - iconSize/2, posY + iconSize/2, iconSize, iconSize)

        draw.SimpleText((ACC2.GetSetting("loadMoney", "boolean") and money or ACC2.formatMoney(ACC2.LocalPlayer:ACC2GetMoney())), "ACC2:Font:07", w/2 + ((sizeY/2))/2, posY + (sizeY/2)*0.85, ACC2.Colors["white50"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        --[[ Job draw ]]
        local job = (characterTable["job"] or "Invalid")

        surface.SetFont("ACC2:Font:07")

        local sizeJob = surface.GetTextSize(job)
        local sizeX, sizeY, posY = sizeJob + ACC2.ScrW*0.03, ACC2.ScrH*0.03, h*0.74

        draw.RoundedBox(18, w/2-(sizeX/2), posY, sizeX, sizeY, ACC2.Colors["white5"])
        
        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(w/2-(sizeX/2) + (sizeY/2), posY + (sizeY/2), sizeY/2, 360)

        local iconSize = h*0.03

        surface.SetMaterial(ACC2.Materials["job"])
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(w/2-(sizeX/2) + (sizeY/2) - iconSize/2, posY + iconSize/2, iconSize, iconSize)

        draw.SimpleText(job, "ACC2:Font:07", w/2 + ((sizeY/2))/2, posY + (sizeY/2)*0.85, ACC2.Colors["white50"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local cannotSelect = false
    if not ACC2.GetSetting("canSelectWhenNotAllowed", "boolean") then
        if not ACC2.LocalPlayer:ACC2CanLoadCharacter(characterId, ACC2.Characters) then
            cannotSelect = true
        end
    end
    
    surface.SetFont("ACC2:Font:06")
    local sizeSelect = surface.GetTextSize(ACC2.GetSentence("select")) + (ACC2.ScrW*0.01)*2 + ACC2.ScrW*0.005

--[[ Select the Character of your choice ]] --[[
    local selectButton = vgui.Create("ACC2:SlideButton", characterPanel)
    selectButton:SetSize(sizeSelect, ACC2.ScrH*0.045)
    selectButton:SetPos(characterPanel:GetWide()/2 - sizeSelect/2, ACC2.ScrH*0.46)
    selectButton:SetValue(ACC2.GetSentence("select"))
    selectButton:InclineButton(ACC2.ScrW*0.01)
    selectButton:SetButtonColor(ACC2.Colors[(cannotSelect and "grey" or "purple120")])
    selectButton:SetIconColor(ACC2.Colors["white80"])
    selectButton:SetIconMaterial(nil)
    selectButton.DoClick = function() end
    selectButton.MinMaxLerp = {60, 120}

    selectButton.DoClick = function()
        ACC2.SelectCharacter(characterId)

        if ACC2.GetSetting("selectPlay", "boolean") then
            local characterId = tonumber(selectedCharacter)
            
            if isnumber(characterId) then
                net.Start("ACC2:Character")
                    net.WriteUInt(3, 4)
                    net.WriteUInt(characterId, 22)
                net.SendToServer()
            end
        end
    end

    characterPanel.DoClick = function()
        ACC2.SelectCharacter(characterId)
    end
    --]]
    --[[local deleteButton = vgui.Create("DButton", characterPanel)
    deleteButton:SetSize(ACC2.ScrW*0.07, ACC2.ScrH*0.03)
    deleteButton:SetPos(characterPanel:GetWide()/2 - ACC2.ScrW*0.07/2, ACC2.ScrH*0.503)
    deleteButton:SetText(ACC2.GetSentence("deleteCharacter"))
    deleteButton:SetFont("ACC2:Font:08")
    deleteButton.DoClick = function(self)
        if not ACC2.GetSetting("canRemoveWhenNotAllowed", "boolean") then
            if not ACC2.LocalPlayer:ACC2CanLoadCharacter(characterId, ACC2.Characters) then
                ACC2.Notification(5, ACC2.GetSentence("cannotInteractWithThisCharacter"))
                return 
            end
        end
        
        local areYouSure = ACC2.GetSentence("areYouSure")
        
        if self:GetText() == areYouSure then
            net.Start("ACC2:Character")
                net.WriteUInt(2, 4)
                net.WriteUInt(characterId, 22)
            net.SendToServer()
            return            
        end

        self:SetText(areYouSure)
        
        timer.Simple(3, function()
            if not IsValid(self) then return end

            self:SetText(ACC2.GetSentence("deleteCharacter"))
        end)
    end

    local baseColorDelete = ACC2.Colors["white80"]
    deleteButton:SetTextColor(baseColorDelete)

    deleteButton.Paint = function(self)
        lerpDeleted[characterId] = lerpDeleted[characterId] or baseColorDelete
        lerpDeleted[characterId] = ACC2.LerpColor(FrameTime()*3, lerpDeleted[characterId], (self:IsHovered() and ACC2.Colors["red202"] or baseColorDelete))

        self:SetTextColor(lerpDeleted[characterId])
    end]]

    scrollCharacter:AddPanel(characterPanel)
end

local lerpCreateButton = {}

function ACC2.CreateCharacterStep()
    local characterId = ACC2.GetNWVariables("characterId", ACC2.LocalPlayer)
    local maxCharacter = ACC2.LocalPlayer:ACC2GetMaxCharacter()

    if table.Count(ACC2.Characters) >= maxCharacter then
        ACC2.Notification(5, ACC2.GetSentence("maxCharacterNotify"))
        return 
    end

    if IsValid(ACC2Container) then ACC2Container:Remove() end

    ACC2.TableCreationCharacter = {}
    
    local factionsTable = ACC2.GetFactionsTable()
    if ACC2.GetSetting("factionSystem", "boolean") && table.Count(factionsTable) > 0 then
        ACC2.FactionMenu(factionsTable)
    else
        ACC2.CreateCharacter()
    end
end

local function notCreatedCharacterCard()
    local characterPanel = vgui.Create("DPanel", scrollCharacter)
    characterPanel:SetSize(ACC2.ScrW*0.2215, ACC2.ScrH*0.55)
    characterPanel.Paint = function(self, w, h)
        --[[ Draw card ]]
        surface.SetDrawColor(ACC2.Colors["whiteinact"])
        surface.DrawRect(0, 0, w, h)
           
        
        --draw.DrawText(ACC2.GetSentence("newCharacter"), "ACC2:Font:05", w*0.5, h*0.6, ACC2.Colors["white80"], TEXT_ALIGN_CENTER)
        --[[
        local maxCharacter = ACC2.GetSetting("maxPlayerCharacters", "table")

        if istable(maxCharacter) then
            maxCharacter = tonumber(maxCharacter[ACC2.LocalPlayer:GetUserGroup()]) or 1
        end

        if table.Count(ACC2.Characters) >= maxCharacter then
            draw.DrawText(ACC2.GetSentence("notAllowed"), "ACC2:Font:03", w*0.5, h*0.64, ACC2.Colors["red202"], TEXT_ALIGN_CENTER)
        else
            draw.DrawText(ACC2.GetSentence("allowed"), "ACC2:Font:03", w*0.5, h*0.64, ACC2.Colors["green97"], TEXT_ALIGN_CENTER)
        end
        --]]
        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["whiteinact"])
        ACC2.DrawSimpleCircle(w*0.5, h*0.35, w*0.3, 360)

        ACC2.MaskStencil(function()
            draw.NoTexture()
            surface.SetDrawColor(ACC2.Colors["whiteinact"])
            ACC2.DrawSimpleCircle(w*0.5, h*0.35, w*0.3, 360)
        end, 
        function()
            surface.SetMaterial(ACC2.Materials["user"])
            surface.SetDrawColor(ACC2.Colors["whiteinact"])
            surface.DrawTexturedRect(w*0.5-h*0.35/2, h*0.22, h*0.35, h*0.35)
        end, false)
    end

    local maxCharacter = ACC2.GetSetting("maxPlayerCharacters", "table")

    if istable(maxCharacter) then
        maxCharacter = tonumber(maxCharacter[ACC2.LocalPlayer:GetUserGroup()]) or 1
    end

    if maxCharacter > table.Count(ACC2.Characters) then
        local lerpButton = 0
        --[[ Select the Character of your choice ]]
        local createButton = vgui.Create("DButton", characterPanel)
        createButton:SetSize(ACC2.ScrH*0.07, ACC2.ScrH*0.07)
        createButton:SetPos(characterPanel:GetWide()/2 - ACC2.ScrH*0.07/2, ACC2.ScrH*0.445)
        createButton:SetText("")
        createButton.DoClick = function() end
        createButton.Paint = function(self, w, h)
            lerpButton = Lerp(FrameTime()*5, lerpButton, (createButton:IsHovered() and 140 or 255))

            draw.NoTexture()
            surface.SetDrawColor(ColorAlpha(ACC2.Colors["purple3"], lerpButton))
            ACC2.DrawSimpleCircle(w/2, h/2, w/2, 50)

            surface.SetMaterial(ACC2.Materials["more"])
            surface.SetDrawColor(ACC2.Colors["white"])
            surface.DrawTexturedRect(w/2-h*0.43/2, h/2-h*0.43/2, h*0.43, h*0.43)
        end
        createButton.DoClick = function()
            ACC2.CreateCharacterStep()
        end
    end


    scrollCharacter:AddPanel(characterPanel)
end

function ACC2.PlayURL(url, volume, stopSound)
    if stopSound then
        RunConsoleCommand("stopsound")
    end

    timer.Simple(0, function()    
        sound.PlayURL(url, "", 
        function(station)
            if IsValid(station) then
                station:Play()
                station:SetVolume(volume)

                ACC2.Sound = station
            end 
        end)
    end)
end

local MATERIALS = FindMetaTable("IMaterial")

function MATERIALS:ACC2ReloadMaterial()
    RunConsoleCommand("mat_reloadmaterial", self:GetName())
end

ACC2.CachedURLImage = ACC2.CachedURLImage or {}
function ACC2.CacheMaterial(url, uniqueName)
    if not isstring(url) or not isstring(uniqueName) then return end

    http.Fetch(url, function(body, size, headers, code)
        if not file.Exists("acc2_image_cache", "DATA") then
            file.CreateDir("acc2_image_cache")
        end

        local serverIP = string.Replace(game.GetIPAddress(), ".", "")
        serverIP = string.Replace(serverIP, ":", "")
        
        if not file.Exists("acc2_image_cache/"..serverIP, "DATA") then
            file.CreateDir("acc2_image_cache/"..serverIP.."/")
        end

        file.Write("acc2_image_cache/"..serverIP.."/"..uniqueName..".png", body)

        timer.Simple(1, function()
            ACC2.CachedURLImage[uniqueName] = Material("../data/acc2_image_cache/"..serverIP.."/"..uniqueName..".png", "smooth")
            ACC2.CachedURLImage[uniqueName]:ACC2ReloadMaterial()
        end)

    end, function(errorMessage)
        print(errorMessage)
    end)
end

function ACC2.ReloadCharacter()
    if not IsValid(scrollCharacter) then return end

    scrollCharacter:Clear()

    local needFakeCard, firstSelected = 3
    local tableSequencial = ACC2.GetSequencialCharacters(ACC2.Characters)

    selectedCharacter = nil

    local notUniqueId = 0

    for k, characterId in ipairs(tableSequencial) do
        notUniqueId = notUniqueId + 1

        createdCharacterCard(characterId, ACC2.Characters[characterId], notUniqueId)
        
        if not firstSelected then
            selectedCharacter = characterId
            firstSelected = true
        end

        needFakeCard = math.Clamp(needFakeCard-1, 0, 3)
    end

    if needFakeCard <= 0 then
        notCreatedCharacterCard()
    else
        for i=1, needFakeCard do
            notCreatedCharacterCard()
        end
    end

    local fakeCard = vgui.Create("DPanel", scrollCharacter)
    fakeCard:SetSize(ACC2.ScrW*0.2215/2, ACC2.ScrH*0.55)
    fakeCard.Paint = function(self, w, h)
        local sizeX, sizeY = ACC2.ScrW*0.2215, ACC2.ScrH*0.55

        surface.SetDrawColor(ACC2.Colors["whiteinact"])
        surface.DrawRect(0, 0, sizeX, sizeY)

        surface.SetMaterial(ACC2.Materials["user"])
        surface.SetDrawColor(ACC2.Colors["whiteinact"])
        surface.DrawTexturedRect(sizeX*0.24, sizeY*0.4, sizeY*0.7, sizeY*0.7)
    end

    scrollCharacter:AddPanel(fakeCard)
end

function ACC2.SetNextCharacter(reverse)
    local tableToLoop = table.GetKeys(ACC2.Characters)

    if reverse then
        table.sort(tableToLoop, function(a, b) 
            return (a < b) 
        end)
    else
        table.sort(tableToLoop, function(a, b) 
            return (a > b) 
        end)
    end

    local selectNext, findCharacter

    for k, characterId in ipairs(tableToLoop) do
        if not isnumber(selectedCharacter) then
            selectedCharacter = characterId
            break
        end

        if selectNext then
            findCharacter = true
            scrollNow = true
            selectedCharacter = characterId
            break
        end

        if characterId == selectedCharacter then
            selectNext = true
        end
    end
end

function ACC2.MainMenu()
    ACC2.LocalPlayer = LocalPlayer()
    ACC2.Characters = ACC2.Characters or {}
    ACC2.FunctionsCalled = {}
    ACC2.CurrentFuncIdCalled = 0

    lerpSelectedCard = {}

    if IsValid(ACC2Container) then ACC2Container:Remove() end

    if ACC2.GetSetting("enableSoundMenu", "boolean") then
        ACC2.PlayURL(ACC2.GetSetting("soundMenuLink", "string"), ACC2.GetSetting("soundMenuVolume", "number"), true)
    end

    ACC2Container = vgui.Create("DFrame")
    ACC2Container:SetSize(ACC2.ScrW, ACC2.ScrH)
    ACC2Container:SetDraggable(false)
    ACC2Container:ShowCloseButton(false)
    ACC2Container:MakePopup()
    ACC2Container:SetTitle("")
    ACC2Container.startTime = SysTime()
    
    ACC2Container.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 15)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))

        surface.SetDrawColor(ACC2.Colors["blackpurpledisful"])
        surface.DrawRect(0, 0, w, h)
        --[[
        surface.SetDrawColor(ACC2.Colors["blackpurpledisful"])
        surface.SetMaterial(ACC2.Materials["background"])
        surface.DrawRect(0, 0, w, h)
        --]]
        surface.SetDrawColor(ACC2.Colors["white2"])
        draw.NoTexture()
        surface.DrawPoly(rectangle)

        surface.SetFont("ACC2:Font:01")

        local base = ACC2.GetSentence("characterCreator")
        local textSize = surface.GetTextSize(base)
                
        draw.DrawText(base, "ACC2:Font:01", w*0.04, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        --draw.DrawText(" - ".."HOME", "ACC2:Font:02", w*0.043 + textSize, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        --draw.DrawText(ACC2.GetSetting("shortDescription", "string"), "ACC2:Font:03", w*0.04, h*0.09, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
        
        surface.SetFont("ACC2:Font:05")

        ACC2.DrawNotification()
    end

    scrollCharacter = vgui.Create("DHorizontalScroller", ACC2Container)
    scrollCharacter:SetSize(ACC2.ScrW*0.8, ACC2.ScrH*0.55)
    scrollCharacter:SetPos(ACC2.ScrW*0.041, ACC2.ScrH*0.22)
    scrollCharacter:SetOverlap(-ACC2.ScrW*0.007)
    scrollCharacter.btnLeft.Paint = function() end
    scrollCharacter.btnRight.Paint = function() end
    scrollCharacter.OnMouseWheeled = function(self, dlta)
        scrollCharacter.ACC2ScrollPos = (self.OffsetX + dlta * -125)
    end

    scrollCharacter.Paint = function(self,w,h)
        if IsValid(characterPanelByCharacterId[selectedCharacter]) && scrollNow then
            scrollCharacter.ACC2ScrollPos = scrollCharacter.pnlCanvas:GetChildPosition(characterPanelByCharacterId[selectedCharacter]) - (ACC2.ScrW*0.2215)
            scrollNow = false
        end

        if isnumber(scrollCharacter.ACC2ScrollPos) then
            scrollCharacter.ACC2LerpScrollPos = Lerp(FrameTime()*5, scrollCharacter.ACC2LerpScrollPos or scrollCharacter.OffsetX, scrollCharacter.ACC2ScrollPos)
            scrollCharacter:SetScroll(scrollCharacter.ACC2LerpScrollPos)
        end
    end

    scrollCharacter.oldMouseWheeled = scrollCharacter.OnMouseWheeled
    scrollCharacter.OnMouseWheeled = function(self, dlta)
        if isnumber(scrollCharacter.ACC2ScrollPos) then
            scrollCharacter.ACC2ScrollPos = nil
        end

        self.oldMouseWheeled(self, dlta)
    end

    ACC2.ReloadCharacter()
    
    dModelMainMenu = vgui.Create("ACC2:DModel", ACC2Container)
    dModelMainMenu:SetSize(ACC2.ScrW*0.25, ACC2.ScrH*1)
    dModelMainMenu:SetPos(ACC2.ScrW*0.72, 0)
    dModelMainMenu:ACC2SetFOV(35)
    dModelMainMenu:ACC2SetFOVBase(50)
    dModelMainMenu:SetModel(ACC2.GetSetting("defaultMenuModel", "string"))
    dModelMainMenu.LayoutEntity = function() end
    dModelMainMenu:CanRotateCamera(false)
    dModelMainMenu:SetFocusEntity(dModelMainMenu.Entity)
    dModelMainMenu:ACC2SetIgnoreZ(true)

    local modelEnt = dModelMainMenu.Entity
    
    if IsValid(modelEnt) then
        modelEnt:SetAngles(ACC2.Constants["angleDModel1"])
    end

    ACC2.SetPreviewModel(selectedCharacter)

    --[[ This scroll permit to add all button on the top right of the screen ]]
    local buttonScroll = vgui.Create("DHorizontalScroller", ACC2Container)
    buttonScroll:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.046)
    buttonScroll:SetPos(ACC2.ScrW*0.68, ACC2.ScrH*0.05)

    local buttons = ACC2.CreateButtons()

    for k, v in ipairs(buttons) do
        local mainButton = vgui.Create("ACC2:SlideButton", buttonScroll)
        mainButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
        mainButton:InclineButton(ACC2.ScrW*0.01)
        mainButton:Dock(RIGHT)
        mainButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
        mainButton:SetButtonColor(ACC2.Colors["purple120"])
        mainButton:SetIconColor(ACC2.Colors["white80"])
        mainButton:SetIconMaterial(v.mat)
        mainButton.DoClick = function()
            v.func(ACC2Container, nil, mainButton)
        end
        mainButton.MinMaxLerp = {60, 120}
    end

    local fakeCard = vgui.Create("DPanel", ACC2Container)
    fakeCard:SetSize(ACC2.ScrW*0.2215, ACC2.ScrH*0.55)
    fakeCard:SetPos(ACC2.ScrW*-0.188, ACC2.ScrH*0.22)
    fakeCard.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["whiteinact"])
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(ACC2.Materials["user"])
        surface.SetDrawColor(ACC2.Colors["whiteinact"])
        surface.DrawTexturedRect(w*0.25, h*0.4, h*0.7, h*0.7)
    end

    local leftArrow = vgui.Create("DButton", ACC2Container)
    leftArrow:SetSize(ACC2.ScrH*0.022, ACC2.ScrH*0.022)
    leftArrow:SetPos(ACC2.ScrW*0.675, ACC2.ScrH*0.792)
    leftArrow:SetText("")
    leftArrow.Paint = function(self, w, h)
        surface.SetMaterial(ACC2.Materials["leftArrow"])
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    leftArrow.DoClick = function()
        ACC2.SetNextCharacter(false)
    end 

    local rightArrow = vgui.Create("DButton", ACC2Container)
    rightArrow:SetSize(ACC2.ScrH*0.022, ACC2.ScrH*0.022)
    rightArrow:SetPos(ACC2.ScrW*0.69, ACC2.ScrH*0.792)
    rightArrow:SetText("")
    rightArrow.Paint = function(self, w, h)
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    rightArrow.DoClick = function()
        ACC2.SetNextCharacter(true)
    end

    --[[
    local description = vgui.Create("DLabel", ACC2Container)
    description:SetSize(ACC2.ScrW*0.68, ACC2.ScrH*0.15)
    description:SetPos(ACC2.ScrW*0.04, ACC2.ScrH*0.845)
    description:SetWrap(true)
    description:SetContentAlignment(7)
    description:SetText(ACC2.GetSetting("mainMenuDescription", "string"))
    description:SetFont("ACC2:Font:06")
    description:SetTextColor(ACC2.Colors["white50"])
    --]]
    local playButton = vgui.Create("ACC2:SlideButton", ACC2Container)
    playButton:SetSize(ACC2.ScrW*0.09, ACC2.ScrH*0.045)
    playButton:SetPos(ACC2.ScrW*0.717, ACC2.ScrH*0.78)
    playButton:SetValue(ACC2.GetSentence("play"))
    playButton:InclineButton(ACC2.ScrW*0.01)
    playButton:SetButtonColor(ACC2.Colors["purple3"])
    playButton:SetIconColor(ACC2.Colors["white80"])
    playButton:SetIconMaterial(nil)
    playButton.DoClick = function()
        local characterId = tonumber(selectedCharacter)
        if isnumber(characterId) then
            net.Start("ACC2:Character")
                net.WriteUInt(3, 4)
                net.WriteUInt(characterId, 22)
            net.SendToServer()
        end
    end
    playButton.MinMaxLerp = {60, 120}

    ACC2Container.PaintOver = function()
        if ACC2.RenderTarget[modelBaseName2] then
            surface.SetMaterial(ACC2.RenderTarget[modelBaseName2])
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(ACC2.ScrW*0.555, ACC2.ScrH*-0.04, ACC2.ScrW*0.58, ACC2.ScrH*0.95)
        end
    end

    ACC2.CurrentFuncIdCalled = ACC2.CurrentFuncIdCalled + 1

    ACC2.FunctionsCalled[ACC2.CurrentFuncIdCalled] = {
        ["func"] = ACC2.MainMenu,
    }
end

local function drawPanelWithPolygon(self, w, h, right, inclineNumber, text, color, mat)
    if not isnumber(inclineNumber) then inclineNumber = ACC2.ScrW*0.009 end

    local rectangle = {}
    if right == true then
        rectangle = {
            {x = 0, y = 0},
            {x = w-inclineNumber, y = 0},
            {x = w, y = h/2},
            {x = w-inclineNumber, y = h},
            {x = 0, y = h},
        }
    elseif right == false then
        rectangle = {
            {x = 0, y = h},
            {x = inclineNumber, y = h/2},
            {x = 0, y = 0},
            {x = w, y = 0},
            {x = w, y = h},
        }
    end

    
    if right == nil then
        surface.SetDrawColor(color)
        surface.DrawRect(0, 0, w, h)
    else
        surface.SetDrawColor(color)
        draw.NoTexture()
        surface.DrawPoly(rectangle)
    end

    if mat then
        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(((right or right == nil) and ACC2.ScrW*0.018 or ACC2.ScrW*0.025), h*0.5, h/3.5, 360)
        
        surface.SetMaterial(mat)
        surface.SetDrawColor(ACC2.Colors["white50"])
        surface.DrawTexturedRect(((right or right == nil) and ACC2.ScrW*0.018 or ACC2.ScrW*0.025) - ACC2.ScrH*0.015/2, h*0.5 - ACC2.ScrH*0.015/2, ACC2.ScrH*0.015, ACC2.ScrH*0.015)
    end

    draw.SimpleText(text, "ACC2:Font:06", ((right or right == nil) and ACC2.ScrW*0.035 or ACC2.ScrW*0.043), h/2, ACC2.Colors["white80"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local scrollModelList
local function reloadModels(models, modelList, dModel, characterModel, characterTable)
    if not istable(models) then return end

    modelList:Clear()

    local modelSelected, modelPanelLerpSelected, modelPanelLerp = 1, {}, {}
    local i = 1
    for k, v in pairs(models) do
        local modelPanel = modelList:Add("DButton")
        modelPanel:SetSize(ACC2.ScrH*0.105, ACC2.ScrH*0.105)
        modelPanel:SetText("")
        modelPanel.DoClick = function() end
        modelPanel.uniqueId = i
        if modelPanel.uniqueId == 1 then 
            dModel:SetModel(k)
            dModel:SetFocusEntity(dModel.Entity)
            
            local ent = dModel.Entity
            if IsValid(ent) then
                ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
            end
            ACC2.TableCreationCharacter["model"] = k
        end

        if string.lower((characterModel or "")) == string.lower((k or "")) then
            dModel:SetModel(k)
            dModel:SetFocusEntity(dModel.Entity)
            
            local ent = dModel.Entity
            if IsValid(ent) then
                ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
            end

            if istable(characterTable) then
                local bodygroups = characterTable["bodygroups"]
                if istable(bodygroups) then
                    for k, v in pairs(bodygroups) do
                        dModel.Entity:SetBodygroup(k, v)
                    end
                end
            end

            modelSelected = i
            ACC2.TableCreationCharacter["model"] = k
        end

        local circleCached = ACC2.PrecacheCircle(ACC2.ScrH*0.105/2, ACC2.ScrH*0.105/2, ACC2.ScrH*0.105/2, 0, 360)
        modelPanel.Paint = function(self, w, h)
            local uniqueId = self.uniqueId

            modelPanelLerp[uniqueId] = modelPanelLerp[uniqueId] or 0
            modelPanelLerp[uniqueId] = Lerp(FrameTime()*5, modelPanelLerp[uniqueId], ((self:IsHovered() && uniqueId != modelSelected) and 20 or 10))

            draw.NoTexture()
            surface.SetDrawColor(ColorAlpha(ACC2.Colors["white10"], modelPanelLerp[uniqueId]))
            surface.DrawPoly(circleCached)
            
            modelPanelLerpSelected[uniqueId] = modelPanelLerpSelected[uniqueId] or 0
            modelPanelLerpSelected[uniqueId] = Lerp(FrameTime()*5, modelPanelLerpSelected[uniqueId], (uniqueId == modelSelected and 100 or 0))

            draw.NoTexture()
            surface.SetDrawColor(ColorAlpha(ACC2.Colors["purple100"], modelPanelLerpSelected[uniqueId]))
            surface.DrawPoly(circleCached)

            ACC2.MaskStencil(function()
                draw.NoTexture()
                surface.SetDrawColor(ACC2.Colors["white2"])
                surface.DrawPoly(circleCached)
            end, 
            function()
                if IsValid(self.dModel) then
                    self.dModel:PaintManual()
                end
            end, false)
        end

        local modelToSelect = vgui.Create("ACC2:DModel", modelPanel)
        modelToSelect:SetSize(ACC2.ScrH*0.105, ACC2.ScrH*0.105)
        modelToSelect:SetModel(k)
        modelToSelect:SetPaintedManually(true)
        modelToSelect.LayoutEntity = function() end
        modelToSelect:CanRotateCamera(false)
        modelToSelect:ACC2SetIgnoreZ(true)
        modelToSelect.uniqueId = i
        
        if IsValid(modelToSelect.Entity) then
            modelToSelect:SetFocusEntity(modelToSelect.Entity)
            
            local headBone = modelToSelect.Entity:LookupBone("ValveBiped.Bip01_Head1")
    
            if isnumber(headBone) then
                local headpos = modelToSelect.Entity:GetBonePosition(headBone)
        
                if isvector(headpos) then
                    modelToSelect:SetLookAt(headpos)
                    modelToSelect:SetCamPos(headpos-Vector(-15, 0, 0))
                end
            end
        end

        modelToSelect.DoClick = function(self)
            modelSelected = self.uniqueId
            
            dModel:SetModel(k)
            dModel:SetFocusEntity(dModel.Entity)
            
            local ent = dModel.Entity
            if IsValid(ent) then
                ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
            end

            ACC2.TableCreationCharacter["model"] = k 
        end

        modelPanel.dModel = modelToSelect

        i = i + 1
    end

    timer.Simple(0, function()
        if not IsValid(scrollModelList) then return end

        scrollModelList:PerformLayout()
    end)
end

function ACC2.CreateCharacter(models, modifyCharacter)
    ACC2.TableCreationCharacter = ACC2.TableCreationCharacter or {}
    if IsValid(ACC2Container) then ACC2Container:Remove() end

    if modifyCharacter then
        ACC2.CurrentFuncIdCalled = 0
        ACC2.FunctionsCalled = {}
    end 
    
    ACC2Container = vgui.Create("DFrame")
    ACC2Container:SetSize(ACC2.ScrW, ACC2.ScrH)
    ACC2Container:SetDraggable(false)
    ACC2Container:ShowCloseButton(false)
    ACC2Container:MakePopup()
    ACC2Container:SetTitle("")
    ACC2Container.startTime = SysTime()
    
    ACC2Container.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 15)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))

        surface.SetDrawColor(ACC2.Colors["blackpurpledisful"])
        surface.DrawRect(0, 0, w, h)
        --[[
        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["background"])
        surface.DrawTexturedRect(0, 0, w, h)
        --]]
        surface.SetFont("ACC2:Font:01")
        
        if modifyCharacter then
            draw.DrawText(ACC2.GetSentence("modifyCharacterTitle"), "ACC2:Font:01", w*0.04, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
            draw.DrawText(ACC2.GetSentence("modifyCharacterDescription"), "ACC2:Font:03", w*0.04, h*0.09, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)    
        else
            local base = ACC2.GetSentence("characterCreator")
            local textSize = surface.GetTextSize(base)

            draw.DrawText(base, "ACC2:Font:01", w*0.04, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
            --draw.DrawText(" - ".."CREATION", "ACC2:Font:02", w*0.043 + textSize, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
            --draw.DrawText(string.Replace(ACC2.GetSetting("shortDescription", "string"), "{name}", ACC2.LocalPlayer:Name()), "ACC2:Font:03", w*0.04, h*0.09, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)    
        end

        surface.SetFont("ACC2:Font:05")

        ACC2.DrawNotification()
    end

    local dModel = vgui.Create("ACC2:DModel", ACC2Container)
    dModel:SetSize(ACC2.ScrW*0.25, ACC2.ScrH*1)
    dModel:SetPos(ACC2.ScrW*0.72, 0)
    dModel:ACC2SetFOV(35)
    dModel:ACC2SetFOVBase(35)
    dModel:SetModel(ACC2.GetSetting("defaultMenuModel", "string"))
    dModel.LayoutEntity = function() end
    dModel:CanRotateCamera(true)
    dModel:SetFocusEntity(dModel.Entity)
    
    local ent = dModel.Entity
    if IsValid(ent) then
        ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
    end

    --[[ This scroll permit to add all button on the top right of the screen ]]
    local buttonScroll = vgui.Create("DHorizontalScroller", ACC2Container)
    buttonScroll:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.046)
    buttonScroll:SetPos(ACC2.ScrW*0.68, ACC2.ScrH*0.05)

    local buttons = ACC2.CreateButtons()
    local characterId = ACC2.GetNWVariables("characterId", ACC2.LocalPlayer)

    for k, v in ipairs(buttons) do
        local mainButton = vgui.Create("ACC2:SlideButton", buttonScroll)
        mainButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
        mainButton:InclineButton(ACC2.ScrW*0.01)
        mainButton:Dock(RIGHT)
        mainButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
        mainButton:SetButtonColor(ACC2.Colors["purple120"])
        mainButton:SetIconColor(ACC2.Colors["white80"])
        mainButton:SetIconMaterial(v.mat)
        mainButton.DoClick = function()
            v.func(ACC2Container, modifyCharacter, mainButton)
        end
        mainButton.MinMaxLerp = {60, 120}
    end

    if not modifyCharacter then
        local backButton = vgui.Create("ACC2:SlideButton", buttonScroll)
        backButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
        backButton:InclineButton(ACC2.ScrW*0.01)
        backButton:Dock(RIGHT)
        backButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
        backButton:SetButtonColor(ACC2.Colors["purple120"])
        backButton:SetIconColor(ACC2.Colors["white80"])
        backButton:SetIconMaterial(ACC2.Materials["return"])
        backButton.DoClick = function()
            ACC2.CurrentFuncIdCalled = math.Clamp(ACC2.CurrentFuncIdCalled - 1, 1, 999)
            callStepById(ACC2.CurrentFuncIdCalled)
        end
        backButton.MinMaxLerp = {60, 120}
    end

    local disableLastName = ACC2.GetSetting("disableLastName", "boolean")

    local scrollCustomization = vgui.Create("DScrollPanel", ACC2Container)
    scrollCustomization:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.7)
    scrollCustomization:SetPos(ACC2.ScrW*0.04, ACC2.ScrH*0.17)

    local containerNameLastName = vgui.Create("DPanel", scrollCustomization)
    containerNameLastName:SetSize(ACC2.ScrW*0.17, ACC2.ScrH*0.05)
    containerNameLastName:Dock(TOP)
    containerNameLastName:DockMargin(0, 0, 0, ACC2.ScrH*0.014)
    containerNameLastName.Paint = function() end
    
    local baseNameEntryText = ACC2.GetSentence("firstName")

    local containerName = vgui.Create("DPanel", containerNameLastName)
    containerName:SetSize(disableLastName and ACC2.ScrW*0.34 or ACC2.ScrW*0.17, ACC2.ScrH*0.05)
    containerName.Paint = function(self, w, h)
        if disableLastName then
            drawPanelWithPolygon(self, w, h, nil, nil, "", ACC2.Colors["white10"], ACC2.Materials["info"])
        else
            drawPanelWithPolygon(self, w, h, true, nil, "", ACC2.Colors["white10"], ACC2.Materials["info"])
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

    local nameEntry = vgui.Create("DTextEntry", containerName)
    nameEntry:Dock(FILL)
    nameEntry:DockMargin(ACC2.ScrW*0.035, ACC2.ScrH*0.005, ACC2.ScrW*0.012, 5)
    nameEntry:SetText(baseNameEntryText)
    nameEntry:SetFont("ACC2:Font:06")
    nameEntry:SetTextColor(ACC2.Colors["white80"])
    nameEntry:SetDrawLanguageID(false)
    nameEntry.Paint = function(self, w, h) 
        self:DrawTextEntryText(ACC2.Colors["white80"], ACC2.Colors["white80"], ACC2.Colors["white80"])
    end
    nameEntry.OnLoseFocus = function(self)
        if string.Trim(self:GetText()) == "" then
            self:SetText(baseNameEntryText)
        end
    end
    nameEntry.OnGetFocus = function(self)
        if string.Trim(self:GetText()) == baseNameEntryText then
            self:SetText("")
        end
    end
    nameEntry.OnChange = function(self)
        ACC2.TableCreationCharacter["name"] = self:GetText()
    end

    if modifyCharacter then
        if ACC2.Characters && istable(ACC2.Characters[characterId]) then
            local name = ACC2.Characters[characterId]["name"]
            
            if isstring(name) then
                nameEntry:SetText(name)
                ACC2.TableCreationCharacter["name"] = name
            end
        end
    end

    local lastNameEntry
    if not disableLastName then
        local baseLastNameEntryText = ACC2.GetSentence("lastName")

        local containerLastName = vgui.Create("DPanel", containerNameLastName)
        containerLastName:SetSize(ACC2.ScrW*0.17, ACC2.ScrH*0.05)
        containerLastName:SetPos(ACC2.ScrW*0.17, 0)
        containerLastName.Paint = function(self, w, h)
            drawPanelWithPolygon(self, w, h, false, nil, "", ACC2.Colors["white10"], ACC2.Materials["info"])
        end

        lastNameEntry = vgui.Create("DTextEntry", containerLastName)
        lastNameEntry:Dock(FILL)
        lastNameEntry:DockMargin(ACC2.ScrW*0.043, ACC2.ScrH*0.005, ACC2.ScrW*0.012, 5)
        lastNameEntry:SetText(baseLastNameEntryText)
        lastNameEntry:SetFont("ACC2:Font:06")
        lastNameEntry:SetTextColor(ACC2.Colors["white80"])
        lastNameEntry:SetDrawLanguageID(false)
        lastNameEntry.Paint = function(self, w, h)
            self:DrawTextEntryText(ACC2.Colors["white80"], ACC2.Colors["white80"], ACC2.Colors["white80"])
        end
        lastNameEntry.OnLoseFocus = function(self)
            if string.Trim(self:GetText()) == "" then
                self:SetText(baseLastNameEntryText)
            end
        end
        lastNameEntry.OnGetFocus = function(self)
            if string.Trim(self:GetText()) == baseLastNameEntryText then
                self:SetText("")
            end
        end
        lastNameEntry.OnChange = function(self)
            ACC2.TableCreationCharacter["lastName"] = self:GetText()
        end

        if modifyCharacter then
            if ACC2.Characters && istable(ACC2.Characters[characterId]) then
                local lastName = ACC2.Characters[characterId]["lastName"]
                
                if isstring(lastName) then
                    lastNameEntry:SetText(lastName)
                    ACC2.TableCreationCharacter["lastName"] = lastName
                end
            end
        end
    end

    if ACC2.GetSetting("randomNameEnable", "boolean") then
        local randomName = vgui.Create("DImageButton", ACC2Container)
        randomName:SetSize(ACC2.ScrH*0.025, ACC2.ScrH*0.025)
        randomName:SetPos(ACC2.ScrW*0.365, ACC2.ScrH*0.133)
        randomName:SetText("")
        randomName:SetImage("advanced_character_creator/random.png")
        randomName:SetColor(ACC2.Colors["white100"])
        randomName.DoClick = function()
            local charactersName = ACC2.GetSetting("randomName", "table")
            local name = charactersName[math.random(1, #charactersName)]

            if IsValid(nameEntry) then
                nameEntry:SetText(name)
                ACC2.TableCreationCharacter["name"] = name
            else
                ACC2.TableCreationCharacter["name"] = ""
            end
            
            local charactersLastName = ACC2.GetSetting("randomLastName", "table")
            local lastName = charactersLastName[math.random(1, #charactersLastName)]

            if IsValid(lastNameEntry) then
                lastNameEntry:SetText(lastName)
                ACC2.TableCreationCharacter["lastName"] = lastName
            else
                ACC2.TableCreationCharacter["lastName"] = ""
            end
        end
    end

    if ACC2.GetSetting("enableAge", "boolean") then
        local containerAge = vgui.Create("DPanel", scrollCustomization)
        containerAge:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.05)
        containerAge:Dock(TOP)
        containerAge:DockMargin(0, 0, 0, ACC2.ScrH*0.014)
        
        local minAge, maxAge = (ACC2.GetSetting("minimumAge", "number") or 18), (ACC2.GetSetting("maximumAge", "number") or 80)

        local sliderAge = vgui.Create("ACC2:Slider", containerAge)
        sliderAge:SetSize(ACC2.ScrW*0.16, ACC2.ScrH*0.05)
        sliderAge:SetPos(ACC2.ScrW*0.165, ACC2.ScrH*0.002)
        sliderAge:SetMin(minAge)
        sliderAge:SetMax(maxAge)
        sliderAge:SetValue(minAge + (maxAge-minAge)/2)
        sliderAge.OnValueChanged = function(self)
            ACC2.TableCreationCharacter["age"] = math.Round(self:GetValue())
        end

        containerAge.Paint = function(self, w, h)
            drawPanelWithPolygon(self, w, h, nil, nil, ACC2.GetSentence("age"), ACC2.Colors["white10"], ACC2.Materials["birthday"])

            draw.SimpleText((ACC2.GetSentence("years")):format(math.Round(sliderAge:GetValue())), "ACC2:Font:04", w*0.47, h/2, ACC2.Colors["white"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        
        if modifyCharacter then    
            if ACC2.Characters && istable(ACC2.Characters[characterId]) then
                local age = tonumber(ACC2.Characters[characterId]["age"])
                
                if isnumber(age) then
                    age = math.Clamp(age, minAge, maxAge)

                    sliderAge:SetValue(age)
                    ACC2.TableCreationCharacter["age"] = age
                end
            end
        end    
    end

    if ACC2.GetSetting("enableSize", "boolean") then
        local containerSize = vgui.Create("DPanel", scrollCustomization)
        containerSize:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.05)
        containerSize:Dock(TOP)
        containerSize:DockMargin(0, 0, 0, ACC2.ScrH*0.014)
        
        local minSize, maxSize, maxSizeConvertion = (ACC2.GetSetting("minSizeValue", "number") or 0.9), (ACC2.GetSetting("maxSizeValue", "number") or 1.1), (ACC2.GetSetting("maxSizeConvertion", "number") or 120)

        local sliderSize = vgui.Create("ACC2:Slider", containerSize)
        sliderSize:SetSize(ACC2.ScrW*0.16, ACC2.ScrH*0.05)
        sliderSize:SetPos(ACC2.ScrW*0.165, ACC2.ScrH*0.002)
        sliderSize:SetMin(minSize-0.15)
        sliderSize:SetMax(maxSize)
        sliderSize:SetValue(minSize + (maxSize-minSize)/2)
        sliderSize.OnValueChanged = function(self)
            ACC2.TableCreationCharacter["size"] = self:GetValue()
        end

        local defaultModelScale = dModel.Entity:GetModelScale()
        containerSize.Paint = function(self, w, h)
            drawPanelWithPolygon(self, w, h, nil, nil, ACC2.GetSentence("size"), ACC2.Colors["white10"], ACC2.Materials["size"])

            local value = sliderSize:GetValue()

            local ent = dModel.Entity
            if IsValid(ent) then
                ent:SetModelScale(math.Clamp(value*defaultModelScale, minSize, maxSize))
            end

            draw.SimpleText((ACC2.GetSentence("height")):format(math.Round(maxSizeConvertion*value/maxSize)), "ACC2:Font:04", w*0.47, h/2, ACC2.Colors["white"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        if modifyCharacter then    
            if ACC2.Characters && istable(ACC2.Characters[characterId]) then
                local size = tonumber(ACC2.Characters[characterId]["size"])
                
                if isnumber(size) then
                    
                    sliderSize:SetValue(size)
                    ACC2.TableCreationCharacter["size"] = size
                end
            end
        end
    end

    if ACC2.GetSetting("enableCharacterDescription", "boolean") then
        local containerDescription = vgui.Create("DPanel", scrollCustomization)
        containerDescription:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.05)
        containerDescription:Dock(TOP)
        containerDescription:DockMargin(0, 0, 0, ACC2.ScrH*0.014)
    
        containerDescription.Paint = function(self, w, h)
            drawPanelWithPolygon(self, w, h, nil, nil, "", ACC2.Colors["white10"], ACC2.Materials["icon_edit"])
        end
    
        local defaultDescription = ACC2.GetSentence("description")
    
        local descriptionEntry = vgui.Create("DTextEntry", containerDescription)
        descriptionEntry:Dock(FILL)
        descriptionEntry:DockMargin(ACC2.ScrW*0.032, ACC2.ScrH*0.005, ACC2.ScrW*0.012, 5)
        descriptionEntry:SetText(defaultDescription)
        descriptionEntry:SetFont("ACC2:Font:06")
        descriptionEntry:SetTextColor(ACC2.Colors["white80"])
        descriptionEntry:SetDrawLanguageID(false)
        descriptionEntry.Paint = function(self, w, h)
            self:DrawTextEntryText(ACC2.Colors["white80"], ACC2.Colors["white80"], ACC2.Colors["white80"])
        end
        descriptionEntry.OnLoseFocus = function(self)
            if string.Trim(self:GetText()) == "" then
                self:SetText(defaultDescription)
            end
        end
        descriptionEntry.OnGetFocus = function(self)
            if string.Trim(self:GetText()) == defaultDescription then
                self:SetText("")
            end
        end
        descriptionEntry.OnChange = function(self)
            ACC2.TableCreationCharacter["description"] = self:GetText()
        end

        if modifyCharacter then    
            if ACC2.Characters && istable(ACC2.Characters[characterId]) then
                local description = ACC2.Characters[characterId]["description"]
                
                if isstring(description) && description != "" then
                    
                    descriptionEntry:SetText(description)
                    ACC2.TableCreationCharacter["description"] = description
                end
            end
        end
    end

    local modelList
    local containerGroup = vgui.Create("DPanel", scrollCustomization)
    containerGroup:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.05)
    containerGroup:Dock(TOP)
    containerGroup:DockMargin(0, 0, 0, ACC2.ScrH*0.014)
    containerGroup.Paint = function() end

    if modifyCharacter then
        local characterId = ACC2.GetNWVariables("characterId", ACC2.LocalPlayer)
        
        if ACC2.Characters && istable(ACC2.Characters[characterId]) then
            local factionId = tonumber(ACC2.Characters[characterId]["factionId"])
            
            if isnumber(factionId) then
                ACC2.Factions = ACC2.Factions or {}
                
                local faction = ACC2.Factions[factionId]
                if istable(faction) then
                    models = faction["models"] or {}
                end
            end
        end
        if not istable(models) then
            models = defaultModels
        end
    end

    local onlyOneGroup = (istable(models) and true or ACC2.GetSetting("onlyOneModelGroup", "boolean"))
    local lerpFirstGroupSeletor, lerpSecondGroupSelector = 255, 0

    ACC2.TableCreationCharacter["sexSelected"] = 1 

    local defaultModel
    if modifyCharacter then
        if ACC2.Characters && istable(ACC2.Characters[characterId]) then
            local sexSelected = ACC2.Characters[characterId]["sexSelected"]
            
            if isnumber(sexSelected) then
                ACC2.TableCreationCharacter["sexSelected"] = sexSelected
            end

            defaultModel = ACC2.Characters[characterId]["model"]
        end
    end
    
    local firstGroupSelector = vgui.Create("DButton", containerGroup)
    firstGroupSelector:SetSize((onlyOneGroup and ACC2.ScrW*0.34 or ACC2.ScrW*0.17), ACC2.ScrH*0.05)
    firstGroupSelector:SetText("")

    firstGroupSelector.Paint = function(self, w, h)
        lerpFirstGroupSeletor = Lerp(FrameTime()*5, lerpFirstGroupSeletor, (ACC2.TableCreationCharacter["sexSelected"] == 1 and 255 or 0))
        
        drawPanelWithPolygon(self, w, h, true, nil, "", ACC2.Colors["white10"])
        
        local colorPurple = ColorAlpha(ACC2.Colors["purple3"], lerpFirstGroupSeletor)
        local name = istable(models) and ACC2.GetSentence("appearances") or ACC2.GetSetting("groupName1", "string")
        
        if onlyOneGroup then
            drawPanelWithPolygon(self, w, h, nil, nil, name, colorPurple, ACC2.Materials["user"])
        else
            drawPanelWithPolygon(self, w, h, true, nil, name, colorPurple, ACC2.Materials["user"])
        end
    end

    firstGroupSelector.DoClick = function()
        ACC2.TableCreationCharacter["sexSelected"] = 1
        
        reloadModels(istable(models) and models or (ACC2.GetSetting("defaultModelGroup1", "table") or {}), modelList, dModel, defaultModel, ACC2.Characters[characterId])
    end
    
    if not onlyOneGroup then
        local secondGroupSelector = vgui.Create("DButton", containerGroup)
        secondGroupSelector:SetSize(ACC2.ScrW*0.17, ACC2.ScrH*0.05)
        secondGroupSelector:SetPos(ACC2.ScrW*0.17, 0)
        secondGroupSelector:SetText("")

        secondGroupSelector.Paint = function(self, w, h)
            lerpSecondGroupSelector = Lerp(FrameTime()*5, lerpSecondGroupSelector, (ACC2.TableCreationCharacter["sexSelected"] == 2 and 255 or 0))

            local color = ColorAlpha(ACC2.Colors["purple3"], lerpSecondGroupSelector)

            drawPanelWithPolygon(self, w, h, false, nil, "", ACC2.Colors["white10"])
            drawPanelWithPolygon(self, w, h, false, nil, ACC2.GetSetting("groupName2", "string"), color, ACC2.Materials["user"])
        end

        secondGroupSelector.DoClick = function()
            ACC2.TableCreationCharacter["sexSelected"] = 2
            
            reloadModels(istable(models) and models or (ACC2.GetSetting("defaultModelGroup2", "table") or {}), modelList, dModel, defaultModel, ACC2.Characters[characterId])
        end
    end

    scrollModelList = vgui.Create("ACC2:DScroll", scrollCustomization) 
    scrollModelList:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.36)
    scrollModelList:Dock(TOP)
    scrollModelList:DockMargin(0, ACC2.ScrH*0.01, 0, 0)

    modelList = vgui.Create("DIconLayout", scrollModelList)
    modelList:Dock(FILL)
    modelList:SetSpaceY(ACC2.ScrH*0.02)
    modelList:SetSpaceX(ACC2.ScrW*0.008)
    
    local defaultModels = {}
    if ACC2.TableCreationCharacter["sexSelected"] == 1 then
        defaultModels = (ACC2.GetSetting("defaultModelGroup1", "table") or {})
    elseif ACC2.TableCreationCharacter["sexSelected"] == 2 then
        defaultModels = (ACC2.GetSetting("defaultModelGroup2", "table") or {})
    end

    reloadModels((istable(models) and models or defaultModels), modelList, dModel, defaultModel, ACC2.Characters[characterId])

    local lerpConfirmButton = 255

    local confirmButton = vgui.Create("DButton", ACC2Container)
    confirmButton:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.05)
    confirmButton:SetPos(ACC2.ScrW*0.04, ACC2.ScrH*0.885)
    confirmButton:SetText("")
    confirmButton.Paint = function(self, w, h)
        lerpConfirmButton = Lerp(FrameTime()*3, lerpConfirmButton, (self:IsHovered() and 50 or 100))

        surface.SetDrawColor(ACC2.Colors["purple3"].r, ACC2.Colors["purple3"].g, ACC2.Colors["purple3"].b, lerpConfirmButton)
        surface.DrawRect(0, 0, w, h)

        local price = ACC2.GetSetting("priceToModifyCharacter", "number")

        if not ACC2.GetSetting("bodygroupMenu", "boolean") then
            if isnumber(price) && price > 0 then
                draw.SimpleText(ACC2.GetSentence("pay"):format(ACC2.formatMoney(price)), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText(ACC2.GetSentence("next"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        else
            if IsValid(dModel.Entity) && #dModel.Entity:GetBodyGroups() > 1 then
                draw.SimpleText(ACC2.GetSentence("next"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                if isnumber(price) && price > 0 && modifyCharacter then
                    draw.SimpleText(ACC2.GetSentence("pay"):format(ACC2.formatMoney(price)), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(ACC2.GetSentence("next"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
        end

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.955-h*0.1/2, h/2-h*0.28/2, h*0.28, h*0.28)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.955-h*0.35/2, h/2-h*0.28/2, h*0.28, h*0.28)

        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(w*0.955, h/2, h*0.27, 360)
    end
    confirmButton.DoClick = function()
        if not isstring(ACC2.TableCreationCharacter["name"]) then ACC2.TableCreationCharacter["name"] = "" end

        local name = string.Trim(ACC2.TableCreationCharacter["name"])
        local minCharacterName, maxCharacterName = (ACC2.GetSetting("minCharacterName", "number") or 3), (ACC2.GetSetting("maxCharacterName", "number") or 8)

        if #name < minCharacterName or #name > maxCharacterName then
            ACC2.Notification(5, ACC2.GetSentence("nameErrorNotify"):format(minCharacterName, maxCharacterName))
            return
        end

        if not isstring(ACC2.TableCreationCharacter["lastName"]) then ACC2.TableCreationCharacter["lastName"] = "" end

        local lastName = string.Trim(ACC2.TableCreationCharacter["lastName"])
        local disableLastName = ACC2.GetSetting("disableLastName", "boolean")
        
        if not disableLastName then
            local minCharacterLastName, maxCharacterLastName = (ACC2.GetSetting("minCharacterLastName", "number") or 3), (ACC2.GetSetting("maxCharacterLastName", "number") or 8)
           
            if #lastName < minCharacterLastName or #lastName > maxCharacterLastName then
                ACC2.Notification(5, ACC2.GetSentence("lastNameErrorNotify"):format(minCharacterLastName, maxCharacterLastName))
                return
            end
        end
    
        if not ACC2.GetSetting("bodygroupMenu", "boolean") then
            ACC2.SaveCharacter(modifyCharacter)
        else
            local count = 0
            for k, v in ipairs(dModel.Entity:GetBodyGroups()) do
                if v.num == 1 then continue end
                count = count + 1 
            end

            if IsValid(dModel.Entity) && count > 1 then
                ACC2.ModifyBodygroups(dModel:GetModel(), modifyCharacter)
            else
                ACC2.SaveCharacter(modifyCharacter)
            end
        end
    end

    ACC2.CurrentFuncIdCalled = ACC2.CurrentFuncIdCalled + 1

    ACC2.FunctionsCalled[ACC2.CurrentFuncIdCalled] = {
        ["func"] = ACC2.CreateCharacter,
        ["args"] = {models, modifyCharacter},
    }
end

function ACC2.RPName()
    ACC2.TableCreationCharacter = ACC2.TableCreationCharacter or {}
    if IsValid(ACC2Container) then ACC2Container:Remove() end
    
    local disableLastName = ACC2.GetSetting("disableLastName", "boolean")

    ACC2Container = vgui.Create("DFrame")
    ACC2Container:SetSize(ACC2.ScrW*0.3, disableLastName and ACC2.ScrH*0.215 or ACC2.ScrH*0.275)
    ACC2Container:SetDraggable(false)
    ACC2Container:ShowCloseButton(false)
    ACC2Container:MakePopup()
    ACC2Container:SetTitle("")
    ACC2Container:Center()
    ACC2Container.startTime = SysTime()
    
    ACC2Container.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 10)

        surface.SetDrawColor(ACC2.Colors["blackpurpledisful225"])
        surface.DrawRect(0, 0, w, h)

        
        draw.DrawText(ACC2.GetSentence("nameChangerTitle"), "ACC2:Font:23", w*0.04, h*0.075, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        --draw.DrawText(ACC2.GetSentence("nameChangerDescription"), "ACC2:Font:24", w*0.04, ACC2.ScrH*0.04, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)    
    end

    local scrollRPName = vgui.Create("DScrollPanel", ACC2Container)
    scrollRPName:SetSize(ACC2.ScrW*0.275, ACC2.ScrH*0.7)
    scrollRPName:SetPos(ACC2.ScrW*0.013, ACC2.ScrH*0.085)

    local baseNameEntryText = ACC2.GetSentence("firstName")

    local containerName = vgui.Create("DPanel", scrollRPName)
    containerName:SetSize(ACC2.ScrW*0.17, ACC2.ScrH*0.05)
    containerName:Dock(TOP)
    containerName:DockMargin(0, 0, 0, ACC2.ScrH*0.01)
    containerName.Paint = function(self, w, h)
        drawPanelWithPolygon(self, w, h, nil, nil, "", ACC2.Colors["white10"], ACC2.Materials["info"])
    end

    local nameEntry = vgui.Create("DTextEntry", containerName)
    nameEntry:Dock(FILL)
    nameEntry:DockMargin(ACC2.ScrW*0.035, 5, ACC2.ScrW*0.012, 5)
    nameEntry:SetText(baseNameEntryText)
    nameEntry:SetFont("ACC2:Font:06")
    nameEntry:SetTextColor(ACC2.Colors["white80"])
    nameEntry:SetDrawLanguageID(false)
    nameEntry.Paint = function(self, w, h) 
        self:DrawTextEntryText(ACC2.Colors["white80"], ACC2.Colors["white80"], ACC2.Colors["white80"])
    end
    nameEntry.OnLoseFocus = function(self)
        if string.Trim(self:GetText()) == "" then
            self:SetText(baseNameEntryText)
        end
    end
    nameEntry.OnGetFocus = function(self)
        if string.Trim(self:GetText()) == baseNameEntryText then
            self:SetText("")
        end
    end
    nameEntry.OnChange = function(self)
        ACC2.TableCreationCharacter["name"] = self:GetText()
    end

    local characterId = ACC2.GetNWVariables("characterId", ACC2.LocalPlayer)

    if ACC2.Characters && istable(ACC2.Characters[characterId]) then
        local name = ACC2.Characters[characterId]["name"]
        
        if isstring(name) then
            nameEntry:SetText(name)
            ACC2.TableCreationCharacter["name"] = name
        end
    end

    if not disableLastName then
        local baseLastNameEntryText = ACC2.GetSentence("lastName")

        local containerLastName = vgui.Create("DPanel", scrollRPName)
        containerLastName:SetSize(ACC2.ScrW*0.17, ACC2.ScrH*0.05)
        containerLastName:Dock(TOP)
        containerLastName:DockMargin(0, 0, 0, ACC2.ScrH*0.01)
        containerLastName.Paint = function(self, w, h)
            drawPanelWithPolygon(self, w, h, nil, nil, "", ACC2.Colors["white10"], ACC2.Materials["info"])
        end

        local lastNameEntry = vgui.Create("DTextEntry", containerLastName)
        lastNameEntry:Dock(FILL)
        lastNameEntry:DockMargin(ACC2.ScrW*0.035, 5, ACC2.ScrW*0.012, 5)
        lastNameEntry:SetText(baseLastNameEntryText)
        lastNameEntry:SetFont("ACC2:Font:06")
        lastNameEntry:SetTextColor(ACC2.Colors["white80"])
        lastNameEntry:SetDrawLanguageID(false)
        lastNameEntry.Paint = function(self, w, h)
            self:DrawTextEntryText(ACC2.Colors["white80"], ACC2.Colors["white80"], ACC2.Colors["white80"])
        end
        lastNameEntry.OnLoseFocus = function(self)
            if string.Trim(self:GetText()) == "" then
                self:SetText(baseLastNameEntryText)
            end
        end
        lastNameEntry.OnGetFocus = function(self)
            if string.Trim(self:GetText()) == baseLastNameEntryText then
                self:SetText("")
            end
        end
        lastNameEntry.OnChange = function(self)
            ACC2.TableCreationCharacter["lastName"] = self:GetText()
        end

        if ACC2.Characters && istable(ACC2.Characters[characterId]) then
            local lastName = ACC2.Characters[characterId]["lastName"]
            
            if isstring(lastName) then
                lastNameEntry:SetText(lastName)
                ACC2.TableCreationCharacter["lastName"] = lastName
            end
        end
    end

    local lerpConfirmButton = 255

    local confirmButton = vgui.Create("DButton", scrollRPName)
    confirmButton:SetSize(ACC2.ScrW*0.17, ACC2.ScrH*0.05)
    confirmButton:Dock(TOP)
    confirmButton:SetText("")
    confirmButton.Paint = function(self, w, h)
        lerpConfirmButton = Lerp(FrameTime()*3, lerpConfirmButton, (self:IsHovered() and 50 or 100))

        surface.SetDrawColor(ACC2.Colors["purple3"].r, ACC2.Colors["purple3"].g, ACC2.Colors["purple3"].b, lerpConfirmButton)
        surface.DrawRect(0, 0, w, h)

        local modifiedName = false
        if ACC2.Characters[characterId] then
            local name = ACC2.Characters[characterId]["name"]
            local lastName = ACC2.Characters[characterId]["lastName"]

            if name != ACC2.TableCreationCharacter["name"] or lastName != ACC2.TableCreationCharacter["lastName"] then
                modifiedName = true
            end
        end

        local price = ACC2.GetSetting("priceToModifyRPName", "number")
        if not isnumber(price) or price == 0 or not modifyCharacter && not modifiedName then
            draw.SimpleText(ACC2.GetSentence("finish"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText((ACC2.GetSentence("pay"):format(ACC2.formatMoney(price)).. "                     10.000$"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.955-h*0.1/2, h/2-h*0.28/2, h*0.28, h*0.28)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.955-h*0.35/2, h/2-h*0.28/2, h*0.28, h*0.28)

        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(w*0.955, h/2, h*0.27, 360)
    end
    confirmButton.DoClick = function()
        if not isstring(ACC2.TableCreationCharacter["name"]) then ACC2.TableCreationCharacter["name"] = "" end

        local name = string.Trim(ACC2.TableCreationCharacter["name"])
        local minCharacterName, maxCharacterName = (ACC2.GetSetting("minCharacterName", "number") or 3), (ACC2.GetSetting("maxCharacterName", "number") or 8)

        if #name < minCharacterName or #name > maxCharacterName then
            ACC2.Notification(5, ACC2.GetSentence("nameErrorNotify"):format(minCharacterName, maxCharacterName))
            return
        end

        if not isstring(ACC2.TableCreationCharacter["lastName"]) then ACC2.TableCreationCharacter["lastName"] = "" end

        local modifiedName = false
        if ACC2.Characters[characterId] then
            local name = ACC2.Characters[characterId]["name"]
            local lastName = ACC2.Characters[characterId]["lastName"]

            if name != ACC2.TableCreationCharacter["name"] or lastName != ACC2.TableCreationCharacter["lastName"] then
                modifiedName = true
            end
        end

        if not modifiedName then
            if IsValid(ACC2Container) then ACC2Container:Remove() end
            return
        end

        local lastName = string.Trim(ACC2.TableCreationCharacter["lastName"])

        if not disableLastName then
            local minCharacterLastName, maxCharacterLastName = (ACC2.GetSetting("minCharacterLastName", "number") or 3), (ACC2.GetSetting("maxCharacterLastName", "number") or 8)
            
            if #lastName < minCharacterLastName or #lastName > maxCharacterLastName then
                ACC2.Notification(5, ACC2.GetSentence("lastNameErrorNotify"):format(minCharacterLastName, maxCharacterLastName))
                return
            end
        end

        net.Start("ACC2:Character")
            net.WriteUInt(4, 4)
            net.WriteString(ACC2.TableCreationCharacter["name"])
            net.WriteString(ACC2.TableCreationCharacter["lastName"])
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", ACC2Container)
    close:SetSize(ACC2.ScrH*0.03, ACC2.ScrH*0.03)
    close:SetPos(ACC2Container:GetWide()*0.9, ACC2.ScrH*0.02)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(ACC2.Colors["white100"], closeLerp))
        surface.SetMaterial(ACC2.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        ACC2Container:Remove()
    end
end

function ACC2.ModifyBodygroups(model, modifyCharacter)
    ACC2.TableCreationCharacter = ACC2.TableCreationCharacter or {}
    if IsValid(ACC2Container) then ACC2Container:Remove() end
    
    ACC2Container = vgui.Create("DFrame")
    ACC2Container:SetSize(ACC2.ScrW, ACC2.ScrH)
    ACC2Container:SetDraggable(false)
    ACC2Container:ShowCloseButton(false)
    ACC2Container:MakePopup()
    ACC2Container:SetTitle("")
    ACC2Container.startTime = SysTime()
    
    ACC2Container.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 15)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))

        surface.SetDrawColor(ACC2.Colors["purple3"])
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["background"])
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetFont("ACC2:Font:01")

        local base = ACC2.GetSentence("characterCreator")
        local textSize = surface.GetTextSize(base)
                
        draw.DrawText(base, "ACC2:Font:01", w*0.04, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(" - ".."CREATION", "ACC2:Font:02", w*0.043 + textSize, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(string.Replace(ACC2.GetSetting("shortDescription", "string"), "{name}", ACC2.LocalPlayer:Name()), "ACC2:Font:03", w*0.04, h*0.09, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
        
        surface.SetFont("ACC2:Font:05")

        ACC2.DrawNotification()
    end
    
    local dModel = vgui.Create("ACC2:DModel", ACC2Container)
    dModel:SetSize(ACC2.ScrW*0.25, ACC2.ScrH*1)
    dModel:SetPos(ACC2.ScrW*0.72, 0)
    dModel:ACC2SetFOV(35)
    dModel:ACC2SetFOVBase(35)
    dModel:SetModel(model)
    dModel.LayoutEntity = function() end
    dModel:CanRotateCamera(false)
    dModel:SetFocusEntity(dModel.Entity)

    --[[ This scroll permit to add all button on the top right of the screen ]]
    local buttonScroll = vgui.Create("DHorizontalScroller", ACC2Container)
    buttonScroll:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.046)
    buttonScroll:SetPos(ACC2.ScrW*0.68, ACC2.ScrH*0.05)

    local buttons = ACC2.CreateButtons()

    for k, v in ipairs(buttons) do
        local mainButton = vgui.Create("ACC2:SlideButton", buttonScroll)
        mainButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
        mainButton:InclineButton(ACC2.ScrW*0.01)
        mainButton:Dock(RIGHT)
        mainButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
        mainButton:SetButtonColor(ACC2.Colors["purple120"])
        mainButton:SetIconColor(ACC2.Colors["white80"])
        mainButton:SetIconMaterial(v.mat)
        mainButton.DoClick = function()
            v.func(ACC2Container, modifyCharacter, mainButton)
        end
        mainButton.MinMaxLerp = {60, 120}
    end

    local backButton = vgui.Create("ACC2:SlideButton", buttonScroll)
    backButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
    backButton:InclineButton(ACC2.ScrW*0.01)
    backButton:Dock(RIGHT)
    backButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
    backButton:SetButtonColor(ACC2.Colors["purple120"])
    backButton:SetIconColor(ACC2.Colors["white80"])
    backButton:SetIconMaterial(ACC2.Materials["return"])
    backButton.DoClick = function()
        ACC2.CurrentFuncIdCalled = math.Clamp(ACC2.CurrentFuncIdCalled - 1, 1, 999)
        callStepById(ACC2.CurrentFuncIdCalled)
    end
    backButton.MinMaxLerp = {60, 120}

    local scrollBodygroups = vgui.Create("DScrollPanel", ACC2Container)
    scrollBodygroups:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.6)
    scrollBodygroups:SetPos(ACC2.ScrH*0.07, ACC2.ScrH*0.17)
    
    local bodygroups = ACC2.LocalPlayer:GetBodyGroups()
    local ent = dModel.Entity
    if IsValid(ent) then
        ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
        
        for k, v in pairs(ent:GetBodyGroups()) do
            if v.num == 1 then continue end
            local name = ent:GetBodygroupName(v.id)
            
            local containerBodygroup = vgui.Create("DPanel", scrollBodygroups)
            containerBodygroup:SetSize(ACC2.ScrW*0.5, ACC2.ScrH*0.05)
            containerBodygroup:Dock(TOP)
            containerBodygroup:DockMargin(0, 0, 0, ACC2.ScrH*0.01)
            
            local sliderBodygroup = vgui.Create("ACC2:Slider", containerBodygroup)
            sliderBodygroup:SetSize(ACC2.ScrW*0.16, ACC2.ScrH*0.05)
            sliderBodygroup:SetPos(ACC2.ScrW*0.16, ACC2.ScrH*0.002)
            sliderBodygroup:SetMin(0)
            sliderBodygroup:SetMax(v.num-1)
            sliderBodygroup:SetValue(0)
            if modifyCharacter then
                local value = ACC2.LocalPlayer:GetBodygroup(v.id)
                sliderBodygroup:SetValue(value)

                ACC2.TableCreationCharacter["bodygroups"] = ACC2.TableCreationCharacter["bodygroups"] or {}
                ACC2.TableCreationCharacter["bodygroups"][v.id] = value
            end

            sliderBodygroup.OnValueChanged = function(self)
                ACC2.TableCreationCharacter["bodygroups"] = ACC2.TableCreationCharacter["bodygroups"] or {}
                ACC2.TableCreationCharacter["bodygroups"][v.id] = math.Round(self:GetValue())
            end
            
            containerBodygroup.Paint = function(self, w, h)
                ent:SetBodygroup(v.id, sliderBodygroup:GetValue())

                draw.RoundedBox(4, 0, 0, w, h, ACC2.Colors["white10"])
                draw.SimpleText(name, "ACC2:Font:06", ACC2.ScrW*0.015, h/2.1, ACC2.Colors["white80"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end
    end

    local lerpConfirmButton = 255
    local confirmButton = vgui.Create("DButton", ACC2Container)
    confirmButton:SetSize(ACC2.ScrW*0.34, ACC2.ScrH*0.05)
    confirmButton:SetPos(ACC2.ScrW*0.04, ACC2.ScrH*0.885)
    confirmButton:SetText("")
    confirmButton.Paint = function(self, w, h)
        lerpConfirmButton = Lerp(FrameTime()*3, lerpConfirmButton, (self:IsHovered() and 50 or 100))

        surface.SetDrawColor(ACC2.Colors["purple100"].r, ACC2.Colors["purple100"].g, ACC2.Colors["purple100"].b, lerpConfirmButton)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(ACC2.GetSentence("next"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.955-h*0.1/2, h/2-h*0.28/2, h*0.28, h*0.28)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.955-h*0.35/2, h/2-h*0.28/2, h*0.28, h*0.28)

        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(w*0.955, h/2, h*0.27, 360)
    end
    confirmButton.DoClick = function()
        ACC2.SaveCharacter(modifyCharacter)
    end

    ACC2.CurrentFuncIdCalled = ACC2.CurrentFuncIdCalled + 1
    
    ACC2.FunctionsCalled[ACC2.CurrentFuncIdCalled] = {
        ["func"] = ACC2.ModifyBodygroups,
        ["args"] = {model, modifyCharacter},
    }
end

function ACC2.SaveCharacter(modifyCharacter)
    ACC2.TableCreationCharacter = ACC2.TableCreationCharacter or {}

    if not isstring(ACC2.TableCreationCharacter["name"]) or ACC2.TableCreationCharacter["name"] == "" then return end

    if not isstring(ACC2.TableCreationCharacter["lastName"]) then 
        ACC2.TableCreationCharacter["lastName"] = "" 
    end
    
    local minAge, maxAge = (ACC2.GetSetting("minimumAge", "number") or 18), (ACC2.GetSetting("maximumAge", "number") or 80)
    local age = isnumber(ACC2.TableCreationCharacter["age"]) and math.Clamp(ACC2.TableCreationCharacter["age"], minAge, maxAge) or math.random(minAge, maxAge) 
    if not isnumber(age) then return end

    local minSize, maxSize = (ACC2.GetSetting("minSizeValue", "number") or 0.9), (ACC2.GetSetting("maxSizeValue", "number") or 1.1)
    local size = isnumber(ACC2.TableCreationCharacter["size"]) and math.Clamp(ACC2.TableCreationCharacter["size"], minSize, maxSize) or math.random(minSize, maxSize) 
    if not isnumber(size) then return end
    
    if not isstring(ACC2.TableCreationCharacter["model"]) or ACC2.TableCreationCharacter["model"] == "" then return end

    local factionId = ACC2.TableCreationCharacter["factionId"]
    if not isnumber(factionId) then factionId = 0 end

    ACC2.TableCreationCharacter["bodygroups"] = ACC2.TableCreationCharacter["bodygroups"] or {}

    if not isstring(ACC2.TableCreationCharacter["description"]) then ACC2.TableCreationCharacter["description"] = "" end
    if not isnumber(ACC2.TableCreationCharacter["sexSelected"]) then ACC2.TableCreationCharacter["sexSelected"] = 1 end

    net.Start("ACC2:Character")
        net.WriteUInt(1, 4)
        net.WriteBool(modifyCharacter)
        net.WriteString(ACC2.TableCreationCharacter["name"])
        net.WriteString(ACC2.TableCreationCharacter["lastName"])
        net.WriteUInt(age, 16)
        net.WriteFloat(size, 4)
        net.WriteUInt(ACC2.TableCreationCharacter["sexSelected"], 3)
        net.WriteString(ACC2.TableCreationCharacter["description"])
        net.WriteString(ACC2.TableCreationCharacter["model"])

        net.WriteUInt(table.Count(ACC2.TableCreationCharacter["bodygroups"]), 16)
        for k, v in pairs(ACC2.TableCreationCharacter["bodygroups"]) do
            net.WriteUInt(k, 16)
            net.WriteUInt(v, 16)
        end
        net.WriteUInt(factionId, 12)
    net.SendToServer()
end

local lerpSelectedCard, lerpDeleted, selectedFaction = {}, {}

local function autoWrapText(text, sizeMax, font, maxLine)
    local explodeString = string.Explode(" ", text)
    
    local linesTable, currentLine = {}, 1

    for k, v in ipairs(explodeString) do
        linesTable[currentLine] = linesTable[currentLine] or ""

        surface.SetFont(font)
        local size = (surface.GetTextSize(linesTable[currentLine])>=sizeMax)

        if size then
            currentLine = currentLine + 1

            if currentLine > maxLine then
                local lineBefore = (currentLine - 1)
                
                linesTable[lineBefore] = linesTable[lineBefore] or ""
                linesTable[lineBefore] = linesTable[lineBefore].."..." 
                break 
            end
            
            linesTable[currentLine] = linesTable[currentLine] or ""
            linesTable[currentLine] = linesTable[currentLine].." "..v
        else
            linesTable[currentLine] = linesTable[currentLine].." "..v
        end
    end

    local stringToDraw = ""

    for k, v in ipairs(linesTable) do
        stringToDraw = stringToDraw..(k>1 and "\n" or "")..v
    end

    return stringToDraw
end

local factionPanelById = {}
local function selectFaction(scrollFaction, factionId, factionTable, factionsTable)
    ACC2.TableCreationCharacter = ACC2.TableCreationCharacter or {}

    local factionPanel = vgui.Create("DButton", scrollFaction)
    factionPanel:SetSize(ACC2.ScrW*0.2215, ACC2.ScrH*0.55)
    factionPanel:SetText("")
    factionPanelById[factionId] = factionPanel

    factionPanel.Paint = function(self, w, h)
        --[[ Draw card ]]
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(ACC2.Materials["faction"])
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawTexturedRect(w*0.34, h*0.45, h*0.7, h*0.7)

        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white5"])
        ACC2.DrawSimpleCircle(w*0.5, h*0.305, h*0.23, 360)

        draw.SimpleText(factionTable["name"], "ACC2:Font:11", w/2, h*0.6, ACC2.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        lerpSelectedCard[factionId] = lerpSelectedCard[factionId] or 0
        lerpSelectedCard[factionId] = Lerp(FrameTime()*8, lerpSelectedCard[factionId], (factionId == selectedFaction and 255 or 0))

        surface.SetDrawColor(ACC2.Colors["purple3"].r, ACC2.Colors["purple3"].g, ACC2.Colors["purple3"].b, lerpSelectedCard[factionId] - 250)
        surface.DrawRect(0, 0, w, h)
        
        surface.SetDrawColor(ColorAlpha(ACC2.Colors["purple3"], lerpSelectedCard[factionId]))
        surface.DrawOutlinedRect(0, 0, w, h, ACC2.ScrH*0.005)

        draw.DrawText(autoWrapText(factionTable["description"], ACC2.ScrW*0.15, "ACC2:Font:12", 4), "ACC2:Font:12", w/2, h*0.64, ACC2.Colors["white100"], TEXT_ALIGN_CENTER)
    end
    factionPanel.DoClick = function()
        if isnumber(factionTable.factionUniqueId) then
            ACC2.TableCreationCharacter["factionId"] = factionTable.factionUniqueId

            selectedFaction = factionId
        elseif isnumber(factionId) then
            selectedFaction = factionId
        end
    end

    local factionLogo = vgui.Create("DButton", factionPanel)
    factionLogo:SetSize(ACC2.ScrH*0.35, ACC2.ScrH*0.35)
    factionLogo:SetPos(factionPanel:GetWide()/2-ACC2.ScrH*0.35/2, ACC2.ScrH*0.046)
    factionLogo:SetText("")
    factionLogo.Paint = function(self, w, h)
        ACC2.MaskStencil(function()
            draw.NoTexture()
            surface.SetDrawColor(ACC2.Colors["white2"])
            ACC2.DrawSimpleCircle(w*0.505, h*0.355, w*0.3, 360)
        end, 
        function()
            local factionMaterial = ACC2.CachedURLImage[(istable(factionsTable) and "category_image_" or "faction_image_")..factionId]

            if factionMaterial then
                surface.SetDrawColor(ACC2.Colors["white"])
                surface.SetMaterial(factionMaterial)
                surface.DrawTexturedRect(w*0.5-w*0.59/2, h*0.06, w*0.6, w*0.6)
            end
        end, false)
    end
    factionLogo.DoClick = function()
        if isnumber(factionTable.factionUniqueId) then
            ACC2.TableCreationCharacter["factionId"] = factionTable.factionUniqueId

            selectedFaction = factionId
        elseif isnumber(factionId) then
            selectedFaction = factionId
        end
    end
    
    surface.SetFont("ACC2:Font:06")
    local sizeSelect = surface.GetTextSize(ACC2.GetSentence("selectCharacter")) + (ACC2.ScrW*0.01)*2 + ACC2.ScrW*0.005

    --[[ Select the Character of your choice ]]
    local selectButton = vgui.Create("ACC2:SlideButton", factionPanel)
    selectButton:SetSize(sizeSelect, ACC2.ScrH*0.045)
    selectButton:SetPos(factionPanel:GetWide()/2 - sizeSelect/2, ACC2.ScrH*0.47)
    selectButton:SetValue(ACC2.GetSentence("selectCharacter"))
    selectButton:InclineButton(ACC2.ScrW*0.01)
    selectButton:SetButtonColor(ACC2.Colors["purple120"])
    selectButton:SetIconColor(ACC2.Colors["white80"])
    selectButton:SetIconMaterial(nil)
    selectButton.DoClick = function() end
    selectButton.MinMaxLerp = {60, 120}

    selectButton.DoClick = function()
        if istable(factionsTable) then

            ACC2.FactionMenu(factionsTable)
            return
        end

        if isnumber(factionTable.factionUniqueId) then
            ACC2.TableCreationCharacter["factionId"] = factionTable.factionUniqueId
        end

        selectedFaction = factionId

        ACC2.NextFaction()
    end

    scrollFaction:AddPanel(factionPanel)
end

--[[ Get factions without category ]]
function ACC2.GetFactionsTable()
    local returnTable = {}
    local factionsByCategories = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

    for k, v in pairs(ACC2.Factions) do
        if not v.ranksAccess[ACC2.LocalPlayer:GetUserGroup()] && not v.ranksAccess["*"] then continue end
        
        factionsByCategories[v.groupId] = factionsByCategories[v.groupId] or {}
        factionsByCategories[v.groupId][k] = v
    end

    for k, v in pairs(ACC2.Categories) do
        if not v.ranksAccess[ACC2.LocalPlayer:GetUserGroup()] && not v.ranksAccess["*"] then continue end

        local factionsTable = factionsByCategories[v.categoryUniqueId] or {}
        if table.Count(factionsTable) <= 0 then continue end
        
        returnTable[v.categoryUniqueId] = v
        returnTable[v.categoryUniqueId]["factionsTable"] = factionsTable
    end

    for k, v in pairs(ACC2.Factions) do
        if not v.ranksAccess[ACC2.LocalPlayer:GetUserGroup()] && not v.ranksAccess["*"] then continue end
        if istable(ACC2.Categories[v.groupId]) then continue end

        table.insert(returnTable, v)
    end

    return returnTable
end

function ACC2.SetNextFaction(reverse, tbl)
    local tableToLoop = table.GetKeys(tbl)

    if reverse then
        table.sort(tableToLoop, function(a, b) 
            return (a < b) 
        end)
    else
        table.sort(tableToLoop, function(a, b) 
            return (a > b) 
        end)
    end

    local selectNext, findFaction

    for k, factionId in ipairs(tableToLoop) do
        if selectNext then
            findFaction = true
            scrollNow = true
            selectedFaction = factionId

            if tbl[factionId] && not tbl[factionId]["categoryUniqueId"] then
                ACC2.TableCreationCharacter["factionId"] = factionId
            end
            break
        end

        if factionId == selectedFaction then
            selectNext = true
        end
    end

    return selectedFaction
end

function ACC2.NextFaction()
    local factionId = ACC2.TableCreationCharacter["factionId"]
    if isnumber(factionId) then 
        local factionTable = ACC2.Factions[factionId] or {}
        local models = factionTable["models"]
        
        ACC2.CreateCharacter(models)
    else
        local returnTable = {}
        for k, v in pairs(ACC2.GetFactionsTable()) do
            if v.categoryUniqueId == selectedFaction then
                returnTable = v.factionsTable

                break
            end
        end

        ACC2.FactionMenu(returnTable)
    end
end

function ACC2.FactionMenu(factionTableToLoop)
    if IsValid(ACC2Container) then ACC2Container:Remove() end

    factionTableToLoop = factionTableToLoop or {}
    selectedFaction = nil
    lerpSelectedCard = {}
    ACC2.TableCreationCharacter["factionId"] = nil
    
    ACC2Container = vgui.Create("DFrame")
    ACC2Container:SetSize(ACC2.ScrW, ACC2.ScrH)
    ACC2Container:SetDraggable(false)
    ACC2Container:ShowCloseButton(false)
    ACC2Container:MakePopup()
    ACC2Container:SetTitle("")
    ACC2Container.startTime = SysTime()
    
    ACC2Container.Paint = function(self,w,h)
        ACC2.DrawBlur(self, 15)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))

        surface.SetDrawColor(ACC2.Colors["purple3"])
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["background"])
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(ACC2.Colors["white2"])
        draw.NoTexture()
        surface.DrawPoly(rectangle)

        surface.SetFont("ACC2:Font:01")

        local base = ACC2.GetSentence("characterCreator")
        local textSize = surface.GetTextSize(base)
                
        draw.DrawText(base, "ACC2:Font:01", w*0.04, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(" - ".."HOME", "ACC2:Font:02", w*0.043 + textSize, h*0.04, ACC2.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(string.Replace(ACC2.GetSetting("shortDescription", "string"), "{name}", ACC2.LocalPlayer:Name()), "ACC2:Font:03", w*0.04, h*0.09, ACC2.Colors["white100"], TEXT_ALIGN_LEFT)
        
        surface.SetFont("ACC2:Font:05")

        ACC2.DrawNotification()
    end

    local srollFaction = vgui.Create("DHorizontalScroller", ACC2Container)
    srollFaction:SetSize(ACC2.ScrW*0.8, ACC2.ScrH*0.55)
    srollFaction:SetPos(ACC2.ScrW*0.041, ACC2.ScrH*0.22)
    srollFaction:SetOverlap(-ACC2.ScrW*0.007)
    srollFaction.btnLeft.Paint = function() end
    srollFaction.btnRight.Paint = function() end
    srollFaction.OnMouseWheeled = function(self, dlta)
        srollFaction.ACC2ScrollPos = (self.OffsetX + dlta * -125)
    end

    srollFaction.Paint = function(self,w,h)
        if IsValid(factionPanelById[selectedFaction]) && scrollNow then
            srollFaction.ACC2ScrollPos = srollFaction.pnlCanvas:GetChildPosition(factionPanelById[selectedFaction]) - (ACC2.ScrW*0.2215)
            scrollNow = false
        end

        if isnumber(srollFaction.ACC2ScrollPos) then
            srollFaction.ACC2LerpScrollPos = Lerp(FrameTime()*5, srollFaction.ACC2LerpScrollPos or srollFaction.OffsetX, srollFaction.ACC2ScrollPos)
            srollFaction:SetScroll(srollFaction.ACC2LerpScrollPos)
        end
    end

    srollFaction.oldMouseWheeled = srollFaction.OnMouseWheeled
    srollFaction.OnMouseWheeled = function(self, dlta)
        if isnumber(srollFaction.ACC2ScrollPos) then
            srollFaction.ACC2ScrollPos = nil
        end

        self.oldMouseWheeled(self, dlta)
    end

    local fakeCard = vgui.Create("DPanel", ACC2Container)
    fakeCard:SetSize(ACC2.ScrW*0.2215, ACC2.ScrH*0.55)
    fakeCard:SetPos(ACC2.ScrW*-0.188, ACC2.ScrH*0.22)
    fakeCard.Paint = function(self, w, h)
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawRect(0, 0, w, h)

        surface.SetMaterial(ACC2.Materials["faction"])
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawTexturedRect(w*0.34, h*0.45, h*0.7, h*0.7)
    end
    
    local needFakeCard, firstFaction = 3
    for factionUniqueId, factionTable in pairs(factionTableToLoop) do
        local factionsTable = factionTable.factionsTable or nil

        if not firstFaction then
            if isnumber(factionTable.factionUniqueId) then
                selectedFaction = factionTable.factionUniqueId
                ACC2.TableCreationCharacter["factionId"] = factionTable.factionUniqueId

            elseif isnumber(factionTable.categoryUniqueId) then
                selectedFaction = factionTable.categoryUniqueId
            else
                selectedFaction = factionUniqueId
            end

            firstFaction = true
        end

        selectFaction(srollFaction, (istable(factionsTable) and factionTable.categoryUniqueId or factionTable.factionUniqueId), factionTable, factionsTable)

        needFakeCard = math.Clamp(needFakeCard - 1, 0, 3)
    end

    for i=1, needFakeCard do
        local fakeCard = vgui.Create("DPanel", srollFaction)
        fakeCard:SetSize(ACC2.ScrW*0.2215, ACC2.ScrH*0.55)
        fakeCard:SetPos(ACC2.ScrW*-0.188, ACC2.ScrH*0.22)
        fakeCard.Paint = function(self, w, h)
            surface.SetDrawColor(ACC2.Colors["white2"])
            surface.DrawRect(0, 0, w, h)
    
            surface.SetMaterial(ACC2.Materials["faction"])
            surface.SetDrawColor(ACC2.Colors["white2"])
            surface.DrawTexturedRect(w*0.34, h*0.45, h*0.7, h*0.7)
        end

        srollFaction:AddPanel(fakeCard)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */

    local fakeCard = vgui.Create("DPanel", ACC2Container)
    fakeCard:SetSize(ACC2.ScrW*0.2215/2, ACC2.ScrH*0.55)
    fakeCard.Paint = function(self, w, h)
        local sizeX, sizeY = ACC2.ScrW*0.2215, ACC2.ScrH*0.55

        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawRect(0, 0, sizeX, sizeY)

        surface.SetMaterial(ACC2.Materials["faction"])
        surface.SetDrawColor(ACC2.Colors["white2"])
        surface.DrawTexturedRect(sizeX*0.34, sizeY*0.45, sizeY*0.7, sizeY*0.7)
    end

    srollFaction:AddPanel(fakeCard)

    local dModel = vgui.Create("ACC2:DModel", ACC2Container)
    dModel:SetSize(ACC2.ScrW*0.25, ACC2.ScrH*1)
    dModel:SetPos(ACC2.ScrW*0.72, 0)
    dModel:ACC2SetFOV(35)
    dModel:ACC2SetFOVBase(35)
    dModel:SetModel(ACC2.GetSetting("defaultMenuModel", "string"))
    dModel.LayoutEntity = function() end
    dModel:CanRotateCamera(false)
    dModel:SetFocusEntity(dModel.Entity)
    
    local ent = dModel.Entity
    if IsValid(ent) then
        ent:SetAngles(ent:GetAngles() + ACC2.Constants["angleDModel1"])
    end

    --[[ This scroll permit to add all button on the top right of the screen ]]
    local buttonScroll = vgui.Create("DHorizontalScroller", ACC2Container)
    buttonScroll:SetSize(ACC2.ScrW*0.3, ACC2.ScrH*0.046)
    buttonScroll:SetPos(ACC2.ScrW*0.68, ACC2.ScrH*0.05)

    local buttons = ACC2.CreateButtons()

    for k, v in ipairs(buttons) do
        local mainButton = vgui.Create("ACC2:SlideButton", buttonScroll)
        mainButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
        mainButton:InclineButton(ACC2.ScrW*0.01)
        mainButton:Dock(RIGHT)
        mainButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
        mainButton:SetButtonColor(ACC2.Colors["purple120"])
        mainButton:SetIconColor(ACC2.Colors["white80"])
        mainButton:SetIconMaterial(v.mat)
        mainButton.DoClick = function()
            v.func(ACC2Container, nil, mainButton)
        end
        mainButton.MinMaxLerp = {60, 120}
    end

    local backButton = vgui.Create("ACC2:SlideButton", buttonScroll)
    backButton:SetSize(ACC2.ScrH*0.062, ACC2.ScrH*0.05)
    backButton:InclineButton(ACC2.ScrW*0.01)
    backButton:Dock(RIGHT)
    backButton:DockMargin(-ACC2.ScrW*0.007, 0, 0, 0)
    backButton:SetButtonColor(ACC2.Colors["purple120"])
    backButton:SetIconColor(ACC2.Colors["white80"])
    backButton:SetIconMaterial(ACC2.Materials["return"])
    backButton.DoClick = function()
        ACC2.CurrentFuncIdCalled = math.Clamp(ACC2.CurrentFuncIdCalled - 1, 1, 999)
        callStepById(ACC2.CurrentFuncIdCalled)
    end
    backButton.MinMaxLerp = {60, 120}

    local leftArrow = vgui.Create("DButton", ACC2Container)
    leftArrow:SetSize(ACC2.ScrH*0.022, ACC2.ScrH*0.022)
    leftArrow:SetPos(ACC2.ScrW*0.675, ACC2.ScrH*0.792)
    leftArrow:SetText("")
    leftArrow.Paint = function(self, w, h)
        surface.SetMaterial(ACC2.Materials["leftArrow"])
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    leftArrow.DoClick = function()
        ACC2.SetNextFaction(false, factionTableToLoop)
    end 

    local rightArrow = vgui.Create("DButton", ACC2Container)
    rightArrow:SetSize(ACC2.ScrH*0.022, ACC2.ScrH*0.022)
    rightArrow:SetPos(ACC2.ScrW*0.69, ACC2.ScrH*0.792)
    rightArrow:SetText("")
    rightArrow.Paint = function(self, w, h)
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    rightArrow.DoClick = function()
        ACC2.SetNextFaction(true, factionTableToLoop)
    end 

    local nextButton = vgui.Create("ACC2:SlideButton", ACC2Container)
    nextButton:SetSize(ACC2.ScrW*0.09, ACC2.ScrH*0.045)
    nextButton:SetPos(ACC2.ScrW*0.717, ACC2.ScrH*0.78)
    nextButton:SetValue(ACC2.GetSentence("next"))
    nextButton:InclineButton(ACC2.ScrW*0.01)
    nextButton:SetButtonColor(ACC2.Colors["purple120"])
    nextButton:SetIconColor(ACC2.Colors["white80"])
    nextButton:SetIconMaterial(nil)
    nextButton.DoClick = function()
        ACC2.NextFaction()
    end
    nextButton.MinMaxLerp = {60, 120}

    ACC2Container.PaintOver = function()
        if ACC2.RenderTarget[modelBaseName2] then
            surface.SetMaterial(ACC2.RenderTarget[modelBaseName2])
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(ACC2.ScrW*0.555, ACC2.ScrH*-0.04, ACC2.ScrW*0.58, ACC2.ScrH*0.95)
        end
    end

    ACC2.CurrentFuncIdCalled = ACC2.CurrentFuncIdCalled + 1

    ACC2.FunctionsCalled[ACC2.CurrentFuncIdCalled] = {
        ["func"] = ACC2.FactionMenu,
        ["args"] = {factionTableToLoop},
    }
end

function ACC2.WelcomeMenu()
    if IsValid(ACC2Container) then ACC2Container:Remove() end

    if ACC2.GetSetting("enableSoundCreated", "boolean") then
        ACC2.PlayURL(ACC2.GetSetting("soundCreatedLink", "string"), ACC2.GetSetting("soundCreatedVolume", "number"), true)
    end
    
    ACC2Container = vgui.Create("DFrame")
    ACC2Container:SetSize(ACC2.ScrW, ACC2.ScrH)
    ACC2Container:SetDraggable(false)
    ACC2Container:ShowCloseButton(false)
    ACC2Container:MakePopup()
    ACC2Container:SetTitle("")
    ACC2Container.startTime = SysTime()
    
    local lerpAnimation, lerpAnimation2 = -ACC2.ScrH, ACC2.ScrH*1.5
    ACC2Container.Paint = function(self,w,h)
        lerpAnimation = Lerp(FrameTime()*5, lerpAnimation, 0)
        lerpAnimation2 = Lerp(FrameTime()*8, lerpAnimation2, 0)

        ACC2.DrawBlur(self, 15)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))

        surface.SetDrawColor(ACC2.Colors["purple3"])
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["background"])
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetFont("ACC2:Font:01")

        local base = ACC2.GetSentence("characterCreator")
        local textSize = surface.GetTextSize(base)
                
        draw.DrawText(ACC2.GetSentence("welcomePlayer"):format(string.upper(ACC2.LocalPlayer:Name())), "ACC2:Font:01", w*0.5, lerpAnimation + h*0.55, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("welcomePlayerDesc"):format(string.upper(ACC2.GetSetting("serverName", "string"))), "ACC2:Font:05", w*0.5, lerpAnimation + h*0.61, ACC2.Colors["white100"], TEXT_ALIGN_CENTER)
        
        surface.SetFont("ACC2:Font:05")

        ACC2.DrawNotification()
    end

    local logo = vgui.Create("DPanel", ACC2Container)
    logo:SetSize(ACC2.ScrH*0.35, ACC2.ScrH*0.35)
    logo:SetPos(ACC2Container:GetWide()/2-ACC2.ScrH*0.35/2, lerpAnimation + ACC2.ScrH*0.28)
    logo.Paint = function(self, w, h)
        ACC2.MaskStencil(function()
            draw.NoTexture()
            surface.SetDrawColor(ACC2.Colors["white2"])
            ACC2.DrawSimpleCircle(w*0.505, h*0.355, w*0.3, 360)
        end, 
        function()
            local mat = ACC2.CachedURLImage["serverLogo"]

            if mat then
                surface.SetDrawColor(ACC2.Colors["white"])
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(w*0.5-w*0.59/2, h*0.06, w*0.6, w*0.6)
            end
        end, false)
    end
    logo.Think = function()
        logo:SetPos(ACC2Container:GetWide()/2-ACC2.ScrH*0.35/2, lerpAnimation + ACC2.ScrH*0.28)
    end

    local lerpConfirmButton = 255
    local confirmButton = vgui.Create("DButton", ACC2Container)
    confirmButton:SetSize(ACC2.ScrW*0.2, ACC2.ScrH*0.05)
    confirmButton:SetPos(ACC2.ScrW*0.5-ACC2.ScrW*0.2/2, lerpAnimation2 + ACC2.ScrH*0.885)
    confirmButton:SetText("")
    confirmButton.Paint = function(self, w, h)
        lerpConfirmButton = Lerp(FrameTime()*3, lerpConfirmButton, (self:IsHovered() and 50 or 100))
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(ACC2.Colors["purple100"], lerpConfirmButton))

        draw.SimpleText(ACC2.GetSentence("playServer"), "ACC2:Font:10", ACC2.ScrW*0.014, h/2, ACC2.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.92-h*0.1/2, h/2-h*0.28/2, h*0.28, h*0.28)

        surface.SetDrawColor(ACC2.Colors["white220"])
        surface.SetMaterial(ACC2.Materials["rightArrow"])
        surface.DrawTexturedRect(w*0.92-h*0.35/2, h/2-h*0.28/2, h*0.28, h*0.28)

        draw.NoTexture()
        surface.SetDrawColor(ACC2.Colors["white10"])
        ACC2.DrawSimpleCircle(w*0.92, h/2, h*0.27, 360)
        
    end
    confirmButton.Think = function()
        confirmButton:SetPos(ACC2.ScrW*0.5-ACC2.ScrW*0.2/2, lerpAnimation2 + ACC2.ScrH*0.885)
    end
    confirmButton.DoClick = function()
        ACC2.LocalPlayer:ScreenFade(SCREENFADE.IN, ACC2.Colors["black"], 0.5, 1)
        ACC2.FadeActivate = true

        timer.Simple(1.5, function()
            ACC2.FadeActivate = false
        end)

        if IsValid(ACC2Container) then ACC2Container:Remove() end
    end
end

function ACC2.BeforeLoad()
    if IsValid(ACC2BeforeLoad) then ACC2BeforeLoad:Remove() end

    surface.CreateFont("ACC2:BeforeLoad:01", {
		font = "Georama",
		extended = false,
		size = ACC2.ScrH*0.07,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
		rotary = false,
	})

    surface.CreateFont("ACC2:BeforeLoad:02", {
		font = "Georama",
		extended = false,
		size = ACC2.ScrH*0.049,
		weight = 1000, 
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

    ACC2BeforeLoad = vgui.Create("DFrame")
    ACC2BeforeLoad:SetSize(ACC2.ScrW, ACC2.ScrH)
    ACC2BeforeLoad:SetDraggable(false)
    ACC2BeforeLoad:ShowCloseButton(false)
    ACC2BeforeLoad:MakePopup()
    ACC2BeforeLoad:SetTitle("")
    ACC2BeforeLoad.startTime = SysTime()
    
    local lang = GetConVar("gmod_language"):GetString()
    
    local lerpAnimation, lerpAnimation2 = -ACC2.ScrH, ACC2.ScrH*1.5
    ACC2BeforeLoad.Paint = function(self, w, h)
        lerpAnimation = Lerp(FrameTime()*5, lerpAnimation, 0)
        lerpAnimation2 = Lerp(FrameTime()*8, lerpAnimation2, 0)

        surface.SetDrawColor(ACC2.Colors["black"])
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(ACC2.Colors["white1"])
        surface.SetMaterial(ACC2.Materials["background2"])
        surface.DrawTexturedRect(0, 0, w, h)

        ACC2.DrawBlur(self, 10)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))
        
        surface.SetFont("ACC2:BeforeLoad:01")

        local base = ACC2.GetSentence("characterCreator", lang)
        local textSize = surface.GetTextSize(base)
                
        draw.DrawText(ACC2.GetSentence("syncChar", lang), "ACC2:BeforeLoad:01", w*0.5, lerpAnimation + h*0.45, ACC2.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(ACC2.GetSentence("weCurrentlySyncChar", lang):format(string.upper(ACC2.GetSetting("serverName", "string"))), "ACC2:BeforeLoad:02", w*0.5, lerpAnimation + h*0.52, ACC2.Colors["white100"], TEXT_ALIGN_CENTER)
        
        surface.SetFont("ACC2:BeforeLoad:02")

        ACC2.DrawNotification()
    end
end

ACC2.AlreadyDrawedLoad = ACC2.AlreadyDrawedLoad or false
hook.Add("HUDShouldDraw", "ACC2:HUDShouldDraw:BeforeLoad", function()
    if ACC2.DisableSyncMenu then
        ACC2.AlreadyDrawedLoad = true
        return
    end
    
    if ACC2.AlreadyDrawedLoad then return end

    ACC2.BeforeLoad()
    ACC2.AlreadyDrawedLoad = true
    
    hook.Remove("HUDShouldDraw", "ACC2:HUDShouldDraw:BeforeLoad")
end)

hook.Add("HUDShouldDraw", "ACC2:HUDShouldDraw:Animation", function()
    if ACC2.FadeActivate then
        return false
    end
end)

ACC2.ScrW, ACC2.ScrH = ScrW(), ScrH()
ACC2.RenderKey = ACC2.RenderKey or ""
hook.Add("OnScreenSizeChanged", "ACC2:OnScreenSizeChanged", function()
    ACC2.ScrW, ACC2.ScrH = ScrW(), ScrH()
    ACC2.RenderKey = ACC2.ScrW..":"..ACC2.ScrH

    ACC2.LoadFonts()
end)

hook.Add("HUDPaint", "ACC2:HUDPaint:SetupVariables", function()
    ACC2.LocalPlayer = LocalPlayer()
    ACC2.RenderKey = ACC2.ScrW..":"..ACC2.ScrH

    ACC2.LoadFonts()

    hook.Add("HUDWeaponPickedUp", "ACC2:WeaponPickedUp:HUDWeaponPickedUp", function(weapon) end)
    hook.Remove("HUDPaint", "ACC2:HUDPaint:SetupVariables")
end)

ACC2.AntiSpamToOpen = 0
ACC2.AntiSpamToOpenModification = 0

ACC2.CoodownToOpen = ACC2.CoodownToOpen or nil
ACC2.CoodownToOpenModification = ACC2.CoodownToOpenModification or nil

local lerpCooldownOpen = 90
hook.Add("HUDPaint", "ACC2:HUDPaint:OpenWithKey", function()
    local curTime = CurTime()
    
    local canOpen = ACC2.GetSetting("canOpenMenuWithKey", "boolean")
    if not canOpen then return end

    if input.IsKeyDown(ACC2.GetSetting("openMenuKey", "number")) && canOpen then
        if not ACC2.CoodownToOpen then
            if ACC2.AntiSpamToOpen > curTime then return end

            ACC2.CoodownToOpen = curTime + ACC2.GetSetting("cooldownToggleToOpen", "number")
        elseif ACC2.CoodownToOpen < curTime then
            ACC2.CoodownToOpen = nil
            ACC2.AntiSpamToOpen = curTime + ACC2.GetSetting("cooldownToOpen", "number")

            lerpCooldownOpen = 90

            net.Start("ACC2:Character")
                net.WriteUInt(5, 5)
            net.SendToServer()
        end
    else
        ACC2.CoodownToOpen = nil
    end

    local circle1 = ACC2.PrecacheCircle(ACC2.ScrW/2, ACC2.ScrH/2, ACC2.ScrW*0.01, 100, 360)
    
    ACC2.MaskStencil(function()
        draw.NoTexture()
        surface.SetDrawColor(color_white)
        surface.DrawPoly(circle1)
    end, function()
        lerpCooldownOpen = Lerp(FrameTime()*10, lerpCooldownOpen, (isnumber(ACC2.CoodownToOpen) and math.Clamp(360*((ACC2.GetSetting("cooldownToggleToOpen", "number")*1.1 - (ACC2.CoodownToOpen - CurTime()))/ACC2.GetSetting("cooldownToggleToOpen", "number")) + 90, 0, 450) or 90))

        ACC2.DrawComplexCircle(ACC2.ScrW/2, ACC2.ScrH/2, ACC2.ScrW*0.014, 90, lerpCooldownOpen, ACC2.Colors["white200"])
    end, true)
end)

local lerpModificationCooldownOpen = 90
hook.Add("HUDPaint", "ACC2:HUDPaint:OpenModificationWithKey", function()
    local canOpen = ACC2.GetSetting("canOpenModificationMenuWithKey", "boolean")
    if not canOpen then return end

    local curTime = CurTime()

    if input.IsKeyDown(ACC2.GetSetting("openModificationMenuKey", "number")) && canOpen then
        if not ACC2.CoodownToOpenModification then
            if ACC2.AntiSpamToOpenModification > curTime then return end

            ACC2.CoodownToOpenModification = curTime + ACC2.GetSetting("cooldownToggleToOpenModification", "number")
        elseif ACC2.CoodownToOpenModification < curTime then
            ACC2.CoodownToOpenModification = nil
            ACC2.AntiSpamToOpenModification = curTime + ACC2.GetSetting("cooldownToOpenModification", "number")

            net.Start("ACC2:Character")
                net.WriteUInt(6, 5)
            net.SendToServer()

            lerpModificationCooldownOpen = 90
        end
    else
        ACC2.CoodownToOpenModification = nil
    end

    local circle1 = ACC2.PrecacheCircle(ACC2.ScrW/2, ACC2.ScrH/2, ACC2.ScrW*0.01, 100, 360)
    
    ACC2.MaskStencil(function()
        draw.NoTexture()
        surface.SetDrawColor(color_white)
        surface.DrawPoly(circle1)
    end, function()
        lerpModificationCooldownOpen = Lerp(FrameTime()*10, lerpModificationCooldownOpen, (isnumber(ACC2.CoodownToOpenModification) and math.Clamp(360*((ACC2.GetSetting("cooldownToggleToOpenModification", "number")*1.1 - (ACC2.CoodownToOpenModification - CurTime()))/ACC2.GetSetting("cooldownToggleToOpenModification", "number")) + 90, 0, 450) or 90))

        ACC2.DrawComplexCircle(ACC2.ScrW/2, ACC2.ScrH/2, ACC2.ScrW*0.014, 90, lerpModificationCooldownOpen, ACC2.Colors["white200"])
    end, true)
end)

net.Receive("ACC2:MainNet", function()
    local uInt = net.ReadUInt(5)

    --[[ Get one factions or multiple ]]
    if uInt == 1 then
        local reset = net.ReadBool()
        
        ACC2.Factions = ACC2.Factions or {}
        if reset then
            ACC2.Factions = {}
        end

        local factionCount = net.ReadUInt(16)
        for i=1, factionCount do
            local valueCount = net.ReadUInt(16)
            local factionUniqueId = net.ReadUInt(16)

            ACC2.Factions[factionUniqueId] = ACC2.Factions[factionUniqueId] or {}

            for i=1, valueCount do
                local valueType = net.ReadString()
                local key = net.ReadString()
                
                local value = net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */
                
                ACC2.Factions[factionUniqueId][key] = value

                if key == "logo" then
                    ACC2.CacheMaterial(value, "faction_image_"..factionUniqueId)
                end
            end
        end
    elseif uInt == 2 then
        local factionUniqueId = net.ReadUInt(16)

        ACC2.Factions = ACC2.Factions or {}
        ACC2.Factions[factionUniqueId] = nil
    elseif uInt == 3 then
        local reset = net.ReadBool()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944
        
        ACC2.Categories = ACC2.Categories or {}
        if reset then
            ACC2.Categories = {}
        end

        local categoriesCount = net.ReadUInt(16)
        for i=1, categoriesCount do
            local valueCount = net.ReadUInt(16)
            local categoryUniqueId = net.ReadUInt(16)

            ACC2.Categories[categoryUniqueId] = ACC2.Categories[categoryUniqueId] or {}

            for i=1, valueCount do
                local valueType = net.ReadString()
                local key = net.ReadString()
                
                local value = net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))
                
                ACC2.Categories[categoryUniqueId][key] = value

                if key == "logo" then
                    ACC2.CacheMaterial(value, "category_image_"..categoryUniqueId)
                end
            end
        end
    elseif uInt == 4 then
        local categoryUniqueId = net.ReadUInt(16)

        ACC2.Categories = ACC2.Categories or {}
        ACC2.Categories[categoryUniqueId] = nil
    elseif uInt == 5 then
        ACC2.ClientTable = ACC2.ClientTable or {}
        ACC2.ClientTable["NWToSynchronize"] = ACC2.ClientTable["NWToSynchronize"] or {}
            
        local entAmountToSynchronize = net.ReadUInt(12)
        for i=1, entAmountToSynchronize do
            
            local entIndex = net.ReadUInt(32)
            local ent = Entity(entIndex)

            local needToSync = {}
            local varAmountToSynchronize = net.ReadUInt(4)
            
            for i=1, varAmountToSynchronize do
                local valueType = net.ReadString()
                
                if IsValid(ent) then
                    ent.ACC2NWVariables = ent.ACC2NWVariables or {}

                    local valueName, value = net.ReadString(), net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))

                    if value == "nil" then
                        ent.ACC2NWVariables[valueName] = nil
                    else
                        ent.ACC2NWVariables[valueName] = value
                    end
                else
                    local valueName, value = net.ReadString(), net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))

                    if value == "nil" then
                        needToSync[valueName] = nil
                    else
                        needToSync[valueName] = value
                    end 
                end
            end

            if not IsValid(ent) then
                ACC2.ClientTable["NWToSynchronize"][entIndex] = ACC2.ClientTable["NWToSynchronize"][entIndex] or {}
                
                for k, v in pairs(needToSync) do
                    ACC2.ClientTable["NWToSynchronize"][entIndex][k] = v
                end
            end
        end
    end
end)

net.Receive("ACC2:Character", function(len)
    local uInt = net.ReadUInt(4)
    
    if uInt == 1 then
        if IsValid(ACC2Container) then ACC2Container:Remove() end
        
        if IsValid(ACC2.Sound) then
            ACC2.Sound:Stop()
        end

        if ACC2.GetSetting("welcomeScreen", "boolean") then 
            ACC2.WelcomeMenu()
        else
            if ACC2.GetSetting("enableSoundCreated", "boolean") then
                ACC2.PlayURL(ACC2.GetSetting("soundCreatedLink", "string"), ACC2.GetSetting("soundCreatedVolume", "number"), true)
            end

            ACC2.LocalPlayer:ScreenFade(SCREENFADE.IN, ACC2.Colors["black"], 0.5, 1)
            ACC2.FadeActivate = true
    
            timer.Simple(1.5, function()
                ACC2.FadeActivate = false
            end)
        end
    elseif uInt == 2 then
        local openMenu = net.ReadBool()
        local steamId64 = net.ReadString()
        local characterCount = net.ReadUInt(16)
        
        local characters = {}
        for i=1, characterCount do
            local valueCount = net.ReadUInt(16)
            local characterUniqueId = net.ReadUInt(22)

            characters[characterUniqueId] = characters[characterUniqueId] or {}

            for i=1, valueCount do
                local valueType = net.ReadString()
                local key = net.ReadString()
                
                local value = net["Read"..ACC2.TypeNet[valueType]](((ACC2.TypeNet[valueType] == "Int") and 32))
                
                characters[characterUniqueId][key] = value

                if steamId64 == LocalPlayer():SteamID64() then
                    ACC2.Characters = ACC2.Characters or {}

                    ACC2.Characters[characterUniqueId] = ACC2.Characters[characterUniqueId] or {}
                    ACC2.Characters[characterUniqueId][key] = value
                end
            end

            // bug fixes when you edit the status of your characters
            if ACC2.Characters[characterUniqueId] && ACC2.Characters[characterUniqueId]["deletedAt"] then
                ACC2.Characters[characterUniqueId] = nil
            end
        end

        ACC2.ViewCharacters = ACC2.ViewCharacters or {}
        ACC2.ViewCharacters = characters
        
        if openMenu then
            if IsValid(ACC2BeforeLoad) then ACC2BeforeLoad:Remove() end
            if IsValid(ACC2Container) then return end

            ACC2.MainMenu()
        end
    elseif uInt == 3 then
        if IsValid(ACC2BeforeLoad) then ACC2BeforeLoad:Remove() end
        if IsValid(ACC2Container) then return end

        ACC2.MainMenu()
    elseif uInt == 4 then
        local characterId = net.ReadUInt(22)
        
        ACC2.Characters = ACC2.Characters or {}
        ACC2.Characters[characterId] = nil

        ACC2.ReloadCharacter()
    elseif uInt == 5 then
        ACC2.CreateCharacter(ACC2.LocalPlayer, true)
    elseif uInt == 6 then
        if IsValid(ACC2Container) then ACC2Container:Remove() end

        local fade = net.ReadBool()

        if fade then
            ACC2.LocalPlayer:ScreenFade(SCREENFADE.IN, ACC2.Colors["black"], 0.5, 1)
            ACC2.FadeActivate = true

            timer.Simple(1.5, function()
                ACC2.FadeActivate = false
            end)
        end
    elseif uInt == 7 then
        ACC2.RPName()
    elseif uInt == 8 then
        local modelsTable = {}
        local countModels = net.ReadUInt(32)

        for i=1, countModels do
            local model = net.ReadString()
            util.PrecacheModel(model)

            modelsTable[#modelsTable + 1] = model
        end

        if IsValid(ACC2.PanelPrecache) then ACC2.PanelPrecache:Remove() end
        ACC2.PanelPrecache = vgui.Create("DModelPanel")
        ACC2.PanelPrecache:SetSize(ACC2.ScrH*0.1, ACC2.ScrH*0.1)
        ACC2.PanelPrecache:SetPos(ACC2.ScrW-ACC2.ScrH*0.1, ACC2.ScrH-ACC2.ScrH*0.1)
        ACC2.PanelPrecache.LayoutEntity = function() end

        timer.Create("acc2_model_precache", 0.2, #modelsTable, function()
            local model = modelsTable[timer.RepsLeft("acc2_model_precache")]
            if not isstring(model) then return end
            
            ACC2.PanelPrecache:SetModel(modelsTable[timer.RepsLeft("acc2_model_precache")])

            if timer.RepsLeft("acc2_model_precache") <= 1 then
                if IsValid(ACC2.PanelPrecache) then
                    ACC2.PanelPrecache:Remove()
                end
            end
        end)
    end
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
