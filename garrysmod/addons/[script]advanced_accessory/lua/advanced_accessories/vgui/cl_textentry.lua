/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}

function PANEL:Init()
    self:SetText("Edit Text")
    self:SetFont("AAS:Font:03")
    self:SetSize(AAS.ScrW*0.175, AAS.ScrH*0.03)
    self:SetTextColor(AAS.Colors["white"])
    self:SetDrawLanguageID(false)

    self.Icon = nil 
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198402768773 */

function PANEL:SetIcon(mat)
    self.Icon = mat
end 

function PANEL:SetHoldText(text)
    self.AASBaseText = text
    self:SetText(self.AASBaseText)
end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, AAS.Colors["black18"])

    self:DrawTextEntryText(AAS.Colors["white"], AAS.Colors["selectedBlue"], AAS.Colors["white"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a */

    if self.Icon != nil then
        local sizeY = self.Icon:Height()*AAS.ScrH/1080
        
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(self.Icon, "smooth")
        surface.DrawTexturedRect(w*0.78, h/2 - sizeY/2, self.Icon:Width()*AAS.ScrW/1920, sizeY)
    end 
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8

function PANEL:OnGetFocus()
    if self:GetValue() == self.AASBaseText then
        self:SetText("") 
    end 
end 

function PANEL:OnLoseFocus()
    if self:GetValue() == "" then
        self:SetText(self.AASBaseText)
    end
end 

derma.DefineControl("AAS:TextEntry", "AAS TextEntry", PANEL, "DTextEntry")
