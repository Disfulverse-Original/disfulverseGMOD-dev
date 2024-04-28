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
    self:SetSize(ACC2.ScrW*0.1949, ACC2.ScrH*0.5)
    self:SetMinMax(0, 1)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466944 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198931466969

    function self.Slider.Knob:Paint(w, h)
	    draw.NoTexture()
        ACC2.DrawCircle(w/2, h/2, ACC2.ScrH*0.008, 0, 360, ACC2.Colors["white"])
    end

    function self.Slider:Paint() end
    
    function self:Paint(w,h)
        local coef = math.Remap(self:GetValue(), self:GetMin(), self:GetMax(), 0, 1)

        draw.RoundedBox(0, 0, h*0.5-ACC2.ScrH*0.005/2, w*0.99, ACC2.ScrH*0.005, ACC2.Colors["grey"])
        draw.RoundedBox(0, 0, h*0.5-ACC2.ScrH*0.005/2, w*coef*0.99, ACC2.ScrH*0.005, ACC2.Colors["purple99"])
    end

    self.TextArea:SetVisible(false)
    self.Label:SetVisible(false)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- c1e813f17deb1a62965eca6e9ba2b60aeb690b46a55b07d54ea18ee0c7b23980

derma.DefineControl("ACC2:Slider", "ACC2 Slider", PANEL, "DNumSlider")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
