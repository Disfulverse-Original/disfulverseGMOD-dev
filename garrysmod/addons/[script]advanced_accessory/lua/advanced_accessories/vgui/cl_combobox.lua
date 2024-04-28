/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.15, AAS.ScrH*0.029)
    self:SetTextColor(AAS.Colors["white"])
    self:SetText("")
    self:SetFont("AAS:Font:03")
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768796 */

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, AAS.Colors["black18"])
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5

derma.DefineControl("AAS:ComboBox", "AAS ComboBox", PANEL, "DComboBox")
