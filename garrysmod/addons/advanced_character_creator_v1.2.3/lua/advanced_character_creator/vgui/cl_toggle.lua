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
    self:SetSize(ACC2.ScrW*0.023, ACC2.ScrH*0.019)
    self:SetText("")
    self.ACC2Lerp = 0
    self.ACC2Activate = true
    self.ACC2LerpColor = ACC2.Colors["purple"]
    self.ACC2CanChange = true
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

function PANEL:SetDefaultStatut(bool)
    self.ACC2Activate = bool
    self.ACC2LerpColor = ACC2.Colors[(bool and "purple" or "grey")]
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980

function PANEL:ChangeStatut(bool)
    self.ACC2Activate = bool
end

function PANEL:GetStatut()
    return self.ACC2Activate
end

function PANEL:CanChange(bool)
    self.ACC2CanChange = bool
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101

function PANEL:Paint(w,h)
    self.ACC2Lerp = Lerp(FrameTime()*5, self.ACC2Lerp, (self.ACC2Activate and w*0.44 or 0))
    self.ACC2LerpColor = ACC2.LerpColor(FrameTime()*5, self.ACC2LerpColor, (self.ACC2Activate && self.ACC2CanChange and ACC2.Colors["purple"] or ACC2.Colors["grey"]))

    ACC2.DrawElipse(0, 0, w, h, self.ACC2LerpColor, false, false)
    ACC2.DrawCircle(w*0.28 + self.ACC2Lerp, h*0.5, h*0.4, 0, 360, ACC2.Colors["white"])
end

function PANEL:DoClick()
    if not self.ACC2CanChange then return end

    self.ACC2Activate = !self.ACC2Activate
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

    if isfunction(self.OnChange) then
        self:OnChange()
    end
end

derma.DefineControl("ACC2:Toggle", "ACC2 Toggle", PANEL, "DButton")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
