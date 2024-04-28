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
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

function PANEL:Init()
    self.entry = vgui.Create("DTextEntry", self)
    self.entry:Dock(FILL)
    self.entry:DockMargin(ACC2.ScrW*0.0035, 0, 0, 0)
    self.entry:SetText("")
    self.entry:SetDrawLanguageID(false)
    self.entry:SetFont("ACC2:Font:09")
    
    self.entry.ACC2PlaceHolder = ""
    self.entry.ACC2BackgroundColor = ACC2.Colors["white5"]
    self.entry.ACC2Rounded = 0

    self.entry.Paint = function(pnl,w,h)
        pnl:DrawTextEntryText(ACC2.Colors["white100"], ACC2.Colors["white100"], ACC2.Colors["white100"])
    end

    self.entry.OnGetFocus = function()
        if string.Trim(self.entry:GetValue()) == "" or tostring(self.entry:GetValue()) == tostring(self.entry.ACC2PlaceHolder) then
            self.entry:SetValue("")
        end
    end
    
    self.entry.OnLoseFocus = function()
        if string.Trim(self.entry:GetValue()) == "" then
            self.entry:SetText(self.entry.ACC2PlaceHolder)
        end
    end
end

function PANEL:BackGroundColor(color)
    self.entry.ACC2BackgroundColor = color
end

function PANEL:SetPlaceHolder(text)
    self.entry.ACC2PlaceHolder = text
    self.entry:SetText(self.entry.ACC2PlaceHolder)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7

function PANEL:SetNumeric()
    self.entry:SetNumeric(true)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* ded51e6532282dfa00c9343043e6163c5627f86ee51ba1d02ddf9be86bf42ec7 */

function PANEL:SetRounded(number)
    self.entry.ACC2Rounded = (number or 0)
end

function PANEL:GetText()
    return self.entry:GetText()
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */
                                                                                                                                                                                                                                                                                                                                                                                                                                                       /* 76561198931466969 */

function PANEL:SetText(text)
    return self.entry:SetText(text)
end

function PANEL:Paint(w,h) 
    draw.RoundedBox(self.entry.ACC2Rounded, 0, 0, w, h, self.entry.ACC2BackgroundColor)
end

derma.DefineControl("ACC2:TextEntry", "ACC2 TextEntry", PANEL, "DPanel")


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
