/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.175, AAS.ScrH*0.03)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a
    
    local dtexEntry = vgui.Create("DTextEntry", self)
    dtexEntry:SetTextColor(AAS.Colors["white"])
    dtexEntry:SetSize(AAS.ScrW*0.17, AAS.ScrH*0.03)
    dtexEntry:SetPos(AAS.ScrW*0.005, 0)
    dtexEntry:SetDrawLanguageID(false)
    dtexEntry:SetText(AAS.GetSentence("search"))
    dtexEntry:SetFont("AAS:Font:03")
    dtexEntry.AASBaseText = AAS.GetSentence("search")
    dtexEntry.Paint = function(self,w,h) 
        self:DrawTextEntryText(AAS.Colors["black18200"], AAS.Colors["black18200"], AAS.Colors["black18200"])
    end 
    dtexEntry.AllowInput = function(self, stringValue)    
        if #self:GetValue() > 25 then
            return true 
        end 
    end 
    dtexEntry.OnGetFocus = function(self)
        if self:GetValue() == self.AASBaseText then
            self:SetText("") 
        end 
    end 
    dtexEntry.OnLoseFocus = function(self)
        if self:GetValue() == "" then
            self:SetText(self.AASBaseText)
        end
    end 
    
    dtexEntry.GetAutoComplete = function(self, text)
        AAS.ClientTable["filters"]["search"] = text
        
        AAS.UpdateList(AAS.ClientTable["ItemsVisible"], istable(AAS.ClientTable["ItemSelected"]))
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb */
    
    self.AASTextEntry = dtexEntry
    self.AASBaseText = self:GetValue()
end

function PANEL:Paint(w,h) 
    surface.SetDrawColor(AAS.Colors["white"])
    surface.SetMaterial(AAS.Materials["searchbar"])
    surface.DrawTexturedRect(0, 0, w, h)
end

derma.DefineControl("AAS:SearchBar", "AAS SearchBar", PANEL, "DPanel")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768773
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a
