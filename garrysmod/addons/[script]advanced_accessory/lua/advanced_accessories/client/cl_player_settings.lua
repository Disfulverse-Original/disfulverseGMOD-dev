/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local lerpBack, offsetsValue = false, {}

local function getItemSettings(typeSet)
    local tbl = offsetsValue or {}
    for i=1, 3 do tbl[i] = tbl[i] or {} end 

    if typeSet == "pos" then 
        return Vector((tbl[1][typeSet] or 0), (tbl[2][typeSet] or 0), (tbl[3][typeSet] or 0))
    elseif typeSet == "rotate" then 
        return Angle((tbl[1][typeSet] or 0), (tbl[2][typeSet] or 0), (tbl[3][typeSet] or 0))
    elseif typeSet == "scale" then 
        return Vector((tbl[1][typeSet] or 1), (tbl[2][typeSet] or 1), (tbl[3][typeSet] or 1))
    end
end

local function sliderMove(x, y, panel, title, name, itemTable)
    local sliderPanel = vgui.Create("DPanel", panel)
    sliderPanel:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.175)
    sliderPanel:SetPos(x, y)

    sliderPanel.Paint = function(self,w,h)
        draw.RoundedBoxEx(8, 0, 0, w, h, AAS.Colors["black18230"], false, false, true, true)
        draw.RoundedBox(0, 0, 0, w, h*0.26, AAS.Colors["black18"])
        draw.RoundedBox(0, 0, h*0.26, w, h*0.05, AAS.Colors["black18100"])
        
        draw.DrawText(title, "AAS:Font:05", w/2, h*0.05, AAS.Colors["white"], TEXT_ALIGN_CENTER)
    end 

    for i=1, 3 do
        offsetsValue[i] = offsetsValue[i] or {}

        local slider = vgui.Create("AAS:Slider", sliderPanel)
        slider:SetPos(0, i*AAS.ScrH*0.04)
        slider:ChangeBackground(false)

        local offsetItems = AAS.ClientTable["offsetItems"] or {}
        local offsetTable = offsetItems[itemTable["uniqueId"]] or {}

        if name == "pos" then
            local pos = isvector(offsetTable.pos) and offsetTable.pos or Vector(0,0,0)

            slider.Slider:SetMin(-AAS.MaxVectorOffset)
            slider.Slider:SetMax(AAS.MaxVectorOffset)
            slider.Slider:SetValue(pos[i])

            offsetsValue[i]["pos"] = pos[i]
        elseif name == "rotate" then
            local ang = isangle(offsetTable.ang) and offsetTable.ang or Angle(0,0,0)

            slider.Slider:SetMin(-AAS.MaxAngleOffset)
            slider.Slider:SetMax(AAS.MaxAngleOffset)
            slider.Slider:SetValue(ang[i])

            offsetsValue[i]["rotate"] = ang[i]
        end 

        if name == "scale" then 
            local scale = isvector(offsetTable.scale) and offsetTable.scale or Vector(1,1,1)

            slider.Slider:SetMin(-AAS.MaxVectorOffset)
            slider.Slider:SetMax(AAS.MaxVectorOffset)
            slider.Slider:SetValue(scale[i])

            slider:SetAccurateNumber(0.002)

            offsetsValue[i]["scale"] = scale[i]
        end

        slider.Slider.OnValueChanged = function()
            offsetsValue[i] = offsetsValue[i] or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

            offsetsValue[i][name] = slider.Slider:GetValue()
        end
    end 
end

