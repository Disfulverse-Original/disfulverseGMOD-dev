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
    self:SetText("")
    self:SetSize(ACC2.ScrW*0.1949, ACC2.ScrH*0.05)
    self.ACC2Lerp = 0
    self.ACC2Activate = false
    self.ACC2LerpColor = ACC2.Colors["white0"]
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* e76c9cbfd4851f046d135a3807c90610912e0963b3302ca13880769302aa4101 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */

function PANEL:Paint(w,h)
    self.ACC2Lerp = Lerp(FrameTime()*12, self.ACC2Lerp, self.ACC2Activate and h/2 or 0)

    ACC2.DrawCircle(w/2, h/2, h/2, 0, 360, ACC2.Colors["grey84"])
    ACC2.DrawCircle(w/2, h/2, self.ACC2Lerp, 0, 360, ACC2.Colors["purple"])

    local scale = math.floor(self.ACC2Lerp)*1.2
    local divisedScale = math.floor(scale/2)

    self.ACC2LerpColor = ACC2.LerpColor(FrameTime()*12, self.ACC2LerpColor, (self.ACC2Activate and ACC2.Colors["white200"] or ACC2.Colors["white0"]))
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

    surface.SetDrawColor(self.ACC2LerpColor)
	surface.SetMaterial(ACC2.Materials["icon_check"])
	surface.DrawTexturedRect(w/2-h*0.3, h/2-h*0.3, h*0.6, h*0.6)
end

function PANEL:DoClick()
    self.ACC2Activate = !self.ACC2Activate

    self:OnChange(self.ACC2Activate)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */

function PANEL:GetActive()
    return self.ACC2Activate
end

function PANEL:SetActive(bool)
    self.ACC2Activate = bool
end

derma.DefineControl("ACC2:CheckBox", "ACC2 CheckBox", PANEL, "DButton")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
