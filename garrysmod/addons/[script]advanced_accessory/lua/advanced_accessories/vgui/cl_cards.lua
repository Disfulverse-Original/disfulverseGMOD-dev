/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.0811, AAS.ScrH*0.26)

    local size = AAS.Materials["editpos"]

    local editItem = vgui.Create("DImageButton", self)
    editItem:SetMaterial(AAS.Materials["editpos"])
    editItem:SetSize(AAS.Materials["editpos"]:Width()*AAS.ScrW/1920, AAS.Materials["editpos"]:Height()*AAS.ScrH/1080)
    editItem:SetPos(self:GetWide()*0.83, 0)
    editItem.DoClick = function()
        AAS.ClientTable["ItemSelected"] = self.AASTable

        sliderList:AlphaTo( 0, 0.3, 0, function()
            sliderList:Remove()
            AAS.settingsScroll(accessoriesFrame, AAS.ScrH*0.11, AAS.ScrH*0.525, true, "Edit Item", true, true)
        end)

        // Debug a litle thing with the icon
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

    local deleteItem = vgui.Create("DImageButton", self)
    deleteItem:SetMaterial(AAS.Materials["removeitem"])
    deleteItem:SetSize(AAS.Materials["removeitem"]:Width()*AAS.ScrW/1920, AAS.Materials["removeitem"]:Height()*AAS.ScrH/1080)
    deleteItem:SetPos(self:GetWide()*0.83, AAS.ScrH*0.035)
    deleteItem.DoClick = function()
        net.Start("AAS:Main")
            net.WriteUInt(2, 5)
            net.WriteUInt(self.AASTable["uniqueId"], 32)
        net.SendToServer()
    end

    self.AASButton = {editItem, deleteItem}
end

function PANEL:RemoveButton()
    if IsValid(self.AASButton[1]) then self.AASButton[1]:Remove() end 
    if IsValid(self.AASButton[2]) then self.AASButton[2]:Remove() end 
end 