local curentPosx, curentPosY, curentFov = 0, 0, 0
function AAS.PlayerSettings(itemTable)
    if not istable(itemTable) then return end
    if IsValid(playerSettingsPanel) then playerSettingsPanel:Remove() end

    lerpBack = false

    if IsValid(accessoriesFrame) then 
        accessoriesFrame:AlphaTo(100, 0.3, 0, function() 
            if not IsValid(accessoriesFrame) then return end 
            accessoriesFrame:Remove()
        end)
    end

    local linearGradient = {
        {offset = 0, color = AAS.Gradient["upColor"]},
        {offset = 0.4, color = AAS.Gradient["midleColor"]},
        {offset = 1, color = AAS.Gradient["downColor"]},
    }

    playerSettingsPanel = vgui.Create("DFrame")
    playerSettingsPanel:SetSize(AAS.ScrW, AAS.ScrH)
    playerSettingsPanel:ShowCloseButton(false)
    playerSettingsPanel:SetTitle("")
    playerSettingsPanel:MakePopup()
    playerSettingsPanel:AlphaTo( 255, 0.3, 0 )
    playerSettingsPanel.Paint = function() end
    playerSettingsPanel:SetCursor("sizeall")

    local lastPosX, lastPosY = 0, 50
    local posMouseX, posMouseY = 0,0

    playerSettingsPanel.Think = function(self)
        if input.IsMouseDown(MOUSE_FIRST) and self:IsHovered() and self.IsDraggingBool then 
            local currentMouseX, currentMouseY = input.GetCursorPos()
            local differenceMousePosX = currentMouseX - posMouseX
            local differenceMousePosY = currentMouseY - posMouseY

            curentPosx = lastPosX + differenceMousePosX / AAS.ScrW*10
            curentPosY = math.Clamp(lastPosY + differenceMousePosY,-20,200)
        end 
    end
    function playerSettingsPanel:OnMousePressed()
        if playerSettingsPanel:IsHovered() then
            posMouseX, posMouseY = input.GetCursorPos()
        end

        self.IsDraggingBool = true
    end
    function playerSettingsPanel:OnMouseReleased()
        lastPosX = curentPosx
        lastPosY = curentPosY

        self.IsDraggingBool = false
    end
    function playerSettingsPanel:OnMouseWheeled(keycode)    
        if keycode == 1 and curentFov < 150 then curentFov = curentFov + 6 end
        if keycode == -1 and curentFov > -20 then curentFov = curentFov - 6 end
    end
    
    local topPanel = vgui.Create("DPanel", playerSettingsPanel)
    topPanel:SetSize(AAS.ScrW, AAS.ScrH*0.04)
    topPanel:SetPos(0,0)
    topPanel.Paint = function(self,w,h)
        draw.RoundedBoxEx(0, 0, 0, w, h, AAS.Colors["black18"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["scale"])
        surface.DrawTexturedRect( w*0.01, h/2-10, 20, 20 )
    end

    AAS.PlayerSettingsModel(itemTable)

    sliderMove(AAS.ScrW*0.13, AAS.ScrH*0.82, playerSettingsPanel, AAS.GetSentence("position"), "pos", itemTable)
    sliderMove(AAS.ScrW*0.34, AAS.ScrH*0.82, playerSettingsPanel, AAS.GetSentence("rotation"), "rotate", itemTable)
    sliderMove(AAS.ScrW*0.55, AAS.ScrH*0.82, playerSettingsPanel, AAS.GetSentence("scale"), "scale", itemTable)

    local closeButton = vgui.Create("DButton", playerSettingsPanel)
    closeButton:SetSize(AAS.ScrW*0.011, AAS.ScrW*0.011)
    closeButton:SetPos(playerSettingsPanel:GetWide()*0.98, AAS.ScrH*0.04/2-closeButton:GetTall()/2) 
    closeButton:SetText("")
    closeButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["close"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    closeButton.DoClick = function()
        lerpBack = true
        calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AAS.LocalPlayer:GetPos() - (AAS.LocalPlayer:GetAngles():Forward() * -100) + AAS.LocalPlayer:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

        if IsValid(playerSettingsPanel) then
            playerSettingsPanel:AlphaTo(100, 1, 0, function() 
                if not IsValid(playerSettingsPanel) then return end 
                playerSettingsPanel:Remove()

                AAS.InventoryMenu()
            end)
        end
    end

    local lerpFirstButton = 255
    local firstButton = vgui.Create("DButton", playerSettingsPanel)
    firstButton:SetSize(AAS.ScrW*0.055, AAS.ScrH*0.027)
    firstButton:SetPos(playerSettingsPanel:GetWide()*0.11, AAS.ScrH*0.007)
    firstButton:SetFont("AAS:Font:04")
    firstButton:SetTextColor(AAS.Colors["white"])
    firstButton:SetText(AAS.GetSentence("cancel"))
    firstButton.Paint = function(self,w,h)
        lerpFirstButton = Lerp(FrameTime()*10, lerpFirstButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["red49"], lerpFirstButton))
    end 
    firstButton.DoClick = function()
        lerpBack = true
        calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AASClientSide:GetPos() - (AASClientSide:GetAngles():Forward() * -100) + AASClientSide:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

        if IsValid(playerSettingsPanel) then
            playerSettingsPanel:AlphaTo(100, 1, 0, function() 
                if not IsValid(playerSettingsPanel) then return end 
                playerSettingsPanel:Remove()

                AAS.InventoryMenu()
            end)
        end
    end 

    local lerpSecondButton = 255
    local secondButton = vgui.Create("DButton", playerSettingsPanel)
    secondButton:SetSize(AAS.ScrW*0.065, AAS.ScrH*0.027)
    secondButton:SetPos(playerSettingsPanel:GetWide()*0.04, AAS.ScrH*0.007)
    secondButton:SetFont("AAS:Font:04")
    secondButton:SetTextColor(AAS.Colors["white"])
    secondButton:SetText(AAS.GetSentence("save"))
    secondButton.Paint = function(self,w,h)
        lerpSecondButton = Lerp(FrameTime()*10, lerpSecondButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["selectedBlue"], lerpSecondButton))
    end
    secondButton.DoClick = function()
        net.Start("AAS:Inventory")
            net.WriteUInt(5, 5)
            net.WriteUInt(itemTable["uniqueId"], 32)
            net.WriteVector(getItemSettings("pos"))
            net.WriteAngle(getItemSettings("rotate"))
            net.WriteVector(getItemSettings("scale"))
        net.SendToServer()
    end
end

