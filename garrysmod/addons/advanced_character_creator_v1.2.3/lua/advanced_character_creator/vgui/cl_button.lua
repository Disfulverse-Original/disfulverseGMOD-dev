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

function PANEL:Init()
    self:SetSize(ACC2.ScrH*0.03, ACC2.ScrH*0.03)
    self:SetText("")
    self.ACC2BackgroundColor = ACC2.Colors["white100"]
    self.ACC2HoveredAlpha = 0
    self.ACC2Icon = nil
    self.ACC2Alignement = TEXT_ALIGN_LEFT
    self.ACC2TextPos = 0
    self.ACC2MinMaxLerp = {60, 0}
    self.ACC2Value = ACC2.GetSentence("invalidText")

    self:SetFont("ACC2:Font:09")
end

function PANEL:SetValue(value)
    self.ACC2Value = value
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

function PANEL:GetValue()
    return self.ACC2Value or ""
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

function PANEL:SetBackgroundColor(color)
    self.ACC2BackgroundColor = color
end

function PANEL:SetHoveredColor(color)
    self.ACC2HoveredColor = color
end

function PANEL:SetIconMaterial(mat)
    self.ACC2Icon = mat
end

function PANEL:SetTextAlignement(align) 
    self.ACC2Alignement = align
end

function PANEL:Paint(w, h)
    self.ACC2HoveredAlpha = Lerp(FrameTime()*3, self.ACC2HoveredAlpha, (self:IsHovered() and self.ACC2MinMaxLerp[1] or self.ACC2MinMaxLerp[2]))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

    surface.SetDrawColor(ColorAlpha(self.ACC2BackgroundColor, self.ACC2HoveredAlpha))
    surface.DrawRect(0, 0, w, h)

    if self.ACC2Icon then
        self.ACC2TextPos = ACC2.ScrW*0.025

        ACC2.DrawCircle(ACC2.ScrW*0.012, h/2, h*0.4, 0, 360, ACC2.Colors["white30"])
        
        surface.SetMaterial(self.ACC2Icon)
        surface.SetDrawColor(ACC2.Colors["white100"])
        surface.DrawTexturedRect(ACC2.ScrW*0.012 - h*0.18, h/2-h*0.4/2, h*0.4, h*0.4)
    else
        self.ACC2TextPos = self.ACC2Alignement == TEXT_ALIGN_CENTER and w/2 or ACC2.ScrW*0.005
    end

    draw.SimpleText(self.ACC2Value, self:GetFont(), self.ACC2TextPos, h/2, ACC2.Colors["white"], self.ACC2Alignement, TEXT_ALIGN_CENTER)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980

derma.DefineControl("ACC2:Button", "ACC2 Button", PANEL, "DButton")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
