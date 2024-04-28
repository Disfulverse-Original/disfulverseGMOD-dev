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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */

function PANEL:Init()
    self:SetText("")
    self:SetSize(ACC2.ScrW*0.1949, ACC2.ScrH*0.05)
    self:SetFont("ACC2:Font:09")
    self:SetTextColor(ACC2.Colors["white100"])
    self.ACC2Rounded = 0
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 482c562e67c7127e3b68e63eb0de779cb19814da22ab42eae52a7d3451fc844a */

function PANEL:SetRounded(number)
    self.ACC2Rounded = (number or 0)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823

function PANEL:Paint(w,h)
    draw.RoundedBox(self.ACC2Rounded, 0, 0, w, h, ACC2.Colors["white5"])
    self:DrawTextEntryText(ACC2.Colors["white100"], ACC2.Colors["white100"], ACC2.Colors["white100"])
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

derma.DefineControl("ACC2:DComboBox", "ACC2 DComboBox", PANEL, "DComboBox")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
