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
    local sbar = self:GetVBar()
    sbar:SetWide(ACC2.ScrW*0.003)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, ACC2.Colors["grey30"])
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, ACC2.Colors["grey30"])
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, ACC2.Colors["grey30"])
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, ACC2.Colors["grey30"])
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- f7fd1fca3ccaab2e1a41a243c7c9e204241772fcea4df32223d2f6203cc38823
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

derma.DefineControl("ACC2:DScroll", "ACC2 DScroll", PANEL, "DScrollPanel")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
