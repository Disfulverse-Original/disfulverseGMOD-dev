/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

function PANEL:Init()
    self:SetSize(AAS.ScrH*0.03, AAS.ScrH*0.03)
    self.AASValue = false
    self:SetText("")
    self.Lerp = 0
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

function PANEL:SetValue(bool)
    self.AASValue = bool
end

function PANEL:GetValue()
    return self.AASValue
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

function PANEL:DoClick()
    self.AASValue = !self.AASValue
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 211b2def519ae9f141af89ab258a00a77f195a848e72e920543b1ae6f5d7c0c1 */

function PANEL:Paint(w,h)
    draw.RoundedBox(2, 0, 0, w, h, AAS.Colors["white"])

    self.Lerp = Lerp(FrameTime()*10, self.Lerp, self.AASValue and 255 or 0)
    draw.RoundedBox(2, self:GetWide()*0.1, self:GetTall()*0.1, w-self:GetWide()*0.2, h-self:GetWide()*0.2, ColorAlpha(AAS.Colors["dark34"], self.Lerp))
end

derma.DefineControl("AAS:CheckBox", "AAS CheckBox", PANEL, "DButton")
