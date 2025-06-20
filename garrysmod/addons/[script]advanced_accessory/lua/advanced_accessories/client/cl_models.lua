/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

function AAS.ChangeModels()
    local changeModel = (AAS.UseDarkRPModel and DarkRP) and RPExtraTeams[AAS.LocalPlayer:Team()].model or (AAS.CustomModelTable[team.GetName(AAS.LocalPlayer:Team())] or {})
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8

    AAS.BaseMenu(AAS.GetSentence("customCharacter"), false, AAS.ScrW*0.2, "customcharacter")

    AAS.ClientTable["Id"] = 1

    local modelGet, idSelected = AAS.LocalPlayer:GetModel(), nil
    
    local playerModel = vgui.Create("AAS:DModel", accessoriesFrame)
    playerModel:SetSize(AAS.ScrW*0.11, AAS.ScrH*0.55)
    playerModel:SetPos(accessoriesFrame:GetWide()*0.27, AAS.ScrH*0.07) 
    playerModel:SetFOV(15)
    playerModel:Zoom()
    playerModel:SetDrawModelAccessories(false)

    if isnumber(playerModel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
        local modelEye = playerModel.Entity:GetBonePosition(playerModel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        modelEye:Add(Vector(0, 0, -28))
        playerModel:SetLookAt(modelEye)
        playerModel:SetCamPos(modelEye-Vector(-100, 0, -5))
    end

    local arrowLeft = vgui.Create("DButton", accessoriesFrame)
    arrowLeft:SetSize(AAS.ScrW*0.013, AAS.ScrH*0.039)
    arrowLeft:SetPos(AAS.ScrW*0.095, AAS.ScrH*0.28)
    arrowLeft:SetText("")
    arrowLeft.Paint = function(self, w, h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["arrowleft"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end
    arrowLeft.Think = function()
        if not arrowLeft:IsHovered() or not input.IsButtonDown(MOUSE_FIRST) then return end
        playerModel.Entity:SetAngles(playerModel.Entity:GetAngles() - Angle(0, 1, 0))
    end

    local arrowRight = vgui.Create("DButton", accessoriesFrame)
    arrowRight:SetSize(AAS.ScrW*0.013, AAS.ScrH*0.039)
    arrowRight:SetPos(AAS.ScrW*0.325, AAS.ScrH*0.28)
    arrowRight:SetText("")
    arrowRight.Paint = function(self, w, h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["arrowright"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end
    arrowRight.Think = function()
        if not arrowRight:IsHovered() or not input.IsButtonDown(MOUSE_FIRST) then return end
        playerModel.Entity:SetAngles(playerModel.Entity:GetAngles() + Angle(0, 1, 0))
    end

    local categoryList = vgui.Create("DScrollPanel", accessoriesFrame)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.1)

    local categoryButton = vgui.Create("DButton", categoryList)
    categoryButton:SetSize(0, AAS.ScrH*0.038)
    categoryButton:Dock(TOP)
    categoryButton:SetText("")
    categoryButton:DockMargin(0,0,0,AAS.ScrH*0.006)
    categoryButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, w*0.955, 0, w*0.1, h, AAS.Colors["white200"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["avatar"])
        surface.DrawTexturedRect(w/2 - AAS.ScrW*0.015/2, h/2 - AAS.ScrH*0.0268/2, AAS.ScrW*0.015, AAS.ScrH*0.0268)
    end
    categoryButton.DoClick = function()
        AAS.ClientTable["Id"] = k 
    end

    local sliderList = vgui.Create("AAS:ScrollPanel", accessoriesFrame)
    sliderList:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.43)
    sliderList:SetPos(accessoriesFrame:GetWide() - AAS.ScrW*0.195, AAS.ScrH*0.12)
    sliderList:GetVBar():SetSize(0,0)

    local panelBack = vgui.Create("DPanel", accessoriesFrame)
    panelBack:SetSize(AAS.ScrW*0.197, AAS.ScrH*0.04)
    panelBack:SetPos(accessoriesFrame:GetWide()*0.67, AAS.ScrH*0.065)
    panelBack.Paint = function(self,w,h)
        draw.DrawText(string.upper(AAS.GetSentence("appearance")), "AAS:Font:04", w*0.02, h*0.1, AAS.Colors["white"], TEXT_ALIGN_LEFT)
        draw.RoundedBox(0, w*0.025, h*0.93, w*0.94, AAS.ScrH*0.002, AAS.Colors["white"])
    end

    local lerpFirstButton = 255
    local firstButton = vgui.Create("DButton", panelBack)
    firstButton:SetSize(AAS.ScrW*0.055, AAS.ScrH*0.027)
    firstButton:SetPos(panelBack:GetWide()*0.685, AAS.ScrH*0.0)
    firstButton:SetText(AAS.GetSentence("cancel"))
    firstButton:SetFont("AAS:Font:04")
    firstButton:SetTextColor(AAS.Colors["white"])
    firstButton.Paint = function(self,w,h)
        lerpFirstButton = Lerp(FrameTime()*10, lerpFirstButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["red49"], lerpFirstButton))
    end
    firstButton.DoClick = function()
        accessoriesFrame:AlphaTo( 100, 0.3, 0, function() 
            if not IsValid(accessoriesFrame) then return end 
            accessoriesFrame:Remove()
        end)
    end

    local lerpSecondButton = 255
    local secondButton = vgui.Create("DButton", panelBack)
    secondButton:SetSize(AAS.ScrW*0.06, AAS.ScrH*0.027)
    secondButton:SetPos(panelBack:GetWide()*0.36, AAS.ScrH*0.0)
    secondButton:SetText(AAS.GetSentence("saveModel"))
    secondButton:SetFont("AAS:Font:04")
    secondButton:SetTextColor(AAS.Colors["white"])
    secondButton.Paint = function(self,w,h)
        lerpSecondButton = Lerp(FrameTime()*10, lerpSecondButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["selectedBlue"], lerpSecondButton))
    end
    secondButton.DoClick = function()
        local model = playerModel:GetModel()

        net.Start("AAS:Models")
            net.WriteString(model)
        net.SendToServer()
    end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

    local itemContainer = vgui.Create("DIconLayout", sliderList)
    itemContainer:SetSize(AAS.ScrW*0.384, AAS.ScrH*0.542)
    itemContainer:SetSpaceX(AAS.ScrW*0.008) 
    itemContainer:SetSpaceY(AAS.ScrW*0.008)

    for k,v in pairs((changeModel or {})) do
        if modelGet == v then idSelected = k end
        
        local model = vgui.Create("SpawnIcon", itemContainer)
        model:SetSize( ScrH()*0.07, ScrH()*0.07 )
        model:SetModel(v)
        model:SetTooltip(false)
        model.Icon:SetSize(3, 3)

        local LerpColor = 0
        model.Paint = function(self,w,h)
            LerpColor = Lerp(FrameTime()*5, LerpColor, (idSelected == k) and 255 or 0)

            draw.RoundedBox(0, 0, 0, w, h, AAS.Colors["dark34"])
            surface.SetDrawColor((idSelected == k) and ColorAlpha(AAS.Colors["selectedBlue"], LerpColor) or AAS.Colors["white"])
            surface.DrawOutlinedRect( 0, 0, w, h, AAS.ScrH*0.003)
        end
        function model:PerformLayout()
            self.Icon:StretchToParent(3, 3, 3, 3)
        end
        model.DoClick = function()
            idSelected = k
            playerModel:SetModel(v)
        end
        model.Think = function() end
    end
end
