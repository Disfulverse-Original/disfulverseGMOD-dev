--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

/*
    Addon id: 00690769-9ce4-49c1-bc5f-802f53225f58
    Version: v1.2.3 (stable)
*/

local PANEL = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

function PANEL:Init()
    self.Incline = 0
    self.ACC2Poly = {}
    self.ACC2Color = ACC2.Colors["white"]
    self.ACC2Icon = ACC2.Materials["icon_car"]
    self.ACC2IconColor = ACC2.Colors["white"]
    self.ACC2IconPosX = nil
    self.ACC2Value = nil
    self.ColorLerp = 5
    self.MinMaxLerp = {0, 0}
    self:SetText("")
    self:SetSize(ACC2.ScrH*0.1, ACC2.ScrH*0.1)
end

function PANEL:InclineButton(number)
    self.Incline = (number or 0)
    self:ReloadPoly()
end

function PANEL:SetButtonColor(color)
    self.ACC2Color = (color or ACC2.Colors["white"])
end

function PANEL:SetIconColor(color)
    self.ACC2IconColor = (color or ACC2.Colors["white"])
end

function PANEL:SetCustomIconPos(value)
    self.ACC2IconPosX = value
end

function PANEL:SetValue(value)
    self.ACC2Value = value
end

function PANEL:SetIconMaterial(mat)
    self.ACC2Icon = mat
end

function PANEL:ReloadPoly()
    local w, h = self:GetSize()

    self.ACC2Poly = {
        {x = self.Incline, y = 0},
        {x = w, y = 0},
        {x = w-self.Incline, y = h},
        {x = 0, y = h},
    }
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466944
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

function PANEL:OnSizeChanged(newWidth, newHeight)
    self:ReloadPoly()
end

function PANEL:Paint(w,h)
    self.ColorLerp = Lerp(FrameTime()*2, self.ColorLerp, (self:IsHovered() and self.MinMaxLerp[1] or self.MinMaxLerp[2]))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

	surface.SetDrawColor(ColorAlpha(self.ACC2Color, self.ColorLerp))
	draw.NoTexture()
	surface.DrawPoly(self.ACC2Poly)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */
    
    local iconSizeX, iconSizeY, iconPosX, iconPosY
    if self.ACC2Icon != nil then
        iconSizeX, iconSizeY = ACC2.ScrH*0.02, ACC2.ScrH*0.02
        iconPosX, iconPosY = (self.ACC2IconPosX != nil and self.ACC2IconPosX or (w/1.9-iconSizeX/2)), (h/2-iconSizeY/2)

        if isstring(self.ACC2Icon) then
            self.ACC2Icon = Material(self.ACC2Icon, "smooth")
        elseif self.ACC2Icon != nil then
            surface.SetDrawColor(self.ACC2IconColor)
            surface.SetMaterial(self.ACC2Icon)
            surface.DrawTexturedRect(iconPosX, iconPosY, iconSizeX, iconSizeY)
        end
    end

    if self.ACC2Value != nil then
        draw.SimpleText(self.ACC2Value, "ACC2:Font:06", (self.ACC2Icon and (iconPosX or 0)+(iconSizeX or 0)+w*0.055 or w/2), h/2, ACC2.Colors["white"], (self.ACC2Icon and TEXT_ALIGN_LEFT or TEXT_ALIGN_CENTER), TEXT_ALIGN_CENTER)
    end
end

derma.DefineControl("ACC2:SlideButton", "ACC2 SlideButton", PANEL, "DButton")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
