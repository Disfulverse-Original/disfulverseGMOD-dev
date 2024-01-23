/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */

function PANEL:Init()
    self.VBar:SetHideButtons(true)
    self.VBar:SetWide(AAS.ScrW*0.0048)
    self:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.4)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */

    self:DrawBars()
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5

function PANEL:DrawBars()
    function self.VBar.btnUp:Paint() end
    function self.VBar.btnDown:Paint() end

    function self.VBar:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, AAS.Colors["white50"])
    end
    function self.VBar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, AAS.Colors["white"])
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

function PANEL:OnChildAdded(child)
    self:AddItem(child)
    child:Dock(TOP)    
end

derma.DefineControl("AAS:ScrollPanel", "AAS Scroll Panel", PANEL, "DScrollPanel")