function PANEL:AddItemView(itemScroll, accessoriesFrame, itemContainer, tbl)
    if not istable(tbl) then return end
    local sizeX, sizeY = 0, 0

    local item = vgui.Create("DPanel", self)
    item:SetSize(AAS.ScrW*0.081, AAS.ScrH*0.2)
    self.AASTable = tbl
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1
    
    item.Paint = function(panel,w,h)
        local scrollX, scrollY = accessoriesFrame:LocalToScreen(itemScroll:GetPos())
        local scrollW, scrollH = itemScroll:GetSize()
        
        local itemX, itemY = itemContainer:LocalToScreen(self:GetPos())
        local itemW, itemH = AAS.ScrW*0.081, h - AAS.ScrH*0.031
        
        itemY = itemY + AAS.ScrH*0.0135
        
        sizeX, sizeY = itemW, itemH
        posX, posY = itemX, itemY
        
        if itemY < scrollY then
            sizeY = sizeY - (scrollY-itemY)
            posY = posY + (scrollY-itemY)
        end
        
        if (itemY+itemH) > (scrollY+scrollH) then
            sizeY = sizeY - ((itemY+itemH) - (scrollY+scrollH))
        end

        draw.RoundedBoxEx(16, 0, 0, w, h, AAS.Colors["white"], false, true, true, false)
        draw.RoundedBoxEx(14, AAS.ScrW*0.001, h*0.0695, w-AAS.ScrW*0.0022, h*0.92, AAS.Gradient["downColor"], false, true, true, false)

        AAS.SimpleLinearGradient(posX + AAS.ScrW*0.001, posY, w - AAS.ScrW*0.002, sizeY, AAS.Colors["white"], AAS.Gradient["downColor"])
        
        local newTime = istable(self.AASTable["options"]) and tonumber(self.AASTable["options"]["date"]) or 0

        if (istable(self.AASTable["options"]) and ((newTime + (AAS.NewTime*60*60*24)) > os.time()) and self.AASTable["options"]["new"]) or (self.AASTable["preview"] and self.AASTable["options"]["new"]) then 
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(AAS.Materials["new"])
            surface.DrawTexturedRect(0, 0, AAS.ScrW*0.047, AAS.ScrH*0.046)
        end 
        
        if istable(self.AASTable["options"]) and self.AASTable["options"]["vip"] then 
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(AAS.Materials["vip"])
            surface.DrawTexturedRect(w-AAS.ScrW*0.0465, itemH-AAS.ScrH*0.02, AAS.ScrW*0.0475, AAS.ScrH*0.055)
        end
    end
    
    local itemModel = vgui.Create("DModelPanel", item)
    itemModel:SetSize(item:GetWide(), item:GetWide())
    
    itemModel.Think = function(model)
        model:SetModel((self.AASTable["model"] or ""))
        
        if not IsValid(model.Entity) then return end
        model.mn, model.mx = model.Entity:GetRenderBounds()
        
        local size = 0
        size = math.max(size, math.abs(model.mn.x) + math.abs(model.mx.x))
        size = math.max(size, math.abs(model.mn.y) + math.abs(model.mx.y))
        size = math.max(size, math.abs(model.mn.z) + math.abs(model.mx.z))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */
    
        model:SetPos(0, AAS.ScrH*0.2/2 - model:GetWide()/2)
        model:SetCamPos(Vector(size, size, size))
        
        if not model.AASStatut and istable(AAS.ClientTable["ItemSelected"]) then
    
            local vector = (AAS.ClientTable["ItemSelected"].uniqueId == self.AASTable.uniqueId) and Vector(AAS.ClientTable["ResizeIcon"][1], AAS.ClientTable["ResizeIcon"][2], AAS.ClientTable["ResizeIcon"][3]) or self.AASTable["options"]["iconPos"]
            if not isvector(vector) then vector = Vector(0,0,0) end

            local fov = (AAS.ClientTable["ItemSelected"].uniqueId == self.AASTable.uniqueId) and AAS.ClientTable["ResizeIcon"][4] or self.AASTable["options"]["iconFov"]
    
            model:SetFOV(45 + fov)
            model:SetLookAt((model.mn + model.mx) * 0.5 + vector)
        else
            if istable(self.AASTable["options"]) then
                if isnumber(self.AASTable["options"]["iconFov"]) then
                    model:SetFOV(45 + self.AASTable["options"]["iconFov"])
                end
    
                local vector = self.AASTable["options"]["iconPos"]
                if isvector(vector) then
                    model:SetLookAt((model.mn + model.mx) * 0.5 + vector)
                end
            end
        end

        AAS.SetPanelSettings(model, self.AASTable)
    end
    function itemModel:LayoutEntity() end

    local buttonHover = vgui.Create("DButton", self)
    buttonHover:SetSize(AAS.ScrW*0.081, AAS.ScrH*0.2)
    buttonHover:SetText("")
    buttonHover.AASColor = AAS.Colors["black18"]
    buttonHover.DoClick = function()
        local uniqueId = self.AASTable["uniqueId"]
        if not isnumber(uniqueId) then return end
        
        local sell = AAS.ItemIsBought(uniqueId)
        
        if not IsValid(self.AASButton[1]) and not IsValid(self.AASButton[2]) then
            AAS.PopupMenu(uniqueId, sell, self.AASTable["price"])
        end
    end
    
    buttonHover.Paint = function(panel,w,h) 
        local text = AAS.BreakText((self.AASTable["description"] or ""), 20)

        if istable(AAS.ClientTable["ItemSelected"]) and IsValid(self.AASButton[1]) and IsValid(self.AASButton[2]) and AAS.ClientTable["ItemSelected"].uniqueId == self.AASTable["uniqueId"] then 
            local checkSizeX, checkSizeY = (AAS.Materials["selected"]:Width()*AAS.ScrW/1920), (AAS.Materials["selected"]:Height()*AAS.ScrH/1080)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(AAS.Materials["selected"])
            surface.DrawTexturedRect(w/2-checkSizeX/2, h/2-checkSizeY/2, checkSizeX, checkSizeY)
        end

        if not isnumber(panel.LerpColor) then panel.LerpColor = 0 end 
        
        if panel:IsHovered() then 
            panel.LerpColor = Lerp(FrameTime()*15, panel.LerpColor, 255)
            
            buttonHover.AASColor = AAS.Colors["white"]
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */
            
            draw.RoundedBoxEx(16, 0, 0, w, h, ColorAlpha(AAS.Colors["white"], panel.LerpColor), false, true, true, false)
            draw.RoundedBoxEx(16, 1, 1, w-2, h-2, ColorAlpha(AAS.Colors["dark34"], panel.LerpColor), false, true, true, false)
            draw.DrawText(text, "AAS:Font:03", w/2.1, h*0.25, ColorAlpha(AAS.Colors["white"], panel.LerpColor), TEXT_ALIGN_CENTER)
        else
            buttonHover.AASColor = AAS.Colors["black18"]

            if panel.LerpColor != 0 then panel.LerpColor = 0 end 
        end
        
        local mat = AAS.GetMaterial(self.AASTable["category"])
        if mat == nil then return end

        surface.SetDrawColor(buttonHover.AASColor)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(AAS.ScrW*0.052, AAS.ScrH*0.005, (mat:Width()*AAS.ScrW/1920)*0.8, (mat:Height()*AAS.ScrH/1080)*0.8 )
    end
    self.buttonHover = buttonHover
end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */

function PANEL:Paint(w, h)
    local uniqueId = self.AASTable["uniqueId"]
    local sell = AAS.ItemIsBought(uniqueId)

    draw.DrawText((self.AASTable["name"] or "Data Problem"), "AAS:Font:02", AAS.ScrW*0.081/2, h*0.79,  AAS.Colors["white"], TEXT_ALIGN_CENTER)
    draw.DrawText((sell and not IsValid(self.AASButton[1])) and AAS.GetSentence("bought") or AAS.formatMoney((self.AASTable["price"] or 0)), "AAS:Font:03", AAS.ScrW*0.081/2, h*0.89,  (sell and not IsValid(self.AASButton[1])) and AAS.Colors["bought"] or AAS.Colors["white"], TEXT_ALIGN_CENTER)
end

derma.DefineControl("AAS:Cards", "AAS Cards", PANEL, "DPanel")