function AAS.PlayerSettingsModel(itemTable)
    if IsValid(AASClientSide) then AASClientSide:Remove() end
    if not istable(itemTable["options"]) then itemTable["options"] = {} end

    AASClientSide = ClientsideModel( "models/props_c17/oildrum001_explosive.mdl" )
	AASClientSide:SetPos(AAS.LocalPlayer:LocalToWorld(Vector(0,0,0)))

    local skin = tonumber(itemTable["options"]["skin"])
    if isnumber(skin) then
        AASClientSide:SetSkin(skin)
    end
	AASClientSide:Spawn()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5 */

    calcPos, calcAng, calcPosE, calcAngE = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AAS.LocalPlayer:GetPos() - (AAS.LocalPlayer:GetAngles():Forward() * -100) + AAS.LocalPlayer:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

    local boneName = itemTable.options.bone
    local boneId = AAS.LocalPlayer:LookupBone(boneName)
    if not isnumber(boneId) then
        for i=1, AAS.LocalPlayer:GetBoneCount() do
            local name = AAS.LocalPlayer:GetBoneName(i)
            
            AAS.SimilarityBones[boneName] = AAS.SimilarityBones[boneName] or {}
            local bool = AAS.SimilarityBones[boneName][name]
            
            if bool then
                boneName = name
                boneId = AAS.LocalPlayer:LookupBone(boneName)
                break
            end
        end
    end
    if not isnumber(boneId) then return end

    timer.Create("AAS:updateClientSideModel", 0, 0, function()
        if not IsValid(playerSettingsPanel) then AASClientSide:Remove() timer.Remove("AAS:updateClientSideModel") return end 
        if not IsValid(AASClientSide) then timer.Remove("AAS:updateClientSideModel") return end

        local matrix = LocalPlayer():GetBoneMatrix(boneId)
        if not matrix then 
            return
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5
    
        local pos = matrix:GetTranslation()
        local ang = matrix:GetAngles()   
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

        local mdl = string.lower((LocalPlayer():GetModel() or ""))
        AAS.ClientTable["ItemsOffsetModel"] = AAS.ClientTable["ItemsOffsetModel"] or {}

        --[[ Custom model offset (SERVER) ]]
        local offset = AAS.ClientTable["ItemsOffsetModel"][itemTable.uniqueId] or {}
        local offsetModel = offset[mdl] or {}

        --[[ Get settings from sliders ]]
        local offsetPos = getItemSettings("pos") or Vector(0,0,0)
        local offsetAng = getItemSettings("rotate") or Angle(0,0,0)
        local offsetScale = getItemSettings("scale") or Vector(0,0,0)

        local posToSet, angToSet, scaleToSet
        if offsetModel["pos"] then
            posToSet = offsetModel["pos"]
        else
            posToSet = itemTable.pos
        end
    
        if offsetModel["ang"] then
            angToSet = offsetModel["ang"]
        else
            angToSet = itemTable.ang
        end
    
        if offsetModel["scale"] then
            scaleToSet = offsetModel["scale"]
        else
            scaleToSet = itemTable.scale
        end    

        pos = AAS.ConvertVector(pos, (posToSet + offsetPos), ang)
        ang = AAS.ConvertAngle(ang, (angToSet + offsetAng))

        AASClientSide:SetPos(pos)
        AASClientSide:SetAngles(ang)
        AASClientSide:SetModel(itemTable["model"])
        AASClientSide:SetColor(itemTable["options"]["color"])

        local mat = Matrix()
        mat:Scale(scaleToSet + (offsetScale / 50))
        AASClientSide:EnableMatrix("RenderMultiply", mat)
    end)
end

hook.Add("CalcView", "AAS:CalcView:PlayerSettings", function( ply, pos, angles, fov )
    if not IsValid(playerSettingsPanel) or not IsValid(AASClientSide) then return end

    local BonePos = AASClientSide:GetPos()

    if not lerpBack then
        calcPos = LerpVector(FrameTime()*5, calcPos, BonePos + Vector(math.cos(curentPosx)*(200 -curentFov),math.sin(curentPosx)*(200 -curentFov),curentPosY))
        calcAng = (pos - calcPos):Angle()
    else
        calcPos = LerpVector(FrameTime()*3, calcPos, calcPosE)
        calcAng = LerpAngle(FrameTime()*3, calcAng, calcAngE)
    end

	local view = {
		origin = calcPos,
		angles = calcAng,
		fov = fov,
		drawviewer = true,
	}

	return view
end)

hook.Add("AAS:ClosePlayerSettingsPanel", "AAS:ClosePlayerSettingsPanel", function()
    lerpBack = true
    calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AASClientSide:GetPos() - (AASClientSide:GetAngles():Forward() * -100) + AASClientSide:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

    if IsValid(playerSettingsPanel) then
        playerSettingsPanel:AlphaTo(100, 1, 0, function() 
            if not IsValid(playerSettingsPanel) then return end 
            playerSettingsPanel:Remove()

            AAS.InventoryMenu()
        end)
    end
end)
