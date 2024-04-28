/*
    Addon id: 08ee2233-2d73-4598-a636-76adb93194f5
    Version: v2.1.6 (stable)
*/

local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetFont("AAS:Font:01")
    self:SetSize(AAS.ScrW*0.2, AAS.ScrH*0.029)
    self:SetTextColor(AAS.Colors["white"])
    self.AASTheme = true
    self.activateButton = true 
    self.lerpCircle = self:GetWide()*0.63
    self.lerpColor = self.AASTheme and AAS.Colors["disfulpurple"] or AAS.Colors["selectedBlue"]
end

function PANEL:SetTheme(bool)
    self.AASTheme = bool
end 
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 2ac76e693552f037481c18f13287287a7dd363c0c619b282b58470ebf17cd78a

function PANEL:ChangeStatut(bool)
    self.activateButton = !self.activateButton
    if bool then self:ChangeFilter() end
end 

function PANEL:ChangeFilter()
    AAS.ClientTable["filters"][self.AASTheme and "vip" or "new"] = self.activateButton
end

function PANEL:GetStatut()
    return (self.activateButton or false)
end 

function PANEL:Paint(w, h)
    self.lerpCircle = Lerp(FrameTime()*10, self.lerpCircle, self.activateButton and w*0.49 or w*0.415 )
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 0fd22f1243f0001f31e3d159f2ecd1adb4d5513bd78688f3c34a090a154e38c5

    --local textColor = self.activateButton and (self.AASTheme and AAS.Colors["yellow"] or AAS.Colors["darkBlue"]) or AAS.Colors["grey"]
    draw.SimpleText(self.AASTheme and "DISFULVERSED" or "NEW", "AAS:Font:04", self.AASTheme and w*0.02 or 0, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- bd51170ee3a15f0e8d5e6b12ded39977f6a3f8896bd2c58844ad6ead73ef34eb

    surface.SetDrawColor(
    self.activateButton and
    (self.AASTheme and AAS.Colors["disfulpurple"] or AAS.Colors["selectedBlue"]) or
    AAS.Colors["darkBlue"]
    )
	--surface.SetMaterial(AAS.Materials[self.activateButton and (self.AASTheme and "vipButton" or "newButton") or "inactive"])
    surface.DrawTexturedRect(w*0.41, 2, w*0.15, h*0.9)

    surface.SetDrawColor(AAS.Colors["white"])
	--surface.SetMaterial(AAS.Materials["circle"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 4fe11df2c417444b79aed9fe6656320fa35293cadbcf662f9154077dfcbe3cb8
    local height = AAS.Materials["circle"]:Height()*AAS.ScrH/1080+7
	surface.DrawTexturedRect(self.lerpCircle, h*0.09, (AAS.Materials["circle"]:Width()*AAS.ScrW/1920)-5, height-5)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561198402768796

derma.DefineControl("AAS:Button", "AAS Button", PANEL, "DButton")
